#!./pyenv/bin/python

#LAS standard spec:
#https://esd.halliburton.com/support/LSM/GGT/ProMAXSuite/ProMAX/5000/5000_8/Help/promax/las_overview.pdf

import json, las
import recordhelper as helper

def process_record(filename, record):
  if '~' not in record: return 'No proper start of record'
  halves = record[record.index('~'):].strip().split('~A')
  if len(halves) < 2: return 'Improperly separated metadata & data blocks'

  metadata = las.parse_metadata(\
    las.sanitize(line.strip('.').strip()) for line in las.filter_lines(halves[0], ['-'])\
  )
  if len(metadata['curveAliases']) < 1: return 'Improperly formatted metadata block'

  for block in ['V', 'W', 'C']:
    if block in metadata:
      for mnemonic, val in metadata[block].iteritems():
        helper.emit('%s\t%s\t%s\t%s\t%s' % \
          (filename, block, mnemonic, val.get('UOM', ''), val.get('description', '')))

helper.process_records(process_record, las.parse_filename, '__key')
