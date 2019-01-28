sh build.sh
python ../scripts/importcode.py test.flat
wine ../bin/CSpect.exe -zxnext -cur -brk -exit -w3  ../files/bootloader.sna
