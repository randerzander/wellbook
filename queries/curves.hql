select * from wells
join log_readings on
  
select collect(distinct lv.mnemonic) as channels
from log_metadata
lateral view explode(
  split(
    regexp_replace(
      get_json_object(metadata, '$.curvealiases'),
    '"|\\[|\\]', '')
  , ',')
) lv as mnemonic;
