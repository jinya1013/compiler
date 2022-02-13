reduction_g.2691:	#- 832
	lw	%f3 0(%x29)	# 2 
	fle	%x5 %f3 %f1	# 2 
	bne	%x5 %x0 fle_else.9146	# 2 
	jr	0(%x1)	# 4 
fle_else.9146:	# 2 
	fle	%x5 %f2 %f1	# 3 
	bne	%x5 %x0 fle_else.9147	# 3 
	lw	%f3 4(%x29)	# 3 
	fdiv	%f2 %f2 %f3	# 3 
	j	reduction_g.2691	# 3 
fle_else.9147:	# 3 
	fsub	%f1 %f1 %f2	# 3 
	lw	%f3 4(%x29)	# 3 
	fdiv	%f2 %f2 %f3	# 3 
	j	reduction_g.2691	# 3 
reduction_f.2694:	#- 884
	fle	%x5 %f2 %f1	# 8 
	bne	%x5 %x0 fle_else.9148	# 8 
	j	reduction_g.2691	# 9 
fle_else.9148:	# 8 
	lw	%f3 4(%x29)	# 8 
	fmul	%f2 %f3 %f2	# 8 
	j	reduction_f.2694	# 8 
kernel_cos.2697:	#- 908
	fmul	%f1 %f1 %f1	# 13 
	fmul	%f3 %f1 %f1	# 14 
	fmul	%f4 %f3 %f1	# 15 
	lw	%f5 8(%x29)	# 16 
	lw	%f6 12(%x29)	# 16 
	fmul	%f1 %f6 %f1	# 16 
	fsub	%f1 %f5 %f1	# 16 
	lw	%f5 16(%x29)	# 16 
	fmul	%f3 %f5 %f3	# 16 
	fadd	%f1 %f1 %f3	# 16 
	lw	%f3 20(%x29)	# 16 
	fmul	%f3 %f3 %f4	# 16 
	fsub	%f1 %f1 %f3	# 16 
	fmul	%f1 %f2 %f1	# 16 
	jr	0(%x1)	# 16 
kernel_sin.2700:	#- 968
	fmul	%f3 %f1 %f1	# 20 
	fmul	%f4 %f3 %f1	# 21 
	fmul	%f5 %f4 %f3	# 22 
	fmul	%f3 %f5 %f3	# 23 
	lw	%f6 24(%x29)	# 24 
	fmul	%f4 %f6 %f4	# 24 
	fsub	%f1 %f1 %f4	# 24 
	lw	%f4 28(%x29)	# 24 
	fmul	%f4 %f4 %f5	# 24 
	fadd	%f1 %f1 %f4	# 24 
	lw	%f4 32(%x29)	# 24 
	fmul	%f3 %f4 %f3	# 24 
	fsub	%f1 %f1 %f3	# 24 
	fmul	%f1 %f2 %f1	# 24 
	jr	0(%x1)	# 24 
sin_h.2703:	#- 1028
	lw	%f3 36(%x29)	# 28 
	fle	%x5 %f1 %f3	# 28 
	bne	%x5 %x0 fle_else.9149	# 28 
	lw	%f3 40(%x29)	# 28 
	fsub	%f1 %f3 %f1	# 28 
	j	kernel_cos.2697	# 28 
fle_else.9149:	# 28 
	j	kernel_sin.2700	# 29 
cos_h.2706:	#- 1056
	lw	%f3 36(%x29)	# 33 
	fle	%x5 %f1 %f3	# 33 
	bne	%x5 %x0 fle_else.9150	# 33 
	lw	%f3 40(%x29)	# 33 
	fsub	%f1 %f3 %f1	# 33 
	j	kernel_sin.2700	# 33 
fle_else.9150:	# 33 
	j	kernel_cos.2697	# 34 
sin_g.2709:	#- 1084
	lw	%f3 40(%x29)	# 38 
	fle	%x5 %f3 %f1	# 38 
	bne	%x5 %x0 fle_else.9151	# 38 
	j	sin_h.2703	# 39 
fle_else.9151:	# 38 
	lw	%f3 44(%x29)	# 38 
	fsub	%f1 %f3 %f1	# 38 
	j	sin_h.2703	# 38 
cos_g.2712:	#- 1112
	lw	%f3 40(%x29)	# 43 
	fle	%x5 %f3 %f1	# 43 
	bne	%x5 %x0 fle_else.9152	# 43 
	j	cos_h.2706	# 44 
