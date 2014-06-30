echo Creating wells table
hive -f wellbook/ddl/wells.ddl

echo Converting production data to SequenceFiles
mahout seqdirectory -i wellbook/production_raw -o stage -prefix __key -ow
echo Creating production table
hive -f ~/wellbook/ddl/production.ddl
cd wellbook/SequenceFileKeyValueInputFormat
echo Populating production table
hive -f job.hql \
	-hiveconf SCRIPT=production.py \
	-hiveconf COLUMNS=file_no,perfs,spacing,total_depth,pool,date,days,bbls_oil,runs,bbls_water,mcd_prod,mcf_sold,vent_flare \
  -hiveconf TARGET=production

echo Converting injection data to SequenceFiles
mahout seqdirectory -i wellbook/injections_raw -o stage -prefix __key -ow
echo Creating injections table
hive -f ~/wellbook/ddl/injections.ddl
echo Populating injections table
hive -f job.hql \
	-hiveconf SCRIPT=injections.py \
	-hiveconf COLUMNS=file_no,uic_number,pool,date,eor_bbls_injected,eor_mcf_injected,bbls_salt_water_disposed,average_psi \
	-hiveconf TARGET=injections

echo Converting las files to SequenceFiles
mahout seqdirectory -i wellbook/las_raw -o stage -prefix __key -ow

echo Creating log_metadata table
hive -f ~/wellbook/ddl/log_metadata.ddl
echo Populating log_metadata table
hive -f job.hql \
	-hiveconf SCRIPT=las_metadata.py \
	-hiveconf COLUMNS=filename,file_no,log_name,metadata \
	-hiveconf TARGET=log_metadata

echo Creating log_readings table
hive -f ~/wellbook/ddl/log_readings.ddl
echo Populating log_readings table
hive -f job.hql \
	-hiveconf SCRIPT=las_readings.py \
	-hiveconf COLUMNS=filename,file_no,log_name,reading \
	-hiveconf TARGET=log_readings
