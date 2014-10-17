set hive.execution.engine=tez;
use wellbook;

add jar /home/dev/wellbook/udfs/CurveUDFs/target/CurveUDFs-0.1.0-SNAPSHOT.jar;
create temporary function fastdtw as 'com.github.randerzander.CurveUDFs.UDFFastDTW';

drop table if exists mnemonic_buckets;
create table mnemonic_buckets stored as orc as
select 
  collect_set(concat_ws('|', a.mnemonic, b.mnemonic, cast(fastdtw(a.x, a.y, b.x, b.y, 10) as string))) as mnemonics
from (
    select file_no, step_type, mnemonic, uom, collect_list(step) as x, collect_list(reading) as y
    from log_readings
    group by file_no, step_type, mnemonic, uom) a
join (
    select file_no, step_type, mnemonic, uom, collect_list(step) as x, collect_list(reading) as y
    from log_readings
    group by file_no, step_type, mnemonic, uom) b
  on a.step_type = b.step_type and a.uom = b.uom and a.file_no = b.file_no
where a.mnemonic != b.mnemonic and fastdtw(a.x, a.y, b.x, b.y, 10) < 2000
;
