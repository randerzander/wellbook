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
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.JustBytesWritable;
import org.apache.hadoop.util.Progressable;

/**
 * <p>An OutputFormat that writes unmodified, unaugmented bytes as key and no
 * value.
 * </p>
 *
 * <p>Output is never compressed.
 * </p>
 */
public class JustBytesOutputFormat extends
    FileOutputFormat<JustBytesWritable, NullWritable> {
  private static final Log LOG = LogFactory.getLog(JustBytesOutputFormat.class);

  /**
   * RecordWriter that writes raw bytes as key and no value.
   */
  public static class JustBytesRecordWriter implements
      RecordWriter<JustBytesWritable, NullWritable> {
    private final FSDataOutputStream outputStream;

    public JustBytesRecordWriter(FSDataOutputStream outputStream) {
      this.outputStream = outputStream;
    }

    @Override
    public void close(Reporter reporter) throws IOException {
      outputStream.close();
    }

    @Override
    public void write(JustBytesWritable bytes, NullWritable none)
        throws IOException {
      outputStream.write(bytes.getBytes(), 0, bytes.getLength());
    }
  }

  /**
   * @return {@link JustBytesRecordWriter}
   */
  @Override
  public RecordWriter<JustBytesWritable, NullWritable> getRecordWriter(
      FileSystem fileSystem, JobConf conf, String name, Progressable progress)
      throws IOException {
    Path file = FileOutputFormat.getTaskOutputPath(conf, name);
    LOG.info("New JustBytesRecordWriter for file " + file);
    return new JustBytesRecordWriter(file.getFileSystem(conf).create(file,
        progress));
  }
}
