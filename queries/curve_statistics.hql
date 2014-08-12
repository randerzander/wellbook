use wellbook;

set hive.execution.engine=tez;

drop table if exists curve_statistics;
create table curve_statistics stored as orc as
select
  i.mnemonic, i.uom, i.average, i.median, i.stddev, i.variance, i.max, i.min, i.range, i.histogram,
  meta.description
from (
  select
    filename,
    mnemonic,
    uom,
    avg(reading) as average,
    percentile(cast(reading as bigint), 0.5) as median,
    stddev(reading) as stddev,
    variance(reading) as variance,
    max(reading) as max,
    min(reading) as min,
    max(reading) - min(reading) as range,
    histogram_numeric(reading, 10) as histogram
  from log_readings
  group by filename, mnemonic, uom
) i
left outer join log_metadata meta on
  i.filename = meta.filename and
  i.mnemonic = meta.mnemonic and
  i.uom = meta.uom
  and lower(meta.block) =  'c'
;
