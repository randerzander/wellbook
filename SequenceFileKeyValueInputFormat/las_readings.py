#!./pyenv/bin/python

#LAS standard spec:
#https://esd.halliburton.com/support/LSM/GGT/ProMAXSuite/ProMAX/5000/5000_8/Help/promax/las_overview.pdf

import json, las
import recordhelper as helper

def process_record(filename, record):
  if '~' not in record: #handle malformed LAS files
    helper.log('No proper start of record for %s\n' % (filename))
    return
  halves = record[record.index('~'):].strip().split('~A')
  metadata = las.parse_metadata(\
    las.sanitize(line.strip('.').strip()) for line in las.filter_lines(halves[0], ['-'])\
  )
  if len(metadata['curveAliases']) < 1:
    helper.log(filename + ': improperly formatted metadata block')
    return

  #filter blank and lines starting with #, split resulting text into tokens
  halves[1] = halves[1][halves[1].index('\n'):]
  tokens = '\t'.join(las.filter_lines(halves[1], ['#'])).split()

  if len(metadata['curveAliases']) < 1:
    helper.log(filename + ': malformed curve information block\n')
    return
  if len(tokens) % len(metadata['curveAliases']) != 0:
    helper.log(filename + ': Mismatched token count\n')
    return

  readings = iter(tokens)
  while True: #TODO handle timestamps
    step = {}
    try: #iterate through enough tokens to fill the step and emit as Hive record
      for alias in metadata['curveAliases']: step[alias] = readings.next()
      helper.emit('%s\t%s\n' % (filename, json.dumps(step).lower()))
      step = {}
    except StopIteration: return
      
helper.process_records(process_record, las.parse_filename, '__key')
