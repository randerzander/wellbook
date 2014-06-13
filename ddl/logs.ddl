use wellbook;

drop table if exists wellbook.tmp;
create external table if not exists wellbook.tmp(
  file_no string,
  fields string,
  reading string
)
row format delimited fields terminated by '\t'
lines terminated by '\n'
location '/user/dev/wellbook/las-parsed/';

drop table if exists wellbook.logs;
create table wellbook.logs like wellbook.tmp;
alter table logs set fileformat orc;
insert into table wellbook.logs select * from wellbook.tmp;
drop table wellbook.tmp;
