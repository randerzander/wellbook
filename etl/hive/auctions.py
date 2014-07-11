#!./pyenv/bin/python
from pyquery import PyQuery as pq
import recordhelper as helper
import string

def emit(fields, cells): helper.emit('%s\n' % ('\t'.join(fields + [cell.text_content() for cell in cells])))

def process_record(key, record):
  record = filter(lambda x: x in string.printable, record)
  record = record.replace('$', '')
  rows = pq(record.replace('\'', ''))('table').eq(0)('table')('tr')[1:]
  cells = pq(filter(lambda x: len(pq(x)('td')) > 1, rows))('td')
  [emit([key], rec) for rec in [cells[x:x+8] for x in xrange(0, len(cells), 8)]]

def parse_key(text): return text.split('.html')[0][1:]

#read all of input and run it through process_rec
helper.process_records(process_record, parse_key, '__key')
