--list of all observed mnemonics and their description
select distinct lv.mnemonic
from log_metadata
lateral view explode(
  split(
    regexp_replace(
      get_json_object(metadata, '$.curvealiases'),
    '"|\\[|\\]', '')
  , ',')
) lv as mnemonic;
