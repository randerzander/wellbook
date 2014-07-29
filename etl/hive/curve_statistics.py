#!./pyenv/bin/python

import sys, json, numpy

def emit(file_no, channels):
  averages = {}
  for channel, readings in channels.iteritems():
    arr = numpy.array(readings)
    averages[channel] = {'mean': numpy.mean(arr), 'median': numpy.median(arr), 'std': numpy.std(arr), 'count': len(arr)}
  sys.stdout.write(file_no + '\t' + json.dumps(averages) + '\n')

def is_ascii(s): return all(ord(c) < 128 for c in s)

file_no = None
channels = {}
#proc = psutil.Process(os.getpid())
for line in sys.stdin:
  tokens = line.strip().split('\t')

  try:
    this_file_no, null_value, this_reading = tokens[0], float(tokens[1]), json.loads(tokens[2])
  except:
    continue

  for channel, reading in this_reading.iteritems():
    try:
      val = float(reading[:20])
      if val == null_value: continue
      if channel in channels: channels[channel].append(val)
      else: channels[channel] = [val]
    except:
      #sys.stderr.write('Err converting ' + channel + ', ' + reading + '\n')
      sys.stderr.write(file_no + ' err converting\n')
      continue
      
  if file_no == None: file_no, channels  = this_file_no, {}
  elif file_no != this_file_no: #finish this rec, start new rec
    emit(file_no, channels)
    #sys.stderr.write(str(proc.memory_info()) + ', Reading ' + this_file_no + '\n')
    file_no, channels = this_file_no, {}

emit(file_no, channels)
