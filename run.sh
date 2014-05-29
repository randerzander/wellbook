INPUTDIR=$1
OUTPUTDIR=$2
SCRIPT=$3

hadoop fs -rm -r $OUTPUTDIR

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming-*.jar \
  -D mapred.job.reduces=0 \
  -inputformat org.apache.hadoop.mapred.SequenceFileAsBinaryInputFormat \
  -outputformat org.apache.hadoop.mapred.TextOutputFormat \
  -file $SCRIPT \
  -mapper "$SCRIPT" \
  -input $INPUTDIR/* \
  -output $OUTPUTDIR/

  #-inputformat org.apache.hadoop.mapred.TextInputFormat \
