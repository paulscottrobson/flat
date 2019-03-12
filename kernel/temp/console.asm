; *********************************************************************************
; *********************************************************************************
;
;  File:  console.src
;  Purpose: con.raw words.
;  Date :   12th March 2019
;  Author:  paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************



; ********* con.raw.setmode word *********

define_63_6f_6e_2e_72_61_77_2e_73_65_74_6d_6f_64_65:
	call COMPCompileSelf
	jp   GFXMode



; ********* con.raw.char! word *********

define_63_6f_6e_2e_72_61_77_2e_63_68_61_72_21:
	call COMPCompileSelf
	jp   GFXWriteCharacter



; ********* con.raw.hex! word *********

define_63_6f_6e_2e_72_61_77_2e_68_65_78_21:
	call COMPCompileSelf
	jp   GFXWriteHexWord



; ********* con.raw.inkey word *********

define_63_6f_6e_2e_72_61_77_2e_69_6e_6b_65_79:
	call COMPCompileSelf
	ex   de,hl
	call  IOScanKeyboard       ; read keyboard
	ld   l,a
	ld   h,$00
	ret
