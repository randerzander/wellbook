use wellbook;

drop table if exists wellbook.tmp;
create external table if not exists wellbook.tmp(
  file_name string,
  file_no int,
  log_name string,
  metadata string
)
row format delimited fields terminated by '\t'
lines terminated by '\n'
location '/user/dev/wellbook/log-metadata/';

drop table if exists wellbook.log_metadata;
create table wellbook.log_metadata like wellbook.tmp;
alter table log_metadata set fileformat orc;
insert into table wellbook.log_metadata select * from wellbook.tmp;
drop table wellbook.tmp;
