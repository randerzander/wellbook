set hive.execution.engine=tez;
use wellbook;

drop table if exists log_readings_stats;
create table log_readings_stats stored as orc as
select
  file_no,
  mnemonic,
  avg(reading) as avg,
  stddev_pop(reading) as stddev,
  percentile(cast(reading as int), 0.5) as median
from log_readings
group by file_no, mnemonic;

drop table if exists log_readings_qc;
create table log_readings_qc stored as orc as
select
  a.*,
  b.avg,
  b.stddev,
  b.median,
  (a.reading > b.avg + 3*b.stddev) as qc_max,
  (a.reading < b.avg - 3*b.stddev) as qc_min
from log_readings_tvd a
join log_readings_stats b on (a.file_no = b.file_no and a.mnemonic = b.mnemonic)
;
