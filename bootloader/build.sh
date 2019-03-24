#
#		Delete old files
#
rm bootloader.sna 
rm ../files/bootloader.sna
#
#		Assemble bootloader
#
zasm -buw bootloader.asm -l bootloader.lst bootloader.sna
#
#		Copy to file area if exists
#
if [ -e bootloader.sna ]
then
	cp bootloader.sna ../files
fi



