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
	push 	ix

	ld 		a,(bc) 									; look at the tag
	cp 		$82 									; $82 = red word (definition + header)
	jr 		z,__COMCDefine
	cp 		$83 									; $83 = magenta word (definition only)
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
	pop 	ix
	pop 	bc
	ret

; =======================================================================================
;
;			Red define. Add the word to the dictionary at HERE and do the prefix
;					Magenta define. Add the word to HERE only.
;
; =======================================================================================

__COMCDefine:
	push 	de 										; save A + B current values.
	push 	hl
	ld 		h,b 									; add the word to the dictionary.
	ld 		l,c
	call 	DICTAddWord
	ld 		a,(bc) 									; re-check the tag
	cp 		$83
	jr 		z,__COMCDefineNoHeader 					; if it is $83 Magenta then no header.
	ld 		a,$CD 									; CALL opcode
	call 	FARCompileByte
	ld 		hl,COMCompileCallToFollowing 			; address of self-compiling routine.
	call 	FARCompileWord
__COMCDefineNoHeader:
	pop 	hl 										; restore A + B current values
	pop 	de
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
	push 	de 										; A and B are not changed.
	push 	hl 
	call 	DICTFindWord 							; find the word ?
	jr 		nc,__COMCWExecute 						; create the code to execute this word.
	call 	CONSTConvert 							; does it convert to a number ?
	jr 		c,__COMCFail 							; if not, fail.
;
;		This code compiles the code to load in as a constant
;
__COMCWConstant:
	ld 		a,$EB 									; compile EX DE,HL
	call 	FARCompileByte
	ld 		a,$21 									; compile LD HL,xxxxx
	call 	FARCompileByte
	call 	FARCompileWord 							; compile address
	pop 	hl 											
	pop 	de
	ret
;
;		This code compiles the code to call the word by .... calling the word.
;
__COMCWExecute:
	ld 		a,e 									; switch to the page
	call 	PAGESwitch
	push 	hl 										; put execution address in IX.
	pop 	ix
	pop 	hl 										; restore registers
	pop 	de
	call 	__COMCWCallIX 							; call (ix)
	call 	PAGERestore 							; restore the page
	ret

__COMCWCallIX:
	jp 		(ix)

; =======================================================================================
;
;		Yellow Execute - use the compiler to create code that executes it, then
; 		call it.
;				
; =======================================================================================

__COMCExecute:
	db 		$DD,$01
	push 	de 										; save A and B
	push 	hl 

	ld 		hl,(SINextFreeCode) 					; save the next free code
	push 	hl
	ld 		hl,ExecuteCodeBuffer 					; point here the execute code buffer
	ld 		(SINextFreeCode),hl

	call 	COMCompileWord 							; compile the code, whatever it is.
	ld 		a,$C9 									; followed by RET.
	call 	FARCompileByte 

	pop 	hl 										; restore the next free code
	ld 		(SINextFreeCode),hl

	pop 	hl 										; restore A + B
	pop 	de  
	call 	ExecuteCodeBuffer 						; execute the code buffer.
	jp 		__COMCExitOkay

