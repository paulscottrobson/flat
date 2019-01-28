#
#		Tidy up
#
rm temp/*
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
python ../scripts/processcore.py
zasm -buw kernel.asm -o boot.img -l boot.lst