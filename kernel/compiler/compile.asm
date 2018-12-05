; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		compile.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		4th December 2018
;		Purpose :	Compiler code
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;					Compile/Execute word in BC. A and B are in DEHL
;
; ***************************************************************************************

COMCompileWord:
		ld 		a,(bc) 								; get the tag
		and 	$60 								; mask out the tag type
		jr 		z,__COMCRedTag00
		cp 		$20
		jr 		z,__COMCGreenTag01
		cp 		$40
		jr 		z,__COMCYellowTag10
		ret
;
;		Come here to fail with the tag in BC
;
COMError:											; error, BC points to tag
		push 	bc
		pop 	hl		
		inc 	hl 									; skip tag header
		jp 		ErrorHandler
;
;		Red word. Add to dictionary and compile default header.
;		
__COMCRedTag00:
		call 	DICTAddWord 						; add BC to dictionary
		push 	hl
		ld 		a,$CD 								; compile standard header
		call 	FARCompileByteA
		ld 		hl,COMUCompileCallToSelf 			; compiles call to self
		call 	FARCompileWord
		pop 	hl
		ret
;
;		Green word - word is executed under self compilation rule, if it's a constant
; 		or string appropriate code is generated.
;
__COMCGreenTag01:
		call 	COMCompileCodeAtHereForBC 			; compile the code for it
		ret 										; and exit
;
;		Yellow word - compile in workspace, and execute that code. Check to see HERE
; 		is not modified by the code compilation, this won't work as we changed HERE
;		anyway.
;
__COMCYellowTag10:
		push 	ix
		call 	COMCompileWordInBuffer 				; compile code in the buffer
		call 	__CallIX 							; call it
		call 	COMBufferReleaseSpace
		pop 	ix
		ret

__CallIX:
		jp 		(ix)

; ***************************************************************************************
;
;					Compile the word at BC at here. A and B are in DEHL
;
; ***************************************************************************************

COMCompileCodeAtHereForBC:
		push 	bc 									; save BC and IX
		push 	ix

		push 	hl 									; save A/B
		push 	de
		call 	DICTFindWord 						; try to find the word ?
		jr 		nc,__COMCCWordFound
		inc 	bc 									; check for string ?
		ld 		a,(bc)
		dec 	bc
		cp 		'"'
		jr 		z,__COMCCString
		call 	CONSTConvert 						; is it a number ?
		jp 		c,COMError 							; no we have an error
		jr 		__COMCCConstant
;
;		Compile as a string
;
__COMCCString:
		ld 		a,$18 								; JR <length>
		call 	FARCompileByteA 					; the length is the same - lose the ", gain the NULL
		ld 		a,(bc)
		and 	$1F
		call 	FARCompileByteA
		ld 		hl,(Here) 							; save HERE which will be the constant
		push 	hl 					
		dec 	a 									; but we do one character less
		jr 		z,__COMCCNull 						; quote on its own is null string
		ld 		e,a 							
		inc 	bc 									; points to "
__COMCCCopy:
		inc 	bc
		ld 		a,(bc)
		cp 		'_'									; map _ to space
		jr 		nz,__COMCCNotBar
		ld 		a,' '
__COMCCNotBar:
		call 	FARCompileByteA
		dec 	e
		jr 		nz,__COMCCCopy
__COMCCNull:
		xor 	a 									; compile NULL
		call 	FARCompileByteA
		pop 	hl 									; restore HERE
		jr 		__COMCCConstant 					; and compile constant.
;
;		Compile word in HL as a constant
;
__COMCCConstant:
		call 	COMUCompileConstant 				; compile HL as constant
		pop 	de 									; restore A/B
		pop 	hl
		pop 	ix 									; pop registers and exit
		pop 	bc
		ret
;
;		Found a word. Address is in EHL
;
__COMCCWordFound:
		ld 		a,e 								; switch page
		call 	PAGESwitch
		pop 	de 									; restore B
		pop 	bc 									; restore A to BC temporarily
		ld 		ix,__COMCCContinue 					; push continue address on stack
		push 	ix
		push 	hl 									; push code address on stack
		ld 		h,b 								; copy BC -> HL
		ld 		l,c
		ret 										; call code, then return to __COMCCContinue
__COMCCContinue:
		call 	PAGERestore 						; restore old page.
		pop 	ix 									; restore BC and IX
		pop 	bc
		ret 										; and exit.

; ***************************************************************************************
;
;					Compile word at BC in buffer. Return buffer pointer in IX
;
; ***************************************************************************************

COMCompileWordInBuffer:
		ld 		ix,(Here) 							; push HERE on the stack
		push 	ix

		ld 		ix,(__COMExecBufferPointer) 		; point IX to the execute buffer area
		push 	ix 									; save on the stack
		push 	bc 									; add 32 to it.
		ld 		bc,32
		add 	ix,bc
		ld 		(__COMExecBufferPointer),ix 		; and write back for reentrancy.
		pop 	bc 			
		pop 	ix 									; IX is now the current value to use
		ld 		(Here),ix 							; so point here to it.

		call 	COMCompileCodeAtHereForBC 			; do the actual compilation 
		ld 		a,$C9								; compile a RET
		call 	FARCompileByteA

		ex 		(sp),ix 							; restore and save HERE
		ld 		(Here),ix
		pop 	ix 									; restore address of code
		ret 										; and exit

; ***************************************************************************************
;
;			Release space allocated for execution of the word in buffer
;
; ***************************************************************************************

COMBufferReleaseSpace:
		push 	hl
		push 	de
		ld 		hl,(__COMExecBufferPointer)
		ld 		de,-32
		add 	hl,de
		ld 		(__COMExecBufferPointer),hl
		pop 	de
		pop 	hl
		ret
		pop 	bc


