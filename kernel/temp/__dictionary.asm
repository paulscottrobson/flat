	db  1+5
	db  $20
	dw  define_21
	db  1,"!"

	db  1+5
	db  $20
	dw  define_2a
	db  1,"*"

	db  1+5
	db  $20
	dw  define_2b
	db  1,"+"

	db  2+5
	db  $20
	dw  define_2b_21
	db  2,"+!"

	db  2+5
	db  $20
	dw  define_2b_2b
	db  2,"++"

	db  3+5
	db  $20
	dw  define_2b_2b_2b
	db  3,"+++"

	db  1+5
	db  $20
	dw  define_2c
	db  1,","

	db  1+5
	db  $20
	dw  define_2d
	db  1,"-"

	db  2+5
	db  $20
	dw  define_2d_2d
	db  2,"--"

	db  3+5
	db  $20
	dw  define_2d_2d_2d
	db  3,"---"

	db  1+5
	db  $20
	dw  define_2f
	db  1,"/"

	db  1+5
	db  $20
	dw  define_30
	db  1,"0"

	db  2+5
	db  $20
	dw  define_30_2d
	db  2,"0-"

	db  3+5
	db  $20
	dw  define_31_36_2a
	db  3,"16*"

	db  2+5
	db  $20
	dw  define_32_2a
	db  2,"2*"

	db  2+5
	db  $20
	dw  define_32_2f
	db  2,"2/"

	db  2+5
	db  $20
	dw  define_34_2a
	db  2,"4*"

	db  1+5
	db  $20
	dw  define_40
	db  1,"@"

	db  3+5
	db  $20
	dw  define_61_3e_62
	db  3,"a>b"

	db  3+5
	db  $20
	dw  define_61_3e_72
	db  3,"a>r"

	db  4+5
	db  $20
	dw  define_61_62_3e_72
	db  4,"ab>r"

	db  3+5
	db  $20
	dw  define_61_6e_64
	db  3,"and"

	db  3+5
	db  $20
	dw  define_62_3e_61
	db  3,"b>a"

	db  3+5
	db  $20
	dw  define_62_3e_72
	db  3,"b>r"

	db  5+5
	db  $20
	dw  define_62_72_65_61_6b
	db  5,"break"

	db  5+5
	db  $20
	dw  define_62_73_77_61_70
	db  5,"bswap"

	db  2+5
	db  $20
	dw  define_63_21
	db  2,"c!"

	db  2+5
	db  $20
	dw  define_63_2c
	db  2,"c,"

	db  2+5
	db  $20
	dw  define_63_40
	db  2,"c@"

	db  8+5
	db  $20
	dw  define_63_6f_6d_70_69_6c_65_73
	db  8,"compiles"

	db  4+5
	db  $20
	dw  define_63_6f_70_79
	db  4,"copy"

	db  5+5
	db  $20
	dw  define_64_65_62_75_67
	db  5,"debug"

	db  4+5
	db  $20
	dw  define_66_69_6c_6c
	db  4,"fill"

	db  4+5
	db  $20
	dw  define_68_61_6c_74
	db  4,"halt"

	db  5+5
	db  $20
	dw  define_69_6e_6b_65_79
	db  5,"inkey"

	db  3+5
	db  $20
	dw  define_6d_6f_64
	db  3,"mod"

	db  3+5
	db  $20
	dw  define_6e_6f_74
	db  3,"not"

	db  2+5
	db  $20
	dw  define_6f_72
	db  2,"or"

	db  2+5
	db  $20
	dw  define_70_21
	db  2,"p!"

	db  2+5
	db  $20
	dw  define_70_40
	db  2,"p@"

	db  6+5
	db  $20
	dw  define_70_61_72_61_6d_21
	db  6,"param!"

	db  3+5
	db  $20
	dw  define_72_3e_61
	db  3,"r>a"

	db  4+5
	db  $20
	dw  define_72_3e_61_62
	db  4,"r>ab"

	db  3+5
	db  $20
	dw  define_72_3e_62
	db  3,"r>b"

	db  4+5
	db  $20
	dw  define_73_77_61_70
	db  4,"swap"

	db  3+5
	db  $20
	dw  define_78_6f_72
	db  3,"xor"

	db  0

