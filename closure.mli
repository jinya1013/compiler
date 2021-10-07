type closure = { entry : Id.l; actual_fv : Id.t list }
type t =
  | Unit of Syntax.position 
  | Int of int * Syntax.position 
  | Float of float * Syntax.position
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
  | MakeCls of (Id.t * Type.t) * closure * t * Syntax.position
  | AppCls of Id.t * Id.t list * Syntax.position
  | AppDir of Id.l * Id.t list * Syntax.position
  | Tuple of Id.t list * Syntax.position
  | LetTuple of (Id.t * Type.t) list * Id.t * t * Syntax.position
  | Get of Id.t * Id.t * Syntax.position
  | Put of Id.t * Id.t * Id.t * Syntax.position
  | ExtArray of Id.l * Syntax.position
type fundef = { name : Id.l * Type.t;
                args : (Id.t * Type.t) list;
                formal_fv : (Id.t * Type.t) list;
                body : t }
type prog = Prog of fundef list * t

val fv : t -> S.t
val f : KNormal.t -> prog
