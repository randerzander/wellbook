use wellbook;

add jar /home/dev/udfs/brickhouse/target/brickhouse-0.7.0-SNAPSHOT.jar;
source /home/dev/udfs/brickhouse/src/main/resources/brickhouse.hql;
set hive.execution.engine=tez;

select collect(distinct lv.mnemonic) as channels
from log_metadata
lateral view explode(
  split(
    regexp_replace(
      get_json_object(metadata, '$.curvealiases'),
    '"|\\[|\\]', '')
  , ',')
) lv as mnemonic;
