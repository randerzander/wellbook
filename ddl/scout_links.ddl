create database if not exists wellbook;
use wellbook;

drop table if exists wellbook.scout_links;
create external table if not exists wellbook.scout_links(
  file_no int,
  link string
)
stored as orc;
