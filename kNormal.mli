type t =
  | Unit of Syntax.position
  | Int of int * Syntax.position
  | Float of float* Syntax.position
  | Neg of Id.t * Syntax.position
  | Add of Id.t * Id.t * Syntax.position
  | Sub of Id.t * Id.t * Syntax.position
  | FNeg of Id.t * Syntax.position
  | FAdd of Id.t * Id.t * Syntax.position
  | FSub of Id.t * Id.t * Syntax.position
  | FMul of Id.t * Id.t * Syntax.position
  | FDiv of Id.t * Id.t * Syntax.position
  | IfEq of Id.t * Id.t * t * t * Syntax.position
  | IfLE of Id.t * Id.t * t * t * Syntax.position
  | Let of (Id.t * Type.t) * t * t * Syntax.position
  | Var of Id.t * Syntax.position
  | LetRec of fundef * t * Syntax.position
  | App of Id.t * Id.t list * Syntax.position
  | Tuple of Id.t list list * Syntax.position
  | LetTuple of (Id.t * Type.t) list * Id.t * t list * Syntax.position
  | Get of Id.t * Id.t list * Syntax.position
  | Put of Id.t * Id.t * Id.t list * Syntax.position
  | ExtArray of Id.t list * Syntax.position
  | ExtFunApp of Id.t * Id.t list list * Syntax.position
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }

val fv : t -> S.t
val f : Syntax.t -> t
