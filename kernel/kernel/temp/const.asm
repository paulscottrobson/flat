; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   const.src
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   19th March 2019.
;  Purpose : ASCII -> Decimal.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;     Convert constant at BC to constant in BC, CC if okay.
;
; ***************************************************************************************

CONSTEvaluate:
	push  de          ; save registers
	push  hl
	push  ix
	ld   hl,$0000        ; HL is the result.
	ld   a,(bc)         ; get the tag
	and  $3F         ; extract the length into E
	ld   e,a
__CONSTLoop:
	inc  bc          ; next character
	ld   a,(bc)         ; read it.
	cp   '-'         ; negate ?
	jr   nz,__CONSTCheckDigit     ; no, check digit.

	ld   a,h         ; negate the current result
	cpl
	ld   h,a
	ld   a,l
	cpl
	ld   l,a
	inc  hl
	jr   __CONSTNextChar      ; and get the next character.
;
__CONSTCheckDigit:
	cp   '0'         ; check if ASCII digit
	jr   c,__CONSTFail
	cp   '9'+1
	jr   nc,__CONSTFail
	and  15          ; make constant
	push  de          ; save DE
	push  af          ; save digit
	ld   e,l         ; DE = HL
	ld   d,h
	add  hl,hl         ; x 2
	add  hl,hl         ; x 4
	add  hl,de         ; x 5
	add  hl,hl         ; x 10
	pop  af          ; restore digit
	ld   e,a         ; into DE
	ld   d,0
	add  hl,de         ; and add
	pop  de          ; restore DE.
;
__CONSTNextChar:
	dec  e          ; done all
	jr   nz,__CONSTLoop
	xor  a          ; clear carry.
	ld   b,h         ; result in BC
	ld   c,l
	jr   __CONSTExit       ; and exit out.

__CONSTFail:           ; return with CS
	scf
__CONSTExit:
	pop  ix
	pop  hl
	pop  de
	ret
