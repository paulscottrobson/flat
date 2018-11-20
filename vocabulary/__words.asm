;
; Generated.
;
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   binary.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   16th November 2018
;  Purpose : Binary operators
;
; ***************************************************************************************
; ***************************************************************************************

; =========== + copies ===========

flatwordmarker_2b:
    ld  b,en_flat_2b-st_flat_2b
    call COMCopyFollowingCode
st_flat_2b:
  add  hl,de
en_flat_2b:

; ***************************************************************************************

; =========== - copies ===========

flatwordmarker_2d:
    ld  b,en_flat_2d-st_flat_2d
    call COMCopyFollowingCode
st_flat_2d:
  ld   b,d
  ld   c,e
  ex   de,hl
  xor  a
  sbc  hl,de
  ld   d,b
  ld   e,c
en_flat_2d:

; ***************************************************************************************

; =========== * word ===========

flatwordmarker_2a:
    call COMCompileCallToFollowing
st_flat_2a:
  jp   MULTMultiply16
en_flat_2a:

; ***************************************************************************************

; =========== / word ===========

flatwordmarker_2f:
    call COMCompileCallToFollowing
st_flat_2f:
  jp   DIVDivide
en_flat_2f:

; ***************************************************************************************

; =========== mod word ===========

flatwordmarker_6d_6f_64:
    call COMCompileCallToFollowing
st_flat_6d_6f_64:
  jp   DIVModulus
en_flat_6d_6f_64:

; ***************************************************************************************

; =========== and word ===========

flatwordmarker_61_6e_64:
    call COMCompileCallToFollowing
st_flat_61_6e_64:
  ld   a,h
  and  d
  ld   h,a
  ld   a,l
  and  e
  ld   l,a
  ret
en_flat_61_6e_64:

; ***************************************************************************************

; =========== xor word ===========

flatwordmarker_78_6f_72:
    call COMCompileCallToFollowing
st_flat_78_6f_72:
  ld   a,h
  xor   d
  ld   h,a
  ld   a,l
  xor  e
  ld   l,a
  ret
en_flat_78_6f_72:

; ***************************************************************************************

; =========== or word ===========

flatwordmarker_6f_72:
    call COMCompileCallToFollowing
st_flat_6f_72:
  ld   a,h
  or   d
  ld   h,a
  ld   a,l
  or   e
  ld   l,a
  ret
en_flat_6f_72:


; ***************************************************************************************

; =========== = word ===========

flatwordmarker_3d:
    call COMCompileCallToFollowing
st_flat_3d:
  ld   a,e
  cp   l
  jr   nz,__EqualFail
  ld   a,d
  cp   h
  ld   hl,$FFFF
  ret  z
__EqualFail:
  ld   hl,0
  ret

en_flat_3d:

; ***************************************************************************************

; =========== < word ===========

flatwordmarker_3c:
    call COMCompileCallToFollowing
st_flat_3c:
  ld   a,d      ; this is calculating true if B < A e.g. 4 7 <
  xor  h
  add  a,a      ; if the signs are different, check those.
  jr   c,__LessDifferentSigns

  push  de
  ex   de,hl      ; want to do B-A
  sbc  hl,de      ; carry set if B-A < 0 e.g. B < A
  pop  de
  jr   c,__LessTrue

__LessFalse:
  ld   hl,$0000
  ret

__LessDifferentSigns:
  bit  7,b      ; if B is +ve then B must be > A
  jr   z,__LessFalse

__LessTrue:
  ld   hl,$FFFF
  ret

en_flat_3c:

; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   graphics.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   18th November 2018
;  Purpose : Hardware I/O words
;
; ***************************************************************************************
; ***************************************************************************************

; =========== screen! word ===========

flatwordmarker_73_63_72_65_65_6e_21:
    call COMCompileCallToFollowing
st_flat_73_63_72_65_65_6e_21:
 jp   GFXWriteCharacter
en_flat_73_63_72_65_65_6e_21:

; ***************************************************************************************

; =========== screenmode word ===========

flatwordmarker_73_63_72_65_65_6e_6d_6f_64_65:
    call COMCompileCallToFollowing
