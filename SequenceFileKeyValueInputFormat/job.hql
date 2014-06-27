use wellbook;

add jar /home/dev/SequenceFileKeyValueInputFormat/target/SequenceFileKeyValueInputFormat-0.1.0-SNAPSHOT.jar;
add file /home/dev/pyenv;
add file ${hiveconf:SCRIPT};

drop table if exists stage;
create external table stage(filename string, text string)
stored as inputformat 'com.github.randerzander.SequenceFileKeyValueInputFormat'
outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/user/dev/stage/';

insert overwrite table ${hiveconf:TARGET}
select transform(filename, text) using '${hiveconf:SCRIPT}'
  as ${hiveconf:COLUMNS}
from stage;
