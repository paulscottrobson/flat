# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		makedictionary.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		16th November 2018
#		Purpose :	Extract dictionary items from listing and put in image.
#
# ***************************************************************************************
# ***************************************************************************************

import re,imagelib
from labels import *

print("Importing core words into dictionary.")
image = imagelib.FlatColorForthImage()
print(image.getCodePage())
labels = LabelExtractor("kernel.lst").getLabels()
count = 0
keys = [x for x in labels.keys() if x[:14] == "flatwordmarker"]
keys.sort(key = lambda x:labels[x])
for label in keys:
	name = "".join([chr(int(x,16)) for x in label[15:].split("_")])
	address = labels[label]
	#print(name,address)
	image.addDictionary(name,image.getCodePage(),address)
	count += 1
image.save()
print("\tImported {0} words.".format(count))
