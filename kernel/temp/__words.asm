; =========== ! macro ===========

start_21:
 ld a,end_21-start_21-5
 call COMUCopyCode
  ld   (hl),e
  inc  hl
  ld   (hl),d
  dec  hl
end_21:

; =========== * word ===========

start_2a:
 call COMUCompileCallToSelf
  jp   MULTMultiply16
end_2a:

; =========== + macro ===========

start_2b:
 ld a,end_2b-start_2b-5
 call COMUCopyCode
  add  hl,de
end_2b:

; =========== +! word ===========

start_2b_21:
 call COMUCompileCallToSelf
  ld   a,(hl)
  add  a,e
  ld   (hl),a
  inc  hl
  ld   a,(hl)
  adc  a,d
  ld   (hl),a
  ret
end_2b_21:

; =========== ++ macro ===========

start_2b_2b:
 ld a,end_2b_2b-start_2b_2b-5
 call COMUCopyCode
  inc  hl
end_2b_2b:

; =========== +++ macro ===========

start_2b_2b_2b:
 ld a,end_2b_2b_2b-start_2b_2b_2b-5
 call COMUCopyCode
  inc  hl
  inc  hl
end_2b_2b_2b:

; =========== - macro ===========

start_2d:
 ld a,end_2d-start_2d-5
 call COMUCopyCode
  ld   b,h
  ld   c,l
  ld   h,d
  ld   l,e
  xor  a
  sbc  hl,de
end_2d:

; =========== -- macro ===========

start_2d_2d:
 ld a,end_2d_2d-start_2d_2d-5
 call COMUCopyCode
  dec  hl
end_2d_2d:

; =========== --- macro ===========

start_2d_2d_2d:
 ld a,end_2d_2d_2d-start_2d_2d_2d-5
 call COMUCopyCode
  dec  hl
  dec  hl
end_2d_2d_2d:

; =========== / word ===========

start_2f:
 call COMUCompileCallToSelf
  push  de
  ex   de,hl
  call  DIVDivideMod16
  ex   de,hl
  pop  de
  ret
end_2f:

; =========== 0- word ===========

start_30_2d:
 call COMUCompileCallToSelf
  ld   a,h
  cpl
  ld   h,a
  ld   a,l
  cpl
  ld   l,a
  inc  hl
  ret
end_30_2d:

; =========== 0< word ===========

start_30_3c:
 call COMUCompileCallToSelf
  bit  7,h
  ld   hl,$0000
  ret  z
  dec  hl
  ret
end_30_3c:

; =========== 0= word ===========

start_30_3d:
 call COMUCompileCallToSelf
  ld   a,h
  or   l
  ld   hl,$0000
  ret  nz
  dec  hl
  ret
end_30_3d:

; =========== 16* macro ===========

start_31_36_2a:
 ld a,end_31_36_2a-start_31_36_2a-5
 call COMUCopyCode
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
end_31_36_2a:

; =========== 2* macro ===========

start_32_2a:
 ld a,end_32_2a-start_32_2a-5
 call COMUCopyCode
  add  hl,hl
end_32_2a:

; =========== 2/ macro ===========

start_32_2f:
 ld a,end_32_2f-start_32_2f-5
 call COMUCopyCode
  sra  h
  rr   l
end_32_2f:

; =========== 4* macro ===========

start_34_2a:
 ld a,end_34_2a-start_34_2a-5
 call COMUCopyCode
  add  hl,hl
  add  hl,hl
end_34_2a:

; =========== ; macro ===========

start_3b:
 ld a,end_3b-start_3b-5
 call COMUCopyCode
  ret
end_3b:

; =========== < word ===========

start_3c:
 call COMUCompileCallToSelf
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
end_3c:

; =========== = word ===========

start_3d:
 call COMUCompileCallToSelf
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
end_3d:

; =========== @ macro ===========

start_40:
 ld a,end_40-start_40-5
 call COMUCopyCode
  ld   a,(hl)
  inc  hl
  ld   h,(hl)
  ld   l,a
end_40:

; =========== a>b macro ===========

start_61_3e_62:
 ld a,end_61_3e_62-start_61_3e_62-5
 call COMUCopyCode
  ld   d,h
  ld   e,l
end_61_3e_62:

; =========== a>r macro ===========

start_61_3e_72:
 ld a,end_61_3e_72-start_61_3e_72-5
 call COMUCopyCode
  push  hl
end_61_3e_72:

; =========== ab>r macro ===========

start_61_62_3e_72:
 ld a,end_61_62_3e_72-start_61_62_3e_72-5
 call COMUCopyCode
  push  de
  push  hl
