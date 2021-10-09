(* give names to intermediate values (K-normalization) *)

type t = (* K正規化後の式 (caml2html: knormal_t) *)
  | Unit
  | Int of int
  | Float of float
  | Neg of Id.t
  | Add of Id.t * Id.t
  | Sub of Id.t * Id.t
  | FNeg of Id.t
  | FAdd of Id.t * Id.t
  | FSub of Id.t * Id.t
  | FMul of Id.t * Id.t
  | FDiv of Id.t * Id.t
  | IfEq of Id.t * Id.t * t * t (* 比較 + 分岐 (caml2html: knormal_branch) *)
  | IfLE of Id.t * Id.t * t * t (* 比較 + 分岐 *)
  | Let of (Id.t * Type.t) * t * t
  | Var of Id.t
  | LetRec of fundef * t
  | App of Id.t * Id.t list
  | Tuple of Id.t list
  | LetTuple of (Id.t * Type.t) list * Id.t * t
  | Get of Id.t * Id.t
  | Put of Id.t * Id.t * Id.t
  | ExtArray of Id.t
  | ExtFunApp of Id.t * Id.t list
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }

let rec fv = function (* 式に出現する（自由な）変数 (caml2html: knormal_fv) *)
  | Unit | Int(_) | Float(_) | ExtArray(_) -> S.empty
  | Neg(x) | FNeg(x) -> S.singleton x
  | Add(x, y) | Sub(x, y) | FAdd(x, y) | FSub(x, y) | FMul(x, y) | FDiv(x, y) | Get(x, y) -> S.of_list [x; y]
  | IfEq(x, y, e1, e2) | IfLE(x, y, e1, e2) -> S.add x (S.add y (S.union (fv e1) (fv e2)))
  | Let((x, t), e1, e2) -> S.union (fv e1) (S.remove x (fv e2))
  | Var(x) -> S.singleton x
  | LetRec({ name = (x, t); args = yts; body = e1 }, e2) ->
      let zs = S.diff (fv e1) (S.of_list (List.map fst yts)) in
      S.diff (S.union zs (fv e2)) (S.singleton x)
  | App(x, ys) -> S.of_list (x :: ys)
  | Tuple(xs) | ExtFunApp(_, xs) -> S.of_list xs
  | Put(x, y, z) -> S.of_list [x; y; z]
  | LetTuple(xs, y, e) -> S.add y (S.diff (fv e) (S.of_list (List.map fst xs)))

