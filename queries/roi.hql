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

select 
  w.file_no,
  w.currentoperator,
  w.fieldname,
  oil,
  gas,
  a.acres * a.bonus_per_acre * 0.6 as price,
  oil / (a.acres*a.bonus_per_acre*0.6) as oil_roi,
  gas / (a.acres*a.bonus_per_acre*0.6) as gas_roi
from wells w
join auctions a
  on split(w.township, ' ')[0] = a.township and split(w.range, ' ')[0] = a.range and w.section = a.section
join (select file_no, sum(bbls_oil) as oil, sum(mcf_prod) as gas from production group by file_no) p
  on p.file_no = w.file_no
left outer join auctions a2 on
  on (split(w.township, ' ')[0] = a.township and split(w.range, ' ')[0] = a.range and w.section = a.section
      and (a.date < a2.date or a.date = a2.date and a
     )
--  split(w.township, ' ')[0] = a2.township and (p1.date < p2.date OR p1.date = p2.date AND p1.id < p2.id))
--where p2.id IS NULL;
;
