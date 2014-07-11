set hive.execution.engine=tez;
use wellbook;


select * from wells w
join auctions a on
  split(w.township, ' ')[0] = a.township;

select * from wells w
join auctions a on
  split(w.section, ' ')[0] = a.section;

select * from wells w
join auctions a on
  w.range = a.range;

select w.file_no, oil, gas, a.acres * a.bonus_per_acre * .6 as price
from wells w
join auctions a
  on split(w.township, ' ')[0] = a.township
    and split(w.range, ' ')[0] = a.range
    and w.section = a.section
join (select file_no, sum(bbls_oil) as oil, sum(mcf_prod) as gas from production group by file_no) p
  on p.file_no = w.file_no
;
