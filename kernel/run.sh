sh build.sh
python ../scripts/importcode.py demo.flat
wine ../bin/CSpect.exe -zxnext -brk -esc -w3 ../files/bootloader.sna
