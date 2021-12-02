float_table:	
	addi	%x7 %x0 12
	addi	%x6 %x0 193
	sll	%x6 %x6 %x7
	addi	%x6 %x6 512
	sll	%x6 %x6 %x7
	addi	%x6 %x6 0
	sw	%x6 52(%x29)
	addi	%x6 %x0 62
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 1537
	sll	%x6 %x6 %x7
	addi	%x6 %x6 0
	sw	%x6 48(%x29)
	addi	%x6 %x0 64
	sll	%x6 %x6 %x7
	addi	%x6 %x6 448
	sll	%x6 %x6 %x7
	addi	%x6 %x6 0
	sw	%x6 44(%x29)
	addi	%x6 %x0 61
	sll	%x6 %x6 %x7
	addi	%x6 %x6 1886
	sll	%x6 %x6 %x7
	addi	%x6 %x6 1989
	sw	%x6 40(%x29)
	addi	%x6 %x0 61
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 894
	sll	%x6 %x6 %x7
	addi	%x6 %x6 1646
	sw	%x6 36(%x29)
	addi	%x6 %x0 61
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 1593
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 1593
	sw	%x6 32(%x29)
	addi	%x6 %x0 62
	sll	%x6 %x6 %x7
	addi	%x6 %x6 292
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 294
	sw	%x6 28(%x29)
	addi	%x6 %x0 62
	sll	%x6 %x6 %x7
	addi	%x6 %x6 1228
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 1230
	sw	%x6 24(%x29)
	addi	%x6 %x0 62
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 683
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 683
	sw	%x6 20(%x29)
	addi	%x6 %x0 63
	sll	%x6 %x6 %x7
	addi	%x6 %x6 1168
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 2012
	sw	%x6 16(%x29)
	addi	%x6 %x0 63
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 1169
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 2012
	sw	%x6 12(%x29)
	addi	%x6 %x0 191
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 1
	sll	%x6 %x6 %x7
	addi	%x6 %x6 0
	sw	%x6 8(%x29)
	addi	%x6 %x0 0
	sll	%x6 %x6 %x7
	addi	%x6 %x6 0
	sll	%x6 %x6 %x7
	addi	%x6 %x6 0
	sw	%x6 4(%x29)
	addi	%x6 %x0 63
	sll	%x6 %x6 %x7
	addi	%x6 %x6 2047
	addi	%x6 %x6 1
	sll	%x6 %x6 %x7
	addi	%x6 %x6 0
	sw	%x6 0(%x29)
	j	min_caml_start
kernel_atan.218:	# 400
	flw	%f2 24(%x4)	# 97 
	flw	%f3 20(%x4)	# 97 
	flw	%f4 16(%x4)	# 97 
	flw	%f5 12(%x4)	# 97 
	flw	%f6 8(%x4)	# 97 
	flw	%f7 4(%x4)	# 97 
	fmul	%f5 %f5 %f1	# 97 
	fmul	%f5 %f5 %f1	# 97 
	fmul	%f5 %f5 %f1	# 97 
	fsub	%f5 %f1 %f5	# 97 
	fmul	%f4 %f4 %f1	# 97 
	fmul	%f4 %f4 %f1	# 97 
	fmul	%f4 %f4 %f1	# 97 
	fmul	%f4 %f4 %f1	# 97 
	fmul	%f4 %f4 %f1	# 97 
	fadd	%f4 %f5 %f4	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fsub	%f3 %f4 %f3	# 97 
	fmul	%f2 %f2 %f1	# 97 
	fmul	%f2 %f2 %f1	# 97 
	fmul	%f2 %f2 %f1	# 97 
	fmul	%f2 %f2 %f1	# 97 
	fmul	%f2 %f2 %f1	# 97 
	fmul	%f2 %f2 %f1	# 97 
	fmul	%f2 %f2 %f1	# 97 
	fmul	%f2 %f2 %f1	# 97 
	fmul	%f2 %f2 %f1	# 97 
	fadd	%f2 %f3 %f2	# 97 
	fmul	%f3 %f7 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fsub	%f2 %f2 %f3	# 97 
	fmul	%f3 %f6 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f3 %f3 %f1	# 97 
	fmul	%f1 %f3 %f1	# 97 
	fadd	%f1 %f2 %f1	# 97 
	jr	0(%x1)	# 97 
	nop	# 97 
atan_f.222:	# 648
	flw	%f3 20(%x4)	# 104 
	flw	%f4 16(%x4)	# 104 
	lw	%x6 12(%x4)	# 104 
	flw	%f5 8(%x4)	# 104 
	flw	%f6 4(%x4)	# 104 
	fle	%x5 %f1 %f6	# 104 
	bne	%x5 %x0 fle_else.421	# 104 
	nop	# 104 
	flw	%f3 0(%x29)	# 104 
	fdiv	%f1 %f3 %f1	# 104 
	fsw	%f2 0(%x2)	# 104 
	fsw	%f4 4(%x2)	# 104 
	add	%x4 %x0 %x6	# 104 
	sw	%x1 12(%x2)	# 104 
	lw	%x5 0(%x4)	# 104 
	addi	%x2 %x2 16	# 104 
	jalr	%x1 0(%x5)	# 104 
	addi	%x2 %x2 -16	# 104 
	lw	%x1 12(%x2)	# 104 
	flw	%f2 4(%x2)	# 104 
	fsub	%f1 %f2 %f1	# 104 
	flw	%f2 0(%x2)	# 104 
	fmul	%f1 %f2 %f1	# 104 
	jr	0(%x1)	# 104 
	nop	# 104 
