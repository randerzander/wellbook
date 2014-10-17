#!./pyenv/bin/python

#LAS standard spec:
#https://esd.halliburton.com/support/LSM/GGT/ProMAXSuite/ProMAX/5000/5000_8/Help/promax/las_overview.pdf

import json, las
import recordhelper as helper

def get_nulls(metadata): # W or V blocks define null calibrated readings
  for block in ['W', 'V']:
    try: return [float(metadata[block]['NULL']['value'])]
    except: pass
  return [-99.25, -999.25] # Default null calibration values

def process_record(filename, record):
  if '~' not in record: return 'No proper start of record'
  if '~A' not in record: return 'No delimited data block'

  halves = record[record.index('~'):].strip().split('~A')
  metadata = las.parse_metadata(\
    las.sanitize(line.strip('.').strip()) for line in las.filter_lines(halves[0], ['-'])\
  )
  if len(metadata['curveAliases']) < 1: return 'bad format in metadata block'

  try:
    halves[1] = halves[1][halves[1].index('\n'):]
    #filter blank and lines starting with #, split resulting text into tokens
    tokens = '\t'.join(las.filter_lines(halves[1], ['#'])).split()
  except: return 'bad separation between metadata and curve data'

  if len(tokens) % len(metadata['curveAliases']) != 0: return 'mismatched reading count'

  null_vals = get_nulls(metadata)
  curve_aliases = metadata['curveAliases']
  step_type = curve_aliases[0]
  for idx in xrange(0, len(tokens), len(curve_aliases)): # idx is index of first reading on a step
    step_values = tokens[idx : idx + len(curve_aliases)] # get all readings for the next step
    try:
      for idy, reading in enumerate(filter(lambda x: float(x) not in null_vals, step_values)[1:]):
        helper.emit('\t'.join([filename, step_type, step_values[0], curve_aliases[idy], metadata['C'][curve_aliases[idy]].get('UOM', ''), reading]))
    except ValueError: pass

helper.process_records(process_record, las.parse_filename, '__key')
