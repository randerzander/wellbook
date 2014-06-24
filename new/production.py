#!./devenv/bin/python
from pyquery import PyQuery as pq
import sys

def extract_fields(fields, text):
  vals = []
  #Append extracted field value for each field in list of fields
  for field in fields:
    if field in text: vals.append(text.split(field + ': ')[1].split(' ')[0].replace(u'\xa0', 'null'))
    else: vals.append('null')
  return vals

#Print tab separated list of fields concatted with array of extracted cell values
def emit(fields, cells): sys.stdout.write('%s\n' % ('\t'.join(fields + [cell.text_content() for cell in cells])))

def process_rec(rec):
  if 'Vent/Flare' in rec:
    fields = extract_fields(['File No', 'Perfs', 'Spacing', 'Total Depth'], pq(rec).text())
    cells = pq(rec)('table').eq(2)('td')
    #Split each 9 cell values into one row and emit record
    [emit(fields, record) for record in [cells[x:x+9] for x in xrange(0, len(cells), 9)]]

#read all of input and run it through process_rec
process_rec(sys.stdin.read())
