create database if not exists wellbook;
use wellbook;

add jar /home/dev/wellbook/serdes/csv-serde/target/csv-serde-1.1.2-0.11.0-all.jar;

drop table if exists wellbook.tmp;
create external table if not exists wellbook.tmp (
  APINo string,
  File_No int,
  CurrentOperator string,
  CurrentWellName string,
  LeaseName string,
  LeaseNumber string,
  OriginalOperator string,
  OriginalWellName string,
  SpudDate string,
  TD string,
  CountyName string,
  Township string,
  Range string,
  Section string,
  QQ string,
  Footages string,
  FieldName string,
  ProducedPools string,
  OilWaterGasCums string,
  IPTDateOilWaterGas string,
  Wellbore string,
  Latitude double,
  Longitude double,
  WellType string,
  WellStatus string,
  CTB string,
  WellStatusDate string
)
row format serde 'com.bizo.hive.serde.csv.CSVSerde'
stored as textfile
location '/user/dev/wellbook/wells_raw/';

drop table if exists wellbook.wells;
create table wellbook.wells like wellbook.tmp;
alter table wells set fileformat orc;
insert into table wellbook.wells select * from wellbook.tmp;
drop table wellbook.tmp;
