create database if not exists wellbook;
use wellbook;

add jar /home/dev/wellbook/serdes/csv-serde/target/csv-serde-1.1.2-0.11.0-all.jar;

drop table if exists wellbook.tmp;
create external table if not exists wellbook.tmp(
  API string,
  File_No int,
  OriginalOperator string,
  OriginalWellName string,
  CurrentOperator string,
  CurrentWellName string,
  FieldName string,
  CountyName string,
  Township string,
  Range string,
  Section string,
  QQ string,
  Footages string,
  Hole_Type string,
  LATITUDE double,
  LONGITUDE double,
  FirstSpudDate string,
  MeasuredTD double,
  KBElev double,
  DFElev double,
  GRElev double,
  GLElev double,
  TY_BCHR double,
  TY_BCHN double,
  K_P double,
  K_PJRS double,
  K_PES double,
  K_NB double,
  K_GH double,
  K_M double,
  K_N double,
  K_IK double,
  J_S double,
  J_R double,
  T_S double,
  PM_MK double,
  PM_OP double,
  PM_EBA double,
  PM_BC double,
  PN_T double,
  M_EBS double,
  M_BS double,
  M_KL double,
  M_MDUN double,
  M_MD double,
  M_MDR double,
  M_MDLS double,
  M_MDFA double,
  M_MDFY double,
  M_MDSA double,
  M_MDTI double,
  M_MDLP double,
  MD_B double,
  D_DV double,
  D_TF double,
  D_BB double,
  D_DP double,
  D_SR double,
  D_DB double,
  D_PE double,
  D_W double,
  S_I double,
  S_CL double,
  O_G double,
  O_ST double,
  O_RR double,
  O_WR double,
  O_WI double,
  O_BI double,
  CO_D double,
  PC double,
  LogsOnFile int
)
row format serde 'com.bizo.hive.serde.csv.CSVSerde'
stored as textfile
location '/user/dev/wellbook/formations_raw/';

drop table if exists wellbook.formations;
create table wellbook.formations like wellbook.tmp;
alter table formations set fileformat orc;
insert into table wellbook.formations select * from wellbook.tmp;
drop table wellbook.tmp;
