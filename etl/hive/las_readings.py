#!./pyenv/bin/python

#LAS standard spec:
#https://esd.halliburton.com/support/LSM/GGT/ProMAXSuite/ProMAX/5000/5000_8/Help/promax/las_overview.pdf

import json, las
import recordhelper as helper

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

  readings = iter(tokens)

  if 'W' not in metadata:
    if 'NULL' in metadata['V']: null_val = metadata['V']['NULL']['value']
    else: null_val = '-99.25'
  else: null_val = metadata['W']['NULL']['value']
  
  curve_aliases = metadata['curveAliases']
  step_type = curve_aliases[0]
  while True: #TODO handle timestamps
    try:
      step_readings = []
      for x in range(0, len(curve_aliases)): step_readings.append(readings.next())
      for idx, reading in enumerate(step_readings[1:]):
        if reading != null_val:
          try: helper.emit('%s\t%s\t%s\t%s\t%s\t%s' % (filename, step_type, step_readings[0], curve_aliases[idx+1], metadata['C'][curve_aliases[idx+1]].get('UOM', ''), float(reading)))
          except: continue
    except StopIteration: return
      
helper.process_records(process_record, las.parse_filename, '__key')
