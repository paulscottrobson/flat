; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		utility.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		4th December 2018
;		Purpose :	Compile Utilities
;
; ***************************************************************************************
; ***************************************************************************************

COMUCompileCallToSelf:
		pop 	bc									; address to compile call to
		push 	hl 									; save HL
		ld 		a,$CD 								; Z80 Call opcode
		call 	FARCompileByteA
		ld 		h,b 								; put address in HL
		ld 		l,c
		call 	FARCompileWord						; compile it
		pop 	hl 									; restore HL and exit
		ret

COMUCompileConstant:
		ld 		a,$EB 								; EX DE,HL
		call 	FARCompileByteA
		ld 		a,$21								; LD HL,xxxx
		call 	FARCompileByteA
		call 	FARCompileWord						; compile constant
		ret

		