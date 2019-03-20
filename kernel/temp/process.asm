; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   process.src
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   19th March 2019.
;  Purpose : Process a word
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;    Process a word at IX, with A=HL B=DE as per usual.
;
; ***************************************************************************************

PROProcessTaggedWord:
	ld   a,(ix+0)       ; Check type
	and  $C0         ; strip off length leaving tag
	jr   z,__PRODefinition      ; $00 is RED definition
	cp   $40         ; $40 is GREEN compilation
	jr   z,__PROCompilation
	cp   $80         ; $80 is YELLOW execution
	jr   z,__PROExecution
	ret
;
;  Handle a RED word (definition), by adding a dictionary reference and a self-compile
;  call.
;
__PRODefinition:
	push  ix          ; copy word address into BC
	pop  bc
	call  DICTAddWord       ; add the definition in
	ld   a,$CD          ; Z80 call instruction.
	call  FARCompileByte
	push  hl
	ld   hl,COMPCompileSelf      ; compile self address.
	call  FARCompileWord
	pop  hl
	ret
;
;  Handle a GREEN word, by calling it if it exists to self compile, otherwise try as a
;  constant, compiling load constant code.
;
__PROCompilation:
	exx           ; temporarily put AB in alternate registers.
	push  ix          ; put the word address in BC
	pop  bc
	call  DICTFindWord       ; look it up.
	jr   c,__PROComTryConstant     ; not found, try as a constant.
;
	call  __PROExecuteEHL      ; Execute E:HL with the a values in the alternate register
	exx           ; restore the AB values
	ret
;
__PROComTryConstant:
	call  CONSTEvaluate       ; evaluate as a constant.
	jr   c,__PROCError      ; not evaluatable as a constant.
	ld   a,$EB         ; compile EX DE,HL
	call  FARCompileByte
	ld   a,$21         ; compile LD HL,xxxx
	call  FARCompileByte
	ld   h,b         ; compile constant in BC
	ld   l,c
	call  FARCompileWord
	exx           ; get AB back
	ret
;
;  Handle a YELLOW word, executing it directly.
;
__PROExecution:
	exx           ; temporarily put AB in alternate registers.
	push  ix          ; put the word address in BC
	pop  bc
	call  DICTFindWord       ; look it up.
	jr   c,__PROExeTryConstant     ; not found, try as a constant.
	ld   a,e         ; switch to page
	call  PAGESwitch
	ld   a,(hl)         ; read first byte and switch back.
	call  PAGERestore
	or   a          ; if it is zero, (NOP) you cannot execute this.
	jr   z,__PROCError       ; because it is verboten :)
	inc  hl          ; skip over the compile-caller to the actual code.
	inc  hl
	inc  hl
	call  __PROExecuteEHL      ; and execute that.
	exx            ; restore A/B and exit.
	ret
;
__PROExeTryConstant:
	call  CONSTEvaluate       ; evaluate as a constant.
	jr   c,__PROCError      ; not evaluatable as a constant.
	push  bc          ; save result
	exx           ; get A B back
	ex   de,hl         ; put A into B
	pop  hl          ; copy new value into A
	ret
;
;  Execute E:HL using A/B values in HL' and DE'
;
__PROExecuteEHL:
	ld   a,e          ; switch to the correct page
	call  PAGESwitch
	ld   bc,__PROExecuteContinue    ; return to here.
	push  bc
	push  hl          ; call here.
	exx           ; restore A/B from HL' DE'
	ret           ; call the routine.
__PROExecuteContinue:
	exx           ; save A/B back in HL' DE'
	call  PAGERestore       ; back to the original page.
	ret
;
;  Error
;
__PROCError:           ; can't process word.
	push  ix
	ld   a,(ix+0)
	and  $3F
	ld   c,a
	ld   b,0
	add  ix,bc
	ld   (ix+1),' '
	ld   (ix+2),'?'
	ld   (ix+3),'?'
	ld   (ix+4),$80
	pop  hl
	inc  hl
	jp   ErrorHandler