st_flat_73_63_72_65_65_6e_6d_6f_64_65:
 jp   GFXMode
en_flat_73_63_72_65_65_6e_6d_6f_64_65:

; ***************************************************************************************

; =========== hex! word ===========

flatwordmarker_68_65_78_21:
    call COMCompileCallToFollowing
st_flat_68_65_78_21:
 jp   GFXWriteHexWord
en_flat_68_65_78_21:
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   memory.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   18th November 2018
;  Purpose : Memory and Hardware access
;
; ***************************************************************************************
; ***************************************************************************************

; =========== c@ copies ===========

flatwordmarker_63_40:
    ld  b,en_flat_63_40-st_flat_63_40
    call COMCopyFollowingCode
st_flat_63_40:
  ld   l,(hl)
  ld   h,0
en_flat_63_40:

; ***************************************************************************************

; =========== @ copies ===========

flatwordmarker_40:
    ld  b,en_flat_40-st_flat_40
    call COMCopyFollowingCode
st_flat_40:
  ld   a,(hl)
  inc  hl
  ld   h,(hl)
  ld   l,a
en_flat_40:

; ***************************************************************************************

; =========== c! copies ===========

flatwordmarker_63_21:
    ld  b,en_flat_63_21-st_flat_63_21
    call COMCopyFollowingCode
st_flat_63_21:
  ld   (hl),e
en_flat_63_21:

; ***************************************************************************************

; =========== ! copies ===========

flatwordmarker_21:
    ld  b,en_flat_21-st_flat_21
    call COMCopyFollowingCode
st_flat_21:
  ld   (hl),e
  inc  hl
  ld   (hl),d
  dec  hl
en_flat_21:

; ***************************************************************************************

; =========== +! word ===========

flatwordmarker_2b_21:
    call COMCompileCallToFollowing
st_flat_2b_21:
  ld   a,(hl)
  add  a,e
  ld   (hl),a
  inc  hl

  ld   a,(hl)
  adc  a,d
  ld   (hl),a
  dec  hl
  ret
en_flat_2b_21:

; ***************************************************************************************

; =========== p! copies ===========

flatwordmarker_70_21:
    ld  b,en_flat_70_21-st_flat_70_21
    call COMCopyFollowingCode
st_flat_70_21:
  ld   c,l
  ld   b,h
  out  (c),e
en_flat_70_21:

; ***************************************************************************************

; =========== p@ word ===========

flatwordmarker_70_40:
    call COMCompileCallToFollowing
st_flat_70_40:
  ld   c,l
  ld   b,h
  in   l,(c)
  ld   h,0
  ret
en_flat_70_40:

; ***************************************************************************************

; =========== far@ word ===========

flatwordmarker_66_61_72_40:
    call COMCompileCallToFollowing
st_flat_66_61_72_40:
  jp   FARRead
en_flat_66_61_72_40:

; ***************************************************************************************

; =========== far! word ===========

flatwordmarker_66_61_72_21:
    call COMCompileCallToFollowing
st_flat_66_61_72_21:
  jp   FARWrite
en_flat_66_61_72_21:
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   register.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   18th November 2018
;  Purpose : Register operators
;
; ***************************************************************************************
; ***************************************************************************************

; =========== swap copies ===========

flatwordmarker_73_77_61_70:
    ld  b,en_flat_73_77_61_70-st_flat_73_77_61_70
    call COMCopyFollowingCode
st_flat_73_77_61_70:
 ex   de,hl
en_flat_73_77_61_70:

; ***************************************************************************************

; =========== a>b copies ===========

flatwordmarker_61_3e_62:
    ld  b,en_flat_61_3e_62-st_flat_61_3e_62
    call COMCopyFollowingCode
st_flat_61_3e_62:
 ld   d,h
 ld   e,l
en_flat_61_3e_62:

; ***************************************************************************************

; =========== b>a copies ===========

flatwordmarker_62_3e_61:
    ld  b,en_flat_62_3e_61-st_flat_62_3e_61
    call COMCopyFollowingCode
st_flat_62_3e_61:
 ld   h,d
 ld   l,e
en_flat_62_3e_61:

; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   stack.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   18th November 2018
;  Purpose : Stack operators
;
; ***************************************************************************************
; ***************************************************************************************

; =========== ab>r copies.only ===========

flatwordmarker_61_62_3e_72:
    ld  b,en_flat_61_62_3e_72-st_flat_61_62_3e_72+$80
    call COMCopyFollowingCode
st_flat_61_62_3e_72:
 push  de
 push  hl
en_flat_61_62_3e_72:

; ***************************************************************************************

; =========== r>ab copies.only ===========

flatwordmarker_72_3e_61_62:
    ld  b,en_flat_72_3e_61_62-st_flat_72_3e_61_62+$80
    call COMCopyFollowingCode
st_flat_72_3e_61_62:
 pop  hl
 pop  de
en_flat_72_3e_61_62:

; ***************************************************************************************

; =========== r>bb copies.only ===========

flatwordmarker_72_3e_62_62:
    ld  b,en_flat_72_3e_62_62-st_flat_72_3e_62_62+$80
    call COMCopyFollowingCode
st_flat_72_3e_62_62:
 pop  de
 pop  de
en_flat_72_3e_62_62:

; ***************************************************************************************

; =========== push copies.only ===========

flatwordmarker_70_75_73_68:
    ld  b,en_flat_70_75_73_68-st_flat_70_75_73_68+$80
    call COMCopyFollowingCode
st_flat_70_75_73_68:
 push  hl
en_flat_70_75_73_68:

; ***************************************************************************************

; =========== pop copies.only ===========

flatwordmarker_70_6f_70:
    ld  b,en_flat_70_6f_70-st_flat_70_6f_70+$80
    call COMCopyFollowingCode
st_flat_70_6f_70:
 ex   de,hl
 pop  hl
en_flat_70_6f_70:

; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   unary.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   18th November 2018
;  Purpose : Unary operators
;
; ***************************************************************************************
; ***************************************************************************************

; =========== 0= word ===========

flatwordmarker_30_3d:
    call COMCompileCallToFollowing
st_flat_30_3d:
  ld  a,h
  or  l
  ld  hl,$0000
  ret nz
  dec hl
  ret
en_flat_30_3d:

; ***************************************************************************************

; =========== 0< word ===========

flatwordmarker_30_3c:
    call COMCompileCallToFollowing
st_flat_30_3c:
  bit 7,h
  ld  hl,$0000
  ret z
  dec hl
  ret
en_flat_30_3c:

; ***************************************************************************************

; =========== 0- word ===========

flatwordmarker_30_2d:
    call COMCompileCallToFollowing
st_flat_30_2d:
  ld  a,h
  cpl
  ld  h,a
  ld  a,l
  cpl
  ld  l,a
  inc hl
  ret
en_flat_30_2d:

; ***************************************************************************************

; =========== not word ===========

flatwordmarker_6e_6f_74:
    call COMCompileCallToFollowing
st_flat_6e_6f_74:
  ld  a,h
  cpl
  ld  h,a
  ld  a,l
  cpl
  ld  l,a
  ret
en_flat_6e_6f_74:

; ***************************************************************************************

; =========== ++ copies ===========

flatwordmarker_2b_2b:
    ld  b,en_flat_2b_2b-st_flat_2b_2b
    call COMCopyFollowingCode
st_flat_2b_2b:
  inc hl
en_flat_2b_2b:

; ***************************************************************************************

; =========== -- copies ===========

flatwordmarker_2d_2d:
    ld  b,en_flat_2d_2d-st_flat_2d_2d
    call COMCopyFollowingCode
st_flat_2d_2d:
  dec hl
en_flat_2d_2d:

; ***************************************************************************************

; =========== 2* copies ===========

flatwordmarker_32_2a:
    ld  b,en_flat_32_2a-st_flat_32_2a
    call COMCopyFollowingCode
st_flat_32_2a:
  add  hl,hl
en_flat_32_2a:

; ***************************************************************************************

; =========== 2/ copies ===========

flatwordmarker_32_2f:
    ld  b,en_flat_32_2f-st_flat_32_2f
    call COMCopyFollowingCode
