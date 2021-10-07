type position = int * int
type t = (* MinCamlの構文を表現するデータ型 (caml2html: syntax_t) *)
  | Unit
  | Bool of bool * position
  | Int of int * position
  | Float of float * position
  | Not of t * position
  | Neg of t * position
  | Add of t * t * position
  | Sub of t * t * position
  | FNeg of t * position
  | FAdd of t * t * position
  | FSub of t * t * position
  | FMul of t * t * position
  | FDiv of t * t * position
  | Eq of t * t * position
  | LE of t * t * position
  | If of t * t * t * position
  | Let of (Id.t * Type.t) * t * t * position
  | Var of Id.t * position
  | LetRec of fundef * t * position
  | App of t * t list * position
  | Tuple of t list * position
  | LetTuple of (Id.t * Type.t) list * t * t * position
  | Array of t * t * position
  | Get of t * t * position
  | Put of t * t * t * position
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }
let top_position:position = (1, 1);;
