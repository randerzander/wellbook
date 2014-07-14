use wellbook;

--add jar /home/dev/udfs/brickhouse/target/brickhouse-0.7.0-SNAPSHOT.jar;
--source /home/dev/udfs/brickhouse/src/main/resources/brickhouse.hql;
set hive.execution.engine=tez;
add file /home/dev/wellbook/etl/hive/merge_depths.py;
add file channels.txt;

insert overwrite table total_depth_environments
select transform(i.file_no, i.reading) using 'merge_depths.py' as file_no, averages
from (
  select r.file_no, r.reading
  from log_readings r
  join wells w on w.file_no = r.file_no
  where 
    coalesce(
      cast(get_json_object(r.reading, '$.dept') as double),
      cast(get_json_object(r.reading, '$.depth') as double),
      cast(get_json_object(r.reading, '$.md') as double)
    ) <= cast(w.td as double) + 500
    or
    coalesce(
      cast(get_json_object(r.reading, '$.dept') as double),
      cast(get_json_object(r.reading, '$.depth') as double),
      cast(get_json_object(r.reading, '$.md') as double)
    ) <= cast(w.td as double) - 500
  order by r.file_no
) i
;

