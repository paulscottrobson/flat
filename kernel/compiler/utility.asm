; ********************************************************************************************************
; ********************************************************************************************************
;
;		Name : 		utility.asm
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Purpose : 	Utility functions.
;		Date : 		19th November 2018
;
; ********************************************************************************************************
; ********************************************************************************************************

; ********************************************************************************************************
; ********************************************************************************************************
;
;		Name : 		computils.asm
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Purpose : 	Compiler utilities
;		Date : 		20th November 2018
;
; ********************************************************************************************************
; ********************************************************************************************************

; ********************************************************************************************************
;
;								  Compile code inline following me, B bytes
;
; ********************************************************************************************************
		
COMCopyFollowingCode:
		ld 		a,b
		and 	$7F
		pop 	bc										; pop the address off the stack.
		push 	hl
		ld 		l,c
		ld 		h,b
		ld 		b,a
__COMCFCLoop:
		ld 		a,(hl)									; read the byte
		inc 	hl
		call 	FARCompileByte 							; compile inline
		djnz 	__COMCFCLoop
		pop 	hl
		ret

; ********************************************************************************************************
;
;									Compile call to code following me.
;
; ********************************************************************************************************

COMCompileCallToFollowing:
		pop 	bc
		push 	hl
		;
		;		Paging if *both* in $C000-$FFFF but the pages are different.
		;		Or if calling from < $C000 to >= $C000 (e.g. the execute code)
		;
		ld 		a,$CD 									; compile CALL opcode
		call 	FARCompileByte
		ld 		h,b
		ld 		l,c
		call 	FARCompileWord 							; compile address
		pop 	hl
		ret


