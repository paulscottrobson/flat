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
	jr   z,__PRODefinition      ; $00 is a RED definition
	cp   $40         ; $40 is a GREEN compilation
	jr   z,__PROCompilation
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
;  Handle a Green word, by calling it if it exists to self compile, otherwise try as a
;  constant, compiling load constant code.
;
__PROCompilation:
	exx           ; temporarily put AB in alternate registers.
	push  ix          ; put the word address in BC
	pop  bc
	call  DICTFindWord       ; look it up.
	jr   c,__PROComTryConstant     ; not found, try as a constant.
;
	call  __PROExecute       ; Execute E:HL with the a values in the alternate register
	exx           ; restore the AB values
	ret
;
__PROComTryConstant:
	db   $DD,$01
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
;  Error
;
__PROCError:           ; can't process word.
	jr   __PROCError
;
;  Execute E:HL using A/B values in HL' and DE'
;
__PROExecute:
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
