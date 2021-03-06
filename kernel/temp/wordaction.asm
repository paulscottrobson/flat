; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   wordaction.src
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   12th March 2019
;  Purpose : Routines that belong to word code
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;       Compile a reference to self.
;
; ***************************************************************************************

COMPCompileSelf:
	ex   (sp),hl        ; HL is the address, old HL on top of stack
	ld  a,$CD         ; call opcode
	call  FARCompileByte       ; compile that
	call  FARCompileWord       ; compile the address
	pop  hl          ; restore old HL
	ret

; ***************************************************************************************
;
;         Compile Macro Code
;
; ***************************************************************************************

COMPMacroExpand:
	ex   (sp),hl        ; HL is the address, old HL on top of stack
	inc  hl          ; skip over the LD B,xx opcode
	ld   b,(hl)         ; read count
__COMPMExLoop:
	inc  hl          ; get next byte to copy
	ld   a,(hl)
	call  FARCompileByte       ; compile that
	djnz  __COMPMExLoop      ; do it B times.
	pop  hl          ; restore old HL
	ret


