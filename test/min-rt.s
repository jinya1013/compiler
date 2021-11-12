l.4552:	# 128.000000
	.long	0x0
	.long	0x40600000
l.4540:	# 40000.000000
	.long	0x0
	.long	0x40e38800
l.4479:	# -2.000000
	.long	0x0
	.long	0xc0000000
l.4477:	# 0.100000
	.long	0x9999999a
	.long	0x3fb99999
l.4474:	# 0.200000
	.long	0x9999999a
	.long	0x3fc99999
l.4434:	# 20.000000
	.long	0x0
	.long	0x40340000
l.4432:	# 0.050000
	.long	0x9999999a
	.long	0x3fa99999
l.4424:	# 0.250000
	.long	0x0
	.long	0x3fd00000
l.4417:	# 255.000000
	.long	0x0
	.long	0x406fe000
l.4415:	# 3.141593
	.long	0x5a7ed197
	.long	0x400921fb
l.4413:	# 10.000000
	.long	0x0
	.long	0x40240000
l.4407:	# 850.000000
	.long	0x0
	.long	0x408a9000
l.4403:	# 0.500000
	.long	0x0
	.long	0x3fe00000
l.4401:	# 0.150000
	.long	0x33333333
	.long	0x3fc33333
l.4395:	# 9.549296
	.long	0x62316387
	.long	0x4023193d
l.4393:	# 15.000000
	.long	0x0
	.long	0x402e0000
l.4391:	# 0.000100
	.long	0xeb1c432d
	.long	0x3f1a36e2
l.4338:	# 100000000.000000
	.long	0x0
	.long	0x4197d784
l.4332:	# 1000000000.000000
	.long	0x0
	.long	0x41cdcd65
l.4296:	# -0.100000
	.long	0x9999999a
	.long	0xbfb99999
l.4280:	# 0.010000
	.long	0x47ae147b
	.long	0x3f847ae1
l.4278:	# -0.200000
	.long	0x9999999a
	.long	0xbfc99999
l.4246:	# 4.000000
	.long	0x0
	.long	0x40100000
l.4017:	# -200.000000
	.long	0x0
	.long	0xc0690000
l.4002:	# 0.017453
	.long	0xaa91ed06
	.long	0x3f91df46
l.4000:	# -1.000000
	.long	0x0
	.long	0xbff00000
l.3998:	# 1.000000
	.long	0x0
	.long	0x3ff00000
l.3996:	# 0.000000
	.long	0x0
	.long	0x0
l.3971:	# 2.000000
	.long	0x0
	.long	0x40000000
xor.1759:
	addi	%x5 %x0 0	# 126 
	bne	%x6 %x5 beq_else.5827	# 126 
	nop	# 126 
	add	%x6 %x0 %x7	# 126 
	jr	0(%x1)	# 126 
	nop	# 126 
beq_else.5827:	# 126 
	addi	%x5 %x0 0	# 126 
	bne	%x7 %x5 beq_else.5828	# 126 
	nop	# 126 
	addi	%x6 %x0 1	# 126 
	jr	0(%x1)	# 126 
	nop	# 126 
beq_else.5828:	# 126 
	addi	%x6 %x0 0	# 126 
	jr	0(%x1)	# 126 
	nop	# 126 
fsqr.1762:
	fmul	%f1 %f1 %f1	# 129 
	jr	0(%x1)	# 129 
	nop	# 129 
fhalf.1764:
	addi	%x6 %x0 l.3971	# 132 
	flw	%f2 (0)%x6	# 132 
	fdiv	%f1 %f1 %f2	# 132 
	jr	0(%x1)	# 132 
	nop	# 132 
o_texturetype.1766:
	lw	%x6 0(%x6)	# 140 
	jr	0(%x1)	# 145 
	nop	# 145 
o_form.1768:
	lw	%x6 4(%x6)	# 150 
	jr	0(%x1)	# 155 
	nop	# 155 
o_reflectiontype.1770:
	lw	%x6 8(%x6)	# 160 
	jr	0(%x1)	# 165 
	nop	# 165 
o_isinvert.1772:
	lw	%x6 24(%x6)	# 170 
	jr	0(%x1)	# 174 
	nop	# 174 
o_isrot.1774:
	lw	%x6 12(%x6)	# 179 
	jr	0(%x1)	# 183 
	nop	# 183 
o_param_a.1776:
	lw	%x6 16(%x6)	# 188 
	flw	%f1 (0)%x6	# 193 
	jr	0(%x1)	# 193 
	nop	# 193 
o_param_b.1778:
	lw	%x6 16(%x6)	# 198 
	flw	%f1 (4)%x6	# 203 
	jr	0(%x1)	# 203 
	nop	# 203 
o_param_c.1780:
	lw	%x6 16(%x6)	# 208 
	flw	%f1 (8)%x6	# 213 
	jr	0(%x1)	# 213 
	nop	# 213 
o_param_x.1782:
	lw	%x6 20(%x6)	# 218 
	flw	%f1 (0)%x6	# 223 
	jr	0(%x1)	# 223 
	nop	# 223 
o_param_y.1784:
	lw	%x6 20(%x6)	# 228 
	flw	%f1 (4)%x6	# 233 
	jr	0(%x1)	# 233 
	nop	# 233 
o_param_z.1786:
	lw	%x6 20(%x6)	# 238 
	flw	%f1 (8)%x6	# 243 
	jr	0(%x1)	# 243 
	nop	# 243 
o_diffuse.1788:
	lw	%x6 28(%x6)	# 248 
	flw	%f1 (0)%x6	# 253 
	jr	0(%x1)	# 253 
	nop	# 253 
o_hilight.1790:
	lw	%x6 28(%x6)	# 258 
	flw	%f1 (4)%x6	# 263 
	jr	0(%x1)	# 263 
	nop	# 263 
o_color_red.1792:
	lw	%x6 32(%x6)	# 268 
	flw	%f1 (0)%x6	# 273 
	jr	0(%x1)	# 273 
	nop	# 273 
o_color_green.1794:
	lw	%x6 32(%x6)	# 278 
	flw	%f1 (4)%x6	# 283 
	jr	0(%x1)	# 283 
	nop	# 283 
o_color_blue.1796:
	lw	%x6 32(%x6)	# 288 
	flw	%f1 (8)%x6	# 293 
	jr	0(%x1)	# 293 
	nop	# 293 
o_param_r1.1798:
	lw	%x6 36(%x6)	# 298 
	flw	%f1 (0)%x6	# 303 
	jr	0(%x1)	# 303 
	nop	# 303 
o_param_r2.1800:
	lw	%x6 36(%x6)	# 308 
	flw	%f1 (4)%x6	# 313 
	jr	0(%x1)	# 313 
	nop	# 313 
o_param_r3.1802:
	lw	%x6 36(%x6)	# 318 
	flw	%f1 (8)%x6	# 323 
	jr	0(%x1)	# 323 
	nop	# 323 
normalize_vector.1804:
	flw	%f1 (0)%x6	# 328 
	sw	%x7 0(%x2)	# 328 
	sw	%x6 4(%x2)	# 328 
	sw	%x1 12(%x2)	# 328 
	addi	%x2 %x2 16	# 328 
	jal	 %x1 fsqr.1762	# 328 
	addi	%x2 %x2 -16	# 328 
	lw	%x1 12(%x2)	# 328 
	lw	%x6 4(%x2)	# 328 
	flw	%f2 (4)%x6	# 328 
	fsw	%f1 8(%x2)	# 328 
	fadd	%f1 %f2 %f0	# 328 
	sw	%x1 12(%x2)	# 328 
	addi	%x2 %x2 16	# 328 
	jal	 %x1 fsqr.1762	# 328 
	addi	%x2 %x2 -16	# 328 
	lw	%x1 12(%x2)	# 328 
	flw	%f2 8(%x2)	# 328 
	fadd	%f1 %f2 %f1	# 328 
	lw	%x6 4(%x2)	# 328 
	flw	%f2 (8)%x6	# 328 
	fsw	%f1 12(%x2)	# 328 
	fadd	%f1 %f2 %f0	# 328 
	sw	%x1 20(%x2)	# 328 
	addi	%x2 %x2 24	# 328 
	jal	 %x1 fsqr.1762	# 328 
	addi	%x2 %x2 -24	# 328 
	lw	%x1 20(%x2)	# 328 
	flw	%f2 12(%x2)	# 328 
	fadd	%f1 %f2 %f1	# 328 
	sw	%x1 20(%x2)	# 328 
	addi	%x2 %x2 24	# 328 
	jal	 %x1 min_caml_sqrt	# 328 
	addi	%x2 %x2 -24	# 328 
	lw	%x1 20(%x2)	# 328 
	lw	%x6 0(%x2)	# 329 
	addi	%x5 %x0 0	# 329 
	bne	%x6 %x5 beq_else.5829	# 329 
	nop	# 329 
	j	beq_cont.5830	# 329 
	nop	# 329 
beq_else.5829:	# 329 
	fneg	%f1 %f1	# 329 
beq_cont.5830:	# 329 
	lw	%x6 4(%x2)	# 330 
	flw	%f2 (0)%x6	# 330 
	fdiv	%f2 %f2 %f1	# 330 
	fsw	%f2 (0)%x6	# 330 

	flw	%f2 (4)%x6	# 331 
	fdiv	%f2 %f2 %f1	# 331 
	fsw	%f2 (4)%x6	# 331 

	flw	%f2 (8)%x6	# 332 
	fdiv	%f1 %f2 %f1	# 332 
	fsw	%f1 (8)%x6	# 332 

	jr	0(%x1)	# 332 
	nop	# 332 
sgn.1807:
	addi	%x6 %x0 l.3996	# 337 
	flw	%f2 (0)%x6	# 337 
	fle	%f1 %f2 fle.5832	# 337 
	nop	# 337 
	addi	%x6 %x0 l.3998	# 337 
	flw	%f1 (0)%x6	# 337 
	jr	0(%x1)	# 337 
	nop	# 337 
fle.5832:	# 337 
	addi	%x6 %x0 l.4000	# 338 
	flw	%f1 (0)%x6	# 338 
	jr	0(%x1)	# 338 
	nop	# 338 
rad.1809:
	addi	%x6 %x0 l.4002	# 344 
	flw	%f2 (0)%x6	# 344 
	fmul	%f1 %f1 %f2	# 344 
	jr	0(%x1)	# 344 
	nop	# 344 
read_environ.1811:
	lw	%x6 28(%x4)	# 353 
	lw	%x7 24(%x4)	# 353 
	lw	%x8 20(%x4)	# 353 
	lw	%x9 16(%x4)	# 353 
	lw	%x10 12(%x4)	# 353 
	lw	%x11 8(%x4)	# 353 
	lw	%x12 4(%x4)	# 353 
	sw	%x7 0(%x2)	# 353 
	sw	%x6 4(%x2)	# 353 
	sw	%x12 8(%x2)	# 353 
	sw	%x10 12(%x2)	# 353 
	sw	%x8 16(%x2)	# 353 
	sw	%x11 20(%x2)	# 353 
	sw	%x9 24(%x2)	# 353 
	sw	%x1 28(%x2)	# 353 
	addi	%x2 %x2 32	# 353 
	jal	 %x1 min_caml_read_float	# 353 
	addi	%x2 %x2 -32	# 353 
	lw	%x1 28(%x2)	# 353 
	lw	%x6 24(%x2)	# 353 
	fsw	%f1 (0)%x6	# 353 

	sw	%x1 28(%x2)	# 354 
	addi	%x2 %x2 32	# 354 
	jal	 %x1 min_caml_read_float	# 354 
	addi	%x2 %x2 -32	# 354 
	lw	%x1 28(%x2)	# 354 
	lw	%x6 24(%x2)	# 354 
	fsw	%f1 (4)%x6	# 354 

	sw	%x1 28(%x2)	# 355 
	addi	%x2 %x2 32	# 355 
	jal	 %x1 min_caml_read_float	# 355 
	addi	%x2 %x2 -32	# 355 
	lw	%x1 28(%x2)	# 355 
	lw	%x6 24(%x2)	# 355 
	fsw	%f1 (8)%x6	# 355 

	sw	%x1 28(%x2)	# 357 
	addi	%x2 %x2 32	# 357 
	jal	 %x1 min_caml_read_float	# 357 
	addi	%x2 %x2 -32	# 357 
	lw	%x1 28(%x2)	# 357 
	sw	%x1 28(%x2)	# 357 
	addi	%x2 %x2 32	# 357 
	jal	 %x1 rad.1809	# 357 
	addi	%x2 %x2 -32	# 357 
	lw	%x1 28(%x2)	# 357 
	fsw	%f1 28(%x2)	# 358 
	sw	%x1 36(%x2)	# 358 
	addi	%x2 %x2 40	# 358 
	jal	 %x1 min_caml_cos	# 358 
	addi	%x2 %x2 -40	# 358 
	lw	%x1 36(%x2)	# 358 
	lw	%x6 20(%x2)	# 358 
	fsw	%f1 (0)%x6	# 358 

	flw	%f1 28(%x2)	# 359 
	sw	%x1 36(%x2)	# 359 
	addi	%x2 %x2 40	# 359 
	jal	 %x1 min_caml_sin	# 359 
	addi	%x2 %x2 -40	# 359 
	lw	%x1 36(%x2)	# 359 
	lw	%x6 16(%x2)	# 359 
	fsw	%f1 (0)%x6	# 359 

	sw	%x1 36(%x2)	# 360 
	addi	%x2 %x2 40	# 360 
	jal	 %x1 min_caml_read_float	# 360 
	addi	%x2 %x2 -40	# 360 
	lw	%x1 36(%x2)	# 360 
	sw	%x1 36(%x2)	# 360 
	addi	%x2 %x2 40	# 360 
	jal	 %x1 rad.1809	# 360 
	addi	%x2 %x2 -40	# 360 
	lw	%x1 36(%x2)	# 360 
	fsw	%f1 32(%x2)	# 361 
	sw	%x1 36(%x2)	# 361 
	addi	%x2 %x2 40	# 361 
	jal	 %x1 min_caml_cos	# 361 
	addi	%x2 %x2 -40	# 361 
	lw	%x1 36(%x2)	# 361 
	lw	%x6 20(%x2)	# 361 
	fsw	%f1 (4)%x6	# 361 

	flw	%f1 32(%x2)	# 362 
	sw	%x1 36(%x2)	# 362 
	addi	%x2 %x2 40	# 362 
	jal	 %x1 min_caml_sin	# 362 
	addi	%x2 %x2 -40	# 362 
	lw	%x1 36(%x2)	# 362 
	lw	%x6 16(%x2)	# 362 
	fsw	%f1 (4)%x6	# 362 

	sw	%x1 36(%x2)	# 364 
	addi	%x2 %x2 40	# 364 
	jal	 %x1 min_caml_read_float	# 364 
	addi	%x2 %x2 -40	# 364 
	lw	%x1 36(%x2)	# 364 
	sw	%x1 36(%x2)	# 367 
	addi	%x2 %x2 40	# 367 
	jal	 %x1 min_caml_read_float	# 367 
	addi	%x2 %x2 -40	# 367 
	lw	%x1 36(%x2)	# 367 
	sw	%x1 36(%x2)	# 367 
	addi	%x2 %x2 40	# 367 
	jal	 %x1 rad.1809	# 367 
	addi	%x2 %x2 -40	# 367 
	lw	%x1 36(%x2)	# 367 
	fsw	%f1 36(%x2)	# 368 
	sw	%x1 44(%x2)	# 368 
	addi	%x2 %x2 48	# 368 
	jal	 %x1 min_caml_sin	# 368 
	addi	%x2 %x2 -48	# 368 
	lw	%x1 44(%x2)	# 368 
	fneg	%f1 %f1	# 369 
	lw	%x6 12(%x2)	# 369 
	fsw	%f1 (4)%x6	# 369 

	sw	%x1 44(%x2)	# 370 
	addi	%x2 %x2 48	# 370 
	jal	 %x1 min_caml_read_float	# 370 
	addi	%x2 %x2 -48	# 370 
	lw	%x1 44(%x2)	# 370 
	sw	%x1 44(%x2)	# 370 
	addi	%x2 %x2 48	# 370 
	jal	 %x1 rad.1809	# 370 
	addi	%x2 %x2 -48	# 370 
	lw	%x1 44(%x2)	# 370 
	flw	%f2 36(%x2)	# 371 
	fsw	%f1 40(%x2)	# 371 
	fadd	%f1 %f2 %f0	# 371 
	sw	%x1 44(%x2)	# 371 
	addi	%x2 %x2 48	# 371 
	jal	 %x1 min_caml_cos	# 371 
	addi	%x2 %x2 -48	# 371 
	lw	%x1 44(%x2)	# 371 
	flw	%f2 40(%x2)	# 372 
	fsw	%f1 44(%x2)	# 372 
	fadd	%f1 %f2 %f0	# 372 
	sw	%x1 52(%x2)	# 372 
	addi	%x2 %x2 56	# 372 
	jal	 %x1 min_caml_sin	# 372 
	addi	%x2 %x2 -56	# 372 
	lw	%x1 52(%x2)	# 372 
	flw	%f2 44(%x2)	# 373 
	fmul	%f1 %f2 %f1	# 373 
	lw	%x6 12(%x2)	# 373 
	fsw	%f1 (0)%x6	# 373 

	flw	%f1 40(%x2)	# 374 
	sw	%x1 52(%x2)	# 374 
	addi	%x2 %x2 56	# 374 
	jal	 %x1 min_caml_cos	# 374 
	addi	%x2 %x2 -56	# 374 
	lw	%x1 52(%x2)	# 374 
	flw	%f2 44(%x2)	# 375 
	fmul	%f1 %f2 %f1	# 375 
	lw	%x6 12(%x2)	# 375 
	fsw	%f1 (8)%x6	# 375 

	sw	%x1 52(%x2)	# 376 
	addi	%x2 %x2 56	# 376 
	jal	 %x1 min_caml_read_float	# 376 
	addi	%x2 %x2 -56	# 376 
	lw	%x1 52(%x2)	# 376 
	lw	%x6 8(%x2)	# 376 
	fsw	%f1 (0)%x6	# 376 

	lw	%x6 20(%x2)	# 379 
	flw	%f1 (0)%x6	# 379 
	lw	%x7 16(%x2)	# 379 
	flw	%f2 (4)%x7	# 379 
	fmul	%f1 %f1 %f2	# 379 
	addi	%x8 %x0 l.4017	# 379 
	flw	%f2 (0)%x8	# 379 
	fmul	%f1 %f1 %f2	# 379 
	lw	%x8 4(%x2)	# 379 
	fsw	%f1 (0)%x8	# 379 

	flw	%f1 (0)%x7	# 380 
	fneg	%f1 %f1	# 380 
	addi	%x7 %x0 l.4017	# 380 
	flw	%f2 (0)%x7	# 380 
	fmul	%f1 %f1 %f2	# 380 
	fsw	%f1 (4)%x8	# 380 

	flw	%f1 (0)%x6	# 381 
	flw	%f2 (4)%x6	# 381 
	fmul	%f1 %f1 %f2	# 381 
	addi	%x6 %x0 l.4017	# 381 
	flw	%f2 (0)%x6	# 381 
	fmul	%f1 %f1 %f2	# 381 
	fsw	%f1 (8)%x8	# 381 

	flw	%f1 (0)%x8	# 384 
	lw	%x6 24(%x2)	# 384 
	flw	%f2 (0)%x6	# 384 
	fadd	%f1 %f1 %f2	# 384 
	lw	%x7 0(%x2)	# 384 
	fsw	%f1 (0)%x7	# 384 

	flw	%f1 (4)%x8	# 385 
	flw	%f2 (4)%x6	# 385 
	fadd	%f1 %f1 %f2	# 385 
	fsw	%f1 (4)%x7	# 385 

	flw	%f1 (8)%x8	# 386 
	flw	%f2 (8)%x6	# 386 
	fadd	%f1 %f1 %f2	# 386 
	fsw	%f1 (8)%x7	# 386 

	jr	0(%x1)	# 386 
	nop	# 386 
read_nth_object.1813:
	lw	%x7 8(%x4)	# 395 
	lw	%x8 4(%x4)	# 395 
	sw	%x8 0(%x2)	# 395 
	sw	%x7 4(%x2)	# 395 
	sw	%x6 8(%x2)	# 395 
	sw	%x1 12(%x2)	# 395 
	addi	%x2 %x2 16	# 395 
	jal	 %x1 min_caml_read_int	# 395 
	addi	%x2 %x2 -16	# 395 
	lw	%x1 12(%x2)	# 395 
	addi	%x5 %x0 -1	# 396 
	bne	%x6 %x5 beq_else.5834	# 396 
	nop	# 396 
	addi	%x6 %x0 0	# 515 
	jr	0(%x1)	# 515 
	nop	# 515 
beq_else.5834:	# 396 
	sw	%x6 12(%x2)	# 398 
	sw	%x1 20(%x2)	# 398 
	addi	%x2 %x2 24	# 398 
	jal	 %x1 min_caml_read_int	# 398 
	addi	%x2 %x2 -24	# 398 
	lw	%x1 20(%x2)	# 398 
	sw	%x6 16(%x2)	# 399 
	sw	%x1 20(%x2)	# 399 
	addi	%x2 %x2 24	# 399 
	jal	 %x1 min_caml_read_int	# 399 
	addi	%x2 %x2 -24	# 399 
	lw	%x1 20(%x2)	# 399 
	sw	%x6 20(%x2)	# 400 
	sw	%x1 28(%x2)	# 400 
	addi	%x2 %x2 32	# 400 
	jal	 %x1 min_caml_read_int	# 400 
	addi	%x2 %x2 -32	# 400 
	lw	%x1 28(%x2)	# 400 
	addi	%x7 %x0 3	# 402 
	addi	%x8 %x0 l.3996	# 402 
	flw	%f1 (0)%x8	# 402 
	sw	%x6 24(%x2)	# 402 
	add	%x6 %x0 %x7	# 402 
	sw	%x1 28(%x2)	# 402 
	addi	%x2 %x2 32	# 402 
	jal	 %x1 min_caml_create_float_array	# 402 
	addi	%x2 %x2 -32	# 402 
	lw	%x1 28(%x2)	# 402 
	sw	%x6 28(%x2)	# 404 
	sw	%x1 36(%x2)	# 404 
	addi	%x2 %x2 40	# 404 
	jal	 %x1 min_caml_read_float	# 404 
	addi	%x2 %x2 -40	# 404 
	lw	%x1 36(%x2)	# 404 
	lw	%x6 28(%x2)	# 404 
	fsw	%f1 (0)%x6	# 404 

	sw	%x1 36(%x2)	# 405 
	addi	%x2 %x2 40	# 405 
	jal	 %x1 min_caml_read_float	# 405 
	addi	%x2 %x2 -40	# 405 
	lw	%x1 36(%x2)	# 405 
	lw	%x6 28(%x2)	# 405 
	fsw	%f1 (4)%x6	# 405 

	sw	%x1 36(%x2)	# 406 
	addi	%x2 %x2 40	# 406 
	jal	 %x1 min_caml_read_float	# 406 
	addi	%x2 %x2 -40	# 406 
	lw	%x1 36(%x2)	# 406 
	lw	%x6 28(%x2)	# 406 
	fsw	%f1 (8)%x6	# 406 

	addi	%x7 %x0 3	# 408 
	addi	%x8 %x0 l.3996	# 408 
	flw	%f1 (0)%x8	# 408 
	add	%x6 %x0 %x7	# 408 
	sw	%x1 36(%x2)	# 408 
	addi	%x2 %x2 40	# 408 
	jal	 %x1 min_caml_create_float_array	# 408 
	addi	%x2 %x2 -40	# 408 
	lw	%x1 36(%x2)	# 408 
	sw	%x6 32(%x2)	# 410 
	sw	%x1 36(%x2)	# 410 
	addi	%x2 %x2 40	# 410 
	jal	 %x1 min_caml_read_float	# 410 
	addi	%x2 %x2 -40	# 410 
	lw	%x1 36(%x2)	# 410 
	lw	%x6 32(%x2)	# 410 
	fsw	%f1 (0)%x6	# 410 

	sw	%x1 36(%x2)	# 411 
	addi	%x2 %x2 40	# 411 
	jal	 %x1 min_caml_read_float	# 411 
	addi	%x2 %x2 -40	# 411 
	lw	%x1 36(%x2)	# 411 
	lw	%x6 32(%x2)	# 411 
	fsw	%f1 (4)%x6	# 411 

	sw	%x1 36(%x2)	# 412 
	addi	%x2 %x2 40	# 412 
	jal	 %x1 min_caml_read_float	# 412 
	addi	%x2 %x2 -40	# 412 
	lw	%x1 36(%x2)	# 412 
	lw	%x6 32(%x2)	# 412 
	fsw	%f1 (8)%x6	# 412 

	addi	%x7 %x0 l.3996	# 414 
	flw	%f1 (0)%x7	# 414 
	fsw	%f1 36(%x2)	# 414 
	sw	%x1 44(%x2)	# 414 
	addi	%x2 %x2 48	# 414 
	jal	 %x1 min_caml_read_float	# 414 
	addi	%x2 %x2 -48	# 414 
	lw	%x1 44(%x2)	# 414 
	flw	%f2 36(%x2)	# 414 
	fblt	%f2 %f1 fblt.5835	# 414 
	nop	# 414 
	addi	%x6 %x0 1	# 414 
	j	fblt_cont.5836	# 414 
	nop	# 414 
fblt.5835:	# 414 
	addi	%x6 %x0 0	# 414 
fblt_cont.5836:	# 414 
	addi	%x7 %x0 2	# 416 
	addi	%x8 %x0 l.3996	# 416 
	flw	%f1 (0)%x8	# 416 
	sw	%x6 40(%x2)	# 416 
	add	%x6 %x0 %x7	# 416 
	sw	%x1 44(%x2)	# 416 
	addi	%x2 %x2 48	# 416 
	jal	 %x1 min_caml_create_float_array	# 416 
	addi	%x2 %x2 -48	# 416 
	lw	%x1 44(%x2)	# 416 
	sw	%x6 44(%x2)	# 418 
	sw	%x1 52(%x2)	# 418 
	addi	%x2 %x2 56	# 418 
	jal	 %x1 min_caml_read_float	# 418 
	addi	%x2 %x2 -56	# 418 
	lw	%x1 52(%x2)	# 418 
	lw	%x6 44(%x2)	# 418 
	fsw	%f1 (0)%x6	# 418 

	sw	%x1 52(%x2)	# 419 
	addi	%x2 %x2 56	# 419 
	jal	 %x1 min_caml_read_float	# 419 
	addi	%x2 %x2 -56	# 419 
	lw	%x1 52(%x2)	# 419 
	lw	%x6 44(%x2)	# 419 
	fsw	%f1 (4)%x6	# 419 

	addi	%x7 %x0 3	# 421 
	addi	%x8 %x0 l.3996	# 421 
	flw	%f1 (0)%x8	# 421 
	add	%x6 %x0 %x7	# 421 
	sw	%x1 52(%x2)	# 421 
	addi	%x2 %x2 56	# 421 
	jal	 %x1 min_caml_create_float_array	# 421 
	addi	%x2 %x2 -56	# 421 
	lw	%x1 52(%x2)	# 421 
	sw	%x6 48(%x2)	# 423 
	sw	%x1 52(%x2)	# 423 
	addi	%x2 %x2 56	# 423 
	jal	 %x1 min_caml_read_float	# 423 
	addi	%x2 %x2 -56	# 423 
	lw	%x1 52(%x2)	# 423 
	lw	%x6 48(%x2)	# 423 
	fsw	%f1 (0)%x6	# 423 

	sw	%x1 52(%x2)	# 424 
	addi	%x2 %x2 56	# 424 
	jal	 %x1 min_caml_read_float	# 424 
	addi	%x2 %x2 -56	# 424 
	lw	%x1 52(%x2)	# 424 
	lw	%x6 48(%x2)	# 424 
	fsw	%f1 (4)%x6	# 424 

	sw	%x1 52(%x2)	# 425 
	addi	%x2 %x2 56	# 425 
	jal	 %x1 min_caml_read_float	# 425 
	addi	%x2 %x2 -56	# 425 
	lw	%x1 52(%x2)	# 425 
	lw	%x6 48(%x2)	# 425 
	fsw	%f1 (8)%x6	# 425 

	addi	%x7 %x0 3	# 427 
	addi	%x8 %x0 l.3996	# 427 
	flw	%f1 (0)%x8	# 427 
	add	%x6 %x0 %x7	# 427 
	sw	%x1 52(%x2)	# 427 
	addi	%x2 %x2 56	# 427 
	jal	 %x1 min_caml_create_float_array	# 427 
	addi	%x2 %x2 -56	# 427 
	lw	%x1 52(%x2)	# 427 
	lw	%x7 24(%x2)	# 428 
	addi	%x5 %x0 0	# 428 
	bne	%x7 %x5 beq_else.5837	# 428 
	nop	# 428 
	j	beq_cont.5838	# 428 
	nop	# 428 
beq_else.5837:	# 428 
	sw	%x6 52(%x2)	# 430 
	sw	%x1 60(%x2)	# 430 
	addi	%x2 %x2 64	# 430 
	jal	 %x1 min_caml_read_float	# 430 
	addi	%x2 %x2 -64	# 430 
	lw	%x1 60(%x2)	# 430 
	sw	%x1 60(%x2)	# 430 
	addi	%x2 %x2 64	# 430 
	jal	 %x1 rad.1809	# 430 
	addi	%x2 %x2 -64	# 430 
	lw	%x1 60(%x2)	# 430 
	lw	%x6 52(%x2)	# 430 
	fsw	%f1 (0)%x6	# 430 

	sw	%x1 60(%x2)	# 431 
	addi	%x2 %x2 64	# 431 
	jal	 %x1 min_caml_read_float	# 431 
	addi	%x2 %x2 -64	# 431 
	lw	%x1 60(%x2)	# 431 
	sw	%x1 60(%x2)	# 431 
	addi	%x2 %x2 64	# 431 
	jal	 %x1 rad.1809	# 431 
	addi	%x2 %x2 -64	# 431 
	lw	%x1 60(%x2)	# 431 
	lw	%x6 52(%x2)	# 431 
	fsw	%f1 (4)%x6	# 431 

	sw	%x1 60(%x2)	# 432 
	addi	%x2 %x2 64	# 432 
	jal	 %x1 min_caml_read_float	# 432 
	addi	%x2 %x2 -64	# 432 
	lw	%x1 60(%x2)	# 432 
	sw	%x1 60(%x2)	# 432 
	addi	%x2 %x2 64	# 432 
	jal	 %x1 rad.1809	# 432 
	addi	%x2 %x2 -64	# 432 
	lw	%x1 60(%x2)	# 432 
	lw	%x6 52(%x2)	# 432 
	fsw	%f1 (8)%x6	# 432 

beq_cont.5838:	# 428 
	lw	%x7 16(%x2)	# 439 
	addi	%x5 %x0 2	# 439 
	bne	%x7 %x5 beq_else.5839	# 439 
	nop	# 439 
	addi	%x8 %x0 1	# 439 
	j	beq_cont.5840	# 439 
	nop	# 439 
beq_else.5839:	# 439 
	lw	%x8 40(%x2)	# 439 
beq_cont.5840:	# 439 
	add	%x9 %x0 %x3	# 443 
	addi	%x3 %x3 40	# 443 
	sw	%x6 36(%x9)	# 443 
	lw	%x10 48(%x2)	# 443 
	sw	%x10 32(%x9)	# 443 
	lw	%x10 44(%x2)	# 443 
	sw	%x10 28(%x9)	# 443 
	sw	%x8 24(%x9)	# 443 
	lw	%x8 32(%x2)	# 443 
	sw	%x8 20(%x9)	# 443 
	lw	%x8 28(%x2)	# 443 
	sw	%x8 16(%x9)	# 443 
	lw	%x10 24(%x2)	# 443 
	sw	%x10 12(%x9)	# 443 
	lw	%x11 20(%x2)	# 443 
	sw	%x11 8(%x9)	# 443 
	sw	%x7 4(%x9)	# 443 
	lw	%x11 12(%x2)	# 443 
	sw	%x11 0(%x9)	# 443 
	lw	%x11 8(%x2)	# 450 
	sll	%x11 %x11 2	# 450 
	lw	%x12 4(%x2)	# 450 
	sw	%x9 %x11(%x12)	# 450 
	sw	%x6 52(%x2)	# 452 
	addi	%x5 %x0 3	# 452 
	bne	%x7 %x5 beq_else.5841	# 452 
	nop	# 452 
	flw	%f1 (0)%x8	# 455 
	addi	%x7 %x0 l.3996	# 456 
	flw	%f2 (0)%x7	# 456 
	feq	%f2 %f1 feq.5843	# 456 
	nop	# 456 
	fsw	%f1 56(%x2)	# 456 
	sw	%x1 60(%x2)	# 456 
	addi	%x2 %x2 64	# 456 
	jal	 %x1 sgn.1807	# 456 
	addi	%x2 %x2 -64	# 456 
	lw	%x1 60(%x2)	# 456 
	flw	%f2 56(%x2)	# 456 
	fsw	%f1 60(%x2)	# 456 
	fadd	%f1 %f2 %f0	# 456 
	sw	%x1 68(%x2)	# 456 
	addi	%x2 %x2 72	# 456 
	jal	 %x1 fsqr.1762	# 456 
	addi	%x2 %x2 -72	# 456 
	lw	%x1 68(%x2)	# 456 
	flw	%f2 60(%x2)	# 456 
	fdiv	%f1 %f2 %f1	# 456 
	j	feq_cont.5844	# 456 
	nop	# 456 
feq.5843:	# 456 
	addi	%x7 %x0 l.3996	# 456 
	flw	%f1 (0)%x7	# 456 
