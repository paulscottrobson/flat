; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		kernel.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		16th November 2018
;		Purpose :	FlatColorForth Kernel
;
; ***************************************************************************************
; ***************************************************************************************

StackTop   = 	$7EF0 								; Top of stack
EditBuffer = $7B08 									; 512 byte edit buffer (2 bytes either side)
ErrorMessageBuffer = $7D10

DictionaryPage = $20 								; dictionary page
BootstrapPage = $22 								; bootstrap page
FirstCodePage = $24 								; first page of actual code.

		org 	$8000 								; $8000 boot.
		jr 		Boot
		org 	$8004 								; $8004 address of sysinfo
		dw 		SystemInformationTable
		org 	$8010								; $8010 loads word into BC
		ld 		bc,(SIWord)
		ret

Boot:	ld 		sp,(SIStack)						; reset Z80 Stack
		di											; disable interrupts
	
		db 		$ED,$91,7,2							; set turbo port (7) to 2 (14Mhz speed)
		ld 		l,1 								; set graphics mode 0 (48k Spectrum)
		call 	GFXMode

		ld 		a,(SIBootCodePage) 					; get the page to start
		call 	PAGEInitialise
		ld 		hl,(SIBootCodeAddress) 				; get boot address
		jp 		(hl) 								; and go there

ErrorHandler: 										; arrive here with message in ASCII with bit 7 set following
		jr 		ErrorHandler
		
COMCopyFollowingCode:
COMCompileCallToFollowing:
		ret

		include "support/paging.asm" 				; page switcher (not while executing)
		include "support/farmemory.asm" 			; far memory routines
		include "support/divide.asm" 				; division
		include "support/multiply.asm" 				; multiplication
		include "support/graphics.asm" 				; common graphics
		include "support/keyboard.asm"
		include "support/screen48k.asm"				; screen "drivers"
		include "support/screen_layer2.asm"
		include "support/screen_lores.asm"

		include "compiler/loader.asm"				; loads in bootstrap code
		include "compiler/dictionary.asm"			; dictionary add/update routines.

		include "temp/__words.asm" 					; and the actual words

AlternateFont:										; nicer font
		include "font.inc" 							; can be $3D00 here to save memory

		include "data.asm"		

		org 	$C000
		db 		0 									; start of dictionary, which is empty.
