import os
for file in os.listdir('.'):
  with open(file, 'r') as f: text = f.read()
  with open(file, 'w') as f: f.write(file + text.replace('\r\n', '||'))
