hadoop fs -mkdir -p wellbook
cat las_raw.tgz.part* > las_raw.tgz
#This will take awhile
tar -xvf las_raw.tgz
tar -xvf production_raw.tgz
tar -xvf injections_raw.tgz
tar -xvf wells_raw.tgz
tar -xvf water-sites_raw.tgz
tar -xvf auctions_raw.tgz
hadoop fs -put *_raw wellbook/
