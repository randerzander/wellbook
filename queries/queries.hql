use wellbook;

add jar /home/dev/udfs/brickhouse/target/brickhouse-0.7.0-SNAPSHOT.jar;
source /home/dev/udfs/brickhouse/src/main/resources/brickhouse.hql;

--Get number of logfiles per well
select file_no, count(*) from log_metadata group by file_no;

--Get deepest readings per well
select file_no, max(cast(coalesce(
  get_json_object(reading, '$.dept'),
  get_json_object(reading, '$.depth'),
  get_json_object(reading, '$.md')
) as double)) from log_readings
group by file_no;

--Get # reaindgs per well
select file_no, count(*) from log_readings group by file_no;

--Get average number of readings per well
select avg(count) from(
  select file_no, count(*) as count from log_readings group by file_no
) A;

--Get wells with greater than average number of readings
select file_no, count, currentoperator from (
  select file_no, count(*) as count from log_readings group by file_no
) A
join wells on A.file_no = wells.file_no
where count > 48000;

--north dakota data lake query
--merges master well-header data, production data, and all well-logs per well
select * from wells
join (
  select 
    wells.file_no,
    collect(inner.reading) as readings
  from (
    select
      log_readings.file_no,
      log_readings.reading,
      coalesce(
        get_json_object(log_readings.reading, '$.dept'),
        get_json_object(log_readings.reading, '$.depth'),
        get_json_object(log_readings.reading, '$.md')
      ) as depth
    from logs
    order by coalesce(
      get_json_object(log_readings.reading, '$.dept'),
      get_json_object(log_readings.reading, '$.depth'),
      get_json_object(log_readings.reading, '$.md')) asc
  ) inner
  join wells on inner.file_no = wells.file_no
  group by wells.file_no
) outer on wells.file_no = outer.file_no
join (
  select
    production.file_no,
    collect(concat_ws('|', production.bbls_oil, production.date)) as production
  from production
  group by production.file_no
) production on wells.file_no = production.file_no;

--query for readings within arbitrary depth range
select * from log_readings
  where
    cast(coalesce(get_json_object(reading, '$.dept'), get_json_object(reading, '$.depth'), get_json_object(reading, '$.md')) as double) > 100000
;

  select log_metadata.file_no, lv.mnemonic, count(*)
  from log_metadata
  lateral view explode(
    split(
      regexp_replace(
        get_json_object(metadata, '$.curvealiases'),
      '"|\\[|\\]', '')
    , ',')
  ) lv as mnemonic
  group by log_metadata.file_no, lv.mnemonic;
  

--yet to come: merge/order/interpolate/step all readings into standard units
