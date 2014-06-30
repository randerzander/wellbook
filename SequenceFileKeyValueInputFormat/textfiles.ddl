use wellbook;

add jar ~/SequenceFileKeyValueInputFormat/target/SequenceFileKeyValueInputFormat-0.1.0-SNAPSHOT.jar;
add file ~/pyenv;
add file ${hiveconf:SCRIPT};

drop table if exists textfiles;
create external table if not exists textfiles(filename string, text string)
stored as inputformat 'com.github.randerzander.SequenceFileKeyValueInputFormat'
outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/user/dev/stage/';

insert overwrite table tmp
select transform(filename, text) using '${hiveconf:SCRIPT}' as ${hiveconf:COLUMNS}
from textfiles;

drop table if exists ${hiveconf:TARGET};
create table ${hiveconf:TARGET} like wellbook.tmp;
alter table ${hiveconf:TARGET} set fileformat orc;
insert into table ${hiveconf:TARGET} select * from wellbook.tmp;
drop table wellbook.tmp;
