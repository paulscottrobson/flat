;
; =========== * ===========
;
define_2a:
	call COMCompileCallToSelf
start_2a:
	jp   MULTMultiply16
end_2a:
	ret

;
; =========== / ===========
;
define_2f:
	call COMCompileCallToSelf
start_2f:
	push  de
	ex   de,hl
	call  DIVDivideMod16
	ex   de,hl
	pop  de
	ret
end_2f:
	ret

;
; =========== mod ===========
;
define_6d_6f_64:
	call COMCompileCallToSelf
start_6d_6f_64:
	push  de
	ex   de,hl
	call  DIVDivideMod16
	pop  de
	ret
end_6d_6f_64:
	ret

;
; =========== + ===========
;
define_2b:
	call COMCopyCode
	db   end_2b-start_2b
start_2b:
	add  hl,de
end_2b:
	ret

;
; =========== - ===========
;
define_2d:
	call COMCopyCode
	db   end_2d-start_2d
start_2d:
	ld   b,h
	ld   c,l
	ld   h,d
	ld   l,e
	xor  a
	sbc  hl,bc
@word  <
	ld   a,d
	xor  h
	add  a,a
	jr   c,__SignsDifferent
	push  de
	ex   de,hl
	xor  a
	sbc  hl,de
	pop  de
	ld   hl,$0000
	ret  nc
	dec  hl
	ret
__SignsDifferent:
	bit  7,d
	ld   hl,$0000
	ret  z
	dec  hl
	ret
@word  =
	ld   a,d
	xor  h
	ld   h,a
	ld   a,e
	xor  l
	or   h
	ld   hl,$0000
	ret  nz
	dec  hl
	ret
end_2d:
	ret

;
; =========== and ===========
;
define_61_6e_64:
	call COMCompileCallToSelf
start_61_6e_64:
	ld   a,h
	and  d
	ld   h,a
	ld   a,l
	and  e
	ld   l,a
	ret
end_61_6e_64:
	ret

;
; =========== or ===========
;
define_6f_72:
	call COMCompileCallToSelf
start_6f_72:
	ld   a,h
	or   d
	ld   h,a
	ld   a,l
	or   e
	ld   l,a
	ret
end_6f_72:
	ret

;
; =========== xor ===========
;
define_78_6f_72:
	call COMCompileCallToSelf
start_78_6f_72:
	ld   a,h
	xor  d
	ld   h,a
	ld   a,l
	xor  e
	ld   l,a
	ret
end_78_6f_72:
	ret

;
; =========== ! ===========
;
define_21:
	call COMCopyCode
	db   end_21-start_21
start_21:
	ld   (hl),e
	inc  hl
	ld   (hl),d
	dec  hl
end_21:
	ret

;
; =========== @ ===========
;
define_40:
	call COMCopyCode
	db   end_40-start_40
start_40:
	ld   a,(hl)
	inc  hl
	ld   h,(hl)
	ld   l,a
end_40:
	ret

;
; =========== +! ===========
;
define_2b_21:
	call COMCompileCallToSelf
start_2b_21:
	ld   a,(hl)
	add  a,e
	ld   (hl),a
	inc  hl
	ld   a,(hl)
	adc  a,d
	ld   (hl),a
	ret
end_2b_21:
	ret

;
; =========== c! ===========
;
define_63_21:
	call COMCopyCode
	db   end_63_21-start_63_21
start_63_21:
	ld   (hl),e
end_63_21:
	ret

;
; =========== c@ ===========
;
define_63_40:
	call COMCopyCode
	db   end_63_40-start_63_40
start_63_40:
	ld   l,(hl)
	ld   h,0
end_63_40:
	ret

;
; =========== p@ ===========
;
define_70_40:
	call COMCompileCallToSelf
start_70_40:
	ld   b,h
	ld   c,l
	in   l,(c)
	ld   h,0
end_70_40:
	ret

;
; =========== p! ===========
;
define_70_21:
	call COMCopyCode
	db   end_70_21-start_70_21
start_70_21:
	ld   b,h
	ld   c,l
	out  (c),e
@macro  ;
	ret
end_70_21:
	ret

