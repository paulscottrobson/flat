; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   miscellany.src
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   12th March 2019
;  Purpose : Miscellaneous words
;
; ***************************************************************************************
; ***************************************************************************************



; ********* , word *********

define_2c:
	nop
	call COMPCompileSelf
	jp   FARCompileWord

; ***************************************************************************************



; ********* ; macro *********

define_3b:
	nop
	call COMPMacroExpand
	ld b,end_3b-start_3b
start_3b:
	ret
end_3b:
	ret

; ***************************************************************************************



; ********* c, word *********

define_63_2c:
	nop
	call COMPCompileSelf
	ld   a,l
	jp   FARCompileWord

; ***************************************************************************************



; ********* param! word *********

define_70_61_72_61_6d_21:
	call COMPCompileSelf
	ld   (Parameter),hl

; ***************************************************************************************



; ********* copy word *********

define_63_6f_70_79:
	call COMPCompileSelf
	ld   bc,(Parameter)
	ld   a,b
	or   c
	ret  z

	push  bc          ; BC count
	push  de          ; DE target
	push  hl          ; HL source

	xor  a          ; Clear C
	sbc  hl,de         ; check overlap ?
	jr   nc,__copy_gt_count      ; if source after target
	add  hl,de         ; undo subtract

	add  hl,bc         ; add count to HL + DE
	ex   de,hl
	add  hl,bc
	ex   de,hl
	dec  de          ; dec them, so now at the last byte to copy
	dec  hl
	lddr           ; do it backwards
	jr   __copy_exit

__copy_gt_count:
	add  hl,de         ; undo subtract
	ldir          ; do the copy
__copy_exit:
	pop  hl          ; restore registers
	pop  de
	pop  bc
	ret

; ***************************************************************************************



; ********* fill word *********

define_66_69_6c_6c:
	call COMPCompileSelf
	ld   bc,(Parameter)
	ld   a,b         ; exit if C = 0
	or   c
	ret  z

	push  bc          ; BC count
	push  de          ; DE target, L byte
__fill_loop:
	ld   a,l         ; copy a byte
	ld   (de),a
	inc  de          ; bump pointer
	dec  bc          ; dec counter and loop
	ld   a,b
	or   c
	jr   nz,__fill_loop
	pop  de          ; restore
	pop  bc
	ret

; ***************************************************************************************



; ********* halt word *********

define_68_61_6c_74:
	nop
	call COMPCompileSelf
__halt_loop:
	di
	halt
	jr   __halt_loop

; ***************************************************************************************



; ********* break macro *********

define_62_72_65_61_6b:
	nop
	call COMPMacroExpand
	ld b,end_62_72_65_61_6b-start_62_72_65_61_6b
start_62_72_65_61_6b:
	db   $DD,$01
end_62_72_65_61_6b:
	ret

