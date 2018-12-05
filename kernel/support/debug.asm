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

DEBUGShowWord:
		call 	COMUCompileCallToSelf
DEBUGShow:
		push 	af 									; save registers
		push 	bc
		push 	de
		push 	hl

		push 	bc 									; push CBA
		push 	de
		push 	hl

		ld 		hl,(__DIScreenSize) 				; calculate 32 off bottom of screen
		ld 		de,-32
		add 	hl,de
		ex 		de,hl
		push 	de 									; save it
		ld 		hl,3 								; set screen position
		call 	SystemHandler
		ld 		b,32 								; count
__DEBUGSSClear:
		ld 		hl,4
		ld 		de,$0400
		call 	SystemHandler
		djnz 	__DEBUGSSClear

		pop 	de 									; restore the bottom of screen
		ld 		hl,3 								; set screen position
		call 	SystemHandler

		pop 	de 									; pop off stack and print
		call 	__DEBUGPrintNumber
		ld 		de,$0600
		call 	__DEBUGPrintCharacter

		pop 	de
		call 	__DEBUGPrintNumber
		ld 		de,$0600
		call 	__DEBUGPrintCharacter

		pop 	de
		call 	__DEBUGPrintNumber
		ld 		de,$0600
		call 	__DEBUGPrintCharacter

		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		ret

__DEBUGPrintCharacter:
		push 	hl 									; seperating space.
		push 	de
		ld 		hl,4
		call 	SystemHandler
		pop 	de
		pop 	hl
		ret
;
;		Print integer DE
;
__DEBUGPrintNumber:
		push 	bc
		push 	de
		push 	hl

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
		ld 		de,$0600+'-'
		bit 	7,b
		jr 		z,__DSDDNoMinus
		call 	__DEBUGPrintCharacter
__DSDDNoMinus:
		pop 	hl
		pop 	de
		pop 	bc
		ret

__DSSDisplayRecursive:
		ld 		hl,10
		call 	DIVDivideMod16
		push 	hl
		ld 		a,d
		or 		e
		call 	nz,__DSSDisplayRecursive
		pop 	de
		ld 		a,e
		add 	a,48
		ld 		e,a
		ld 		d,6
		call 	__DEBUGPrintCharacter
		ret