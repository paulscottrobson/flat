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


StartSystem:
		call 	LOADBootstrap						; boot up
		ld 		hl,SystemIntroMessage
ErrorHandler: 										; handle error, message is at HL
		ld 		sp,(SIStack)						; reset stack
		push 	hl 									; save message

		ld 		hl,(DIScreenSize)					; clear the bottom 2 lines.
		ld 		de,64
		xor 	a
		sbc 	hl,de
		ld 		b,e
__CLIClearLoop:
		ld 		de,$0720
		call 	GFXWriteCharacter
		inc 	hl
		djnz 	__CLIClearLoop

		pop 	bc  								; error message into BC
		ld 		hl,(DIScreenSize)  					; error message from bottom-48 onwards.
		xor 	a
		ld 		de,48
		sbc 	hl,de
__CLIDisplayMessage:
		ld 		a,(bc)
		ld 		e,a
		add 	a,a
		jr 		c,__CLIDisplayAB
		ld 		d,2
		call 	GFXWriteCharacter
		inc 	hl
		inc 	bc
		jr 		__CLIDisplayMessage

__CLIDisplayAB: 									; display A and B

w1:		jr 		w1

SystemIntroMessage:
		db 		"Flat 21-11-18"
SystemEmptyMessage:
		db 		" ",$FF


