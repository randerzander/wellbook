#!/usr/bin/python

import sys, json

for line in sys.stdin:
  tokens = line.split('\t')
  file_no = tokens[0]
  fields = tokens[1]
  reading = tokens[2]