fle_else.421:	# 104 
	fle	%x5 %f5 %f1	# 105 
	bne	%x5 %x0 fle_else.422	# 105 
	nop	# 105 
	fsw	%f2 0(%x2)	# 107 
	add	%x4 %x0 %x6	# 107 
	sw	%x1 12(%x2)	# 107 
	lw	%x5 0(%x4)	# 107 
	addi	%x2 %x2 16	# 107 
	jalr	%x1 0(%x5)	# 107 
	addi	%x2 %x2 -16	# 107 
	lw	%x1 12(%x2)	# 107 
	flw	%f2 0(%x2)	# 107 
	fmul	%f1 %f2 %f1	# 107 
	jr	0(%x1)	# 107 
	nop	# 107 
fle_else.422:	# 105 
	fle	%x5 %f6 %f1	# 106 
	bne	%x5 %x0 fle_else.423	# 106 
	nop	# 106 
	flw	%f4 0(%x29)	# 106 
	fsub	%f4 %f1 %f4	# 106 
	flw	%f5 0(%x29)	# 106 
	fadd	%f1 %f1 %f5	# 106 
	fdiv	%f1 %f4 %f1	# 106 
	fsw	%f2 0(%x2)	# 106 
	fsw	%f3 8(%x2)	# 106 
	add	%x4 %x0 %x6	# 106 
	sw	%x1 12(%x2)	# 106 
	lw	%x5 0(%x4)	# 106 
	addi	%x2 %x2 16	# 106 
	jalr	%x1 0(%x5)	# 106 
	addi	%x2 %x2 -16	# 106 
	lw	%x1 12(%x2)	# 106 
	flw	%f2 8(%x2)	# 106 
	fadd	%f1 %f2 %f1	# 106 
	flw	%f2 0(%x2)	# 106 
	fmul	%f1 %f2 %f1	# 106 
	jr	0(%x1)	# 106 
	nop	# 106 
fle_else.423:	# 106 
	fsw	%f2 0(%x2)	# 106 
	add	%x4 %x0 %x6	# 106 
	sw	%x1 12(%x2)	# 106 
	lw	%x5 0(%x4)	# 106 
	addi	%x2 %x2 16	# 106 
	jalr	%x1 0(%x5)	# 106 
	addi	%x2 %x2 -16	# 106 
	lw	%x1 12(%x2)	# 106 
	flw	%f2 0(%x2)	# 106 
	fmul	%f1 %f2 %f1	# 106 
	jr	0(%x1)	# 106 
	nop	# 106 
atan.225:	# 948
	lw	%x4 4(%x4)	# 111 
	flw	%f2 4(%x29)	# 111 
	fle	%x5 %f1 %f2	# 111 
	bne	%x5 %x0 fle_else.424	# 111 
	nop	# 111 
	flw	%f2 0(%x29)	# 111 
	lw	%x5 0(%x4)	# 111 
	jr	0(%x5)	# 111 
	nop	# 111 
fle_else.424:	# 111 
	flw	%f2 4(%x29)	# 112 
	fle	%x5 %f2 %f1	# 112 
	bne	%x5 %x0 fle_else.425	# 112 
	nop	# 112 
	flw	%f2 8(%x29)	# 112 
	fmul	%f1 %f2 %f1	# 112 
	flw	%f2 8(%x29)	# 112 
	lw	%x5 0(%x4)	# 112 
	jr	0(%x5)	# 112 
	nop	# 112 
fle_else.425:	# 112 
	flw	%f1 4(%x29)	# 113 
	jr	0(%x1)	# 113 
	nop	# 113 
min_caml_start:
	addi	%x4 %x0 1000
	addi	%x3 %x4 1000
	flw	%f1 12(%x29)	# 2 
	flw	%f2 16(%x29)	# 3 
	flw	%f3 20(%x29)	# 88 
	flw	%f4 24(%x29)	# 89 
	flw	%f5 28(%x29)	# 90 
	flw	%f6 32(%x29)	# 91 
	flw	%f7 36(%x29)	# 92 
	flw	%f8 40(%x29)	# 93 
	add	%x6 %x0 %x3	# 96 
	addi	%x3 %x3 28	# 96 
	addi	%x7 %x0 400	# 96 
	sw	%x7 0(%x6)	# 96 
	fsw	%f6 24(%x6)	# 96 
	fsw	%f5 20(%x6)	# 96 
	fsw	%f4 16(%x6)	# 96 
	fsw	%f3 12(%x6)	# 96 
	fsw	%f8 8(%x6)	# 96 
	fsw	%f7 4(%x6)	# 96 
	flw	%f3 44(%x29)	# 100 
	flw	%f4 48(%x29)	# 101 
	add	%x7 %x0 %x3	# 103 
	addi	%x3 %x3 24	# 103 
	addi	%x8 %x0 648	# 103 
	sw	%x8 0(%x7)	# 103 
	fsw	%f2 20(%x7)	# 103 
	fsw	%f1 16(%x7)	# 103 
	sw	%x6 12(%x7)	# 103 
	fsw	%f4 8(%x7)	# 103 
	fsw	%f3 4(%x7)	# 103 
	add	%x4 %x0 %x3	# 110 
	addi	%x3 %x3 8	# 110 
	addi	%x6 %x0 948	# 110 
	sw	%x6 0(%x4)	# 110 
	sw	%x7 4(%x4)	# 110 
	flw	%f1 52(%x29)	# 115 
	sw	%x1 4(%x2)	# 115 
	lw	%x5 0(%x4)	# 115 
	addi	%x2 %x2 8	# 115 
	jalr	%x1 0(%x5)	# 115 
	addi	%x2 %x2 -8	# 115 
	lw	%x1 4(%x2)	# 115 
