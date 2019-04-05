sh build.sh
#
#		Create a dummy boot.img file
#
rm boot.img
python makedemoimage.py

if [ -e bootloader.sna ]
then
	MONO_IOMAP=all mono ../bin/CSpect.exe -zxnext -cur -brk -exit -w3 bootloader.sna 
fi

