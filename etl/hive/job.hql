use wellbook;

set hive.execution.engine=tez;

add jar /home/dev/wellbook/SequenceFileKeyValueInputFormat/target/SequenceFileKeyValueInputFormat-0.1.0-SNAPSHOT.jar;
add file /home/dev/wellbook/pyenv;
add file ${hiveconf:SCRIPT};

drop table if exists stage;
create external table stage(filename string, text string)
stored as inputformat 'com.github.randerzander.SequenceFileKeyValueInputFormat'
outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '${hiveconf:SOURCE}';

create table if not exists ${hiveconf:TARGET}_errors (error string) stored as orc;

from (
  select transform(filename, text) using '${hiveconf:SCRIPT}'
    as error,${hiveconf:COLUMNS}
  from stage
) source
insert overwrite table ${hiveconf:TARGET} select ${hiveconf:COLUMNS} where error = ''
insert overwrite table ${hiveconf:TARGET}_errors select error where error != '';
