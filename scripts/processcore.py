# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		processcore.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		28th January 2019
#		Purpose :	Create source files for core.
#
# ***************************************************************************************
# ***************************************************************************************

import os,re,sys

dictionary = {}

def convert(sourceFile,targetFile):
	current = None
	hOut = open(targetFile,"w")
	for l in [x.rstrip().replace("\t"," ") for x in open(sourceFile).readlines()]:
		if l.startswith("@end"):
			assert current is not None
			if current != "word":
				hOut.write("end_"+scrambled+":\n")
				hOut.write("\tret\n")
			current = None

		elif l.startswith("@"):
			assert current is None
			m = re.match("^\@([a-z]+)\s*(.*)$",l)
			assert m is not None
			current = m.group(1)
			name = m.group(2)
			locked = False
			if name.endswith("lock"):
				name = name[:-4].strip()
				locked = True
			assert current == "word" or current == "macro"
			scrambled = "_".join(["{0:02x}".format(ord(c)) for c in name])
			#print(current,scrambled,m.group(2))
			hOut.write("\n\n; {0} {1} {2} {0}\n\n".format("*********",name,current))
			hOut.write("define_"+scrambled+":\n")
			if locked:
				hOut.write("\tnop\n")
			hOut.write("\tcall {0}\n".format("COMPCompileSelf" if current == "word" else "COMPMacroExpand"))
			if current != "word":
				hOut.write("\tld b,end_{0}-start_{0}\n".format(scrambled))
				hOut.write("start_"+scrambled+":\n")
			assert name not in dictionary
			dictionary[name] = "define_"+scrambled

		else:
			l = "\t"+l.strip() if l.startswith(" ") else l.strip()
			hOut.write(l+"\n")

	hOut.close()

importList = []
for root,dirs,files in os.walk("components"):
	for f in files:
		fullPath = root+os.sep+f
		if f.endswith(".asm"):
			importList.append(fullPath)
		if f.endswith(".src"):
			target = "temp"+os.sep+f.replace(".src",".asm")
			importList.append(target)
			convert(fullPath,target)

importList.sort()
importList = ["\tinclude \"{0}\"".format(x) for x in importList]
h = open("__includes.asm","w")
h.write("\n".join(importList))
h.write("\n\n")
h.close()			

words = [x for x in dictionary.keys()]
words.sort()
h = open("temp"+os.sep+"__dictionary.asm","w")
for w in words:
	h.write("\tdb {0}+5\n".format(len(w)))
	h.write("\tdb $20\n")
	h.write("\tdw {0}\n".format(dictionary[w]))
	h.write("\tdb {0}\n".format(len(w)))
	h.write("\tdb \"{0}\"\n\n".format(w))
	
h.write("\tdb 0\n")
h.close()

