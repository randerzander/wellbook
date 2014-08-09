use wellbook;

set hive.execution.engine=tez;

add jar /home/dev/udfs/brickhouse/target/brickhouse-0.7.0-SNAPSHOT.jar;
source /home/dev/udfs/brickhouse/src/main/resources/brickhouse.hql;

select a.mnemonic, get_json_object(b.metadata, '$.c.' + a.mnemonic + '.description')
from (
  select lv.mnemonic
  from log_metadata
  lateral view explode(
    split(
      regexp_replace(concat_ws(',',
        get_json_object(metadata, '$.curvealiases'),
        get_json_object(metadata, '$.c.null.value')),
      '\\"|\\[|\\]', '')
    , ',')
  ) lv as mnemonic
) a
join log_metadata b on get_json_object(b.metadata, '$.c.' + a.mnemonic) = a.mnemonic
;
