drop table if exists wellbook.logs;

create external table if not exists wellbook.logs(
  file_no string,
  fields string,
  reading string
)
row format delimited fields terminated by '\t'
lines terminated by '\n'
location '/user/dev/wellbook/las-parsed/';
