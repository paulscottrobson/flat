; ********************************************************************************************************
; ********************************************************************************************************
;
;		Name : 		loader.asm
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Purpose : 	Source loader
;		Date : 		19th November 2018
;
; ********************************************************************************************************
; ********************************************************************************************************

; ********************************************************************************************************
;
;									Load the bootstrap page
;
; ********************************************************************************************************

LOADBootstrap:
		ld 		a,BootstrapPage 					; set the current page to bootstrap page.
		call 	PAGESwitch
		ld 		ix,$C000 							; current section being loaded.
		ld 		c,0 								; used to display progress.
		ld 		hl,$A456 							; helps with debugging.
		ld 		de,$B123
;
;		Once here for every 'chunk'. We copy the text to the editor buffer in 
;		chunks (currently 1024 bytes) until we've done all 16k of the page.
;
__LOADBootLoop:
		push 	de 									; save A registers
		push 	hl

		push 	ix 									; HL = Current Section
		pop 	hl
		ld 		de,EditBuffer  						; Copy to edit buffer 1/2k (512 bytes) of code.
		ld 		bc,512
		ldir 	

		ld 		h,0 								; Progress prompt.
		ld 		a,ixh
		rrca
		and 	31
		ld 		l,a
		ld 		de,$052A
		call 	GFXWriteCharacter

		pop 	hl 									; restore A & B
		pop 	de
		ld 		bc,EditBuffer 						; now scan the edit buffer
		call 	LOADScanBuffer 

		ld 		bc,512 								; add 512 size to IX
		add 	ix,bc
		push 	ix									; until wrapped round to $0000
		pop 	bc
		bit 	7,b
		jr 		nz,__LOADBootLoop

__LOADEnds:
		call 	PAGERestore 						; restore page
		jp 		HaltZ80 							; and stop
		
; ********************************************************************************************************
;
;					Process (compiling) the text at BC. A and B are in HL/DE
; 
; ********************************************************************************************************

LOADScanBuffer:
		push 	af
		push 	bc
		push 	ix

__LOADScanLoop:
		ld 		a,(bc) 								; look at tage
		cp 		$FF 								; was it $FF ?
		jr 		z,__LOADScanExit 					; if so, we are done.

		call 	COMCompileExecute 					; execute text at BC.

__LOADNextWord: 									; look for the next bit 7 high.
		inc 	bc 									; advance forward to next word.
		ld 		a,(bc)
		bit 	7,a
		jr 		z,__LOADNextWord
		jr 		__LOADScanLoop 

__LOADScanExit:
		pop 	ix
		pop 	bc
		pop 	af
		ret
