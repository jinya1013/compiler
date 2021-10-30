oepn Closure

type closure = { entry : Id.l; actual_fv : Id.t list } (* トップレベル関数のラベル, 自由変数のリスト *)
type t = (* クロージャ変換後の式 (caml2html: closure_t) *)
  | Unit of Syntax.pos
  | Int of int * Syntax.pos
  | Float of float * Syntax.pos
  | Neg of Id.t * Syntax.pos
  | Add of Id.t * Id.t * Syntax.pos
  | Sub of Id.t * Id.t * Syntax.pos
  | FNeg of Id.t * Syntax.pos
  | FAdd of Id.t * Id.t * Syntax.pos
  | FSub of Id.t * Id.t * Syntax.pos
  | FMul of Id.t * Id.t * Syntax.pos
  | FDiv of Id.t * Id.t * Syntax.pos
  | IfEq of Id.t * Id.t * t * t * Syntax.pos
  | IfLE of Id.t * Id.t * t * t * Syntax.pos
  | Let of (Id.t * Type.t) * t * t * Syntax.pos
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

let rec search_env key = function
  | (x, Tuple(xs, _)) :: envs when key = x -> xs
  | (x, Tuple(_)) :: envs -> search_env key envs
  | _ -> [key]

(* envは変数名とTuple式の組のリスト, flattenはフラット化されたタプルのリスト *)
let rec g fundef env flatten = function
| Let((x, t), e1, e2, p) ->
(
  let e1' = g env e1 in (*  *)
  match e1' with
  | Tuple(xs, q)  -> 
    let xs' = List.fold_left (fun acc x -> acc @ (search_env x env)) [] xs in (* xsの中にタプルがあればそれをバラす *)
    let e2' = g ((x, Tuple(xs', q)) :: env) ((x, (e1, ,Tuple(xs', q))) :: flatten) e2 in
    Let((x, t), e1', e2')
  | _ ->
    Let((x, t), e1', g env e2)
) 
| LetTuple(xts, y, e) ->
  match y with
  