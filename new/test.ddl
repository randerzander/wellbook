use wellbook;

add jar /home/dev/SequenceFileKeyValueInputFormat/target/SequenceFileKeyValueInputFormat-0.1.0-SNAPSHOT.jar;
add file /home/dev/devenv;
--add file /home/dev/devenv.zip;
--add archive /home/dev/devenv.zip;
--add archive /home/dev/devenv.tar.gz;
--add archive /home/dev/devenv.jar;
--add archive /home/dev/devenv.tar;
add file /home/dev/wellbook/new/production.py;
add file /home/dev/wellbook/new/test.py;

drop table if exists test;
create external table test (filename string, text string)
stored as inputformat 'com.github.randerzander.SequenceFileKeyValueInputFormat'
outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
location '/user/dev/stage/';

select transform(filename, text) using 'production.py'
--select transform('') using 'test.py'
  as file_no,perfs,spacing,total_depth,pool,date,days,bbls_oil,runs,bbls_water,mcf_prod,mcf_sold,vent_flare
from test;
