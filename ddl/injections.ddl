create database if not exists wellbook;
use wellbook;

drop table if exists wellbook.injections;
create external table if not exists wellbook.injections(
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
