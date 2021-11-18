exception Error of Syntax.t * Type.t * Type.t * Syntax.pos
val extenv : Type.t M.t ref
val output_env : out_channel -> Type.t M.t -> unit
val f : Syntax.t -> Syntax.t
