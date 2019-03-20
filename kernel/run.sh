sh build.sh
python ../scripts/importcode.py standard.flat test.flat
MONO_IOMAP=all mono ../bin/CSpect.exe -zxnext -cur -brk -exit -w3  ../files/bootloader.sna
