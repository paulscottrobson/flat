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

CompilerTest:
		ld 		de,$B045
		ld 		hl,$A156
		ld 		bc,0
		call 	COMCompileBuffer
w1: 	jr 		w1

; ***************************************************************************************
;
;					Compile the buffer given in BC. DE/HL are B and A
;
; ***************************************************************************************

COMCompileBuffer:
		db 		$DD,$01
		call 	BUFFindBuffer 						; A:BC is the buffer page/address
		call 	BUFLoadBuffer 						; load buffer into edit buffer.
		ld 		bc,EditBuffer 						; now process it.
__COMCBTag:
		ld 		a,(bc) 								; look at the first word
		cp 		$FF 								; reached the end ?
		ret 	z 									; exit having compiled.

		ld 		a,(bc)
		cp 		$82 								; red (defining word)
		call 	z,COMDefinition_Red
		cp 		$83 								; magenta (defining word)
		call 	z,COMDefinition_Magenta	
		cp 		$84 								; green (compile) word
		call 	z,COMCompileWord_Green
		cp 		$86 								; yellow (execute) word
		call 	z,COMExecuteWord_Yellow
__COMCBNext: 										; go to the next tag/end (bit 7 set)
		inc 	bc
		ld 		a,(bc)
		bit 	7,a
		jr 		z,__COMCBNext
		jr 	__COMCBTag 								

COMDefinition_Red:
COMDefinition_Magenta:
		push 	de
		push 	hl

		pop 	hl
		pop 	de
		ret

COMCompileWord_Green:
		push 	de
		push 	hl

		pop 	hl
		pop 	de
		ret

COMExecuteWord_Yellow:
		ret