fib.10:
	addi	%x6 %x6 -1	# 2 
	ble	%x6 1 ble.24	# 2 
	nop	# 2 
	addi	%x6 %x6 1	# 2 
	addi	%x7 %x6 -1	# 3 
	sw	%x6 (0)%x2	# 3 
	add	%x6 %x0 %x7	# 3 
	sw	%x1 4(%x2)	# 3 
	addi	%x2 %x2 8	# 3 
	jalr	%x5	# 3 
	addi	%x2 %x2 -8	# 3 
	lw	%x1 4(%x2)	# 3 
	lw	%x7 0(%x2)	# 3 
	addi	%x7 %x7 -2	# 3 
	sw	%x6 (4)%x2	# 3 
	add	%x6 %x0 %x7	# 3 
	sw	%x1 12(%x2)	# 3 
	addi	%x2 %x2 16	# 3 
	jalr	%x5	# 3 
	addi	%x2 %x2 -16	# 3 
	lw	%x1 12(%x2)	# 3 
	lw	%x7 4(%x2)	# 3 
	add	%x6 %x7 %x6	# 3 
	jr	%x1	# 3 
	nop	# 3 
ble.24:	# 2 
	addi	%x6 %x6 1	# 2 
	jr	%x1	# 2 
	nop	# 2 
min_caml_start:
	addi	%x6 %x0 30	# 4 # x6に30をセット
	sw	%x1 4(%x2)	# 4 	# raをスタックに退避
	addi	%x2 %x2 8	# 4 
	jalr	%x5	# 4 
	addi	%x2 %x2 -8	# 4 
	lw	%x1 4(%x2)	# 4 
	sw	%x1 4(%x2)	# 4 
	addi	%x2 %x2 8	# 4 
	jalr	%x5	# 4 
	addi	%x2 %x2 -8	# 4 
	lw	%x1 4(%x2)	# 4 
