open KNormal

(* let empty_env = []
let add_env env (xt:(Id.t * Type.t)) (exp:KNormal.t)  = (xt,exp)::env

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
  | Let((a1,a2),t1,t2,_),Let((b1,b2),s1,s2,_) -> (a1 = b1) && (a2 = b2) && (check_same_exp (g t1 empty_env) (g s1 empty_env)) && (check_same_exp (g t2 empty_env) (g s2 empty_env))
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
  | IfEq(x, y, e1, e2, p) -> IfEq(x, y, g e1 empty_env, g e2 empty_env, p)
  | IfLE(x, y, e1, e2, p) -> IfLE(x, y, g e1 empty_env, g e2 empty_env, p)
  | Let((x, t), e1, e2, p) as exp-> (* let�Φ´��� (caml2html: beta_let) *)
    if (not (Elim.effect e1)) then
      (
        match find_exp e1 env with
      | Some(z) -> (  
        let e2' = g e2 env in
        (Format.eprintf "replace exp with %s in line %d" z p;Let((x,t), Var(z,p), e2', p))) 
      | _    ->  (  
        let e2' = g e2 (add_env env (x,t) e1) in
        Let((x,t), e1, e2', p))
      )
      else exp
  | LetRec({ name = xt; args = yts; body = e1 }, e2, p) ->
      LetRec({ name = xt; args = yts; body = g e1 empty_env }, g e2 env, p)
and find_exp exp env :Id.t option =
  match env with
  | [] -> None
  | ((x,t),exp')::envs -> (
    if check_same_exp exp exp' then
      Some(x)
    else
      find_exp exp envs) *)

<<<<<<< HEAD
(* トップレベルの関数 *)
let rec f (t : KNormal.t) = g t empty_env
  
=======
exception NotFoundErr of string

let bound_vars = ref S.empty

let m_find p x env = 
  try
    M.find x env
  with
    | _ -> raise (NotFoundErr ("In line " ^ (string_of_int p) ^ ", tried to look up " ^ x ^ ", but failed"))

let m_add_list xes m = 
  let rec m_add_list_sub xes m = 
    match xes with
    | [] -> m
    | (x, e) :: xes' -> m_add_list_sub xes' (M.add x e m)
  in m_add_list_sub xes m

let _m_union_rule = fun key a b -> Some(a)

let rec effect = function (* 副作用の有無 (caml2html: elim_effect) *)
  | Let(_, e1, e2, p) | IfEq(_, _, e1, e2, p) | IfLE(_, _, e1, e2, p) -> effect e1 || effect e2
  | LetRec(_, e, p) | LetTuple(_, _, e, p) -> effect e
  | App _ | Get _ | Put _ | ExtFunApp _ -> true
  | _ -> false
  

let rec check_type t1 t2 = 
  match t1, t2 with
  | Type.Unit, Type.Unit -> true
  | Type.Bool, Type.Bool -> true
  | Type.Int, Type.Int -> true
  | Type.Float, Type.Float -> true
  | Type.Fun(ts1, rt1), Type.Fun(ts2, rt2) -> (List.for_all2 (fun t1 t2 -> check_type t1 t2) ts1 ts2) && (check_type rt1 rt2)
  | Type.Tuple(ts1), Type.Tuple(ts2) -> (List.for_all2 (fun t1 t2 -> check_type t1 t2) ts1 ts2)
  | Type.Array(t1), Type.Array(t2) -> check_type t1 t2
  | _ -> false

let rec check env1 env2 e1 e2 = 
  (* print_string "checking\n"; *)
  (* output_prog stdout e1; *)
  (* print_string "is the same as \n"; *)
  (* output_prog stdout e2; *)
  (* print_string "\n"; *)
  match e1, e2 with
  | Unit(_), Unit(_) -> true
  | Int(n1, _), Int(n2, _) -> n1 = n2
  | Float(c1, _), Float(c2, _) -> c1 = c2
  | Neg(x1, p), Neg(x2, _) -> check env1 env2 (m_find p x1 env1) (m_find p x2 env2)
  | Add(x1, y1, p), Add(x2, y2, _) -> 
    let d1 = m_find p x1 env1 in
    let e1 = m_find p y1 env1 in
    let d2 = m_find p x2 env2 in
    let e2 = m_find p y2 env2 in
    ((check env1 env2 d1 d2) && (check env1 env2 e1 e2)) || ((check env1 env2 d1 e2) && (check env1 env2 e1 d2))
  | Sub(x1, y1, p), Sub(x2, y2, _) -> 
    let d1 = m_find p x1 env1 in
    let e1 = m_find p y1 env1 in
    let d2 = m_find p x2 env2 in
    let e2 = m_find p y2 env2 in
    ((check env1 env2 d1 d2) && (check env1 env2 e1 e2)) || ((check env1 env2 d1 e2) && (check env1 env2 e1 d2))
  | FNeg(x1, p), FNeg(x2, _) -> check env1 env2 (m_find p x1 env1) (m_find p x2 env2)
  | FAdd(x1, y1, p), FAdd(x2, y2, _) -> 
    let d1 = m_find p x1 env1 in
    let e1 = m_find p y1 env1 in
    let d2 = m_find p x2 env2 in
    let e2 = m_find p y2 env2 in
    ((check env1 env2 d1 d2) && (check env1 env2 e1 e2)) || ((check env1 env2 d1 e2) && (check env1 env2 e1 d2))
  | FSub(x1, y1, p), FSub(x2, y2, _) -> 
    let d1 = m_find p x1 env1 in
    let e1 = m_find p y1 env1 in
    let d2 = m_find p x2 env2 in
    let e2 = m_find p y2 env2 in
    ((check env1 env2 d1 d2) && (check env1 env2 e1 e2)) || ((check env1 env2 d1 e2) && (check env1 env2 e1 d2))
  | FMul(x1, y1, p), FMul(x2, y2, _) -> 
    let d1 = m_find p x1 env1 in
    let e1 = m_find p y1 env1 in
    let d2 = m_find p x2 env2 in
    let e2 = m_find p y2 env2 in
    ((check env1 env2 d1 d2) && (check env1 env2 e1 e2)) || ((check env1 env2 d1 e2) && (check env1 env2 e1 d2))
  | FDiv(x1, y1, p), FDiv(x2, y2, _) -> 
    let d1 = m_find p x1 env1 in
    let e1 = m_find p y1 env1 in
    let d2 = m_find p x2 env2 in
    let e2 = m_find p y2 env2 in
    ((check env1 env2 d1 d2) && (check env1 env2 e1 e2)) || ((check env1 env2 d1 e2) && (check env1 env2 e1 d2))
  | IfEq(x1, y1, t1, f1, p), IfEq(x2, y2, t2, f2, _) ->
    let d1 = m_find p x1 env1 in
    let e1 = m_find p y1 env1 in
    let d2 = m_find p x2 env2 in
    let e2 = m_find p y2 env2 in
    let same_exp = (check env1 env2 t1 t2) && (check env1 env2 f1 f2) in
    ((check env1 env2 d1 d2) && (check env1 env2 e1 e2) && same_exp) || ((check env1 env2 d1 e2) && (check env1 env2 e1 d2) && same_exp)
  | IfLE(x1, y1, t1, f1, p), IfEq(x2, y2, t2, f2, _) ->
    let d1 = m_find p x1 env1 in
    let e1 = m_find p y1 env1 in
    let d2 = m_find p x2 env2 in
    let e2 = m_find p y2 env2 in
    let same_exp = (check env1 env2 t1 t2) && (check env1 env2 f1 f2) in
    ((check env1 env2 d1 d2) && (check env1 env2 e1 e2) && same_exp) || ((check env1 env2 d1 e2) && (check env1 env2 e1 d2) && same_exp)
  | Let((x1, t1), d1, e1, _), Let((x2, t2), d2, e2, _) ->
    (check_type t1 t2) && (check (M.add x1 d1 env1) (M.add x2 d2 env2) e1 e2)
  | Var(x1, p), Var(x2, _) ->
    let e1 = m_find p x1 env1 in
    let e2 = m_find p x2 env2 in
    check env1 env2 e1 e2
  | LetRec _, LetRec _ -> false (* temporary *)
  | App(f1, args1, p), App(f2, args2, _) ->
    (check env1 env2 (m_find p f1 env1) (m_find p f2 env2)) && (List.for_all2 (fun x1 x2 -> check env1 env2 (m_find p x1 env1) (m_find p x2 env2)) args1 args2)
  | Tuple(xs1, p), Tuple(xs2, _) ->
    (List.for_all2 (fun x1 x2 -> check env1 env2 (m_find p x1 env1) (m_find p x2 env2)) xs1 xs2)
  | LetTuple(xts1, y1, e1, _), Let(xts2, y2, e2, _) -> false (* Instead of unfolding tuple, check the equality by comparing the name of defined variables *)
    (* let xs1 = List.map fst xts1 in
    let xs2 = List.map fst xts2 in
    let ts1 = List.map snd xts1 in
    let ts2 = List.map snd xts2 in
    (List.for_all2 (fun t1  t2 -> check_type t1 t2) ts1 ts2) && (List.for_all2 (fun x1, x2 -> x1 = x2) xs1 xs2) && () *)
  | Get(x1, y1, p), Get(x2, y2, _) ->
    let d1 = m_find p x1 env1 in
    let e1 = m_find p y1 env1 in
    let d2 = m_find p x2 env2 in
    let e2 = m_find p y2 env2 in
    ((check env1 env2 d1 d2) && (check env1 env2 e1 e2))
  | Put(x1, y1, z1, p), Put(x2, y2, z2, _) ->
    let d1 = m_find p x1 env1 in
    let e1 = m_find p y1 env1 in
    let f1 = m_find p z1 env1 in
    let d2 = m_find p x2 env2 in
    let e2 = m_find p y2 env2 in
    let f2 = m_find p z2 env2 in
    ((check env1 env2 d1 d2) && (check env1 env2 e1 e2) && (check env1 env2 f1 f2))
  | ExtArray(x1, _), ExtArray(x2, _) -> x1 = x2
  | ExtFunApp(f1, args1, p), ExtFunApp(f2, args2, _) ->
    (f1 = f2) && (List.for_all2 (fun x1 x2 -> check env1 env2 (m_find p x1 env1) (m_find p x2 env2)) args1 args2)
  | _ -> false
and rm env e =
  match e with
  | Unit(_) | Int(_) | Float(_) | Neg(_) | Add(_) | Sub(_) | FNeg(_) | FSqrt (_) | Floor (_) | FAdd(_) | FSub(_) | FMul(_) | FDiv(_) | Var(_) | Tuple(_)
  | Get(_) | Put(_) | App(_) | ExtArray(_) | ExtFunApp (_) as exp -> env, exp
  | IfEq(x, y, e1, e2, p) -> 
      let (env1, e1') = rm env e1 in
      let (env2, e2') = rm env e2 in
      let env' = M.union _m_union_rule env1 env2 in
      env', IfEq(x, y, e1', e2', p)
  | IfLE(x, y, e1, e2, p) ->
      let (env1, e1') = rm env e1 in
      let (env2, e2') = rm env e2 in
      let env' = M.union _m_union_rule env1 env2 in
      env', IfLE(x, y, e1', e2', p)
  | Let((x, t), e1, e2, p) ->
    if (not (effect e1)) then (* if no e1 does not have any sub effect *)
      (
        match find_exp env (M.bindings env) e1 with (* look up e1 on the env *)
      | Some(z) when S.mem x !bound_vars -> (  
        bound_vars := S.add x !bound_vars;
        let env', e2' = rm (M.add x (Var(z, p)) env) e2 in
        (Format.eprintf "replacing exp with %s in line %d\n" z p; env', Let((x, t), Var(z, p), e2', p))) 
      | _    ->  (  
        bound_vars := S.add x !bound_vars;
        let env', e2' = rm (M.add x e1 env) e2 in
        env', Let((x, t), e1, e2', p))
      )
      else 
        (bound_vars := S.add x !bound_vars;
        let env', e2' = rm (M.add x e1 env) e2 in
        env', Let((x, t), e1, e2', p))
  | LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) ->
      let dummy_env_in_e2 = M.add x (Unit(p)) env in
      let dummy_exps = List.map (fun (y, t) -> (y, Unit(p))) yts in
      let dummy_env_in_e1 = m_add_list dummy_exps dummy_env_in_e2 in
      let backup = !bound_vars in
      bound_vars := S.add x (S.of_list (List.map fst yts));
      let env_body, exp_body = rm dummy_env_in_e1 e1 in
      bound_vars := S.add x backup;
      let env_main, exp_main = rm dummy_env_in_e2 e2 in
      (* let env' = M.union _m_union_rule env_body env_main in *)
      env_main, LetRec({ name = (x, t); args = yts; body = exp_body }, exp_main, p) (* add dummy *)
  | LetTuple _ as exp -> env, exp

and find_exp env env_list e = 
  match env_list with
  | [] -> None
  | (x, e') :: env_list' ->
    if check env env e e' then
      Some(x)
    else
      find_exp env env_list' e

(* トップレベルの関数 *)
let rec f (e : KNormal.t) = snd (rm M.empty e)
>>>>>>> 49d1a1e ([変更] シフト演算の即値最適化を実装)
