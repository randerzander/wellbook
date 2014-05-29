drop table if exists wellbook.scout_tickets;

create external table if not exists wellbook.scout_tickets(
 api_no string,
 url string
)
row format delimited fields terminated by '\t'
lines terminated by '\n'
location '/user/dev/wellbook/scout-tickets-parsed/';
