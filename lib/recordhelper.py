import sys, gc

def log(text): sys.stderr.write(text)
def output(text): sys.stdout.write(text)
def process_records(process_record, parse_key, key_prefix):
  key = ''
  rec = ''
  for line in sys.stdin: 
    if key_prefix in line:
      if key != '': log('Finished read of: ' + key + '\n')
      if rec != '': process_record(key, rec)
      gc.collect()
      key = parse_key(line.split(key_prefix)[1])
      #log('Started read of: ' + key + '\n')
      rec = line[line.index('\t')+1:]
    else: rec += line
  if rec != '': process_record(key, rec)
