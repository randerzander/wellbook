import sys, gc

def log(text): sys.stderr.write(text.strip() + '\n')
def error(text):
  log(text)
  sys.stdout.write(text.strip() + '\n')

def emit(text): sys.stdout.write('\t' + text.strip() + '\n')

def process_records(process_record, parse_key, key_prefix):
  key, rec = '', ''
  lines = 0
  for line in sys.stdin:
    lines += 1
    if key_prefix in line:
      if key != '': log('Finished read of: ' + key + ', ' + str(lines))
      if rec != '':
        err = process_record(key, rec)
        if err is not None: error(key + ' ERROR: ' + err)
      if key_prefix != '': key = parse_key(line.split(key_prefix)[1])
      else: key = parse_key(line)
      
      rec = line[line.index('\t')+1:]
    else: rec += line

  if rec != '':  #handle last record
    log('Finished read of: ' + key)
    err = process_record(key, rec)
    if err is not None: error(key + ' ERROR: ' + err)
