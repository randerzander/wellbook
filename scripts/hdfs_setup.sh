tar -xvf auctions_raw.tgz
tar -xvf formations_key_raw.tgz
tar -xvf formations_raw.tgz
tar -xvf injections_raw.tgz
tar -xvf log_key_raw.tgz
tar -xvf production_raw.tgz
tar -xvf scout-tickets_raw.tgz
tar -xvf wells_raw.tgz
tar -xvf well_surveys_raw.tgz
tar -xvf water-sites_raw.tgz
#tar -xvf las_raw.tgz
hadoop fs -mkdir -p wellbook
#This will take awhile
hadoop fs -put *_raw wellbook/
