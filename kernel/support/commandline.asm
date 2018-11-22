; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		commandline.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		21st November 2018
;		Purpose :	Command line handler.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;								Command Line Warm Start
;
; ***************************************************************************************

StartSystem:
		call 	LOADBootstrap						; boot up
		call 	GFXClearScreen 						; clear the screen
		ld 		hl,SystemIntroMessage
;
;					Come here with message to be shown in HL
;
ErrorHandler: 										; handle error, message is at HL
		ld 		sp,(SIStack)						; reset stack
		push 	hl 									; save message
;
;		Clear bottom lines
;
		ld 		hl,(DIScreenSize)					; clear the bottom 2 lines.
		ld 		de,-64
		add 	hl,de
__CLIClearLoop:
		ld 		de,$0720
		call 	GFXWriteCharacter
		inc 	hl
		djnz 	__CLIClearLoop
;
;		Display error message
;
		pop 	bc  								; error message into BC
		ld 		hl,(DIScreenSize)  					; error message from bottom-48 onwards.
		ld 		de,-48
		add 	hl,de
__CLIDisplayMessage:
		ld 		a,(bc)
		ld 		e,a
		add 	a,a
		jr 		c,__CLIDisplayAB 					; bit 7 set
		jr 		z,__CLIDisplayAB 					; or zero
		ld 		d,2
		call 	GFXWriteCharacter
		inc 	hl
		inc 	bc
		jr 		__CLIDisplayMessage
;
;		Show A and B
;
__CLIDisplayAB: 									; display A and B
		ld 		hl,(DIScreenSize)
		ld 		bc,-32
		add 	hl,bc
		ld 		de,(COMARegister)
		call 	__CLIDisplayDecimal

		ld 		bc,8
		add 	hl,bc
		ld 		de,(COMBRegister)
		call 	__CLIDisplayDecimal
;
;		Enter the command line
;
__CLIEnterCommandLine:
		ld 		hl,(DIScreenSize) 					; HL = start of entry
		ld 		de,-64
		add 	hl,de
		ld 		ix,CLIBuffer 						; IX = character position.

__CLILoop:
		ld 		de,$047F 							; write the cursor out
		call 	GFXWriteCharacter 					
		call 	CLIGetKey 							; key get
		cp 		8
		jr 		z,__CLIBackspace
		cp 		13
		jr		z,__CLIExecuteWord
		cp 		32 									; execute on space or return
		jr		z,__CLIExecuteWord
		jr 		c,__CLILoopBack 					; any control clears word

		ld 		(ix+0),a 							; put in buffer
		ld 		e,a 								; display on screen
		ld 		d,6
		call 	GFXWriteCharacter
		ld 		a,l 								; check reached limit
		and 	$1F
		cp 		$1E
		jr 		z,__CLIEnterCommandLine
		inc 	hl 									; go round again with one extra character
		inc 	ix
		jr 		__CLILoop
;
__CLIBackspace:
		ld 		a,l 								; at start ?
		and 	$3F
		jr 		z,__CLILoop
		ld 		de,$0120 							; clear current
		call 	GFXWriteCharacter
		dec 	hl 									; back one
		dec 	ix
		jr 		__CLILoop
;
;		Execute word in buffer
;
__CLIExecuteWord:
		ld 		(ix+0),$FF 							; set end of word marker
		ld 		bc,CLIBuffer-1
		call 	COMCompileExecute
__CLILoopBack:
		ld 		hl,SystemEmptyMessage
		jp 		ErrorHandler

SystemIntroMessage:
		db 		"Flat 21-11-18"
SystemEmptyMessage:
		db 		" ",$FF

;
;		Display DE in Decimal at HL
;
__CLIDisplayDecimal:
		push 	bc
		push 	de
		push 	hl
		push 	de
		bit 	7,d
		jr 		z,__CLIDDNotNegative
		ld 		a,d
		cpl 
		ld 		d,a
		ld 		a,e
		cpl 
		ld 		e,a
		inc 	de
__CLIDDNotNegative:
		call 	__CLIDisplayRecursive
		pop 	bc
		ld 		de,$0500+'-'
		bit 	7,b
		call 	nz,GFXWriteCharacter
		pop 	hl
		pop 	de
		pop 	bc
		ret

__CLIDisplayRecursive:
		push 	hl
		ld 		hl,10
		call 	DIVDivideMod16
		ex 		(sp),hl
		ld 		a,d
		or 		e
		call 	nz,__CLIDisplayRecursive
		pop 	de
		ld 		a,e
		add 	a,48
		ld 		e,a
		ld 		d,5
		call 	GFXWriteCharacter
		inc 	hl
		ret
;
;		Get keystroke into A (No repeating)
;
CLIGetKey:
		push 	bc
__CLIWaitChange:
		call 	__CLIGetKeyboardChange
		or 		a
		jr 		z,__CLIWaitChange
		pop 	bc
		ret

__CLIGetKeyboardChange:
		call 	IOScanKeyboard
		ld 		b,a
		ld 		a,(CLILastKeyboardState)
		cp 		b
		jr 		z,__CLIGetKeyboardChange
		ld 		a,b
		ld 		(CLILastKeyboardState),a
		ret

		