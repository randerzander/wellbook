INPUTDIR=$1
OUTPUTDIR=$2
SCRIPT=$3
hadoop fs -rm -r $OUTPUTDIR
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming-*.jar \
  -D stream.io.identifier.resolver.class=org.apache.hadoop.streaming.io.JustBytesIdentifierResolver \
  -D mapred.job.reduces=0 \
  -libjars JustBytes/JustBytes.jar \
  -inputformat org.apache.hadoop.mapred.JustBytesInputFormat \
  -outputformat org.apache.hadoop.mapred.TextOutputFormat \
  -io justbytes-input \
  -file $SCRIPT \
  -mapper "/usr/bin/python $SCRIPT" \
  -input $INPUTDIR/* \
  -output $OUTPUTDIR/
