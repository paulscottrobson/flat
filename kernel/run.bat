@echo off
call build.bat
python ..\scripts\importcode.py standard.flat test.flat
..\bin\CSpect.exe -zxnext -cur -brk -exit -w3  ..\files\bootloader.sna