end_61_62_3e_72:

; =========== and word ===========

start_61_6e_64:
 call COMUCompileCallToSelf
  ld   a,h
  and  d
  ld   h,a
  ld   a,l
  and  e
  ld   l,a
  ret
end_61_6e_64:

; =========== b>a macro ===========

start_62_3e_61:
 ld a,end_62_3e_61-start_62_3e_61-5
 call COMUCopyCode
  ld   h,d
  ld   l,e
end_62_3e_61:

; =========== b>r macro ===========

start_62_3e_72:
 ld a,end_62_3e_72-start_62_3e_72-5
 call COMUCopyCode
  push  de
end_62_3e_72:

; =========== break macro ===========

start_62_72_65_61_6b:
 ld a,end_62_72_65_61_6b-start_62_72_65_61_6b-5
 call COMUCopyCode
  db   $DD,$01
end_62_72_65_61_6b:

; =========== bswap macro ===========

start_62_73_77_61_70:
 ld a,end_62_73_77_61_70-start_62_73_77_61_70-5
 call COMUCopyCode
  ld   a,h
  ld   h,l
  ld   l,a
end_62_73_77_61_70:

; =========== c! macro ===========

start_63_21:
 ld a,end_63_21-start_63_21-5
 call COMUCopyCode
  ld   (hl),e
end_63_21:

; =========== c@ macro ===========

start_63_40:
 ld a,end_63_40-start_63_40-5
 call COMUCopyCode
  ld   l,(hl)
  ld   h,0
end_63_40:

; =========== compiles word ===========

start_63_6f_6d_70_69_6c_65_73:
 call COMUCompileCallToSelf
  ld   bc,(Here)
  dec  bc
  dec  bc
  dec  bc
  ld   (Here),bc
  ret
end_63_6f_6d_70_69_6c_65_73:

; =========== copy word ===========

start_63_6f_70_79:
 call COMUCompileCallToSelf
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

; =========== fill word ===========

start_66_69_6c_6c:
 call COMUCompileCallToSelf
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

; =========== halt word ===========

start_68_61_6c_74:
 call COMUCompileCallToSelf
__HaltLoop:
  di
  halt
  jr   __HaltLoop
end_68_61_6c_74:

; =========== mod word ===========

start_6d_6f_64:
 call COMUCompileCallToSelf
  push  de
  ex   de,hl
  call  DIVDivideMod16
  pop  de
  ret
end_6d_6f_64:

; =========== not word ===========

start_6e_6f_74:
 call COMUCompileCallToSelf
  ld   a,h
  cpl
  ld   h,a
  ld   a,l
  cpl
  ld   l,a
  ret
end_6e_6f_74:

; =========== or word ===========

start_6f_72:
 call COMUCompileCallToSelf
  ld   a,h
  or   d
  ld   h,a
  ld   a,l
  or   e
  ld   l,a
  ret
end_6f_72:

; =========== p! macro ===========

start_70_21:
 ld a,end_70_21-start_70_21-5
 call COMUCopyCode
  ld   b,h
  ld   c,l
  out  (c),e
end_70_21:

; =========== p@ word ===========

start_70_40:
 call COMUCompileCallToSelf
  ld   b,h
  ld   c,l
  in   l,(c)
  ld   h,0
end_70_40:

; =========== param! macro ===========

start_70_61_72_61_6d_21:
 ld a,end_70_61_72_61_6d_21-start_70_61_72_61_6d_21-5
 call COMUCopyCode
  ld   (Parameter),hl
end_70_61_72_61_6d_21:

; =========== r>a macro ===========

start_72_3e_61:
 ld a,end_72_3e_61-start_72_3e_61-5
 call COMUCopyCode
  pop  hl
end_72_3e_61:

; =========== r>ab macro ===========

start_72_3e_61_62:
 ld a,end_72_3e_61_62-start_72_3e_61_62-5
 call COMUCopyCode
  pop  hl
  pop  de
end_72_3e_61_62:

; =========== r>b macro ===========

start_72_3e_62:
 ld a,end_72_3e_62-start_72_3e_62-5
 call COMUCopyCode
  pop  de
end_72_3e_62:

; =========== swap macro ===========

start_73_77_61_70:
 ld a,end_73_77_61_70-start_73_77_61_70-5
 call COMUCopyCode
  ex   de,hl
end_73_77_61_70:

; =========== xor word ===========

start_78_6f_72:
 call COMUCompileCallToSelf
  ld   a,h
  xor  d
  ld   h,a
  ld   a,l
  xor  e
  ld   l,a
  ret
end_78_6f_72:

