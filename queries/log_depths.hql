set hive.execution.engine=tez;
use wellbook;

add jar /home/dev/wellbook/udfs/CurveUDFs/target/CurveUDFs-0.1.0-SNAPSHOT.jar;
create temporary function interpolate as 'com.github.randerzander.CurveUDFs.UDFInterpolate';

create table tvd_readings stored as orc as
select 
  log_readings.*,
  a.coeff[0] + a.coeff[1] * log_readings.step + a.coeff[2] * pow(log_readings.step, 2.0) + a.coeff[3] * pow(log_readings.step, 3.0) as tvd
from log_readings
left outer join (
  select file_no, interpolate(mds, tvds, "spline") as coeff from (
    select file_no, collect_list(md) as mds, collect_list(tvd) as tvds
    from well_surveys
    where size(collect_list(md)) > 2
    group by file_no
  ) inner
) a on log_readings.file_no = a.file_no
;
