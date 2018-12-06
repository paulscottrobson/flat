; *********************************************************************************
; *********************************************************************************
;
;		File:		debug.asm
;		Purpose:	Show ABC Registers
;		Date : 		4th December 2018
;		Author:		paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************

DEBUGShow:
		push 	af 									; save registers
		push 	bc
		push 	de
		push 	hl

		push 	de 									; push BA
		push 	hl

		ld 		hl,(__DIScreenSize) 				; calculate 32 off bottom of screen
		ld 		de,-32
		add 	hl,de
		push 	hl 									; save this position.

		ld 		b,32 								; count of spaces to write.
__DEBUGSSClear:
		ld 		de,$0420
		call 	GFXWriteCharacter
		inc 	hl
		djnz 	__DEBUGSSClear
		pop 	hl 									; restore the bottom of screen

		pop 	de 									; pop off stack and print
		call 	__DEBUGPrintNumber
		inc 	hl

		pop 	de
		call 	__DEBUGPrintNumber

		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		ret

;
;		Print integer DE at position HL
;
__DEBUGPrintNumber:
		push 	bc
		push 	de

		push 	de
		bit 	7,d
		jr 		z,__DSSDDNotNegative
		ld 		a,d
		cpl 
		ld 		d,a
		ld 		a,e
		cpl 
		ld 		e,a
		inc 	de
__DSSDDNotNegative:
		call 	__DSSDisplayRecursive
		pop 	bc
		bit 	7,b
		jr 		z,__DSDDNoMinus
		ld 		de,$0600+'-'
		call 	GFXWriteCharacter
		inc 	hl
__DSDDNoMinus:
		pop 	de
		pop 	bc
		ret

__DSSDisplayRecursive:
		push 	hl
		ld 		hl,10
		call 	DIVDivideMod16
		ex 		(sp),hl
		ld 		a,d
		or 		e
		call 	nz,__DSSDisplayRecursive
		pop 	de
		ld 		a,e
		add 	a,48
		ld 		e,a
		ld 		d,6
		call 	GFXWriteCharacter
		inc 	hl
		ret
