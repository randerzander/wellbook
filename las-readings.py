#!/usr/bin/python

#LAS standard spec:
#https://esd.halliburton.com/support/LSM/GGT/ProMAXSuite/ProMAX/5000/5000_8/Help/promax/las_overview.pdf

import sys, json

log = sys.stderr
output = sys.stdout

def process_metadata(block_type, line, fields):
  log.write('Meta: ' + line)
  if line[0] == '.': line = line[1:] #remove leading '.'s

  if block_type != 'C': return
  name = line.split('.')[0].strip()
  desc = line.split(':')[1].strip().replace('\t', ' ').replace('  ', ' ')
  if name == '': name = desc

  if block_type == 'C': #keep track of curve information block field order
    if 'cib_order' in fields: fields['cib_order'].append(name)
    else: fields['cib_order'] = [name]

def process_depth_entry(line, fields):
  depth = {}
  #for each reading at this depth, look up sensor name corresponding to the value
  for idx, reading in enumerate(line.split()): depth[fields['cib_order'][idx]] = reading
  return depth

def emit(filename, rec): output.write('%s\n' % (filename+ '\t' + json.dumps(rec).lower()))

def process_rec(filename, rec):
  log.write('Parsing filename: %s\n' % (filename))
  fields = {}
  #filters blank lines, and lines starting with #
  for line in filter(lambda x: len(x) > 0 and x[0] != '#', rec.split('\n')):
    if line[0] == '~': block_type = line[1]
    else: #All lines but ~A deal with metadata
      if block_type != 'A': process_metadata(block_type, line, fields)
      else: emit(filename, process_depth_entry(line, fields))

def parse_filename(text):
  fn = text.split('__key')[1].split('.las')[0] + '.las'
  file_no = fn.split('/')[1].split('-')[0]
  log_type = fn.split('-')[1].split('.las')[0]
  return '\t'.join([fn, file_no, log_type])
 
def strip_rec(rec): return rec[rec.index('~'):].strip()

rec = ''
filename = ''
for line in sys.stdin:
  if '__key' in line and rec == '':
    filename = parse_filename(line)
    rec = line
  if '__key' in line and rec != '':
    process_rec(filename, strip_rec(rec))
    rec = line
    filename = parse_filename(line)
  else: rec += line
if rec != '': process_rec(filename, strip_rec(rec))
