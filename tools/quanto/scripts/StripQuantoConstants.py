#!/usr/bin/env python
import sys
from operator import itemgetter

if len(sys.argv) < 2:
  print "Usage: StripQuantoConstants.py infile [outfile]"
  print "  infile   NesC XML file with app constants (e.g. app.xml)"
  print "  outfile  Python class file (default: QuantoAppConstants.py)"
  exit()

infilename  = sys.argv[1]
outfilename = "QuantoAppConstants.py"

if len(sys.argv) == 3:
  outfilename = sys.argv[2]

infile = open(infilename, "r")
outfile = open(outfilename, "w")

activities = {}
resources = {}

for line in infile:
  if line.strip().startswith("<constant "):
    for frag in line.split(" "):
      if frag.strip().startswith("cst="):
        cst = frag.strip().replace('cst="I:', "").replace('"', "")
      if frag.strip().startswith("name="):
        name = frag.strip().replace('name="', "").replace('"', "")
    if (name.endswith("_ACTIVITY_ID")):
      activities[(name)] = cst
    elif (name.endswith("_RESOURCE_ID")):
      resources[(name)] = cst

outfile.write("class QuantoAppConstants:\n")

s_activities = sorted(activities.iteritems(), key=itemgetter(1), cmp=lambda x, y: int(x)-int(y))
s_resources  = sorted( resources.iteritems(), key=itemgetter(1), cmp=lambda x, y: int(x)-int(y))

for a in s_activities:
  outfile.write("  " + a[0] + " = " + a[1] + "\n")

outfile.write("\n")

for r in s_resources:
  outfile.write("  " + r[0] + " = " + r[1] + "\n")

outfile.write("\n\n")

# Print the activity names
outfile.write("  activityNames = {\n")
tot = len(s_activities)
idx = 1
for n in (s_activities):
  txt = n[0].replace("QUANTO_", "").replace("_ACTIVITY_ID", "")
  txt = txt.replace("_", " ").title().replace(" ","_")
  if idx == tot:
    outfile.write("    " + n[0] + ": '" + txt + "'\n")
  else:
    outfile.write("    " + n[0] + ": '" + txt + "',\n")
  idx = idx + 1
outfile.write("  }\n")
outfile.write("\n")

#Print the resource names
outfile.write("  resourceNames = {\n")
tot = len(s_resources)
idx = 1
for n in (s_resources):
  txt = n[0].replace("QUANTO_", "").replace("_RESOURCE_ID", "")
  txt = txt.replace("_", " ").title().replace(" ","_")
  if idx == tot:
    outfile.write("    " + n[0] + ": '" + txt + "'\n")
  else:
    outfile.write("    " + n[0] + ": '" + txt + "',\n")
  idx = idx + 1
outfile.write("  }\n")

outfile.close()
infile.close()
