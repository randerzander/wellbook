use wellbook;

drop table if exists wellbook.auctions;
create external table if not exists wellbook.auctions(
  date string,
  lease_no string,
  township string,
  range string,
  section string,
  description string,
  bidder string,
  acres double,
  bonus_per_acre double
)
stored as orc;
