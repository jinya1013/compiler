float_table:	
	addi	%x7 %x0 12
	addi	%x6 %x0 64
	sll	%x6 %x6 %x7
	addi	%x6 %x6 102
	sll	%x6 %x6 %x7
	addi	%x6 %x6 1638
	sw	%x6 0(%x29)
	j	min_caml_start
min_caml_start:
	addi	%x4 %x0 1000
	addi	%x3 %x4 1000
	flw	%f1 0(%x29)	# 5 
	sw	%x1 4(%x2)	# 5 
	addi	%x2 %x2 8	# 5 
	jal	 %x1 min_caml_fneg	# 5 
	addi	%x2 %x2 -8	# 5 
	lw	%x1 4(%x2)	# 5 
