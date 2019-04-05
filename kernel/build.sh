#
#		Tidy up
#
rm temp/*.*
rm boot.img
#
#		Build the bootloader
#
pushd ../bootloader
sh build.sh
popd
#
#		Build the source files
#
python3 ../scripts/processcore.py
zasm -buw kernel.asm -l boot.lst -o boot.img
