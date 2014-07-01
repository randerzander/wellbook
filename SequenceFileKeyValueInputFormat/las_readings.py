#!./pyenv/bin/python

#LAS standard spec:
#https://esd.halliburton.com/support/LSM/GGT/ProMAXSuite/ProMAX/5000/5000_8/Help/promax/las_overview.pdf

import json
import recordhelper as helper
from dateutil import parser

null_value = ''
def process_metadata(block_type, line, fields):
  if line[0] == '.': line = line[1:] #remove leading '.'s

  if block_type not in ['C', 'W']: return
  name = line.split('.')[0].strip()
  desc = ''
  if ':' in line: desc = line.split(':')[1].strip().replace('\t', ' ').replace('  ', ' ')
  else: helper.log('No : in line: %s\n' % (line))
  
  UOM = ''
  if '.' in line: UOM = line.split('.')[1].split(' ')[0].strip()
  else: helper.log('No . in line: %s\n' % (line))
  
  if UOM == '': val = ' '.join(line.split('.')[1:]).strip().split(':')[0].strip()
  else: val = ' '.join(line.split(UOM)[1:]).strip().split(':')[0].strip()
  if name == '': name = desc
  if 'null value' in desc.lower(): null_value = val

  if block_type == 'C':
    if 'cib_order' in fields: fields['cib_order'].append(name)
    else: fields['cib_order'] = [name]

def process_depth_entry(line, fields):
  depth = {}
  #for each reading at this depth, look up sensor name corresponding to the value
  if line.count(':') >= 1: 
    depth[fields['cib_order'][0]] = line[0:20]
    line = line[21:].strip()
  if len(line.split()) > len(fields['cib_order']):
    helper.log('%s\n%s\n' % (json.dumps(fields).lower(), line))
    return ''
  for idx, reading in enumerate(line.split()):
    if reading != null_value: depth[fields['cib_order'][idx]] = reading
  return depth

def emit(filename, rec):
  if rec != '': helper.output('%s\n' % (filename+ '\t' + json.dumps(rec).lower()))

def process_rec(filename, rec):
  if '~' not in rec:
    helper.log('No proper start of record for %s\n' % (filename))
    return
  rec = rec[rec.index('~'):].strip()
  fields = {}
  #filters blank lines, and lines starting with #
  for line in filter(lambda x: len(x.strip()) >= 1 and x.strip()[0] != '#', rec.split('\n')):
    if line[0] == '~': block_type = line[1]
    else: #All lines but ~A deal with metadata
      if block_type != 'A': process_metadata(block_type, line, fields)
      else: emit(filename, process_depth_entry(line, fields))
        

def parse_filename(text):
  fn = text.split('\t')[0]
  file_no = fn.split('/')[1].split('-')[0]
  log_type = fn.split('-')[1].split('.las')[0]
  return '\t'.join([fn, file_no, log_type])
 
helper.process_records(process_rec, parse_filename, '__key')
