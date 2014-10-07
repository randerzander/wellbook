create database if not exists wellbook;
use wellbook;

add jar /home/dev/wellbook/serdes/csv-serde/target/csv-serde-1.1.2-0.11.0-all.jar;

drop table if exists wellbook.tmp;
create external table if not exists wellbook.tmp(
  code string,
  formation string
)
row format serde 'com.bizo.hive.serde.csv.CSVSerde'
stored as textfile
location '/user/dev/wellbook/formations_key_raw/';

drop table if exists wellbook.formations_key;
create table wellbook.formations_key like wellbook.tmp;
alter table formations_key set fileformat orc;
insert into table wellbook.formations_key select * from wellbook.tmp;
drop table wellbook.tmp;
