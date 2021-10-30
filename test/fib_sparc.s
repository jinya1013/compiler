.section	".rodata"
.align	8
.section	".text"
fib.10:
	cmp	%x6, 1	# 2 
	bg	ble_else.24	# 2 
	nop	# 2 
	retl	# 2 
	nop	# 2 
ble_else.24:	# 2 
	sub	%x6, 1, %x7	# 3 
	st	%x6, [%x2 + 0]	# 3 
	mov	%x7, %x6	# 3 
	st	%x1, [%x2 + 4]	# 3 
	call	fib.10	# 3 
	add	%x2, 8, %x2	! delay slot	# 3 
	sub	%x2, 8, %x2	# 3 
	ld	[%x2 + 4], %x1	# 3 
	ld	[%x2 + 0], %x7	# 3 
	sub	%x7, 2, %x7	# 3 
	st	%x6, [%x2 + 4]	# 3 
	mov	%x7, %x6	# 3 
	st	%x1, [%x2 + 12]	# 3 
	call	fib.10	# 3 
	add	%x2, 16, %x2	! delay slot	# 3 
	sub	%x2, 16, %x2	# 3 
	ld	[%x2 + 12], %x1	# 3 
	ld	[%x2 + 4], %x7	# 3 
	add	%x7, %x6, %x6	# 3 
	retl	# 3 
	nop	# 3 
.global	min_caml_start
min_caml_start:
	save	%sp, -112, %sp
	set	30, %x6	# 4 
	st	%x1, [%x2 + 4]	# 4 
	call	fib.10	# 4 
	add	%x2, 8, %x2	! delay slot	# 4 
	sub	%x2, 8, %x2	# 4 
	ld	[%x2 + 4], %x1	# 4 
	st	%x1, [%x2 + 4]	# 4 
	call	min_caml_print_int	# 4 
	add	%x2, 8, %x2	! delay slot	# 4 
	sub	%x2, 8, %x2	# 4 
	ld	[%x2 + 4], %x1	# 4 
	ret
	restore