feq_cont.5844:	# 456 
	lw	%x6 28(%x2)	# 456 
	fsw	%f1 (0)%x6	# 456 

	flw	%f1 (4)%x6	# 457 
	addi	%x7 %x0 l.3996	# 458 
	flw	%f2 (0)%x7	# 458 
	feq	%f2 %f1 feq.5845	# 458 
	nop	# 458 
	fsw	%f1 64(%x2)	# 458 
	sw	%x1 68(%x2)	# 458 
	addi	%x2 %x2 72	# 458 
	jal	 %x1 sgn.1807	# 458 
	addi	%x2 %x2 -72	# 458 
	lw	%x1 68(%x2)	# 458 
	flw	%f2 64(%x2)	# 458 
	fsw	%f1 68(%x2)	# 458 
	fadd	%f1 %f2 %f0	# 458 
	sw	%x1 76(%x2)	# 458 
	addi	%x2 %x2 80	# 458 
	jal	 %x1 fsqr.1762	# 458 
	addi	%x2 %x2 -80	# 458 
	lw	%x1 76(%x2)	# 458 
	flw	%f2 68(%x2)	# 458 
	fdiv	%f1 %f2 %f1	# 458 
	j	feq_cont.5846	# 458 
	nop	# 458 
feq.5845:	# 458 
	addi	%x7 %x0 l.3996	# 458 
	flw	%f1 (0)%x7	# 458 
feq_cont.5846:	# 458 
	lw	%x6 28(%x2)	# 458 
	fsw	%f1 (4)%x6	# 458 

	flw	%f1 (8)%x6	# 459 
	addi	%x7 %x0 l.3996	# 460 
	flw	%f2 (0)%x7	# 460 
	feq	%f2 %f1 feq.5847	# 460 
	nop	# 460 
	fsw	%f1 72(%x2)	# 460 
	sw	%x1 76(%x2)	# 460 
	addi	%x2 %x2 80	# 460 
	jal	 %x1 sgn.1807	# 460 
	addi	%x2 %x2 -80	# 460 
	lw	%x1 76(%x2)	# 460 
	flw	%f2 72(%x2)	# 460 
	fsw	%f1 76(%x2)	# 460 
	fadd	%f1 %f2 %f0	# 460 
	sw	%x1 84(%x2)	# 460 
	addi	%x2 %x2 88	# 460 
	jal	 %x1 fsqr.1762	# 460 
	addi	%x2 %x2 -88	# 460 
	lw	%x1 84(%x2)	# 460 
	flw	%f2 76(%x2)	# 460 
	fdiv	%f1 %f2 %f1	# 460 
	j	feq_cont.5848	# 460 
	nop	# 460 
feq.5847:	# 460 
	addi	%x7 %x0 l.3996	# 460 
	flw	%f1 (0)%x7	# 460 
feq_cont.5848:	# 460 
	lw	%x6 28(%x2)	# 460 
	fsw	%f1 (8)%x6	# 460 

	j	beq_cont.5842	# 452 
	nop	# 452 
beq_else.5841:	# 452 
	addi	%x5 %x0 2	# 462 
	bne	%x7 %x5 beq_else.5849	# 462 
	nop	# 462 
	lw	%x7 40(%x2)	# 464 
	addi	%x5 %x0 0	# 464 
	bne	%x7 %x5 beq_else.5851	# 464 
	nop	# 464 
	addi	%x7 %x0 1	# 464 
	j	beq_cont.5852	# 464 
	nop	# 464 
beq_else.5851:	# 464 
	addi	%x7 %x0 0	# 464 
beq_cont.5852:	# 464 
	add	%x6 %x0 %x8	# 464 
	sw	%x1 84(%x2)	# 464 
	addi	%x2 %x2 88	# 464 
	jal	 %x1 normalize_vector.1804	# 464 
	addi	%x2 %x2 -88	# 464 
	lw	%x1 84(%x2)	# 464 
	j	beq_cont.5850	# 462 
	nop	# 462 
beq_else.5849:	# 462 
beq_cont.5850:	# 462 
beq_cont.5842:	# 452 
	lw	%x6 24(%x2)	# 468 
	addi	%x5 %x0 0	# 468 
	bne	%x6 %x5 beq_else.5853	# 468 
	nop	# 468 
	j	beq_cont.5854	# 468 
	nop	# 468 
beq_else.5853:	# 468 
	lw	%x6 52(%x2)	# 470 
	flw	%f1 (0)%x6	# 470 
	sw	%x1 84(%x2)	# 470 
	addi	%x2 %x2 88	# 470 
	jal	 %x1 min_caml_cos	# 470 
	addi	%x2 %x2 -88	# 470 
	lw	%x1 84(%x2)	# 470 
	lw	%x6 0(%x2)	# 470 
	fsw	%f1 (40)%x6	# 470 

	lw	%x7 52(%x2)	# 471 
	flw	%f1 (0)%x7	# 471 
	sw	%x1 84(%x2)	# 471 
	addi	%x2 %x2 88	# 471 
	jal	 %x1 min_caml_sin	# 471 
	addi	%x2 %x2 -88	# 471 
	lw	%x1 84(%x2)	# 471 
	lw	%x6 0(%x2)	# 471 
	fsw	%f1 (44)%x6	# 471 

	lw	%x7 52(%x2)	# 472 
	flw	%f1 (4)%x7	# 472 
	sw	%x1 84(%x2)	# 472 
	addi	%x2 %x2 88	# 472 
	jal	 %x1 min_caml_cos	# 472 
	addi	%x2 %x2 -88	# 472 
	lw	%x1 84(%x2)	# 472 
	lw	%x6 0(%x2)	# 472 
	fsw	%f1 (48)%x6	# 472 

	lw	%x7 52(%x2)	# 473 
	flw	%f1 (4)%x7	# 473 
	sw	%x1 84(%x2)	# 473 
	addi	%x2 %x2 88	# 473 
	jal	 %x1 min_caml_sin	# 473 
	addi	%x2 %x2 -88	# 473 
	lw	%x1 84(%x2)	# 473 
	lw	%x6 0(%x2)	# 473 
	fsw	%f1 (52)%x6	# 473 

	lw	%x7 52(%x2)	# 474 
	flw	%f1 (8)%x7	# 474 
	sw	%x1 84(%x2)	# 474 
	addi	%x2 %x2 88	# 474 
	jal	 %x1 min_caml_cos	# 474 
	addi	%x2 %x2 -88	# 474 
	lw	%x1 84(%x2)	# 474 
	lw	%x6 0(%x2)	# 474 
	fsw	%f1 (56)%x6	# 474 

	lw	%x7 52(%x2)	# 475 
	flw	%f1 (8)%x7	# 475 
	sw	%x1 84(%x2)	# 475 
	addi	%x2 %x2 88	# 475 
	jal	 %x1 min_caml_sin	# 475 
	addi	%x2 %x2 -88	# 475 
	lw	%x1 84(%x2)	# 475 
	lw	%x6 0(%x2)	# 475 
	fsw	%f1 (60)%x6	# 475 

	flw	%f1 (48)%x6	# 476 
	flw	%f2 (56)%x6	# 476 
	fmul	%f1 %f1 %f2	# 476 
	fsw	%f1 (0)%x6	# 476 

	flw	%f1 (44)%x6	# 478 
	flw	%f2 (52)%x6	# 478 
	fmul	%f1 %f1 %f2	# 478 
	flw	%f2 (56)%x6	# 478 
	fmul	%f1 %f1 %f2	# 478 
	flw	%f2 (40)%x6	# 478 
	flw	%f3 (60)%x6	# 478 
	fmul	%f2 %f2 %f3	# 478 
	fsub	%f1 %f1 %f2	# 478 
	fsw	%f1 (4)%x6	# 477 

	flw	%f1 (40)%x6	# 480 
	flw	%f2 (52)%x6	# 480 
	fmul	%f1 %f1 %f2	# 480 
	flw	%f2 (56)%x6	# 480 
	fmul	%f1 %f1 %f2	# 480 
	flw	%f2 (44)%x6	# 480 
	flw	%f3 (60)%x6	# 480 
	fmul	%f2 %f2 %f3	# 480 
	fadd	%f1 %f1 %f2	# 480 
	fsw	%f1 (8)%x6	# 479 

	flw	%f1 (48)%x6	# 481 
	flw	%f2 (60)%x6	# 481 
	fmul	%f1 %f1 %f2	# 481 
	fsw	%f1 (12)%x6	# 481 

	flw	%f1 (44)%x6	# 483 
	flw	%f2 (52)%x6	# 483 
	fmul	%f1 %f1 %f2	# 483 
	flw	%f2 (60)%x6	# 483 
	fmul	%f1 %f1 %f2	# 483 
	flw	%f2 (40)%x6	# 483 
	flw	%f3 (56)%x6	# 483 
	fmul	%f2 %f2 %f3	# 483 
	fadd	%f1 %f1 %f2	# 483 
	fsw	%f1 (16)%x6	# 482 

	flw	%f1 (40)%x6	# 485 
	flw	%f2 (52)%x6	# 485 
	fmul	%f1 %f1 %f2	# 485 
	flw	%f2 (60)%x6	# 485 
	fmul	%f1 %f1 %f2	# 485 
	flw	%f2 (44)%x6	# 485 
	flw	%f3 (56)%x6	# 485 
	fmul	%f2 %f2 %f3	# 485 
	fsub	%f1 %f1 %f2	# 485 
	fsw	%f1 (20)%x6	# 484 

	flw	%f1 (52)%x6	# 486 
	fneg	%f1 %f1	# 486 
	fsw	%f1 (24)%x6	# 486 

	flw	%f1 (44)%x6	# 487 
	flw	%f2 (48)%x6	# 487 
	fmul	%f1 %f1 %f2	# 487 
	fsw	%f1 (28)%x6	# 487 

	flw	%f1 (40)%x6	# 488 
	flw	%f2 (48)%x6	# 488 
	fmul	%f1 %f1 %f2	# 488 
	fsw	%f1 (32)%x6	# 488 

	lw	%x7 28(%x2)	# 489 
	flw	%f1 (0)%x7	# 489 
	flw	%f2 (4)%x7	# 490 
	flw	%f3 (8)%x7	# 491 
	flw	%f4 (0)%x6	# 492 
	fsw	%f3 80(%x2)	# 492 
	fsw	%f2 84(%x2)	# 492 
	fsw	%f1 88(%x2)	# 492 
	fadd	%f1 %f4 %f0	# 492 
	sw	%x1 92(%x2)	# 492 
	addi	%x2 %x2 96	# 492 
	jal	 %x1 fsqr.1762	# 492 
	addi	%x2 %x2 -96	# 492 
	lw	%x1 92(%x2)	# 492 
	flw	%f2 88(%x2)	# 492 
	fmul	%f1 %f2 %f1	# 492 
	lw	%x6 0(%x2)	# 492 
	flw	%f3 (12)%x6	# 492 
	fsw	%f1 92(%x2)	# 492 
	fadd	%f1 %f3 %f0	# 492 
	sw	%x1 100(%x2)	# 492 
	addi	%x2 %x2 104	# 492 
	jal	 %x1 fsqr.1762	# 492 
	addi	%x2 %x2 -104	# 492 
	lw	%x1 100(%x2)	# 492 
	flw	%f2 84(%x2)	# 492 
	fmul	%f1 %f2 %f1	# 492 
	flw	%f3 92(%x2)	# 492 
	fadd	%f1 %f3 %f1	# 492 
	lw	%x6 0(%x2)	# 492 
	flw	%f3 (24)%x6	# 492 
	fsw	%f1 96(%x2)	# 492 
	fadd	%f1 %f3 %f0	# 492 
	sw	%x1 100(%x2)	# 492 
	addi	%x2 %x2 104	# 492 
	jal	 %x1 fsqr.1762	# 492 
	addi	%x2 %x2 -104	# 492 
	lw	%x1 100(%x2)	# 492 
	flw	%f2 80(%x2)	# 492 
	fmul	%f1 %f2 %f1	# 492 
	flw	%f3 96(%x2)	# 492 
	fadd	%f1 %f3 %f1	# 492 
	lw	%x6 28(%x2)	# 492 
	fsw	%f1 (0)%x6	# 492 

	lw	%x7 0(%x2)	# 493 
	flw	%f1 (4)%x7	# 493 
	sw	%x1 100(%x2)	# 493 
	addi	%x2 %x2 104	# 493 
	jal	 %x1 fsqr.1762	# 493 
	addi	%x2 %x2 -104	# 493 
	lw	%x1 100(%x2)	# 493 
	flw	%f2 88(%x2)	# 493 
	fmul	%f1 %f2 %f1	# 493 
	lw	%x6 0(%x2)	# 493 
	flw	%f3 (16)%x6	# 493 
	fsw	%f1 100(%x2)	# 493 
	fadd	%f1 %f3 %f0	# 493 
	sw	%x1 108(%x2)	# 493 
	addi	%x2 %x2 112	# 493 
	jal	 %x1 fsqr.1762	# 493 
	addi	%x2 %x2 -112	# 493 
	lw	%x1 108(%x2)	# 493 
	flw	%f2 84(%x2)	# 493 
	fmul	%f1 %f2 %f1	# 493 
	flw	%f3 100(%x2)	# 493 
	fadd	%f1 %f3 %f1	# 493 
	lw	%x6 0(%x2)	# 493 
	flw	%f3 (28)%x6	# 493 
	fsw	%f1 104(%x2)	# 493 
	fadd	%f1 %f3 %f0	# 493 
	sw	%x1 108(%x2)	# 493 
	addi	%x2 %x2 112	# 493 
	jal	 %x1 fsqr.1762	# 493 
	addi	%x2 %x2 -112	# 493 
	lw	%x1 108(%x2)	# 493 
	flw	%f2 80(%x2)	# 493 
	fmul	%f1 %f2 %f1	# 493 
	flw	%f3 104(%x2)	# 493 
	fadd	%f1 %f3 %f1	# 493 
	lw	%x6 28(%x2)	# 493 
	fsw	%f1 (4)%x6	# 493 

	lw	%x7 0(%x2)	# 494 
	flw	%f1 (8)%x7	# 494 
	sw	%x1 108(%x2)	# 494 
	addi	%x2 %x2 112	# 494 
	jal	 %x1 fsqr.1762	# 494 
	addi	%x2 %x2 -112	# 494 
	lw	%x1 108(%x2)	# 494 
	flw	%f2 88(%x2)	# 494 
	fmul	%f1 %f2 %f1	# 494 
	lw	%x6 0(%x2)	# 494 
	flw	%f3 (20)%x6	# 494 
	fsw	%f1 108(%x2)	# 494 
	fadd	%f1 %f3 %f0	# 494 
	sw	%x1 116(%x2)	# 494 
	addi	%x2 %x2 120	# 494 
	jal	 %x1 fsqr.1762	# 494 
	addi	%x2 %x2 -120	# 494 
	lw	%x1 116(%x2)	# 494 
	flw	%f2 84(%x2)	# 494 
	fmul	%f1 %f2 %f1	# 494 
	flw	%f3 108(%x2)	# 494 
	fadd	%f1 %f3 %f1	# 494 
	lw	%x6 0(%x2)	# 494 
	flw	%f3 (32)%x6	# 494 
	fsw	%f1 112(%x2)	# 494 
	fadd	%f1 %f3 %f0	# 494 
	sw	%x1 116(%x2)	# 494 
	addi	%x2 %x2 120	# 494 
	jal	 %x1 fsqr.1762	# 494 
	addi	%x2 %x2 -120	# 494 
	lw	%x1 116(%x2)	# 494 
	flw	%f2 80(%x2)	# 494 
	fmul	%f1 %f2 %f1	# 494 
	flw	%f3 112(%x2)	# 494 
	fadd	%f1 %f3 %f1	# 494 
	lw	%x6 28(%x2)	# 494 
	fsw	%f1 (8)%x6	# 494 

	addi	%x6 %x0 l.3971	# 495 
	flw	%f1 (0)%x6	# 495 
	lw	%x6 0(%x2)	# 495 
	flw	%f3 (4)%x6	# 495 
	flw	%f4 88(%x2)	# 495 
	fmul	%f3 %f4 %f3	# 495 
	flw	%f5 (8)%x6	# 495 
	fmul	%f3 %f3 %f5	# 495 
	flw	%f5 (16)%x6	# 496 
	flw	%f6 84(%x2)	# 496 
	fmul	%f5 %f6 %f5	# 496 
	flw	%f7 (20)%x6	# 496 
	fmul	%f5 %f5 %f7	# 496 
	fadd	%f3 %f3 %f5	# 495 
	flw	%f5 (28)%x6	# 497 
	fmul	%f5 %f2 %f5	# 497 
	flw	%f7 (32)%x6	# 497 
	fmul	%f5 %f5 %f7	# 497 
	fadd	%f3 %f3 %f5	# 495 
	fmul	%f1 %f1 %f3	# 495 
	lw	%x7 52(%x2)	# 495 
	fsw	%f1 (0)%x7	# 495 

	addi	%x8 %x0 l.3971	# 498 
	flw	%f1 (0)%x8	# 498 
	flw	%f3 (0)%x6	# 498 
	fmul	%f3 %f4 %f3	# 498 
	flw	%f5 (8)%x6	# 498 
	fmul	%f3 %f3 %f5	# 498 
	flw	%f5 (12)%x6	# 499 
	fmul	%f5 %f6 %f5	# 499 
	flw	%f7 (20)%x6	# 499 
	fmul	%f5 %f5 %f7	# 499 
	fadd	%f3 %f3 %f5	# 498 
	flw	%f5 (24)%x6	# 500 
	fmul	%f5 %f2 %f5	# 500 
	flw	%f7 (32)%x6	# 500 
	fmul	%f5 %f5 %f7	# 500 
	fadd	%f3 %f3 %f5	# 498 
	fmul	%f1 %f1 %f3	# 498 
	fsw	%f1 (4)%x7	# 498 

	addi	%x8 %x0 l.3971	# 501 
	flw	%f1 (0)%x8	# 501 
	flw	%f3 (0)%x6	# 501 
	fmul	%f3 %f4 %f3	# 501 
	flw	%f4 (4)%x6	# 501 
	fmul	%f3 %f3 %f4	# 501 
	flw	%f4 (12)%x6	# 502 
	fmul	%f4 %f6 %f4	# 502 
	flw	%f5 (16)%x6	# 502 
	fmul	%f4 %f4 %f5	# 502 
	fadd	%f3 %f3 %f4	# 501 
	flw	%f4 (24)%x6	# 503 
	fmul	%f2 %f2 %f4	# 503 
	flw	%f4 (28)%x6	# 503 
	fmul	%f2 %f2 %f4	# 503 
	fadd	%f2 %f3 %f2	# 501 
	fmul	%f1 %f1 %f2	# 501 
	fsw	%f1 (8)%x7	# 501 

beq_cont.5854:	# 468 
	addi	%x6 %x0 1	# 512 
	jr	0(%x1)	# 512 
	nop	# 512 
read_object.1815:
	lw	%x7 4(%x4)	# 521 
	addi	%x5 %x0 61	# 521 
	blt	%x6 %x5 bge_else.5855	# 521 
	nop	# 521 
	jr	0(%x1)	# 525 
	nop	# 525 
bge_else.5855:	# 521 
	sw	%x4 0(%x2)	# 522 
	sw	%x6 4(%x2)	# 522 
	add	%x4 %x0 %x7	# 522 
	sw	%x1 12(%x2)	# 522 
	lw	%x5 0(%x4)	# 522 
	addi	%x2 %x2 16	# 522 
	jalr	%x1 %x5	# 522 
	addi	%x2 %x2 -16	# 522 
	lw	%x1 12(%x2)	# 522 
	addi	%x5 %x0 0	# 522 
	bne	%x6 %x5 beq_else.5857	# 522 
	nop	# 522 
	jr	0(%x1)	# 524 
	nop	# 524 
beq_else.5857:	# 522 
	lw	%x6 4(%x2)	# 523 
	addi	%x6 %x6 1	# 523 
	lw	%x4 0(%x2)	# 523 
	lw	%x5 0(%x4)	# 523 
	jr	0(%x5)	# 523 
	nop	# 523 
read_all_object.1817:
	lw	%x4 4(%x4)	# 530 
	addi	%x6 %x0 0	# 530 
	lw	%x5 0(%x4)	# 530 
	jr	0(%x5)	# 530 
	nop	# 530 
read_net_item.1819:
	sw	%x6 0(%x2)	# 538 
	sw	%x1 4(%x2)	# 538 
	addi	%x2 %x2 8	# 538 
	jal	 %x1 min_caml_read_int	# 538 
	addi	%x2 %x2 -8	# 538 
	lw	%x1 4(%x2)	# 538 
	addi	%x5 %x0 -1	# 539 
	bne	%x6 %x5 beq_else.5859	# 539 
	nop	# 539 
	lw	%x6 0(%x2)	# 539 
	addi	%x6 %x6 1	# 539 
	addi	%x7 %x0 -1	# 539 
	j	min_caml_create_array	# 539 
	nop	# 539 
beq_else.5859:	# 539 
	lw	%x7 0(%x2)	# 541 
	addi	%x8 %x7 1	# 541 
	sw	%x6 4(%x2)	# 541 
	add	%x6 %x0 %x8	# 541 
	sw	%x1 12(%x2)	# 541 
	addi	%x2 %x2 16	# 541 
	jal	 %x1 read_net_item.1819	# 541 
	addi	%x2 %x2 -16	# 541 
	lw	%x1 12(%x2)	# 541 
	lw	%x7 0(%x2)	# 542 
	sll	%x7 %x7 2	# 542 
	lw	%x8 4(%x2)	# 542 
	sw	%x8 %x7(%x6)	# 542 
	jr	0(%x1)	# 542 
	nop	# 542 
read_or_network.1821:
	addi	%x7 %x0 0	# 547 
	sw	%x6 0(%x2)	# 547 
	add	%x6 %x0 %x7	# 547 
	sw	%x1 4(%x2)	# 547 
	addi	%x2 %x2 8	# 547 
	jal	 %x1 read_net_item.1819	# 547 
	addi	%x2 %x2 -8	# 547 
	lw	%x1 4(%x2)	# 547 
	add	%x7 %x0 %x6	# 547 
	lw	%x6 0(%x7)	# 548 
	addi	%x5 %x0 -1	# 548 
	bne	%x6 %x5 beq_else.5860	# 548 
	nop	# 548 
	lw	%x6 0(%x2)	# 549 
	addi	%x6 %x6 1	# 549 
	j	min_caml_create_array	# 549 
	nop	# 549 
beq_else.5860:	# 548 
	lw	%x6 0(%x2)	# 551 
	addi	%x8 %x6 1	# 551 
	sw	%x7 4(%x2)	# 551 
	add	%x6 %x0 %x8	# 551 
	sw	%x1 12(%x2)	# 551 
	addi	%x2 %x2 16	# 551 
	jal	 %x1 read_or_network.1821	# 551 
	addi	%x2 %x2 -16	# 551 
	lw	%x1 12(%x2)	# 551 
	lw	%x7 0(%x2)	# 552 
	sll	%x7 %x7 2	# 552 
	lw	%x8 4(%x2)	# 552 
	sw	%x8 %x7(%x6)	# 552 
	jr	0(%x1)	# 552 
	nop	# 552 
read_and_network.1823:
	lw	%x7 4(%x4)	# 557 
	addi	%x8 %x0 0	# 557 
	sw	%x4 0(%x2)	# 557 
	sw	%x7 4(%x2)	# 557 
	sw	%x6 8(%x2)	# 557 
	add	%x6 %x0 %x8	# 557 
	sw	%x1 12(%x2)	# 557 
	addi	%x2 %x2 16	# 557 
	jal	 %x1 read_net_item.1819	# 557 
	addi	%x2 %x2 -16	# 557 
	lw	%x1 12(%x2)	# 557 
	lw	%x7 0(%x6)	# 558 
	addi	%x5 %x0 -1	# 558 
	bne	%x7 %x5 beq_else.5861	# 558 
	nop	# 558 
	jr	0(%x1)	# 558 
	nop	# 558 
beq_else.5861:	# 558 
	lw	%x7 8(%x2)	# 560 
	sll	%x8 %x7 2	# 560 
	lw	%x9 4(%x2)	# 560 
	sw	%x6 %x8(%x9)	# 560 
	addi	%x6 %x7 1	# 561 
	lw	%x4 0(%x2)	# 561 
	lw	%x5 0(%x4)	# 561 
	jr	0(%x5)	# 561 
	nop	# 561 
read_parameter.1825:
	lw	%x6 16(%x4)	# 568 
	lw	%x7 12(%x4)	# 568 
	lw	%x8 8(%x4)	# 568 
	lw	%x9 4(%x4)	# 568 
	sw	%x9 0(%x2)	# 568 
	sw	%x7 4(%x2)	# 568 
	sw	%x8 8(%x2)	# 568 
	add	%x4 %x0 %x6	# 568 
	sw	%x1 12(%x2)	# 568 
	lw	%x5 0(%x4)	# 568 
	addi	%x2 %x2 16	# 568 
	jalr	%x1 %x5	# 568 
	addi	%x2 %x2 -16	# 568 
	lw	%x1 12(%x2)	# 568 
	lw	%x4 8(%x2)	# 569 
	sw	%x1 12(%x2)	# 569 
	lw	%x5 0(%x4)	# 569 
	addi	%x2 %x2 16	# 569 
	jalr	%x1 %x5	# 569 
	addi	%x2 %x2 -16	# 569 
	lw	%x1 12(%x2)	# 569 
	addi	%x6 %x0 0	# 570 
	lw	%x4 4(%x2)	# 570 
	sw	%x1 12(%x2)	# 570 
	lw	%x5 0(%x4)	# 570 
	addi	%x2 %x2 16	# 570 
	jalr	%x1 %x5	# 570 
	addi	%x2 %x2 -16	# 570 
	lw	%x1 12(%x2)	# 570 
	addi	%x6 %x0 0	# 571 
	sw	%x1 12(%x2)	# 571 
	addi	%x2 %x2 16	# 571 
	jal	 %x1 read_or_network.1821	# 571 
	addi	%x2 %x2 -16	# 571 
	lw	%x1 12(%x2)	# 571 
	lw	%x7 0(%x2)	# 571 
	sw	%x6 0(%x7)	# 571 
	jr	0(%x1)	# 571 
	nop	# 571 
solver_rect.1827:
	lw	%x8 8(%x4)	# 592 
	lw	%x9 4(%x4)	# 592 
	addi	%x10 %x0 l.3996	# 592 
	flw	%f1 (0)%x10	# 592 
	flw	%f2 (0)%x7	# 592 
	sw	%x9 0(%x2)	# 592 
	sw	%x8 4(%x2)	# 592 
	sw	%x6 8(%x2)	# 592 
	sw	%x7 12(%x2)	# 592 
	feq	%f1 %f2 feq.5864	# 592 
	nop	# 592 
	sw	%x1 20(%x2)	# 594 
	addi	%x2 %x2 24	# 594 
	jal	 %x1 o_isinvert.1772	# 594 
	addi	%x2 %x2 -24	# 594 
	lw	%x1 20(%x2)	# 594 
	addi	%x7 %x0 l.3996	# 594 
	flw	%f1 (0)%x7	# 594 
	lw	%x7 12(%x2)	# 594 
	flw	%f2 (0)%x7	# 594 
	fblt	%f1 %f2 fblt.5866	# 594 
	nop	# 594 
	addi	%x8 %x0 1	# 594 
	j	fblt_cont.5867	# 594 
	nop	# 594 
fblt.5866:	# 594 
	addi	%x8 %x0 0	# 594 
fblt_cont.5867:	# 594 
	add	%x7 %x0 %x8	# 594 
	sw	%x1 20(%x2)	# 594 
	addi	%x2 %x2 24	# 594 
	jal	 %x1 xor.1759	# 594 
	addi	%x2 %x2 -24	# 594 
	lw	%x1 20(%x2)	# 594 
	addi	%x5 %x0 0	# 594 
	bne	%x6 %x5 beq_else.5868	# 594 
	nop	# 594 
	lw	%x6 8(%x2)	# 594 
	sw	%x1 20(%x2)	# 594 
	addi	%x2 %x2 24	# 594 
	jal	 %x1 o_param_a.1776	# 594 
	addi	%x2 %x2 -24	# 594 
	lw	%x1 20(%x2)	# 594 
	fneg	%f1 %f1	# 594 
	j	beq_cont.5869	# 594 
	nop	# 594 
beq_else.5868:	# 594 
	lw	%x6 8(%x2)	# 594 
	sw	%x1 20(%x2)	# 594 
	addi	%x2 %x2 24	# 594 
	jal	 %x1 o_param_a.1776	# 594 
	addi	%x2 %x2 -24	# 594 
	lw	%x1 20(%x2)	# 594 
beq_cont.5869:	# 594 
	lw	%x6 4(%x2)	# 596 
	flw	%f2 (0)%x6	# 596 
	fsub	%f1 %f1 %f2	# 596 
	lw	%x7 12(%x2)	# 596 
	flw	%f2 (0)%x7	# 596 
	fdiv	%f1 %f1 %f2	# 596 
	lw	%x8 8(%x2)	# 598 
	fsw	%f1 16(%x2)	# 598 
	add	%x6 %x0 %x8	# 598 
	sw	%x1 20(%x2)	# 598 
	addi	%x2 %x2 24	# 598 
	jal	 %x1 o_param_b.1778	# 598 
	addi	%x2 %x2 -24	# 598 
	lw	%x1 20(%x2)	# 598 
	lw	%x6 12(%x2)	# 598 
	flw	%f2 (4)%x6	# 598 
	flw	%f3 16(%x2)	# 598 
	fmul	%f2 %f3 %f2	# 598 
	lw	%x7 4(%x2)	# 598 
	flw	%f4 (4)%x7	# 598 
	fadd	%f2 %f2 %f4	# 598 
	fsw	%f1 20(%x2)	# 598 
	fadd	%f1 %f2 %f0	# 598 
	sw	%x1 28(%x2)	# 598 
	addi	%x2 %x2 32	# 598 
	jal	 %x1 min_caml_abs_float	# 598 
	addi	%x2 %x2 -32	# 598 
	lw	%x1 28(%x2)	# 598 
	flw	%f2 20(%x2)	# 598 
	fblt	%f2 %f1 fblt.5870	# 598 
	nop	# 598 
	lw	%x6 8(%x2)	# 599 
	sw	%x1 28(%x2)	# 599 
	addi	%x2 %x2 32	# 599 
	jal	 %x1 o_param_c.1780	# 599 
	addi	%x2 %x2 -32	# 599 
	lw	%x1 28(%x2)	# 599 
	lw	%x6 12(%x2)	# 599 
	flw	%f2 (8)%x6	# 599 
	flw	%f3 16(%x2)	# 599 
	fmul	%f2 %f3 %f2	# 599 
	lw	%x7 4(%x2)	# 599 
	flw	%f4 (8)%x7	# 599 
	fadd	%f2 %f2 %f4	# 599 
	fsw	%f1 24(%x2)	# 599 
	fadd	%f1 %f2 %f0	# 599 
	sw	%x1 28(%x2)	# 599 
	addi	%x2 %x2 32	# 599 
	jal	 %x1 min_caml_abs_float	# 599 
	addi	%x2 %x2 -32	# 599 
	lw	%x1 28(%x2)	# 599 
	flw	%f2 24(%x2)	# 599 
	fblt	%f2 %f1 fblt.5872	# 599 
	nop	# 599 
	lw	%x6 0(%x2)	# 600 
	flw	%f1 16(%x2)	# 600 
	fsw	%f1 (0)%x6	# 600 

	addi	%x6 %x0 1	# 600 
	j	fblt_cont.5873	# 599 
	nop	# 599 
fblt.5872:	# 599 
	addi	%x6 %x0 0	# 601 
fblt_cont.5873:	# 599 
	j	fblt_cont.5871	# 598 
	nop	# 598 
fblt.5870:	# 598 
	addi	%x6 %x0 0	# 602 
fblt_cont.5871:	# 598 
	j	feq_cont.5865	# 592 
	nop	# 592 
feq.5864:	# 592 
	addi	%x6 %x0 0	# 592 
feq_cont.5865:	# 592 
	addi	%x5 %x0 0	# 605 
	bne	%x6 %x5 beq_else.5874	# 605 
	nop	# 605 
	addi	%x6 %x0 l.3996	# 609 
	flw	%f1 (0)%x6	# 609 
	lw	%x6 12(%x2)	# 609 
	flw	%f2 (4)%x6	# 609 
	feq	%f1 %f2 feq.5875	# 609 
	nop	# 609 
	lw	%x7 8(%x2)	# 611 
	add	%x6 %x0 %x7	# 611 
	sw	%x1 28(%x2)	# 611 
	addi	%x2 %x2 32	# 611 
	jal	 %x1 o_isinvert.1772	# 611 
	addi	%x2 %x2 -32	# 611 
	lw	%x1 28(%x2)	# 611 
	addi	%x7 %x0 l.3996	# 611 
	flw	%f1 (0)%x7	# 611 
	lw	%x7 12(%x2)	# 611 
	flw	%f2 (4)%x7	# 611 
	fblt	%f1 %f2 fblt.5877	# 611 
	nop	# 611 
	addi	%x8 %x0 1	# 611 
	j	fblt_cont.5878	# 611 
	nop	# 611 
fblt.5877:	# 611 
	addi	%x8 %x0 0	# 611 
fblt_cont.5878:	# 611 
	add	%x7 %x0 %x8	# 611 
	sw	%x1 28(%x2)	# 611 
	addi	%x2 %x2 32	# 611 
	jal	 %x1 xor.1759	# 611 
	addi	%x2 %x2 -32	# 611 
	lw	%x1 28(%x2)	# 611 
	addi	%x5 %x0 0	# 611 
	bne	%x6 %x5 beq_else.5879	# 611 
	nop	# 611 
	lw	%x6 8(%x2)	# 611 
	sw	%x1 28(%x2)	# 611 
	addi	%x2 %x2 32	# 611 
	jal	 %x1 o_param_b.1778	# 611 
	addi	%x2 %x2 -32	# 611 
	lw	%x1 28(%x2)	# 611 
	fneg	%f1 %f1	# 611 
	j	beq_cont.5880	# 611 
	nop	# 611 
beq_else.5879:	# 611 
	lw	%x6 8(%x2)	# 611 
	sw	%x1 28(%x2)	# 611 
	addi	%x2 %x2 32	# 611 
	jal	 %x1 o_param_b.1778	# 611 
	addi	%x2 %x2 -32	# 611 
	lw	%x1 28(%x2)	# 611 
