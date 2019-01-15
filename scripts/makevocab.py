# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		makevocab.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		15th January 2019
#		Purpose :	Build __words.asm and __dictionary.asm for Kernel from sources.
#
# ***************************************************************************************
# ***************************************************************************************

import sys,re,os
#
#		Get source files
#
sourceList = []
for root,dirs,files in os.walk("sources"):
	for f in [x for x in files if x.endswith(".words")]:
		sourceList.append(root+os.sep+f)
sourceList.sort()
#
#		Build the source file as one long string with ~ for new lines.
#
sourceCode = []
for f in sourceList:
	for l in [x.rstrip().replace("\t"," ") for x in open(f).readlines()]:
		sourceCode.append(l if l.find("//") < 0 else l[:l.find("//")])
sourceCode = "~".join(sourceCode)
#
#		Split around ~@<type> <name>
#
parts = re.split("(\~\@\w+\s+[\w\@\!\+\-\*\/\>\,]+)",sourceCode)
if not parts[0].startswith("~@"):
	del parts[0]
#
#		Write source file.
#
words = {}
hOut = open(".."+os.sep+"kernel"+os.sep+"temp"+os.sep+"__words.asm","w")
for w in range(0,len(parts),2):												# work through in pairs.
	defn = re.split("\s+",parts[w].replace("~","").strip())					# get name/type
	name = defn[1]															
	wType = defn[0]
	assert wType == "@word" or wType == "@macro"
	code = [x.rstrip() for x in parts[w+1].split("~") if x.rstrip() != ""]	# strip code
	scramble = "_".join(["{0:02x}".format(ord(x)) for x in name])			# scrambled word name
	words[name] = "define_"+scramble 										# comment to help readability
	hOut.write(";\n; {0} {1} {0}\n;\n".format("===========",name))
	hOut.write("define_{0}:\n".format(scramble))
	if wType == "@word":
		hOut.write("\tcall COMCompileCallToSelf\n")
	if wType == "@macro":
		hOut.write("\tcall COMCopyCode\n")
		hOut.write("\tdb   end_{0}-start_{0}\n".format(scramble))

	hOut.write("start_{0}:\n".format(scramble))
	hOut.write("\n".join(["\t"+x.strip() if x.startswith(" ") else x.strip() for x in code]))
	hOut.write("\n")
	hOut.write("end_{0}:\n".format(scramble))
	hOut.write("\tret\n\n")
hOut.close()

keys = [x for x in words.keys()]
keys.sort()
hOut = open(".."+os.sep+"kernel"+os.sep+"temp"+os.sep+"__dictionary.asm","w")
for k in keys:
	hOut.write("\tdb  {0}+5\n".format(len(k)))
	hOut.write("\tdb  $20\n")
	hOut.write("\tdw  {0}\n".format(words[k]))
	hOut.write("\tdb  {0},\"{1}\"\n".format(len(k),k))
	hOut.write("\n")
hOut.write("\tdb  0\n\n")


hOut.close()