create database if not exists wellbook;
use wellbook;

drop table if exists wellbook.scout_tickets;
create external table if not exists wellbook.scout_tickets(
  file_no int,
  link string
)
stored as orc;
