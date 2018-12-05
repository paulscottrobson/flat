; =========== ! macro ===========

start_21_3a_6d:
  ld   (hl),e
  inc  hl
  ld   (hl),d
  dec  hl
end_21_3a_6d:

; =========== * word ===========

start_2a_3a_77:
  push  bc
  push  de
  ld   b,h
  ld   c,l
  ld   hl,$0000
__MultiplyLoop:
  srl  b
  rr   c
  jr   nc,__MultiplyNoAdd
  add  hl,de
__MultiplyNoAdd:
  ex   de,hl
  add  hl,de
  ex   de,hl
  ld   a,b
  or   c
  jr   nz,__MultiplyLoop
  pop  de
  pop  bc
  ret
end_2a_3a_77:

; =========== + macro ===========

start_2b_3a_6d:
  add  hl,de
end_2b_3a_6d:

; =========== +! word ===========

start_2b_21_3a_77:
  ld   a,(hl)
  add  a,e
  ld   (hl),a
  inc  hl
  ld   a,(hl)
  adc  a,d
  ld   (hl),a
  ret
end_2b_21_3a_77:

; =========== ++ macro ===========

start_2b_2b_3a_6d:
  inc  hl
end_2b_2b_3a_6d:

; =========== - word ===========

start_2d_3a_77:
  ld   a,h
  cpl
  ld   h,a
  ld   a,l
  cpl
  ld   l,a
  inc  hl
  ret
end_2d_3a_77:

; =========== -- macro ===========

start_2d_2d_3a_6d:
  dec  hl
end_2d_2d_3a_6d:

; =========== 0< word ===========

start_30_3c_3a_77:
  bit  7,h
  ld   hl,$0000
  ret  z
  dec  hl
  ret
end_30_3c_3a_77:

; =========== 0= word ===========

start_30_3d_3a_77:
  ld   a,h
  or   l
  ld   hl,$0000
  ret  nz
  dec  hl
  ret
end_30_3d_3a_77:

; =========== 16* macro ===========

start_31_36_2a_3a_6d:
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
end_31_36_2a_3a_6d:

; =========== 2* macro ===========

start_32_2a_3a_6d:
  add  hl,hl
end_32_2a_3a_6d:

; =========== 2/ macro ===========

start_32_2f_3a_6d:
  sra  h
  rr   l
end_32_2f_3a_6d:

; =========== 4* macro ===========

start_34_2a_3a_6d:
  add  hl,hl
  add  hl,hl
end_34_2a_3a_6d:

; =========== ; macro ===========

start_3b_3a_6d:
  ret
end_3b_3a_6d:

; =========== < word ===========

start_3c_3a_77:
  ld   a,d
  xor  h
  jp   m,__SignsDifferent
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
end_3c_3a_77:

; =========== = word ===========

start_3d_3a_77:
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
end_3d_3a_77:

; =========== @ macro ===========

start_40_3a_6d:
  ld   a,(hl)
  inc  hl
  ld   h,(hl)
  ld   l,a
end_40_3a_6d:

; =========== a>b macro ===========

start_61_3e_62_3a_6d:
  ld   d,h
  ld   e,l
end_61_3e_62_3a_6d:

; =========== a>c macro ===========

start_61_3e_63_3a_6d:
  ld   b,h
  ld   c,l
end_61_3e_63_3a_6d:

; =========== a>r macro ===========

start_61_3e_72_3a_6d:
  push  hl
end_61_3e_72_3a_6d:

; =========== ab>r macro ===========

start_61_62_3e_72_3a_6d:
  push  de
  push  hl
end_61_62_3e_72_3a_6d:

; =========== abc>r macro ===========

start_61_62_63_3e_72_3a_6d:
  push  bc
  push  de
  push  hl
end_61_62_63_3e_72_3a_6d:

; =========== and word ===========

start_61_6e_64_3a_77:
  ld   a,h
  and  d
  ld   h,a
  ld   a,l
  and  e
  ld   l,a
  ret
end_61_6e_64_3a_77:

; =========== b>a macro ===========

start_62_3e_61_3a_6d:
  ld   h,d
  ld   l,e
end_62_3e_61_3a_6d:

; =========== b>c macro ===========

start_62_3e_63_3a_6d:
  ld   b,d
  ld   c,e
end_62_3e_63_3a_6d:

; =========== b>r macro ===========

start_62_3e_72_3a_6d:
  push  de
end_62_3e_72_3a_6d:

; =========== break macro ===========

start_62_72_65_61_6b_3a_6d:
  db   $DD,$01
end_62_72_65_61_6b_3a_6d:

; =========== bswap macro ===========

start_62_73_77_61_70_3a_6d:
  ld   a,h
  ld   h,l
  ld   l,a
end_62_73_77_61_70_3a_6d:

; =========== c! macro ===========

start_63_21_3a_6d:
  ld   (hl),e
end_63_21_3a_6d:

; =========== c>a macro ===========

start_63_3e_61_3a_6d:
  ld   h,b
  ld   l,c
end_63_3e_61_3a_6d:

; =========== c>b macro ===========

start_63_3e_62_3a_6d:
  ld   d,b
  ld   e,c
end_63_3e_62_3a_6d:

; =========== c>r macro ===========

start_63_3e_72_3a_6d:
  push  bc
end_63_3e_72_3a_6d:

; =========== c@ macro ===========

start_63_40_3a_6d:
  ld   l,(hl)
  ld   h,0
end_63_40_3a_6d:

; =========== copy word ===========

start_63_6f_70_79_3a_77:
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
end_63_6f_70_79_3a_77:

; =========== fill word ===========

start_66_69_6c_6c_3a_77:
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
end_66_69_6c_6c_3a_77:

; =========== halt word ===========

start_68_61_6c_74_3a_77:
__HaltLoop:
  di
  halt
  jr   __HaltLoop
end_68_61_6c_74_3a_77:

; =========== not word ===========

start_6e_6f_74_3a_77:
  ld   a,h
  cpl
  ld   h,a
  ld   a,l
  cpl
  ld   l,a
  ret
end_6e_6f_74_3a_77:

; =========== or word ===========

start_6f_72_3a_77:
  ld   a,h
  or   d
  ld   h,a
  ld   a,l
  or   e
  ld   l,a
  ret
end_6f_72_3a_77:

; =========== p! macro ===========

start_70_21_3a_6d:
  out  (c),l
end_70_21_3a_6d:

; =========== p@ macro ===========

start_70_40_3a_6d:
  in   l,(c)
  ld   h,0
end_70_40_3a_6d:

; =========== r>a macro ===========

start_72_3e_61_3a_6d:
  pop  hl
end_72_3e_61_3a_6d:

; =========== r>ab macro ===========

start_72_3e_61_62_3a_6d:
  pop  hl
  pop  de
end_72_3e_61_62_3a_6d:

; =========== r>abc macro ===========

start_72_3e_61_62_63_3a_6d:
  pop  hl
  pop  de
  pop  bc
end_72_3e_61_62_63_3a_6d:

; =========== r>b macro ===========

start_72_3e_62_3a_6d:
  pop  de
end_72_3e_62_3a_6d:

; =========== r>c macro ===========

start_72_3e_63_3a_6d:
  pop  bc
end_72_3e_63_3a_6d:

; =========== swap macro ===========

start_73_77_61_70_3a_6d:
  ex   de,hl
end_73_77_61_70_3a_6d:

; =========== xor word ===========

start_78_6f_72_3a_77:
  ld   a,h
  xor  d
  ld   h,a
  ld   a,l
  xor  e
  ld   l,a
  ret
end_78_6f_72_3a_77:

