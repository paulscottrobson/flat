# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		makerandomimage.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		12th March 2019
#		Purpose :	Creates a dummy boot.img which has BRK at $8000
#
# ***************************************************************************************
# ***************************************************************************************

memory = [0xDD,0x01]
h = open("boot.img","wb")							# write out the dummy boot image file
h.write(bytes(memory))
h.close()