;
; =========== break ===========
;
define_62_72_65_61_6b:
	call COMCopyCode
	db   end_62_72_65_61_6b-start_62_72_65_61_6b
start_62_72_65_61_6b:
	db   $DD,$01
end_62_72_65_61_6b:
	ret

;
; =========== debug ===========
;
define_64_65_62_75_67:
	call COMCompileCallToSelf
start_64_65_62_75_67:
	jp   DEBUGShow
end_64_65_62_75_67:
	ret

;
; =========== c, ===========
;
define_63_2c:
	call COMCompileCallToSelf
start_63_2c:
	jp   FARCompileByteL
end_63_2c:
	ret

;
; =========== , ===========
;
define_2c:
	call COMCompileCallToSelf
start_2c:
	jp   FARCompileWord
end_2c:
	ret

;
; =========== copy ===========
;
define_63_6f_70_79:
	call COMCompileCallToSelf
start_63_6f_70_79:
	ld   bc,(Parameter)
	ld   a,b
	or   c
	ret  z
	push  bc
	push  de
	push  hl
	xor  a
	sbc  hl,de
	ld   a,h
	add  hl,de
	bit  7,a
	jr   z,__copy2
	ex   de,hl
	ldir
__copyExit:
	pop  hl
	pop  de
	pop  bc
	ret
__copy2:
	add  hl,bc
	ex   de,hl
	add  hl,bc
	dec  de
	dec  hl
	lddr
	jr   __copyExit
end_63_6f_70_79:
	ret

;
; =========== fill ===========
;
define_66_69_6c_6c:
	call COMCompileCallToSelf
start_66_69_6c_6c:
	ld   bc,(Parameter)
	ld   a,b
	or   c
	ret  z
	push bc
	push  hl
__fill1:ld   (hl),e
	inc  hl
	dec  bc
	ld   a,b
	or   c
	jr   nz,__fill1
	pop  hl
	pop  bc
	ret
end_66_69_6c_6c:
	ret

;
; =========== halt ===========
;
define_68_61_6c_74:
	call COMCompileCallToSelf
start_68_61_6c_74:
__HaltLoop:
	di
	halt
	jr   __HaltLoop
end_68_61_6c_74:
	ret

;
; =========== param! ===========
;
define_70_61_72_61_6d_21:
	call COMCopyCode
	db   end_70_61_72_61_6d_21-start_70_61_72_61_6d_21
start_70_61_72_61_6d_21:
	ld   (Parameter),hl
end_70_61_72_61_6d_21:
	ret

;
; =========== compiles ===========
;
define_63_6f_6d_70_69_6c_65_73:
	call COMCompileCallToSelf
start_63_6f_6d_70_69_6c_65_73:
	ld   bc,(Here)
	dec  bc
	dec  bc
	dec  bc
	ld   (Here),bc
	ret
end_63_6f_6d_70_69_6c_65_73:
	ret

;
; =========== inkey ===========
;
define_69_6e_6b_65_79:
	call COMCompileCallToSelf
start_69_6e_6b_65_79:
	ex   de,hl
	call  IOScanKeyboard
	ld   l,a
	ld   h,0
	ret
end_69_6e_6b_65_79:
	ret

;
; =========== b>a ===========
;
define_62_3e_61:
	call COMCopyCode
	db   end_62_3e_61-start_62_3e_61
start_62_3e_61:
	ld   h,d
	ld   l,e
end_62_3e_61:
	ret

;
; =========== a>b ===========
;
define_61_3e_62:
	call COMCopyCode
	db   end_61_3e_62-start_61_3e_62
start_61_3e_62:
	ld   d,h
	ld   e,l
end_61_3e_62:
	ret

;
; =========== a>r ===========
;
define_61_3e_72:
	call COMCopyCode
	db   end_61_3e_72-start_61_3e_72
start_61_3e_72:
	push  hl
end_61_3e_72:
	ret

;
; =========== b>r ===========
;
define_62_3e_72:
	call COMCopyCode
	db   end_62_3e_72-start_62_3e_72
start_62_3e_72:
	push  de
end_62_3e_72:
	ret

;
; =========== ab>r ===========
;
define_61_62_3e_72:
	call COMCopyCode
	db   end_61_62_3e_72-start_61_62_3e_72
