create database if not exists wellbook;
use wellbook;

drop table if exists wellbook.log_metadata;
create external table if not exists wellbook.log_metadata(
  filename string,
  file_no int,
  log_name string,
  block string,
  mnemonic string,
  uom string,
  description string
)
stored as orc;
