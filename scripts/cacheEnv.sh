ENV=$1
LOC=$2

echo Making $ENV relocatable
virtualenv --relocatable $ENV
cd $ENV
echo Zipping up $ENV
zip -q -r ../$ENV.zip *
cd ..
echo Removing existing HDFS copy of $ENV
hadoop fs -rm -r $LOC
echo Creating HDFS dir $LOC
hadoop fs -mkdir $LOC
echo Putting $ENV.zip into HDFS://$LOC/$ENV.zip
hadoop fs -put $ENV.zip $LOC/
rm $ENV.zip
