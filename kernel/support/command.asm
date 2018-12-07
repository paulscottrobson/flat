; *********************************************************************************
; *********************************************************************************
;
;		File:		command.asm
;		Purpose:	Command line code
;		Date : 		6th December 2018
;		Author:		paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************

CommandLineStart:
		ld 		hl,__CLIWelcome
		ld 		d,5
		jr 		Continue
WarmStart:
		ld 		hl,__CLIWarmStart
		ld 		d,4
		jr 		Continue
ErrorHandler:
		ld 		d,2
Continue:
		ld 		sp,StackTop							; reset Z80 Stack
		push 	hl
		push 	de
		ld 		a,FirstCodePage 					; get the page to start and reset the paging.
		call 	PAGEInitialise
		ld 		bc,ExecuteBuffer 					; reset exec pointer
		ld 		(__COMExecBufferPointer),bc


		ld		hl,(ARegister)						; display memory copies
		ld 		de,(BRegister)
		call 	DEBUGShow

		ld 		hl,(__DIScreenSize)					; clear the 2nd to last row (on 32 chars)
		ld		de,-64
		add 	hl,de
		ld 		b,32
__CLIClear:
		ld 		de,$0520
		call 	GFXWriteCharacter
		inc 	hl
		djnz 	__CLIClear
		ld 		de,-16 								; half way across that row
		add 	hl,de

		pop 	de 									; get colour
		pop 	bc 									; retrieve message
__CLIMessage:
		ld 		a,(bc) 								; display message till -ve or 0
		or 		a
		jr 		z,__CLIMessageEnd
		jp 		m,__CLIMessageEnd
		ld 		e,a 								; display char in red
		call 	GFXWriteCharacter
		inc 	hl 									; advance pos and message
		inc		bc
		jr 		__CLIMessage
__CLIMessageEnd:

		ld 		hl,(__DIScreenSize)					; bakck to start of 2nd to last row
		ld		de,-64
		add 	hl,de
		ld 		ix,__CLIBuffer 						; IX points to buffer
__CLILoop:
		ld 		de,$057F 							; display prompt
		call 	GFXWriteCharacter
		call 	__CLIGetKey 						; get key
		cp 		13 									; exec on CR
		jr 		z,__CLIExecute
		cp 		' ' 								; exec on space
		jr 		z,__CLIExecute
		jp 		c,WarmStart 						; any other < ' ' warm start e.g. start again

		ld 		(ix+0),a 							; save char in buffer
		ld 		d,6 								; draw it
		ld 		e,a
		call 	GFXWriteCharacter

		ld 		a,l 								; reached 15 chars, don't add
		and 	15
		cp 		15
		jr 		z,__CLILoop
		inc 	hl 									; move forward
		inc 	ix
		jr 		__CLILoop

__CLIExecute:
		ld 		(ix+0),$80 							; add end marker to tagged word
		ld 		a,l 								; get length
		and 	15
		jr 		z,__CLILoop 						; if zero nothing to execute
		or 		$A0 								; make it a 1 10 lllll tag
		ld 		bc,__CLIBuffer-1 					; put before buffer
		ld 		(bc),a
		call 	COMCompileWordInBuffer 				; compile this
		ld 		hl,(ARegister) 						; execute it with the registers loaded
		ld 		de,(BRegister)
		call 	__CallIX
		ld 		(BRegister),de 						; save the registers
		ld 		(ARegister),hl
		jp 		WarmStart


__CLIGetKey:
		call 	__CLIGetChange
		or 		a
		jr 		z,__CLIGetKey
		ret
__CLIGetChange:
		push 	bc
		ld 		a,(__CLICurrentKey)
		ld 		b,a
__CLIChangeLoop:
		call 	IOScanKeyboard
		cp 		b
		jr 		z,__CLIChangeLoop
		ld 		(__CLICurrentKey),a
		pop 	bc
		ret






__CLIWelcome:
		db 		"flat 06-Dec-18",$00
__CLIWarmStart:
		db 		"ready",$00
