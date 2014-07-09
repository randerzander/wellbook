create database if not exists wellbook;
use wellbook;

drop table if exists wellbook.tmp;
create external table if not exists wellbook.tmp(
  agency_cd string,
  site_no string,
  station_nm string,
  site_tp_cd string,
  dec_lat_va float,
  dec_long_va float,
  coord_acy_cd float,
  dec_coord_datum_cd float,
  alt_va float,
  alt_acy_va float,
  alt_datum_cd string,
  huc_cd string
)
row format delimited fields terminated by '\t'
lines terminated by '\n'
location '/user/dev/wellbook/water-sites_raw/';

drop table if exists wellbook.water_sites;
create table wellbook.water_sites like wellbook.tmp;
alter table water_sites set fileformat orc;
insert into table wellbook.water_sites select * from wellbook.tmp;
drop table wellbook.tmp;