beq_cont.5880:	# 611 
	lw	%x6 4(%x2)	# 613 
	flw	%f2 (4)%x6	# 613 
	fsub	%f1 %f1 %f2	# 613 
	lw	%x7 12(%x2)	# 613 
	flw	%f2 (4)%x7	# 613 
	fdiv	%f1 %f1 %f2	# 613 
	lw	%x8 8(%x2)	# 615 
	fsw	%f1 28(%x2)	# 615 
	add	%x6 %x0 %x8	# 615 
	sw	%x1 36(%x2)	# 615 
	addi	%x2 %x2 40	# 615 
	jal	 %x1 o_param_c.1780	# 615 
	addi	%x2 %x2 -40	# 615 
	lw	%x1 36(%x2)	# 615 
	lw	%x6 12(%x2)	# 615 
	flw	%f2 (8)%x6	# 615 
	flw	%f3 28(%x2)	# 615 
	fmul	%f2 %f3 %f2	# 615 
	lw	%x7 4(%x2)	# 615 
	flw	%f4 (8)%x7	# 615 
	fadd	%f2 %f2 %f4	# 615 
	fsw	%f1 32(%x2)	# 615 
	fadd	%f1 %f2 %f0	# 615 
	sw	%x1 36(%x2)	# 615 
	addi	%x2 %x2 40	# 615 
	jal	 %x1 min_caml_abs_float	# 615 
	addi	%x2 %x2 -40	# 615 
	lw	%x1 36(%x2)	# 615 
	flw	%f2 32(%x2)	# 615 
	fblt	%f2 %f1 fblt.5881	# 615 
	nop	# 615 
	lw	%x6 8(%x2)	# 616 
	sw	%x1 36(%x2)	# 616 
	addi	%x2 %x2 40	# 616 
	jal	 %x1 o_param_a.1776	# 616 
	addi	%x2 %x2 -40	# 616 
	lw	%x1 36(%x2)	# 616 
	lw	%x6 12(%x2)	# 616 
	flw	%f2 (0)%x6	# 616 
	flw	%f3 28(%x2)	# 616 
	fmul	%f2 %f3 %f2	# 616 
	lw	%x7 4(%x2)	# 616 
	flw	%f4 (0)%x7	# 616 
	fadd	%f2 %f2 %f4	# 616 
	fsw	%f1 36(%x2)	# 616 
	fadd	%f1 %f2 %f0	# 616 
	sw	%x1 44(%x2)	# 616 
	addi	%x2 %x2 48	# 616 
	jal	 %x1 min_caml_abs_float	# 616 
	addi	%x2 %x2 -48	# 616 
	lw	%x1 44(%x2)	# 616 
	flw	%f2 36(%x2)	# 616 
	fblt	%f2 %f1 fblt.5883	# 616 
	nop	# 616 
	lw	%x6 0(%x2)	# 617 
	flw	%f1 28(%x2)	# 617 
	fsw	%f1 (0)%x6	# 617 

	addi	%x6 %x0 1	# 617 
	j	fblt_cont.5884	# 616 
	nop	# 616 
fblt.5883:	# 616 
	addi	%x6 %x0 0	# 618 
fblt_cont.5884:	# 616 
	j	fblt_cont.5882	# 615 
	nop	# 615 
fblt.5881:	# 615 
	addi	%x6 %x0 0	# 619 
fblt_cont.5882:	# 615 
	j	feq_cont.5876	# 609 
	nop	# 609 
feq.5875:	# 609 
	addi	%x6 %x0 0	# 609 
feq_cont.5876:	# 609 
	addi	%x5 %x0 0	# 622 
	bne	%x6 %x5 beq_else.5885	# 622 
	nop	# 622 
	addi	%x6 %x0 l.3996	# 626 
	flw	%f1 (0)%x6	# 626 
	lw	%x6 12(%x2)	# 626 
	flw	%f2 (8)%x6	# 626 
	feq	%f1 %f2 feq.5886	# 626 
	nop	# 626 
	lw	%x7 8(%x2)	# 628 
	add	%x6 %x0 %x7	# 628 
	sw	%x1 44(%x2)	# 628 
	addi	%x2 %x2 48	# 628 
	jal	 %x1 o_isinvert.1772	# 628 
	addi	%x2 %x2 -48	# 628 
	lw	%x1 44(%x2)	# 628 
	addi	%x7 %x0 l.3996	# 628 
	flw	%f1 (0)%x7	# 628 
	lw	%x7 12(%x2)	# 628 
	flw	%f2 (8)%x7	# 628 
	fblt	%f1 %f2 fblt.5888	# 628 
	nop	# 628 
	addi	%x8 %x0 1	# 628 
	j	fblt_cont.5889	# 628 
	nop	# 628 
fblt.5888:	# 628 
	addi	%x8 %x0 0	# 628 
fblt_cont.5889:	# 628 
	add	%x7 %x0 %x8	# 628 
	sw	%x1 44(%x2)	# 628 
	addi	%x2 %x2 48	# 628 
	jal	 %x1 xor.1759	# 628 
	addi	%x2 %x2 -48	# 628 
	lw	%x1 44(%x2)	# 628 
	addi	%x5 %x0 0	# 628 
	bne	%x6 %x5 beq_else.5890	# 628 
	nop	# 628 
	lw	%x6 8(%x2)	# 628 
	sw	%x1 44(%x2)	# 628 
	addi	%x2 %x2 48	# 628 
	jal	 %x1 o_param_c.1780	# 628 
	addi	%x2 %x2 -48	# 628 
	lw	%x1 44(%x2)	# 628 
	fneg	%f1 %f1	# 628 
	j	beq_cont.5891	# 628 
	nop	# 628 
beq_else.5890:	# 628 
	lw	%x6 8(%x2)	# 628 
	sw	%x1 44(%x2)	# 628 
	addi	%x2 %x2 48	# 628 
	jal	 %x1 o_param_c.1780	# 628 
	addi	%x2 %x2 -48	# 628 
	lw	%x1 44(%x2)	# 628 
beq_cont.5891:	# 628 
	lw	%x6 4(%x2)	# 630 
	flw	%f2 (8)%x6	# 630 
	fsub	%f1 %f1 %f2	# 630 
	lw	%x7 12(%x2)	# 630 
	flw	%f2 (8)%x7	# 630 
	fdiv	%f1 %f1 %f2	# 630 
	lw	%x8 8(%x2)	# 632 
	fsw	%f1 40(%x2)	# 632 
	add	%x6 %x0 %x8	# 632 
	sw	%x1 44(%x2)	# 632 
	addi	%x2 %x2 48	# 632 
	jal	 %x1 o_param_a.1776	# 632 
	addi	%x2 %x2 -48	# 632 
	lw	%x1 44(%x2)	# 632 
	lw	%x6 12(%x2)	# 632 
	flw	%f2 (0)%x6	# 632 
	flw	%f3 40(%x2)	# 632 
	fmul	%f2 %f3 %f2	# 632 
	lw	%x7 4(%x2)	# 632 
	flw	%f4 (0)%x7	# 632 
	fadd	%f2 %f2 %f4	# 632 
	fsw	%f1 44(%x2)	# 632 
	fadd	%f1 %f2 %f0	# 632 
	sw	%x1 52(%x2)	# 632 
	addi	%x2 %x2 56	# 632 
	jal	 %x1 min_caml_abs_float	# 632 
	addi	%x2 %x2 -56	# 632 
	lw	%x1 52(%x2)	# 632 
	flw	%f2 44(%x2)	# 632 
	fblt	%f2 %f1 fblt.5892	# 632 
	nop	# 632 
	lw	%x6 8(%x2)	# 633 
	sw	%x1 52(%x2)	# 633 
	addi	%x2 %x2 56	# 633 
	jal	 %x1 o_param_b.1778	# 633 
	addi	%x2 %x2 -56	# 633 
	lw	%x1 52(%x2)	# 633 
	lw	%x6 12(%x2)	# 633 
	flw	%f2 (4)%x6	# 633 
	flw	%f3 40(%x2)	# 633 
	fmul	%f2 %f3 %f2	# 633 
	lw	%x6 4(%x2)	# 633 
	flw	%f4 (4)%x6	# 633 
	fadd	%f2 %f2 %f4	# 633 
	fsw	%f1 48(%x2)	# 633 
	fadd	%f1 %f2 %f0	# 633 
	sw	%x1 52(%x2)	# 633 
	addi	%x2 %x2 56	# 633 
	jal	 %x1 min_caml_abs_float	# 633 
	addi	%x2 %x2 -56	# 633 
	lw	%x1 52(%x2)	# 633 
	flw	%f2 48(%x2)	# 633 
	fblt	%f2 %f1 fblt.5894	# 633 
	nop	# 633 
	lw	%x6 0(%x2)	# 634 
	flw	%f1 40(%x2)	# 634 
	fsw	%f1 (0)%x6	# 634 

	addi	%x6 %x0 1	# 634 
	j	fblt_cont.5895	# 633 
	nop	# 633 
fblt.5894:	# 633 
	addi	%x6 %x0 0	# 635 
fblt_cont.5895:	# 633 
	j	fblt_cont.5893	# 632 
	nop	# 632 
fblt.5892:	# 632 
	addi	%x6 %x0 0	# 636 
fblt_cont.5893:	# 632 
	j	feq_cont.5887	# 626 
	nop	# 626 
feq.5886:	# 626 
	addi	%x6 %x0 0	# 626 
feq_cont.5887:	# 626 
	addi	%x5 %x0 0	# 639 
	bne	%x6 %x5 beq_else.5896	# 639 
	nop	# 639 
	addi	%x6 %x0 0	# 639 
	jr	0(%x1)	# 639 
	nop	# 639 
beq_else.5896:	# 639 
	addi	%x6 %x0 3	# 639 
	jr	0(%x1)	# 639 
	nop	# 639 
beq_else.5885:	# 622 
	addi	%x6 %x0 2	# 622 
	jr	0(%x1)	# 622 
	nop	# 622 
beq_else.5874:	# 605 
	addi	%x6 %x0 1	# 605 
	jr	0(%x1)	# 605 
	nop	# 605 
solver_surface.1830:
	lw	%x8 8(%x4)	# 647 
	lw	%x9 4(%x4)	# 647 
	flw	%f1 (0)%x7	# 647 
	sw	%x9 0(%x2)	# 647 
	sw	%x8 4(%x2)	# 647 
	sw	%x6 8(%x2)	# 647 
	sw	%x7 12(%x2)	# 647 
	fsw	%f1 16(%x2)	# 647 
	sw	%x1 20(%x2)	# 647 
	addi	%x2 %x2 24	# 647 
	jal	 %x1 o_param_a.1776	# 647 
	addi	%x2 %x2 -24	# 647 
	lw	%x1 20(%x2)	# 647 
	flw	%f2 16(%x2)	# 647 
	fmul	%f1 %f2 %f1	# 647 
	lw	%x6 12(%x2)	# 647 
	flw	%f2 (4)%x6	# 647 
	lw	%x7 8(%x2)	# 647 
	fsw	%f1 20(%x2)	# 647 
	fsw	%f2 24(%x2)	# 647 
	add	%x6 %x0 %x7	# 647 
	sw	%x1 28(%x2)	# 647 
	addi	%x2 %x2 32	# 647 
	jal	 %x1 o_param_b.1778	# 647 
	addi	%x2 %x2 -32	# 647 
	lw	%x1 28(%x2)	# 647 
	flw	%f2 24(%x2)	# 647 
	fmul	%f1 %f2 %f1	# 647 
	flw	%f2 20(%x2)	# 647 
	fadd	%f1 %f2 %f1	# 647 
	lw	%x6 12(%x2)	# 647 
	flw	%f2 (8)%x6	# 647 
	lw	%x6 8(%x2)	# 647 
	fsw	%f1 28(%x2)	# 647 
	fsw	%f2 32(%x2)	# 647 
	sw	%x1 36(%x2)	# 647 
	addi	%x2 %x2 40	# 647 
	jal	 %x1 o_param_c.1780	# 647 
	addi	%x2 %x2 -40	# 647 
	lw	%x1 36(%x2)	# 647 
	flw	%f2 32(%x2)	# 647 
	fmul	%f1 %f2 %f1	# 647 
	flw	%f2 28(%x2)	# 647 
	fadd	%f1 %f2 %f1	# 647 
	addi	%x6 %x0 l.3996	# 648 
	flw	%f2 (0)%x6	# 648 
	fle	%f1 %f2 fle.5897	# 648 
	nop	# 648 
	lw	%x6 4(%x2)	# 649 
	flw	%f2 (0)%x6	# 649 
	lw	%x7 8(%x2)	# 649 
	fsw	%f1 36(%x2)	# 649 
	fsw	%f2 40(%x2)	# 649 
	add	%x6 %x0 %x7	# 649 
	sw	%x1 44(%x2)	# 649 
	addi	%x2 %x2 48	# 649 
	jal	 %x1 o_param_a.1776	# 649 
	addi	%x2 %x2 -48	# 649 
	lw	%x1 44(%x2)	# 649 
	flw	%f2 40(%x2)	# 649 
	fmul	%f1 %f2 %f1	# 649 
	lw	%x6 4(%x2)	# 649 
	flw	%f2 (4)%x6	# 649 
	lw	%x7 8(%x2)	# 649 
	fsw	%f1 44(%x2)	# 649 
	fsw	%f2 48(%x2)	# 649 
	add	%x6 %x0 %x7	# 649 
	sw	%x1 52(%x2)	# 649 
	addi	%x2 %x2 56	# 649 
	jal	 %x1 o_param_b.1778	# 649 
	addi	%x2 %x2 -56	# 649 
	lw	%x1 52(%x2)	# 649 
	flw	%f2 48(%x2)	# 649 
	fmul	%f1 %f2 %f1	# 649 
	flw	%f2 44(%x2)	# 649 
	fadd	%f1 %f2 %f1	# 649 
	lw	%x6 4(%x2)	# 649 
	flw	%f2 (8)%x6	# 649 
	lw	%x6 8(%x2)	# 649 
	fsw	%f1 52(%x2)	# 649 
	fsw	%f2 56(%x2)	# 649 
	sw	%x1 60(%x2)	# 649 
	addi	%x2 %x2 64	# 649 
	jal	 %x1 o_param_c.1780	# 649 
	addi	%x2 %x2 -64	# 649 
	lw	%x1 60(%x2)	# 649 
	flw	%f2 56(%x2)	# 649 
	fmul	%f1 %f2 %f1	# 649 
	flw	%f2 52(%x2)	# 649 
	fadd	%f1 %f2 %f1	# 649 
	flw	%f2 36(%x2)	# 649 
	fdiv	%f1 %f1 %f2	# 649 
	fneg	%f1 %f1	# 650 
	lw	%x6 0(%x2)	# 650 
	fsw	%f1 (0)%x6	# 650 

	addi	%x6 %x0 1	# 650 
	jr	0(%x1)	# 650 
	nop	# 650 
fle.5897:	# 648 
	addi	%x6 %x0 0	# 651 
	jr	0(%x1)	# 651 
	nop	# 651 
in_prod_sqr_obj.1833:
	flw	%f1 (0)%x7	# 658 
	sw	%x7 0(%x2)	# 658 
	sw	%x6 4(%x2)	# 658 
	sw	%x1 12(%x2)	# 658 
	addi	%x2 %x2 16	# 658 
	jal	 %x1 fsqr.1762	# 658 
	addi	%x2 %x2 -16	# 658 
	lw	%x1 12(%x2)	# 658 
	lw	%x6 4(%x2)	# 658 
	fsw	%f1 8(%x2)	# 658 
	sw	%x1 12(%x2)	# 658 
	addi	%x2 %x2 16	# 658 
	jal	 %x1 o_param_a.1776	# 658 
	addi	%x2 %x2 -16	# 658 
	lw	%x1 12(%x2)	# 658 
	flw	%f2 8(%x2)	# 658 
	fmul	%f1 %f2 %f1	# 658 
	lw	%x6 0(%x2)	# 659 
	flw	%f2 (4)%x6	# 659 
	fsw	%f1 12(%x2)	# 659 
	fadd	%f1 %f2 %f0	# 659 
	sw	%x1 20(%x2)	# 659 
	addi	%x2 %x2 24	# 659 
	jal	 %x1 fsqr.1762	# 659 
	addi	%x2 %x2 -24	# 659 
	lw	%x1 20(%x2)	# 659 
	lw	%x6 4(%x2)	# 659 
	fsw	%f1 16(%x2)	# 659 
	sw	%x1 20(%x2)	# 659 
	addi	%x2 %x2 24	# 659 
	jal	 %x1 o_param_b.1778	# 659 
	addi	%x2 %x2 -24	# 659 
	lw	%x1 20(%x2)	# 659 
	flw	%f2 16(%x2)	# 659 
	fmul	%f1 %f2 %f1	# 659 
	flw	%f2 12(%x2)	# 658 
	fadd	%f1 %f2 %f1	# 658 
	lw	%x6 0(%x2)	# 660 
	flw	%f2 (8)%x6	# 660 
	fsw	%f1 20(%x2)	# 660 
	fadd	%f1 %f2 %f0	# 660 
	sw	%x1 28(%x2)	# 660 
	addi	%x2 %x2 32	# 660 
	jal	 %x1 fsqr.1762	# 660 
	addi	%x2 %x2 -32	# 660 
	lw	%x1 28(%x2)	# 660 
	lw	%x6 4(%x2)	# 660 
	fsw	%f1 24(%x2)	# 660 
	sw	%x1 28(%x2)	# 660 
	addi	%x2 %x2 32	# 660 
	jal	 %x1 o_param_c.1780	# 660 
	addi	%x2 %x2 -32	# 660 
	lw	%x1 28(%x2)	# 660 
	flw	%f2 24(%x2)	# 660 
	fmul	%f1 %f2 %f1	# 660 
	flw	%f2 20(%x2)	# 658 
	fadd	%f1 %f2 %f1	# 658 
	jr	0(%x1)	# 658 
	nop	# 658 
in_prod_co_objrot.1836:
	flw	%f1 (4)%x7	# 665 
	flw	%f2 (8)%x7	# 665 
	fmul	%f1 %f1 %f2	# 665 
	sw	%x6 0(%x2)	# 665 
	sw	%x7 4(%x2)	# 665 
	fsw	%f1 8(%x2)	# 665 
	sw	%x1 12(%x2)	# 665 
	addi	%x2 %x2 16	# 665 
	jal	 %x1 o_param_r1.1798	# 665 
	addi	%x2 %x2 -16	# 665 
	lw	%x1 12(%x2)	# 665 
	flw	%f2 8(%x2)	# 665 
	fmul	%f1 %f2 %f1	# 665 
	lw	%x6 4(%x2)	# 666 
	flw	%f2 (0)%x6	# 666 
	flw	%f3 (8)%x6	# 666 
	fmul	%f2 %f2 %f3	# 666 
	lw	%x7 0(%x2)	# 666 
	fsw	%f1 12(%x2)	# 666 
	fsw	%f2 16(%x2)	# 666 
	add	%x6 %x0 %x7	# 666 
	sw	%x1 20(%x2)	# 666 
	addi	%x2 %x2 24	# 666 
	jal	 %x1 o_param_r2.1800	# 666 
	addi	%x2 %x2 -24	# 666 
	lw	%x1 20(%x2)	# 666 
	flw	%f2 16(%x2)	# 666 
	fmul	%f1 %f2 %f1	# 666 
	flw	%f2 12(%x2)	# 665 
	fadd	%f1 %f2 %f1	# 665 
	lw	%x6 4(%x2)	# 667 
	flw	%f2 (0)%x6	# 667 
	flw	%f3 (4)%x6	# 667 
	fmul	%f2 %f2 %f3	# 667 
	lw	%x6 0(%x2)	# 667 
	fsw	%f1 20(%x2)	# 667 
	fsw	%f2 24(%x2)	# 667 
	sw	%x1 28(%x2)	# 667 
	addi	%x2 %x2 32	# 667 
	jal	 %x1 o_param_r3.1802	# 667 
	addi	%x2 %x2 -32	# 667 
	lw	%x1 28(%x2)	# 667 
	flw	%f2 24(%x2)	# 667 
	fmul	%f1 %f2 %f1	# 667 
	flw	%f2 20(%x2)	# 665 
	fadd	%f1 %f2 %f1	# 665 
	jr	0(%x1)	# 665 
	nop	# 665 
solver2nd_mul_b.1839:
	lw	%x8 4(%x4)	# 672 
	flw	%f1 (0)%x8	# 672 
	flw	%f2 (0)%x7	# 672 
	fmul	%f1 %f1 %f2	# 672 
	sw	%x6 0(%x2)	# 672 
	sw	%x7 4(%x2)	# 672 
	sw	%x8 8(%x2)	# 672 
	fsw	%f1 12(%x2)	# 672 
	sw	%x1 20(%x2)	# 672 
	addi	%x2 %x2 24	# 672 
	jal	 %x1 o_param_a.1776	# 672 
	addi	%x2 %x2 -24	# 672 
	lw	%x1 20(%x2)	# 672 
	flw	%f2 12(%x2)	# 672 
	fmul	%f1 %f2 %f1	# 672 
	lw	%x6 8(%x2)	# 673 
	flw	%f2 (4)%x6	# 673 
	lw	%x7 4(%x2)	# 673 
	flw	%f3 (4)%x7	# 673 
	fmul	%f2 %f2 %f3	# 673 
	lw	%x8 0(%x2)	# 673 
	fsw	%f1 16(%x2)	# 673 
	fsw	%f2 20(%x2)	# 673 
	add	%x6 %x0 %x8	# 673 
	sw	%x1 28(%x2)	# 673 
	addi	%x2 %x2 32	# 673 
	jal	 %x1 o_param_b.1778	# 673 
	addi	%x2 %x2 -32	# 673 
	lw	%x1 28(%x2)	# 673 
	flw	%f2 20(%x2)	# 673 
	fmul	%f1 %f2 %f1	# 673 
	flw	%f2 16(%x2)	# 672 
	fadd	%f1 %f2 %f1	# 672 
	lw	%x6 8(%x2)	# 674 
	flw	%f2 (8)%x6	# 674 
	lw	%x6 4(%x2)	# 674 
	flw	%f3 (8)%x6	# 674 
	fmul	%f2 %f2 %f3	# 674 
	lw	%x6 0(%x2)	# 674 
	fsw	%f1 24(%x2)	# 674 
	fsw	%f2 28(%x2)	# 674 
	sw	%x1 36(%x2)	# 674 
	addi	%x2 %x2 40	# 674 
	jal	 %x1 o_param_c.1780	# 674 
	addi	%x2 %x2 -40	# 674 
	lw	%x1 36(%x2)	# 674 
	flw	%f2 28(%x2)	# 674 
	fmul	%f1 %f2 %f1	# 674 
	flw	%f2 24(%x2)	# 672 
	fadd	%f1 %f2 %f1	# 672 
	jr	0(%x1)	# 672 
	nop	# 672 
solver2nd_rot_b.1842:
	lw	%x8 4(%x4)	# 679 
	flw	%f1 (8)%x8	# 679 
	flw	%f2 (4)%x7	# 679 
	fmul	%f1 %f1 %f2	# 679 
	flw	%f2 (4)%x8	# 679 
	flw	%f3 (8)%x7	# 679 
	fmul	%f2 %f2 %f3	# 679 
	fadd	%f1 %f1 %f2	# 679 
	sw	%x6 0(%x2)	# 679 
	sw	%x7 4(%x2)	# 679 
	sw	%x8 8(%x2)	# 679 
	fsw	%f1 12(%x2)	# 679 
	sw	%x1 20(%x2)	# 679 
	addi	%x2 %x2 24	# 679 
	jal	 %x1 o_param_r1.1798	# 679 
	addi	%x2 %x2 -24	# 679 
	lw	%x1 20(%x2)	# 679 
	flw	%f2 12(%x2)	# 679 
	fmul	%f1 %f2 %f1	# 679 
	lw	%x6 8(%x2)	# 680 
	flw	%f2 (0)%x6	# 680 
	lw	%x7 4(%x2)	# 680 
	flw	%f3 (8)%x7	# 680 
	fmul	%f2 %f2 %f3	# 680 
	flw	%f3 (8)%x6	# 680 
	flw	%f4 (0)%x7	# 680 
	fmul	%f3 %f3 %f4	# 680 
	fadd	%f2 %f2 %f3	# 680 
	lw	%x8 0(%x2)	# 680 
	fsw	%f1 16(%x2)	# 680 
	fsw	%f2 20(%x2)	# 680 
	add	%x6 %x0 %x8	# 680 
	sw	%x1 28(%x2)	# 680 
	addi	%x2 %x2 32	# 680 
	jal	 %x1 o_param_r2.1800	# 680 
	addi	%x2 %x2 -32	# 680 
	lw	%x1 28(%x2)	# 680 
	flw	%f2 20(%x2)	# 680 
	fmul	%f1 %f2 %f1	# 680 
	flw	%f2 16(%x2)	# 679 
	fadd	%f1 %f2 %f1	# 679 
	lw	%x6 8(%x2)	# 681 
	flw	%f2 (0)%x6	# 681 
	lw	%x7 4(%x2)	# 681 
	flw	%f3 (4)%x7	# 681 
	fmul	%f2 %f2 %f3	# 681 
	flw	%f3 (4)%x6	# 681 
	flw	%f4 (0)%x7	# 681 
	fmul	%f3 %f3 %f4	# 681 
	fadd	%f2 %f2 %f3	# 681 
	lw	%x6 0(%x2)	# 681 
	fsw	%f1 24(%x2)	# 681 
	fsw	%f2 28(%x2)	# 681 
	sw	%x1 36(%x2)	# 681 
	addi	%x2 %x2 40	# 681 
	jal	 %x1 o_param_r3.1802	# 681 
	addi	%x2 %x2 -40	# 681 
	lw	%x1 36(%x2)	# 681 
	flw	%f2 28(%x2)	# 681 
	fmul	%f1 %f2 %f1	# 681 
	flw	%f2 24(%x2)	# 679 
	fadd	%f1 %f2 %f1	# 679 
	jr	0(%x1)	# 679 
	nop	# 679 
solver_second.1845:
	lw	%x8 16(%x4)	# 686 
	lw	%x9 12(%x4)	# 686 
	lw	%x10 8(%x4)	# 686 
	lw	%x11 4(%x4)	# 686 
	sw	%x9 0(%x2)	# 686 
	sw	%x8 4(%x2)	# 686 
	sw	%x10 8(%x2)	# 686 
	sw	%x11 12(%x2)	# 686 
	sw	%x7 16(%x2)	# 686 
	sw	%x6 20(%x2)	# 686 
	sw	%x1 28(%x2)	# 686 
	addi	%x2 %x2 32	# 686 
	jal	 %x1 in_prod_sqr_obj.1833	# 686 
	addi	%x2 %x2 -32	# 686 
	lw	%x1 28(%x2)	# 686 
	lw	%x6 20(%x2)	# 688 
	fsw	%f1 24(%x2)	# 688 
	sw	%x1 28(%x2)	# 688 
	addi	%x2 %x2 32	# 688 
	jal	 %x1 o_isrot.1774	# 688 
	addi	%x2 %x2 -32	# 688 
	lw	%x1 28(%x2)	# 688 
	addi	%x5 %x0 0	# 688 
	bne	%x6 %x5 beq_else.5898	# 688 
	nop	# 688 
	flw	%f1 24(%x2)	# 689 
	j	beq_cont.5899	# 688 
	nop	# 688 
beq_else.5898:	# 688 
	lw	%x6 20(%x2)	# 688 
	lw	%x7 16(%x2)	# 688 
	sw	%x1 28(%x2)	# 688 
	addi	%x2 %x2 32	# 688 
	jal	 %x1 in_prod_co_objrot.1836	# 688 
	addi	%x2 %x2 -32	# 688 
	lw	%x1 28(%x2)	# 688 
	flw	%f2 24(%x2)	# 688 
	fadd	%f1 %f2 %f1	# 688 
beq_cont.5899:	# 688 
	addi	%x6 %x0 l.3996	# 691 
	flw	%f2 (0)%x6	# 691 
	feq	%f2 %f1 feq.5900	# 691 
	nop	# 691 
	addi	%x6 %x0 l.3971	# 695 
	flw	%f2 (0)%x6	# 695 
	lw	%x6 20(%x2)	# 695 
	lw	%x7 16(%x2)	# 695 
	lw	%x4 12(%x2)	# 695 
	fsw	%f1 28(%x2)	# 695 
	fsw	%f2 32(%x2)	# 695 
	sw	%x1 36(%x2)	# 695 
	lw	%x5 0(%x4)	# 695 
	addi	%x2 %x2 40	# 695 
	jalr	%x1 %x5	# 695 
	addi	%x2 %x2 -40	# 695 
	lw	%x1 36(%x2)	# 695 
	flw	%f2 32(%x2)	# 695 
	fmul	%f1 %f2 %f1	# 695 
	lw	%x6 20(%x2)	# 698 
	fsw	%f1 36(%x2)	# 698 
	sw	%x1 44(%x2)	# 698 
	addi	%x2 %x2 48	# 698 
	jal	 %x1 o_isrot.1774	# 698 
	addi	%x2 %x2 -48	# 698 
	lw	%x1 44(%x2)	# 698 
	addi	%x5 %x0 0	# 698 
	bne	%x6 %x5 beq_else.5901	# 698 
	nop	# 698 
	flw	%f1 36(%x2)	# 699 
	j	beq_cont.5902	# 698 
	nop	# 698 
beq_else.5901:	# 698 
	lw	%x6 20(%x2)	# 698 
	lw	%x7 16(%x2)	# 698 
	lw	%x4 8(%x2)	# 698 
	sw	%x1 44(%x2)	# 698 
	lw	%x5 0(%x4)	# 698 
	addi	%x2 %x2 48	# 698 
	jalr	%x1 %x5	# 698 
	addi	%x2 %x2 -48	# 698 
	lw	%x1 44(%x2)	# 698 
	flw	%f2 36(%x2)	# 698 
	fadd	%f1 %f2 %f1	# 698 
beq_cont.5902:	# 698 
	lw	%x6 20(%x2)	# 701 
	lw	%x7 4(%x2)	# 701 
	fsw	%f1 40(%x2)	# 701 
	sw	%x1 44(%x2)	# 701 
	addi	%x2 %x2 48	# 701 
	jal	 %x1 in_prod_sqr_obj.1833	# 701 
	addi	%x2 %x2 -48	# 701 
	lw	%x1 44(%x2)	# 701 
	lw	%x6 20(%x2)	# 703 
	fsw	%f1 44(%x2)	# 703 
	sw	%x1 52(%x2)	# 703 
	addi	%x2 %x2 56	# 703 
	jal	 %x1 o_isrot.1774	# 703 
	addi	%x2 %x2 -56	# 703 
	lw	%x1 52(%x2)	# 703 
	addi	%x5 %x0 0	# 703 
	bne	%x6 %x5 beq_else.5903	# 703 
	nop	# 703 
	flw	%f1 44(%x2)	# 705 
	j	beq_cont.5904	# 703 
	nop	# 703 
beq_else.5903:	# 703 
	lw	%x6 20(%x2)	# 704 
	lw	%x7 4(%x2)	# 704 
	sw	%x1 52(%x2)	# 704 
	addi	%x2 %x2 56	# 704 
	jal	 %x1 in_prod_co_objrot.1836	# 704 
	addi	%x2 %x2 -56	# 704 
	lw	%x1 52(%x2)	# 704 
	flw	%f2 44(%x2)	# 704 
	fadd	%f1 %f2 %f1	# 704 
beq_cont.5904:	# 703 
	lw	%x6 20(%x2)	# 707 
	fsw	%f1 48(%x2)	# 707 
	sw	%x1 52(%x2)	# 707 
	addi	%x2 %x2 56	# 707 
	jal	 %x1 o_form.1768	# 707 
	addi	%x2 %x2 -56	# 707 
	lw	%x1 52(%x2)	# 707 
	addi	%x5 %x0 3	# 707 
	bne	%x6 %x5 beq_else.5905	# 707 
	nop	# 707 
	addi	%x6 %x0 l.3998	# 708 
	flw	%f1 (0)%x6	# 708 
	flw	%f2 48(%x2)	# 708 
	fsub	%f1 %f2 %f1	# 708 
	j	beq_cont.5906	# 707 
	nop	# 707 
beq_else.5905:	# 707 
	flw	%f1 48(%x2)	# 708 
beq_cont.5906:	# 707 
	addi	%x6 %x0 l.4246	# 711 
	flw	%f2 (0)%x6	# 711 
	flw	%f3 28(%x2)	# 711 
	fmul	%f2 %f2 %f3	# 711 
	fmul	%f1 %f2 %f1	# 711 
	flw	%f2 40(%x2)	# 712 
	fsw	%f1 52(%x2)	# 712 
	fadd	%f1 %f2 %f0	# 712 
	sw	%x1 60(%x2)	# 712 
	addi	%x2 %x2 64	# 712 
	jal	 %x1 fsqr.1762	# 712 
	addi	%x2 %x2 -64	# 712 
	lw	%x1 60(%x2)	# 712 
	flw	%f2 52(%x2)	# 712 
	fsub	%f1 %f1 %f2	# 712 
	addi	%x6 %x0 l.3996	# 714 
	flw	%f2 (0)%x6	# 714 
	fle	%f1 %f2 fle.5907	# 714 
	nop	# 714 
	sw	%x1 60(%x2)	# 717 
	addi	%x2 %x2 64	# 717 
	jal	 %x1 min_caml_sqrt	# 717 
	addi	%x2 %x2 -64	# 717 
	lw	%x1 60(%x2)	# 717 
	lw	%x6 20(%x2)	# 718 
	fsw	%f1 56(%x2)	# 718 
	sw	%x1 60(%x2)	# 718 
	addi	%x2 %x2 64	# 718 
	jal	 %x1 o_isinvert.1772	# 718 
	addi	%x2 %x2 -64	# 718 
	lw	%x1 60(%x2)	# 718 
	addi	%x5 %x0 0	# 718 
	bne	%x6 %x5 beq_else.5908	# 718 
	nop	# 718 
	flw	%f1 56(%x2)	# 718 
	fneg	%f1 %f1	# 718 
	j	beq_cont.5909	# 718 
	nop	# 718 
