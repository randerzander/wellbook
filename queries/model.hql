use wellbook;
set hive.execution.engine=tez;

select concat_ws('_',
  coalesce(cast(bbls_oil as string), ''),
  coalesce(cast(mcf_gas as string), ''),
  coalesce(cast(bbls_water as string), ''),
  coalesce(cast(td as string), ''),
  coalesce(footages, ''),
  coalesce(fieldname, ''),
  coalesce(producedpools, ''),
  coalesce(wellbore, ''),
  coalesce(welltype, ''),
  coalesce(ctb, ''),
  coalesce(perfs, ''),
  coalesce(spacing, ''),
  coalesce(pool,  ''),
  coalesce(cast(eor_bbls as string), ''),
  coalesce(cast(eor_mcf as string), ''),
  coalesce(cast(salt_water_disposed as string), ''),
  coalesce(cast(average_psi as string), '')
)
from master;