fle_else.9152:	# 43 
	lw	%f3 44(%x29)	# 43 
	fsub	%f1 %f3 %f1	# 43 
	lw	%f3 48(%x29)	# 43 
	fmul	%f2 %f3 %f2	# 43 
	j	cos_h.2706	# 43 
sin_f.2715:	#- 1148
	lw	%f3 44(%x29)	# 48 
	fle	%x5 %f3 %f1	# 48 
	bne	%x5 %x0 fle_else.9153	# 48 
	j	sin_g.2709	# 49 
fle_else.9153:	# 48 
	lw	%f3 44(%x29)	# 48 
	fsub	%f1 %f1 %f3	# 48 
	lw	%f3 48(%x29)	# 48 
	fmul	%f2 %f3 %f2	# 48 
	j	sin_g.2709	# 48 
cos_f.2718:	#- 1184
	lw	%f3 44(%x29)	# 53 
	fle	%x5 %f3 %f1	# 53 
	bne	%x5 %x0 fle_else.9154	# 53 
	j	cos_g.2712	# 54 
fle_else.9154:	# 53 
	lw	%f3 44(%x29)	# 53 
	fsub	%f1 %f1 %f3	# 53 
	lw	%f3 48(%x29)	# 53 
	fmul	%f2 %f3 %f2	# 53 
	j	cos_g.2712	# 53 
sin.2721:	#- 1220
	lw	%f2 52(%x29)	# 58 
	fle	%x5 %f1 %f2	# 58 
	bne	%x5 %x0 fle_else.9155	# 58 
	lw	%f2 0(%x29)	# 58 
	sw	%x1 0(%x2)	# 58 
	addi	%x2 %x2 -4	# 58 
	jal	 %x1 reduction_f.2694	# 58 
	addi	%x2 %x2 4	# 58 
	lw	%x1 0(%x2)	# 58 
	lw	%f2 8(%x29)	# 58 
	j	sin_f.2715	# 58 
fle_else.9155:	# 58 
	lw	%f2 52(%x29)	# 59 
	fle	%x5 %f2 %f1	# 59 
	bne	%x5 %x0 fle_else.9156	# 59 
	lw	%f2 48(%x29)	# 59 
	fmul	%f1 %f2 %f1	# 59 
	lw	%f2 0(%x29)	# 59 
	sw	%x1 0(%x2)	# 59 
	addi	%x2 %x2 -4	# 59 
	jal	 %x1 reduction_f.2694	# 59 
	addi	%x2 %x2 4	# 59 
	lw	%x1 0(%x2)	# 59 
	lw	%f2 48(%x29)	# 59 
	j	sin_f.2715	# 59 
fle_else.9156:	# 59 
	lw	%f1 52(%x29)	# 60 
	jr	0(%x1)	# 60 
cos.2723:	#- 1324
	lw	%f2 52(%x29)	# 64 
	fle	%x5 %f1 %f2	# 64 
	bne	%x5 %x0 fle_else.9157	# 64 
	lw	%f2 0(%x29)	# 64 
	sw	%x1 0(%x2)	# 64 
	addi	%x2 %x2 -4	# 64 
	jal	 %x1 reduction_f.2694	# 64 
	addi	%x2 %x2 4	# 64 
	lw	%x1 0(%x2)	# 64 
	lw	%f2 8(%x29)	# 64 
	j	cos_f.2718	# 64 
fle_else.9157:	# 64 
	lw	%f2 52(%x29)	# 65 
	fle	%x5 %f2 %f1	# 65 
	bne	%x5 %x0 fle_else.9158	# 65 
	lw	%f2 48(%x29)	# 65 
	fmul	%f1 %f2 %f1	# 65 
	lw	%f2 0(%x29)	# 65 
	sw	%x1 0(%x2)	# 65 
	addi	%x2 %x2 -4	# 65 
	jal	 %x1 reduction_f.2694	# 65 
	addi	%x2 %x2 4	# 65 
	lw	%x1 0(%x2)	# 65 
	lw	%f2 8(%x29)	# 65 
	j	cos_f.2718	# 65 
fle_else.9158:	# 65 
	lw	%f1 8(%x29)	# 66 
	jr	0(%x1)	# 66 