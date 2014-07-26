use wellbook;

set hive.execution.engine=tez;

add jar /home/dev/udfs/brickhouse/target/brickhouse-0.7.0-SNAPSHOT.jar;
source /home/dev/udfs/brickhouse/src/main/resources/brickhouse.hql;

select collect(distinct lv.mnemonic) as channels
from log_metadata
lateral view explode(
  split(
    regexp_replace(concat_ws(',',
      get_json_object(metadata, '$.curvealiases'),
      get_json_object(metadata, '$.c.null.value')),
    '\\"|\\[|\\]', '')
  , ',')
) lv as mnemonic;
