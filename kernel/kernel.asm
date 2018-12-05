; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		kernel.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd December 2018
;		Purpose :	Flat Kernel
;
; ***************************************************************************************
; ***************************************************************************************

;
;		Page allocation. These need to match up with those given in the page table
;		in data.asm
;													
DictionaryPage = $20 								; dictionary page
FirstSourcePage = $22 								; first page of 512 byte source pages
SourcePageCount = 4 								; number of source pages (32 pages/page)
EditPageSize = 512 									; bytes per edit page.
FirstCodePage = $22+SourcePageCount*2 				; first code page.
;
;		Memory allocated from the Unused space in $4000-$7FFF
;
EditBuffer = $7B08 									; $7B00-$7D1F 512 byte edit buffer
ExecuteBuffer = $7D20 								; $7D20-$7D5F Execute buffer
StackTop = $7EFC 									;      -$7EFC Top of stack

		opt 	zxnextreg
		org 	$8000 								; $8000 boot.
		jr 		Boot
		org 	$8004 								; $8004 address of sysinfo
		dw 		SystemInformation 
		org		$8008								; $8008 system commands.
		jp	 	SystemHandler

		org 	$8020
Boot:	ld 		sp,StackTop							; reset Z80 Stack
		di											; disable interrupts
	
		db 		$ED,$91,7,2							; set turbo port (7) to 2 (14Mhz speed)
		ld 		a,FirstCodePage 					; get the page to start
		call 	PAGEInitialise

		ld 		hl,0								; A = 0
		ld 		de,0 								; B = Mode
		call 	SystemHandler 						; Switch to that mode.

		call 	BUFFScan

w1:		jp 		w1
ErrorHandler:
		jp 		ErrorHandler

		include "support/debug.asm"					; debug display
		include "support/multiply.asm" 				; 16 bit multiply (not used in kernel)
		include "support/divide.asm" 				; 16 bit divide (not used in kernel)
		include "support/farmemory.asm" 			; far memory routines
		include "support/graphics.asm" 				; common graphics
		include "support/keyboard.asm"				; keyboard handler
		include "support/paging.asm" 				; page switcher (not while executing)
		include "support/screen48k.asm"				; screen "drivers"
		include "support/screen_layer2.asm"
		include "support/screen_lores.asm"
		include "support/system.asm"				; system calls handler

		include "compiler/buffer.asm" 				; buffer code.
		include "compiler/dictionary.asm" 			; dictionary access code
		include "compiler/constant.asm"				; ASCII -> Integer
		include "compiler/compile.asm"				; actual compiler.
		include "compiler/utility.asm"				; compiler utility functions.

AlternateFont:										; nicer font
		include "font.inc" 							; can be $3D00 here to save memory
		include "data.asm"		

