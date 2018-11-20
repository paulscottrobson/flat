@echo off
del __words.asm ..\kernel\temp\__words.asm
python ..\scripts\makewordasm.py
copy __words.asm ..\kernel\temp


