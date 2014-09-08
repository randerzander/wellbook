#!./pyenv/bin/python
import sys, json, numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestRegressor

file_nos, x, y_oil, y_gas, y_water  = [], [], [], [], []
files = {}

idx = 0
f = open('predict_input.txt')
lines = f.read().split('\n')
#for line in sys.stdin:
for line in lines:
  tokens = line.strip().lower().split('\t')
  if tokens[0] in files: continue
  else: files[tokens[0]] = True
  if len(tokens) == 1: continue
  #print 'Parsing well ' + tokens[0]
  y_oil.append(float(tokens[1])) #bbls_oil
  y_gas.append(float(tokens[2])) #mcf_gas
  y_water.append(float(tokens[3])) #bbls_water
           #footages, fieldname, producedpools, wellbore, welltype, ctb,          perfs,      spacing
  x.append((tokens[4], tokens[5], tokens[6], tokens[7], tokens[8], tokens[9], tokens[10], tokens[11]))
  file_nos.append(tokens[0])
  #for token in tokens[12:]:
    #if token != '': x[idx].append(float(token))
  idx += 1

X = np.asarray(x)
#LabelEncode footages, fieldname, producedpools, wellbore, welltype, ctb, perfs, spacing
for idx in xrange(0, 8): X[:,idx] = LabelEncoder().fit_transform(X[:,idx])

m_oil, m_gas, m_water = RandomForestRegressor(), RandomForestRegressor(), RandomForestRegressor()
m_oil.fit(X,y_oil)
m_gas.fit(X,y_gas)
m_water.fit(X,y_water)
for idx,x in enumerate(X):
  print '\t'.join([file_nos[idx], str(x[0]), str(m_oil.predict(x)[0]), str(x[1]), str(m_gas.predict(x)[0]), str(x[1]), str(m_water.predict(x)[0])])
