use wellbook;

add file /home/dev/wellbook/etl/hive/merge_depths.py;
add file channels.txt;

set hive.execution.engine=tez;

drop table if exists total_depth_environments;
create table total_depth_environments stored as orc as
select 
  transform(file_no, nullval, reading) using 'merge_depths.py'
    as file_no, averages
from (
  select r.file_no, r.reading, coalesce(get_json_object(m.metadata, '$.c.null.value'), ' ') as nullval
  from log_readings r
  join wells w
    on w.file_no = r.file_no
  join log_metadata m
    on r.filename = m.filename
  where 
    --coalesce(
    --  cast(get_json_object(r.reading, '$.dept') as double),
    --  cast(get_json_object(r.reading, '$.depth') as double),
    --  cast(get_json_object(r.reading, '$.md') as double)
    --) <= cast(w.td as double) + 500
    --or
    coalesce(
      cast(get_json_object(r.reading, '$.dept') as double),
      cast(get_json_object(r.reading, '$.depth') as double),
      cast(get_json_object(r.reading, '$.md') as double)
    ) <= cast(w.td as double) - 1000
  cluster by r.file_no
) i
;
