#!./pyenv/bin/python

#LAS standard spec:
#https://esd.halliburton.com/support/LSM/GGT/ProMAXSuite/ProMAX/5000/5000_8/Help/promax/las_overview.pdf

#import sys, os, tarfile
#tar = tarfile.open('pyenv.tgz')
#tar.extractall()
#tar.close()
#for f in os.listdir('.'): sys.stderr.write('%s\n' % (f))
#sys.stderr.write('END OF FILES\n')

import json, las
import recordhelper as helper

def process_record(filename, record):
  if '~' not in record:
    helper.log('No proper start of record for %s\n' % (filename))
    return
  halves = record[record.index('~'):].strip().split('~A')
  metadata = las.parse_metadata( \
    (las.sanitize(line.strip('.').strip()) for line in \
      filter(lambda x: len(x.strip()) >= 1 and x.strip()[0] not in ['-'], halves[0].split('\n')) \
  ))
  helper.output('%s\n' % (filename + '\t' + json.dumps(metadata).lower()))

helper.process_records(process_record, las.parse_filename, '__key')
