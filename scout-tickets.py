#!/usr/bin/env ./local-py/bin/python
from pyquery import PyQuery as pq
import sys

def extract_fields(fields, text):
  vals = []
  #Append extracted field value for each field in list of fields
  for field in fields:
    if field in text:
      vals.append(text.split(field + ': ')[1].split(' ')[0].replace(u'\xa0', 'null'))
    else:
      vals.append('null')
  return vals

def emit(fields, text):
  sys.stdout.write('%s\n' % ('\t'.join(fields + [text])))

def is_log_link(link):
  for log_type in ['tif', 'las']:
    if log_type in link.attrib['href']: return True
  return False

def process_rec(rec):
  fields = extract_fields(['File No'], pq(rec).text())
  links = pq(rec).find('a')
  for link in links:
    if is_log_link(link): emit(fields, 'https://www.dmr.nd.gov' + link.attrib['href'])

rec = ''
key = ''
for line in sys.stdin:
  if '__key' in line and rec == '': key = line
  if '__key' in line and rec != '':
    sys.stderr.write('Starting read of File: %s' % (line))
    process_rec(rec.strip())
    rec = ''
    key = line
  else: rec += line
process_rec(rec)
