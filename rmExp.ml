open KNormal


let empty_env = []
let add_env env (xt:(Id.t * Type.t)) (exp:KNormal.t)  = (xt,exp)::env

let rec volatile_exp = function (* 副作用の有無 (caml2html: elim_effect) *)
  | Let(_, e1, e2, p) | IfEq(_, _, e1, e2, p) | IfLE(_, _, e1, e2, p) -> volatile_exp e1 || volatile_exp e2
  | LetRec(_, e, p) | LetTuple(_, _, e, p) -> volatile_exp e
  | App _ | Put _ | Get _ | ExtFunApp _ -> true
  | _ -> false

let sbst_id (x : Id.t) (new_x : Id.t) (a : Id.t) = 
  if x = a then new_x else a


let rec output_env = function
| [] -> ()
| ((x, _), e) :: env -> 
(
  Id.output_id stdout x;
  print_string ", ";
  KNormal.output_knormal stdout e 0;
  print_string "\n";
  output_env env
)  
  
(* change variable name x-> y when idname = x *)
let rec change_var_name x new_x exp =
  match exp with
  | Var(a,p) -> Var((sbst_id x new_x a), p)
  | Neg(a,p) -> Neg((sbst_id x new_x a), p)
  | Add(a1, a2, p) -> Add((sbst_id x new_x a1), (sbst_id x new_x a2), p)
  | Sub(a1, a2, p) -> Sub((sbst_id x new_x a1), (sbst_id x new_x a2), p)
  | FNeg(a,p) -> FNeg((sbst_id x new_x a), p)
  | FAdd(a1,a2,p) -> FAdd((sbst_id x new_x a1), (sbst_id x new_x a2), p) 
  | FSub(a1,a2,p) -> FSub((sbst_id x new_x a1), (sbst_id x new_x a2), p)
  | FMul(a1,a2,p) -> FMul((sbst_id x new_x a1), (sbst_id x new_x a2), p)
  | FDiv (a1, a2, p) -> FDiv((sbst_id x new_x a1), (sbst_id x new_x a2), p)
  | IfEq(a1,a2,t1,t2,p) -> IfEq((sbst_id x new_x a1),(sbst_id x new_x a2),(change_var_name x new_x t1),t2,p)
  | IfLE(a1, a2, t1, t2, p) -> IfLE((sbst_id x new_x a1),(sbst_id x new_x a2),(change_var_name x new_x t1), (change_var_name x new_x t2),p)
  | App(f, args, p)-> App(f, args, p)
  | Tuple (xs, p) -> Tuple (xs, p)
  | LetTuple (xts, a, t, p) -> LetTuple (xts, a, t, p)
  | Get (x1, x2, p) -> Get (x1, x2, p) (* cannot sbst  *)
  | Put (x1, x2, x3,  p) -> Put (x1, x2, x3,  p) (* cannot sbst  *)
  | ExtArray (x, p) -> ExtArray (x, p) (* cannot sbst  *)
  | ExtFunApp(f, args, p) -> ExtFunApp(f, args, p) (* cannot sbst  *)
  | LetRec(f, x0, p) -> LetRec(f, x0, p) 
  | Let((a1, a2), e1, e2, p) ->  if a1 = x then Let((a1, a2), (change_var_name x new_x e1), e2, p) else Let((a1, a2), (change_var_name x new_x e1), (change_var_name x new_x e2), p)
  | (_ as exp) -> exp
  

