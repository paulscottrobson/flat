# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		makebootstrap.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		3rd December 2018
#		Purpose :	Make bootstrap file
#
# ***************************************************************************************
# ***************************************************************************************

import labels
#
#		Get all relevant labels
#
labels = labels.LabelExtractor("code.bin.vice").getLabels()
words = [x for x in labels.keys() if x[:6] == "start_"]
words.sort()
binary = [x for x in open("code.bin","rb").read(-1)]
#
#		Process each one.
#
hOut = open("bootstrap.flat","w")
hOut.write("//\n//    Generated.\n//\n")
for word in words:
	name = "".join([chr(int(x,16)) for x in word[6:].split("_")])
	wType = name[-1]
	name = name[:-2]
	codeBegin = labels[word]
	codeEnd = labels[word.replace("start","end")]
	code = binary[codeBegin:codeEnd]
	if wType == "w":
		genCode = " ".join(["[{0}] [c,]".format(x) for x in code])
	else:
		genCode = "compiles "+" ".join(["{0} c,".format(x) for x in code])
	genCode = ":"+name+" "+genCode+" [201] [c,] "
	#print(name,wType,codeBegin,codeEnd,code)
	#print(genCode)
	hOut.write(genCode+"\n\n")
hOut.close()
