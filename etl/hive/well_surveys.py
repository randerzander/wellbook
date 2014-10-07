#!./pyenv/bin/python
from pyquery import PyQuery as pq
import recordhelper as helper

def sanitize(cell):
  if cell.text is None: return ''
  else: return cell.text.strip()

def process_rec(key, rec):
  cells = pq(rec)('table')('td')
  records = [cells[x:x+13] for x in xrange(0, len(cells), 13)]
  for record in records: helper.emit('\t'.join([sanitize(cell) for cell in record]))

def parse_key(text): return text.split()[0]

helper.process_records(process_rec, parse_key, '__key')
