#!/usr/bin/python

import sys, os

for f in os.listdir('.'):
  sys.stderr.write('%s\n' % (f))
  
input = sys.stdin.read()