beq_else.5908:	# 718 
	flw	%f1 56(%x2)	# 718 
beq_cont.5909:	# 718 
	flw	%f2 40(%x2)	# 719 
	fsub	%f1 %f1 %f2	# 719 
	addi	%x6 %x0 l.3971	# 719 
	flw	%f2 (0)%x6	# 719 
	fdiv	%f1 %f1 %f2	# 719 
	flw	%f2 28(%x2)	# 719 
	fdiv	%f1 %f1 %f2	# 719 
	lw	%x6 0(%x2)	# 719 
	fsw	%f1 (0)%x6	# 719 

	addi	%x6 %x0 1	# 719 
	jr	0(%x1)	# 719 
	nop	# 719 
fle.5907:	# 714 
	addi	%x6 %x0 0	# 721 
	jr	0(%x1)	# 721 
	nop	# 721 
feq.5900:	# 691 
	addi	%x6 %x0 0	# 692 
	jr	0(%x1)	# 692 
	nop	# 692 
solver.1848:
	lw	%x9 20(%x4)	# 728 
	lw	%x10 16(%x4)	# 728 
	lw	%x11 12(%x4)	# 728 
	lw	%x12 8(%x4)	# 728 
	lw	%x13 4(%x4)	# 728 
	sll	%x6 %x6 2	# 728 
	lw	%x6 %x6(%x13)	# 728 
	flw	%f1 (0)%x8	# 729 
	sw	%x11 0(%x2)	# 729 
	sw	%x10 4(%x2)	# 729 
	sw	%x7 8(%x2)	# 729 
	sw	%x12 12(%x2)	# 729 
	sw	%x6 16(%x2)	# 729 
	sw	%x8 20(%x2)	# 729 
	sw	%x9 24(%x2)	# 729 
	fsw	%f1 28(%x2)	# 729 
	sw	%x1 36(%x2)	# 729 
	addi	%x2 %x2 40	# 729 
	jal	 %x1 o_param_x.1782	# 729 
	addi	%x2 %x2 -40	# 729 
	lw	%x1 36(%x2)	# 729 
	flw	%f2 28(%x2)	# 729 
	fsub	%f1 %f2 %f1	# 729 
	lw	%x6 24(%x2)	# 729 
	fsw	%f1 (0)%x6	# 729 

	lw	%x7 20(%x2)	# 730 
	flw	%f1 (4)%x7	# 730 
	lw	%x8 16(%x2)	# 730 
	fsw	%f1 32(%x2)	# 730 
	add	%x6 %x0 %x8	# 730 
	sw	%x1 36(%x2)	# 730 
	addi	%x2 %x2 40	# 730 
	jal	 %x1 o_param_y.1784	# 730 
	addi	%x2 %x2 -40	# 730 
	lw	%x1 36(%x2)	# 730 
	flw	%f2 32(%x2)	# 730 
	fsub	%f1 %f2 %f1	# 730 
	lw	%x6 24(%x2)	# 730 
	fsw	%f1 (4)%x6	# 730 

	lw	%x7 20(%x2)	# 731 
	flw	%f1 (8)%x7	# 731 
	lw	%x7 16(%x2)	# 731 
	fsw	%f1 36(%x2)	# 731 
	add	%x6 %x0 %x7	# 731 
	sw	%x1 44(%x2)	# 731 
	addi	%x2 %x2 48	# 731 
	jal	 %x1 o_param_z.1786	# 731 
	addi	%x2 %x2 -48	# 731 
	lw	%x1 44(%x2)	# 731 
	flw	%f2 36(%x2)	# 731 
	fsub	%f1 %f2 %f1	# 731 
	lw	%x6 24(%x2)	# 731 
	fsw	%f1 (8)%x6	# 731 

	lw	%x6 16(%x2)	# 732 
	sw	%x1 44(%x2)	# 732 
	addi	%x2 %x2 48	# 732 
	jal	 %x1 o_form.1768	# 732 
	addi	%x2 %x2 -48	# 732 
	lw	%x1 44(%x2)	# 732 
	addi	%x5 %x0 1	# 733 
	bne	%x6 %x5 beq_else.5910	# 733 
	nop	# 733 
	lw	%x6 16(%x2)	# 733 
	lw	%x7 8(%x2)	# 733 
	lw	%x4 12(%x2)	# 733 
	lw	%x5 0(%x4)	# 733 
	jr	0(%x5)	# 733 
	nop	# 733 
beq_else.5910:	# 733 
	addi	%x5 %x0 2	# 734 
	bne	%x6 %x5 beq_else.5911	# 734 
	nop	# 734 
	lw	%x6 16(%x2)	# 734 
	lw	%x7 8(%x2)	# 734 
	lw	%x4 4(%x2)	# 734 
	lw	%x5 0(%x4)	# 734 
	jr	0(%x5)	# 734 
	nop	# 734 
beq_else.5911:	# 734 
	lw	%x6 16(%x2)	# 735 
	lw	%x7 8(%x2)	# 735 
	lw	%x4 0(%x2)	# 735 
	lw	%x5 0(%x4)	# 735 
	jr	0(%x5)	# 735 
	nop	# 735 
is_rect_outside.1852:
	lw	%x7 4(%x4)	# 745 
	sw	%x6 0(%x2)	# 745 
	sw	%x7 4(%x2)	# 745 
	sw	%x1 12(%x2)	# 745 
	addi	%x2 %x2 16	# 745 
	jal	 %x1 o_param_a.1776	# 745 
	addi	%x2 %x2 -16	# 745 
	lw	%x1 12(%x2)	# 745 
	lw	%x6 4(%x2)	# 745 
	flw	%f2 (0)%x6	# 745 
	fsw	%f1 8(%x2)	# 745 
	fadd	%f1 %f2 %f0	# 745 
	sw	%x1 12(%x2)	# 745 
	addi	%x2 %x2 16	# 745 
	jal	 %x1 min_caml_abs_float	# 745 
	addi	%x2 %x2 -16	# 745 
	lw	%x1 12(%x2)	# 745 
	flw	%f2 8(%x2)	# 745 
	fblt	%f2 %f1 fblt.5912	# 745 
	nop	# 745 
	lw	%x6 0(%x2)	# 746 
	sw	%x1 12(%x2)	# 746 
	addi	%x2 %x2 16	# 746 
	jal	 %x1 o_param_b.1778	# 746 
	addi	%x2 %x2 -16	# 746 
	lw	%x1 12(%x2)	# 746 
	lw	%x6 4(%x2)	# 746 
	flw	%f2 (4)%x6	# 746 
	fsw	%f1 12(%x2)	# 746 
	fadd	%f1 %f2 %f0	# 746 
	sw	%x1 20(%x2)	# 746 
	addi	%x2 %x2 24	# 746 
	jal	 %x1 min_caml_abs_float	# 746 
	addi	%x2 %x2 -24	# 746 
	lw	%x1 20(%x2)	# 746 
	flw	%f2 12(%x2)	# 746 
	fblt	%f2 %f1 fblt.5914	# 746 
	nop	# 746 
	lw	%x6 0(%x2)	# 747 
	sw	%x1 20(%x2)	# 747 
	addi	%x2 %x2 24	# 747 
	jal	 %x1 o_param_c.1780	# 747 
	addi	%x2 %x2 -24	# 747 
	lw	%x1 20(%x2)	# 747 
	lw	%x6 4(%x2)	# 747 
	flw	%f2 (8)%x6	# 747 
	fsw	%f1 16(%x2)	# 747 
	fadd	%f1 %f2 %f0	# 747 
	sw	%x1 20(%x2)	# 747 
	addi	%x2 %x2 24	# 747 
	jal	 %x1 min_caml_abs_float	# 747 
	addi	%x2 %x2 -24	# 747 
	lw	%x1 20(%x2)	# 747 
	flw	%f2 16(%x2)	# 747 
	fblt	%f2 %f1 fblt.5916	# 747 
	nop	# 747 
	addi	%x6 %x0 1	# 747 
	j	fblt_cont.5917	# 747 
	nop	# 747 
fblt.5916:	# 747 
	addi	%x6 %x0 0	# 747 
fblt_cont.5917:	# 747 
	j	fblt_cont.5915	# 746 
	nop	# 746 
fblt.5914:	# 746 
	addi	%x6 %x0 0	# 748 
fblt_cont.5915:	# 746 
	j	fblt_cont.5913	# 745 
	nop	# 745 
fblt.5912:	# 745 
	addi	%x6 %x0 0	# 749 
fblt_cont.5913:	# 745 
	addi	%x5 %x0 0	# 744 
	bne	%x6 %x5 beq_else.5918	# 744 
	nop	# 744 
	lw	%x6 0(%x2)	# 751 
	sw	%x1 20(%x2)	# 751 
	addi	%x2 %x2 24	# 751 
	jal	 %x1 o_isinvert.1772	# 751 
	addi	%x2 %x2 -24	# 751 
	lw	%x1 20(%x2)	# 751 
	addi	%x5 %x0 0	# 751 
	bne	%x6 %x5 beq_else.5919	# 751 
	nop	# 751 
	addi	%x6 %x0 1	# 751 
	jr	0(%x1)	# 751 
	nop	# 751 
beq_else.5919:	# 751 
	addi	%x6 %x0 0	# 751 
	jr	0(%x1)	# 751 
	nop	# 751 
beq_else.5918:	# 744 
	lw	%x6 0(%x2)	# 751 
	j	o_isinvert.1772	# 751 
	nop	# 751 
is_plane_outside.1854:
	lw	%x7 4(%x4)	# 756 
	sw	%x6 0(%x2)	# 756 
	sw	%x7 4(%x2)	# 756 
	sw	%x1 12(%x2)	# 756 
	addi	%x2 %x2 16	# 756 
	jal	 %x1 o_param_a.1776	# 756 
	addi	%x2 %x2 -16	# 756 
	lw	%x1 12(%x2)	# 756 
	lw	%x6 4(%x2)	# 756 
	flw	%f2 (0)%x6	# 756 
	fmul	%f1 %f1 %f2	# 756 
	lw	%x7 0(%x2)	# 757 
	fsw	%f1 8(%x2)	# 757 
	add	%x6 %x0 %x7	# 757 
	sw	%x1 12(%x2)	# 757 
	addi	%x2 %x2 16	# 757 
	jal	 %x1 o_param_b.1778	# 757 
	addi	%x2 %x2 -16	# 757 
	lw	%x1 12(%x2)	# 757 
	lw	%x6 4(%x2)	# 757 
	flw	%f2 (4)%x6	# 757 
	fmul	%f1 %f1 %f2	# 757 
	flw	%f2 8(%x2)	# 756 
	fadd	%f1 %f2 %f1	# 756 
	lw	%x7 0(%x2)	# 758 
	fsw	%f1 12(%x2)	# 758 
	add	%x6 %x0 %x7	# 758 
	sw	%x1 20(%x2)	# 758 
	addi	%x2 %x2 24	# 758 
	jal	 %x1 o_param_c.1780	# 758 
	addi	%x2 %x2 -24	# 758 
	lw	%x1 20(%x2)	# 758 
	lw	%x6 4(%x2)	# 758 
	flw	%f2 (8)%x6	# 758 
	fmul	%f1 %f1 %f2	# 758 
	flw	%f2 12(%x2)	# 756 
	fadd	%f1 %f2 %f1	# 756 
	addi	%x6 %x0 l.3996	# 759 
	flw	%f2 (0)%x6	# 759 
	fblt	%f2 %f1 fblt.5920	# 759 
	nop	# 759 
	addi	%x6 %x0 1	# 759 
	j	fblt_cont.5921	# 759 
	nop	# 759 
fblt.5920:	# 759 
	addi	%x6 %x0 0	# 759 
fblt_cont.5921:	# 759 
	lw	%x7 0(%x2)	# 760 
	sw	%x6 16(%x2)	# 760 
	add	%x6 %x0 %x7	# 760 
	sw	%x1 20(%x2)	# 760 
	addi	%x2 %x2 24	# 760 
	jal	 %x1 o_isinvert.1772	# 760 
	addi	%x2 %x2 -24	# 760 
	lw	%x1 20(%x2)	# 760 
	lw	%x7 16(%x2)	# 760 
	sw	%x1 20(%x2)	# 760 
	addi	%x2 %x2 24	# 760 
	jal	 %x1 xor.1759	# 760 
	addi	%x2 %x2 -24	# 760 
	lw	%x1 20(%x2)	# 760 
	addi	%x5 %x0 0	# 760 
	bne	%x6 %x5 beq_else.5922	# 760 
	nop	# 760 
	addi	%x6 %x0 1	# 760 
	jr	0(%x1)	# 760 
	nop	# 760 
beq_else.5922:	# 760 
	addi	%x6 %x0 0	# 760 
	jr	0(%x1)	# 760 
	nop	# 760 
is_second_outside.1856:
	lw	%x7 4(%x4)	# 765 
	sw	%x7 0(%x2)	# 765 
	sw	%x6 4(%x2)	# 765 
	sw	%x1 12(%x2)	# 765 
	addi	%x2 %x2 16	# 765 
	jal	 %x1 in_prod_sqr_obj.1833	# 765 
	addi	%x2 %x2 -16	# 765 
	lw	%x1 12(%x2)	# 765 
	lw	%x6 4(%x2)	# 766 
	fsw	%f1 8(%x2)	# 766 
	sw	%x1 12(%x2)	# 766 
	addi	%x2 %x2 16	# 766 
	jal	 %x1 o_form.1768	# 766 
	addi	%x2 %x2 -16	# 766 
	lw	%x1 12(%x2)	# 766 
	addi	%x5 %x0 3	# 766 
	bne	%x6 %x5 beq_else.5923	# 766 
	nop	# 766 
	addi	%x6 %x0 l.3998	# 766 
	flw	%f1 (0)%x6	# 766 
	flw	%f2 8(%x2)	# 766 
	fsub	%f1 %f2 %f1	# 766 
	j	beq_cont.5924	# 766 
	nop	# 766 
beq_else.5923:	# 766 
	flw	%f1 8(%x2)	# 766 
beq_cont.5924:	# 766 
	lw	%x6 4(%x2)	# 768 
	fsw	%f1 12(%x2)	# 768 
	sw	%x1 20(%x2)	# 768 
	addi	%x2 %x2 24	# 768 
	jal	 %x1 o_isrot.1774	# 768 
	addi	%x2 %x2 -24	# 768 
	lw	%x1 20(%x2)	# 768 
	addi	%x5 %x0 0	# 768 
	bne	%x6 %x5 beq_else.5925	# 768 
	nop	# 768 
	flw	%f1 12(%x2)	# 771 
	j	beq_cont.5926	# 768 
	nop	# 768 
beq_else.5925:	# 768 
	lw	%x6 4(%x2)	# 769 
	lw	%x7 0(%x2)	# 769 
	sw	%x1 20(%x2)	# 769 
	addi	%x2 %x2 24	# 769 
	jal	 %x1 in_prod_co_objrot.1836	# 769 
	addi	%x2 %x2 -24	# 769 
	lw	%x1 20(%x2)	# 769 
	flw	%f2 12(%x2)	# 769 
	fadd	%f1 %f2 %f1	# 769 
beq_cont.5926:	# 768 
	addi	%x6 %x0 l.3996	# 773 
	flw	%f2 (0)%x6	# 773 
	fblt	%f2 %f1 fblt.5927	# 773 
	nop	# 773 
	addi	%x6 %x0 1	# 773 
	j	fblt_cont.5928	# 773 
	nop	# 773 
fblt.5927:	# 773 
	addi	%x6 %x0 0	# 773 
fblt_cont.5928:	# 773 
	lw	%x7 4(%x2)	# 774 
	sw	%x6 16(%x2)	# 774 
	add	%x6 %x0 %x7	# 774 
	sw	%x1 20(%x2)	# 774 
	addi	%x2 %x2 24	# 774 
	jal	 %x1 o_isinvert.1772	# 774 
	addi	%x2 %x2 -24	# 774 
	lw	%x1 20(%x2)	# 774 
	lw	%x7 16(%x2)	# 774 
	sw	%x1 20(%x2)	# 774 
	addi	%x2 %x2 24	# 774 
	jal	 %x1 xor.1759	# 774 
	addi	%x2 %x2 -24	# 774 
	lw	%x1 20(%x2)	# 774 
	addi	%x5 %x0 0	# 774 
	bne	%x6 %x5 beq_else.5929	# 774 
	nop	# 774 
	addi	%x6 %x0 1	# 774 
	jr	0(%x1)	# 774 
	nop	# 774 
beq_else.5929:	# 774 
	addi	%x6 %x0 0	# 774 
	jr	0(%x1)	# 774 
	nop	# 774 
is_outside.1858:
	lw	%x7 20(%x4)	# 779 
	lw	%x8 16(%x4)	# 779 
	lw	%x9 12(%x4)	# 779 
	lw	%x10 8(%x4)	# 779 
	lw	%x11 4(%x4)	# 779 
	flw	%f1 (0)%x11	# 779 
	sw	%x8 0(%x2)	# 779 
	sw	%x10 4(%x2)	# 779 
	sw	%x9 8(%x2)	# 779 
	sw	%x6 12(%x2)	# 779 
	sw	%x11 16(%x2)	# 779 
	sw	%x7 20(%x2)	# 779 
	fsw	%f1 24(%x2)	# 779 
	sw	%x1 28(%x2)	# 779 
	addi	%x2 %x2 32	# 779 
	jal	 %x1 o_param_x.1782	# 779 
	addi	%x2 %x2 -32	# 779 
	lw	%x1 28(%x2)	# 779 
	flw	%f2 24(%x2)	# 779 
	fsub	%f1 %f2 %f1	# 779 
	lw	%x6 20(%x2)	# 779 
	fsw	%f1 (0)%x6	# 779 

	lw	%x7 16(%x2)	# 780 
	flw	%f1 (4)%x7	# 780 
	lw	%x8 12(%x2)	# 780 
	fsw	%f1 28(%x2)	# 780 
	add	%x6 %x0 %x8	# 780 
	sw	%x1 36(%x2)	# 780 
	addi	%x2 %x2 40	# 780 
	jal	 %x1 o_param_y.1784	# 780 
	addi	%x2 %x2 -40	# 780 
	lw	%x1 36(%x2)	# 780 
	flw	%f2 28(%x2)	# 780 
	fsub	%f1 %f2 %f1	# 780 
	lw	%x6 20(%x2)	# 780 
	fsw	%f1 (4)%x6	# 780 

	lw	%x7 16(%x2)	# 781 
	flw	%f1 (8)%x7	# 781 
	lw	%x7 12(%x2)	# 781 
	fsw	%f1 32(%x2)	# 781 
	add	%x6 %x0 %x7	# 781 
	sw	%x1 36(%x2)	# 781 
	addi	%x2 %x2 40	# 781 
	jal	 %x1 o_param_z.1786	# 781 
	addi	%x2 %x2 -40	# 781 
	lw	%x1 36(%x2)	# 781 
	flw	%f2 32(%x2)	# 781 
	fsub	%f1 %f2 %f1	# 781 
	lw	%x6 20(%x2)	# 781 
	fsw	%f1 (8)%x6	# 781 

	lw	%x6 12(%x2)	# 782 
	sw	%x1 36(%x2)	# 782 
	addi	%x2 %x2 40	# 782 
	jal	 %x1 o_form.1768	# 782 
	addi	%x2 %x2 -40	# 782 
	lw	%x1 36(%x2)	# 782 
	addi	%x5 %x0 1	# 783 
	bne	%x6 %x5 beq_else.5930	# 783 
	nop	# 783 
	lw	%x6 12(%x2)	# 784 
	lw	%x4 8(%x2)	# 784 
	lw	%x5 0(%x4)	# 784 
	jr	0(%x5)	# 784 
	nop	# 784 
beq_else.5930:	# 783 
	addi	%x5 %x0 2	# 785 
	bne	%x6 %x5 beq_else.5931	# 785 
	nop	# 785 
	lw	%x6 12(%x2)	# 786 
	lw	%x4 4(%x2)	# 786 
	lw	%x5 0(%x4)	# 786 
	jr	0(%x5)	# 786 
	nop	# 786 
beq_else.5931:	# 785 
	lw	%x6 12(%x2)	# 788 
	lw	%x4 0(%x2)	# 788 
	lw	%x5 0(%x4)	# 788 
	jr	0(%x5)	# 788 
	nop	# 788 
check_all_inside.1860:
	lw	%x8 8(%x4)	# 794 
	lw	%x9 4(%x4)	# 794 
	sll	%x10 %x6 2	# 794 
	lw	%x10 %x10(%x7)	# 794 
	addi	%x5 %x0 -1	# 795 
	bne	%x10 %x5 beq_else.5932	# 795 
	nop	# 795 
	addi	%x6 %x0 1	# 795 
	jr	0(%x1)	# 795 
	nop	# 795 
beq_else.5932:	# 795 
	sll	%x10 %x10 2	# 796 
	lw	%x8 %x10(%x8)	# 796 
	sw	%x7 0(%x2)	# 796 
	sw	%x4 4(%x2)	# 796 
	sw	%x6 8(%x2)	# 796 
	add	%x6 %x0 %x8	# 796 
	add	%x4 %x0 %x9	# 796 
	sw	%x1 12(%x2)	# 796 
	lw	%x5 0(%x4)	# 796 
	addi	%x2 %x2 16	# 796 
	jalr	%x1 %x5	# 796 
	addi	%x2 %x2 -16	# 796 
	lw	%x1 12(%x2)	# 796 
	addi	%x5 %x0 0	# 796 
	bne	%x6 %x5 beq_else.5933	# 796 
	nop	# 796 
	lw	%x6 8(%x2)	# 797 
	addi	%x6 %x6 1	# 797 
	lw	%x7 0(%x2)	# 797 
	lw	%x4 4(%x2)	# 797 
	lw	%x5 0(%x4)	# 797 
	jr	0(%x5)	# 797 
	nop	# 797 
beq_else.5933:	# 796 
	addi	%x6 %x0 0	# 796 
	jr	0(%x1)	# 796 
	nop	# 796 
shadow_check_and_group.1863:
	lw	%x9 24(%x4)	# 809 
	lw	%x10 20(%x4)	# 809 
	lw	%x11 16(%x4)	# 809 
	lw	%x12 12(%x4)	# 809 
	lw	%x13 8(%x4)	# 809 
	lw	%x14 4(%x4)	# 809 
	sll	%x15 %x6 2	# 809 
	lw	%x15 %x15(%x7)	# 809 
	addi	%x5 %x0 -1	# 809 
	bne	%x15 %x5 beq_else.5934	# 809 
	nop	# 809 
	addi	%x6 %x0 0	# 810 
	jr	0(%x1)	# 810 
	nop	# 810 
beq_else.5934:	# 809 
	sll	%x15 %x6 2	# 812 
	lw	%x15 %x15(%x7)	# 812 
	sw	%x14 0(%x2)	# 818 
	sw	%x13 4(%x2)	# 818 
	sw	%x12 8(%x2)	# 818 
	sw	%x8 12(%x2)	# 818 
	sw	%x7 16(%x2)	# 818 
	sw	%x4 20(%x2)	# 818 
	sw	%x6 24(%x2)	# 818 
	sw	%x11 28(%x2)	# 818 
	sw	%x15 32(%x2)	# 818 
	sw	%x9 36(%x2)	# 818 
	add	%x7 %x0 %x12	# 818 
	add	%x6 %x0 %x15	# 818 
	add	%x4 %x0 %x10	# 818 
	sw	%x1 44(%x2)	# 818 
	lw	%x5 0(%x4)	# 818 
	addi	%x2 %x2 48	# 818 
	jalr	%x1 %x5	# 818 
	addi	%x2 %x2 -48	# 818 
	lw	%x1 44(%x2)	# 818 
	lw	%x7 36(%x2)	# 819 
	flw	%f1 (0)%x7	# 819 
	addi	%x5 %x0 0	# 820 
	bne	%x6 %x5 beq_else.5935	# 820 
	nop	# 820 
	addi	%x6 %x0 0	# 820 
	j	beq_cont.5936	# 820 
	nop	# 820 
beq_else.5935:	# 820 
	addi	%x6 %x0 l.4278	# 820 
	flw	%f2 (0)%x6	# 820 
	fblt	%f2 %f1 fblt.5937	# 820 
	nop	# 820 
	addi	%x6 %x0 1	# 820 
	j	fblt_cont.5938	# 820 
	nop	# 820 
fblt.5937:	# 820 
	addi	%x6 %x0 0	# 820 
fblt_cont.5938:	# 820 
beq_cont.5936:	# 820 
	addi	%x5 %x0 0	# 820 
	bne	%x6 %x5 beq_else.5939	# 820 
	nop	# 820 
	lw	%x6 32(%x2)	# 836 
	sll	%x6 %x6 2	# 836 
	lw	%x7 28(%x2)	# 836 
	lw	%x6 %x6(%x7)	# 836 
	sw	%x1 44(%x2)	# 836 
	addi	%x2 %x2 48	# 836 
	jal	 %x1 o_isinvert.1772	# 836 
	addi	%x2 %x2 -48	# 836 
	lw	%x1 44(%x2)	# 836 
	addi	%x5 %x0 0	# 836 
	bne	%x6 %x5 beq_else.5940	# 836 
	nop	# 836 
	addi	%x6 %x0 0	# 838 
	jr	0(%x1)	# 838 
	nop	# 838 
beq_else.5940:	# 836 
	lw	%x6 24(%x2)	# 837 
	addi	%x6 %x6 1	# 837 
	lw	%x7 16(%x2)	# 837 
	lw	%x8 12(%x2)	# 837 
	lw	%x4 20(%x2)	# 837 
	lw	%x5 0(%x4)	# 837 
	jr	0(%x5)	# 837 
	nop	# 837 
beq_else.5939:	# 820 
	addi	%x6 %x0 l.4280	# 824 
	flw	%f2 (0)%x6	# 824 
	fadd	%f1 %f1 %f2	# 824 
	lw	%x6 8(%x2)	# 825 
	flw	%f2 (0)%x6	# 825 
	fmul	%f2 %f2 %f1	# 825 
	lw	%x7 12(%x2)	# 825 
	flw	%f3 (0)%x7	# 825 
	fadd	%f2 %f2 %f3	# 825 
	lw	%x8 4(%x2)	# 825 
	fsw	%f2 (0)%x8	# 825 

	flw	%f2 (4)%x6	# 826 
	fmul	%f2 %f2 %f1	# 826 
	flw	%f3 (4)%x7	# 826 
	fadd	%f2 %f2 %f3	# 826 
	fsw	%f2 (4)%x8	# 826 

	flw	%f2 (8)%x6	# 827 
	fmul	%f1 %f2 %f1	# 827 
	flw	%f2 (8)%x7	# 827 
	fadd	%f1 %f1 %f2	# 827 
	fsw	%f1 (8)%x8	# 827 

	addi	%x6 %x0 0	# 828 
	lw	%x8 16(%x2)	# 828 
	lw	%x4 0(%x2)	# 828 
	add	%x7 %x0 %x8	# 828 
	sw	%x1 44(%x2)	# 828 
	lw	%x5 0(%x4)	# 828 
	addi	%x2 %x2 48	# 828 
	jalr	%x1 %x5	# 828 
	addi	%x2 %x2 -48	# 828 
	lw	%x1 44(%x2)	# 828 
	addi	%x5 %x0 0	# 828 
	bne	%x6 %x5 beq_else.5941	# 828 
	nop	# 828 
	lw	%x6 24(%x2)	# 830 
	addi	%x6 %x6 1	# 830 
	lw	%x7 16(%x2)	# 830 
	lw	%x8 12(%x2)	# 830 
	lw	%x4 20(%x2)	# 830 
	lw	%x5 0(%x4)	# 830 
	jr	0(%x5)	# 830 
	nop	# 830 
beq_else.5941:	# 828 
	addi	%x6 %x0 1	# 829 
	jr	0(%x1)	# 829 
	nop	# 829 
shadow_check_one_or_group.1867:
	lw	%x9 8(%x4)	# 844 
	lw	%x10 4(%x4)	# 844 
	sll	%x11 %x6 2	# 844 
	lw	%x11 %x11(%x7)	# 844 
	addi	%x5 %x0 -1	# 845 
	bne	%x11 %x5 beq_else.5942	# 845 
	nop	# 845 
	addi	%x6 %x0 0	# 846 
	jr	0(%x1)	# 846 
	nop	# 846 
beq_else.5942:	# 845 
	sll	%x11 %x11 2	# 848 
	lw	%x10 %x11(%x10)	# 848 
	addi	%x11 %x0 0	# 849 
	sw	%x8 0(%x2)	# 849 
	sw	%x7 4(%x2)	# 849 
	sw	%x4 8(%x2)	# 849 
	sw	%x6 12(%x2)	# 849 
	add	%x7 %x0 %x10	# 849 
	add	%x6 %x0 %x11	# 849 
	add	%x4 %x0 %x9	# 849 
	sw	%x1 20(%x2)	# 849 
	lw	%x5 0(%x4)	# 849 
	addi	%x2 %x2 24	# 849 
	jalr	%x1 %x5	# 849 
	addi	%x2 %x2 -24	# 849 
	lw	%x1 20(%x2)	# 849 
	addi	%x5 %x0 0	# 850 
	bne	%x6 %x5 beq_else.5943	# 850 
	nop	# 850 
	lw	%x6 12(%x2)	# 851 
	addi	%x6 %x6 1	# 851 
	lw	%x7 4(%x2)	# 851 
	lw	%x8 0(%x2)	# 851 
	lw	%x4 8(%x2)	# 851 
	lw	%x5 0(%x4)	# 851 
	jr	0(%x5)	# 851 
	nop	# 851 
beq_else.5943:	# 850 
	addi	%x6 %x0 1	# 850 
	jr	0(%x1)	# 850 
	nop	# 850 
shadow_check_one_or_matrix.1871:
	lw	%x9 16(%x4)	# 858 
	lw	%x10 12(%x4)	# 858 
	lw	%x11 8(%x4)	# 858 
	lw	%x12 4(%x4)	# 858 
	sll	%x13 %x6 2	# 858 
	lw	%x13 %x13(%x7)	# 858 
	lw	%x14 0(%x13)	# 859 
	addi	%x5 %x0 -1	# 860 
	bne	%x14 %x5 beq_else.5944	# 860 
	nop	# 860 
	addi	%x6 %x0 0	# 860 
	jr	0(%x1)	# 860 
	nop	# 860 
beq_else.5944:	# 860 
	addi	%x5 %x0 99	# 862 
	bne	%x14 %x5 beq_else.5945	# 862 
	nop	# 862 
	addi	%x9 %x0 1	# 865 
	sw	%x8 0(%x2)	# 865 
	sw	%x7 4(%x2)	# 865 
	sw	%x4 8(%x2)	# 865 
	sw	%x6 12(%x2)	# 865 
	add	%x7 %x0 %x13	# 865 
	add	%x6 %x0 %x9	# 865 
	add	%x4 %x0 %x11	# 865 
	sw	%x1 20(%x2)	# 865 
	lw	%x5 0(%x4)	# 865 
	addi	%x2 %x2 24	# 865 
	jalr	%x1 %x5	# 865 
	addi	%x2 %x2 -24	# 865 
	lw	%x1 20(%x2)	# 865 
	addi	%x5 %x0 0	# 865 
	bne	%x6 %x5 beq_else.5946	# 865 
	nop	# 865 
	lw	%x6 12(%x2)	# 867 
	addi	%x6 %x6 1	# 867 
	lw	%x7 4(%x2)	# 867 
	lw	%x8 0(%x2)	# 867 
	lw	%x4 8(%x2)	# 867 
	lw	%x5 0(%x4)	# 867 
	jr	0(%x5)	# 867 
	nop	# 867 
beq_else.5946:	# 865 
	addi	%x6 %x0 1	# 866 
	jr	0(%x1)	# 866 
	nop	# 866 
beq_else.5945:	# 862 
	sw	%x13 16(%x2)	# 870 
	sw	%x11 20(%x2)	# 870 
	sw	%x9 24(%x2)	# 870 
	sw	%x8 0(%x2)	# 870 
	sw	%x7 4(%x2)	# 870 
	sw	%x4 8(%x2)	# 870 
	sw	%x6 12(%x2)	# 870 
	add	%x7 %x0 %x12	# 870 
	add	%x6 %x0 %x14	# 870 
	add	%x4 %x0 %x10	# 870 
	sw	%x1 28(%x2)	# 870 
	lw	%x5 0(%x4)	# 870 
	addi	%x2 %x2 32	# 870 
	jalr	%x1 %x5	# 870 
	addi	%x2 %x2 -32	# 870 
	lw	%x1 28(%x2)	# 870 
	addi	%x5 %x0 0	# 873 
	bne	%x6 %x5 beq_else.5947	# 873 
	nop	# 873 
	lw	%x6 12(%x2)	# 880 
	addi	%x6 %x6 1	# 880 
	lw	%x7 4(%x2)	# 880 
	lw	%x8 0(%x2)	# 880 
	lw	%x4 8(%x2)	# 880 
	lw	%x5 0(%x4)	# 880 
	jr	0(%x5)	# 880 
	nop	# 880 
beq_else.5947:	# 873 
	addi	%x6 %x0 l.4296	# 874 
	flw	%f1 (0)%x6	# 874 
	lw	%x6 24(%x2)	# 874 
	flw	%f2 (0)%x6	# 874 
	fle	%f1 %f2 fle.5948	# 874 
	nop	# 874 
	addi	%x6 %x0 1	# 876 
	lw	%x7 16(%x2)	# 876 
	lw	%x8 0(%x2)	# 876 
	lw	%x4 20(%x2)	# 876 
	sw	%x1 28(%x2)	# 876 
	lw	%x5 0(%x4)	# 876 
	addi	%x2 %x2 32	# 876 
	jalr	%x1 %x5	# 876 
	addi	%x2 %x2 -32	# 876 
	lw	%x1 28(%x2)	# 876 
	addi	%x5 %x0 0	# 876 
	bne	%x6 %x5 beq_else.5949	# 876 
	nop	# 876 
	lw	%x6 12(%x2)	# 878 
	addi	%x6 %x6 1	# 878 
	lw	%x7 4(%x2)	# 878 
	lw	%x8 0(%x2)	# 878 
	lw	%x4 8(%x2)	# 878 
	lw	%x5 0(%x4)	# 878 
	jr	0(%x5)	# 878 
	nop	# 878 
