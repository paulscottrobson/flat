sh build.sh
python ../scripts/importcode.py test.flat
MONO_IOMAP=all mono ../bin/CSpect.exe -zxnext -cur -brk -exit -w3  ../files/bootloader.sna
