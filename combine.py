#!/usr/bin/python

import sys, json

def interpolate(prev_reading, reading, channel, method):
  if method == 'step':
    return prev_reading[channel]
  #TODO add linear interp
  #elif method == 'linear':

for line in sys.stdin:
  records = json.loads(line.split('\t')[0])
  interp_method = line.split('\t')[1]
  file_no = records[0].split('|')[0]
  #init last_readings

  if prev_rec is None:
    prev_rec = records[0]
    all_fields = records[0].split('|')[1]

  #combine all logfile metadata
  for rec in records:
    rec_fields = rec.split('|')[1]
    for field in rec_fields: all_fields[field] = rec_fields[field]

  for rec in records:
    fields = rec.split('|')[1]
    reading = rec.split('|')[2]
    for channel, val  in prev_reading:
      if channel not in reading:
        reading[channel] = interpolate(prev_reading, reading, channel, interp_method)
    prev_rec = rec
    #emit depth record
    sys.stdout.write('%s\t%s\t%s\t' % (file_no, fields, reading))