st_flat_32_2f:
  sra  h
  rr   l
en_flat_32_2f:

; ***************************************************************************************

; =========== 4* copies ===========

flatwordmarker_34_2a:
    ld  b,en_flat_34_2a-st_flat_34_2a
    call COMCopyFollowingCode
st_flat_34_2a:
  add  hl,hl
  add  hl,hl
en_flat_34_2a:

; ***************************************************************************************

; =========== 16* copies ===========

flatwordmarker_31_36_2a:
    ld  b,en_flat_31_36_2a-st_flat_31_36_2a
    call COMCopyFollowingCode
st_flat_31_36_2a:
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
en_flat_31_36_2a:

; ***************************************************************************************

; =========== bswap copies ===========

flatwordmarker_62_73_77_61_70:
    ld  b,en_flat_62_73_77_61_70-st_flat_62_73_77_61_70
    call COMCopyFollowingCode
st_flat_62_73_77_61_70:
  ld   a,h
  ld   h,l
  ld   l,a
en_flat_62_73_77_61_70:

; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   utility.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   18th November 2018
;  Purpose : Miscellaneous words.
;
; ***************************************************************************************
; ***************************************************************************************

; =========== break copies.only ===========

flatwordmarker_62_72_65_61_6b:
    ld  b,en_flat_62_72_65_61_6b-st_flat_62_72_65_61_6b+$80
    call COMCopyFollowingCode
st_flat_62_72_65_61_6b:
  db   $DD,$01
en_flat_62_72_65_61_6b:

; ***************************************************************************************

; =========== ; copies.only ===========

flatwordmarker_3b:
    ld  b,en_flat_3b-st_flat_3b+$80
    call COMCopyFollowingCode
st_flat_3b:
  ret
en_flat_3b:

; ***************************************************************************************

; =========== halt word ===========

flatwordmarker_68_61_6c_74:
    call COMCompileCallToFollowing
st_flat_68_61_6c_74:
HaltZ80:
  di
  halt
  jr   HaltZ80
en_flat_68_61_6c_74:

; ***************************************************************************************

; =========== copy word ===========

flatwordmarker_63_6f_70_79:
    call COMCompileCallToFollowing
st_flat_63_6f_70_79:
  call  $8010         ; load work into BC
  ld   a,b         ; nothing to do.
  or   c
  ret  z

  push  bc
  push  de
  push  hl

  xor  a          ; find direction.
  sbc  hl,de
  ld   a,h
  add  hl,de
  bit  7,a         ; if +ve use LDDR
  jr   z,__copy2

  ex   de,hl         ; LDIR etc do (DE) <- (HL)
  ldir
__copyExit:
  pop  hl
  pop  de
  pop  bc
  ret

__copy2:
  add  hl,bc         ; add length to HL,DE, swap as LDDR does (DE) <- (HL)
  ex   de,hl
  add  hl,bc
  dec  de          ; -1 to point to last byte
  dec  hl
  lddr
  jr   __copyExit
en_flat_63_6f_70_79:

; ***************************************************************************************

; =========== fill word ===========

flatwordmarker_66_69_6c_6c:
    call COMCompileCallToFollowing
st_flat_66_69_6c_6c:
  call  $8010         ; load work into BC
  ld   a,b         ; nothing to do.
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
en_flat_66_69_6c_6c:

; ***************************************************************************************

; =========== c, word ===========

flatwordmarker_63_2c:
    call COMCompileCallToFollowing
st_flat_63_2c:
  ld   a,l
  jp   FARCompileByte
en_flat_63_2c:

; ***************************************************************************************

; =========== , word ===========

flatwordmarker_2c:
    call COMCompileCallToFollowing
st_flat_2c:
  ld   a,l
  jp   FARCompileWord
en_flat_2c:

; ***************************************************************************************

; =========== inkey word ===========

flatwordmarker_69_6e_6b_65_79:
    call COMCompileCallToFollowing
st_flat_69_6e_6b_65_79:
  ex   de,hl
  call  IOScanKeyboard
  ld   l,a
  ld   h,0
  ret
en_flat_69_6e_6b_65_79:

