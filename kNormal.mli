type t = (* K��������μ� (caml2html: knormal_t) *)
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
  | IfEq of Id.t * Id.t * t * t  * Syntax.pos (* ��� + ʬ�� (caml2html: knormal_branch) *)
  | IfLE of Id.t * Id.t * t * t  * Syntax.pos (* ��� + ʬ�� *)
  | Let of (Id.t * Type.t) * t * t  * Syntax.pos
  | Var of Id.t * Syntax.pos
  | LetRec of fundef * t * Syntax.pos
  | App of Id.t * Id.t list * Syntax.pos
  | Tuple of Id.t list * Syntax.pos
  | LetTuple of (Id.t * Type.t) list * Id.t * t * Syntax.pos
  | Get of Id.t * Id.t * Syntax.pos
  | Put of Id.t * Id.t * Id.t * Syntax.pos
  | ExtArray of Id.t * Syntax.pos
  | ExtFunApp of Id.t * Id.t list * Syntax.pos
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }

val fv : t -> S.t
val f : Syntax.t -> t
val output_knormal : out_channel -> t  -> int -> unit
val output_prog : out_channel -> t  -> unit

