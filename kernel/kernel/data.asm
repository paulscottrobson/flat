; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		data.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		12th March 2019
;		Purpose :	Data area
;
; ***************************************************************************************
; ***************************************************************************************

__CLIWelcome:
		db 		"flat.code 190320",$00

; ***************************************************************************************
;
;								System Information
;
; ***************************************************************************************

SystemInformation:

Here:												; +0 	Here 
		dw 		FreeMemory
HerePage: 											; +2	Here.Page
		db 		FirstCodePage,0
NextFreePage: 										; +4 	Next available code page (2 8k pages/page)
		db 		FirstCodePage+2,0,0,0
DisplayInfo: 										; +8 	Display information
		dw 		DisplayInformation,0		
BootAddress:										; +12 	Boot Address
		dw 		BootDefault
BootPage:											; +14 	Boot Page
		db 		FirstCodePage,0
Parameter:	 										; +16 	3rd Parameter
		dw 		0,0		

; ***************************************************************************************
;
;							 Display system information
;
; ***************************************************************************************

DisplayInformation:

SIScreenWidth: 										; +0 	screen width
		db 		0,0,0,0	
SIScreenHeight:										; +4 	screen height
		db 		0,0,0,0
SIScreenSize:										; +8 	char size of screen
		dw 		0,0		
SIScreenMode:										; +12 	current mode
		db 		0,0,0,0
SIFontBase:											; font in use
		dw 		AlternateFont
SIScreenDriver:										; Screen Driver
		dw 		0	

; ***************************************************************************************
;
;								 Other data and buffers
;
; ***************************************************************************************

__PAGEStackPointer: 								; stack used for switching pages
		dw 		0
__PAGEStackBase:
		ds 		16


__ARegister:										; register temp for command line
		dw 		0
__BRegister:
		dw 		0
		
		dw 		0
__CLIBuffer:
		ds 		32
__CLICurrentKey:
		db 		0		