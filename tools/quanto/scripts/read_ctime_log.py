#!/usr/bin/python

import sys
import re
import os

sys.path.insert(0,os.getcwd())

from LogUtil import *
from QuantoCTimeConstants import QuantoCTimeConstants
from QuantoAppConstants import QuantoAppConstants
from QuantoLogConstants import QuantoLogConstants

def usage():
    print >> sys.stderr, "Usage:", os.path.basename(sys.argv[0]) , "<raw log file>"

#if (len(sys.argv) != 2):
#    usage()
#    exit()
# 
# fname = sys.argv[1]
# try:
#     fin = open(fname, "r")
#     fout = open(fname + '.ctime',"w")
# except IOError, e:
#     print >> sys.stderr, "Error in file IO:", e
#     if fin: fin.close()
#     if fout: fout.close()
#     exit()

fin = sys.stdin
class TimeTable:
   def __init__(self, res_count, act_count):
      self.clear(res_count, act_count) 
   def clear(self, res_count, act_count):
      self.res_count = res_count
      self.act_count = act_count
      self.table = []
      for i in (range(res_count)):
         self.table.append([])
         for j in (range(act_count)):
            self.table[i].append(0)
   def addTime(self, res, act, time):
      self.table[res][act] = self.table[res][act] + time
   def __str__(self):
      # print resources in order
      # for each resource, print the activities in order of time.
      s = ""
      for res in (range(self.res_count)):
         total_time = 0
         unknown_time = self.table[res][QuantoAppConstants.QUANTO_UNKNOWN_ACTIVITY_ID]
         for t in (self.table[res]):
            total_time = total_time + t
         if (total_time == unknown_time):
            continue
         s = s + "################# %s #################\n" % QuantoAppConstants.resourceNames[res]
         s = s + "%-10s\tTime(s)\t\t%7s\n" % ("Act",'%')
         for act in (filter(
                           lambda x: self.table[res][x] > 0, 
                            sorted(range(self.act_count),
                                cmp = lambda x, y: int(self.table[res][y] - self.table[res][x])
                              )
                           )
                    ):
            s = s + "%-10s\t%f\t%7.4f\n" % (QuantoAppConstants.activityNames[act], 
                                      self.table[res][act],
                                      100*self.table[res][act]/total_time)
      return s

entries = entriesFromCTimeFile(fin)

line = 0
expected_body = 0
time_base = 0
time_table =  TimeTable(-1,0)
for entry in entries:
   line = line + 1
   type = (entry.get_type() >> QuantoLogConstants.MSG_TYPE_OFFSET ) & 0x0F
   subtype = (entry.get_type() & 0x0F)
   
   if (type != QuantoCTimeConstants.MSG_TYPE_CTIME): 
      continue
   if (subtype == QuantoCTimeConstants.CTIME_HEADER):
      if (expected_body > 0):
         print "unexpected header line at line %d" % line
      expected_body = entry.get_header_res_count()
      time = entry.get_header_time_base() * 1/32768.0
      delta = entry.get_header_total_time() * 1/32768.0
      act_count = entry.get_header_act_count();
      time_table.clear(expected_body, act_count)
      print "t: %f int: %f res: %d acts: %s " % (time, delta, expected_body, act_count)
   elif (subtype == QuantoCTimeConstants.CTIME_BODY):
      if (expected_body == 0):
         print "unexpected body line at line %d" % line
         continue
      expected_body = expected_body - 1
      res = entry.get_body_res_id()
      for i in (range(act_count)):
         time_table.addTime(res, i, entry.getElement_body_time(i) * 1/32768.0)
      if (expected_body == 0):
         #last one
         print time_table
   else:
      print >> sys.stderr, "Line: " + str(line) + " subtype not valid for msg: " + str(subtype)
      sys.exit(-1)
