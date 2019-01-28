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



; ********* push macro *********

define_70_75_73_68:
	nop
	call COMPMacroExpand
	ld b,end_70_75_73_68-start_70_75_73_68
start_70_75_73_68:
	push  hl
end_70_75_73_68:
	ret



; ********* pop macro *********

define_70_6f_70:
	nop
	call COMPMacroExpand
	ld b,end_70_6f_70-start_70_6f_70
start_70_6f_70:
	ex   de,hl
	pop  hl
end_70_6f_70:
	ret

; ***************************************************************************************



; ********* a>r macro *********

define_61_3e_72:
	nop
	call COMPMacroExpand
	ld b,end_61_3e_72-start_61_3e_72
start_61_3e_72:
	push  hl
end_61_3e_72:
	ret



; ********* r>a macro *********

define_72_3e_61:
	nop
	call COMPMacroExpand
	ld b,end_72_3e_61-start_72_3e_61
start_72_3e_61:
	pop  hl
end_72_3e_61:
	ret

; ***************************************************************************************



; ********* b>r macro *********

define_62_3e_72:
	nop
	call COMPMacroExpand
	ld b,end_62_3e_72-start_62_3e_72
start_62_3e_72:
	push  de
end_62_3e_72:
	ret



; ********* r>b macro *********

define_72_3e_62:
	nop
	call COMPMacroExpand
	ld b,end_72_3e_62-start_72_3e_62
start_72_3e_62:
	pop  de
end_72_3e_62:
	ret

; ***************************************************************************************



; ********* ab>r macro *********

define_61_62_3e_72:
	nop
	call COMPMacroExpand
	ld b,end_61_62_3e_72-start_61_62_3e_72
start_61_62_3e_72:
	push  de
	push  hl
end_61_62_3e_72:
	ret



; ********* r>ab macro *********

define_72_3e_61_62:
	nop
	call COMPMacroExpand
	ld b,end_72_3e_61_62-start_72_3e_61_62
start_72_3e_61_62:
	pop  hl
	pop  de
end_72_3e_61_62:
	ret
