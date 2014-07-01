#!./pyenv/bin/python

#LAS standard spec:
#https://esd.halliburton.com/support/LSM/GGT/ProMAXSuite/ProMAX/5000/5000_8/Help/promax/las_overview.pdf

import json, las
import recordhelper as helper

def process_record(filename, record):
  if '~' not in record:
    helper.log('No proper start of record for %s\n' % (filename))
    return
  record = record[record.index('~'):].strip()
  #filters blank lines, and lines starting with #
  metadata = las.parse_metadata(filter(lambda x: len(x.strip()) >= 1 and x.strip()[0] != '#', record.split('~A')[0]))
  for readingText in record.split('~A')[1].split('\n'):
    reading = {}
    if line.count(':') >= 1: #timestamps don't split well
      reading[curveAliases[0]] = readingText[0:20] 
      readingText = readingText[21:].strip()
    elif len(line.split()) != len(emptyReading):
      helper.log(filename + ': fieldcount issue: ' + readingText)
      return
    for reading,idx in enumerate(readingText.split()): reading[curveAliases[idx]] = reading
    if reading != None: helper.output('%s\n' % (filename + '\t' + json.dumps(reading).lower()))
 
helper.process_records(process_record, las.parse_filename, '__key')
