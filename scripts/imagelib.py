# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		imagelib.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date :		28th January 2019
#		Purpose :	Binary Image Library
#
# ***************************************************************************************
# ***************************************************************************************

import sys

class BinaryImage(object):
	def __init__(self,fileName = "boot.img"):
		self.fileName = fileName
		h = open(fileName,"rb")
		self.image = [x for x in h.read(-1)]
		h.close()
		self.sysInfo = self.read(0,0x8004)+self.read(0,0x8005)*256
		self.echo = True
	#
	#		Return sys.info address
	#
	def getSysInfo(self):
		return self.sysInfo 
	#
	#		Get paging size for buffers
	#
	def getBufferSize(self):
		return 512
	#
	#		Return dictionary page
	#
	def dictionaryPage(self):
		return 0x20
	#
	#		Return source page information
	#
	def sourcePages(self):
		return [0x22,4]
	#
	#		Convert a page/z80 address to an address in the image
	#
	def address(self,page,address):
		assert address >= 0x8000 and address <= 0xFFFF
		if address < 0xC000:
			return address & 0x3FFF
		else:
			return (page - 0x20) * 0x2000 + 0x4000 + (address & 0x3FFF)
	#
	#		Read byte from image
	#
	def read(self,page,address):
		self.expandImage(page,address)
		return self.image[self.address(page,address)]
	#
	#		Write byte to image
	#
	def write(self,page,address,data):
		self.expandImage(page,address)
		assert data >= 0 and data < 256
		self.image[self.address(page,address)] = data
		if page >= self.read(0,self.sysInfo+4):
			self.write(0,self.sysInfo+4,page+1)
	#
	#		Expand physical size of image to include given address
	#
	def expandImage(self,page,address):
		required = self.address(page,address)
		while len(self.image) <= required:
			self.image.append(0x00)
	#
	#		Write the image file out.
	#
	def save(self,fileName = None):
		fileName = self.fileName if fileName is None else fileName
		h = open(fileName,"wb")
		h.write(bytes(self.image))		
		h.close()

if __name__ == "__main__":
	z = BinaryImage()
	print(len(z.image))
	print(z.address(z.dictionaryPage(),0xC000))
	#	z.save()
