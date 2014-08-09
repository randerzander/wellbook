use wellbook;

--set hive.execution.engine=tez;

add jar /home/dev/udfs/brickhouse/target/brickhouse-0.7.0-SNAPSHOT.jar;
source /home/dev/udfs/brickhouse/src/main/resources/brickhouse.hql;

drop table if exists curves_3;
create table if not exists curves_3 stored as orc as
select 
  file_no, 
  mnemonic, 
  step_type,
  uom,
  collect(concat_ws('|', cast(step as string), cast(reading as string))) as curve
from log_readings
where file_no >= 15000 and file_no < 20000
group by file_no, mnemonic, step_type, uom
;
