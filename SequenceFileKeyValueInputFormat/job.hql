use wellbook;

add jar /home/dev/SequenceFileKeyValueInputFormat/target/SequenceFileKeyValueInputFormat-0.1.0-SNAPSHOT.jar;
add file /home/dev/pyenv;
add file ${hiveconf:SCRIPT};

drop table if exists stage;
create external table stage(filename string, text string)
stored as inputformat 'com.github.randerzander.SequenceFileKeyValueInputFormat'
outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/user/dev/stage/';

insert overwrite table tmp
select transform(filename, text) using '${hiveconf:SCRIPT}'
  as ${hiveconf:COLUMNS}
from stage;

drop table if exists ${hiveconf:TARGET};
create table ${hiveconf:TARGET} like wellbook.tmp;
alter table ${hiveconf:TARGET} set fileformat orc;
insert into table ${hiveconf:TARGET} select * from wellbook.tmp;
drop table wellbook.tmp;
