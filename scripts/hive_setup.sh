function message(){
  echo '***********************************************************'
  echo $1
  echo '***********************************************************'
  echo -e "\a"
}

function workflow(){
  message "Converting $1 data to SequenceFiles"
  mahout seqdirectory -i wellbook/$1_raw -o wellbook/$1_seq -prefix __key -ow
  message "Creating $1 table"
  hive -f ~/wellbook/ddl/$1.ddl
  populate_table $1 $2 $3 $1
}

function populate_table(){
  message "Populating $1 table"
  hive -f job.hql -hiveconf SCRIPT=$2 -hiveconf COLUMNS=$3 -hiveconf SOURCE=/user/dev/wellbook/$4_seq -hiveconf TARGET=$1
}

message 'Creating wells table'
#hive -f ~/wellbook/ddl/wells.ddl
message 'Creating water_sites table'
#hive -f ~/wellbook/ddl/water_sites.ddl

cp ~/wellbook/etl/lib/* ~/pyenv/lib/python2.6/site-packages/
cd ~/wellbook/etl/hive
#workflow production production.py file_no,perfs,spacing,total_depth,pool,date,days,bbls_oil,runs,bbls_water,mcd_prod,mcf_sold,vent_flare
#workflow injections injections.py file_no,uic_number,pool,date,eor_bbls_injected,eor_mcf_injected,bbls_salt_water_disposed,average_psi
#workflow auctions auctions.py date,lease_no,township,range,section,description,bidder,acres,bonus_per_acre

message 'Converting las files to SequenceFiles'
#mahout seqdirectory -i wellbook/las_raw -o wellbook/las_seq -prefix __key -ow

message 'Creating log_metadata table'
#hive -f ~/wellbook/ddl/log_metadata.ddl
#populate_table log_metadata las_metadata.py filename,file_no,log_name,block,mnemonic,uom,description las
message 'Creating log_readings table'
hive -f ~/wellbook/ddl/log_readings.ddl
populate_table log_readings las_readings.py filename,file_no,log_name,step_type,step,mnemonic,uom,reading las
message 'Transferring from log_readings_tmp to log_readings'
#hive -e 'insert overwrite table wellbook.log_readings select * from wellbook.log_readings_tmp;'
