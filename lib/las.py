import recordhelper as helper

comment_blocks = ['P', 'O']
def parse_metadata(lines):
  metadata = {'curveAliases': [], 'comments': []}
  for line in lines:
    #helper.log(line + '\n')
    if line[0] == '#':
      metadata['comments'].append(line)
      continue
    if line[0] == '~':
      block_type = line[1]
      continue
    if block_type in comment_blocks:
      if block_type in metadata: metadata[block_type].append(line)
      else: metadata[block_type] = [line]
      continue

    mnemonic = line.split('.')[0].strip() #mnem goes until first .
    field = {}
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
  fn = text.split('\t')[0]
  file_no = fn.split('/')[1].split('-')[0]
  log_type = fn.split('-')[1].split('.las')[0]
  return fn + '\t' + file_no + '\t' + log_type
