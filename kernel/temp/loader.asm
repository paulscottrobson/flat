; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   loader.src
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   19th March 2019.
;  Purpose : Loads in source pages
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;      Load in Pages from A until stopped.
;
; ***************************************************************************************



; ********* loadfrom word *********

define_6c_6f_61_64_66_72_6f_6d:
	call COMPCompileSelf

LOADLoadPages:

	push  de          ; save registers
	push  hl
	push  ix
	call  LOADGetPageAndAddress     ; convert to page and address

	ld   hl,$AA01
	ld   de,$BB02

__LOADPageLoop:
	call  LOADProcessPage      ; process Page A from IX to End.
	ld   ix,$C000        ; reset IX to start of next buffer
	add  a,2         ; go to next 16k page pair.
	cp   FirstSourcePage+SourcePageCount  ; reached the end.
	jr   nz,__LOADPageLoop      ; go back.
	jp   CommandLineStart


; ***************************************************************************************
;
;       Process Page A from IX to End
;
; ***************************************************************************************

LOADProcessPage:
	push  af          ; save A IX
	push  ix
	call  PAGESwitch        ; switch to that page
__LOADPLoop:
	ld   a,(ix+0)        ; look at first character on page
	cp   $80         ; is there something here ?
	jr   z,__LOADPNext       ; if not, go to next.
	push  ix          ; save current position

	push  de          ; save DE and HL
	push  hl
	ld   de,EditBuffer       ; copy IX into edit buffer
	push  ix
	pop  hl
	ld   bc,EditPageSize
	ldir
	pop  hl          ; restore HL and DE
	pop  de
	ld   ix,EditBuffer       ; start processing from the edit buffer/

__LOADPDoLoop:
	ld   a,(ix+0)       ; get first tag
	cp   $80         ; end ?
	jr   z,__LOADPDoExit      ; then exit

	call  PROProcessTaggedWord     ; do - something with it.

	ld   a,(ix+0)       ; get length into BC
	and  $3F
	ld   c,a
	ld   b,$00
	add  ix,bc         ; go to next word
	inc  ix          ; +1 for the tag byte
	jr   __LOADPDoLoop

__LOADPDoExit:
	pop  ix          ; restore current position
__LOADPNext:
	ld   bc,EditPageSize      ; go to next page
	add  ix,bc         ; until reached the end.
	jr   nc,__LOADPLoop       ; until done the pages to $0000.
	call  PAGERestore
	pop  ix          ; restore A IX
	pop  af
	ret

; ***************************************************************************************
;
;     Convert a page number in HL to an address in IX, and page in A.
;
; ***************************************************************************************

LOADGetPageAndAddress:
	push  hl          ; save HL twice
	push  hl
	ld   a,l         ; get offset in page (32 source pages/page)
	and  31
	add  a,a         ; 2 x offset, x 512 by putting it in H
	add  a,$C0         ; offset from $C000
	ld   h,a
	ld   l,$00
	push  hl          ; copy into IX.
	pop  ix
	pop  hl          ; this is the page number / 32 x 2
	srl  h
	rr   l
	srl  h
	rr   l
	srl  h
	rr   l
	srl  h
	rr   l
	srl  h
	rr   l
	add  hl,hl         ; HL now contains the offset.
	ld   a,l         ; get in A
	add  a,FirstSourcePage      ; offset from first source page
	pop  hl          ; restore HL
	ret           ; and exit


