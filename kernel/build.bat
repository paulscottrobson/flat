@echo off
rem
rem		Tidy up
rem
del /Q boot.img
del /Q ..\files\boot.img
del /Q boot.img.vice
rem
rem		Build the bootloader
rem
pushd ..\bootloader
call build.bat
popd
rem
rem		Build the assembler file with the vocabulary
rem
pushd ..\vocabulary
call build.bat
popd
rem
rem		Assemble the kernel
rem
..\bin\snasm -vice kernel.asm boot.img
rem
rem		Insert vocabulary into the image file.
rem
if exist boot.img python ..\scripts\makedictionary.py
rem
rem		Copy it out
rem
if exist boot.img copy boot.img ..\files