beq_else.5949:	# 876 
	addi	%x6 %x0 1	# 877 
	jr	0(%x1)	# 877 
	nop	# 877 
fle.5948:	# 874 
	lw	%x6 12(%x2)	# 879 
	addi	%x6 %x6 1	# 879 
	lw	%x7 4(%x2)	# 879 
	lw	%x8 0(%x2)	# 879 
	lw	%x4 8(%x2)	# 879 
	lw	%x5 0(%x4)	# 879 
	jr	0(%x5)	# 879 
	nop	# 879 
solve_each_element.1875:
	lw	%x8 48(%x4)	# 890 
	lw	%x9 44(%x4)	# 890 
	lw	%x10 40(%x4)	# 890 
	lw	%x11 36(%x4)	# 890 
	lw	%x12 32(%x4)	# 890 
	lw	%x13 28(%x4)	# 890 
	lw	%x14 24(%x4)	# 890 
	lw	%x15 20(%x4)	# 890 
	lw	%x16 16(%x4)	# 890 
	lw	%x17 12(%x4)	# 890 
	lw	%x18 8(%x4)	# 890 
	lw	%x19 4(%x4)	# 890 
	sll	%x20 %x6 2	# 890 
	lw	%x20 %x20(%x7)	# 890 
	addi	%x5 %x0 -1	# 891 
	bne	%x20 %x5 beq_else.5950	# 891 
	nop	# 891 
	jr	0(%x1)	# 891 
	nop	# 891 
beq_else.5950:	# 891 
	sw	%x4 0(%x2)	# 893 
	sw	%x6 4(%x2)	# 893 
	sw	%x17 8(%x2)	# 893 
	sw	%x14 12(%x2)	# 893 
	sw	%x16 16(%x2)	# 893 
	sw	%x7 20(%x2)	# 893 
	sw	%x19 24(%x2)	# 893 
	sw	%x18 28(%x2)	# 893 
	sw	%x9 32(%x2)	# 893 
	sw	%x8 36(%x2)	# 893 
	sw	%x10 40(%x2)	# 893 
	sw	%x11 44(%x2)	# 893 
	sw	%x15 48(%x2)	# 893 
	sw	%x13 52(%x2)	# 893 
	sw	%x20 56(%x2)	# 893 
	add	%x7 %x0 %x8	# 893 
	add	%x6 %x0 %x20	# 893 
	add	%x4 %x0 %x12	# 893 
	add	%x8 %x0 %x9	# 893 
	sw	%x1 60(%x2)	# 893 
	lw	%x5 0(%x4)	# 893 
	addi	%x2 %x2 64	# 893 
	jalr	%x1 %x5	# 893 
	addi	%x2 %x2 -64	# 893 
	lw	%x1 60(%x2)	# 893 
	addi	%x5 %x0 0	# 894 
	bne	%x6 %x5 beq_else.5952	# 894 
	nop	# 894 
	lw	%x6 56(%x2)	# 923 
	sll	%x6 %x6 2	# 923 
	lw	%x7 52(%x2)	# 923 
	lw	%x6 %x6(%x7)	# 923 
	sw	%x1 60(%x2)	# 923 
	addi	%x2 %x2 64	# 923 
	jal	 %x1 o_isinvert.1772	# 923 
	addi	%x2 %x2 -64	# 923 
	lw	%x1 60(%x2)	# 923 
	addi	%x5 %x0 0	# 923 
	bne	%x6 %x5 beq_else.5954	# 923 
	nop	# 923 
	addi	%x6 %x0 1	# 923 
	lw	%x7 48(%x2)	# 923 
	sw	%x6 0(%x7)	# 923 
	j	beq_cont.5955	# 923 
	nop	# 923 
beq_else.5954:	# 923 
beq_cont.5955:	# 923 
	j	beq_cont.5953	# 894 
	nop	# 894 
beq_else.5952:	# 894 
	lw	%x7 44(%x2)	# 898 
	flw	%f1 (0)%x7	# 898 
	addi	%x7 %x0 l.4296	# 899 
	flw	%f2 (0)%x7	# 899 
	fblt	%f1 %f2 fblt.5956	# 899 
	nop	# 899 
	lw	%x7 40(%x2)	# 900 
	flw	%f2 (0)%x7	# 900 
	fblt	%f2 %f1 fblt.5958	# 900 
	nop	# 900 
	addi	%x8 %x0 l.4280	# 902 
	flw	%f2 (0)%x8	# 902 
	fadd	%f1 %f1 %f2	# 902 
	lw	%x8 36(%x2)	# 903 
	flw	%f2 (0)%x8	# 903 
	fmul	%f2 %f2 %f1	# 903 
	lw	%x9 32(%x2)	# 903 
	flw	%f3 (0)%x9	# 903 
	fadd	%f2 %f2 %f3	# 903 
	lw	%x10 28(%x2)	# 903 
	fsw	%f2 (0)%x10	# 903 

	flw	%f2 (4)%x8	# 904 
	fmul	%f2 %f2 %f1	# 904 
	flw	%f3 (4)%x9	# 904 
	fadd	%f2 %f2 %f3	# 904 
	fsw	%f2 (4)%x10	# 904 

	flw	%f2 (8)%x8	# 905 
	fmul	%f2 %f2 %f1	# 905 
	flw	%f3 (8)%x9	# 905 
	fadd	%f2 %f2 %f3	# 905 
	fsw	%f2 (8)%x10	# 905 

	addi	%x8 %x0 0	# 906 
	lw	%x9 20(%x2)	# 906 
	lw	%x4 24(%x2)	# 906 
	sw	%x6 60(%x2)	# 906 
	fsw	%f1 64(%x2)	# 906 
	add	%x7 %x0 %x9	# 906 
	add	%x6 %x0 %x8	# 906 
	sw	%x1 68(%x2)	# 906 
	lw	%x5 0(%x4)	# 906 
	addi	%x2 %x2 72	# 906 
	jalr	%x1 %x5	# 906 
	addi	%x2 %x2 -72	# 906 
	lw	%x1 68(%x2)	# 906 
	addi	%x5 %x0 0	# 906 
	bne	%x6 %x5 beq_else.5960	# 906 
	nop	# 906 
	j	beq_cont.5961	# 906 
	nop	# 906 
beq_else.5960:	# 906 
	lw	%x6 40(%x2)	# 908 
	flw	%f1 64(%x2)	# 908 
	fsw	%f1 (0)%x6	# 908 

	lw	%x6 28(%x2)	# 909 
	flw	%f1 (0)%x6	# 909 
	lw	%x7 16(%x2)	# 909 
	fsw	%f1 (0)%x7	# 909 

	flw	%f1 (4)%x6	# 910 
	fsw	%f1 (4)%x7	# 910 

	flw	%f1 (8)%x6	# 911 
	fsw	%f1 (8)%x7	# 911 

	lw	%x6 12(%x2)	# 912 
	lw	%x7 60(%x2)	# 912 
	sw	%x7 0(%x6)	# 912 
	lw	%x6 8(%x2)	# 913 
	lw	%x7 56(%x2)	# 913 
	sw	%x7 0(%x6)	# 913 
beq_cont.5961:	# 906 
	j	fblt_cont.5959	# 900 
	nop	# 900 
fblt.5958:	# 900 
fblt_cont.5959:	# 900 
	j	fblt_cont.5957	# 899 
	nop	# 899 
fblt.5956:	# 899 
fblt_cont.5957:	# 899 
beq_cont.5953:	# 894 
	lw	%x6 48(%x2)	# 925 
	lw	%x6 0(%x6)	# 925 
	addi	%x5 %x0 0	# 925 
	bne	%x6 %x5 beq_else.5962	# 925 
	nop	# 925 
	lw	%x6 4(%x2)	# 926 
	addi	%x6 %x6 1	# 926 
	lw	%x7 20(%x2)	# 926 
	lw	%x4 0(%x2)	# 926 
	lw	%x5 0(%x4)	# 926 
	jr	0(%x5)	# 926 
	nop	# 926 
beq_else.5962:	# 925 
	jr	0(%x1)	# 927 
	nop	# 927 
solve_one_or_network.1878:
	lw	%x8 12(%x4)	# 934 
	lw	%x9 8(%x4)	# 934 
	lw	%x10 4(%x4)	# 934 
	sll	%x11 %x6 2	# 934 
	lw	%x11 %x11(%x7)	# 934 
	addi	%x5 %x0 -1	# 935 
	bne	%x11 %x5 beq_else.5964	# 935 
	nop	# 935 
	jr	0(%x1)	# 935 
	nop	# 935 
beq_else.5964:	# 935 
	sll	%x11 %x11 2	# 936 
	lw	%x10 %x11(%x10)	# 936 
	addi	%x11 %x0 0	# 937 
	sw	%x11 0(%x9)	# 937 
	addi	%x9 %x0 0	# 938 
	sw	%x7 0(%x2)	# 938 
	sw	%x4 4(%x2)	# 938 
	sw	%x6 8(%x2)	# 938 
	add	%x7 %x0 %x10	# 938 
	add	%x6 %x0 %x9	# 938 
	add	%x4 %x0 %x8	# 938 
	sw	%x1 12(%x2)	# 938 
	lw	%x5 0(%x4)	# 938 
	addi	%x2 %x2 16	# 938 
	jalr	%x1 %x5	# 938 
	addi	%x2 %x2 -16	# 938 
	lw	%x1 12(%x2)	# 938 
	lw	%x6 8(%x2)	# 939 
	addi	%x6 %x6 1	# 939 
	lw	%x7 0(%x2)	# 939 
	lw	%x4 4(%x2)	# 939 
	lw	%x5 0(%x4)	# 939 
	jr	0(%x5)	# 939 
	nop	# 939 
trace_or_matrix.1881:
	lw	%x8 24(%x4)	# 946 
	lw	%x9 20(%x4)	# 946 
	lw	%x10 16(%x4)	# 946 
	lw	%x11 12(%x4)	# 946 
	lw	%x12 8(%x4)	# 946 
	lw	%x13 4(%x4)	# 946 
	sll	%x14 %x6 2	# 946 
	lw	%x14 %x14(%x7)	# 946 
	lw	%x15 0(%x14)	# 947 
	addi	%x5 %x0 -1	# 948 
	bne	%x15 %x5 beq_else.5966	# 948 
	nop	# 948 
	jr	0(%x1)	# 949 
	nop	# 949 
beq_else.5966:	# 948 
	sw	%x7 0(%x2)	# 951 
	sw	%x4 4(%x2)	# 951 
	sw	%x6 8(%x2)	# 951 
	addi	%x5 %x0 99	# 951 
	bne	%x15 %x5 beq_else.5968	# 951 
	nop	# 951 
	addi	%x8 %x0 1	# 952 
	add	%x7 %x0 %x14	# 952 
	add	%x6 %x0 %x8	# 952 
	add	%x4 %x0 %x13	# 952 
	sw	%x1 12(%x2)	# 952 
	lw	%x5 0(%x4)	# 952 
	addi	%x2 %x2 16	# 952 
	jalr	%x1 %x5	# 952 
	addi	%x2 %x2 -16	# 952 
	lw	%x1 12(%x2)	# 952 
	j	beq_cont.5969	# 951 
	nop	# 951 
beq_else.5968:	# 951 
	sw	%x14 12(%x2)	# 956 
	sw	%x13 16(%x2)	# 956 
	sw	%x10 20(%x2)	# 956 
	sw	%x11 24(%x2)	# 956 
	add	%x7 %x0 %x8	# 956 
	add	%x6 %x0 %x15	# 956 
	add	%x4 %x0 %x12	# 956 
	add	%x8 %x0 %x9	# 956 
	sw	%x1 28(%x2)	# 956 
	lw	%x5 0(%x4)	# 956 
	addi	%x2 %x2 32	# 956 
	jalr	%x1 %x5	# 956 
	addi	%x2 %x2 -32	# 956 
	lw	%x1 28(%x2)	# 956 
	addi	%x5 %x0 0	# 957 
	bne	%x6 %x5 beq_else.5970	# 957 
	nop	# 957 
	j	beq_cont.5971	# 957 
	nop	# 957 
beq_else.5970:	# 957 
	lw	%x6 24(%x2)	# 958 
	flw	%f1 (0)%x6	# 958 
	lw	%x6 20(%x2)	# 959 
	flw	%f2 (0)%x6	# 959 
	fblt	%f2 %f1 fblt.5972	# 959 
	nop	# 959 
	addi	%x6 %x0 1	# 960 
	lw	%x7 12(%x2)	# 960 
	lw	%x4 16(%x2)	# 960 
	sw	%x1 28(%x2)	# 960 
	lw	%x5 0(%x4)	# 960 
	addi	%x2 %x2 32	# 960 
	jalr	%x1 %x5	# 960 
	addi	%x2 %x2 -32	# 960 
	lw	%x1 28(%x2)	# 960 
	j	fblt_cont.5973	# 959 
	nop	# 959 
fblt.5972:	# 959 
fblt_cont.5973:	# 959 
beq_cont.5971:	# 957 
beq_cont.5969:	# 951 
	lw	%x6 8(%x2)	# 964 
	addi	%x6 %x6 1	# 964 
	lw	%x7 0(%x2)	# 964 
	lw	%x4 4(%x2)	# 964 
	lw	%x5 0(%x4)	# 964 
	jr	0(%x5)	# 964 
	nop	# 964 
tracer.1884:
	lw	%x6 12(%x4)	# 975 
	lw	%x7 8(%x4)	# 975 
	lw	%x8 4(%x4)	# 975 
	addi	%x9 %x0 l.4332	# 975 
	flw	%f1 (0)%x9	# 975 
	fsw	%f1 (0)%x7	# 975 

	addi	%x9 %x0 0	# 976 
	lw	%x8 0(%x8)	# 976 
	sw	%x7 0(%x2)	# 976 
	add	%x7 %x0 %x8	# 976 
	add	%x4 %x0 %x6	# 976 
	add	%x6 %x0 %x9	# 976 
	sw	%x1 4(%x2)	# 976 
	lw	%x5 0(%x4)	# 976 
	addi	%x2 %x2 8	# 976 
	jalr	%x1 %x5	# 976 
	addi	%x2 %x2 -8	# 976 
	lw	%x1 4(%x2)	# 976 
	lw	%x6 0(%x2)	# 977 
	flw	%f1 (0)%x6	# 977 
	addi	%x6 %x0 l.4296	# 978 
	flw	%f2 (0)%x6	# 978 
	fle	%f1 %f2 fle.5974	# 978 
	nop	# 978 
	addi	%x6 %x0 l.4338	# 979 
	flw	%f2 (0)%x6	# 979 
	fle	%f2 %f1 fle.5975	# 979 
	nop	# 979 
	addi	%x6 %x0 1	# 980 
	jr	0(%x1)	# 980 
	nop	# 980 
fle.5975:	# 979 
	addi	%x6 %x0 0	# 981 
	jr	0(%x1)	# 981 
	nop	# 981 
fle.5974:	# 978 
	addi	%x6 %x0 0	# 982 
	jr	0(%x1)	# 982 
	nop	# 982 
get_nvector_rect.1887:
	lw	%x6 12(%x4)	# 996 
	lw	%x7 8(%x4)	# 996 
	lw	%x8 4(%x4)	# 996 
	lw	%x8 0(%x8)	# 996 
	addi	%x5 %x0 1	# 998 
	bne	%x8 %x5 beq_else.5976	# 998 
	nop	# 998 
	flw	%f1 (0)%x6	# 1000 
	sw	%x7 0(%x2)	# 1000 
	sw	%x1 4(%x2)	# 1000 
	addi	%x2 %x2 8	# 1000 
	jal	 %x1 sgn.1807	# 1000 
	addi	%x2 %x2 -8	# 1000 
	lw	%x1 4(%x2)	# 1000 
	fneg	%f1 %f1	# 1000 
	lw	%x6 0(%x2)	# 1000 
	fsw	%f1 (0)%x6	# 1000 

	addi	%x7 %x0 l.3996	# 1001 
	flw	%f1 (0)%x7	# 1001 
	fsw	%f1 (4)%x6	# 1001 

	addi	%x7 %x0 l.3996	# 1002 
	flw	%f1 (0)%x7	# 1002 
	fsw	%f1 (8)%x6	# 1002 

	jr	0(%x1)	# 1002 
	nop	# 1002 
beq_else.5976:	# 998 
	addi	%x5 %x0 2	# 1004 
	bne	%x8 %x5 beq_else.5978	# 1004 
	nop	# 1004 
	addi	%x8 %x0 l.3996	# 1006 
	flw	%f1 (0)%x8	# 1006 
	fsw	%f1 (0)%x7	# 1006 

	flw	%f1 (4)%x6	# 1007 
	sw	%x7 0(%x2)	# 1007 
	sw	%x1 4(%x2)	# 1007 
	addi	%x2 %x2 8	# 1007 
	jal	 %x1 sgn.1807	# 1007 
	addi	%x2 %x2 -8	# 1007 
	lw	%x1 4(%x2)	# 1007 
	fneg	%f1 %f1	# 1007 
	lw	%x6 0(%x2)	# 1007 
	fsw	%f1 (4)%x6	# 1007 

	addi	%x7 %x0 l.3996	# 1008 
	flw	%f1 (0)%x7	# 1008 
	fsw	%f1 (8)%x6	# 1008 

	jr	0(%x1)	# 1008 
	nop	# 1008 
beq_else.5978:	# 1004 
	addi	%x5 %x0 3	# 1010 
	bne	%x8 %x5 beq_else.5980	# 1010 
	nop	# 1010 
	addi	%x8 %x0 l.3996	# 1012 
	flw	%f1 (0)%x8	# 1012 
	fsw	%f1 (0)%x7	# 1012 

	addi	%x8 %x0 l.3996	# 1013 
	flw	%f1 (0)%x8	# 1013 
	fsw	%f1 (4)%x7	# 1013 

	flw	%f1 (8)%x6	# 1014 
	sw	%x7 0(%x2)	# 1014 
	sw	%x1 4(%x2)	# 1014 
	addi	%x2 %x2 8	# 1014 
	jal	 %x1 sgn.1807	# 1014 
	addi	%x2 %x2 -8	# 1014 
	lw	%x1 4(%x2)	# 1014 
	fneg	%f1 %f1	# 1014 
	lw	%x6 0(%x2)	# 1014 
	fsw	%f1 (8)%x6	# 1014 

	jr	0(%x1)	# 1014 
	nop	# 1014 
beq_else.5980:	# 1010 
	jr	0(%x1)	# 1016 
	nop	# 1016 
get_nvector_plane.1889:
	lw	%x7 4(%x4)	# 1022 
	sw	%x6 0(%x2)	# 1022 
	sw	%x7 4(%x2)	# 1022 
	sw	%x1 12(%x2)	# 1022 
	addi	%x2 %x2 16	# 1022 
	jal	 %x1 o_param_a.1776	# 1022 
	addi	%x2 %x2 -16	# 1022 
	lw	%x1 12(%x2)	# 1022 
	fneg	%f1 %f1	# 1022 
	lw	%x6 4(%x2)	# 1022 
	fsw	%f1 (0)%x6	# 1022 

	lw	%x7 0(%x2)	# 1023 
	add	%x6 %x0 %x7	# 1023 
	sw	%x1 12(%x2)	# 1023 
	addi	%x2 %x2 16	# 1023 
	jal	 %x1 o_param_b.1778	# 1023 
	addi	%x2 %x2 -16	# 1023 
	lw	%x1 12(%x2)	# 1023 
	fneg	%f1 %f1	# 1023 
	lw	%x6 4(%x2)	# 1023 
	fsw	%f1 (4)%x6	# 1023 

	lw	%x7 0(%x2)	# 1024 
	add	%x6 %x0 %x7	# 1024 
	sw	%x1 12(%x2)	# 1024 
	addi	%x2 %x2 16	# 1024 
	jal	 %x1 o_param_c.1780	# 1024 
	addi	%x2 %x2 -16	# 1024 
	lw	%x1 12(%x2)	# 1024 
	fneg	%f1 %f1	# 1024 
	lw	%x6 4(%x2)	# 1024 
	fsw	%f1 (8)%x6	# 1024 

	jr	0(%x1)	# 1024 
	nop	# 1024 
get_nvector_second_norot.1891:
	lw	%x8 4(%x4)	# 1030 
	flw	%f1 (0)%x7	# 1030 
	sw	%x7 0(%x2)	# 1030 
	sw	%x8 4(%x2)	# 1030 
	sw	%x6 8(%x2)	# 1030 
	fsw	%f1 12(%x2)	# 1030 
	sw	%x1 20(%x2)	# 1030 
	addi	%x2 %x2 24	# 1030 
	jal	 %x1 o_param_x.1782	# 1030 
	addi	%x2 %x2 -24	# 1030 
	lw	%x1 20(%x2)	# 1030 
	flw	%f2 12(%x2)	# 1030 
	fsub	%f1 %f2 %f1	# 1030 
	lw	%x6 8(%x2)	# 1030 
	fsw	%f1 16(%x2)	# 1030 
	sw	%x1 20(%x2)	# 1030 
	addi	%x2 %x2 24	# 1030 
	jal	 %x1 o_param_a.1776	# 1030 
	addi	%x2 %x2 -24	# 1030 
	lw	%x1 20(%x2)	# 1030 
	flw	%f2 16(%x2)	# 1030 
	fmul	%f1 %f2 %f1	# 1030 
	lw	%x6 4(%x2)	# 1030 
	fsw	%f1 (0)%x6	# 1030 

	lw	%x7 0(%x2)	# 1031 
	flw	%f1 (4)%x7	# 1031 
	lw	%x8 8(%x2)	# 1031 
	fsw	%f1 20(%x2)	# 1031 
	add	%x6 %x0 %x8	# 1031 
	sw	%x1 28(%x2)	# 1031 
	addi	%x2 %x2 32	# 1031 
	jal	 %x1 o_param_y.1784	# 1031 
	addi	%x2 %x2 -32	# 1031 
	lw	%x1 28(%x2)	# 1031 
	flw	%f2 20(%x2)	# 1031 
	fsub	%f1 %f2 %f1	# 1031 
	lw	%x6 8(%x2)	# 1031 
	fsw	%f1 24(%x2)	# 1031 
	sw	%x1 28(%x2)	# 1031 
	addi	%x2 %x2 32	# 1031 
	jal	 %x1 o_param_b.1778	# 1031 
	addi	%x2 %x2 -32	# 1031 
	lw	%x1 28(%x2)	# 1031 
	flw	%f2 24(%x2)	# 1031 
	fmul	%f1 %f2 %f1	# 1031 
	lw	%x6 4(%x2)	# 1031 
	fsw	%f1 (4)%x6	# 1031 

	lw	%x7 0(%x2)	# 1032 
	flw	%f1 (8)%x7	# 1032 
	lw	%x7 8(%x2)	# 1032 
	fsw	%f1 28(%x2)	# 1032 
	add	%x6 %x0 %x7	# 1032 
	sw	%x1 36(%x2)	# 1032 
	addi	%x2 %x2 40	# 1032 
	jal	 %x1 o_param_z.1786	# 1032 
	addi	%x2 %x2 -40	# 1032 
	lw	%x1 36(%x2)	# 1032 
	flw	%f2 28(%x2)	# 1032 
	fsub	%f1 %f2 %f1	# 1032 
	lw	%x6 8(%x2)	# 1032 
	fsw	%f1 32(%x2)	# 1032 
	sw	%x1 36(%x2)	# 1032 
	addi	%x2 %x2 40	# 1032 
	jal	 %x1 o_param_c.1780	# 1032 
	addi	%x2 %x2 -40	# 1032 
	lw	%x1 36(%x2)	# 1032 
	flw	%f2 32(%x2)	# 1032 
	fmul	%f1 %f2 %f1	# 1032 
	lw	%x6 4(%x2)	# 1032 
	fsw	%f1 (8)%x6	# 1032 

	lw	%x7 8(%x2)	# 1033 
	add	%x6 %x0 %x7	# 1033 
	sw	%x1 36(%x2)	# 1033 
	addi	%x2 %x2 40	# 1033 
	jal	 %x1 o_isinvert.1772	# 1033 
	addi	%x2 %x2 -40	# 1033 
	lw	%x1 36(%x2)	# 1033 
	add	%x7 %x0 %x6	# 1033 
	lw	%x6 4(%x2)	# 1033 
	j	normalize_vector.1804	# 1033 
	nop	# 1033 
get_nvector_second_rot.1894:
	lw	%x8 8(%x4)	# 1038 
	lw	%x9 4(%x4)	# 1038 
	flw	%f1 (0)%x7	# 1038 
	sw	%x9 0(%x2)	# 1038 
	sw	%x6 4(%x2)	# 1038 
	sw	%x7 8(%x2)	# 1038 
	sw	%x8 12(%x2)	# 1038 
	fsw	%f1 16(%x2)	# 1038 
	sw	%x1 20(%x2)	# 1038 
	addi	%x2 %x2 24	# 1038 
	jal	 %x1 o_param_x.1782	# 1038 
	addi	%x2 %x2 -24	# 1038 
	lw	%x1 20(%x2)	# 1038 
	flw	%f2 16(%x2)	# 1038 
	fsub	%f1 %f2 %f1	# 1038 
	lw	%x6 12(%x2)	# 1038 
	fsw	%f1 (0)%x6	# 1038 

	lw	%x7 8(%x2)	# 1039 
	flw	%f1 (4)%x7	# 1039 
	lw	%x8 4(%x2)	# 1039 
	fsw	%f1 20(%x2)	# 1039 
	add	%x6 %x0 %x8	# 1039 
	sw	%x1 28(%x2)	# 1039 
	addi	%x2 %x2 32	# 1039 
	jal	 %x1 o_param_y.1784	# 1039 
	addi	%x2 %x2 -32	# 1039 
	lw	%x1 28(%x2)	# 1039 
	flw	%f2 20(%x2)	# 1039 
	fsub	%f1 %f2 %f1	# 1039 
	lw	%x6 12(%x2)	# 1039 
	fsw	%f1 (4)%x6	# 1039 

	lw	%x7 8(%x2)	# 1040 
	flw	%f1 (8)%x7	# 1040 
	lw	%x7 4(%x2)	# 1040 
	fsw	%f1 24(%x2)	# 1040 
	add	%x6 %x0 %x7	# 1040 
	sw	%x1 28(%x2)	# 1040 
	addi	%x2 %x2 32	# 1040 
	jal	 %x1 o_param_z.1786	# 1040 
	addi	%x2 %x2 -32	# 1040 
	lw	%x1 28(%x2)	# 1040 
	flw	%f2 24(%x2)	# 1040 
	fsub	%f1 %f2 %f1	# 1040 
	lw	%x6 12(%x2)	# 1040 
	fsw	%f1 (8)%x6	# 1040 

	flw	%f1 (0)%x6	# 1041 
	lw	%x7 4(%x2)	# 1041 
	fsw	%f1 28(%x2)	# 1041 
	add	%x6 %x0 %x7	# 1041 
	sw	%x1 36(%x2)	# 1041 
	addi	%x2 %x2 40	# 1041 
	jal	 %x1 o_param_a.1776	# 1041 
	addi	%x2 %x2 -40	# 1041 
	lw	%x1 36(%x2)	# 1041 
	flw	%f2 28(%x2)	# 1041 
	fmul	%f1 %f2 %f1	# 1041 
	lw	%x6 12(%x2)	# 1042 
	flw	%f2 (4)%x6	# 1042 
	lw	%x7 4(%x2)	# 1042 
	fsw	%f1 32(%x2)	# 1042 
	fsw	%f2 36(%x2)	# 1042 
	add	%x6 %x0 %x7	# 1042 
	sw	%x1 44(%x2)	# 1042 
	addi	%x2 %x2 48	# 1042 
	jal	 %x1 o_param_r3.1802	# 1042 
	addi	%x2 %x2 -48	# 1042 
	lw	%x1 44(%x2)	# 1042 
	flw	%f2 36(%x2)	# 1042 
	fmul	%f1 %f2 %f1	# 1042 
	lw	%x6 12(%x2)	# 1043 
	flw	%f2 (8)%x6	# 1043 
	lw	%x7 4(%x2)	# 1043 
	fsw	%f1 40(%x2)	# 1043 
	fsw	%f2 44(%x2)	# 1043 
	add	%x6 %x0 %x7	# 1043 
	sw	%x1 52(%x2)	# 1043 
	addi	%x2 %x2 56	# 1043 
	jal	 %x1 o_param_r2.1800	# 1043 
	addi	%x2 %x2 -56	# 1043 
	lw	%x1 52(%x2)	# 1043 
	flw	%f2 44(%x2)	# 1043 
	fmul	%f1 %f2 %f1	# 1043 
	flw	%f2 40(%x2)	# 1042 
	fadd	%f1 %f2 %f1	# 1042 
	sw	%x1 52(%x2)	# 1042 
	addi	%x2 %x2 56	# 1042 
	jal	 %x1 fhalf.1764	# 1042 
	addi	%x2 %x2 -56	# 1042 
	lw	%x1 52(%x2)	# 1042 
	flw	%f2 32(%x2)	# 1041 
	fadd	%f1 %f2 %f1	# 1041 
	lw	%x6 0(%x2)	# 1041 
	fsw	%f1 (0)%x6	# 1041 

	lw	%x7 12(%x2)	# 1044 
	flw	%f1 (4)%x7	# 1044 
	lw	%x8 4(%x2)	# 1044 
	fsw	%f1 48(%x2)	# 1044 
	add	%x6 %x0 %x8	# 1044 
	sw	%x1 52(%x2)	# 1044 
	addi	%x2 %x2 56	# 1044 
	jal	 %x1 o_param_b.1778	# 1044 
	addi	%x2 %x2 -56	# 1044 
	lw	%x1 52(%x2)	# 1044 
	flw	%f2 48(%x2)	# 1044 
	fmul	%f1 %f2 %f1	# 1044 
	lw	%x6 12(%x2)	# 1045 
	flw	%f2 (0)%x6	# 1045 
	lw	%x7 4(%x2)	# 1045 
	fsw	%f1 52(%x2)	# 1045 
	fsw	%f2 56(%x2)	# 1045 
	add	%x6 %x0 %x7	# 1045 
	sw	%x1 60(%x2)	# 1045 
	addi	%x2 %x2 64	# 1045 
	jal	 %x1 o_param_r3.1802	# 1045 
	addi	%x2 %x2 -64	# 1045 
	lw	%x1 60(%x2)	# 1045 
	flw	%f2 56(%x2)	# 1045 
	fmul	%f1 %f2 %f1	# 1045 
	lw	%x6 12(%x2)	# 1046 
	flw	%f2 (8)%x6	# 1046 
	lw	%x7 4(%x2)	# 1046 
	fsw	%f1 60(%x2)	# 1046 
	fsw	%f2 64(%x2)	# 1046 
	add	%x6 %x0 %x7	# 1046 
	sw	%x1 68(%x2)	# 1046 
	addi	%x2 %x2 72	# 1046 
	jal	 %x1 o_param_r1.1798	# 1046 
	addi	%x2 %x2 -72	# 1046 
	lw	%x1 68(%x2)	# 1046 
	flw	%f2 64(%x2)	# 1046 
	fmul	%f1 %f2 %f1	# 1046 
	flw	%f2 60(%x2)	# 1045 
	fadd	%f1 %f2 %f1	# 1045 
	sw	%x1 68(%x2)	# 1045 
	addi	%x2 %x2 72	# 1045 
	jal	 %x1 fhalf.1764	# 1045 
	addi	%x2 %x2 -72	# 1045 
	lw	%x1 68(%x2)	# 1045 
	flw	%f2 52(%x2)	# 1044 
	fadd	%f1 %f2 %f1	# 1044 
	lw	%x6 0(%x2)	# 1044 
	fsw	%f1 (4)%x6	# 1044 

	lw	%x7 12(%x2)	# 1047 
	flw	%f1 (8)%x7	# 1047 
	lw	%x8 4(%x2)	# 1047 
	fsw	%f1 68(%x2)	# 1047 
	add	%x6 %x0 %x8	# 1047 
	sw	%x1 76(%x2)	# 1047 
	addi	%x2 %x2 80	# 1047 
	jal	 %x1 o_param_c.1780	# 1047 
	addi	%x2 %x2 -80	# 1047 
	lw	%x1 76(%x2)	# 1047 
	flw	%f2 68(%x2)	# 1047 
	fmul	%f1 %f2 %f1	# 1047 
	lw	%x6 12(%x2)	# 1048 
	flw	%f2 (0)%x6	# 1048 
	lw	%x7 4(%x2)	# 1048 
	fsw	%f1 72(%x2)	# 1048 
	fsw	%f2 76(%x2)	# 1048 
	add	%x6 %x0 %x7	# 1048 
	sw	%x1 84(%x2)	# 1048 
	addi	%x2 %x2 88	# 1048 
	jal	 %x1 o_param_r2.1800	# 1048 
	addi	%x2 %x2 -88	# 1048 
	lw	%x1 84(%x2)	# 1048 
	flw	%f2 76(%x2)	# 1048 
	fmul	%f1 %f2 %f1	# 1048 
	lw	%x6 12(%x2)	# 1049 
	flw	%f2 (4)%x6	# 1049 
	lw	%x6 4(%x2)	# 1049 
	fsw	%f1 80(%x2)	# 1049 
	fsw	%f2 84(%x2)	# 1049 
	sw	%x1 92(%x2)	# 1049 
	addi	%x2 %x2 96	# 1049 
	jal	 %x1 o_param_r1.1798	# 1049 
	addi	%x2 %x2 -96	# 1049 
	lw	%x1 92(%x2)	# 1049 
	flw	%f2 84(%x2)	# 1049 
	fmul	%f1 %f2 %f1	# 1049 
	flw	%f2 80(%x2)	# 1048 
	fadd	%f1 %f2 %f1	# 1048 
	sw	%x1 92(%x2)	# 1048 
	addi	%x2 %x2 96	# 1048 
	jal	 %x1 fhalf.1764	# 1048 
	addi	%x2 %x2 -96	# 1048 
	lw	%x1 92(%x2)	# 1048 
	flw	%f2 72(%x2)	# 1047 
	fadd	%f1 %f2 %f1	# 1047 
	lw	%x6 0(%x2)	# 1047 
	fsw	%f1 (8)%x6	# 1047 

	lw	%x7 4(%x2)	# 1050 
	add	%x6 %x0 %x7	# 1050 
	sw	%x1 92(%x2)	# 1050 
	addi	%x2 %x2 96	# 1050 
	jal	 %x1 o_isinvert.1772	# 1050 
	addi	%x2 %x2 -96	# 1050 
	lw	%x1 92(%x2)	# 1050 
	add	%x7 %x0 %x6	# 1050 
	lw	%x6 0(%x2)	# 1050 
	j	normalize_vector.1804	# 1050 
	nop	# 1050 
