#!/pyenv/bin/python
import sys, json, numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestRegressor

x, y_oil, y_gas, y_water  = [], [], [], []

idx = 0
#for line in sys.stdin:
f = open('input.txt')
lines = f.read().split('\n')[:-1]
for line in lines:
  tokens = line.strip().split('_')
  y_oil.append(float(tokens[0])) #bbls_oil
  y_gas.append(float(tokens[1])) #mcf_gas
  y_water.append(float(tokens[2])) #bbls_water
  #total_depth, footages, fieldname, producedpools, wellbore, welltype, ctb, perfs, spacing, pool
  x.append((float(tokens[3]), tokens[4], tokens[5], tokens[6], tokens[7], tokens[8], tokens[9], tokens[10], tokens[11], tokens[12]))
  for token in tokens[13:]:
    if token != '': x[idx].append(float(token))
  idx += 1

X = np.asarray(x)
X[:,1] = LabelEncoder().fit_transform(X[:,1]) #footages
X[:,2] = LabelEncoder().fit_transform(X[:,2]) #fieldname
X[:,3] = LabelEncoder().fit_transform(X[:,3]) #producedpools
X[:,4] = LabelEncoder().fit_transform(X[:,4]) #wellbore
X[:,5] = LabelEncoder().fit_transform(X[:,5]) #welltype
X[:,6] = LabelEncoder().fit_transform(X[:,6]) #ctb
X[:,7] = LabelEncoder().fit_transform(X[:,7]) #perfs
X[:,8] = LabelEncoder().fit_transform(X[:,8]) #spacing
X[:,9] = LabelEncoder().fit_transform(X[:,9]) #pool

m_oil, m_gas, m_water = RandomForestRegressor(), RandomForestRegressor(), RandomForestRegressor()
m_oil.fit(X,y_oil)
m_gas.fit(X,y_gas)
m_water.fit(X,y_water)
#model.predict(X)
