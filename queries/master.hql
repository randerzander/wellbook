use wellbook;
set hive.execution.engine=tez;

drop table if exists master;
create table if not exists master stored as orc as
select
  w.*,
  p.perfs, p.spacing, p.bbls_oil, p.mcf_gas, p.bbls_water,
  i.eor_bbls, i.eor_mcf, i.salt_water_disposed, i.average_psi,
  a.lease_no, a.date, a.bonus_per_acre, a.acres,
  1/5 * 94.02 * p.bbls_oil + a.bonus_per_acre * a.acres as oil_cost,
  1/5 * 3.35 * p.mcf_gas + a.bonus_per_acre * a.acres as gas_cost,
  d.averages
from (
  select
    file_no,
    perfs,
    spacing,
    coalesce(sum(bbls_oil),0) as bbls_oil,
    coalesce(sum(mcf_prod),0) as mcf_gas,
    coalesce(sum(bbls_water),0) as bbls_water
  from production
  group by file_no, perfs, spacing
) p
left outer join (
  select
    file_no,
    coalesce(sum(eor_bbls_injected),0) as eor_bbls,
    coalesce(sum(eor_mcf_injected),0) as eor_mcf,
    coalesce(sum(bbls_salt_water_disposed),0) as salt_water_disposed,
    coalesce(avg(average_psi),0) as average_psi
  from injections
  group by file_no
) i on p.file_no = i.file_no
left outer join total_depth_environments d
  on p.file_no = d.file_no
join wells w on
  p.file_no = w.file_no
left outer join (
  select auctions.* from auctions
  join (select lease_no, township, section, range, description, max(unix_timestamp(date, 'MM-yyyy')) from auctions
        group by lease_no, township, section, range, description) b
  on auctions.lease_no = b.lease_no
) a on (split(lower(w.township), ' ')[0] = lower(a.township)
        and split(lower(w.range), ' ')[0] = lower(a.range)
        and lower(w.section) = lower(a.section))
        --and lower(w.qq) = lower(a.description))
;
