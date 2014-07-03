import recordhelper as helper

#filters blank lines, and lines starting with characters in filter_chars
def filter_lines(text, filter_chars):
  return filter(
     lambda x: len(x.strip()) >= 1 and x.strip()[0] not in filter_chars,\
     text.split('\n')\
   )

def parse_metadata(lines):
  comment_blocks = ['O']
  metadata = {'curveAliases': [], 'comments': []}
  for line in lines:
    #helper.log(line + '\n')
    if line[0] == '#':
      #metadata['comments'].append(line)
      continue
    if line[0] == '~':
      block_type = line[1]
      continue
    if block_type in comment_blocks:
      if block_type in metadata: metadata[block_type].append(line)
      else: metadata[block_type] = [line]
      continue

    field = {}
    #helper.log(line + '\n')
    if ':' not in line: mnemonic = line.strip()
    elif '.' not in line: #if no period, no UOM. value is from end of first word to :
      mnemonic = line.split()[0].strip()
      value = line.split(mnemonic)[1].split(':')[0].strip()
    else:
      if '..' in line: mnemonic = line.split(':')[0].strip()
      else:
        mnemonic = line.split('.')[0].strip() #mnem goes until first .
        if line.split('.')[1][0].strip() != '': #if there's a char following the first period..
          UOM = line.split('.')[1].split()[0].strip() #UOM is after first period
          value = line.split(UOM)[1].split(':')[0].strip() #Value is after UOM, before :
          field['UOM'] = UOM
        else: value = '.'.join(line.split('.')[1:]).split(':')[0].strip() #value can have .s in it
        description = line.split(':')[1].strip() #Description is after :

    if mnemonic == '': #if we don't have a field name or description, drop this line
      if description == '': continue
      else: mnemonic = description

    if block_type not in metadata: metadata[block_type] = {}
    if value != '': field['value'] = value
    field['description'] = description
    metadata[block_type][mnemonic] = field

    if block_type == 'C': metadata['curveAliases'].append(mnemonic)
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
  fn = text.split('\t')[0].replace('..', '.')
  file_no = fn.split('/')[1].split('-')[0]
  if '-' in line: log_type = fn.split('-')[1].split('.las')[0]
  else: log_type = ''
  return fn + '\t' + file_no + '\t' + log_type
