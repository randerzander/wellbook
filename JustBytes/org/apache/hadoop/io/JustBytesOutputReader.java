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

package org.apache.hadoop.streaming.io;

import java.io.DataInput;
import java.io.IOException;

import org.apache.hadoop.io.JustBytesWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.streaming.PipeMapRed;

/**
 * OutputReader that reads unmodified, unaugmented bytes from the client as key,
 * and no value.
 */
public class JustBytesOutputReader extends
    OutputReader<JustBytesWritable, NullWritable> {
  private DataInput input;
  private JustBytesWritable key;

  @Override
  public void initialize(PipeMapRed pipeMapRed) throws IOException {
    super.initialize(pipeMapRed);
    input = pipeMapRed.getClientInput();
    key = new JustBytesWritable();
  }

  @Override
  public boolean readKeyValue() throws IOException {
    key.readFields(input);
    return key.getLength() > 0; // Should only be zero on EOF
  }

  @Override
  public JustBytesWritable getCurrentKey() throws IOException {
    return key;
  }

  @Override
  public NullWritable getCurrentValue() throws IOException {
    return NullWritable.get();
  }

  @Override
  public String getLastOutput() {
    throw new UnsupportedOperationException(
        "Use new String(bytes, encoding) to make a String from bytes");
  }
}
