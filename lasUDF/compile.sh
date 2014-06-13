javac -classpath /usr/lib/hive/lib/*:/usr/lib/hadoop/*:/usr/lib/mahout/* src/*.java -d classes
if [ $? != 0 ]
  then
    exit -1
fi
jar -cvf target/nrgUDF.jar -C classes/ .
