create database if not exists wellbook;
use wellbook;

drop table if exists wellbook.log_readings_tmp;
create external table if not exists wellbook.log_readings_tmp(
  filename string,
  file_no int,
  log_name string,
  reading string
)
stored as textfile;

create external table if not exists wellbook.log_readings like wellbook.log_readings_tmp;
alter table log_readings set fileformat orc;
