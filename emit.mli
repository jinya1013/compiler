val is_minrt_cpuexp : bool ref
val hp_address : int ref
val sp_address : int ref
val ftp_address : int ref
val f : out_channel -> in_channel -> Asm.prog -> unit