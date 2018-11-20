# *********************************************************************************
# *********************************************************************************
#
#		File:		makewordasm.py
#		Purpose:	Build word assembly file from core words.
#		Date : 		20th November 2018
#		Author:		paul@robsons.org.uk
#
# *********************************************************************************
# *********************************************************************************

import os,re,sys
print("Scanning for core words.")
#
#		Get list of word files.
#
fileList = []
for root,dirs,files in os.walk("."):
	for f in [x for x in files if x[-6:] == ".words"]:
		fileList.append(root+os.sep+f)
fileList.sort()
#
#		Now process them
#
hOut = open("__words.asm","w")
hOut.write(";\n; Generated.\n;\n")
wordCount = 0
for f in fileList:
	unclosedWord = None
	for l in [x.rstrip().replace("\t"," ") for x in open(f).readlines()]:
		#print(l)
		#
		#		Look for @<marker>.<wrapper> <word> or @end
		#
		if l != "" and l[0] == ";" and l.find("@") >= 0 and l.find("@") < 4:
			m = re.match("^\;\s+\@([\w\.]+)\s*(.*)$",l)
			assert m is not None,l+" syntax ?"
			marker = m.group(1).lower().strip()
			word = m.group(2).lower().strip()
			#
			#		Quick check.
			#
			assert marker == "copies.only" or marker == "copies" or marker == "word" or marker == "end",l
			#print(marker,word)
			#
			#		If it isn't end, create an executable with the wrapper
			#
			if marker != "end":
				wordCount += 1
				assert unclosedWord is None,"Not closed at "+l
				unclosedWord = ("_".join(["{0:02x}".format(ord(x)) for x in word]))
				hOut.write("; =========== {0} {1} ===========\n\n".format(word,marker))
				hOut.write("flatwordmarker_"+unclosedWord+":\n")
				if marker == "word":
					hOut.write("    call COMCompileCallToFollowing\n")
				else:
					size = "en_flat_{0}-st_flat_{0}".format(unclosedWord)
					if marker == "copies.only":
						size = size + "+$80"
					hOut.write("    ld  b,{0}\n".format(size))
					hOut.write("    call COMCopyFollowingCode\n")

				hOut.write("st_flat_"+unclosedWord+":\n")
			#
			#		If it is an end, mark the end if it is a generator, then complete
			# 		the wrapper from the start. Then for generators create a macro word
			# 		which creates he code to copy the word.
			#
			else:
				assert unclosedWord is not None
				hOut.write("en_flat_"+unclosedWord+":\n")
				unclosedWord = None
		else:
			hOut.write(l+"\n")
hOut.close()
print("\tScanned {0} words.".format(wordCount))
