sh build.sh
python ../scripts/importcode.py demo.flat
wine ../bin/cspect.exe -zxnext -brk -esc -w3 ../files/bootloader.sna 2>/dev/null