get_nvector.1897:
	lw	%x8 16(%x4)	# 1055 
	lw	%x9 12(%x4)	# 1055 
	lw	%x10 8(%x4)	# 1055 
	lw	%x11 4(%x4)	# 1055 
	sw	%x8 0(%x2)	# 1055 
	sw	%x7 4(%x2)	# 1055 
	sw	%x9 8(%x2)	# 1055 
	sw	%x6 12(%x2)	# 1055 
	sw	%x11 16(%x2)	# 1055 
	sw	%x10 20(%x2)	# 1055 
	sw	%x1 28(%x2)	# 1055 
	addi	%x2 %x2 32	# 1055 
	jal	 %x1 o_form.1768	# 1055 
	addi	%x2 %x2 -32	# 1055 
	lw	%x1 28(%x2)	# 1055 
	addi	%x5 %x0 1	# 1056 
	bne	%x6 %x5 beq_else.5984	# 1056 
	nop	# 1056 
	lw	%x4 20(%x2)	# 1057 
	lw	%x5 0(%x4)	# 1057 
	jr	0(%x5)	# 1057 
	nop	# 1057 
beq_else.5984:	# 1056 
	addi	%x5 %x0 2	# 1058 
	bne	%x6 %x5 beq_else.5985	# 1058 
	nop	# 1058 
	lw	%x6 12(%x2)	# 1059 
	lw	%x4 16(%x2)	# 1059 
	lw	%x5 0(%x4)	# 1059 
	jr	0(%x5)	# 1059 
	nop	# 1059 
beq_else.5985:	# 1058 
	lw	%x6 12(%x2)	# 1061 
	sw	%x1 28(%x2)	# 1061 
	addi	%x2 %x2 32	# 1061 
	jal	 %x1 o_isrot.1774	# 1061 
	addi	%x2 %x2 -32	# 1061 
	lw	%x1 28(%x2)	# 1061 
	addi	%x5 %x0 0	# 1061 
	bne	%x6 %x5 beq_else.5986	# 1061 
	nop	# 1061 
	lw	%x6 12(%x2)	# 1064 
	lw	%x7 4(%x2)	# 1064 
	lw	%x4 8(%x2)	# 1064 
	lw	%x5 0(%x4)	# 1064 
	jr	0(%x5)	# 1064 
	nop	# 1064 
beq_else.5986:	# 1061 
	lw	%x6 12(%x2)	# 1062 
	lw	%x7 4(%x2)	# 1062 
	lw	%x4 0(%x2)	# 1062 
	lw	%x5 0(%x4)	# 1062 
	jr	0(%x5)	# 1062 
	nop	# 1062 
utexture.1900:
	lw	%x8 4(%x4)	# 1071 
	sw	%x7 0(%x2)	# 1071 
	sw	%x8 4(%x2)	# 1071 
	sw	%x6 8(%x2)	# 1071 
	sw	%x1 12(%x2)	# 1071 
	addi	%x2 %x2 16	# 1071 
	jal	 %x1 o_texturetype.1766	# 1071 
	addi	%x2 %x2 -16	# 1071 
	lw	%x1 12(%x2)	# 1071 
	lw	%x7 8(%x2)	# 1073 
	sw	%x6 12(%x2)	# 1073 
	add	%x6 %x0 %x7	# 1073 
	sw	%x1 20(%x2)	# 1073 
	addi	%x2 %x2 24	# 1073 
	jal	 %x1 o_color_red.1792	# 1073 
	addi	%x2 %x2 -24	# 1073 
	lw	%x1 20(%x2)	# 1073 
	lw	%x6 4(%x2)	# 1073 
	fsw	%f1 (0)%x6	# 1073 

	lw	%x7 8(%x2)	# 1074 
	add	%x6 %x0 %x7	# 1074 
	sw	%x1 20(%x2)	# 1074 
	addi	%x2 %x2 24	# 1074 
	jal	 %x1 o_color_green.1794	# 1074 
	addi	%x2 %x2 -24	# 1074 
	lw	%x1 20(%x2)	# 1074 
	lw	%x6 4(%x2)	# 1074 
	fsw	%f1 (4)%x6	# 1074 

	lw	%x7 8(%x2)	# 1075 
	add	%x6 %x0 %x7	# 1075 
	sw	%x1 20(%x2)	# 1075 
	addi	%x2 %x2 24	# 1075 
	jal	 %x1 o_color_blue.1796	# 1075 
	addi	%x2 %x2 -24	# 1075 
	lw	%x1 20(%x2)	# 1075 
	lw	%x6 4(%x2)	# 1075 
	fsw	%f1 (8)%x6	# 1075 

	lw	%x7 12(%x2)	# 1076 
	addi	%x5 %x0 1	# 1076 
	bne	%x7 %x5 beq_else.5987	# 1076 
	nop	# 1076 
	lw	%x7 0(%x2)	# 1079 
	flw	%f1 (0)%x7	# 1079 
	lw	%x8 8(%x2)	# 1079 
	fsw	%f1 16(%x2)	# 1079 
	add	%x6 %x0 %x8	# 1079 
	sw	%x1 20(%x2)	# 1079 
	addi	%x2 %x2 24	# 1079 
	jal	 %x1 o_param_x.1782	# 1079 
	addi	%x2 %x2 -24	# 1079 
	lw	%x1 20(%x2)	# 1079 
	flw	%f2 16(%x2)	# 1079 
	fsub	%f1 %f2 %f1	# 1079 
	addi	%x6 %x0 l.4432	# 1081 
	flw	%f2 (0)%x6	# 1081 
	fmul	%f2 %f1 %f2	# 1081 
	fsw	%f1 20(%x2)	# 1081 
	fadd	%f1 %f2 %f0	# 1081 
	sw	%x1 28(%x2)	# 1081 
	addi	%x2 %x2 32	# 1081 
	jal	 %x1 min_caml_floor	# 1081 
	addi	%x2 %x2 -32	# 1081 
	lw	%x1 28(%x2)	# 1081 
	addi	%x6 %x0 l.4434	# 1081 
	flw	%f2 (0)%x6	# 1081 
	fmul	%f1 %f1 %f2	# 1081 
	addi	%x6 %x0 l.4413	# 1082 
	flw	%f2 (0)%x6	# 1082 
	flw	%f3 20(%x2)	# 1082 
	fsub	%f1 %f3 %f1	# 1082 
	fblt	%f2 %f1 fblt.5988	# 1082 
	nop	# 1082 
	addi	%x6 %x0 1	# 1082 
	j	fblt_cont.5989	# 1082 
	nop	# 1082 
fblt.5988:	# 1082 
	addi	%x6 %x0 0	# 1082 
fblt_cont.5989:	# 1082 
	lw	%x7 0(%x2)	# 1084 
	flw	%f1 (8)%x7	# 1084 
	lw	%x7 8(%x2)	# 1084 
	sw	%x6 24(%x2)	# 1084 
	fsw	%f1 28(%x2)	# 1084 
	add	%x6 %x0 %x7	# 1084 
	sw	%x1 36(%x2)	# 1084 
	addi	%x2 %x2 40	# 1084 
	jal	 %x1 o_param_z.1786	# 1084 
	addi	%x2 %x2 -40	# 1084 
	lw	%x1 36(%x2)	# 1084 
	flw	%f2 28(%x2)	# 1084 
	fsub	%f1 %f2 %f1	# 1084 
	addi	%x6 %x0 l.4432	# 1086 
	flw	%f2 (0)%x6	# 1086 
	fmul	%f2 %f1 %f2	# 1086 
	fsw	%f1 32(%x2)	# 1086 
	fadd	%f1 %f2 %f0	# 1086 
	sw	%x1 36(%x2)	# 1086 
	addi	%x2 %x2 40	# 1086 
	jal	 %x1 min_caml_floor	# 1086 
	addi	%x2 %x2 -40	# 1086 
	lw	%x1 36(%x2)	# 1086 
	addi	%x6 %x0 l.4434	# 1086 
	flw	%f2 (0)%x6	# 1086 
	fmul	%f1 %f1 %f2	# 1086 
	addi	%x6 %x0 l.4413	# 1087 
	flw	%f2 (0)%x6	# 1087 
	flw	%f3 32(%x2)	# 1087 
	fsub	%f1 %f3 %f1	# 1087 
	fblt	%f2 %f1 fblt.5990	# 1087 
	nop	# 1087 
	addi	%x6 %x0 1	# 1087 
	j	fblt_cont.5991	# 1087 
	nop	# 1087 
fblt.5990:	# 1087 
	addi	%x6 %x0 0	# 1087 
fblt_cont.5991:	# 1087 
	lw	%x7 24(%x2)	# 1090 
	addi	%x5 %x0 0	# 1090 
	bne	%x7 %x5 beq_else.5992	# 1090 
	nop	# 1090 
	addi	%x5 %x0 0	# 1092 
	bne	%x6 %x5 beq_else.5994	# 1092 
	nop	# 1092 
	addi	%x6 %x0 l.4417	# 1092 
	flw	%f1 (0)%x6	# 1092 
	j	beq_cont.5995	# 1092 
	nop	# 1092 
beq_else.5994:	# 1092 
	addi	%x6 %x0 l.3996	# 1092 
	flw	%f1 (0)%x6	# 1092 
beq_cont.5995:	# 1092 
	j	beq_cont.5993	# 1090 
	nop	# 1090 
beq_else.5992:	# 1090 
	addi	%x5 %x0 0	# 1091 
	bne	%x6 %x5 beq_else.5996	# 1091 
	nop	# 1091 
	addi	%x6 %x0 l.3996	# 1091 
	flw	%f1 (0)%x6	# 1091 
	j	beq_cont.5997	# 1091 
	nop	# 1091 
beq_else.5996:	# 1091 
	addi	%x6 %x0 l.4417	# 1091 
	flw	%f1 (0)%x6	# 1091 
beq_cont.5997:	# 1091 
beq_cont.5993:	# 1090 
	lw	%x6 4(%x2)	# 1089 
	fsw	%f1 (4)%x6	# 1089 

	jr	0(%x1)	# 1089 
	nop	# 1089 
beq_else.5987:	# 1076 
	addi	%x5 %x0 2	# 1094 
	bne	%x7 %x5 beq_else.5999	# 1094 
	nop	# 1094 
	lw	%x7 0(%x2)	# 1097 
	flw	%f1 (4)%x7	# 1097 
	addi	%x7 %x0 l.4424	# 1097 
	flw	%f2 (0)%x7	# 1097 
	fmul	%f1 %f1 %f2	# 1097 
	sw	%x1 36(%x2)	# 1097 
	addi	%x2 %x2 40	# 1097 
	jal	 %x1 min_caml_sin	# 1097 
	addi	%x2 %x2 -40	# 1097 
	lw	%x1 36(%x2)	# 1097 
	sw	%x1 36(%x2)	# 1097 
	addi	%x2 %x2 40	# 1097 
	jal	 %x1 fsqr.1762	# 1097 
	addi	%x2 %x2 -40	# 1097 
	lw	%x1 36(%x2)	# 1097 
	addi	%x6 %x0 l.4417	# 1098 
	flw	%f2 (0)%x6	# 1098 
	fmul	%f2 %f2 %f1	# 1098 
	lw	%x6 4(%x2)	# 1098 
	fsw	%f2 (0)%x6	# 1098 

	addi	%x7 %x0 l.4417	# 1099 
	flw	%f2 (0)%x7	# 1099 
	addi	%x7 %x0 l.3998	# 1099 
	flw	%f3 (0)%x7	# 1099 
	fsub	%f1 %f3 %f1	# 1099 
	fmul	%f1 %f2 %f1	# 1099 
	fsw	%f1 (4)%x6	# 1099 

	jr	0(%x1)	# 1099 
	nop	# 1099 
beq_else.5999:	# 1094 
	addi	%x5 %x0 3	# 1101 
	bne	%x7 %x5 beq_else.6001	# 1101 
	nop	# 1101 
	lw	%x7 0(%x2)	# 1104 
	flw	%f1 (0)%x7	# 1104 
	lw	%x8 8(%x2)	# 1104 
	fsw	%f1 36(%x2)	# 1104 
	add	%x6 %x0 %x8	# 1104 
	sw	%x1 44(%x2)	# 1104 
	addi	%x2 %x2 48	# 1104 
	jal	 %x1 o_param_x.1782	# 1104 
	addi	%x2 %x2 -48	# 1104 
	lw	%x1 44(%x2)	# 1104 
	flw	%f2 36(%x2)	# 1104 
	fsub	%f1 %f2 %f1	# 1104 
	lw	%x6 0(%x2)	# 1105 
	flw	%f2 (8)%x6	# 1105 
	lw	%x6 8(%x2)	# 1105 
	fsw	%f1 40(%x2)	# 1105 
	fsw	%f2 44(%x2)	# 1105 
	sw	%x1 52(%x2)	# 1105 
	addi	%x2 %x2 56	# 1105 
	jal	 %x1 o_param_z.1786	# 1105 
	addi	%x2 %x2 -56	# 1105 
	lw	%x1 52(%x2)	# 1105 
	flw	%f2 44(%x2)	# 1105 
	fsub	%f1 %f2 %f1	# 1105 
	flw	%f2 40(%x2)	# 1106 
	fsw	%f1 48(%x2)	# 1106 
	fadd	%f1 %f2 %f0	# 1106 
	sw	%x1 52(%x2)	# 1106 
	addi	%x2 %x2 56	# 1106 
	jal	 %x1 fsqr.1762	# 1106 
	addi	%x2 %x2 -56	# 1106 
	lw	%x1 52(%x2)	# 1106 
	flw	%f2 48(%x2)	# 1106 
	fsw	%f1 52(%x2)	# 1106 
	fadd	%f1 %f2 %f0	# 1106 
	sw	%x1 60(%x2)	# 1106 
	addi	%x2 %x2 64	# 1106 
	jal	 %x1 fsqr.1762	# 1106 
	addi	%x2 %x2 -64	# 1106 
	lw	%x1 60(%x2)	# 1106 
	flw	%f2 52(%x2)	# 1106 
	fadd	%f1 %f2 %f1	# 1106 
	sw	%x1 60(%x2)	# 1106 
	addi	%x2 %x2 64	# 1106 
	jal	 %x1 min_caml_sqrt	# 1106 
	addi	%x2 %x2 -64	# 1106 
	lw	%x1 60(%x2)	# 1106 
	addi	%x6 %x0 l.4413	# 1106 
	flw	%f2 (0)%x6	# 1106 
	fdiv	%f1 %f1 %f2	# 1106 
	fsw	%f1 56(%x2)	# 1107 
	sw	%x1 60(%x2)	# 1107 
	addi	%x2 %x2 64	# 1107 
	jal	 %x1 min_caml_floor	# 1107 
	addi	%x2 %x2 -64	# 1107 
	lw	%x1 60(%x2)	# 1107 
	flw	%f2 56(%x2)	# 1107 
	fsub	%f1 %f2 %f1	# 1107 
	addi	%x6 %x0 l.4415	# 1107 
	flw	%f2 (0)%x6	# 1107 
	fmul	%f1 %f1 %f2	# 1107 
	sw	%x1 60(%x2)	# 1108 
	addi	%x2 %x2 64	# 1108 
	jal	 %x1 min_caml_cos	# 1108 
	addi	%x2 %x2 -64	# 1108 
	lw	%x1 60(%x2)	# 1108 
	sw	%x1 60(%x2)	# 1108 
	addi	%x2 %x2 64	# 1108 
	jal	 %x1 fsqr.1762	# 1108 
	addi	%x2 %x2 -64	# 1108 
	lw	%x1 60(%x2)	# 1108 
	addi	%x6 %x0 l.4417	# 1109 
	flw	%f2 (0)%x6	# 1109 
	fmul	%f2 %f1 %f2	# 1109 
	lw	%x6 4(%x2)	# 1109 
	fsw	%f2 (4)%x6	# 1109 

	addi	%x7 %x0 l.3998	# 1110 
	flw	%f2 (0)%x7	# 1110 
	fsub	%f1 %f2 %f1	# 1110 
	addi	%x7 %x0 l.4417	# 1110 
	flw	%f2 (0)%x7	# 1110 
	fmul	%f1 %f1 %f2	# 1110 
	fsw	%f1 (8)%x6	# 1110 

	jr	0(%x1)	# 1110 
	nop	# 1110 
beq_else.6001:	# 1101 
	addi	%x5 %x0 4	# 1112 
	bne	%x7 %x5 beq_else.6003	# 1112 
	nop	# 1112 
	lw	%x7 0(%x2)	# 1114 
	flw	%f1 (0)%x7	# 1114 
	lw	%x8 8(%x2)	# 1114 
	fsw	%f1 60(%x2)	# 1114 
	add	%x6 %x0 %x8	# 1114 
	sw	%x1 68(%x2)	# 1114 
	addi	%x2 %x2 72	# 1114 
	jal	 %x1 o_param_x.1782	# 1114 
	addi	%x2 %x2 -72	# 1114 
	lw	%x1 68(%x2)	# 1114 
	flw	%f2 60(%x2)	# 1114 
	fsub	%f1 %f2 %f1	# 1114 
	lw	%x6 8(%x2)	# 1114 
	fsw	%f1 64(%x2)	# 1114 
	sw	%x1 68(%x2)	# 1114 
	addi	%x2 %x2 72	# 1114 
	jal	 %x1 o_param_a.1776	# 1114 
	addi	%x2 %x2 -72	# 1114 
	lw	%x1 68(%x2)	# 1114 
	sw	%x1 68(%x2)	# 1114 
	addi	%x2 %x2 72	# 1114 
	jal	 %x1 min_caml_sqrt	# 1114 
	addi	%x2 %x2 -72	# 1114 
	lw	%x1 68(%x2)	# 1114 
	flw	%f2 64(%x2)	# 1114 
	fmul	%f1 %f2 %f1	# 1114 
	lw	%x6 0(%x2)	# 1115 
	flw	%f2 (8)%x6	# 1115 
	lw	%x7 8(%x2)	# 1115 
	fsw	%f1 68(%x2)	# 1115 
	fsw	%f2 72(%x2)	# 1115 
	add	%x6 %x0 %x7	# 1115 
	sw	%x1 76(%x2)	# 1115 
	addi	%x2 %x2 80	# 1115 
	jal	 %x1 o_param_z.1786	# 1115 
	addi	%x2 %x2 -80	# 1115 
	lw	%x1 76(%x2)	# 1115 
	flw	%f2 72(%x2)	# 1115 
	fsub	%f1 %f2 %f1	# 1115 
	lw	%x6 8(%x2)	# 1115 
	fsw	%f1 76(%x2)	# 1115 
	sw	%x1 84(%x2)	# 1115 
	addi	%x2 %x2 88	# 1115 
	jal	 %x1 o_param_c.1780	# 1115 
	addi	%x2 %x2 -88	# 1115 
	lw	%x1 84(%x2)	# 1115 
	sw	%x1 84(%x2)	# 1115 
	addi	%x2 %x2 88	# 1115 
	jal	 %x1 min_caml_sqrt	# 1115 
	addi	%x2 %x2 -88	# 1115 
	lw	%x1 84(%x2)	# 1115 
	flw	%f2 76(%x2)	# 1115 
	fmul	%f1 %f2 %f1	# 1115 
	flw	%f2 68(%x2)	# 1116 
	fsw	%f1 80(%x2)	# 1116 
	fadd	%f1 %f2 %f0	# 1116 
	sw	%x1 84(%x2)	# 1116 
	addi	%x2 %x2 88	# 1116 
	jal	 %x1 fsqr.1762	# 1116 
	addi	%x2 %x2 -88	# 1116 
	lw	%x1 84(%x2)	# 1116 
	flw	%f2 80(%x2)	# 1116 
	fsw	%f1 84(%x2)	# 1116 
	fadd	%f1 %f2 %f0	# 1116 
	sw	%x1 92(%x2)	# 1116 
	addi	%x2 %x2 96	# 1116 
	jal	 %x1 fsqr.1762	# 1116 
	addi	%x2 %x2 -96	# 1116 
	lw	%x1 92(%x2)	# 1116 
	flw	%f2 84(%x2)	# 1116 
	fadd	%f1 %f2 %f1	# 1116 
	sw	%x1 92(%x2)	# 1116 
	addi	%x2 %x2 96	# 1116 
	jal	 %x1 min_caml_sqrt	# 1116 
	addi	%x2 %x2 -96	# 1116 
	lw	%x1 92(%x2)	# 1116 
	addi	%x6 %x0 l.4391	# 1118 
	flw	%f2 (0)%x6	# 1118 
	flw	%f3 68(%x2)	# 1118 
	fsw	%f1 88(%x2)	# 1118 
	fsw	%f2 92(%x2)	# 1118 
	fadd	%f1 %f3 %f0	# 1118 
	sw	%x1 100(%x2)	# 1118 
	addi	%x2 %x2 104	# 1118 
	jal	 %x1 min_caml_abs_float	# 1118 
	addi	%x2 %x2 -104	# 1118 
	lw	%x1 100(%x2)	# 1118 
	flw	%f2 92(%x2)	# 1118 
	fblt	%f2 %f1 fblt.6004	# 1118 
	nop	# 1118 
	addi	%x6 %x0 l.4393	# 1119 
	flw	%f1 (0)%x6	# 1119 
	j	fblt_cont.6005	# 1118 
	nop	# 1118 
fblt.6004:	# 1118 
	flw	%f1 68(%x2)	# 1121 
	flw	%f2 80(%x2)	# 1121 
	fdiv	%f1 %f2 %f1	# 1121 
	sw	%x1 100(%x2)	# 1121 
	addi	%x2 %x2 104	# 1121 
	jal	 %x1 min_caml_abs_float	# 1121 
	addi	%x2 %x2 -104	# 1121 
	lw	%x1 100(%x2)	# 1121 
	sw	%x1 100(%x2)	# 1123 
	addi	%x2 %x2 104	# 1123 
	jal	 %x1 min_caml_atan	# 1123 
	addi	%x2 %x2 -104	# 1123 
	lw	%x1 100(%x2)	# 1123 
	addi	%x6 %x0 l.4395	# 1123 
	flw	%f2 (0)%x6	# 1123 
	fmul	%f1 %f1 %f2	# 1123 
fblt_cont.6005:	# 1118 
	fsw	%f1 96(%x2)	# 1125 
	sw	%x1 100(%x2)	# 1125 
	addi	%x2 %x2 104	# 1125 
	jal	 %x1 min_caml_floor	# 1125 
	addi	%x2 %x2 -104	# 1125 
	lw	%x1 100(%x2)	# 1125 
	flw	%f2 96(%x2)	# 1125 
	fsub	%f1 %f2 %f1	# 1125 
	lw	%x6 0(%x2)	# 1127 
	flw	%f3 (4)%x6	# 1127 
	lw	%x6 8(%x2)	# 1127 
	fsw	%f1 100(%x2)	# 1127 
	fsw	%f3 104(%x2)	# 1127 
	sw	%x1 108(%x2)	# 1127 
	addi	%x2 %x2 112	# 1127 
	jal	 %x1 o_param_y.1784	# 1127 
	addi	%x2 %x2 -112	# 1127 
	lw	%x1 108(%x2)	# 1127 
	flw	%f2 104(%x2)	# 1127 
	fsub	%f1 %f2 %f1	# 1127 
	lw	%x6 8(%x2)	# 1127 
	fsw	%f1 108(%x2)	# 1127 
	sw	%x1 116(%x2)	# 1127 
	addi	%x2 %x2 120	# 1127 
	jal	 %x1 o_param_b.1778	# 1127 
	addi	%x2 %x2 -120	# 1127 
	lw	%x1 116(%x2)	# 1127 
	sw	%x1 116(%x2)	# 1127 
	addi	%x2 %x2 120	# 1127 
	jal	 %x1 min_caml_sqrt	# 1127 
	addi	%x2 %x2 -120	# 1127 
	lw	%x1 116(%x2)	# 1127 
	flw	%f2 108(%x2)	# 1127 
	fmul	%f1 %f2 %f1	# 1127 
	addi	%x6 %x0 l.4391	# 1129 
	flw	%f2 (0)%x6	# 1129 
	flw	%f3 96(%x2)	# 1129 
	fsw	%f1 112(%x2)	# 1129 
	fsw	%f2 116(%x2)	# 1129 
	fadd	%f1 %f3 %f0	# 1129 
	sw	%x1 124(%x2)	# 1129 
	addi	%x2 %x2 128	# 1129 
	jal	 %x1 min_caml_abs_float	# 1129 
	addi	%x2 %x2 -128	# 1129 
	lw	%x1 124(%x2)	# 1129 
	flw	%f2 116(%x2)	# 1129 
	fblt	%f2 %f1 fblt.6006	# 1129 
	nop	# 1129 
	addi	%x6 %x0 l.4393	# 1130 
	flw	%f1 (0)%x6	# 1130 
	j	fblt_cont.6007	# 1129 
	nop	# 1129 
fblt.6006:	# 1129 
	flw	%f1 88(%x2)	# 1132 
	flw	%f2 112(%x2)	# 1132 
	fdiv	%f1 %f2 %f1	# 1132 
	sw	%x1 124(%x2)	# 1132 
	addi	%x2 %x2 128	# 1132 
	jal	 %x1 min_caml_abs_float	# 1132 
	addi	%x2 %x2 -128	# 1132 
	lw	%x1 124(%x2)	# 1132 
	sw	%x1 124(%x2)	# 1133 
	addi	%x2 %x2 128	# 1133 
	jal	 %x1 min_caml_atan	# 1133 
	addi	%x2 %x2 -128	# 1133 
	lw	%x1 124(%x2)	# 1133 
	addi	%x6 %x0 l.4395	# 1133 
	flw	%f2 (0)%x6	# 1133 
	fmul	%f1 %f1 %f2	# 1133 
fblt_cont.6007:	# 1129 
	fsw	%f1 120(%x2)	# 1135 
	sw	%x1 124(%x2)	# 1135 
	addi	%x2 %x2 128	# 1135 
	jal	 %x1 min_caml_floor	# 1135 
	addi	%x2 %x2 -128	# 1135 
	lw	%x1 124(%x2)	# 1135 
	flw	%f2 120(%x2)	# 1135 
	fsub	%f1 %f2 %f1	# 1135 
	addi	%x6 %x0 l.4401	# 1136 
	flw	%f2 (0)%x6	# 1136 
	addi	%x6 %x0 l.4403	# 1136 
	flw	%f3 (0)%x6	# 1136 
	flw	%f4 100(%x2)	# 1136 
	fsub	%f3 %f3 %f4	# 1136 
	fsw	%f1 124(%x2)	# 1136 
	fsw	%f2 128(%x2)	# 1136 
	fadd	%f1 %f3 %f0	# 1136 
	sw	%x1 132(%x2)	# 1136 
	addi	%x2 %x2 136	# 1136 
	jal	 %x1 fsqr.1762	# 1136 
	addi	%x2 %x2 -136	# 1136 
	lw	%x1 132(%x2)	# 1136 
	flw	%f2 128(%x2)	# 1136 
	fsub	%f1 %f2 %f1	# 1136 
	addi	%x6 %x0 l.4403	# 1136 
	flw	%f2 (0)%x6	# 1136 
	flw	%f3 124(%x2)	# 1136 
	fsub	%f2 %f2 %f3	# 1136 
	fsw	%f1 132(%x2)	# 1136 
	fadd	%f1 %f2 %f0	# 1136 
	sw	%x1 140(%x2)	# 1136 
	addi	%x2 %x2 144	# 1136 
	jal	 %x1 fsqr.1762	# 1136 
	addi	%x2 %x2 -144	# 1136 
	lw	%x1 140(%x2)	# 1136 
	flw	%f2 132(%x2)	# 1136 
	fsub	%f1 %f2 %f1	# 1136 
	addi	%x6 %x0 l.3996	# 1137 
	flw	%f2 (0)%x6	# 1137 
	fblt	%f1 %f2 fblt.6008	# 1137 
	nop	# 1137 
	addi	%x6 %x0 l.4407	# 1137 
	flw	%f2 (0)%x6	# 1137 
	fmul	%f1 %f1 %f2	# 1137 
	j	fblt_cont.6009	# 1137 
	nop	# 1137 
fblt.6008:	# 1137 
	addi	%x6 %x0 l.3996	# 1137 
	flw	%f1 (0)%x6	# 1137 
fblt_cont.6009:	# 1137 
	lw	%x6 4(%x2)	# 1137 
	fsw	%f1 (8)%x6	# 1137 

	jr	0(%x1)	# 1137 
	nop	# 1137 
beq_else.6003:	# 1112 
	jr	0(%x1)	# 1139 
	nop	# 1139 
in_prod.1903:
	flw	%f1 (0)%x6	# 1151 
	flw	%f2 (0)%x7	# 1151 
	fmul	%f1 %f1 %f2	# 1151 
	flw	%f2 (4)%x6	# 1151 
	flw	%f3 (4)%x7	# 1151 
	fmul	%f2 %f2 %f3	# 1151 
	fadd	%f1 %f1 %f2	# 1151 
	flw	%f2 (8)%x6	# 1151 
	flw	%f3 (8)%x7	# 1151 
	fmul	%f2 %f2 %f3	# 1151 
	fadd	%f1 %f1 %f2	# 1151 
	jr	0(%x1)	# 1151 
	nop	# 1151 
accumulate_vec_mul.1906:
	flw	%f2 (0)%x6	# 1157 
	flw	%f3 (0)%x7	# 1157 
	fmul	%f3 %f1 %f3	# 1157 
	fadd	%f2 %f2 %f3	# 1157 
	fsw	%f2 (0)%x6	# 1157 

	flw	%f2 (4)%x6	# 1158 
	flw	%f3 (4)%x7	# 1158 
	fmul	%f3 %f1 %f3	# 1158 
	fadd	%f2 %f2 %f3	# 1158 
	fsw	%f2 (4)%x6	# 1158 

	flw	%f2 (8)%x6	# 1159 
	flw	%f3 (8)%x7	# 1159 
	fmul	%f1 %f1 %f3	# 1159 
	fadd	%f1 %f2 %f1	# 1159 
	fsw	%f1 (8)%x6	# 1159 

	jr	0(%x1)	# 1159 
	nop	# 1159 
raytracing.1910:
	lw	%x7 60(%x4)	# 1164 
	lw	%x8 56(%x4)	# 1164 
	lw	%x9 52(%x4)	# 1164 
	lw	%x10 48(%x4)	# 1164 
	lw	%x11 44(%x4)	# 1164 
	lw	%x12 40(%x4)	# 1164 
	lw	%x13 36(%x4)	# 1164 
	lw	%x14 32(%x4)	# 1164 
	lw	%x15 28(%x4)	# 1164 
	lw	%x16 24(%x4)	# 1164 
	lw	%x17 20(%x4)	# 1164 
	lw	%x18 16(%x4)	# 1164 
	lw	%x19 12(%x4)	# 1164 
	lw	%x20 8(%x4)	# 1164 
	lw	%x21 4(%x4)	# 1164 
	sw	%x4 0(%x2)	# 1164 
	sw	%x8 4(%x2)	# 1164 
	sw	%x11 8(%x2)	# 1164 
	sw	%x9 12(%x2)	# 1164 
	sw	%x16 16(%x2)	# 1164 
	sw	%x12 20(%x2)	# 1164 
	sw	%x14 24(%x2)	# 1164 
	sw	%x19 28(%x2)	# 1164 
	sw	%x18 32(%x2)	# 1164 
	sw	%x15 36(%x2)	# 1164 
	sw	%x20 40(%x2)	# 1164 
	sw	%x13 44(%x2)	# 1164 
	sw	%x21 48(%x2)	# 1164 
	fsw	%f1 52(%x2)	# 1164 
	sw	%x17 56(%x2)	# 1164 
	sw	%x7 60(%x2)	# 1164 
	sw	%x6 64(%x2)	# 1164 
	add	%x6 %x0 %x8	# 1164 
	add	%x4 %x0 %x10	# 1164 
	sw	%x1 68(%x2)	# 1164 
	lw	%x5 0(%x4)	# 1164 
	addi	%x2 %x2 72	# 1164 
	jalr	%x1 %x5	# 1164 
	addi	%x2 %x2 -72	# 1164 
	lw	%x1 68(%x2)	# 1164 
	sw	%x6 68(%x2)	# 1168 
	addi	%x5 %x0 0	# 1168 
	bne	%x6 %x5 beq_else.6013	# 1168 
	nop	# 1168 
	lw	%x7 64(%x2)	# 1169 
	addi	%x5 %x0 0	# 1169 
	bne	%x7 %x5 beq_else.6015	# 1169 
	nop	# 1169 
	j	beq_cont.6016	# 1169 
	nop	# 1169 
