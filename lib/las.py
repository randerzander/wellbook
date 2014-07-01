def parse_metadata(lines):
  metadata = {'curveAliases': []}
  for line in lines:
    line = sanitize(line)
    if line[0] == '.': line = line[1:] #remove leading '.'s
    if line[0] == '~':
      block_type = line[1]
      metadata[block_type] = {}
    tokens = line.split()
    name = tokens[0].split('.')[0]
    if '.' in tokens[0]: UOM = tokens[0].split('.')[1]
    colon_seen = False
    value = ''
    description = ''
    for token in tokens[1:]:
      if token != ':' and not colon_seen: value = value + ' ' + token
      elif token == ':': colon_seen = True
      else: description = description + ' ' + token

    metadata[block_type][name] = {'UOM': UOM, 'description': description}
    if block_type == 'C': metadata['curveAliases'].append(name)
  return metadata

def sanitize(line):
  cleansed = ''
  for char in line:
    if str(hex(ord(char))) == '0xb5': cleansed += 'micro'
    elif str(hex(ord(char))) == '0xb0': cleansed += 'degree'
    elif str(hex(ord(char))) == '0xc2': cleansed += ''
    else: cleansed += char
  return cleansed

def parse_filename(text):
  fn = text.split('\t')[0]
  file_no = fn.split('/')[1].split('-')[0]
  log_type = fn.split('-')[1].split('.las')[0]
  return fn + '\t' + file_no + '\t' + log_type
