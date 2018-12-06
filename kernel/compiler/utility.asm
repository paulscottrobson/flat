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

; ***************************************************************************************
;
;				Compile code to call code following this call's return address
;
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

; ***************************************************************************************
;
;							Compile code to load constant
;
; ***************************************************************************************

COMUCompileConstant:
		ld 		a,$EB 								; EX DE,HL
		call 	FARCompileByteA
		ld 		a,$21								; LD HL,xxxx
		call 	FARCompileByteA
		call 	FARCompileWord						; compile constant
		ret

; ***************************************************************************************
;
;			Compile code to copy A bytes from code following caller (for MACRO)
;
; ***************************************************************************************

COMUCopyCode:
		pop 	bc 									; BC = code to copy
		push 	de 									; save E
		ld 		e,a 								; E = count
__COMUCopyLoop:
		ld 		a,(bc) 								; read a byte
		call 	FARCompileByteA 					; compile it
		inc 	bc 									; next byte
		dec 	e 									; do E bytes
		jr 		nz,__COMUCopyLoop
		pop 	de 									; restore E and exit
		ret
