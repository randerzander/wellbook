drop table if exists wellbook.production;

create external table if not exists wellbook.production(
 file_no string,
 perfs string,
 spacing string,
 total_depth string,
 pool string,
 date string,
 days string,
 bbls_oil string,
 runs string,
 bbls_water string,
 mcd_prod string,
 mcf_sold string,
 vent_flare string
)
row format delimited fields terminated by '\t'
lines terminated by '\n'
location '/user/dev/wellbook/production-parsed/';
