# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		makecompasm.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		3rd December 2018
#		Purpose :	Make composite assembly file for bootstrap
#
# ***************************************************************************************
# ***************************************************************************************

import re,os,sys
#
#		Get all source
#
source = []
for root,dirs,files in os.walk("sources"):
	for f in files:
		for l in open(root+os.sep+f).readlines():
			source.append(l)
#
#		Tidy it up
#
source = [x if x.find("//") < 0 else x[:x.find("//")] for x in source]
source = [x.replace("\t"," ").rstrip() for x in source if x.strip() != ""]
#
#		Split it up into words
#
words = {}
currentWord = None
for w in source:
	if w[0] == "@":
		parts = w.split(" ")
		assert parts[-1] not in words,"Duplicate "+w
		assert parts[0] == "@word" or parts[0] == "@macro",w
		currentWord = parts[-1]
		words[currentWord] = { "type":parts[0][1:],"code":[] }

	else:
		words[currentWord]["code"].append(w)
#
#		Generate code.
#
keys = [x for x in words.keys()]
keys.sort()
hOut = open("__words.asm","w")
for w in keys:
	hOut.write("; =========== {0} {1} ===========\n\n".format(w,words[w]["type"]))
	scrambled = "_".join(["{0:02x}".format(ord(x)) for x in w])
	isMacro = words[w]["type"] == "macro"
	hOut.write("start_"+scrambled+":\n")
	if isMacro:
		hOut.write(" ld a,end_{0}-start_{0}-5\n".format(scrambled))
		hOut.write(" call COMUCopyCode\n")
	else:
		hOut.write(" call COMUCompileCallToSelf\n")
	hOut.write("\n".join(words[w]["code"])+"\n")
	hOut.write("end_"+scrambled+":\n")
	hOut.write("\n")
hOut.close()
