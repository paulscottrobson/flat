; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		constant.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		20th November 2018
;		Purpose :	ASCII -> Integer conversion.
;
; ***************************************************************************************
; ***************************************************************************************

; ***********************************************************************************************
;
;			Convert ASCIIZ string at HL to constant in HL. DE 0, Carry Clear if true
;									Uses Colorforth's backend - format.
;
; ***********************************************************************************************

CONSTConvert:
	push 	bc

	ex 		de,hl 									; string in DE.
	ld 		hl,$0000								; result in HL.
	inc 	de 										; skip over the tag
	ld 		c,0										; C is the negate flag
__CONConvLoop:
	ld 		a,(de)									; get next character
	inc 	de

	cp 		'0'										; must be 0-9 otherwise
	jr 		c,__CONConFail
	cp 		'9'+1
	jr 		nc,__CONConFail

	push 	bc
	push 	hl 										; HL -> BC
	pop 	bc
	add 	hl,hl 									; HL := HL * 4 + BC 
	add 	hl,hl
	add 	hl,bc 						
	add 	hl,hl 									; HL := HL * 10
	ld 		b,0 									; add the digit into HL
	and 	15
	ld 		c,a
	add 	hl,bc
	pop 	bc

	ld 		a,(de) 									; check ends in -
	cp 		'-'									
	jr 		z,__CONMinusExit 						
	bit 	7,a 									; check done everything.
	jr 		z,__CONConvLoop
	jr 		__CONNotNegative

__CONMinusExit:
	inc 	de 										; if not the last, it's an error.
	ld 		a,(de)
	bit 	7,a
	jr		z,__CONConFail

	ld 		a,h 									; negate HL
	cpl 	
	ld 		h,a
	ld 		a,l
	cpl
	ld 		l,a
	inc 	hl

__CONNotNegative:
	ld 		de,$0000
	xor 	a 										; clear carry
	pop 	bc
	ret

__CONConFail: 										; didn't convert
	ld 		hl,$FFFF
	ld 		de,$FFFF
	scf
	pop 	bc
	ret

	