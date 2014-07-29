use wellbook;

add file /home/dev/pyenv;
add file /home/dev/wellbook/etl/hive/curve_statistics.py;
--set hive.execution.engine=tez;

drop table if exists curve_statistics;
create table curve_statistics stored as orc as
select 
  transform(file_no, nullval, reading) using 'curve_statistics.py'
  as file_no, statistics
from (
  select r.file_no, r.reading, coalesce(cast(get_json_object(m.metadata, '$.w.null.value') as double), '-999.25') as nullval
  from log_readings r
  join wells w
    on w.file_no = r.file_no
  join log_metadata m
    on r.filename = m.filename
  cluster by r.file_no
) i
;
