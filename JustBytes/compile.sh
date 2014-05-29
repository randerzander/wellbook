javac -classpath /usr/lib/hadoop-mapreduce/*:/usr/lib/hadoop/*:classes/:../commons-logging-1.1.3-src/target/* -d classes/ org/apache/hadoop/io/*.java
cd classes/
jar -cvf ../JustBytes.jar *
