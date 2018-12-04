; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		buffer.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		4th December 2018
;		Purpose :	Scan pages for buffers.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;							Scan and compile buffers. ABC in BCDEHL
;
; ***************************************************************************************

BUFFScan:
		ld 		a,FirstSourcePage
__BUFFScanLoop:
		call 	BUFFCompile 						; compile buffer
		inc 	a 									; bump page
		inc 	a
		cp 		FirstSourcePage+SourcePageCount
		jr 		nz,__BUFFScanLoop
		ret

; ***************************************************************************************
;
;							Compile Buffer A. ABC in BCDEHL
;
; ***************************************************************************************

BUFFCompile:
		push 	af
		push 	ix

		call 	PAGESwitch							; switch to that page.
		ld 		ix,$C000 							; first block of 32 in each page.
__BUFFCompileLoop:
		ld 		a,(ix+0)							; look at the entry
		cp 		$80 								; is the first byte $80 ?
		jr 		z,__BUFFNext 						; if so, the buffer is empty

		push 	bc 									; save ABC
		push 	de 
		push 	hl

		push 	ix 									; copy IX to HL
		pop 	hl

		ld 		de,EditBuffer 						; copy that 512 byte block into edit buffer
		ld 		bc,EditPageSize
		ldir

		pop 	hl 									; restore ABC
		pop 	de
		pop 	bc

		call 	BUFFCompileEditBuffer 				; compile the buffer

__BUFFNext:
		push 	bc 									; go to next page
		ld 		bc,EditPageSize
		add 	ix,bc
		pop 	bc
		jr 		nc,__BUFFCompileLoop 				; ends on carry e.g. gone to $0000

		call 	PAGERestore 						; switch page back
		pop 	ix									; restore registers
		pop 	af
		ret

; ***************************************************************************************
;
;			   		Compile contents of the edit buffer. ABC are in BCDEHL
;
; ***************************************************************************************

BUFFCompileEditBuffer:
		push 	af									; save registers
		push 	bc
		ld 		bc,EditBuffer 						; BC points to edit buffer, this is passed in C
__BUFFCEBLoop:
		ld 		a,(bc)								; read tag
		cp 		$80 								; is it the end of buffer tag
		jr 		z,__BUFFCEBExit
		call 	COMCompileWord 						; try to compile it.
__BUFFCEBNext:
		inc 	bc 									; advance to next tag
		ld 		a,(bc)
		bit 	7,a
		jr 		z,__BUFFCEBNext
		jr 		__BUFFCEBLoop

__BUFFCEBExit:
		pop 	bc 									; pop and exit
		pop 	af
		ret

