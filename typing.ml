(* type inference/reconstruction *)

open Syntax

exception Unify of Type.t * Type.t * Syntax.pos
exception Error of t * Type.t * Type.t * Syntax.pos

exception AppError
exception UncurryError
exception UndefinedVarError

let extenv = ref M.empty

(* 環境を出力する関数, デバッグ用 *)
let output_env outchan m = 
    match M.bindings m with
    | (x, t) :: xts ->
    (
        output_string outchan "(";
        Id.output_id outchan x;
        output_string outchan ", ";
        Type.output_type outchan t;
        output_string outchan ")";

        List.iter (fun (x, t) -> 
        output_string outchan ", ";
        output_string outchan "(";
        Id.output_id outchan x;
        output_string outchan ", ";
        Type.output_type outchan t;
        output_string outchan ")") xts
    )
    | _ -> ()

(* FunCurryをFunに直す(uncurryする)関数, nはFunCurryのラベル *)
let rec uncurry n = function
| Type.FunCurry(t1, t2, n) -> 
    uncurry n (Type.Fun([t1], t2))
| Type.Fun(t1s, Type.FunCurry(t1', t2', m)) when n = m -> uncurry n (Type.Fun(t1s @ [uncurry_typ t1'], t2'))
| Type.Fun(t1s, Type.FunCurry(t1', t2', m)) -> Type.Fun(t1s, (uncurry m (Type.FunCurry(t1', t2', m))))
| Type.Fun(t1s, t2) as e -> e
| _ -> raise UncurryError

and uncurry_typ = 
    function
  | Type.FunCurry(t1, t2, n) as e-> uncurry n e
  | Type.Tuple(ts) -> Type.Tuple(List.map uncurry_typ ts)
  | Type.Array(t) -> Type.Array(uncurry_typ t)
  | t -> t

let rec uncurry_id_typ (x, t) = 
    (x, uncurry_typ t)

let rec uncurry_term = 
    function
  | Not(e, p) -> Not(uncurry_term e, p)
  | Neg(e, p) -> Neg(uncurry_term e, p)
  | Add(e1, e2, p) -> Add(uncurry_term e1, uncurry_term e2, p)
  | Sub(e1, e2, p) -> Sub(uncurry_term e1, uncurry_term e2, p)
  | Eq(e1, e2, p) -> Eq(uncurry_term e1, uncurry_term e2, p)
  | LE(e1, e2, p) -> LE(uncurry_term e1, uncurry_term e2, p)
  | FNeg(e, p) -> FNeg(uncurry_term e, p)
  | FAdd(e1, e2, p) -> FAdd(uncurry_term e1, uncurry_term e2, p)
  | FSub(e1, e2, p) -> FSub(uncurry_term e1, uncurry_term e2, p)
  | FMul(e1, e2, p) -> FMul(uncurry_term e1, uncurry_term e2, p)
  | FDiv(e1, e2, p) -> FDiv(uncurry_term e1, uncurry_term e2, p)
  | If(e1, e2, e3, p) -> If(uncurry_term e1, uncurry_term e2, uncurry_term e3, p)
  | Let(xt, e1, e2, p) -> Let(uncurry_id_typ xt, uncurry_term e1, uncurry_term e2, p)
  | LetRec({ name = xt; args = yts; body = e1 }, e2, p) ->
      LetRec({ name = uncurry_id_typ xt;
               args = List.map uncurry_id_typ yts;
               body = uncurry_term e1 },
             uncurry_term e2, p)
  | App(e, es, p) -> App(uncurry_term e, List.map uncurry_term es, p)
  | Tuple(es, p) -> Tuple(List.map uncurry_term es, p)
  | LetTuple(xts, e1, e2, p) -> LetTuple(List.map uncurry_id_typ xts, uncurry_term e1, uncurry_term e2, p)
  | Array(e1, e2, p) -> Array(uncurry_term e1, uncurry_term e2, p)
  | Get(e1, e2, p) -> Get(uncurry_term e1, uncurry_term e2, p)
  | Put(e1, e2, e3, p) -> Put(uncurry_term e1, uncurry_term e2, uncurry_term e3, p)
  | e -> e

let rec map_from_list m = function
| (x, t) :: xts -> map_from_list (M.add x t m) xts
| [] -> m

let uncurry_env env = 
    let env' = M.bindings env in
    let new_env' = List.map (fun (x, t) -> (x, uncurry_typ t)) env' in
    map_from_list M.empty new_env'

(* for pretty printing (and type normalization) *)
let rec deref_typ = (* 型変数を中身でおきかえる関数 *)
(* 
    与えられた型tに対して, t中に現れる全ての型変数をその参照先(中身)で置き換える.
    型変数の参照先がNoneのとき(型変数が未定義であるとき)は参照先をType.Intにする.

    Args
        t : Type.t
            型

    Returns
        retval : Type.t
            変換後の型
*)
    function
  | Type.FunCurry(t1, t2, n) -> Type.FunCurry(deref_typ t1, deref_typ t2, n)
  | Type.Fun(t1s, t2) -> Type.Fun(List.map deref_typ t1s, deref_typ t2)
  | Type.Tuple(ts) -> Type.Tuple(List.map deref_typ ts)
  | Type.Array(t) -> Type.Array(deref_typ t)
  | Type.Var({ contents = None } as r) ->
      Format.eprintf "uninstantiated type variable detected; assuming int@.";
      r := Some(Type.Int);
      Type.Int
  | Type.Var({ contents = Some(t) } as r) ->
      let t' = deref_typ t in
      r := Some(t');
      t'
  | t -> t
let rec deref_id_typ (x, t) = 
(* 
    変数名xと型tの組を引数にとり, xとderef_typ tの組を返す.

    Args
        xt : Id.t * Type.t
            変数名と型の組

    Returns
        retval : Id.t * Type.t
            変換後の変数名と型の組

*)
    (x, deref_typ t)

let rec deref_term = 
(* 
    式e中に現れる型に対して, 型変数をその参照先で置き換える変換を再帰的に行う.

    Args
        e : Syntax.t
            式

    Returns
        retval : Syntax.t
            変換後の式

*)
    function
  | Not(e, p) -> Not(deref_term e, p)
  | Neg(e, p) -> Neg(deref_term e, p)
  | Add(e1, e2, p) -> Add(deref_term e1, deref_term e2, p)
  | Sub(e1, e2, p) -> Sub(deref_term e1, deref_term e2, p)
  | Eq(e1, e2, p) -> Eq(deref_term e1, deref_term e2, p)
  | LE(e1, e2, p) -> LE(deref_term e1, deref_term e2, p)
  | FNeg(e, p) -> FNeg(deref_term e, p)
  | FAdd(e1, e2, p) -> FAdd(deref_term e1, deref_term e2, p)
  | FSub(e1, e2, p) -> FSub(deref_term e1, deref_term e2, p)
  | FMul(e1, e2, p) -> FMul(deref_term e1, deref_term e2, p)
  | FDiv(e1, e2, p) -> FDiv(deref_term e1, deref_term e2, p)
  | If(e1, e2, e3, p) -> If(deref_term e1, deref_term e2, deref_term e3, p)
  | Let(xt, e1, e2, p) -> Let(deref_id_typ xt, deref_term e1, deref_term e2, p)
  | LetRec({ name = xt; args = yts; body = e1 }, e2, p) ->
      LetRec({ name = deref_id_typ xt;
               args = List.map deref_id_typ yts;
               body = deref_term e1 },
             deref_term e2, p)
  | App(e, es, p) -> App(deref_term e, List.map deref_term es, p)
  | Tuple(es, p) -> Tuple(List.map deref_term es, p)
  | LetTuple(xts, e1, e2, p) -> LetTuple(List.map deref_id_typ xts, deref_term e1, deref_term e2, p)
  | Array(e1, e2, p) -> Array(deref_term e1, deref_term e2, p)
  | Get(e1, e2, p) -> Get(deref_term e1, deref_term e2, p)
  | Put(e1, e2, e3, p) -> Put(deref_term e1, deref_term e2, deref_term e3, p)
  | e -> e


let counter = ref 0
(* 
    引数の型のリストtsと式の型eを受け取って, Type.FunCurry(t1, (Type.FunCurry(t2, ...(Type.FunCurry(tn,g (M.add_list yts env) e1) )))) という入れ子の関数の型を定義する.
    この際, 同じ関数をカリー化した式かどうか判別するための番号がcounterである.
*)
let seq ts e = 
    incr counter;
    List.fold_right (fun t e -> Type.FunCurry(t, e, !counter)) ts e



let rec occur r1 = (* occur check *)
(* 
    与えられた2つの型r1, r2に対して, 一方が他方に含まれているか否かをbool値で返す.

    Args
        r1 : Type.t
            型
        r2 : Type.t
            型
    Returns
        retval : bool
            r1がr2に含まれていたか否か.

*)
    function 
  | Type.FunCurry(t1, t2, _) -> occur r1 t1 || occur r1 t2
  | Type.Tuple(t2s) -> List.exists (occur r1) t2s
  | Type.Array(t2) -> occur r1 t2
  | Type.Var(r2) when r1 == r2 -> true
  | Type.Var({ contents = None }) -> false
  | Type.Var({ contents = Some(t2) }) -> occur r1 t2
  | _ -> false

let rec unify p t1 t2 = (* 型が合うように、型変数への代入をする *)
(* 
    与えられた2つの型t1, t2が等しいかどうかをチェックしていき, 一方が未定義の型変数Type.Var(ref None)であったら他方と等しくなるように代入を行う.
    ただし, このときに一方の型変数が他方に含まれていないことを確認する(occur check).

    Args
        t1 : Type.t
            型
        e : Type.t
            型
    Returns
        retval : unit

*)
  match t1, t2 with
  | Type.Unit, Type.Unit | Type.Bool, Type.Bool | Type.Int, Type.Int | Type.Float, Type.Float -> ()
  | Type.FunCurry(t1, t1', _), Type.FunCurry(t2, t2', _) ->
      (try unify p t1 t2
      with Invalid_argument(_) -> raise (Unify(t1, t2, p)));
      unify p t1' t2'
  | Type.Tuple(t1s), Type.Tuple(t2s) ->
      (try List.iter2 (unify p) t1s t2s
      with Invalid_argument(_) -> raise (Unify(t1, t2, p)))
  | Type.Array(t1), Type.Array(t2) -> unify p t1 t2
  | Type.Var(r1), Type.Var(r2) when r1 == r2 -> ()
  | Type.Var({ contents = Some(t1') }), _ -> unify p t1' t2
  | _, Type.Var({ contents = Some(t2') }) -> unify p t1 t2'
  | Type.Var({ contents = None } as r1), _ -> (* 一方が未定義の型変数の場合 *)
      if occur r1 t2 then raise (Unify(t1, t2, p));
      r1 := Some(t2)
  | _, Type.Var({ contents = None } as r2) ->
      if occur r2 t1 then raise (Unify(t1, t2, p));
      r2 := Some(t1)
  | _, _ -> raise (Unify(t1, t2, p))

let rec g env e = (* 型推論ルーチン *)
(* 
    型環境envの下で式eの型を推論した結果を返す.
    また, 式中に出てくる変数の型があっているかどうかも調べる.
    もし, 未定義の型変数があったら, 適切な型を代入する.

    Args
        env : (Id.t * Type.t) list
            型環境
        e : Syntax.t
            型を推論したい対象の式
    Returns
        retval : Type.t
            式の型の推論結果
    
*)
  try
    match e with
    | Unit(p) -> Type.Unit
    | Bool(_, p) -> Type.Bool
    | Int(_, p) -> Type.Int
    | Float(_, p) -> Type.Float
    | Not(e, p) ->
        unify p Type.Bool (g env e);
        Type.Bool
    | Neg(e, p) ->
        unify p Type.Int (g env e);
        Type.Int
    | Add(e1, e2, p) | Sub(e1, e2, p) -> (* 足し算（と引き算）の型推論 *)
        unify p Type.Int (g env e1);
        unify p Type.Int (g env e2);
        Type.Int
    | FNeg(e, p) ->
        unify p Type.Float (g env e);
        Type.Float
    | FAdd(e1, e2, p) | FSub(e1, e2, p) | FMul(e1, e2, p) | FDiv(e1, e2, p) ->
        unify p Type.Float (g env e1);
        unify p Type.Float (g env e2);
        Type.Float
    | Eq(e1, e2, p) | LE(e1, e2, p) ->
        unify p (g env e1) (g env e2);
        Type.Bool
    | If(e1, e2, e3, p) ->
        unify p (g env e1) Type.Bool;
        let t2 = g env e2 in
        let t3 = g env e3 in
        unify p t2 t3;
        t2
    | Let((x, t), e1, e2, p) -> (* letの型推論 *)
        unify p t (g env e1);
        g (M.add x t env) e2
    | Var(x, p) when M.mem x env -> M.find x env (* 変数の型推論 *)
    | Var(x, p) when M.mem x !extenv -> M.find x !extenv
    | Var(x, p) -> (* 外部変数の型推論 *)
        Format.eprintf "free variable %s assumed as external@." x;
        let t = Type.gentyp () in
        extenv := M.add x t !extenv;
        t
    | LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) -> (* let recの型推論 *)
        let env = M.add x t env in
        (* unify p t (Type.FunCurry(List.map snd yts, g (M.add_list yts env) e1)); *)
        unify p t (seq (List.map snd yts) (g (M.add_list yts env) e1));
        g env e2
    | App(e, es, p) -> (* 関数適用の型推論 *)
        let t = Type.gentyp () in
        (* unify p (g env e) (Type.FunCurry(List.map (g env) es, t)); *)
        unify p (g env e) (seq (List.map (g env) es) t);
        t
    | Tuple(es, p) -> Type.Tuple(List.map (g env) es)
    | LetTuple(xts, e1, e2, p) ->
        unify p (Type.Tuple(List.map snd xts)) (g env e1);
        g (M.add_list xts env) e2
    | Array(e1, e2, p) -> (* must be a primitive for "polymorphic" typing *)
        unify p (g env e1) Type.Int;
        Type.Array(g env e2)
    | Get(e1, e2, p) ->
        let t = Type.gentyp () in
        unify p (Type.Array(t)) (g env e1);
        unify p Type.Int (g env e2);
        t
    | Put(e1, e2, e3, p) ->
        let t = g env e3 in
        unify p (Type.Array(t)) (g env e1);
        unify p Type.Int (g env e2);
        Type.Unit
  with 
    | Unify(t1, t2, p) -> raise (Error(deref_term e, deref_typ t1, deref_typ t2, p))
    | Error(e, t1, t2, p) -> raise (Error(deref_term e, deref_typ t1, deref_typ t2, p))

let rec make_abst_args acc = function
| Type.FunCurry(t1, t2, n) -> make_abst_args (acc @ [(Id.genid "abst_args", t1)]) t2
| _ -> acc

(* 型tfの関数fに型tesの引数esを適用したときの適用後の型を返す関数 *)
(* let rec get_typ_app' tf tes n = 
    match tes with
    | [] -> tf (* tesが空リストだったら, tfが返り値の型 *)
    | th :: tt -> (* tesが空リストではないとき *)
        (
            match tf with
            | Type.FunCurry(t1, t2, m) when t1 = th && m = n -> get_typ_app' t2 tt m (* tfがFunCurryで, tfをラップしていたFunCurryと同じ関数をカリー化したもの(m=n)だったらt2に対して再帰的にttを適用 *)
            | _ -> Type.output_type stdout tf; List.iter (fun e -> Type.output_type stdout e) tes; raise AppError (* それ以外は与えた引数の数が, 関数の実引数よりも多いのでエラー *)
        ) *)

let same_funcurry s t = 
    match s, t with
    | Type.FunCurry(s1, s2, _), Type.FunCurry(t1, t2, _) when s1 = t1 && s2 = t2 -> true
    | _ -> false

(* get_typ_app'のトップレベル関数 *)
let rec get_typ_app tf tes = 
    match tes with
    | [] -> tf
    | th :: tt -> 
        (
            match tf with
            | Type.FunCurry(t1, t2, n) when t1 = th || same_funcurry t1 th  -> get_typ_app t2 tt
            | _ -> output_string stdout "TF:\n"; Type.output_type stdout tf; output_string stdout "\nTES:\n"; List.iter (fun e -> Type.output_type stdout e) tes; raise AppError
        )
(* 型環境envの元で, 式eの型を返す *)
let rec get_typ env = function
| Unit(p) -> Type.Unit
| Bool(_, p) -> Type.Bool
| Int(_, p) -> Type.Int
| Float(_, p) -> Type.Float
| Not(e, p) -> Type.Bool
| Neg(e, p) -> Type.Int
| Add(e1, e2, p) | Sub(e1, e2, p) -> (* 足し算（と引き算）の型推論 *)
    Type.Int
| FNeg(e, p) ->
    Type.Float
| FAdd(e1, e2, p) | FSub(e1, e2, p) | FMul(e1, e2, p) | FDiv(e1, e2, p) ->
    Type.Float
| Eq(e1, e2, p) | LE(e1, e2, p) ->
    Type.Bool
| If(e1, e2, e3, p) ->
    get_typ env e2
| Let((x, t), e1, e2, p) -> (* letの型推論 *)
    get_typ (M.add x t env) e2
| Var(x, p) when M.mem x env -> M.find x env (* 変数の型推論 *)
| Var(x, p) when M.mem x !extenv -> M.find x !extenv
| Var(x, p) -> raise UndefinedVarError
| LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) -> (* let recの型推論 *)
    get_typ (M.add x t env) e2
| App(e, es, p) -> (* 関数適用の型推論 *)
    let te = get_typ env e in
    let tes = List.map (fun e -> get_typ env e) es in
    get_typ_app te tes
| Tuple(es, p) -> Type.Tuple(List.map (get_typ env) es)
| LetTuple(xts, e1, e2, p) ->
    get_typ (M.add_list xts env) e2
| Array(e1, e2, p) -> (* must be a primitive for "polymorphic" typing *)
    Type.Array(get_typ env e2)
| Get(e1, e2, p) ->
    let t = Type.gentyp () in
    unify p (Type.Array(t)) (g env e1);
    unify p Type.Int (g env e2);
    (
        match get_typ env e1 with
        | Type.Array(tt) -> tt
        | e -> e
    )
| Put(e1, e2, e3, p) ->
    Type.Unit

(* 環境envの下で, 式eのeta展開を行う関数 *)
let rec eta env = function
| App(e1, e2, p) ->
(
    let e1 = eta env e1 in (* e1(関数)をeta展開 *)
    let e2 = List.map (fun e -> eta env e) e2 in (* e2(引数のリスト)をeta展開 *)
    let e = App(e1, e2, p) in (* eを更新 *)
    (* output_string stdout "EXP:\n"; *)
    (* Syntax.output_prog stdout e; *)
    let t = get_typ env e in (* eの型 *)
    (* output_string stdout "\nt1\n"; *)
    (* Type.output_type stdout t1; *)
    let t1 = get_typ env e1 in (* e1の型 *)
    (* output_string stdout "\nt\n"; *)
    (* Type.output_type stdout t; *)
    match t, t1 with
    | FunCurry(f, g, n), FunCurry(f1, g1, m) when n = m -> (* 適用が部分適用だったら *)
    (
        let yts = make_abst_args [] t in (* 新しい関数抽象用の引数の型を作る *)
        let yts' = List.map (fun (x, t) -> Var(x, p)) yts in (* 関数適用は式で渡す *)
        let x = Id.genid "lambda_abst" in 
        LetRec({ name = (x, t); args = yts; body = App(e1, e2 @ yts', p) }, Var(x, p), p)
    )
    | _ -> e (* 適用が部分適用ではないときはそのまま *)
)
| Unit(_) | Bool(_) | Int(_) | Float(_) | Var(_) as e -> e
| Not(e, p) -> Not(eta env e, p)
| Neg(e, p) -> Neg(eta env e, p)
| Add(e1, e2, p) -> Add(eta env e1, eta env e2, p) 
| Sub(e1, e2, p) -> Sub(eta env e1, eta env e2, p) 
| FNeg(e, p) -> FNeg(eta env e, p)
| FAdd(e1, e2, p) -> FAdd(eta env e1, eta env e2, p) 
| FSub(e1, e2, p) -> FSub(eta env e1, eta env e2, p) 
| FMul(e1, e2, p) -> FMul(eta env e1, eta env e2, p) 
| FDiv(e1, e2, p) -> FDiv(eta env e1, eta env e2, p) 
| Eq(e1, e2, p) -> Eq(eta env e1, eta env e2, p) 
| LE(e1, e2, p) -> LE(eta env e1, eta env e2, p) 
| If(e1, e2, e3, p) -> If(eta env e1, eta env e2, eta env e3, p) 
| Let((x, t), e1, e2, p) -> Let((x, t), eta env e1, eta (M.add x t env) e2, p)
| LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) -> 
    let env = M.add x t env in
    LetRec({ name = (x, t); args = yts; body = eta (M.add_list yts env) e1 }, eta env e2, p)
| Tuple(es, p) -> Tuple((List.map (fun e -> eta env e) es), p)
| LetTuple(xts, e1, e2, p) -> LetTuple(xts, eta env e1, eta (M.add_list xts env) e2, p)
| Array(e1, e2, p) -> Array(eta env e1, eta env e2, p) 
| Get(e1, e2, p) -> Get(eta env e1, eta env e2, p) 
| Put(e1, e2, e3, p) -> Put(eta env e1, eta env e2, eta env e3, p) 

let f e =
  extenv := M.empty;

  (* (match deref_typ (g M.empty e) with
  | Type.Unit -> ()
  | _ -> Format.eprintf "warning: final result does not have type unit@."); *)

  (try unify Syntax.top_pos Type.Unit (g M.empty e)
  with 
    | Unify _ -> failwith "top level does not have type unit"
    | Error (_, _, _, p) -> print_newline (); failwith (Printf.sprintf "top level Error in line %d" p));
  extenv := M.map deref_typ !extenv;
  let e' = deref_term e in 
  let e' = eta M.empty e' in
  Syntax.output_prog stdout e';
  extenv := uncurry_env !extenv;
  uncurry_term e'
