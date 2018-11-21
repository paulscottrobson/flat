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
;
;						Compile B Bytes of the code following this call.
;
; ********************************************************************************************************

COMCopyFollowingCode:
		pop 	hl
__COMCFCLoop:		
		ld		a,(hl)
		inc 	hl
		call 	FARCompileByte
		djnz 	__COMCFCLoop
		ret

; ********************************************************************************************************
;
;		  Compile code to the following address. This is being called from Here/Here.Page to A':<ret>
;
; ********************************************************************************************************

COMCompileCallToFollowing:
		pop 	bc
		push 	hl
		; TODO: If > $C000 and pages different or forward from $8xxx -> $Cxxx use paged call
		ld 		a,$CD 								; CALL xxx
		call 	FARCompileByte
		ld 		h,b
		ld 		l,c
		call 	FARCompileWord
		pop 	hl
		ret

		ret
