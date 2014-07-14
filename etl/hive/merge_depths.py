#!/usr/bin/python

import sys, json

#load local copy of channels
f = open('channels.txt')
channels = json.loads(f.read())

def emit(file_no, sums, counts):
  averages = {}
  for idx, channel in enumerate(channels):
    if counts[idx] > 0: averages[channel] = sums[idx]/counts[idx]
  sys.stdout.write(file_no + '\t' + json.dumps(averages) + '\n')

file_no = None
for line in sys.stdin:
  tokens = line.strip().split('\t')
  this_file_no, null_value, this_reading = tokens[0], tokens[1], json.loads(tokens[2])
  if file_no == None: file_no, sums, counts = this_file_no, [0]*len(channels), [0]*len(channels)
  elif file_no != this_file_no: #finish this rec, start new rec
    emit(file_no, sums, counts)
    sys.stderr.write('Starting read of ' + this_file_no + '\n')
    file_no, sums, counts = this_file_no, [0]*len(channels), [0]*len(channels)

  for idx, channel in enumerate(channels):
    if channel in this_reading:
      if this_reading[channel] != null_value:
        sums[idx], counts[idx] = sums[idx] + float(this_reading[channel]), counts[idx] + 1

emit(file_no, sums, counts)
