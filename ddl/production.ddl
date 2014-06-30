create database if not exists wellbook;
use wellbook;

drop table if exists wellbook.tmp;
create external table if not exists wellbook.tmp(
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
row format delimited fields terminated by '\t'
lines terminated by '\n';
