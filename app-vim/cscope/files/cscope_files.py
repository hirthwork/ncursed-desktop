#!/usr/bin/env python
#-*- coding: utf-8 -*-

import os
import re
import subprocess
import sys

CSCOPE_NAME = "cscope.files"

includesRe = re.compile('# \d+ "([^<"][^"]*)"')

def readConfiguration():
  try:
    f = open(CSCOPE_NAME, "r")
  except IOError:
    return []

  result = []
  for line in f.readlines():
    strippedLine = line.strip()
    if len(strippedLine) > 0:
      result += [strippedLine]
  f.close()
  return result

def writeConfiguration(lines):
  f = open(CSCOPE_NAME, "w")
  f.writelines(lines)
  f.close()

def extractFiles(args):
  result = []
  try:
    try:
      i = args.index('-o')
      del args[i]
      del args[i]
    except:
      pass
    args.append('-E')
    for x in subprocess.Popen(args, stdout=subprocess.PIPE).stdout.readlines():
      search = includesRe.search(x)
      if search:
        result.append(search.group(1))
  except:
    print "error = ", sys.exc_info()[1]
  return result

def mergeLists(base, new):
  result = list(base)
  for newLine in new:
    try:
      result.index(newLine)
    except ValueError:
      result += [newLine]
  return result

configuration = readConfiguration()
args = extractFiles(sys.argv[1:])
result = mergeLists(configuration, args)
writeConfiguration(map(lambda x: x + "\n", result))

proc = subprocess.Popen(sys.argv[1:])
ret = proc.wait()

if ret is None:
  sys.exit(1)
sys.exit(ret)

# vim: set ts=2 sts=2 sw=2 expandtab :
