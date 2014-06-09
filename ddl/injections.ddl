drop table if exists wellbook.tmp;
create external table if not exists wellbook.tmp(
  file_no int,
  uic_number string,
  pool string,
  date string,
  eor_bbls_injected double,
  eor_mcf_injected double,
  bbls_salt_water_disposed double,
  average_psi double
)
row format delimited fields terminated by '\t'
lines terminated by '\n'
location '/user/dev/wellbook/injections-parsed/';

drop table if exists wellbook.injections;
create table if not exists wellbook.injections(
  file_no int,
  uic_number string,
  pool string,
  date string,
  eor_bbls_injected double,
  eor_mcf_injected double,
  bbls_salt_water_disposed double,
  average_psi double
)
stored as orc;

insert into table wellbook.injections select * from wellbook.tmp;
drop table wellbook.tmp;
