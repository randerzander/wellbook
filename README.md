wellbook
========
The wellbook concept is about a single view of an oil well and its history- something akin to a "Facebook Wall" for oil wells.

This repo is built from data collected and made available by the [North Dakota Industrial Commission](https://www.dmr.nd.gov/oilgas).

I used the wellindex.csv file to obtain a list of well file numbers (file_no), scraped their respective Production, Injection, Scout Ticket web pages, any available LAS format well logfiles, and loaded them into HDFS (/user/dev/wellbook/) for analysis.

To avoid the HDFS small files problem I used the Apache Mahout seqdirectory tool for combining my textfiles into SequenceFiles: the keys are the filenames and the values are the contents of each textfile.

Then I used a combination of Hive queries and the Python pyquery library for parsing relevant fields out of the raw HTML pages.

Setup:
```
git clone https://github.com/randerzander/wellbook

#Prereqs
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo yum groupinstall -y 'development tools'
#libxslt-devel needs to be installed on all datanodes, python-devel, apache-maven, and mahout just need to be installed on an edgenode
sudo yum install -y python-devel libxslt-devel apache-maven mahout

#Download and install virtualenv
wget https://bootstrap.pypa.io/ez_setup.py
sudo python ez_setup.py
sudo easy_install pip
sudo pip install virtualenv

#Create a relocatable Python virtualenv
virtualenv pyenv
source pyenv/bin/activate
pip install pyquery
cp ~/wellbook/lib/recordhelper.py ~/pyenv/lib/python2.6/site-packages/
deactivate
virtualenv --relocatable pyenv

#Download and build the custom Hive InputFormat
git clone https://github.com/randerzander/SequenceFileKeyValueInputFormat
cd SequenceFileKeyValueInputFormat
mvn package

#Download and build necessary Hive UDFs
mkdir ~/udfs
git clone https://github.com/klout/brickhouse.git
mv brickhouse ~/udfs/
cd ~/udfs/brickhouse
mvn package

git clone https://github.com/Esri/spatial-framework-for-hadoop
mv spatial-framework-for-hadoop ~/udfs/
cd ~/udfs/spatial-framework-for-hadoop
mvn package

#Download and build necessary Hive SerDes
mkdir ~/serdes
git clone https://github.com/ogrodnek/csv-serde
mv csv-serde ~/serdes/
cd ~/serdes/csv-serde
mvn package

cd ~/
#Sets up HDFS folder structure
sh ~/wellbook/scripts/hdfs_setup.sh
#Sets up Hive tables
sh ~/wellbook/scripts/hive_setup.sh
```
