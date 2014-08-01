use wellbook;
set hive.execution.engine=tez;

drop table if exists master;
create table if not exists master stored as orc as
select
  w.*,
  p.perfs, p.spacing, p.pool, p.bbls_oil, p.mcf_gas, p.bbls_water,
  i.eor_bbls, i.eor_mcf, i.salt_water_disposed, i.average_psi,
  a.lease_no, a.date, a.bonus_per_acre, a.acres,
  d.averages
from (
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
left outer join total_depth_environments d
  on p.file_no = d.file_no
join wells w on
  p.file_no = w.file_no
left outer join (
  select auctions.* from auctions
  join (select lease_no, max(unix_timestamp(date, 'MM-yyyy')) from auctions group by lease_no) b
    on auctions.lease_no = b.lease_no
) a on (split(w.township, ' ')[0] = a.township and split(w.range, ' ')[0] = a.range and w.section = a.section)
;