beq_else.6015:	# 1169 
	lw	%x8 60(%x2)	# 1171 
	lw	%x9 56(%x2)	# 1171 
	add	%x7 %x0 %x9	# 1171 
	add	%x6 %x0 %x8	# 1171 
	sw	%x1 76(%x2)	# 1171 
	addi	%x2 %x2 80	# 1171 
	jal	 %x1 in_prod.1903	# 1171 
	addi	%x2 %x2 -80	# 1171 
	lw	%x1 76(%x2)	# 1171 
	fneg	%f1 %f1	# 1171 
	addi	%x6 %x0 l.3996	# 1173 
	flw	%f2 (0)%x6	# 1173 
	fblt	%f1 %f2 fblt.6017	# 1173 
	nop	# 1173 
	fsw	%f1 72(%x2)	# 1176 
	sw	%x1 76(%x2)	# 1176 
	addi	%x2 %x2 80	# 1176 
	jal	 %x1 fsqr.1762	# 1176 
	addi	%x2 %x2 -80	# 1176 
	lw	%x1 76(%x2)	# 1176 
	flw	%f2 72(%x2)	# 1176 
	fmul	%f1 %f1 %f2	# 1176 
	flw	%f2 52(%x2)	# 1176 
	fmul	%f1 %f1 %f2	# 1176 
	lw	%x6 48(%x2)	# 1176 
	flw	%f3 (0)%x6	# 1176 
	fmul	%f1 %f1 %f3	# 1176 
	lw	%x6 44(%x2)	# 1177 
	flw	%f3 (0)%x6	# 1177 
	fadd	%f3 %f3 %f1	# 1177 
	fsw	%f3 (0)%x6	# 1177 

	flw	%f3 (4)%x6	# 1178 
	fadd	%f3 %f3 %f1	# 1178 
	fsw	%f3 (4)%x6	# 1178 

	flw	%f3 (8)%x6	# 1179 
	fadd	%f1 %f3 %f1	# 1179 
	fsw	%f1 (8)%x6	# 1179 

	j	fblt_cont.6018	# 1173 
	nop	# 1173 
fblt.6017:	# 1173 
fblt_cont.6018:	# 1173 
beq_cont.6016:	# 1169 
	j	beq_cont.6014	# 1168 
	nop	# 1168 
beq_else.6013:	# 1168 
beq_cont.6014:	# 1168 
	lw	%x6 68(%x2)	# 1186 
	addi	%x5 %x0 0	# 1186 
	bne	%x6 %x5 beq_else.6019	# 1186 
	nop	# 1186 
	jr	0(%x1)	# 1246 
	nop	# 1246 
beq_else.6019:	# 1186 
	lw	%x6 40(%x2)	# 1190 
	lw	%x6 0(%x6)	# 1190 
	sll	%x6 %x6 2	# 1190 
	lw	%x7 36(%x2)	# 1190 
	lw	%x6 %x6(%x7)	# 1190 
	lw	%x7 28(%x2)	# 1191 
	lw	%x4 32(%x2)	# 1191 
	sw	%x6 76(%x2)	# 1191 
	sw	%x1 84(%x2)	# 1191 
	lw	%x5 0(%x4)	# 1191 
	addi	%x2 %x2 88	# 1191 
	jalr	%x1 %x5	# 1191 
	addi	%x2 %x2 -88	# 1191 
	lw	%x1 84(%x2)	# 1191 
	addi	%x6 %x0 0	# 1193 
	lw	%x7 24(%x2)	# 1193 
	lw	%x7 0(%x7)	# 1193 
	lw	%x8 28(%x2)	# 1193 
	lw	%x4 20(%x2)	# 1193 
	sw	%x1 84(%x2)	# 1193 
	lw	%x5 0(%x4)	# 1193 
	addi	%x2 %x2 88	# 1193 
	jalr	%x1 %x5	# 1193 
	addi	%x2 %x2 -88	# 1193 
	lw	%x1 84(%x2)	# 1193 
	addi	%x5 %x0 0	# 1193 
	bne	%x6 %x5 beq_else.6021	# 1193 
	nop	# 1193 
	lw	%x6 16(%x2)	# 1197 
	lw	%x7 56(%x2)	# 1197 
	sw	%x1 84(%x2)	# 1197 
	addi	%x2 %x2 88	# 1197 
	jal	 %x1 in_prod.1903	# 1197 
	addi	%x2 %x2 -88	# 1197 
	lw	%x1 84(%x2)	# 1197 
	fneg	%f1 %f1	# 1197 
	addi	%x6 %x0 l.3996	# 1198 
	flw	%f2 (0)%x6	# 1198 
	fblt	%f2 %f1 fblt.6023	# 1198 
	nop	# 1198 
	addi	%x6 %x0 l.4474	# 1198 
	flw	%f1 (0)%x6	# 1198 
	j	fblt_cont.6024	# 1198 
	nop	# 1198 
fblt.6023:	# 1198 
	addi	%x6 %x0 l.4474	# 1198 
	flw	%f2 (0)%x6	# 1198 
	fadd	%f1 %f1 %f2	# 1198 
fblt_cont.6024:	# 1198 
	flw	%f2 52(%x2)	# 1199 
	fmul	%f1 %f1 %f2	# 1199 
	lw	%x6 76(%x2)	# 1199 
	fsw	%f1 80(%x2)	# 1199 
	sw	%x1 84(%x2)	# 1199 
	addi	%x2 %x2 88	# 1199 
	jal	 %x1 o_diffuse.1788	# 1199 
	addi	%x2 %x2 -88	# 1199 
	lw	%x1 84(%x2)	# 1199 
	flw	%f2 80(%x2)	# 1199 
	fmul	%f1 %f2 %f1	# 1199 
	j	beq_cont.6022	# 1193 
	nop	# 1193 
beq_else.6021:	# 1193 
	addi	%x6 %x0 l.3996	# 1195 
	flw	%f1 (0)%x6	# 1195 
beq_cont.6022:	# 1193 
	lw	%x6 76(%x2)	# 1202 
	lw	%x7 28(%x2)	# 1202 
	lw	%x4 12(%x2)	# 1202 
	fsw	%f1 84(%x2)	# 1202 
	sw	%x1 92(%x2)	# 1202 
	lw	%x5 0(%x4)	# 1202 
	addi	%x2 %x2 96	# 1202 
	jalr	%x1 %x5	# 1202 
	addi	%x2 %x2 -96	# 1202 
	lw	%x1 92(%x2)	# 1202 
	flw	%f1 84(%x2)	# 1203 
	lw	%x6 44(%x2)	# 1203 
	lw	%x7 8(%x2)	# 1203 
	sw	%x1 92(%x2)	# 1203 
	addi	%x2 %x2 96	# 1203 
	jal	 %x1 accumulate_vec_mul.1906	# 1203 
	addi	%x2 %x2 -96	# 1203 
	lw	%x1 92(%x2)	# 1203 
	lw	%x6 64(%x2)	# 1205 
	addi	%x5 %x0 4	# 1205 
	blt	%x5 %x6 blt.6025	# 1205 
	nop	# 1205 
	addi	%x7 %x0 l.4477	# 1206 
	flw	%f1 (0)%x7	# 1206 
	flw	%f2 52(%x2)	# 1206 
	fle	%f2 %f1 fle.6026	# 1206 
	nop	# 1206 
	addi	%x7 %x0 l.4479	# 1209 
	flw	%f1 (0)%x7	# 1209 
	lw	%x7 60(%x2)	# 1209 
	lw	%x8 16(%x2)	# 1209 
	fsw	%f1 88(%x2)	# 1209 
	add	%x6 %x0 %x7	# 1209 
	add	%x7 %x0 %x8	# 1209 
	sw	%x1 92(%x2)	# 1209 
	addi	%x2 %x2 96	# 1209 
	jal	 %x1 in_prod.1903	# 1209 
	addi	%x2 %x2 -96	# 1209 
	lw	%x1 92(%x2)	# 1209 
	flw	%f2 88(%x2)	# 1209 
	fmul	%f1 %f2 %f1	# 1209 
	lw	%x6 60(%x2)	# 1211 
	lw	%x7 16(%x2)	# 1211 
	sw	%x1 92(%x2)	# 1211 
	addi	%x2 %x2 96	# 1211 
	jal	 %x1 accumulate_vec_mul.1906	# 1211 
	addi	%x2 %x2 -96	# 1211 
	lw	%x1 92(%x2)	# 1211 
	lw	%x6 76(%x2)	# 1213 
	sw	%x1 92(%x2)	# 1213 
	addi	%x2 %x2 96	# 1213 
	jal	 %x1 o_reflectiontype.1770	# 1213 
	addi	%x2 %x2 -96	# 1213 
	lw	%x1 92(%x2)	# 1213 
	addi	%x5 %x0 1	# 1214 
	bne	%x6 %x5 beq_else.6027	# 1214 
	nop	# 1214 
	addi	%x6 %x0 l.3996	# 1217 
	flw	%f1 (0)%x6	# 1217 
	lw	%x6 76(%x2)	# 1217 
	fsw	%f1 92(%x2)	# 1217 
	sw	%x1 100(%x2)	# 1217 
	addi	%x2 %x2 104	# 1217 
	jal	 %x1 o_hilight.1790	# 1217 
	addi	%x2 %x2 -104	# 1217 
	lw	%x1 100(%x2)	# 1217 
	flw	%f2 92(%x2)	# 1217 
	feq	%f2 %f1 feq.6028	# 1217 
	nop	# 1217 
	lw	%x6 60(%x2)	# 1220 
	lw	%x7 56(%x2)	# 1220 
	sw	%x1 100(%x2)	# 1220 
	addi	%x2 %x2 104	# 1220 
	jal	 %x1 in_prod.1903	# 1220 
	addi	%x2 %x2 -104	# 1220 
	lw	%x1 100(%x2)	# 1220 
	fneg	%f1 %f1	# 1220 
	addi	%x6 %x0 l.3996	# 1221 
	flw	%f2 (0)%x6	# 1221 
	fle	%f1 %f2 fle.6029	# 1221 
	nop	# 1221 
	sw	%x1 100(%x2)	# 1224 
	addi	%x2 %x2 104	# 1224 
	jal	 %x1 fsqr.1762	# 1224 
	addi	%x2 %x2 -104	# 1224 
	lw	%x1 100(%x2)	# 1224 
	sw	%x1 100(%x2)	# 1224 
	addi	%x2 %x2 104	# 1224 
	jal	 %x1 fsqr.1762	# 1224 
	addi	%x2 %x2 -104	# 1224 
	lw	%x1 100(%x2)	# 1224 
	flw	%f2 52(%x2)	# 1224 
	fmul	%f1 %f1 %f2	# 1224 
	flw	%f2 84(%x2)	# 1224 
	fmul	%f1 %f1 %f2	# 1224 
	lw	%x6 76(%x2)	# 1225 
	fsw	%f1 96(%x2)	# 1225 
	sw	%x1 100(%x2)	# 1225 
	addi	%x2 %x2 104	# 1225 
	jal	 %x1 o_hilight.1790	# 1225 
	addi	%x2 %x2 -104	# 1225 
	lw	%x1 100(%x2)	# 1225 
	flw	%f2 96(%x2)	# 1224 
	fmul	%f1 %f2 %f1	# 1224 
	lw	%x6 44(%x2)	# 1227 
	flw	%f2 (0)%x6	# 1227 
	fadd	%f2 %f2 %f1	# 1227 
	fsw	%f2 (0)%x6	# 1227 

	flw	%f2 (4)%x6	# 1228 
	fadd	%f2 %f2 %f1	# 1228 
	fsw	%f2 (4)%x6	# 1228 

	flw	%f2 (8)%x6	# 1229 
	fadd	%f1 %f2 %f1	# 1229 
	fsw	%f1 (8)%x6	# 1229 

	jr	0(%x1)	# 1229 
	nop	# 1229 
fle.6029:	# 1221 
	jr	0(%x1)	# 1231 
	nop	# 1231 
feq.6028:	# 1217 
	jr	0(%x1)	# 1218 
	nop	# 1218 
beq_else.6027:	# 1214 
	addi	%x5 %x0 2	# 1233 
	bne	%x6 %x5 beq_else.6033	# 1233 
	nop	# 1233 
	lw	%x6 28(%x2)	# 1236 
	flw	%f1 (0)%x6	# 1236 
	lw	%x7 4(%x2)	# 1236 
	fsw	%f1 (0)%x7	# 1236 

	flw	%f1 (4)%x6	# 1237 
	fsw	%f1 (4)%x7	# 1237 

	flw	%f1 (8)%x6	# 1238 
	fsw	%f1 (8)%x7	# 1238 

	addi	%x6 %x0 l.3998	# 1239 
	flw	%f1 (0)%x6	# 1239 
	lw	%x6 76(%x2)	# 1239 
	fsw	%f1 100(%x2)	# 1239 
	sw	%x1 108(%x2)	# 1239 
	addi	%x2 %x2 112	# 1239 
	jal	 %x1 o_diffuse.1788	# 1239 
	addi	%x2 %x2 -112	# 1239 
	lw	%x1 108(%x2)	# 1239 
	flw	%f2 100(%x2)	# 1239 
	fsub	%f1 %f2 %f1	# 1239 
	flw	%f2 52(%x2)	# 1239 
	fmul	%f1 %f2 %f1	# 1239 
	lw	%x6 64(%x2)	# 1240 
	addi	%x6 %x6 1	# 1240 
	lw	%x4 0(%x2)	# 1240 
	lw	%x5 0(%x4)	# 1240 
	jr	0(%x5)	# 1240 
	nop	# 1240 
beq_else.6033:	# 1233 
	jr	0(%x1)	# 1242 
	nop	# 1242 
fle.6026:	# 1206 
	jr	0(%x1)	# 1244 
	nop	# 1244 
blt.6025:	# 1205 
	jr	0(%x1)	# 1205 
	nop	# 1205 
write_rgb.1913:
	lw	%x6 4(%x4)	# 1253 
	flw	%f1 (0)%x6	# 1253 
	sw	%x6 0(%x2)	# 1253 
	sw	%x1 4(%x2)	# 1253 
	addi	%x2 %x2 8	# 1253 
	jal	 %x1 min_caml_int_of_float	# 1253 
	addi	%x2 %x2 -8	# 1253 
	lw	%x1 4(%x2)	# 1253 
	addi	%x5 %x0 255	# 1254 
	blt	%x5 %x6 blt.6037	# 1254 
	nop	# 1254 
	addi	%x6 %x0 255	# 1254 
	j	blt_cont.6038	# 1254 
	nop	# 1254 
blt.6037:	# 1254 
blt_cont.6038:	# 1254 
	sw	%x1 4(%x2)	# 1255 
	addi	%x2 %x2 8	# 1255 
	jal	 %x1 min_caml_print_byte	# 1255 
	addi	%x2 %x2 -8	# 1255 
	lw	%x1 4(%x2)	# 1255 
	lw	%x6 0(%x2)	# 1257 
	flw	%f1 (4)%x6	# 1257 
	sw	%x1 4(%x2)	# 1257 
	addi	%x2 %x2 8	# 1257 
	jal	 %x1 min_caml_int_of_float	# 1257 
	addi	%x2 %x2 -8	# 1257 
	lw	%x1 4(%x2)	# 1257 
	addi	%x5 %x0 255	# 1258 
	blt	%x5 %x6 blt.6039	# 1258 
	nop	# 1258 
	addi	%x6 %x0 255	# 1258 
	j	blt_cont.6040	# 1258 
	nop	# 1258 
blt.6039:	# 1258 
blt_cont.6040:	# 1258 
	sw	%x1 4(%x2)	# 1259 
	addi	%x2 %x2 8	# 1259 
	jal	 %x1 min_caml_print_byte	# 1259 
	addi	%x2 %x2 -8	# 1259 
	lw	%x1 4(%x2)	# 1259 
	lw	%x6 0(%x2)	# 1261 
	flw	%f1 (8)%x6	# 1261 
	sw	%x1 4(%x2)	# 1261 
	addi	%x2 %x2 8	# 1261 
	jal	 %x1 min_caml_int_of_float	# 1261 
	addi	%x2 %x2 -8	# 1261 
	lw	%x1 4(%x2)	# 1261 
	addi	%x5 %x0 255	# 1262 
	blt	%x5 %x6 blt.6041	# 1262 
	nop	# 1262 
	addi	%x6 %x0 255	# 1262 
	j	blt_cont.6042	# 1262 
	nop	# 1262 
blt.6041:	# 1262 
blt_cont.6042:	# 1262 
	j	min_caml_print_byte	# 1263 
	nop	# 1263 
write_ppm_header.1915:
	lw	%x6 4(%x4)	# 1270 
	addi	%x7 %x0 80	# 1270 
	sw	%x6 0(%x2)	# 1270 
	add	%x6 %x0 %x7	# 1270 
	sw	%x1 4(%x2)	# 1270 
	addi	%x2 %x2 8	# 1270 
	jal	 %x1 min_caml_print_byte	# 1270 
	addi	%x2 %x2 -8	# 1270 
	lw	%x1 4(%x2)	# 1270 
	addi	%x6 %x0 54	# 1271 
	sw	%x1 4(%x2)	# 1271 
	addi	%x2 %x2 8	# 1271 
	jal	 %x1 min_caml_print_byte	# 1271 
	addi	%x2 %x2 -8	# 1271 
	lw	%x1 4(%x2)	# 1271 
	addi	%x6 %x0 10	# 1272 
	sw	%x1 4(%x2)	# 1272 
	addi	%x2 %x2 8	# 1272 
	jal	 %x1 min_caml_print_byte	# 1272 
	addi	%x2 %x2 -8	# 1272 
	lw	%x1 4(%x2)	# 1272 
	lw	%x6 0(%x2)	# 1273 
	lw	%x7 0(%x6)	# 1273 
	add	%x6 %x0 %x7	# 1273 
	sw	%x1 4(%x2)	# 1273 
	addi	%x2 %x2 8	# 1273 
	jal	 %x1 min_caml_print_int	# 1273 
	addi	%x2 %x2 -8	# 1273 
	lw	%x1 4(%x2)	# 1273 
	addi	%x6 %x0 32	# 1274 
	sw	%x1 4(%x2)	# 1274 
	addi	%x2 %x2 8	# 1274 
	jal	 %x1 min_caml_print_byte	# 1274 
	addi	%x2 %x2 -8	# 1274 
	lw	%x1 4(%x2)	# 1274 
	lw	%x6 0(%x2)	# 1275 
	lw	%x6 4(%x6)	# 1275 
	sw	%x1 4(%x2)	# 1275 
	addi	%x2 %x2 8	# 1275 
	jal	 %x1 min_caml_print_int	# 1275 
	addi	%x2 %x2 -8	# 1275 
	lw	%x1 4(%x2)	# 1275 
	addi	%x6 %x0 10	# 1276 
	sw	%x1 4(%x2)	# 1276 
	addi	%x2 %x2 8	# 1276 
	jal	 %x1 min_caml_print_byte	# 1276 
	addi	%x2 %x2 -8	# 1276 
	lw	%x1 4(%x2)	# 1276 
	addi	%x6 %x0 255	# 1277 
	sw	%x1 4(%x2)	# 1277 
	addi	%x2 %x2 8	# 1277 
	jal	 %x1 min_caml_print_int	# 1277 
	addi	%x2 %x2 -8	# 1277 
	lw	%x1 4(%x2)	# 1277 
	addi	%x6 %x0 10	# 1278 
	j	min_caml_print_byte	# 1278 
	nop	# 1278 
scan_point.1917:
	lw	%x7 60(%x4)	# 1285 
	lw	%x8 56(%x4)	# 1285 
	lw	%x9 52(%x4)	# 1285 
	lw	%x10 48(%x4)	# 1285 
	lw	%x11 44(%x4)	# 1285 
	lw	%x12 40(%x4)	# 1285 
	lw	%x13 36(%x4)	# 1285 
	lw	%x14 32(%x4)	# 1285 
	lw	%x15 28(%x4)	# 1285 
	lw	%x16 24(%x4)	# 1285 
	lw	%x17 20(%x4)	# 1285 
	lw	%x18 16(%x4)	# 1285 
	lw	%x19 12(%x4)	# 1285 
	lw	%x20 8(%x4)	# 1285 
	lw	%x21 4(%x4)	# 1285 
	lw	%x13 0(%x13)	# 1285 
	blt	%x6 %x13 blt.6043	# 1285 
	nop	# 1285 
	jr	0(%x1)	# 1285 
	nop	# 1285 
blt.6043:	# 1285 
	sw	%x4 0(%x2)	# 1288 
	sw	%x6 4(%x2)	# 1288 
	sw	%x8 8(%x2)	# 1288 
	sw	%x20 12(%x2)	# 1288 
	sw	%x19 16(%x2)	# 1288 
	sw	%x11 20(%x2)	# 1288 
	sw	%x12 24(%x2)	# 1288 
	sw	%x17 28(%x2)	# 1288 
	sw	%x14 32(%x2)	# 1288 
	sw	%x10 36(%x2)	# 1288 
	sw	%x15 40(%x2)	# 1288 
	sw	%x9 44(%x2)	# 1288 
	sw	%x7 48(%x2)	# 1288 
	sw	%x21 52(%x2)	# 1288 
	sw	%x18 56(%x2)	# 1288 
	sw	%x16 60(%x2)	# 1288 
	sw	%x1 68(%x2)	# 1288 
	addi	%x2 %x2 72	# 1288 
	jal	 %x1 min_caml_float_of_int	# 1288 
	addi	%x2 %x2 -72	# 1288 
	lw	%x1 68(%x2)	# 1288 
	lw	%x6 60(%x2)	# 1288 
	flw	%f2 (0)%x6	# 1288 
	fsub	%f1 %f1 %f2	# 1288 
	lw	%x6 56(%x2)	# 1288 
	flw	%f2 (0)%x6	# 1288 
	fmul	%f1 %f1 %f2	# 1288 
	lw	%x6 52(%x2)	# 1290 
	flw	%f2 (4)%x6	# 1290 
	fmul	%f2 %f1 %f2	# 1290 
	lw	%x7 48(%x2)	# 1290 
	flw	%f3 (0)%x7	# 1290 
	fadd	%f2 %f2 %f3	# 1290 
	lw	%x8 44(%x2)	# 1290 
	fsw	%f2 (0)%x8	# 1290 

	lw	%x9 40(%x2)	# 1291 
	flw	%f2 (0)%x9	# 1291 
	flw	%f3 (0)%x6	# 1291 
	fmul	%f2 %f2 %f3	# 1291 
	lw	%x6 36(%x2)	# 1291 
	flw	%f3 (4)%x6	# 1291 
	fsub	%f2 %f2 %f3	# 1291 
	fsw	%f2 (4)%x8	# 1291 

	fneg	%f2 %f1	# 1292 
	lw	%x6 32(%x2)	# 1292 
	flw	%f3 (4)%x6	# 1292 
	fmul	%f2 %f2 %f3	# 1292 
	flw	%f3 (8)%x7	# 1292 
	fadd	%f2 %f2 %f3	# 1292 
	fsw	%f2 (8)%x8	# 1292 

	sw	%x1 68(%x2)	# 1295 
	addi	%x2 %x2 72	# 1295 
	jal	 %x1 fsqr.1762	# 1295 
	addi	%x2 %x2 -72	# 1295 
	lw	%x1 68(%x2)	# 1295 
	lw	%x6 28(%x2)	# 1295 
	flw	%f2 (0)%x6	# 1295 
	fadd	%f1 %f1 %f2	# 1295 
	sw	%x1 68(%x2)	# 1295 
	addi	%x2 %x2 72	# 1295 
	jal	 %x1 min_caml_sqrt	# 1295 
	addi	%x2 %x2 -72	# 1295 
	lw	%x1 68(%x2)	# 1295 
	lw	%x6 44(%x2)	# 1296 
	flw	%f2 (0)%x6	# 1296 
	fdiv	%f2 %f2 %f1	# 1296 
	fsw	%f2 (0)%x6	# 1296 

	flw	%f2 (4)%x6	# 1297 
	fdiv	%f2 %f2 %f1	# 1297 
	fsw	%f2 (4)%x6	# 1297 

	flw	%f2 (8)%x6	# 1298 
	fdiv	%f1 %f2 %f1	# 1298 
	fsw	%f1 (8)%x6	# 1298 

	lw	%x6 24(%x2)	# 1300 
	flw	%f1 (0)%x6	# 1300 
	lw	%x7 20(%x2)	# 1300 
	fsw	%f1 (0)%x7	# 1300 

	flw	%f1 (4)%x6	# 1301 
	fsw	%f1 (4)%x7	# 1301 

	flw	%f1 (8)%x6	# 1302 
	fsw	%f1 (8)%x7	# 1302 

	addi	%x6 %x0 l.3996	# 1305 
	flw	%f1 (0)%x6	# 1305 
	lw	%x6 16(%x2)	# 1305 
	fsw	%f1 (0)%x6	# 1305 

	addi	%x7 %x0 l.3996	# 1306 
	flw	%f1 (0)%x7	# 1306 
	fsw	%f1 (4)%x6	# 1306 

	addi	%x7 %x0 l.3996	# 1307 
	flw	%f1 (0)%x7	# 1307 
	fsw	%f1 (8)%x6	# 1307 

	addi	%x6 %x0 0	# 1310 
	addi	%x7 %x0 l.3998	# 1310 
	flw	%f1 (0)%x7	# 1310 
	lw	%x4 12(%x2)	# 1310 
	sw	%x1 68(%x2)	# 1310 
	lw	%x5 0(%x4)	# 1310 
	addi	%x2 %x2 72	# 1310 
	jalr	%x1 %x5	# 1310 
	addi	%x2 %x2 -72	# 1310 
	lw	%x1 68(%x2)	# 1310 
	lw	%x4 8(%x2)	# 1313 
	sw	%x1 68(%x2)	# 1313 
	lw	%x5 0(%x4)	# 1313 
	addi	%x2 %x2 72	# 1313 
	jalr	%x1 %x5	# 1313 
	addi	%x2 %x2 -72	# 1313 
	lw	%x1 68(%x2)	# 1313 
	lw	%x6 4(%x2)	# 1316 
	addi	%x6 %x6 1	# 1316 
	lw	%x4 0(%x2)	# 1316 
	lw	%x5 0(%x4)	# 1316 
	jr	0(%x5)	# 1316 
	nop	# 1316 
scan_line.1919:
	lw	%x7 40(%x4)	# 1323 
	lw	%x8 36(%x4)	# 1323 
	lw	%x9 32(%x4)	# 1323 
	lw	%x10 28(%x4)	# 1323 
	lw	%x11 24(%x4)	# 1323 
	lw	%x12 20(%x4)	# 1323 
	lw	%x13 16(%x4)	# 1323 
	lw	%x14 12(%x4)	# 1323 
	lw	%x15 8(%x4)	# 1323 
	lw	%x16 4(%x4)	# 1323 
	lw	%x9 0(%x9)	# 1323 
	blt	%x6 %x9 blt.6045	# 1323 
	nop	# 1323 
	jr	0(%x1)	# 1345 
	nop	# 1345 
blt.6045:	# 1323 
	flw	%f1 (0)%x13	# 1333 
	addi	%x9 %x0 l.3998	# 1333 
	flw	%f2 (0)%x9	# 1333 
	fsub	%f1 %f1 %f2	# 1333 
	sw	%x4 0(%x2)	# 1333 
	sw	%x6 4(%x2)	# 1333 
	sw	%x12 8(%x2)	# 1333 
	sw	%x16 12(%x2)	# 1333 
	sw	%x7 16(%x2)	# 1333 
	sw	%x8 20(%x2)	# 1333 
	sw	%x10 24(%x2)	# 1333 
	sw	%x14 28(%x2)	# 1333 
	sw	%x11 32(%x2)	# 1333 
	sw	%x15 36(%x2)	# 1333 
	fsw	%f1 40(%x2)	# 1333 
	sw	%x1 44(%x2)	# 1333 
	addi	%x2 %x2 48	# 1333 
	jal	 %x1 min_caml_float_of_int	# 1333 
	addi	%x2 %x2 -48	# 1333 
	lw	%x1 44(%x2)	# 1333 
	flw	%f2 40(%x2)	# 1333 
	fsub	%f1 %f2 %f1	# 1333 
	lw	%x6 36(%x2)	# 1334 
	flw	%f2 (0)%x6	# 1334 
	fmul	%f1 %f2 %f1	# 1334 
	lw	%x6 32(%x2)	# 1332 
	fsw	%f1 (0)%x6	# 1332 

	flw	%f1 (0)%x6	# 1336 
	sw	%x1 44(%x2)	# 1336 
	addi	%x2 %x2 48	# 1336 
	jal	 %x1 fsqr.1762	# 1336 
	addi	%x2 %x2 -48	# 1336 
	lw	%x1 44(%x2)	# 1336 
	addi	%x6 %x0 l.4540	# 1336 
	flw	%f2 (0)%x6	# 1336 
	fadd	%f1 %f1 %f2	# 1336 
	lw	%x6 28(%x2)	# 1336 
	fsw	%f1 (0)%x6	# 1336 

	lw	%x6 32(%x2)	# 1338 
	flw	%f1 (0)%x6	# 1338 
	lw	%x6 24(%x2)	# 1338 
	flw	%f2 (0)%x6	# 1338 
	fmul	%f1 %f1 %f2	# 1338 
	flw	%f2 (4)%x6	# 1339 
	fmul	%f2 %f1 %f2	# 1339 
	lw	%x6 20(%x2)	# 1339 
	flw	%f3 (0)%x6	# 1339 
	fsub	%f2 %f2 %f3	# 1339 
	lw	%x7 16(%x2)	# 1339 
	fsw	%f2 (0)%x7	# 1339 

	lw	%x8 12(%x2)	# 1340 
	flw	%f2 (4)%x8	# 1340 
	fmul	%f1 %f1 %f2	# 1340 
	flw	%f2 (8)%x6	# 1340 
	fsub	%f1 %f1 %f2	# 1340 
	fsw	%f1 (8)%x7	# 1340 

	addi	%x6 %x0 0	# 1341 
	lw	%x4 8(%x2)	# 1341 
	sw	%x1 44(%x2)	# 1341 
	lw	%x5 0(%x4)	# 1341 
	addi	%x2 %x2 48	# 1341 
	jalr	%x1 %x5	# 1341 
	addi	%x2 %x2 -48	# 1341 
	lw	%x1 44(%x2)	# 1341 
	lw	%x6 4(%x2)	# 1342 
	addi	%x6 %x6 1	# 1342 
	lw	%x4 0(%x2)	# 1342 
	lw	%x5 0(%x4)	# 1342 
	jr	0(%x5)	# 1342 
	nop	# 1342 
scan_start.1921:
	lw	%x6 20(%x4)	# 1352 
	lw	%x7 16(%x4)	# 1352 
	lw	%x8 12(%x4)	# 1352 
	lw	%x9 8(%x4)	# 1352 
	lw	%x10 4(%x4)	# 1352 
	sw	%x9 0(%x2)	# 1352 
	sw	%x8 4(%x2)	# 1352 
	sw	%x10 8(%x2)	# 1352 
	sw	%x7 12(%x2)	# 1352 
	add	%x4 %x0 %x6	# 1352 
	sw	%x1 20(%x2)	# 1352 
	lw	%x5 0(%x4)	# 1352 
	addi	%x2 %x2 24	# 1352 
	jalr	%x1 %x5	# 1352 
	addi	%x2 %x2 -24	# 1352 
	lw	%x1 20(%x2)	# 1352 
	lw	%x6 12(%x2)	# 1353 
	lw	%x6 0(%x6)	# 1353 
	sw	%x1 20(%x2)	# 1353 
	addi	%x2 %x2 24	# 1353 
	jal	 %x1 min_caml_float_of_int	# 1353 
	addi	%x2 %x2 -24	# 1353 
	lw	%x1 20(%x2)	# 1353 
	addi	%x6 %x0 l.4552	# 1354 
	flw	%f2 (0)%x6	# 1354 
	fdiv	%f2 %f2 %f1	# 1354 
	lw	%x6 8(%x2)	# 1354 
	fsw	%f2 (0)%x6	# 1354 

	addi	%x6 %x0 l.3971	# 1355 
	flw	%f2 (0)%x6	# 1355 
	fdiv	%f1 %f1 %f2	# 1355 
	lw	%x6 4(%x2)	# 1355 
	fsw	%f1 (0)%x6	# 1355 

	addi	%x6 %x0 0	# 1356 
	lw	%x4 0(%x2)	# 1356 
	lw	%x5 0(%x4)	# 1356 
	jr	0(%x5)	# 1356 
	nop	# 1356 
rt.1923:
	lw	%x9 16(%x4)	# 1365 
	lw	%x10 12(%x4)	# 1365 
	lw	%x11 8(%x4)	# 1365 
	lw	%x12 4(%x4)	# 1365 
	sw	%x6 0(%x9)	# 1365 
	sw	%x7 4(%x9)	# 1366 
	sw	%x8 0(%x12)	# 1367 
	sw	%x10 0(%x2)	# 1368 
	add	%x4 %x0 %x11	# 1368 
	sw	%x1 4(%x2)	# 1368 
	lw	%x5 0(%x4)	# 1368 
	addi	%x2 %x2 8	# 1368 
	jalr	%x1 %x5	# 1368 
	addi	%x2 %x2 -8	# 1368 
	lw	%x1 4(%x2)	# 1368 
	lw	%x4 0(%x2)	# 1369 
	lw	%x5 0(%x4)	# 1369 
	jr	0(%x5)	# 1369 
	nop	# 1369 
