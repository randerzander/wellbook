wellbook
========
The wellbook concept is about a single view of an oil well and its history- something akin to a "Facebook Wall" for oil wells.

This repo is built from data collected and made available by the [North Dakota Industrial Commission](https://www.dmr.nd.gov/oilgas).

I used the wellindex.csv file to obtain a list of well file numbers (file_no), scraped their respective Production, Injection, Scout Ticket web pages, any available LAS format well logfiles, and loaded them into HDFS (/user/dev/wellbook/) for analysis.

To avoid the HDFS small files problem I used the Apache Mahout seqdirectory tool for combining my textfiles into SequenceFiles: the keys are the filenames and the values are the contents of each textfile.

Then I used a combination of Hive queries and the pyquery Python library for parsing relevant fields out of the raw HTML pages.

Tables:  
wellbook.wells -- [well metadata](https://www.dmr.nd.gov/oilgas/feeservices/flatfiles/flatfiles.asp) including geolocation and owner  
wellbook.well_surveys -- [borehole curve](https://www.dmr.nd.gov/oilgas/feeservices/getsurveydata.asp?ID=8895135722786)  
wellbook.production -- how much [oil, gas, and water](https://www.dmr.nd.gov/oilgas/feeservices/getwellprod.asp?filenumber=22786) was produced for each well on a monthly basis  
wellbook.auctions -- how much was paid for each parcel of land at [auction](http://www.land.nd.gov/minerals/mineralapps/auctions/auctionhistorysale.aspx)  
wellbook.injections -- how much [fluid and gas](https://www.dmr.nd.gov/oilgas/feeservices/getwellinj.asp?filenumber=5600) was injected into each well (for enhanced oil recovery and disposal purposes)  
wellbook.log_metadata -- metadata for each [LAS well log file](http://pubs.usgs.gov/of/2007/1142/)  
wellbook.log_readings -- sensor readings for each depth step in all [LAS well log files](http://pubs.usgs.gov/of/2007/1142/)  
wellbook.log_key -- [map](https://www.dmr.nd.gov/oilgas/feeservices/flatfiles/flatfiles.asp) of log mnemonics to their descriptions
wellbook.formations -- manually annotated [map](https://www.dmr.nd.gov/oilgas/feeservices/flatfiles/flatfiles.asp) of well depths to rock formations
wellbook.formations_key -- [Descriptions](https://www.dmr.nd.gov/oilgas/feeservices/flatfiles/flatfiles.asp) of rock formations
wellbook.water_sites -- [metadata](http://waterservices.usgs.gov/nwis/site/?stateCd=nd) for water quality monitoring stations in North Dakota  

Setup:
```
git clone https://github.com/randerzander/wellbook

#Prereqs
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo yum groupinstall -y 'development tools'
sudo yum install -y apache-maven mahout
#for python libs
sudo yum install -y python-devel libxslt-devel blas-devel lapack-devel gcc-gfortran
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64/bin
echo export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64/bin >> ~/.bashrc

#Download and install virtualenv
wget https://bootstrap.pypa.io/ez_setup.py
sudo python ez_setup.py
sudo easy_install pip
sudo pip install virtualenv

#Create a relocatable Python virtualenv
virtualenv ~/wellbook/pyenv
source ~/wellbook/pyenv/bin/activate
pip install pyquery numpy scipy scikit-learn
cp ~/wellbook/etl/lib/recordhelper.py ~/wellbook/pyenv/lib/python2.6/site-packages/
deactivate
virtualenv --relocatable ~/wellbook/pyenv

function mvn_package(){
  git clone $1
  mv $2 $3/
  cd $3/$2
  mvn package
}
#Download and build the custom Hive InputFormat
mvn_package https://github.com/randerzander/SequenceFileKeyValueInputFormat SequenceFileKeyValueInputFormat ~/wellbook

#Download and build necessary Hive UDFs
mkdir ~/wellbook/udfs
mvn_package https://github.com/Esri/spatial-framework-for-hadoop spatial-framework-for-hadoop ~/wellbook/udfs
mvn_package https://github.com/randerzander/CurveUDFs CurveUDFs ~/wellbook/udfs

#Download and build necessary Hive SerDes
mkdir ~/wellbook/serdes
mvn_package https://github.com/ogrodnek/csv-serde csv-serde ~/wellbook/serdes

cd ~/
#Sets up HDFS folder structure
sh ~/wellbook/scripts/hdfs_setup.sh
#Sets up Hive tables
sh ~/wellbook/scripts/hive_setup.sh
```
