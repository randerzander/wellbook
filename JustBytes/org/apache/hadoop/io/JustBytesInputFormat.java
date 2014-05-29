/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.hadoop.mapred;

import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.JustBytesWritable;
import org.apache.hadoop.io.NullWritable;

/**
 * A FileInputFormat that reads a single, unsplit file of unmodified,
 * unaugmented bytes into {@link org.apache.hadoop.io.JustBytesWritable} keys,
 * and no values.
 *
 * Input files are not split or decompressed.
 */
public class JustBytesInputFormat extends
    FileInputFormat<JustBytesWritable, NullWritable> {
  private static final Log LOG = LogFactory.getLog(JustBytesInputFormat.class);

  /**
   * Read records of keys containing raw bytes and no value.
   */
  public static class JustBytesRecordReader implements
      RecordReader<JustBytesWritable, NullWritable> {
    private final FSDataInputStream inputStream;
    private final long fileSizeBytes;

    public JustBytesRecordReader(InputSplit split, JobConf conf)
        throws IOException {
      FileSplit fileSplit = (FileSplit) split;
      inputStream = fileSplit.getPath().getFileSystem(conf)
          .open(fileSplit.getPath());
      fileSizeBytes = fileSplit.getLength();
      LOG.info("new JustBytesRecordReader for file " + fileSplit.getPath()
          + " (" + fileSizeBytes + " bytes)");
    }

    @Override
    public void close() throws IOException {
      inputStream.close();
    }

    @Override
    public float getProgress() throws IOException {
      return (float) inputStream.getPos() / fileSizeBytes;
    }

    @Override
    public JustBytesWritable createKey() {
      return new JustBytesWritable();
    }

    @Override
    public NullWritable createValue() {
      return NullWritable.get();
    }

    @Override
    public long getPos() throws IOException {
      return inputStream.getPos();
    }

    @Override
    public boolean next(JustBytesWritable bytes, NullWritable none)
        throws IOException {
      int bytesRead = inputStream.read(bytes.getBytes());
      bytes.setLength(bytesRead >= 0 ? bytesRead : 0);
      return bytesRead >= 0;
    }
  }

  /**
   * Return a {@link JustBytesRecordReader} that reads
   * {@link org.apache.hadoop.io.JustBytesWritable} keys.
   */
  @Override
  public RecordReader<JustBytesWritable, NullWritable> getRecordReader(
      InputSplit split, JobConf conf, Reporter reporter) throws IOException {
    return new JustBytesRecordReader(split, conf);
  }

  /**
   * Returns <tt>false</tt>; whole input files are streamed to a single mapper
   * in their entireity.
   *
   * @return false
   */
  @Override
  protected boolean isSplitable(FileSystem fs, Path filename) {
    return false;
  }
}
