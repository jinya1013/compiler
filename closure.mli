type closure = { entry : Id.l; actual_fv : Id.t list }
type t = (* クロージャ変換後の式 (caml2html: closure_t) *)
  | Unit of Syntax.pos
  | Int of int * Syntax.pos
  | Float of float * Syntax.pos
  | Neg of Id.t * Syntax.pos
  | Add of Id.t * Id.t * Syntax.pos
  | Sub of Id.t * Id.t * Syntax.pos
  | FNeg of Id.t * Syntax.pos
  | FSqrt of Id.t * Syntax.pos
  | Floor of Id.t * Syntax.pos
  | FAdd of Id.t * Id.t * Syntax.pos
  | FSub of Id.t * Id.t * Syntax.pos
  | FMul of Id.t * Id.t * Syntax.pos
  | FDiv of Id.t * Id.t * Syntax.pos
  | IfEq of Id.t * Id.t * t * t * Syntax.pos
  | IfLE of Id.t * Id.t * t * t * Syntax.pos
  | Let of (Id.t * Type.t) * t * t * Syntax.pos
  | Loop of (Id.t * Type.t) * t * t * Syntax.pos
  | Recur of Id.t * Syntax.pos
  | Var of Id.t * Syntax.pos
  | MakeCls of (Id.t * Type.t) * closure * t * Syntax.pos  (*(関数名, 関数の型), クロージャ, 関数の本体 *)
  | AppCls of Id.t * Id.t list * Syntax.pos
  | AppDir of Id.l * Id.t list * Syntax.pos
  | Tuple of Id.t list * Syntax.pos
  | LetTuple of (Id.t * Type.t) list * Id.t * t * Syntax.pos
  | Get of Id.t * Id.t * Syntax.pos
  | Put of Id.t * Id.t * Id.t * Syntax.pos
  | ExtArray of Id.l * Syntax.pos
type fundef = { name : Id.l * Type.t;
                args : (Id.t * Type.t) list;
                formal_fv : (Id.t * Type.t) list;
                body : t }
type prog = Prog of fundef list * t

val fv : t -> S.t
val f : KNormal.t -> prog
val output_closure : out_channel -> t -> int -> unit
val output_funclosure : out_channel -> closure -> unit
val output_fundef : out_channel -> fundef -> int -> unit
val output_fundef_list : out_channel -> fundef list -> int -> unit
val output_prog : out_channel -> prog -> unit
val pos_of_t: t -> Syntax.pos
val loop_recur_dict : (Id.t, Type.t) M.t ref