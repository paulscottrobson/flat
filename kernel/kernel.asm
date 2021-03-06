; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		kernel.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		12th March 2019
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
StackTop = $7EFC 									;      -$7EFC Top of stack

		org 	$8000 								; $8000 boot.
		jr 		Boot
		org 	$8004 								; $8004 address of sysinfo
		dw 		SystemInformation 

Boot:	ld 		sp,StackTop							; reset Z80 Stack
		di											; disable interrupts
	
		db 		$ED,$91,7,2							; set turbo port (7) to 2 (14Mhz speed)
		ld 		a,FirstCodePage 					; get the page to start
		call 	PAGEInitialise

		ld 		a,0 								; set Mode 0 (standard 48k Spectrum + Sprites)
		call 	GFXMode

		ld 		a,(BootPage)						; switch to boot page.
		call 	PAGEInitialise
		ld 		ix,(BootAddress)					; start address
		ld 		hl,0								; zero AB registers
		ld 		de,0
		ld 		(Parameter),hl 						; clear parameter
		jp 		(ix) 								; and execute.

BootDefault:
		ld 		hl,$0000 							; start from page 0
		call 	LOADLoadPages 						; load pages till we stop.

StopDefault:	
		jp 		StopDefault

		ret
		
		include "__includes.asm"					; the included sources picked up by processcore.py
		include "data.asm"							; data area.

FreeMemory:											; free memory in $8000-$BFFF page.

		org 	$C000
		include "temp/__dictionary.asm" 			; dictionary.

