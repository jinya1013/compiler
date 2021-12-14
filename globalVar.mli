val genv : int M.t ref
val gtenv : Type.t M.t ref
val output_env : out_channel -> (string * int) list -> unit
val gaddress : int ref
val f
 : out_channel -> Syntax.t -> Syntax.t