let rec check_same_exp (t1: KNormal.t) (t2: KNormal.t) =
  match t1,t2 with
  | Unit(_),Unit(_) -> true
  | Int(a,_),Int(b,_) -> a = b
  | Neg(a,_),Neg(b,_) -> a = b
  | Add (a1, a2, _), Add(b1, b2, _) -> (a1 = b1) && (a2 = b2)
  | Sub(a1,a2,_),Sub(b1,b2,_) -> (a1 = b1) && (a2 = b2)
  | FNeg(a,_),FNeg(b,_) -> a = b
  | FAdd(a1,a2,_),FAdd(b1,b2,_) -> (a1 = b1) && (a2 = b2)
  | FSub(a1,a2,_),FSub(b1,b2,_) -> (a1 = b1) && (a2 = b2)
  | FMul(a1,a2,_),FMul(b1,b2,_) -> (a1 = b1) && (a2 = b2)
  | FDiv (a1, a2, _),FDiv(b1, b2, _) -> (a1 = b1) && (a2 = b2)
  | IfEq(a1,a2,t1,t2,_),IfEq(b1,b2,s1,s2,_) -> (a1 = b1)
  | IfLE(a1, a2, t1, t2, _), IfLE(b1, b2, s1, s2, _) -> (a1 = b1) && (a2 == b2) && (check_same_exp t1 s1) && (check_same_exp t2 s2)
  | Let((a1,a2),t1,t2,_),Let((b1,b2),s1,s2,_) -> 
    if ((a2 = b2) && (check_same_exp (g t1 empty_env) (g s1 empty_env))) then 
      let s2' = change_var_name b1 a1 s2 in
      (check_same_exp (g t2 empty_env) (g s2' empty_env))
    else false
  | Var(a, _), Var(b, _) -> a = b
  | LetRec(_),LetRec(_) -> false (* 大変そうなので, false *)
  | App(f, args, _), App(g, argt, _) -> (f = g) && (List.for_all2 (fun a b -> a = b) args argt)
  | Tuple (xs, _), Tuple(ys, _) -> List.for_all2 (fun a b -> a = b) xs ys
  | LetTuple (xts, a, t, _), LetTuple(yts, b, s, _) -> 
    (List.for_all2 (fun a b -> a = b) (fst (List.split xts)) (fst (List.split yts))) && (a = b) && (check_same_exp (g t empty_env) (g s empty_env))
  | Get (x1, x2, _), Get(y1, y2, _) -> (x1 = y1) && (x2 = y2)
  | Put (x1, x2, x3,  _), Put(y1, y2, y3, _) -> (x1 = y1) && (x2 = y2) && (x3 = y3)
  | ExtArray (x, _), ExtArray(y, _) -> x = y
  | ExtFunApp(f, args, _), ExtFunApp(g, argt, _) -> (f = g) && (List.for_all2 (fun a b -> a = b) args argt)
  | _ -> false
and g t env =
  match t with
  | Unit(_) | Int(_) | Float(_) | Neg(_) | Add(_) | Sub(_) | FNeg(_) | FAdd(_) | FSub(_) | FMul(_) | FDiv(_) | Var(_) | Tuple(_) | LetTuple(_) 
  | Get(_) | Put(_) | App(_) | ExtArray(_) | ExtFunApp (_) as exp -> exp
  | IfEq(x, y, e1, e2, p) -> IfEq(x, y, g e1 env, g e2 env, p)
  | IfLE(x, y, e1, e2, p) -> IfLE(x, y, g e1 env, g e2 env, p)
  | Let((x, t), e1, e2, p)->
  ( (* let?Φ´??? (caml2html: beta_let) *)
     if (not (volatile_exp e1)) then
      (
        match find_exp e1 env with
      | Some(z) -> (  
        let e2' = g e2 env in
        (Format.eprintf "replace exp with %s in line %d" z p; Let((x,t), Var(z,p), e2', p))) 
      | _    ->  (  
        let e2' = g e2 (add_env env (x,t) e1) in
        Let((x,t), e1, e2', p))
      )
    else 
      (let e2' = g e2 (add_env env (x,t) e1) in
      Let((x,t), e1, e2', p))
  )
  | LetRec({ name = xt; args = yts; body = e1 }, e2, p) ->
      LetRec({ name = xt; args = yts; body = g e1 empty_env }, g e2 env, p)
and find_exp exp env :Id.t option =
  match env with
  | [] -> None
  | ((x,t),exp')::envs -> (
    if check_same_exp exp exp' then
      Some(x)
    else
      find_exp exp envs)

(* トップレベルの関数 *)
let rec f (t : KNormal.t) = g t empty_env
