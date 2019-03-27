; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   dictionary.src
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   12th March 2019.
;  Purpose : Dictionary handler.
;
; ***************************************************************************************
; ***************************************************************************************

; ***********************************************************************************************
;
;  Add Dictionary Word. Name is a tagged string at BC ends in $80-$FF.
;  Uses the current page/pointer values.
;
; ***********************************************************************************************

DICTAddWord:
	push  af          ; registers to stack.
	push  bc
	push  de
	push hl
	push  ix

	push  bc          ; put word address in HL
	pop  hl

	ld   a,(hl)         ; get length from tag into B
	and  $3F
	ld   b,a
	inc  hl          ; HL = first character of word to be added.

	ld   a,DictionaryPage     ; switch to dictionary page
	call  PAGESwitch

	ld   ix,$C000       ; IX = Start of dictionary

__DICTFindEndDictionary:
	ld   a,(ix+0)        ; follow down chain to the end
	or   a
	jr   z,__DICTCreateEntry
	ld   e,a         ; go to next.
	ld   d,0
	add  ix,de
	jr   __DICTFindEndDictionary

__DICTCreateEntry:         ; IX now points to the 0 which ends the dictionary.
	ld   a,b
	add  a,5
	ld   (ix+0),a        ; offset is length + 5

	ld   a,(HerePage)      ; code page
	ld   (ix+1),a

	ld   de,(Here)        ; code address
	ld   (ix+2),e
	ld   (ix+3),d

	ld   (ix+4),b        ; put length in offset 4

	ex   de,hl         ; put address of name in DE
__DICTAddCopy:
	ld   a,(de)         ; copy byte over as 7 bit ASCII.
	ld   (ix+5),a
	inc  ix
	inc  de
	djnz __DICTAddCopy       ; until string is copied over, e.g. B bytes

	ld   (ix+5),0        ; write end of dictionary zero.

	call  PAGERestore

	pop  ix          ; restore and exit
	pop  hl
	pop  de
	pop  bc
	pop  af
	ret

; ***********************************************************************************************
;
;   Find word in dictionary. BC points to tagged string which is the name.
;
;   On exit, HL is the address and DE the page number with CC if found,
;   CS set and HL=DE=0 if not found.
;
; ***********************************************************************************************

DICTFindWord:
	push  bc         ; save registers - return in DEHL Carry
	push  ix

	ld   h,b        ; put address of name in HL.
	ld   l,c        ; this points to the length/type tag.

	ld   a,DictionaryPage     ; switch to dictionary page
	call  PAGESwitch

	ld   ix,$C000       ; dictionary start
__DICTFindMainLoop:
	ld   a,(ix+0)      ; examine offset, exit if zero as we have searched the lot.
	or   a
	jr   z,__DICTFindFail

	ld   a,(ix+4)       ; length of the word being checked.
	xor  (hl)        ; xor with tag length
	and  $3F        ; check lower 6 bits
	jr   nz,__DICTFindNext     ; if different can't be this word as different lengths.

	push  ix         ; save pointers on stack.
	push  hl

	ld   a,(ix+4)      ; get the word length to test into B
	and  $3F
	ld   b,a
	inc  hl         ; skip over tag byte
__DICTCheckName:
	ld   a,(ix+5)       ; compare dictionary vs character.
	cp   (hl)        ; compare vs the matching character.
	jr   nz,__DICTFindNoMatch    ; no, not the same word.
	inc  hl         ; HL point to next character
	inc  ix
	djnz  __DICTCheckName     ; do for B characters.

	pop  hl         ; Found a match. restore HL and IX
	pop  ix

	ld   d,0        ; D = 0
	ld   e,(ix+1)      ; E = page#
	ld   l,(ix+2)      ; HL = address
	ld   h,(ix+3)
	xor  a         ; clear the carry flag.
	jr   __DICTFindExit

__DICTFindNoMatch:        ; this one doesn't match.
	pop  hl         ; restore HL and IX
	pop  ix
__DICTFindNext:
	ld   e,(ix+0)      ; DE = offset to next word
	ld   d,$00
	add  ix,de        ; IX now points to next word.
	jr   __DICTFindMainLoop    ; and try the next one.

__DICTFindFail:
	ld   de,$0000       ; return all zeros.
	ld   hl,$0000
	scf          ; set carry flag
__DICTFindExit:
	push  af         ; restore original page, preserving carry flag.
	call  PAGERestore
	pop  af
	pop  ix         ; pop registers and return.
	pop  bc
	ret

; ***********************************************************************************************
;
;      Remove underscore prefixed words from the dictionary.
;
; ***********************************************************************************************



; ********* dict.crunch word *********

define_64_69_63_74_2e_63_72_75_6e_63_68:
	call COMPCompileSelf

DICTCrunchDictionary:
	push  bc
	push  de
	push hl
	push  ix

	ld   a,DictionaryPage     ; switch to dictionary page
	call  PAGESwitch
	ld   ix,$C000       ; dictionary start
__DICTCrunchNext:
	ld   a,(ix+0)
	or   a
	jr   z,__DICTCrunchExit
	ld   a,(ix+5)       ; check first character
	cp   '_'        ; if not _, try next
	jr   nz,__DICTCrunchAdvance

	push  ix
	pop   de         ; DE = start position
	ld   l,(ix+0)      ; HL = start + offset
	ld   h,0
	add  hl,de
	ld   a,h        ; BC = count
	cpl
	ld   b,a
	ld   a,l
	cpl
	ld   c,a
	ldir          ; copy it
	jr   __DICTCrunchNext     ; retry from the same position.

__DICTCrunchAdvance:       ; go to next slot.
	ld   e,(ix+0)      ; DE = offset
	ld   d,0
	add  ix,de        ; go gorward
	jr   __DICTCrunchNext

__DICTCrunchExit:
	pop  ix
	pop  hl
	pop  de
	pop  bc
	ret


