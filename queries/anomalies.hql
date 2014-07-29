use wellbook;

add file /home/dev/pyenv;
add file /home/dev/wellbook/etl/hive/anomalies.py;

drop table if exists anomalies;
create table anomalies stored as orc as
select
  transform(file_no, statistics, reading) using 'anomalies.py'
  as file_no, anomalous_readings
from (
  select r.file_no, r.reading, coalesce(cast(get_json_object(m.metadata, '$.w.null.value') as double), '-99.25') as nullval
  from log_readings r
  join wells w
    on w.file_no = r.file_no
  join log_metadata m
    on r.filename = m.filename
  cluster by r.file_no
) i
;
