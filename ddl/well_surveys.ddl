create database if not exists wellbook;
use wellbook;

drop table if exists wellbook.well_surveys;
create external table if not exists wellbook.well_surveys(
 api_no string,
 file_no int,
 leg string,
 md double,
 inc double,
 azimuth double,
 tvd double,
 ft_ns double,
 ns string,
 ft_ew double,
 ew string,
 latitude double,
 longitude double
)
stored as orc;
