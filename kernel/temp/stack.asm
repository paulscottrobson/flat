; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   stack.src
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   28th January 2019
;  Purpose : Stack words
;
; ***************************************************************************************
; ***************************************************************************************



; ********* push lock macro *********

define_70_75_73_68_20_6c_6f_63_6b:
	nop
	call COMPMacroExpand
	ld b,end_70_75_73_68_20_6c_6f_63_6b-start_70_75_73_68_20_6c_6f_63_6b
start_70_75_73_68_20_6c_6f_63_6b:
	push  hl
end_70_75_73_68_20_6c_6f_63_6b:
	ret



; ********* pop lock macro *********

define_70_6f_70_20_6c_6f_63_6b:
	nop
	call COMPMacroExpand
	ld b,end_70_6f_70_20_6c_6f_63_6b-start_70_6f_70_20_6c_6f_63_6b
start_70_6f_70_20_6c_6f_63_6b:
	ex   de,hl
	pop  hl
end_70_6f_70_20_6c_6f_63_6b:
	ret

; ***************************************************************************************



; ********* a>r lock macro *********

define_61_3e_72_20_6c_6f_63_6b:
	nop
	call COMPMacroExpand
	ld b,end_61_3e_72_20_6c_6f_63_6b-start_61_3e_72_20_6c_6f_63_6b
start_61_3e_72_20_6c_6f_63_6b:
	push  hl
end_61_3e_72_20_6c_6f_63_6b:
	ret



; ********* r>a lock macro *********

define_72_3e_61_20_6c_6f_63_6b:
	nop
	call COMPMacroExpand
	ld b,end_72_3e_61_20_6c_6f_63_6b-start_72_3e_61_20_6c_6f_63_6b
start_72_3e_61_20_6c_6f_63_6b:
	pop  hl
end_72_3e_61_20_6c_6f_63_6b:
	ret

; ***************************************************************************************



; ********* b>r lock macro *********

define_62_3e_72_20_6c_6f_63_6b:
	nop
	call COMPMacroExpand
	ld b,end_62_3e_72_20_6c_6f_63_6b-start_62_3e_72_20_6c_6f_63_6b
start_62_3e_72_20_6c_6f_63_6b:
	push  de
end_62_3e_72_20_6c_6f_63_6b:
	ret



; ********* r>b lock macro *********

define_72_3e_62_20_6c_6f_63_6b:
	nop
	call COMPMacroExpand
	ld b,end_72_3e_62_20_6c_6f_63_6b-start_72_3e_62_20_6c_6f_63_6b
start_72_3e_62_20_6c_6f_63_6b:
	pop  de
end_72_3e_62_20_6c_6f_63_6b:
	ret

; ***************************************************************************************



; ********* ab>r lock macro *********

define_61_62_3e_72_20_6c_6f_63_6b:
	nop
	call COMPMacroExpand
	ld b,end_61_62_3e_72_20_6c_6f_63_6b-start_61_62_3e_72_20_6c_6f_63_6b
start_61_62_3e_72_20_6c_6f_63_6b:
	push  de
	push  hl
end_61_62_3e_72_20_6c_6f_63_6b:
	ret



; ********* r>ab lock macro *********

define_72_3e_61_62_20_6c_6f_63_6b:
	nop
	call COMPMacroExpand
	ld b,end_72_3e_61_62_20_6c_6f_63_6b-start_72_3e_61_62_20_6c_6f_63_6b
start_72_3e_61_62_20_6c_6f_63_6b:
	pop  hl
	pop  de
end_72_3e_61_62_20_6c_6f_63_6b:
	ret
