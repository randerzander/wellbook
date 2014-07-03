echo **********************************
echo ****** Creating wells table ******
echo **********************************
hive -f wellbook/ddl/wells.ddl

echo **********************************
echo ****** Converting production data to SequenceFiles ******
echo **********************************
mahout seqdirectory -i wellbook/production_raw -o stage -prefix __key -ow
echo **********************************
echo ****** Creating production table ******
echo **********************************
hive -f ~/wellbook/ddl/production.ddl
cp wellbook/lib/* ~/pyenv/lib/python2.6/site-packages/
cd wellbook/SequenceFileKeyValueInputFormat
echo **********************************
echo ****** Populating production table ******
echo **********************************
hive -f job.hql \
	-hiveconf SCRIPT=production.py \
  -hiveconf COLUMNS=file_no,perfs,spacing,total_depth,pool,date,days,bbls_oil,runs,bbls_water,mcd_prod,mcf_sold,vent_flare \
  -hiveconf TARGET=production

echo **********************************
echo ****** Converting injection data to SequenceFiles ******
echo **********************************
mahout seqdirectory -i wellbook/injections_raw -o stage -prefix __key -ow
echo **********************************
echo ****** Creating injections table ******
echo **********************************
hive -f ~/wellbook/ddl/injections.ddl
echo **********************************
echo ****** Populating injections table ******
echo **********************************
hive -f job.hql \
	-hiveconf SCRIPT=injections.py \
	-hiveconf COLUMNS=file_no,uic_number,pool,date,eor_bbls_injected,eor_mcf_injected,bbls_salt_water_disposed,average_psi \
	-hiveconf TARGET=injections

echo **********************************
echo ****** Converting las files to SequenceFiles ******
echo **********************************
mahout seqdirectory -i wellbook/las_raw -o stage -prefix __key -ow

echo **********************************
echo ****** Creating log_metadata table ******
echo **********************************
hive -f ~/wellbook/ddl/log_metadata.ddl
echo **********************************
echo ****** Populating log_metadata table ******
echo **********************************
hive -f job.hql \
	-hiveconf SCRIPT=las_metadata.py \
	-hiveconf COLUMNS=filename,file_no,log_name,metadata \
	-hiveconf TARGET=log_metadata

echo -e "\a"

echo **********************************
echo ****** Creating log_readings table ******
echo **********************************
hive -f ~/wellbook/ddl/log_readings.ddl
echo **********************************
echo ****** Populating log_readings table ******
echo **********************************
hive -f job.hql \
	-hiveconf SCRIPT=las_readings.py \
	-hiveconf COLUMNS=filename,file_no,log_name,reading \
	-hiveconf TARGET=log_readings

echo -e "\a"
