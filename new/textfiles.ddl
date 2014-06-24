use wellbook;

add jar /home/dev/SequenceFileKeyValueInputFormat/target/SequenceFileKeyValueInputFormat-0.1.0-SNAPSHOT.jar;
add file ${hiveconf:SCRIPT};

!echo ${hiveconf:SCRIPT};
!echo ${hiveconf:SOURCE};
!echo ${hiveconf:COLUMNS};

drop table if exists textfiles;
create external table if not exists textfiles(filename string, text string)
stored as inputformat 'com.github.randerzander.SequenceFileKeyValueInputFormat'
outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/user/dev/${hiveconf:SOURCE}';

insert overwrite table log_readings
select transform(filename, text) using '${hiveconf:SCRIPT}' as ${hiveconf:COLUMNS}
from textfiles;
