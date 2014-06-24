use wellbook;

drop table if exists wellbook.tmp;
create external table if not exists wellbook.tmp(
  file_name string,
  file_no int,
  log_name string,
  reading string
)
row format delimited fields terminated by '\t'
lines terminated by '\n'
location '/user/dev/wellbook/log-readings/';

drop table if exists wellbook.log_readings;
create table wellbook.log_readings like wellbook.tmp;
alter table log_readings set fileformat orc;
insert into table wellbook.log_readings select * from wellbook.tmp;
drop table wellbook.tmp;
