; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   binary.src
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   12th March 2019
;  Purpose : Binary operators (A ? B -> A)
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************



; ********* < word *********

define_3c:
	call COMPCompileSelf
	ld   a,h           ; check if signs different.
	xor  d
	add  a,a          ; CS if different
	jr   nc,__less_samesign
	ld   a,d          ; different. set CS to sign of B
	add  a,a          ; if set (negative) B must be < A as A is +ve
	jr   __less_returnc
__less_samesign:
	push  de           ; save DE
	ex   de,hl          ; -1 if B < A
	sbc  hl,de          ; calculate B - A , hencs CS if < (Carry clear by add a,a)
	pop  de           ; restore DE
__less_returnc:
	ld   a,0          ; A 0
	sbc  a,0          ; A $FF if CS.
	ld   l,a          ; put in HL
	ld   h,a
	ret

; ***************************************************************************************



; ********* = word *********

define_3d:
	call COMPCompileSelf
	ld   a,h          ; H = H ^ D
	xor  d
	ld   h,a
	ld   a,l          ; A = (L ^ E) | (H ^ D)
	xor  e
	or   h           ; if A == 0 they are the same.
	ld   hl,$0000         ; return 0 if different
	ret  nz
	dec  hl           ; return -1
	ret

; ***************************************************************************************



; ********* - word *********

define_2d:
	call COMPCompileSelf
	push  de           ; save DE
	ex   de,hl          ; HL = B, DE = A
	xor  a            ; clear carry
	sbc  hl,de          ; calculate B-A
	pop  de           ; restore DE
	ret

; ***************************************************************************************



; ********* * word *********

define_2a:
	call COMPCompileSelf
	jp   MULTMultiply16

; ***************************************************************************************



; ********* / word *********

define_2f:
	call COMPCompileSelf
	push  de
	call  DIVDivideMod16
	ex   de,hl
	pop  de
	ret

; ***************************************************************************************



; ********* + macro *********

define_2b:
	call COMPMacroExpand
	ld b,end_2b-start_2b
start_2b:
	add  hl,de
end_2b:
	ret

; ***************************************************************************************



; ********* and word *********

define_61_6e_64:
	call COMPCompileSelf
	ld   a,h
	and  d
	ld   h,a
	ld   a,l
	and  e
	ld   l,a
	ret

; ***************************************************************************************



; ********* mod word *********

define_6d_6f_64:
	call COMPCompileSelf
	push  de
	call  DIVDivideMod16
	pop  de
	ret

; ***************************************************************************************



; ********* or word *********

define_6f_72:
	call COMPCompileSelf
	ld   a,h
	or   d
	ld   h,a
	ld   a,l
	or   e
	ld   l,a
	ret

; ***************************************************************************************



; ********* xor word *********

define_78_6f_72:
	call COMPCompileSelf
	ld   a,h
	xor  d
	ld   h,a
	ld   a,l
	xor  e
	ld   l,a
	ret

