open Syntax
let empty_env = []
let rec find_env f env =
  match env with
  | [] -> raise Not_found
  | (key, value)::xs -> 
    if (key = f) then value
    else find_env f xs
(* 
let rec concat_env e1 e2  *)
(* let rec make_env exp =
  match exp with
  | Not (e, p) -> make_env e
  | Neg (e, p) -> make_env e
  | Add (e1, e2, p) -> concat_env (make_env e1) (make_env e2)
  | Sub (e1, e2, p) -> concat_env (make_env e1) (make_env e2)
  | FNeg (e, p) -> make_env e
  | FAdd (e1, e2, p) -> concat_env (make_env e1) (make_env e2)
  | FSub (e1, e2, p) -> concat_env (make_env e1) (make_env e2)
  | FMul (e1, e2, p) -> concat_env (make_env e1) (make_env e2)
  | FDiv (e1, e2, p) -> concat_env (make_env e1) (make_env e2)
  | Eq (e1, e2, p) -> concat_env (make_env e1) (make_env e2)
  | LE (e1, e2, p) -> LE(make_env e1, make_env e2, p)
  | If (e1, e2, e3, p) -> If(make_env e1, make_env e2, make_env e3, p)
  | Let ((x, t), e1, e2, p) -> Let((x, t), make_env e1, make_env  env e2, p)
  | LetRec({ Syntax.name = (x, t); Syntax.args = yts; Syntax.body = e1 }, e2, p) ->
      (x, ) :: (make_env e2)
  | App (e1, lis, p) -> make_env e1
  | Tuple (lis, p) -> 
  | LetTuple (lis, e1, e2, p) -> 
  | Array (e1, e2, p)
  | Get (e1, e2, p)
  | Put (e1, e2, e3, p)
  | _ -> _ *)

let rec eta_expansion env exp =
  match exp with
  | Not (e, p) -> Not(eta_expansion env e, p)
  | Neg (e, p) -> Neg(eta_expansion env e, p)
  | Add (e1, e2, p) -> Add(eta_expansion env e1, eta_expansion env e2, p)
  | Sub (e1, e2, p) -> Sub(eta_expansion env e1, eta_expansion env e2, p)
  | FNeg (e, p) -> FNeg(eta_expansion env e, p)
  | FAdd (e1, e2, p) -> FAdd(eta_expansion env e1, eta_expansion env e2, p)
  | FSub (e1, e2, p) -> FSub(eta_expansion env e1, eta_expansion env e2, p)
  | FMul (e1, e2, p) -> FMul(eta_expansion env e1, eta_expansion env e2, p)
  | FDiv (e1, e2, p) -> FDiv(eta_expansion env e1, eta_expansion env e2, p)
  | Eq (e1, e2, p) -> Eq(eta_expansion env e1, eta_expansion env e2, p)
  | LE (e1, e2, p) -> LE(eta_expansion env e1, eta_expansion env e2, p)
  | If (e1, e2, e3, p) -> If(eta_expansion env e1, eta_expansion env e2, eta_expansion env e3, p)
  | Let ((x, t), e1, e2, p) -> Let((x, t), eta_expansion env e1, eta_expansion  env e2, p)
  | LetRec({ Syntax.name = (x, t); Syntax.args = yts; Syntax.body = e1 }, e2, p) ->
      let env' = (x,)::env in
      LetRec({ Syntax.name = (x, t); Syntax.args = yts; Syntax.body = eta_expansion (M.add_list yts env') e1 }, e2, p)
  | App (e1, lis, p) -> App((l))
  | Tuple (lis, p)
  | LetTuple (lis, e1, e2, p)
  | Array (e1, e2, p)
  | Get (e1, e2, p)
  | Put (e1, e2, e3, p)
  | _ -> _

let del_lambda exp =
  match exp with
  | Not (e, p)
  | Neg (e, p)
  | Add (e1, e2, p)
  | Sub (e1, e2, p)
  | FNeg (e1, e2, p)
  | FAdd (e1, e2, p)
  | FSub (e1, e2, p)
  | FMul (e1, e2, p)
  | FDiv (e1, e2, p)
  | Eq (e1, e2, p)
  | LE (e1, e2, p)
  | If (e1, e2, e3, p)
  | Let of (lis, e1, e2, p)
  | Var of (id, p)
  | LetRec (fd, e1, p)
  | App of (e1, lis, p)
  | Tuple (lis, p)
  | LetTuple (lis, e1, e2, p)
  | Array (e1, e2, p)
  | Get (e1, e2, p)
  | Put (e1, e2, e3, p)
  | Lambda of (Id.t * Type.t) list * t * pos
  | _ -> _

  
  
let f e = 
  let exp' = eta_expansion empty_env e in
  let exp'' = del_lambda exp' in
  exp''