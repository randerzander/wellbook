use wellbook;

add jar /home/dev/udfs/UDFFastDTW/target/UDFFastDTW-0.1.0-SNAPSHOT.jar;
create temporary function fastdtw as 'com.github.randerzander.UDFFastDTW.UDFFastDTW';

create table fastdtw_input stored as orc as
select 
  a.step_type, a.mnemonic as source_mnemonic,
  b.mnemonic as test_mnemonic,
  a.uom,
  a.x as x1, a.y as y1,
  b.x as x2, b.y as y2
from (
    select step_type, mnemonic, uom, collect_list(step) as x, collect_list(reading) as y
    from log_readings
    where file_no < 20000
    group by step_type, mnemonic, uom) a
join (
    select step_type, mnemonic, uom, collect_list(step) as x, collect_list(reading) as y
    from log_readings
    where file_no < 20000
    group by step_type, mnemonic, uom) b
  on a.step_type = b.step_type and a.uom = b.uom
where a.mnemonic != b.mnemonic
;

drop table if exists dtw_results;
create table dtw_results stored as orc as
select source_mnemonic, test_mnemonic, fastdtw(x1, y1, x2, y2, 10) from fastdtw_input;
