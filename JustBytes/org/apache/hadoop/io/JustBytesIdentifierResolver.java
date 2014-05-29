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

import org.apache.hadoop.io.*;
import org.apache.hadoop.io.JustBytesWritable;

/**
 * <p>IdentifierResolver that knows about "justbytes".</p>
 * 
 * <p>To use justbytes, give the following options to streaming:
 * 
 * <pre>
 * -D stream.io.identifier.resolver.class=org.apache.hadoop.streaming.io.JustBytesIdentifierResolver
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
 *  
 */
public class JustBytesIdentifierResolver extends IdentifierResolver {

    /** Identifier for a key of unmodified, unaugmented bytes and no value. */
    public static final String JUST_BYTES_ID = "justbytes-input";
    public static final String JUST_BYTES_IO_ID = "justbytes-inputoutput";

    @Override
    public void resolve(String identifier) {
        if (identifier.equalsIgnoreCase(JUST_BYTES_IO_ID)) {
          setInputWriterClass(JustBytesInputWriter.class);
          setOutputReaderClass(JustBytesOutputReader.class);
          setOutputKeyClass(JustBytesWritable.class);
          setOutputValueClass(NullWritable.class);
        }else if (identifier.equalsIgnoreCase(JUST_BYTES_ID)){
          setInputWriterClass(JustBytesInputWriter.class);
          setOutputReaderClass(TextOutputReader.class);
          setOutputKeyClass(Text.class);
          setOutputValueClass(Text.class);
        }
        else {
            super.resolve(identifier);
        }
    }
}
