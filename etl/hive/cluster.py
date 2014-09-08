#!/pyenv/bin/python
import sys, json, numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.cluster import KMeans

x = []

f = open('cluster_input.txt')
lines = f.read().split('\n')
#for line in sys.stdin:
for idx, line in enumerate(lines[:-1]):
  print idx
  tokens = line.strip().split('\t')
  points = []
  for point in json.loads(tokens[9]):
    points.append(point['x'])
    points.append(point['y'])
  while len(points) < 20:
    points.append(-999.25)
    points.append(-999.25)
  #mnemonic, desription, uom, average, median, stddev, variance, max, min, range, histogram points
  if len(tokens) == 11: description = tokens[10]
  else: description = ''
  x.append((tokens[0], description, tokens[1], \
    float(tokens[2]), float(tokens[3]), float(tokens[4]), float(tokens[5]), float(tokens[6]), float(tokens[7]), float(tokens[8]), \
    points[0], points[1], points[2], points[3], points[4], points[5], points[6], points[7], points[8], points[9], points[10], points[11], points[12], \
    points[13], points[14], points[15], points[16], points[17], points[18], points[19]))

X = np.asarray(x)
print 'Label encoding mnemonic'
X[:,0] = LabelEncoder().fit_transform(X[:,0]) #mnemonic
print 'Label encoding description'
X[:,1] = LabelEncoder().fit_transform(X[:,1]) #description
print 'Label encoding uom'
X[:,2] = LabelEncoder().fit_transform(X[:,2]) #uom

#f = open('cluster_input-encoded.txt')

print 'Beginning clustering..'
#clusters = KMeans(init='k-means++', n_clusters=10, n_init=10, name='k-means++', data=X)
print 'Finished!'
