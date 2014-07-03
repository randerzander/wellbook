create database if not exists wellbook;
use wellbook;

drop table if exists wellbook.log_readings;
create external table if not exists wellbook.log_readings(
  filename string,
  file_no int,
  log_name string,
  reading string
)
stored as orc;
