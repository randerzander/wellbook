use wellbook;
--set hive.execution.engine=tez;

add file /home/dev/pyenv;
add file wellbook/etl/hive/model.py;

drop table if exists predictions;
create table if not exists predictions stored as orc as
select transform(
    file_no,
    bbls_oil,
    mcf_gas,
    bbls_water,
    footages,
    regexp_replace(fieldname, ' ', '_'),
    regexp_replace(producedpools, ' ', '_'),
    wellbore,
    welltype,
    ctb,
    perfs,
    spacing
) using 'model.py' as file_no, oil, yhat_oil, gas, yhat_gas, water, yhat_water
from
wellbook.master;
