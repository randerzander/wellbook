drop table if exists wellbook.injections;

create external table if not exists wellbook.injections(
  file_no string,
  uic_number string,
  pool string,
  date string,
  eor_bbls_injected string,
  eor_mcf_injected string,
  bbls_salt_water_disposed string,
  average_psi string
)
row format delimited fields terminated by '\t'
lines terminated by '\n'
location '/user/dev/wellbook/injections-parsed/';
