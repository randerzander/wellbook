add jar brickhouse/target/brickhouse-0.7.0-SNAPSHOT.jar;
source brickhouse/src/main/resources/brickhouse.hql;
add file wellbook/combine.py;

set hive.execution.engine=mr;

select
  transform(collect(concat_ws('|', file_no, fields, reading)), 'step')
    using 'combine.py' as file_no, fields, reading
from (
  select file_no, fields, reading
  from wellbook.logs
  order by
    coalesce(get_json_object('$.dept', reading), get_json_object('$.depth', reading)) asc
  ) inner
group by file_no
;
