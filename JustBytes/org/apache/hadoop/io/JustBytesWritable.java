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
package org.apache.hadoop.io;

import java.io.DataInput;
import java.io.DataInputStream;
import java.io.DataOutput;
import java.io.IOException;

/**
 * <p>A Writable that reads and writes unmodified, unaugmented bytes as keys
 * and no values.</p>
 *
 * <p>A JustBytesWritable has a length representing the number of valid bytes in
 * its backing array.</p>
 *
 * <p>To use justbytes for binary streaming, give the following command-line
 * options:
 *
 * <pre>
 * -io justbytes
 * -inputformat org.apache.hadoop.mapred.JustBytesInputFormat
 * -outputformat org.apache.hadoop.mapred.JustBytesOutputFormat
 * </pre>
 * </p>
 *
 * <p>
 * <tt>-io justbytes</tt> sets the following:
 *
 * <ul>
 * <li>Input writer class: {@link org.apache.hadoop.streaming.io.JustBytesInputWriter}</li>
 * <li>Output writer class: {@link org.apache.hadoop.streaming.io.JustBytesOutputReader}</li>
 * <li>Output key class: {@link JustBytesWritable}</li>
 * <li>Output value class: {@link NullWritable} (nothing written)</li>
 * </ul>
 * </p>
 */
public class JustBytesWritable extends BinaryComparable implements
    WritableComparable<BinaryComparable> {
  private static final int DEFAULT_CAPACITY_BYTES = 64 * 1024;
  private byte[] bytes; // Actual data
  private int length; // Number of valid bytes in this.bytes

  /**
   * Initialize a new JustBytesWritable containing no bytes, with the default
   * capacity.
   */
  public JustBytesWritable() {
    this(new byte[DEFAULT_CAPACITY_BYTES]);
    this.length = 0;
  }

  /**
   * Initialize a new JustBytesWritable containing the given byte array directly
   * (no copy is made).
   *
   * The length is set to <tt>bytes.length</tt>.
   */
  public JustBytesWritable(byte[] bytes) {
    super();
    set(bytes);
  }

  /**
   * Make this object contain the given array directly (no copy is made).
   *
   * The length is set to <tt>bytes.length</tt>.
   */
  public void set(byte[] bytes) {
    if (bytes == null) {
      throw new IllegalArgumentException("Null array");
    }
    this.bytes = bytes;
    this.length = bytes.length;
  }

  /**
   * Set the number of valid bytes in this object.
   *
   * @param length
   *          Cannot be negative or greater than <tt>getBytes().length</tt>.
   */
  public void setLength(int length) {
    if (length < 0 || length > bytes.length) {
      throw new IllegalArgumentException("Invalid length: " + length);
    }
    this.length = length;
  }

  /**
   * Read up to <tt>getBytes().length</tt> bytes from <tt>input</tt> and set the
   * length to the number of bytes read.
   *
   * Sets the length to zero (and does not modify any bytes) on and only on EOF.
   */
  @Override
  public void readFields(DataInput input) throws IOException {
    /*
     * We cheat and use the knowledge that streaming passes us a DataInputStream
     * so we don't have to read byte by byte waiting for EOFException. This
     * reduces CPU usage by half.
     */
    length = Math.max(0, ((DataInputStream) input).read(bytes));
  }

  /**
   * Write <tt>getLength()</tt> bytes to <tt>output</tt>.
   */
  @Override
  public void write(DataOutput output) throws IOException {
    output.write(bytes, 0, length);
  }

  /**
   * Return the array backing this object (no copy is made).
   *
   * Note that only the first <tt>getLength()</tt> bytes are valid.
   */
  @Override
  public byte[] getBytes() {
    return bytes;
  }

  /**
   * Return the number of valid bytes in this object.
   */
  @Override
  public int getLength() {
    return length;
  }
}