start_61_62_3e_72:
	push  de
	push  hl
end_61_62_3e_72:
	ret

;
; =========== r>a ===========
;
define_72_3e_61:
	call COMCopyCode
	db   end_72_3e_61-start_72_3e_61
start_72_3e_61:
	pop  hl
end_72_3e_61:
	ret

;
; =========== r>b ===========
;
define_72_3e_62:
	call COMCopyCode
	db   end_72_3e_62-start_72_3e_62
start_72_3e_62:
	pop  de
end_72_3e_62:
	ret

;
; =========== r>ab ===========
;
define_72_3e_61_62:
	call COMCopyCode
	db   end_72_3e_61_62-start_72_3e_61_62
start_72_3e_61_62:
	pop  hl
	pop  de
end_72_3e_61_62:
	ret

;
; =========== swap ===========
;
define_73_77_61_70:
	call COMCopyCode
	db   end_73_77_61_70-start_73_77_61_70
start_73_77_61_70:
	ex   de,hl
end_73_77_61_70:
	ret

;
; =========== -- ===========
;
define_2d_2d:
	call COMCopyCode
	db   end_2d_2d-start_2d_2d
start_2d_2d:
	dec  hl
end_2d_2d:
	ret

;
; =========== --- ===========
;
define_2d_2d_2d:
	call COMCopyCode
	db   end_2d_2d_2d-start_2d_2d_2d
start_2d_2d_2d:
	dec  hl
	dec  hl
end_2d_2d_2d:
	ret

;
; =========== 0- ===========
;
define_30_2d:
	call COMCompileCallToSelf
start_30_2d:
	ld   a,h
	cpl
	ld   h,a
	ld   a,l
	cpl
	ld   l,a
	inc  hl
	ret
end_30_2d:
	ret

;
; =========== ++ ===========
;
define_2b_2b:
	call COMCopyCode
	db   end_2b_2b-start_2b_2b
start_2b_2b:
	inc  hl
end_2b_2b:
	ret

;
; =========== +++ ===========
;
define_2b_2b_2b:
	call COMCopyCode
	db   end_2b_2b_2b-start_2b_2b_2b
start_2b_2b_2b:
	inc  hl
	inc  hl
end_2b_2b_2b:
	ret

;
; =========== 0 ===========
;
define_30:
	call COMCompileCallToSelf
start_30:
<
	bit  7,h
	ld   hl,$0000
	ret  z
	dec  hl
	ret
end_30:
	ret

;
; =========== 0 ===========
;
define_30:
	call COMCompileCallToSelf
start_30:
=
	ld   a,h
	or   l
	ld   hl,$0000
	ret  nz
	dec  hl
	ret
end_30:
	ret

;
; =========== 2* ===========
;
define_32_2a:
	call COMCopyCode
	db   end_32_2a-start_32_2a
start_32_2a:
	add  hl,hl
end_32_2a:
	ret

;
; =========== 4* ===========
;
define_34_2a:
	call COMCopyCode
	db   end_34_2a-start_34_2a
start_34_2a:
	add  hl,hl
	add  hl,hl
end_34_2a:
	ret

;
; =========== 16* ===========
;
define_31_36_2a:
	call COMCopyCode
	db   end_31_36_2a-start_31_36_2a
start_31_36_2a:
	add  hl,hl
	add  hl,hl
	add  hl,hl
	add  hl,hl
end_31_36_2a:
	ret

;
; =========== 2/ ===========
;
define_32_2f:
	call COMCopyCode
	db   end_32_2f-start_32_2f
start_32_2f:
	sra  h
	rr   l
end_32_2f:
	ret

;
; =========== bswap ===========
;
define_62_73_77_61_70:
	call COMCopyCode
	db   end_62_73_77_61_70-start_62_73_77_61_70
start_62_73_77_61_70:
	ld   a,h
	ld   h,l
	ld   l,a
end_62_73_77_61_70:
	ret

;
; =========== not ===========
;
define_6e_6f_74:
	call COMCompileCallToSelf
start_6e_6f_74:
	ld   a,h
	cpl
	ld   h,a
	ld   a,l
	cpl
	ld   l,a
	ret
end_6e_6f_74:
	ret

