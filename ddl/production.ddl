create database if not exists wellbook;
use wellbook;

drop table if exists wellbook.production;
create external table if not exists wellbook.production(
 file_no int,
 perfs string,
 spacing string,
 total_depth double,
 pool string,
 date string,
 days int,
 bbls_oil double,
 runs double,
 bbls_water double,
 mcd_prod double,
 mcf_sold double,
 vent_flare double
)
stored as orc;
