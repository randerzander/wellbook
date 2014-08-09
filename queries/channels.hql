use wellbook;

set hive.execution.engine=tez;

--add jar /home/dev/udfs/brickhouse/target/brickhouse-0.7.0-SNAPSHOT.jar;
--source /home/dev/udfs/brickhouse/src/main/resources/brickhouse.hql;

select regexp_replace(lower(mnemonic), "\\d+|\\[|\\]", "") as mnemonic, count(*) as count
--select lower(mnemonic) as mnemonic, lower(description) as description, count(*) as count
from log_metadata where lower(block) = 'c'
--group by lower(mnemonic), lower(description);
group by regexp_replace(lower(mnemonic), "\\d+|\\[|\\]", "");
