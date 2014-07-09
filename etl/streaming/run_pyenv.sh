INPUTDIR=$1
OUTPUTDIR=$2
SCRIPT=$3
ENV=$4

hadoop fs -rm -r $OUTPUTDIR

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming-*.jar \
  -inputformat org.apache.hadoop.mapred.SequenceFileAsBinaryInputFormat \
  -outputformat org.apache.hadoop.mapred.TextOutputFormat \
  -file $SCRIPT \
  -mapper "$SCRIPT" \
  -reducer NONE \
  -input $INPUTDIR/* \
  -output $OUTPUTDIR/ \
  -cacheArchive $ENV#local-py
