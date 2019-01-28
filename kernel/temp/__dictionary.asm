	db 1+5
	db $20
	dw define_21
	db 1
	db "!"

	db 1+5
	db $20
	dw define_2a
	db 1
	db "*"

	db 1+5
	db $20
	dw define_2b
	db 1
	db "+"

	db 2+5
	db $20
	dw define_2b_21
	db 2
	db "+!"

	db 2+5
	db $20
	dw define_2b_2b
	db 2
	db "++"

	db 3+5
	db $20
	dw define_2b_2b_2b
	db 3
	db "+++"

	db 1+5
	db $20
	dw define_2c
	db 1
	db ","

	db 1+5
	db $20
	dw define_2d
	db 1
	db "-"

	db 2+5
	db $20
	dw define_2d_2d
	db 2
	db "--"

	db 3+5
	db $20
	dw define_2d_2d_2d
	db 3
	db "---"

	db 1+5
	db $20
	dw define_2f
	db 1
	db "/"

	db 2+5
	db $20
	dw define_30_2d
	db 2
	db "0-"

	db 2+5
	db $20
	dw define_30_3c
	db 2
	db "0<"

	db 2+5
	db $20
	dw define_30_3d
	db 2
	db "0="

	db 3+5
	db $20
	dw define_31_36_2a
	db 3
	db "16*"

	db 2+5
	db $20
	dw define_32_2a
	db 2
	db "2*"

	db 2+5
	db $20
	dw define_32_2f
	db 2
	db "2/"

	db 2+5
	db $20
	dw define_34_2a
	db 2
	db "4*"

	db 2+5
	db $20
	dw define_34_2f
	db 2
	db "4/"

	db 2+5
	db $20
	dw define_38_2a
	db 2
	db "8*"

	db 1+5
	db $20
	dw define_3b
	db 1
	db ";"

	db 1+5
	db $20
	dw define_3c
	db 1
	db "<"

	db 1+5
	db $20
	dw define_3d
	db 1
	db "="

	db 1+5
	db $20
	dw define_40
	db 1
	db "@"

	db 3+5
	db $20
	dw define_61_3e_62
	db 3
	db "a>b"

	db 3+5
	db $20
	dw define_61_3e_72
	db 3
	db "a>r"

	db 4+5
	db $20
	dw define_61_62_3e_72
	db 4
	db "ab>r"

	db 3+5
	db $20
	dw define_61_62_73
	db 3
	db "abs"

	db 3+5
	db $20
	dw define_61_6e_64
	db 3
	db "and"

	db 3+5
	db $20
	dw define_62_3e_61
	db 3
	db "b>a"

	db 3+5
	db $20
	dw define_62_3e_72
	db 3
	db "b>r"

	db 5+5
	db $20
	dw define_62_72_65_61_6b
	db 5
	db "break"

	db 5+5
	db $20
	dw define_62_73_77_61_70
	db 5
	db "bswap"

	db 2+5
	db $20
	dw define_63_21
	db 2
	db "c!"

	db 2+5
	db $20
	dw define_63_2c
	db 2
	db "c,"

	db 2+5
	db $20
	dw define_63_40
	db 2
	db "c@"

	db 13+5
	db $20
	dw define_63_6f_6e_2e_72_61_77_2e_63_68_61_72_21
	db 13
	db "con.raw.char!"

	db 12+5
	db $20
	dw define_63_6f_6e_2e_72_61_77_2e_68_65_78_21
	db 12
	db "con.raw.hex!"

	db 13+5
	db $20
	dw define_63_6f_6e_2e_72_61_77_2e_69_6e_6b_65_79
	db 13
	db "con.raw.inkey"

	db 15+5
	db $20
	dw define_63_6f_6e_2e_72_61_77_2e_73_65_74_6d_6f_64_65
	db 15
	db "con.raw.setmode"

	db 4+5
	db $20
	dw define_63_6f_70_79
	db 4
	db "copy"

	db 11+5
	db $20
	dw define_64_69_63_74_2e_63_72_75_6e_63_68
	db 11
	db "dict.crunch"

	db 4+5
	db $20
	dw define_66_69_6c_6c
	db 4
	db "fill"

	db 4+5
	db $20
	dw define_68_61_6c_74
	db 4
	db "halt"

	db 3+5
	db $20
	dw define_6d_6f_64
	db 3
	db "mod"

	db 3+5
	db $20
	dw define_6e_6f_74
	db 3
	db "not"

	db 2+5
	db $20
	dw define_6f_72
	db 2
	db "or"

	db 2+5
	db $20
	dw define_70_21
	db 2
	db "p!"

	db 2+5
	db $20
	dw define_70_40
	db 2
	db "p@"

	db 6+5
	db $20
	dw define_70_61_72_61_6d_21
	db 6
	db "param!"

	db 3+5
	db $20
	dw define_70_6f_70
	db 3
	db "pop"

	db 4+5
	db $20
	dw define_70_75_73_68
	db 4
	db "push"

	db 3+5
	db $20
	dw define_72_3e_61
	db 3
	db "r>a"

	db 4+5
	db $20
	dw define_72_3e_61_62
	db 4
	db "r>ab"

	db 3+5
	db $20
	dw define_72_3e_62
	db 3
	db "r>b"

	db 4+5
	db $20
	dw define_73_77_61_70
	db 4
	db "swap"

	db 3+5
	db $20
	dw define_78_6f_72
	db 3
	db "xor"

	db 0
