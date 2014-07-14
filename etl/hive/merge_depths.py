#!/usr/bin/python

import sys, json

#load local copy of channels
f = open('channels.txt')
channels = json.reads(f.read())

def emit(file_no, sums, counts): sys.stdout.write(file_no + '\t' + '\t'.join([sum/count for sum, count in zip(sums, counts)]))

file_no = None
for line in sys.stdin:
  tokens = line.split('\t')
  this_file_no, this_reading = tokens[0], json.loads(tokens[1])
  if file_no == None: file_no, sums, counts = this_file_no, [], []
  elif file_no != this_file_no: #finish this rec, start new rec
    emit(file_no, sums, counts)
    file_no, sums, counts = this_file_no, [], []

  for idx, channel in enumerate(channels): if channel in this_reading: sums[idx], counts[idx] = sums[idx] + parseFloat(channel), counts[idx] + 1
emit(file_no, sums, counts)
