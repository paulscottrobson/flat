@echo off
rem
rem		Tidy up
rem
del /Q temp\*.*
del /Q boot.img
rem
rem		Build the bootloader
rem
pushd ..\bootloader
call build.bat
popd
rem
rem		Build the source files
rem
python ..\scripts\processcore.py
..\bin\snasm -next -vice kernel.asm boot.img