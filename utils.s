min_caml_read_int:
    addi %x6 %x0 0
    addi %x7 %x0 1
    addi %x8 %x0 20
    addi %x9 %x0 8
    sll %x7 %x7 %x8
    addi %x7 %x7 -3 #ロード可能かどうかのフラグが格納されているアドレス
load_int_size1:
    lbu %x8 0(%x7) # フラグを読む
    beq %x8 %x0 load_int_size1 # フラグがゼロだったら読み直し
    lbu %x8 1(%x7) # 1だったらデータを1バイト読む
    add %x6 %x6 %x8
    sll %x6 %x6 %x9 # 左に8ビットシフト
load_int_size2:
    lbu %x8 0(%x7) # フラグを読む
    beq %x8 %x0 load_int_size2 # フラグがゼロだったら読み直し
    lbu %x8 1(%x7) # 1だったらデータを1バイト読む
    add %x6 %x6 %x8
    sll %x6 %x6 %x9 # 左に8ビットシフト
load_int_size3:
    lbu %x8 0(%x7) # フラグを読む
    beq %x8 %x0 load_int_size3 # フラグがゼロだったら読み直し
    lbu %x8 1(%x7) # 1だったらデータを1バイト読む
    add %x6 %x6 %x8
    sll %x6 %x6 %x9 # 左に8ビットシフト
load_int_size4:
    lbu %x8 0(%x7) # フラグを読む
    beq %x8 %x0 load_int_size4 # フラグがゼロだったら読み直し
    lbu %x8 1(%x7) # 1だったらデータを1バイト読む
    add %x6 %x6 %x8
    jr 0(%x1)
min_caml_read_float:
    addi %x6 %x0 0
    addi %x7 %x0 1
    addi %x8 %x0 20
    addi %x9 %x0 8
    sll %x7 %x7 %x8
    addi %x7 %x7 -3 # ロード可能かどうかのフラグが格納されているアドレス
load_float_size1:
    lbu %x8 0(%x7) # フラグを読む
    beq %x8 %x0 load_float_size1 # フラグがゼロだったら読み直し
    lbu %x8 1(%x7) # 1だったらデータを1バイト読む
    add %x6 %x6 %x8
    sll %x6 %x6 %x9 # 左に8ビットシフト
load_float_size2:
    lbu %x8 0(%x7) # フラグを読む
    beq %x8 %x0 load_float_size2 # フラグがゼロだったら読み直し
    lbu %x8 1(%x7) # 1だったらデータを1バイト読む
    add %x6 %x6 %x8
    sll %x6 %x6 %x9 # 左に8ビットシフト
load_float_size3:
    lbu %x8 0(%x7) # フラグを読む
    beq %x8 %x0 load_float_size3 # フラグがゼロだったら読み直し
    lbu %x8 1(%x7) # 1だったらデータを1バイト読む
    add %x6 %x6 %x8
    sll %x6 %x6 %x9 # 左に8ビットシフト
load_float_size4:
    lbu %x8 0(%x7) # フラグを読む
    beq %x8 %x0 load_float_size4 # フラグがゼロだったら読み直し
    lbu %x8 1(%x7) # 1だったらデータを1バイト読む
    add %x6 %x6 %x8
    sw %x6 -4(%x2)
    lw %f1 -4(%x2)
    jr 0(%x1)
min_caml_print_char:
    addi %x7 %x0 1 # x7 <- 1
    addi %x8 %x0 20 # x8 <- 20
    sll %x7 %x7 %x8 # x7 <- 0x100000
    addi %x7 %x7 -3 #ロード可能かどうかのフラグが格納されているアドレス x7 <- 0x100000 - 3
    sb %x6 2(%x7) # データを1バイト書く
    jr 0(%x1)
min_caml_float_of_int:
    itof %f1 %x6
    jr 0(%x1)
min_caml_int_of_float:
    ftoi %x6 %f1
    jr 0(%x1)
min_caml_sra:
    sra %x6 %x6 %x7
    jr 0(%x1)
min_caml_sll:
    sll %x6 %x6 %x7
    jr 0(%x1)
min_caml_create_array:
    add %x8 %x0 %x3 # 先頭アドレスを%x8に入れる
    bne %x6 %x0 create_array_loop # %x6がゼロでないなら戻る
    add %x6 %x0 %x8 # %x6がゼロなら先頭アドレスを%x6に入れる
    jr 0(%x1)
create_array_loop:
    sw %x7 0(%x3) # %x7を書き込む
    addi %x3 %x3 4 # reg_hpを進める
    addi %x6 %x6 -1 # %x6をデクリメント
    bne %x6 %x0 create_array_loop # %x6がゼロでないなら戻る
    add %x6 %x0 %x8 # %x6がゼロなら先頭アドレスを%x6に入れる
    jr 0(%x1)
min_caml_create_float_array:
    add %x8 %x0 %x3 # 先頭アドレスを%x8に入れる
    bne %x6 %x0 create_float_array_loop # %x6がゼロでないなら戻る
    add %x6 %x0 %x8 # %x6がゼロなら先頭アドレスを%x6に入れる
    jr 0(%x1)
create_float_array_loop:
    sw %f1 0(%x3) # %x7を書き込む
    addi %x3 %x3 4 # reg_hpを進める
    addi %x6 %x6 -1 # %x6をデクリメント
    bne %x6 %x0 create_float_array_loop # %x6がゼロでないなら戻る
    add %x6 %x0 %x8 # %x6がゼロなら先頭アドレスを%x6に入れる
    jr 0(%x1)
END