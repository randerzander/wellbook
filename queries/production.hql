use wellbook;
set hive.execution.engine=tez;

create table prod_inj_wells as
select transform(
  file_no,
  perfs,
  spacing,
  total_depth,
  pool,
  bbls_oil,
  bbls_water,
  mcf_gas,
  eor_bbls,
  eor_mcf,
  salt_water_disposed,
  average_psi
  collect(
) using 



select * from (
  select
    file_no,
    perfs,
    spacing,
    total_depth,
    pool,
    sum(bbls_oil) as bbls_oil,
    sum(mcf_prod) as mcf_gas,
    sum(bbls_water) as bbls_water
  from production
  group by file_no, perfs, spacing, total_depth, pool
) p
left outer join (
  select
    file_no,
    sum(eor_bbls_injected) as eor_bbls,
    sum(eor_mcf_injected) as eor_mcf,
    sum(bbls_salt_water_disposed) as salt_water_disposed,
    avg(average_psi) as average_psi
  from injections
  group by file_no
) i on p.file_no = i.file_no
join wells w on
  p.file_no = w.file_no
join 
;


select * from log_readings where 
