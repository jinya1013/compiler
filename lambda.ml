(* type t = (* K正規化後の式 (caml2html: knormal_t) *)
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
  | IfEq of Id.t * Id.t * t * t  * Syntax.pos (* 比較 + 分岐 (caml2html: knormal_branch) *)
  | IfLE of Id.t * Id.t * t * t  * Syntax.pos (* 比較 + 分岐 *)
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
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t } *)

(*
  内部のLetRecの返り値が関数本体の時はlambda lifting できなさそう
  自由変数を持つ再帰関数
  even-odd: 相互再帰
  adder: 部分適用
  funcomp: 部分適用
  cls-rec: 
  cls-reg-bug: レジスタに乗りきらない(非本質)
  shuffle: レジスタに乗りきらない(非本質)
  matmul: 
  matmul-flat: レジスタに乗りきらない(非本質)
*)

open KNormal

exception Error of t

let sbst_id (x : Id.t) (new_x : Id.t) (a : Id.t) = 
  if x = a then new_x else a

(* change variable name x-> y when idname = x *)
let rec sbst_var_name x new_x = function
  | Var(a,p) -> Var((sbst_id x new_x a), p)
  | Neg(a,p) -> Neg((sbst_id x new_x a), p)
  | Add(a1, a2, p) -> Add((sbst_id x new_x a1), (sbst_id x new_x a2), p)
  | Sub(a1, a2, p) -> Sub((sbst_id x new_x a1), (sbst_id x new_x a2), p)
  | FNeg(a,p) -> FNeg((sbst_id x new_x a), p)
  | FAdd(a1,a2,p) -> FAdd((sbst_id x new_x a1), (sbst_id x new_x a2), p) 
  | FSub(a1,a2,p) -> FSub((sbst_id x new_x a1), (sbst_id x new_x a2), p)
  | FMul(a1,a2,p) -> FMul((sbst_id x new_x a1), (sbst_id x new_x a2), p)
  | FDiv (a1, a2, p) -> FDiv((sbst_id x new_x a1), (sbst_id x new_x a2), p)
  | IfEq(a1,a2,t1,t2,p) -> IfEq((sbst_id x new_x a1),(sbst_id x new_x a2),(sbst_var_name x new_x t1),t2,p)
  | IfLE(a1, a2, t1, t2, p) -> IfLE((sbst_id x new_x a1),(sbst_id x new_x a2),(sbst_var_name x new_x t1), (sbst_var_name x new_x t2),p)
  | App(f, args, p)-> App(sbst_id x new_x f, List.map (fun e -> sbst_id x new_x e) args, p)
  | Tuple (xs, p) -> Tuple (List.map (fun e -> sbst_id x new_x e) xs, p)
  | LetTuple (xts, a, t, p) -> LetTuple (xts, sbst_id x new_x a, sbst_var_name x new_x t, p)
  | Get (x1, x2, p) -> Get (sbst_id x new_x x1, sbst_id x new_x x2, p)
  | Put (x1, x2, x3,  p) -> Put (sbst_id x new_x x1, sbst_id x new_x x2, sbst_id x new_x x3, p)
  | ExtArray (x, p) -> ExtArray (x, p) (* cannot sbst *)
  | ExtFunApp(f, args, p) -> ExtFunApp(f, args, p) (* cannot sbst *)
  | LetRec({ name = (f, t); args = yts; body = e1 }, e2, p) -> LetRec({ name = (f, t); args = yts; body = sbst_var_name x new_x e1 }, sbst_var_name x new_x e2, p)
  | Let((a1, a2), e1, e2, p) ->  Let((a1, a2), sbst_var_name x new_x e1, sbst_var_name x new_x e2, p)
  | (_ as exp) -> exp

let rec h1 fname new_args = function (* g1から呼び出され, 関数fname の関数適用があったら, それにnew_argsを付け加える関数 *)
| Unit(_) | Int(_) | Float(_) | Neg(_) | Add(_) | Sub(_) | FNeg(_) | FAdd(_) | FSub(_) | FMul(_) | FDiv(_) | Var(_) | Tuple(_)
| Get(_) | Put(_) | ExtArray(_) | ExtFunApp (_) as exp -> exp
| Let((x, t), e1, e2, p) -> Let((x, t), (h1 fname new_args e1), (h1 fname new_args e2), p)
| LetTuple(xts, e1, e2, p) -> LetTuple(xts, e1, (h1 fname new_args e2), p)
| LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) -> LetRec({ name = (x, t); args = yts; body = (h1 fname new_args e1)}, (h1 fname new_args e2), p)
| IfEq(x, y, e1, e2, p) -> IfEq(x, y, (h1 fname new_args e1), (h1 fname new_args e2), p)
| IfLE(x, y, e1, e2, p) -> IfLE(x, y, (h1 fname new_args e1), (h1 fname new_args e2), p)
| App(x, ys, p) ->
(
  if x = fname then App(x, ys @ (fst (List.split new_args)), p)
  else App(x, ys, p)
)

