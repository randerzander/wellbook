#!./pyenv/bin/python                                                                                  
from pyquery import PyQuery as pq                                                                     
import recordhelper as helper                                                                         
                                                                                                      
def extract_fields(fields, text):                                                                     
  vals = []                                                                                           
  #Append extracted field value for each field in list of fields                                      
  for field in fields:                                                                                
    if field in text: 
      vals.append(text.split(field + ': ')[1].split(' ')[0].replace(u'\xa0', 'null'))                 
    else:
      vals.append('null')                                                                             
  return vals

def emit(fields, text):                                                                               
  helper.emit('%s\n' % ('\t'.join(fields + [text])))                                                  

def process_rec(key, rec):                                                                            
  base = 'https://www.dmr.nd.gov'
  fields = extract_fields(['File No'], pq(rec).text())
  links = pq(rec).find('a')
  for link in links:
    link = link.attrib['href']
    if 'las' in link or 'tif' in link: emit(fields, base + link)                                   
    elif 'launchDirSurveys' in link: emit(fields, base + '/oilgas/feeservices/getsurveydata.asp?ID=' + link.split('\'')[1])
                                                                                                      
def parse_key(text): return text.split()[0]

helper.process_records(process_rec, parse_key, '__key')