min_caml_start:
	addi	%x6 %x0 0	# 20 
	addi	%x7 %x0 l.3996	# 20 
	flw	%f1 (0)%x7	# 20 
	sw	%x1 4(%x2)	# 20 
	addi	%x2 %x2 8	# 20 
	jal	 %x1 min_caml_create_float_array	# 20 
	addi	%x2 %x2 -8	# 20 
	lw	%x1 4(%x2)	# 20 
	addi	%x7 %x0 60	# 21 
	addi	%x8 %x0 0	# 22 
	addi	%x9 %x0 0	# 22 
	addi	%x10 %x0 0	# 22 
	addi	%x11 %x0 0	# 22 
	addi	%x12 %x0 0	# 24 
	add	%x13 %x0 %x3	# 22 
	addi	%x3 %x3 40	# 22 
	sw	%x6 36(%x13)	# 22 
	sw	%x6 32(%x13)	# 22 
	sw	%x6 28(%x13)	# 22 
	sw	%x12 24(%x13)	# 22 
	sw	%x6 20(%x13)	# 22 
	sw	%x6 16(%x13)	# 22 
	sw	%x11 12(%x13)	# 22 
	sw	%x10 8(%x13)	# 22 
	sw	%x9 4(%x13)	# 22 
	sw	%x8 0(%x13)	# 22 
	add	%x6 %x0 %x13	# 22 
	add	%x5 %x0 %x7	# 21 
	add	%x7 %x0 %x6	# 21 
	add	%x6 %x0 %x5	# 21 
	sw	%x1 4(%x2)	# 21 
	addi	%x2 %x2 8	# 21 
	jal	 %x1 min_caml_create_array	# 21 
	addi	%x2 %x2 -8	# 21 
	lw	%x1 4(%x2)	# 21 
	addi	%x7 %x0 2	# 29 
	addi	%x8 %x0 128	# 29 
	sw	%x6 0(%x2)	# 29 
	add	%x6 %x0 %x7	# 29 
	add	%x7 %x0 %x8	# 29 
	sw	%x1 4(%x2)	# 29 
	addi	%x2 %x2 8	# 29 
	jal	 %x1 min_caml_create_array	# 29 
	addi	%x2 %x2 -8	# 29 
	lw	%x1 4(%x2)	# 29 
	addi	%x7 %x0 1	# 32 
	addi	%x8 %x0 1	# 32 
	sw	%x6 4(%x2)	# 32 
	add	%x6 %x0 %x7	# 32 
	add	%x7 %x0 %x8	# 32 
	sw	%x1 12(%x2)	# 32 
	addi	%x2 %x2 16	# 32 
	jal	 %x1 min_caml_create_array	# 32 
	addi	%x2 %x2 -16	# 32 
	lw	%x1 12(%x2)	# 32 
	addi	%x7 %x0 3	# 35 
	addi	%x8 %x0 l.3996	# 35 
	flw	%f1 (0)%x8	# 35 
	sw	%x6 8(%x2)	# 35 
	add	%x6 %x0 %x7	# 35 
	sw	%x1 12(%x2)	# 35 
	addi	%x2 %x2 16	# 35 
	jal	 %x1 min_caml_create_float_array	# 35 
	addi	%x2 %x2 -16	# 35 
	lw	%x1 12(%x2)	# 35 
	addi	%x7 %x0 3	# 38 
	addi	%x8 %x0 l.3996	# 38 
	flw	%f1 (0)%x8	# 38 
	sw	%x6 12(%x2)	# 38 
	add	%x6 %x0 %x7	# 38 
	sw	%x1 20(%x2)	# 38 
	addi	%x2 %x2 24	# 38 
	jal	 %x1 min_caml_create_float_array	# 38 
	addi	%x2 %x2 -24	# 38 
	lw	%x1 20(%x2)	# 38 
	addi	%x7 %x0 3	# 41 
	addi	%x8 %x0 l.3996	# 41 
	flw	%f1 (0)%x8	# 41 
	sw	%x6 16(%x2)	# 41 
	add	%x6 %x0 %x7	# 41 
	sw	%x1 20(%x2)	# 41 
	addi	%x2 %x2 24	# 41 
	jal	 %x1 min_caml_create_float_array	# 41 
	addi	%x2 %x2 -24	# 41 
	lw	%x1 20(%x2)	# 41 
	addi	%x7 %x0 3	# 44 
	addi	%x8 %x0 l.3996	# 44 
	flw	%f1 (0)%x8	# 44 
	sw	%x6 20(%x2)	# 44 
	add	%x6 %x0 %x7	# 44 
	sw	%x1 28(%x2)	# 44 
	addi	%x2 %x2 32	# 44 
	jal	 %x1 min_caml_create_float_array	# 44 
	addi	%x2 %x2 -32	# 44 
	lw	%x1 28(%x2)	# 44 
	addi	%x7 %x0 2	# 47 
	addi	%x8 %x0 l.3996	# 47 
	flw	%f1 (0)%x8	# 47 
	sw	%x6 24(%x2)	# 47 
	add	%x6 %x0 %x7	# 47 
	sw	%x1 28(%x2)	# 47 
	addi	%x2 %x2 32	# 47 
	jal	 %x1 min_caml_create_float_array	# 47 
	addi	%x2 %x2 -32	# 47 
	lw	%x1 28(%x2)	# 47 
	addi	%x7 %x0 2	# 49 
	addi	%x8 %x0 l.3996	# 49 
	flw	%f1 (0)%x8	# 49 
	sw	%x6 28(%x2)	# 49 
	add	%x6 %x0 %x7	# 49 
	sw	%x1 36(%x2)	# 49 
	addi	%x2 %x2 40	# 49 
	jal	 %x1 min_caml_create_float_array	# 49 
	addi	%x2 %x2 -40	# 49 
	lw	%x1 36(%x2)	# 49 
	addi	%x7 %x0 1	# 52 
	addi	%x8 %x0 l.4417	# 52 
	flw	%f1 (0)%x8	# 52 
	sw	%x6 32(%x2)	# 52 
	add	%x6 %x0 %x7	# 52 
	sw	%x1 36(%x2)	# 52 
	addi	%x2 %x2 40	# 52 
	jal	 %x1 min_caml_create_float_array	# 52 
	addi	%x2 %x2 -40	# 52 
	lw	%x1 36(%x2)	# 52 
	addi	%x7 %x0 50	# 55 
	addi	%x8 %x0 1	# 55 
	addi	%x9 %x0 -1	# 55 
	sw	%x6 36(%x2)	# 55 
	sw	%x7 40(%x2)	# 55 
	add	%x7 %x0 %x9	# 55 
	add	%x6 %x0 %x8	# 55 
	sw	%x1 44(%x2)	# 55 
	addi	%x2 %x2 48	# 55 
	jal	 %x1 min_caml_create_array	# 55 
	addi	%x2 %x2 -48	# 55 
	lw	%x1 44(%x2)	# 55 
	add	%x7 %x0 %x6	# 55 
	lw	%x6 40(%x2)	# 55 
	sw	%x1 44(%x2)	# 55 
	addi	%x2 %x2 48	# 55 
	jal	 %x1 min_caml_create_array	# 55 
	addi	%x2 %x2 -48	# 55 
	lw	%x1 44(%x2)	# 55 
	addi	%x7 %x0 1	# 58 
	addi	%x8 %x0 1	# 58 
	lw	%x9 0(%x6)	# 58 
	sw	%x6 44(%x2)	# 58 
	sw	%x7 48(%x2)	# 58 
	add	%x7 %x0 %x9	# 58 
	add	%x6 %x0 %x8	# 58 
	sw	%x1 52(%x2)	# 58 
	addi	%x2 %x2 56	# 58 
	jal	 %x1 min_caml_create_array	# 58 
	addi	%x2 %x2 -56	# 58 
	lw	%x1 52(%x2)	# 58 
	add	%x7 %x0 %x6	# 58 
	lw	%x6 48(%x2)	# 58 
	sw	%x1 52(%x2)	# 58 
	addi	%x2 %x2 56	# 58 
	jal	 %x1 min_caml_create_array	# 58 
	addi	%x2 %x2 -56	# 58 
	lw	%x1 52(%x2)	# 58 
	addi	%x7 %x0 14	# 62 
	addi	%x8 %x0 l.3996	# 62 
	flw	%f1 (0)%x8	# 62 
	sw	%x6 52(%x2)	# 62 
	add	%x6 %x0 %x7	# 62 
	sw	%x1 60(%x2)	# 62 
	addi	%x2 %x2 64	# 62 
	jal	 %x1 min_caml_create_float_array	# 62 
	addi	%x2 %x2 -64	# 62 
	lw	%x1 60(%x2)	# 62 
	addi	%x6 %x0 16	# 64 
	addi	%x7 %x0 l.3996	# 64 
	flw	%f1 (0)%x7	# 64 
	sw	%x1 60(%x2)	# 64 
	addi	%x2 %x2 64	# 64 
	jal	 %x1 min_caml_create_float_array	# 64 
	addi	%x2 %x2 -64	# 64 
	lw	%x1 60(%x2)	# 64 
	addi	%x7 %x0 1	# 69 
	addi	%x8 %x0 l.3996	# 69 
	flw	%f1 (0)%x8	# 69 
	sw	%x6 56(%x2)	# 69 
	add	%x6 %x0 %x7	# 69 
	sw	%x1 60(%x2)	# 69 
	addi	%x2 %x2 64	# 69 
	jal	 %x1 min_caml_create_float_array	# 69 
	addi	%x2 %x2 -64	# 69 
	lw	%x1 60(%x2)	# 69 
	addi	%x7 %x0 3	# 72 
	addi	%x8 %x0 l.3996	# 72 
	flw	%f1 (0)%x8	# 72 
	sw	%x6 60(%x2)	# 72 
	add	%x6 %x0 %x7	# 72 
	sw	%x1 68(%x2)	# 72 
	addi	%x2 %x2 72	# 72 
	jal	 %x1 min_caml_create_float_array	# 72 
	addi	%x2 %x2 -72	# 72 
	lw	%x1 68(%x2)	# 72 
	addi	%x7 %x0 1	# 75 
	addi	%x8 %x0 0	# 75 
	sw	%x6 64(%x2)	# 75 
	add	%x6 %x0 %x7	# 75 
	add	%x7 %x0 %x8	# 75 
	sw	%x1 68(%x2)	# 75 
	addi	%x2 %x2 72	# 75 
	jal	 %x1 min_caml_create_array	# 75 
	addi	%x2 %x2 -72	# 75 
	lw	%x1 68(%x2)	# 75 
	addi	%x7 %x0 1	# 78 
	addi	%x8 %x0 l.4332	# 78 
	flw	%f1 (0)%x8	# 78 
	sw	%x6 68(%x2)	# 78 
	add	%x6 %x0 %x7	# 78 
	sw	%x1 76(%x2)	# 78 
	addi	%x2 %x2 80	# 78 
	jal	 %x1 min_caml_create_float_array	# 78 
	addi	%x2 %x2 -80	# 78 
	lw	%x1 76(%x2)	# 78 
	addi	%x7 %x0 3	# 81 
	addi	%x8 %x0 l.3996	# 81 
	flw	%f1 (0)%x8	# 81 
	sw	%x6 72(%x2)	# 81 
	add	%x6 %x0 %x7	# 81 
	sw	%x1 76(%x2)	# 81 
	addi	%x2 %x2 80	# 81 
	jal	 %x1 min_caml_create_float_array	# 81 
	addi	%x2 %x2 -80	# 81 
	lw	%x1 76(%x2)	# 81 
	addi	%x7 %x0 1	# 84 
	addi	%x8 %x0 0	# 84 
	sw	%x6 76(%x2)	# 84 
	add	%x6 %x0 %x7	# 84 
	add	%x7 %x0 %x8	# 84 
	sw	%x1 84(%x2)	# 84 
	addi	%x2 %x2 88	# 84 
	jal	 %x1 min_caml_create_array	# 84 
	addi	%x2 %x2 -88	# 84 
	lw	%x1 84(%x2)	# 84 
	addi	%x7 %x0 1	# 87 
	addi	%x8 %x0 0	# 87 
	sw	%x6 80(%x2)	# 87 
	add	%x6 %x0 %x7	# 87 
	add	%x7 %x0 %x8	# 87 
	sw	%x1 84(%x2)	# 87 
	addi	%x2 %x2 88	# 87 
	jal	 %x1 min_caml_create_array	# 87 
	addi	%x2 %x2 -88	# 87 
	lw	%x1 84(%x2)	# 87 
	addi	%x7 %x0 3	# 90 
	addi	%x8 %x0 l.3996	# 90 
	flw	%f1 (0)%x8	# 90 
	sw	%x6 84(%x2)	# 90 
	add	%x6 %x0 %x7	# 90 
	sw	%x1 92(%x2)	# 90 
	addi	%x2 %x2 96	# 90 
	jal	 %x1 min_caml_create_float_array	# 90 
	addi	%x2 %x2 -96	# 90 
	lw	%x1 92(%x2)	# 90 
	addi	%x7 %x0 3	# 93 
	addi	%x8 %x0 l.3996	# 93 
	flw	%f1 (0)%x8	# 93 
	sw	%x6 88(%x2)	# 93 
	add	%x6 %x0 %x7	# 93 
	sw	%x1 92(%x2)	# 93 
	addi	%x2 %x2 96	# 93 
	jal	 %x1 min_caml_create_float_array	# 93 
	addi	%x2 %x2 -96	# 93 
	lw	%x1 92(%x2)	# 93 
	addi	%x7 %x0 3	# 96 
	addi	%x8 %x0 l.3996	# 96 
	flw	%f1 (0)%x8	# 96 
	sw	%x6 92(%x2)	# 96 
	add	%x6 %x0 %x7	# 96 
	sw	%x1 100(%x2)	# 96 
	addi	%x2 %x2 104	# 96 
	jal	 %x1 min_caml_create_float_array	# 96 
	addi	%x2 %x2 -104	# 96 
	lw	%x1 100(%x2)	# 96 
	addi	%x7 %x0 3	# 99 
	addi	%x8 %x0 l.3996	# 99 
	flw	%f1 (0)%x8	# 99 
	sw	%x6 96(%x2)	# 99 
	add	%x6 %x0 %x7	# 99 
	sw	%x1 100(%x2)	# 99 
	addi	%x2 %x2 104	# 99 
	jal	 %x1 min_caml_create_float_array	# 99 
	addi	%x2 %x2 -104	# 99 
	lw	%x1 100(%x2)	# 99 
	addi	%x7 %x0 3	# 102 
	addi	%x8 %x0 l.3996	# 102 
	flw	%f1 (0)%x8	# 102 
	sw	%x6 100(%x2)	# 102 
	add	%x6 %x0 %x7	# 102 
	sw	%x1 108(%x2)	# 102 
	addi	%x2 %x2 112	# 102 
	jal	 %x1 min_caml_create_float_array	# 102 
	addi	%x2 %x2 -112	# 102 
	lw	%x1 108(%x2)	# 102 
	addi	%x7 %x0 3	# 105 
	addi	%x8 %x0 l.3996	# 105 
	flw	%f1 (0)%x8	# 105 
	sw	%x6 104(%x2)	# 105 
	add	%x6 %x0 %x7	# 105 
	sw	%x1 108(%x2)	# 105 
	addi	%x2 %x2 112	# 105 
	jal	 %x1 min_caml_create_float_array	# 105 
	addi	%x2 %x2 -112	# 105 
	lw	%x1 108(%x2)	# 105 
	addi	%x7 %x0 3	# 108 
	addi	%x8 %x0 l.3996	# 108 
	flw	%f1 (0)%x8	# 108 
	sw	%x6 108(%x2)	# 108 
	add	%x6 %x0 %x7	# 108 
	sw	%x1 116(%x2)	# 108 
	addi	%x2 %x2 120	# 108 
	jal	 %x1 min_caml_create_float_array	# 108 
	addi	%x2 %x2 -120	# 108 
	lw	%x1 116(%x2)	# 108 
	addi	%x7 %x0 3	# 112 
	addi	%x8 %x0 l.3996	# 112 
	flw	%f1 (0)%x8	# 112 
	sw	%x6 112(%x2)	# 112 
	add	%x6 %x0 %x7	# 112 
	sw	%x1 116(%x2)	# 112 
	addi	%x2 %x2 120	# 112 
	jal	 %x1 min_caml_create_float_array	# 112 
	addi	%x2 %x2 -120	# 112 
	lw	%x1 116(%x2)	# 112 
	addi	%x7 %x0 1	# 115 
	addi	%x8 %x0 l.3996	# 115 
	flw	%f1 (0)%x8	# 115 
	sw	%x6 116(%x2)	# 115 
	add	%x6 %x0 %x7	# 115 
	sw	%x1 124(%x2)	# 115 
	addi	%x2 %x2 128	# 115 
	jal	 %x1 min_caml_create_float_array	# 115 
	addi	%x2 %x2 -128	# 115 
	lw	%x1 124(%x2)	# 115 
	addi	%x7 %x0 1	# 117 
	addi	%x8 %x0 l.3996	# 117 
	flw	%f1 (0)%x8	# 117 
	sw	%x6 120(%x2)	# 117 
	add	%x6 %x0 %x7	# 117 
	sw	%x1 124(%x2)	# 117 
	addi	%x2 %x2 128	# 117 
	jal	 %x1 min_caml_create_float_array	# 117 
	addi	%x2 %x2 -128	# 117 
	lw	%x1 124(%x2)	# 117 
	addi	%x7 %x0 1	# 119 
	addi	%x8 %x0 l.3996	# 119 
	flw	%f1 (0)%x8	# 119 
	sw	%x6 124(%x2)	# 119 
	add	%x6 %x0 %x7	# 119 
	sw	%x1 132(%x2)	# 119 
	addi	%x2 %x2 136	# 119 
	jal	 %x1 min_caml_create_float_array	# 119 
	addi	%x2 %x2 -136	# 119 
	lw	%x1 132(%x2)	# 119 
	addi	%x7 %x0 1	# 121 
	addi	%x8 %x0 l.3996	# 121 
	flw	%f1 (0)%x8	# 121 
	sw	%x6 128(%x2)	# 121 
	add	%x6 %x0 %x7	# 121 
	sw	%x1 132(%x2)	# 121 
	addi	%x2 %x2 136	# 121 
	jal	 %x1 min_caml_create_float_array	# 121 
	addi	%x2 %x2 -136	# 121 
	lw	%x1 132(%x2)	# 121 
	addi	%x7 %x0 3	# 123 
	addi	%x8 %x0 l.3996	# 123 
	flw	%f1 (0)%x8	# 123 
	sw	%x6 132(%x2)	# 123 
	add	%x6 %x0 %x7	# 123 
	sw	%x1 140(%x2)	# 123 
	addi	%x2 %x2 144	# 123 
	jal	 %x1 min_caml_create_float_array	# 123 
	addi	%x2 %x2 -144	# 123 
	lw	%x1 140(%x2)	# 123 
	add	%x7 %x0 %x3	# 348 
	addi	%x3 %x3 32	# 348 
	addi	%x8 %x0 read_environ.1811	# 348 
	sw	%x8 0(%x7)	# 348 
	lw	%x8 16(%x2)	# 348 
	sw	%x8 28(%x7)	# 348 
	lw	%x9 20(%x2)	# 348 
	sw	%x9 24(%x7)	# 348 
	lw	%x10 32(%x2)	# 348 
	sw	%x10 20(%x7)	# 348 
	lw	%x11 12(%x2)	# 348 
	sw	%x11 16(%x7)	# 348 
	lw	%x11 24(%x2)	# 348 
	sw	%x11 12(%x7)	# 348 
	lw	%x12 28(%x2)	# 348 
	sw	%x12 8(%x7)	# 348 
	lw	%x13 36(%x2)	# 348 
	sw	%x13 4(%x7)	# 348 
	add	%x14 %x0 %x3	# 390 
	addi	%x3 %x3 12	# 390 
	addi	%x15 %x0 read_nth_object.1813	# 390 
	sw	%x15 0(%x14)	# 390 
	lw	%x15 0(%x2)	# 390 
	sw	%x15 8(%x14)	# 390 
	lw	%x16 56(%x2)	# 390 
	sw	%x16 4(%x14)	# 390 
	add	%x16 %x0 %x3	# 519 
	addi	%x3 %x3 8	# 519 
	addi	%x17 %x0 read_object.1815	# 519 
	sw	%x17 0(%x16)	# 519 
	sw	%x14 4(%x16)	# 519 
	add	%x14 %x0 %x3	# 528 
	addi	%x3 %x3 8	# 528 
	addi	%x17 %x0 read_all_object.1817	# 528 
	sw	%x17 0(%x14)	# 528 
	sw	%x16 4(%x14)	# 528 
	add	%x16 %x0 %x3	# 555 
	addi	%x3 %x3 8	# 555 
	addi	%x17 %x0 read_and_network.1823	# 555 
	sw	%x17 0(%x16)	# 555 
	lw	%x17 44(%x2)	# 555 
	sw	%x17 4(%x16)	# 555 
	add	%x18 %x0 %x3	# 565 
	addi	%x3 %x3 20	# 565 
	addi	%x19 %x0 read_parameter.1825	# 565 
	sw	%x19 0(%x18)	# 565 
	sw	%x7 16(%x18)	# 565 
	sw	%x16 12(%x18)	# 565 
	sw	%x14 8(%x18)	# 565 
	lw	%x7 52(%x2)	# 565 
	sw	%x7 4(%x18)	# 565 
	add	%x14 %x0 %x3	# 588 
	addi	%x3 %x3 12	# 588 
	addi	%x16 %x0 solver_rect.1827	# 588 
	sw	%x16 0(%x14)	# 588 
	lw	%x16 104(%x2)	# 588 
	sw	%x16 8(%x14)	# 588 
	lw	%x19 60(%x2)	# 588 
	sw	%x19 4(%x14)	# 588 
	add	%x20 %x0 %x3	# 643 
	addi	%x3 %x3 12	# 643 
	addi	%x21 %x0 solver_surface.1830	# 643 
	sw	%x21 0(%x20)	# 643 
	sw	%x16 8(%x20)	# 643 
	sw	%x19 4(%x20)	# 643 
	add	%x21 %x0 %x3	# 670 
	addi	%x3 %x3 8	# 670 
	addi	%x22 %x0 solver2nd_mul_b.1839	# 670 
	sw	%x22 0(%x21)	# 670 
	sw	%x16 4(%x21)	# 670 
	add	%x22 %x0 %x3	# 677 
	addi	%x3 %x3 8	# 677 
	addi	%x23 %x0 solver2nd_rot_b.1842	# 677 
	sw	%x23 0(%x22)	# 677 
	sw	%x16 4(%x22)	# 677 
	add	%x23 %x0 %x3	# 684 
	addi	%x3 %x3 20	# 684 
	addi	%x24 %x0 solver_second.1845	# 684 
	sw	%x24 0(%x23)	# 684 
	sw	%x16 16(%x23)	# 684 
	sw	%x19 12(%x23)	# 684 
	sw	%x22 8(%x23)	# 684 
	sw	%x21 4(%x23)	# 684 
	add	%x21 %x0 %x3	# 726 
	addi	%x3 %x3 24	# 726 
	addi	%x22 %x0 solver.1848	# 726 
	sw	%x22 0(%x21)	# 726 
	sw	%x16 20(%x21)	# 726 
	sw	%x20 16(%x21)	# 726 
	sw	%x23 12(%x21)	# 726 
	sw	%x14 8(%x21)	# 726 
	sw	%x15 4(%x21)	# 726 
	add	%x14 %x0 %x3	# 742 
	addi	%x3 %x3 8	# 742 
	addi	%x16 %x0 is_rect_outside.1852	# 742 
	sw	%x16 0(%x14)	# 742 
	lw	%x16 112(%x2)	# 742 
	sw	%x16 4(%x14)	# 742 
	add	%x20 %x0 %x3	# 754 
	addi	%x3 %x3 8	# 754 
	addi	%x22 %x0 is_plane_outside.1854	# 754 
	sw	%x22 0(%x20)	# 754 
	sw	%x16 4(%x20)	# 754 
	add	%x22 %x0 %x3	# 763 
	addi	%x3 %x3 8	# 763 
	addi	%x23 %x0 is_second_outside.1856	# 763 
	sw	%x23 0(%x22)	# 763 
	sw	%x16 4(%x22)	# 763 
	add	%x23 %x0 %x3	# 777 
	addi	%x3 %x3 24	# 777 
	addi	%x24 %x0 is_outside.1858	# 777 
	sw	%x24 0(%x23)	# 777 
	sw	%x16 20(%x23)	# 777 
	sw	%x22 16(%x23)	# 777 
	sw	%x14 12(%x23)	# 777 
	sw	%x20 8(%x23)	# 777 
	lw	%x14 108(%x2)	# 777 
	sw	%x14 4(%x23)	# 777 
	add	%x16 %x0 %x3	# 792 
	addi	%x3 %x3 12	# 792 
	addi	%x20 %x0 check_all_inside.1860	# 792 
	sw	%x20 0(%x16)	# 792 
	sw	%x15 8(%x16)	# 792 
	sw	%x23 4(%x16)	# 792 
	add	%x20 %x0 %x3	# 807 
	addi	%x3 %x3 28	# 807 
	addi	%x22 %x0 shadow_check_and_group.1863	# 807 
	sw	%x22 0(%x20)	# 807 
	sw	%x19 24(%x20)	# 807 
	sw	%x21 20(%x20)	# 807 
	sw	%x15 16(%x20)	# 807 
	sw	%x11 12(%x20)	# 807 
	sw	%x14 8(%x20)	# 807 
	sw	%x16 4(%x20)	# 807 
	add	%x22 %x0 %x3	# 842 
	addi	%x3 %x3 12	# 842 
	addi	%x23 %x0 shadow_check_one_or_group.1867	# 842 
	sw	%x23 0(%x22)	# 842 
	sw	%x20 8(%x22)	# 842 
	sw	%x17 4(%x22)	# 842 
	add	%x20 %x0 %x3	# 856 
	addi	%x3 %x3 20	# 856 
	addi	%x23 %x0 shadow_check_one_or_matrix.1871	# 856 
	sw	%x23 0(%x20)	# 856 
	sw	%x19 16(%x20)	# 856 
	sw	%x21 12(%x20)	# 856 
	sw	%x22 8(%x20)	# 856 
	sw	%x11 4(%x20)	# 856 
	add	%x22 %x0 %x3	# 888 
	addi	%x3 %x3 52	# 888 
	addi	%x23 %x0 solve_each_element.1875	# 888 
	sw	%x23 0(%x22)	# 888 
	lw	%x23 64(%x2)	# 888 
	sw	%x23 48(%x22)	# 888 
	lw	%x24 88(%x2)	# 888 
	sw	%x24 44(%x22)	# 888 
	lw	%x25 72(%x2)	# 888 
	sw	%x25 40(%x22)	# 888 
	sw	%x19 36(%x22)	# 888 
	sw	%x21 32(%x22)	# 888 
	sw	%x15 28(%x22)	# 888 
	lw	%x26 68(%x2)	# 888 
	sw	%x26 24(%x22)	# 888 
	lw	%x27 84(%x2)	# 888 
	sw	%x27 20(%x22)	# 888 
	lw	%x28 76(%x2)	# 888 
	sw	%x28 16(%x22)	# 888 
	lw	%x29 80(%x2)	# 888 
	sw	%x29 12(%x22)	# 888 
	sw	%x14 8(%x22)	# 888 
	sw	%x16 4(%x22)	# 888 
	add	%x14 %x0 %x3	# 932 
	addi	%x3 %x3 16	# 932 
	addi	%x16 %x0 solve_one_or_network.1878	# 932 
	sw	%x16 0(%x14)	# 932 
	sw	%x22 12(%x14)	# 932 
	sw	%x27 8(%x14)	# 932 
	sw	%x17 4(%x14)	# 932 
	add	%x16 %x0 %x3	# 944 
	addi	%x3 %x3 28	# 944 
	addi	%x17 %x0 trace_or_matrix.1881	# 944 
	sw	%x17 0(%x16)	# 944 
	sw	%x23 24(%x16)	# 944 
	sw	%x24 20(%x16)	# 944 
	sw	%x25 16(%x16)	# 944 
	sw	%x19 12(%x16)	# 944 
	sw	%x21 8(%x16)	# 944 
	sw	%x14 4(%x16)	# 944 
	add	%x14 %x0 %x3	# 972 
	addi	%x3 %x3 16	# 972 
	addi	%x17 %x0 tracer.1884	# 972 
	sw	%x17 0(%x14)	# 972 
	sw	%x16 12(%x14)	# 972 
	sw	%x25 8(%x14)	# 972 
	sw	%x7 4(%x14)	# 972 
	add	%x16 %x0 %x3	# 994 
	addi	%x3 %x3 16	# 994 
	addi	%x17 %x0 get_nvector_rect.1887	# 994 
	sw	%x17 0(%x16)	# 994 
	sw	%x23 12(%x16)	# 994 
	lw	%x17 92(%x2)	# 994 
	sw	%x17 8(%x16)	# 994 
	sw	%x26 4(%x16)	# 994 
	add	%x19 %x0 %x3	# 1019 
	addi	%x3 %x3 8	# 1019 
	addi	%x21 %x0 get_nvector_plane.1889	# 1019 
	sw	%x21 0(%x19)	# 1019 
	sw	%x17 4(%x19)	# 1019 
	add	%x21 %x0 %x3	# 1027 
	addi	%x3 %x3 8	# 1027 
	addi	%x22 %x0 get_nvector_second_norot.1891	# 1027 
	sw	%x22 0(%x21)	# 1027 
	sw	%x17 4(%x21)	# 1027 
	add	%x22 %x0 %x3	# 1036 
	addi	%x3 %x3 12	# 1036 
	addi	%x25 %x0 get_nvector_second_rot.1894	# 1036 
	sw	%x25 0(%x22)	# 1036 
	lw	%x25 116(%x2)	# 1036 
	sw	%x25 8(%x22)	# 1036 
	sw	%x17 4(%x22)	# 1036 
	add	%x25 %x0 %x3	# 1053 
	addi	%x3 %x3 20	# 1053 
	addi	%x26 %x0 get_nvector.1897	# 1053 
	sw	%x26 0(%x25)	# 1053 
	sw	%x22 16(%x25)	# 1053 
	sw	%x21 12(%x25)	# 1053 
	sw	%x16 8(%x25)	# 1053 
	sw	%x19 4(%x25)	# 1053 
	add	%x16 %x0 %x3	# 1069 
	addi	%x3 %x3 8	# 1069 
	addi	%x19 %x0 utexture.1900	# 1069 
	sw	%x19 0(%x16)	# 1069 
	lw	%x19 100(%x2)	# 1069 
	sw	%x19 4(%x16)	# 1069 
	add	%x21 %x0 %x3	# 1162 
	addi	%x3 %x3 64	# 1162 
	addi	%x22 %x0 raytracing.1910	# 1162 
	sw	%x22 0(%x21)	# 1162 
	sw	%x23 60(%x21)	# 1162 
	sw	%x24 56(%x21)	# 1162 
	sw	%x16 52(%x21)	# 1162 
	sw	%x14 48(%x21)	# 1162 
	sw	%x19 44(%x21)	# 1162 
	sw	%x20 40(%x21)	# 1162 
	lw	%x14 96(%x2)	# 1162 
	sw	%x14 36(%x21)	# 1162 
	sw	%x7 32(%x21)	# 1162 
	sw	%x15 28(%x21)	# 1162 
	sw	%x17 24(%x21)	# 1162 
	sw	%x11 20(%x21)	# 1162 
	sw	%x25 16(%x21)	# 1162 
	sw	%x28 12(%x21)	# 1162 
	sw	%x29 8(%x21)	# 1162 
	sw	%x13 4(%x21)	# 1162 
	add	%x7 %x0 %x3	# 1250 
	addi	%x3 %x3 8	# 1250 
	addi	%x11 %x0 write_rgb.1913	# 1250 
	sw	%x11 0(%x7)	# 1250 
	sw	%x14 4(%x7)	# 1250 
	add	%x11 %x0 %x3	# 1267 
	addi	%x3 %x3 8	# 1267 
	addi	%x13 %x0 write_ppm_header.1915	# 1267 
	sw	%x13 0(%x11)	# 1267 
	lw	%x13 4(%x2)	# 1267 
	sw	%x13 4(%x11)	# 1267 
	add	%x15 %x0 %x3	# 1283 
	addi	%x3 %x3 64	# 1283 
	addi	%x16 %x0 scan_point.1917	# 1283 
	sw	%x16 0(%x15)	# 1283 
	sw	%x6 60(%x15)	# 1283 
	sw	%x7 56(%x15)	# 1283 
	sw	%x23 52(%x15)	# 1283 
	sw	%x8 48(%x15)	# 1283 
	sw	%x24 44(%x15)	# 1283 
	sw	%x9 40(%x15)	# 1283 
	sw	%x13 36(%x15)	# 1283 
	sw	%x10 32(%x15)	# 1283 
	lw	%x7 128(%x2)	# 1283 
	sw	%x7 28(%x15)	# 1283 
	lw	%x9 124(%x2)	# 1283 
	sw	%x9 24(%x15)	# 1283 
	lw	%x16 132(%x2)	# 1283 
	sw	%x16 20(%x15)	# 1283 
	lw	%x17 120(%x2)	# 1283 
	sw	%x17 16(%x15)	# 1283 
	sw	%x14 12(%x15)	# 1283 
	sw	%x21 8(%x15)	# 1283 
	sw	%x12 4(%x15)	# 1283 
	add	%x14 %x0 %x3	# 1321 
	addi	%x3 %x3 44	# 1321 
	addi	%x19 %x0 scan_line.1919	# 1321 
	sw	%x19 0(%x14)	# 1321 
	sw	%x6 40(%x14)	# 1321 
	sw	%x8 36(%x14)	# 1321 
	sw	%x13 32(%x14)	# 1321 
	sw	%x10 28(%x14)	# 1321 
	sw	%x7 24(%x14)	# 1321 
	sw	%x15 20(%x14)	# 1321 
	sw	%x9 16(%x14)	# 1321 
	sw	%x16 12(%x14)	# 1321 
	sw	%x17 8(%x14)	# 1321 
	sw	%x12 4(%x14)	# 1321 
	add	%x6 %x0 %x3	# 1349 
	addi	%x3 %x3 24	# 1349 
	addi	%x7 %x0 scan_start.1921	# 1349 
	sw	%x7 0(%x6)	# 1349 
	sw	%x11 20(%x6)	# 1349 
	sw	%x13 16(%x6)	# 1349 
	sw	%x9 12(%x6)	# 1349 
	sw	%x14 8(%x6)	# 1349 
	sw	%x17 4(%x6)	# 1349 
	add	%x4 %x0 %x3	# 1362 
	addi	%x3 %x3 20	# 1362 
	addi	%x7 %x0 rt.1923	# 1362 
	sw	%x7 0(%x4)	# 1362 
	sw	%x13 16(%x4)	# 1362 
	sw	%x6 12(%x4)	# 1362 
	sw	%x18 8(%x4)	# 1362 
	lw	%x6 8(%x2)	# 1362 
	sw	%x6 4(%x4)	# 1362 
	addi	%x6 %x0 768	# 1373 
	addi	%x7 %x0 768	# 1373 
	addi	%x8 %x0 0	# 1373 
	sw	%x1 140(%x2)	# 1373 
	lw	%x5 0(%x4)	# 1373 
	addi	%x2 %x2 144	# 1373 
	jalr	%x1 %x5	# 1373 
	addi	%x2 %x2 -144	# 1373 
	lw	%x1 140(%x2)	# 1373 
