set hive.execution.engine=tez;
use wellbook;

add jar /home/dev/wellbook/udfs/CurveUDFs/target/CurveUDFs-0.1.0-SNAPSHOT.jar;
create temporary function interpolate as 'com.github.randerzander.CurveUDFs.UDFInterpolate';

select 
  log_readings.*,
  a.coeff[0] + a.coeff[1] * log_readings.step + a.coeff[2] * pow(log_readings.step, 2.0) + a.coeff[3] * pow(log_readings.step, 3.0) as tvd
from log_readings
left outer join (
  select file_no, interpolate(collect_list(md), collect_list(tvd), "spline") as coeff
  from well_surveys group by file_no
) a on log_readings.file_no = a.file_no
