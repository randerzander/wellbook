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
  halves = record[record.index('~'):].strip().split('~A')
  metadata = las.parse_metadata(\
    (las.sanitize(line.strip('.').strip()) for line in\
      filter(lambda x: len(x.strip()) >= 1 and x.strip()[0] not in ['-'], halves[0].split('\n'))\
  ))

  curves_per_step = len(metadata['curveAliases'])
  #helper.log(json.dumps(metadata) + '\n')
  step = {}
  for line in halves[1].split('\n')[1:]:
    #if len(line.split()) != curves_per_step:
      #helper.log(filename + ': readings per line mismatch: ' + line + '\n')
    #TODO deal with multiline steps
    for idx, token in enumerate(line.split()):
      if idx < curves_per_step and token != metadata['W']['NULL']['value']:
        step[metadata['curveAliases'][idx]] = token
    helper.output('%s\t%s\n' % (filename, json.dumps(step).lower()))
 
helper.process_records(process_record, las.parse_filename, '__key')
