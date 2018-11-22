; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		compiler.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		20th November 2018
;		Purpose :	Compile/Execute code.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;		On entry BC points to a word, which is a tag followed by text, followed by
; 		a byte with bit 7 set. A(HL) and B(DE) contain their register values
;
; ***************************************************************************************

COMCompileExecute:
	push 	bc
	push 	de
	push 	hl

	ld 		a,(bc) 									; look at the tag
	cp 		$82 									; $82 = red word (definition)
	jr 		z,__COMCDefine
	cp 		$84 									; $84 = green word (compilation)
	jr 		z,__COMCCompile
	cp 		$86 									; $86 = yellow word (execution)
	jr 		z,__COMCExecute
	cp 		$87 									; $87 = white word (comment)
	jr 		z,__COMCExitOkay

__COMCFail:
	ld 		h,b 									; put "error message" (word) in BC
	ld 		l,c
	inc 	hl 										; skip over the tag
	jp 		ErrorHandler 							; and go error.

__COMCExitOkay:
	pop 	hl
	pop 	de
	pop 	bc
	ret

; =======================================================================================
;
;					Red define. Add the word to the dictionary at HERE.
;				
; =======================================================================================

__COMCDefine:
	ld 		h,b
	ld 		l,c
	call 	DICTAddWord
	jp 		__COMCExitOkay

; =======================================================================================
;
;		Green compile. Either compile code to do A->B const->A if a number, if word
; 		in dictionary, then create code to call that.
;				
; =======================================================================================

__COMCCompile:
	call 	COMCompileWord 							; call the word which does the compiling
	jp 		__COMCExitOkay

COMCompileWord:
	ld 		h,b 									; put the word address in HL
	ld 		l,c
	call 	DICTFindWord 							; find the word ?
	jp 		nc,COMExecuteEHLInContext 				; if found, execute it to compile it.
	ld 		h,b 									; put the word address in HL
	ld 		l,c
	inc 	hl 										; string constant ?
	ld 		a,(hl)
	dec 	hl
	cp 		'"'
	jr 		z,__COMCWStringConstant
	call 	CONSTConvert 							; does it convert ?
	jr 		c,__COMCFail 							; if not, fail.
	call 	COMCompileLoadConstant 					; compile the code to put the value in
	ret 											; and return.

__COMCWStringConstant:
	inc 	hl 										; skip over the tag
	push 	hl 										; save string start
	ld 		e,-1 									; calculate length, includes the " hence -1
__COMCWLength:
	inc 	e
	inc 	hl
	bit 	7,(hl)
	jr 		z,__COMCWLength 
	ld 		a,$18 									; compile JR length+1
	call 	FARCompileByte
	ld 		a,e 									; length + 1 (for ASCIIZ)
	inc 	a
	call 	FARCompileByte

	ld 		hl,(SINextFreeCode) 					; HL = Next Free
	ex 		(sp),hl 								; push on stack, swap with string start.
__COMCWString:
	inc 	hl 										; compile string
	ld 		a,(hl)
	cp 		'_'										; convert underscore to space
	jr 		nz,__COMCWNotSpace
	ld 		a,' '
__COMCWNotSpace:	
	call 	FARCompileByte
	dec 	e
	jr 		nz,__COMCWString
	xor 	a 										; ASCIIZ terminator
	call 	FARCompileByte
	pop 	hl 										; get address of string
	call 	COMCompileLoadConstant 					; compile the code to put the address in as a constant
	ret 											; and return.

; =======================================================================================
;
;		Yellow Execute - use the compiler to create code that executes it, then
; 		call it.
;				
; =======================================================================================

__COMCExecute:
	ld 		hl,(SINextFreeCode) 					; save the next free code
	push 	hl
	ld 		hl,ExecuteCodeBuffer 					; point here the execute code buffer
	ld 		(SINextFreeCode),hl

	call 	COMCompileWord 							; compile the code, whatever it is.
	ld 		a,$C9 									; followed by RET.
	call 	FARCompileByte 

	pop 	hl 										; restore the next free code
	ld 		(SINextFreeCode),hl

	ld 		de,(COMBRegister) 						; load registers we saved when entering Compiler
	ld 		hl,(COMARegister) 	
	call 	ExecuteCodeBuffer 						; execute the code buffer.
	ld 		(COMARegister),hl 						; put registers back
	ld 		(COMBRegister),de

	jp 		__COMCExitOkay
