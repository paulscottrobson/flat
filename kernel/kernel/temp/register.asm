; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   register.src
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   12th March 2019
;  Purpose : Register manipulation
;
; ***************************************************************************************
; ***************************************************************************************



; ********* swap macro *********

define_73_77_61_70:
	call COMPMacroExpand
	ld b,end_73_77_61_70-start_73_77_61_70
start_73_77_61_70:
	ex   de,hl
end_73_77_61_70:
	ret

; ***************************************************************************************



; ********* a>b macro *********

define_61_3e_62:
	call COMPMacroExpand
	ld b,end_61_3e_62-start_61_3e_62
start_61_3e_62:
	ld   d,h
	ld   e,l
end_61_3e_62:
	ret




; ********* b>a macro *********

define_62_3e_61:
	call COMPMacroExpand
	ld b,end_62_3e_61-start_62_3e_61
start_62_3e_61:
	ld   h,d
	ld   l,e
end_62_3e_61:
	ret