let insert_let (e, t) k = (* letを挿入する補助関数 (caml2html: knormal_insert) *)
(* 
    式eを受け取り, 新しい変数xを作って, let x = e in ...という式を返す. ただしeが最初から変数のときは, それをxとして利用し, letは挿入しない.
    inの中を作るための関数kも引数として受け取り, kをxに適用した結果を...の部分として利用する.

    Args
        (e, t) : kNormal.t * Type.t
          変換したい式とその型の組
        k : Id.t -> kNormal.t * Type.t
          変換の内容を記述する関数

    Returns
        retval : kNormal.t * Type.t
          K正規化変換後の式とその型の組

*)

  match e with
  | Var(x) -> k x
  | _ ->
      let x = Id.gentmp t in
      let e', t' = k x in
      Let((x, t), e, e'), t'

let rec g env = function (* K正規化ルーチン本体 (caml2html: knormal_g) *)
(* 
    与えられた式sを型環境envの下で, K正規化を行なってK正規化後のデータ型に変換する.

    Args
        env : 
          型環境
        s : Syntax.t
          式

    Returns
        retval : kNormal.t * Type.t
          K正規化変換後の式とその型の組

*)
  | Syntax.Unit(p) -> Unit, Type.Unit
  | Syntax.Bool(b, p) -> Int(if b then 1 else 0), Type.Int (* 論理値true, falseを整数1, 0に変換 (caml2html: knormal_bool) *)
  | Syntax.Int(i, p) -> Int(i), Type.Int
  | Syntax.Float(d, p) -> Float(d), Type.Float
  | Syntax.Not(e, p) -> g env (Syntax.If(e, Syntax.Bool(false, p), Syntax.Bool(true, p), p))
  | Syntax.Neg(e, p) ->
      insert_let (g env e)
        (fun x -> Neg(x), Type.Int)
  | Syntax.Add(e1, e2, p) -> (* 足し算のK正規化 (caml2html: knormal_add) *)
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> Add(x, y), Type.Int))
  | Syntax.Sub(e1, e2, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> Sub(x, y), Type.Int))
  | Syntax.FNeg(e, p) ->
      insert_let (g env e)
        (fun x -> FNeg(x), Type.Float)
  | Syntax.FAdd(e1, e2, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> FAdd(x, y), Type.Float))
  | Syntax.FSub(e1, e2, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> FSub(x, y), Type.Float))
  | Syntax.FMul(e1, e2, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> FMul(x, y), Type.Float))
  | Syntax.FDiv(e1, e2, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> FDiv(x, y), Type.Float))
  | Syntax.Eq (_, _, p) | Syntax.LE (_, _, p) as cmp ->
      g env (Syntax.If(cmp, Syntax.Bool(true, p), Syntax.Bool(false, p), p))
  | Syntax.If(Syntax.Not(e1, p1), e2, e3, p2) -> g env (Syntax.If(e1, e3, e2, p2)) (* notによる分岐を変換 (caml2html: knormal_not) *)
  | Syntax.If(Syntax.Eq(e1, e2, p1), e3, e4, p2) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y ->
              let e3', t3 = g env e3 in
              let e4', t4 = g env e4 in
              IfEq(x, y, e3', e4'), t3))
  | Syntax.If(Syntax.LE(e1, e2, p1), e3, e4, p2) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y ->
              let e3', t3 = g env e3 in
              let e4', t4 = g env e4 in
              IfLE(x, y, e3', e4'), t3))
  | Syntax.If(e1, e2, e3, p) -> g env (Syntax.If(Syntax.Eq(e1, Syntax.Bool(false, p), p), e3, e2, p)) (* 比較のない分岐を変換 (caml2html: knormal_if) *)
  | Syntax.Let((x, t), e1, e2, p) ->
      let e1', t1 = g env e1 in
      let e2', t2 = g (M.add x t env) e2 in
      Let((x, t), e1', e2'), t2
  | Syntax.Var(x, p) when M.mem x env -> Var(x), M.find x env
  | Syntax.Var(x, p) -> (* 外部配列の参照 (caml2html: knormal_extarray) *)
      (match M.find x !Typing.extenv with
      | Type.Array(_) as t -> ExtArray x, t
      | _ -> failwith (Printf.sprintf "external variable %s does not have an array type" x))
  | Syntax.LetRec({ Syntax.name = (x, t); Syntax.args = yts; Syntax.body = e1 }, e2, p) ->
      let env' = M.add x t env in
      let e2', t2 = g env' e2 in
      let e1', t1 = g (M.add_list yts env') e1 in
      LetRec({ name = (x, t); args = yts; body = e1' }, e2'), t2
  | Syntax.App(Syntax.Var(f, p1), e2s, p2) when not (M.mem f env) -> (* 外部関数の呼び出し (caml2html: knormal_extfunapp) *)
      (match M.find f !Typing.extenv with
      | Type.Fun(_, t) ->
          let rec bind xs = function (* "xs" are identifiers for the arguments *)
            | [] -> ExtFunApp(f, xs), t
            | e2 :: e2s ->
                insert_let (g env e2)
                  (fun x -> bind (xs @ [x]) e2s) in
          bind [] e2s (* left-to-right evaluation *)
      | _ -> assert false)
  | Syntax.App(e1, e2s, p) ->
      (match g env e1 with
      | _, Type.Fun(_, t) as g_e1 ->
          insert_let g_e1
            (fun f ->
              let rec bind xs = function (* "xs" are identifiers for the arguments *)
                | [] -> App(f, xs), t
                | e2 :: e2s ->
                    insert_let (g env e2)
                      (fun x -> bind (xs @ [x]) e2s) in
              bind [] e2s) (* left-to-right evaluation *)
      | _ -> assert false)
  | Syntax.Tuple(es, p) ->
      let rec bind xs ts = function (* "xs" and "ts" are identifiers and types for the elements *)
        | [] -> Tuple(xs), Type.Tuple(ts)
        | e :: es ->
            let _, t as g_e = g env e in
            insert_let g_e
              (fun x -> bind (xs @ [x]) (ts @ [t]) es) in
      bind [] [] es
  | Syntax.LetTuple(xts, e1, e2, p) ->
      insert_let (g env e1)
        (fun y ->
          let e2', t2 = g (M.add_list xts env) e2 in
          LetTuple(xts, y, e2'), t2)
  | Syntax.Array(e1, e2, p) ->
      insert_let (g env e1)
        (fun x ->
          let _, t2 as g_e2 = g env e2 in
          insert_let g_e2
            (fun y ->
              let l =
                match t2 with
                | Type.Float -> "create_float_array"
                | _ -> "create_array" in
              ExtFunApp(l, [x; y]), Type.Array(t2)))
  | Syntax.Get(e1, e2, p) ->
      (match g env e1 with
      |        _, Type.Array(t) as g_e1 ->
          insert_let g_e1
            (fun x -> insert_let (g env e2)
                (fun y -> Get(x, y), t))
      | _ -> assert false)
  | Syntax.Put(e1, e2, e3, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> insert_let (g env e3)
                (fun z -> Put(x, y, z), Type.Unit)))

let f e = fst (g M.empty e)


let rec output_knormal outchan k = 
  match k with
  | Unit -> ()
  | Int (i) -> output_string outchan (string_of_int i)
  | Float (f) -> output_string outchan (string_of_float f)
  | Neg (t) -> 
  (
    output_string outchan "Neg( ";
    Id.output_id outchan t;
    output_string outchan " )"
  )
  | Add (t1, t2) ->
  (
    output_string outchan "Add( ";
    Id.output_id outchan t1;
    output_string outchan ", ";
    Id.output_id outchan t2;
    output_string outchan " )"
  )
  | Sub (t1, t2) ->
  (
    output_string outchan "Sub( ";
    Id.output_id outchan t1;
    output_string outchan ", ";
    Id.output_id outchan t2;
    output_string outchan " )"
  )
  | FNeg (t) -> 
  (
    output_string outchan "FNeg( ";
    Id.output_id outchan t;
    output_string outchan " )"
  )
  | FAdd (t1, t2) ->
  (
    output_string outchan "FAdd( ";
    Id.output_id outchan t1;
    output_string outchan ", ";
    Id.output_id outchan t2;
    output_string outchan " )"
  )
  | FSub (t1, t2) ->
  (
    output_string outchan "FSub( ";
    Id.output_id outchan t1;
    output_string outchan ", ";
    Id.output_id outchan t2;
    output_string outchan " )"
  )
  | FMul (t1, t2) ->
  (
    output_string outchan "FMul( ";
    Id.output_id outchan t1;
    output_string outchan ", ";
    Id.output_id outchan t2;
    output_string outchan " )"
  )
  | FDiv (t1, t2) ->
  (
    output_string outchan "FDiv( ";
    Id.output_id outchan t1;
    output_string outchan ", ";
    Id.output_id outchan t2;
    output_string outchan " )"
  )
  | IfEq (t1, t2, t3, t4) -> (* 比較 + 分岐 (caml2html: knormal_branch) *)
  (
    output_string outchan "IfEq( ";
    Id.output_id outchan t1;
    output_string outchan ", ";
    Id.output_id outchan t2;
    output_string outchan ", ";
    output_knormal outchan t3;
    output_string outchan ", ";
    output_knormal outchan t4;
    output_string outchan " )"
  )
  | IfLE (t1, t2, t3, t4) -> (* 比較 + 分岐 (caml2html: knormal_branch) *)
  (
    output_string outchan "IfLE( ";
    Id.output_id outchan t1;
    output_string outchan ", ";
    Id.output_id outchan t2;
    output_string outchan ", ";
    output_knormal outchan t3;
    output_string outchan ", ";
    output_knormal outchan t4;
    output_string outchan " )"
  )
  | Let (t1, t2, t3) ->
  (
    output_string outchan "Let( ";
    Id.output_id outchan (fst t1);
    output_string outchan ", ";
    output_knormal outchan t2;
    output_string outchan ", ";
    output_knormal outchan t3;
    output_string outchan " )"
  )
  | Var (x) -> Id.output_id outchan x
  | LetRec ({ name = f; args = a; body = b }, t) ->
  (
    output_string outchan "LetRec( { name = ";
    Id.output_id outchan (fst f);
    output_string outchan ", args = ( ";
    Id.output_id_list outchan (fst (List.split a));
    output_string outchan " ), body = ";
    output_knormal outchan b;
    output_string outchan " }, ";
    output_knormal outchan t;
    output_string outchan " )";
  )
  | App (t, ts) ->
  (
    output_string outchan "App( ";
    Id.output_id outchan t;
    Id.output_id_list outchan ts;
    output_string outchan " )"

  )
  | Tuple (ts) ->
  (
    output_string outchan "( ";
    Id.output_id_list outchan ts;
    output_string outchan " )"
  )
  | LetTuple (t1s, t2, t3) ->
  (
    output_string outchan "Let( ( ";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan " ), ";
    Id.output_id outchan t2;
    output_string outchan ", ";
    output_knormal outchan t3;
    output_string outchan " )";
  )
  | Get (t1, t2) ->
  (
    output_string outchan "Get( ";
    Id.output_id outchan t1;
    output_string outchan ", ";
    Id.output_id outchan t2;
    output_string outchan " )"
  )
  | Put (t1, t2, t3) ->
  (
    output_string outchan "Put( ";
    Id.output_id outchan t1;
    output_string outchan ", ";
    Id.output_id outchan t2;
    output_string outchan ", ";
    Id.output_id outchan t3;
    output_string outchan " )"
  )
  | ExtArray (t) ->
  (
    output_string outchan "ExtArray( ";
    Id.output_id outchan t;
    output_string outchan " )"
  )
  | ExtFunApp (t, ts) ->
  (
    output_string outchan "ExtFunApp( ";
    Id.output_id outchan t;
    Id.output_id_list outchan ts;
    output_string outchan " )"
  )
