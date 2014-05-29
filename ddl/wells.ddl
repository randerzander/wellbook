add jar csv-serde/target/csv-serde-1.1.2-0.11.0-all.jar;

drop table if exists wellbook.wells_stg;

create external table if not exists wellbook.wells_stg (
  APINo string,
  File_No string,
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
  Latitude string,
  Longitude string,
  WellType string,
  WellStatus string,
  CTB string,
  WellStatusDate string
)
row format serde 'com.bizo.hive.serde.csv.CSVSerde'
stored as textfile
location '/user/dev/wellbook/wells-stg/'
;

drop table if exists wellbook.wells;
create table if not exists wellbook.wells as select * from wellbook.wells_stg;
