; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		data.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		15th November 2018
;		Purpose :	Data area
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;									System Information
;
; ***************************************************************************************

SystemInformationTable:

SINextFreeCode: 									; +0 	Next Free Code Byte
		dw 		FreeMemory,0
SINextFreeCodePage: 								; +4 	Next Free Code Byte Page
		dw 		FirstCodePage,0
SIBootCodeAddress:									; +8	Run from here
		dw 		CompilerTest,0
SIBootCodePage: 									; +12   Run page.
		db		FirstCodePage,0,0,0
SIWord:												; +16 	Work word, used in fill/copy/etc
		dw 		0,0 			
SIDisplayInformation:								; +20 	Display Information structure address
		dw 		DIScreenWidth,0
SIStack:											; +24 	Initial Z80 stack value
		dw 		StackTop,0							
		
; ***************************************************************************************
;
;								 Other data and buffers
;
; ***************************************************************************************

PAGEStackPointer: 									; stack used for switching pages
		dw 		0
PAGEStackBase:
		ds 		16
;
;			Display Information
;
DIScreenWidth:										; +0 	Screen Width
		dw 		0,0
DIScreenHeight:										; +4 	Screen Height
		dw 		0,0
DIScreenSize: 										; +8    Screen Size in Characters
		dw 		0,0
DIScreenDriver:										; +12 	Screen Driver
		dw 		0,0 								
DIFontBase:											; +16 	768 byte font, begins with space
		dw 		AlternateFont,0 							
DIScreenMode:										; +20 	Current Mode
		dw 		0,0

		org 	$A000
FreeMemory:		
