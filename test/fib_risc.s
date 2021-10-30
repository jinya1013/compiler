min_caml_start:
	addi	%x4 %x0 3 # 4 
	sw	%x1 4(%x2)	# 4 
	addi	%x2 %x2 8	# 4 
	jal	 %x1 fib.10	# 4 
	addi	%x2 %x2 -8	# 4 
	lw	%x1 4(%x2)	# 4 
fib.10:
	addi	%x4 %x4 -1	# 2 
	addi	%x5 %x0 1	# 2 
	blt	%x4 %x5 blt.24	# 2 
	nop	# 2 
	addi	%x4 %x4 1	# 2 
	addi	%x5 %x4 -1	# 3 
	sw	%x4 0(%x2)	# 3 
	add	%x4 %x0 %x5	# 3 
	sw	%x1 4(%x2)	# 3 
	addi	%x2 %x2 8	# 3 
	jal	 %x1 fib.10	# 3 
	addi	%x2 %x2 -8	# 3 
	lw	%x1 4(%x2)	# 3 
	lw	%x5 0(%x2)	# 3 
	addi	%x5 %x5 -2	# 3 
	sw	%x4 4(%x2)	# 3 
	add	%x4 %x0 %x5	# 3 
	sw	%x1 12(%x2)	# 3 
	addi	%x2 %x2 16	# 3 
	jal	 %x1 fib.10	# 3 
	addi	%x2 %x2 -16	# 3 
	lw	%x1 12(%x2)	# 3 
	lw	%x5 4(%x2)	# 3 
	add	%x4 %x5 %x4	# 3 
	jr	0(%x1)	# 3 
	nop	# 3 
blt.24:	# 2 
	addi	%x4 %x4 1	# 2 
	jr	0(%x1)	# 2 
	nop	# 2 
