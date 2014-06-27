hadoop fs -mkdir -p wellbook

tar -xvf production-raw.tar.gz
hadoop fs -put production-raw wellbook/

tar -xvf injections-raw.tar.gz
hadoop fs -put injections-raw wellbook/

hadoop fs -mkdir -p wellbook/las-raw
cat las* > las.tgz
tar -xvf las.tgz
hadoop fs -put las/* wellbok/las-raw/
