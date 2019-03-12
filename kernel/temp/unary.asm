; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   unary.src
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   12th March 2019
;  Purpose : Unary operators (A ? B -> A)
;
; ***************************************************************************************
; ***************************************************************************************



; ********* -- macro *********

define_2d_2d:
	call COMPMacroExpand
	ld b,end_2d_2d-start_2d_2d
start_2d_2d:
	dec  hl
end_2d_2d:
	ret

; ***************************************************************************************



; ********* --- macro *********

define_2d_2d_2d:
	call COMPMacroExpand
	ld b,end_2d_2d_2d-start_2d_2d_2d
start_2d_2d_2d:
	dec  hl
	dec  hl
end_2d_2d_2d:
	ret

; ***************************************************************************************



; ********* ++ macro *********

define_2b_2b:
	call COMPMacroExpand
	ld b,end_2b_2b-start_2b_2b
start_2b_2b:
	inc  hl
end_2b_2b:
	ret

; ***************************************************************************************



; ********* +++ macro *********

define_2b_2b_2b:
	call COMPMacroExpand
	ld b,end_2b_2b_2b-start_2b_2b_2b
start_2b_2b_2b:
	inc  hl
	inc  hl
end_2b_2b_2b:
	ret

; ***************************************************************************************



; ********* 0- word *********

define_30_2d:
	call COMPCompileSelf
__negate:
	ld   a,h
	cpl
	ld   h,a
	ld   a,l
	cpl
	ld   l,a
	inc  hl
	ret

; ***************************************************************************************



; ********* 0< word *********

define_30_3c:
	call COMPCompileSelf
	bit  7,h
	ld   hl,$0000
	ret  z
	dec  hl
	ret

; ***************************************************************************************



; ********* 0= word *********

define_30_3d:
	call COMPCompileSelf
	ld   a,h
	or   l
	ld   hl,$0000
	ret  nz
	dec  hl
	ret

; ***************************************************************************************



; ********* 2* macro *********

define_32_2a:
	call COMPMacroExpand
	ld b,end_32_2a-start_32_2a
start_32_2a:
	add  hl,hl
end_32_2a:
	ret



; ********* 4* macro *********

define_34_2a:
	call COMPMacroExpand
	ld b,end_34_2a-start_34_2a
start_34_2a:
	add  hl,hl
	add  hl,hl
end_34_2a:
	ret



; ********* 8* macro *********

define_38_2a:
	call COMPMacroExpand
	ld b,end_38_2a-start_38_2a
start_38_2a:
	add  hl,hl
	add  hl,hl
	add  hl,hl
end_38_2a:
	ret



; ********* 16* macro *********

define_31_36_2a:
	call COMPMacroExpand
	ld b,end_31_36_2a-start_31_36_2a
start_31_36_2a:
	add  hl,hl
	add  hl,hl
	add  hl,hl
	add  hl,hl
end_31_36_2a:
	ret

; ***************************************************************************************



; ********* 2/ macro *********

define_32_2f:
	call COMPMacroExpand
	ld b,end_32_2f-start_32_2f
start_32_2f:
	sra  h
	rr   l
end_32_2f:
	ret



; ********* 4/ macro *********

define_34_2f:
	call COMPMacroExpand
	ld b,end_34_2f-start_34_2f
start_34_2f:
	sra  h
	rr   l
	sra  h
	rr   l
end_34_2f:
	ret

; ***************************************************************************************



; ********* abs word *********

define_61_62_73:
	call COMPCompileSelf
	bit  7,h
	ret  z
	jp   __negate

; ***************************************************************************************



; ********* bswap macro *********

define_62_73_77_61_70:
	call COMPMacroExpand
	ld b,end_62_73_77_61_70-start_62_73_77_61_70
start_62_73_77_61_70:
	ld   a,l
	ld   l,h
	ld   h,a
end_62_73_77_61_70:
	ret

; ***************************************************************************************



; ********* not word *********

define_6e_6f_74:
	call COMPCompileSelf
	ld   a,h
	cpl
	ld   h,a
	ld   a,l
	cpl
	ld   l,a
	ret