let rec g1 env = function (* 関数定義の中の自由変数を引数に加える関数 *)
| Unit(_) | Int(_) | Float(_) | Neg(_) | Add(_) | Sub(_) | FNeg(_) | FAdd(_) | FSub(_) | FMul(_) | FDiv(_) | Var(_) | Tuple(_)
| Get(_) | Put(_) | App(_) | ExtArray(_) | ExtFunApp (_) as exp -> exp
| Let((x, t), e1, e2, p) -> Let((x, t), (g1 env e1), (g1 ((x, t) :: env) e2), p)
| LetTuple(xts, e1, e2, p) -> LetTuple(xts, e1, g1 (xts @ env) e2, p)
| LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) ->
(
  let e1' = g1 (yts @ ((x, t) :: env)) e1 in (* e1をlambda-liftingした結果 *)
  let fv = fv e1' in (* 変換後のe1の中の自由変数の集合 *)
  let new_args = List.filter (fun (x, t) -> S.mem x fv) env in (* 環境に登録されているe1中の自由変数は新たに関数の引数に追加 *)
  let extra_args = List.map (fun (_, t) -> (Id.genid "lambda", t)) new_args in (* 関数の引数用に新たな変数を作る *)
  let e1'' = List.fold_left2 (fun e x new_x -> sbst_var_name x new_x e) e1' (List.map fst new_args) (List.map fst extra_args) in (* e1'の中に現れる自由変数を, 新たに関数の引数として追加した変数で置き換える *)
  let e2' = g1 ((x, t) :: env) (h1 x new_args e2) in (* e2中に現れるxの関数適用において, 全てnew_argsを付け加えたものを再度lambda-lifting *)
  LetRec({ name = (x, t); args = yts @ extra_args; body = e1'' }, e2', p)
)
| IfEq(x, y, e1, e2, p) -> IfEq(x, y, g1 env e1, g1 env e2, p) 
| IfLE(x, y, e1, e2, p) -> IfLE(x, y, g1 env e1, g1 env e2, p)

let rec h2 lifted_funcs = function
| Unit(_) | Int(_) | Float(_) | Neg(_) | Add(_) | Sub(_) | FNeg(_) | FAdd(_) | FSub(_) | FMul(_) | FDiv(_) | Var(_) | Tuple(_)
| Get(_) | Put(_) | App(_) | ExtArray(_) | ExtFunApp (_) as exp -> lifted_funcs, exp
| Let((x, t), e1, e2, p) -> 
(
  let (l1, e1') = h2 lifted_funcs e1 in
  let (l2, e2') = h2 [] e2 in
  l2 @ l1, Let((x, t), e1', e2', p)
)
| LetTuple(xts, e1, e2, p) -> 
(
  let (l2, e2') = h2 lifted_funcs e2 in
  l2, LetTuple(xts, e1, e2', p)
)
| LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) as exp ->
(
  exp :: lifted_funcs, e2
)
| IfEq(x, y, e1, e2, p) -> 
(
  let (l1, e1') = h2 lifted_funcs e1 in
  let (l2, e2') = h2 [] e2 in
  l2 @ l1, IfEq(x, y, e1', e2', p) 
)
| IfLE(x, y, e1, e2, p) -> 
(
  let (l1, e1') = h2 lifted_funcs e1 in
  let (l2, e2') = h2 [] e2 in
  l2 @ l1, IfLE(x, y, e1', e2', p) 
)

let rec g2 = function
| Unit(_) | Int(_) | Float(_) | Neg(_) | Add(_) | Sub(_) | FNeg(_) | FAdd(_) | FSub(_) | FMul(_) | FDiv(_) | Var(_) | Tuple(_)
| Get(_) | Put(_) | App(_) | ExtArray(_) | ExtFunApp (_) as exp -> exp
| Let((x, t), e1, e2, p) -> Let((x, t), g2 e1, g2 e2, p)
| LetTuple(xts, e1, e2, p) -> LetTuple(xts, e1, g2 e2, p)
| LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) ->
(
  let (lifted_funcs, e1') = h2 [] (g2 e1) in
  List.fold_left 
  (
    fun e1 f ->
    (
      match f with
      | LetRec({ name = (x2, t2); args = yts2; body = e2 }, f2, p2) -> LetRec({ name = (x2, t2); args = yts2; body = e2 }, e1, p2)
      | _ -> raise (Error(f))
    ) 
  ) (LetRec({ name = (x, t); args = yts; body = e1' }, (g2 e2), p)) lifted_funcs

)
| IfEq(x, y, e1, e2, p) -> IfEq(x, y, g2 e1, g2 e2, p) 
| IfLE(x, y, e1, e2, p) -> IfLE(x, y, g2 e1, g2 e2, p)

let rec iter n e = 
  if n = 0 then e else
  let e' = g2 (g1 [] e) in
  if e = e' then e else
  iter (n - 1) e'

(* let rec g2 = function *)
let f e = iter 5 e