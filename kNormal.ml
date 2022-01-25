(* give names to intermediate values (K-normalization) *)

type t = (* K正規化後の式 (caml2html: knormal_t) *)
  | Unit of Syntax.pos
  | Int of int * Syntax.pos
  | Float of float * Syntax.pos
  | Neg of Id.t * Syntax.pos
  | Add of Id.t * Id.t * Syntax.pos
  | Sub of Id.t * Id.t * Syntax.pos
  | FNeg of Id.t * Syntax.pos
  | FSqrt of Id.t * Syntax.pos
  | Floor of Id.t * Syntax.pos
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
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }

let rec fv = function (* 式に出現する（自由な）変数 (caml2html: knormal_fv) *)
  | Unit(p) | Int(_, p) | Float(_, p) | ExtArray(_, p) -> S.empty
  | Neg(x, p) | FNeg(x, p) | FSqrt(x, p) | Floor(x, p) -> S.singleton x
  | Add(x, y, p) | Sub(x, y, p) | FAdd(x, y, p) | FSub(x, y, p) | FMul(x, y, p) | FDiv(x, y, p) | Get(x, y, p) -> S.of_list [x; y]
  | IfEq(x, y, e1, e2, p) | IfLE(x, y, e1, e2, p) -> S.add x (S.add y (S.union (fv e1) (fv e2)))
  | Let((x, t), e1, e2, p) -> S.union (fv e1) (S.remove x (fv e2))
  | Var(x, p) -> S.singleton x
  | LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) ->
      let zs = S.diff (fv e1) (S.of_list (List.map fst yts)) in
      S.diff (S.union zs (fv e2)) (S.singleton x)
  | App(x, ys, p) -> S.of_list (x :: ys)
  | Tuple(xs, p) | ExtFunApp(_, xs, p) -> S.of_list xs
  | Put(x, y, z, p) -> S.of_list [x; y; z]
  | LetTuple(xs, y, e, p) -> S.add y (S.diff (fv e) (S.of_list (List.map fst xs)))

let insert_let p (e, t) k = (* letを挿入する補助関数 (caml2html: knormal_insert) *)
(* 
    式eを受け取り, 新しい変数xを作って, let x = e in ...という式を返す. ただしeが最初から変数のときは, それをxとして利用し, letは挿入しない.
    inの中を作るための関数kも引数として受け取り, kをxに適用した結果を...の部分として利用する.

    Args
        (e, t) : kNormal.t * Type.t
          変換したい式とその型の組
        k : Id.t -> kNormal.t * Type.t
          変換の内容を記述する関数, 

    Returns
        retval : kNormal.t * Type.t
          K正規化変換後の式とその型の組

*)

  match e with
  | Var(x, _) -> k x
  | _ ->
      let x = Id.gentmp t in
      let e', t' = k x in
      Let((x, t), e, e', p), t'

let rec g env = function (* K正規化ルーチン本体 (caml2html: knormal_g) *)
(* 
    与えられた式sを変数環境envの下で, K正規化を行なってK正規化後のデータ型に変換する.

    Args
        env : 
          変数環境
        s : Syntax.t
          式

    Returns
        retval : kNormal.t * Type.t
          K正規化変換後の式とその型の組

*)
  | Syntax.Unit(p) -> Unit(p), Type.Unit
  | Syntax.Bool(b, p) -> Int((if b then 1 else 0), p), Type.Int (* 論理値true, falseを整数1, 0に変換 (caml2html: knormal_bool) *)
  | Syntax.Int(i, p) -> Int(i, p), Type.Int
  | Syntax.Float(d, p) -> Float(d, p), Type.Float
  | Syntax.Not(e, p) -> g env (Syntax.If(e, Syntax.Bool(false, p), Syntax.Bool(true, p), p))
  | Syntax.Neg(e, p) ->
      insert_let p (g env e)
        (fun x -> Neg(x, p), Type.Int)
  | Syntax.Add(e1, e2, p) -> (* 足し算のK正規化 (caml2html: knormal_add) *)
      insert_let p (g env e1)
        (fun x -> insert_let p (g env e2)
            (fun y -> Add(x, y, p), Type.Int))
  | Syntax.Sub(e1, e2, p) ->
      insert_let p (g env e1)
        (fun x -> insert_let p (g env e2)
            (fun y -> Sub(x, y, p), Type.Int))
  | Syntax.FNeg(e, p) ->
      insert_let p (g env e)
        (fun x -> FNeg(x, p), Type.Float)
  | Syntax.FSqrt(e, p) ->
      insert_let p (g env e)
        (fun x -> FSqrt(x, p), Type.Float)
  | Syntax.Floor(e, p) ->
      insert_let p (g env e)
        (fun x -> Floor(x, p), Type.Float)
  | Syntax.FAdd(e1, e2, p) ->
      insert_let p (g env e1)
        (fun x -> insert_let p (g env e2)
            (fun y -> FAdd(x, y, p), Type.Float))
  | Syntax.FSub(e1, e2, p) ->
      insert_let p (g env e1)
        (fun x -> insert_let p (g env e2)
            (fun y -> FSub(x, y, p), Type.Float))
  | Syntax.FMul(e1, e2, p) ->
      insert_let p (g env e1)
        (fun x -> insert_let p (g env e2)
            (fun y -> FMul(x, y, p), Type.Float))
  | Syntax.FDiv(e1, e2, p) ->
      insert_let p (g env e1)
        (fun x -> insert_let p (g env e2)
            (fun y -> FDiv(x, y, p), Type.Float))
  | Syntax.Eq (_, _, p) | Syntax.LE (_, _, p) as cmp ->
      g env (Syntax.If(cmp, Syntax.Bool(true, p), Syntax.Bool(false, p), p))
  | Syntax.If(Syntax.Not(e1, p1), e2, e3, p2) -> g env (Syntax.If(e1, e3, e2, p2)) (* notによる分岐を変換 (caml2html: knormal_not) *)
  | Syntax.If(Syntax.Eq(e1, e2, p1), e3, e4, p2) ->
      insert_let p1 (g env e1)
        (fun x -> insert_let p1 (g env e2)
            (fun y ->
              let e3', t3 = g env e3 in
              let e4', t4 = g env e4 in
              IfEq(x, y, e3', e4', p2), t3))
  | Syntax.If(Syntax.LE(e1, e2, p1), e3, e4, p2) ->
      insert_let p1 (g env e1)
        (fun x -> insert_let p1 (g env e2)
            (fun y ->
              let e3', t3 = g env e3 in
              let e4', t4 = g env e4 in
              IfLE(x, y, e3', e4', p2), t3))
  | Syntax.If(e1, e2, e3, p) -> g env (Syntax.If(Syntax.Eq(e1, Syntax.Bool(false, p), p), e3, e2, p)) (* 比較のない分岐を変換 (caml2html: knormal_if) *)
  | Syntax.Let((x, t), e1, e2, p) ->
      let e1', t1 = g env e1 in
      let e2', t2 = g (M.add x t env) e2 in
      Let((x, t), e1', e2', p), t2
  | Syntax.Var(x, p) when M.mem x !GlobalVar.genv -> Int(M.find x !GlobalVar.genv, p), M.find x !GlobalVar.gtenv (* グローバル変数をあらかじめ確保したメモリ上のアドレスに変換 *)
  | Syntax.Var(x, p) when M.mem x env -> Var(x, p), M.find x env
  | Syntax.Var(x, p) -> (* 外部配列の参照 (caml2html: knormal_extarray) *)
      (match M.find x !Typing.extenv with
      | Type.Array(_) as t -> ExtArray(x, p), t
      | _ -> failwith (Printf.sprintf "external variable %s does not have an array type" x))
  | Syntax.LetRec({ Syntax.name = (x, t); Syntax.args = yts; Syntax.body = e1 }, e2, p) ->
      let env' = M.add x t env in
      let e2', t2 = g env' e2 in
      let e1', t1 = g (M.add_list yts env') e1 in
      LetRec({ name = (x, t); args = yts; body = e1' }, e2', p), t2
  | Syntax.App(Syntax.Var(f, p1), e2s, p2) when not (M.mem f env) -> (* 外部関数の呼び出し (caml2html: knormal_extfunapp) *)
      (match M.find f !Typing.extenv with
      | Type.Fun(_, t) ->
          let rec bind xs = function (* "xs" are identifiers for the arguments *)
            | [] -> ExtFunApp(f, xs, p2), t
            | e2 :: e2s ->
                insert_let p2 (g env e2)
                  (fun x -> bind (xs @ [x]) e2s) in
          bind [] e2s (* left-to-right evaluation *)
      | _ -> assert false)
  | Syntax.App(e1, e2s, p) ->
      (match g env e1 with
      | _, Type.Fun(_, t) as g_e1 ->
          insert_let p g_e1
            (fun f ->
              let rec bind xs = function (* "xs" are identifiers for the arguments *)
                | [] -> App(f, xs, p), t
                | e2 :: e2s ->
                    insert_let p (g env e2)
                      (fun x -> bind (xs @ [x]) e2s) in
              bind [] e2s) (* left-to-right evaluation *)
      | _ -> assert false)
  | Syntax.Tuple(es, p) ->
      let rec bind xs ts = function (* "xs" and "ts" are identifiers and types for the elements *)
        | [] -> Tuple(xs, p), Type.Tuple(ts)
        | e :: es ->
            let _, t as g_e = g env e in
            insert_let p g_e
              (fun x -> bind (xs @ [x]) (ts @ [t]) es) in
      bind [] [] es
  | Syntax.LetTuple(xts, e1, e2, p) ->
      insert_let p (g env e1)
        (fun y ->
          let e2', t2 = g (M.add_list xts env) e2 in
          LetTuple(xts, y, e2', p), t2)
  | Syntax.Array(e1, e2, p) ->
      insert_let p (g env e1)
        (fun x ->
          let _, t2 as g_e2 = g env e2 in
          insert_let p g_e2
            (fun y ->
              let l =
                match t2 with
                | Type.Float -> "create_float_array"
                | _ -> "create_array" in
              ExtFunApp(l, [x; y], p), Type.Array(t2)))
  | Syntax.Get(e1, e2, p) ->
      (
        match g env e1 with
      |        _, Type.Array(t) as g_e1 ->
          insert_let p g_e1
            (fun x -> insert_let p (g env e2)
                (fun y -> Get(x, y, p), t))
      | _ -> assert false
      )
  | Syntax.Put(e1, e2, e3, p) ->
      (
        insert_let p (g env e3)
          (fun z -> insert_let p(g env e2)
              (fun y -> insert_let p (g env e1)
                  (fun x -> Put(x, y, z, p), Type.Unit)))
      )

let rec bool_to_int_type t = 
  match t with
  | Type.Bool -> Type.Int
  | Type.Fun(args, r) -> Type.Fun(List.map bool_to_int_type args, bool_to_int_type r)
  | Type.Tuple(ts) -> Type.Tuple(List.map bool_to_int_type ts)
  | Type.Array(t) -> Type.Array(bool_to_int_type t)
  | Type.Var(tref) when Option.is_some !tref -> 
    let t' = Option.get !tref in Type.Var(ref (Some(bool_to_int_type t')))
  | x -> x
let rec bool_to_int_exp = function
  | Let((x, t), e1, e2, p) -> Let((x, bool_to_int_type t), bool_to_int_exp e1,  bool_to_int_exp e2, p)
  | IfEq(x, y, e1, e2, p) -> IfEq(x, y, bool_to_int_exp e1, bool_to_int_exp e2, p) (* 比較 + 分岐 (caml2html: knormal_branch) *)
  | IfLE(x, y, e1, e2, p) -> IfLE(x, y, bool_to_int_exp e1, bool_to_int_exp e2, p) (* 比較 + 分岐 *)
  | LetRec({ name = (x, t); args = yts; body = e1}, e2, p) -> 
    LetRec({ name = (x, bool_to_int_type t); args = List.map (fun (x, t) -> (x, bool_to_int_type t)) yts; body = bool_to_int_exp e1}, bool_to_int_exp e2, p)
  | LetTuple(xts, e1, e2, p) -> LetTuple(List.map (fun (x, t) -> (x, bool_to_int_type t)) xts, e1, bool_to_int_exp e2, p)
  | x -> x
      

let f e = bool_to_int_exp (fst (g M.empty e))


let rec output_knormal outchan k depth = 
(* 
    与えられた正規化後の式kをチャネルoutchanに出力する.

    Args
        outchan : out_channel
          出力先のチャンネル
        k : KNormal.t
          出力する正規化後の式
        depth : int
          構文解析木の深さ

    Returns
        retval : unit
          なし            
*)
  match k with
  | Unit(p) -> 
  (
    Id.output_tab2 outchan (depth + 1) p
  )
  | Int (i, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan ("INT " ^ (string_of_int i))
  )
  | Float (f, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan ("FLOAT " ^ (string_of_float f))
  )
  | Neg (t, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "NEG ";
    Id.output_id outchan t;
  )
  | Add (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "ADD ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | Sub (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "SUB ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FNeg (t, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FNEG ";
    Id.output_id outchan t;
  )
  | FSqrt (t, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FSQRT ";
    Id.output_id outchan t;
  )
  | Floor (t, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FLOOR ";
    Id.output_id outchan t;
  )
  | FAdd (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FADD ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FSub (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FSUB ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FMul (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FMUL ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FDiv (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FDIV ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | IfEq (t1, t2, t3, t4, p) -> (* 比較 + 分岐 (caml2html: knormal_branch) *)
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "IFEQ ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_knormal outchan t3 (depth + 1);
    output_knormal outchan t4 (depth + 1);
  )
  | IfLE (t1, t2, t3, t4, p) -> (* 比較 + 分岐 (caml2html: knormal_branch) *)
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "IFLE ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_knormal outchan t3 (depth + 1);
    output_knormal outchan t4 (depth + 1);
  )
  | Let (t1, t2, t3, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LET ";
    Id.output_id outchan (fst t1);
    output_string outchan " : ";
    Type.output_type outchan (snd t1);
    output_knormal outchan t2 (depth + 1);
    output_knormal outchan t3 (depth + 1);
  )
  | Var (x, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "VAR ";
    Id.output_id outchan x;
  )
  | LetRec ({ name = f; args = a; body = b }, t, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LETREC ";
    Id.output_tab2 outchan depth p;
    output_string outchan "{";
    Id.output_tab2 outchan (depth + 1) p;
    output_string outchan "name = ";
    Id.output_id outchan (fst f);
    Id.output_tab2 outchan (depth + 1) p;
    output_string outchan "args = ";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split a));
    output_string outchan ")";
    Id.output_tab2 outchan (depth + 1) p;
    output_string outchan "body = ";
    output_knormal outchan b (depth + 2);
    Id.output_tab2 outchan depth p;
    output_string outchan "}";
    output_knormal outchan t (depth + 1); 
  )
  | App (t, ts, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "APP ";
    Id.output_id outchan t;
    output_string outchan " ";
    Id.output_id_list outchan ts;
  )
  | Tuple (ts, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "(";
    Id.output_id_list outchan ts;
    output_string outchan ")"
  )
  | LetTuple (t1s, t2, t3, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LET ";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan ")";
    output_string outchan " ";
    Id.output_id outchan t2;
    output_knormal outchan t3 (depth + 1);
  )
  | Get (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "GET ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | Put (t1, t2, t3, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "PUT ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_string outchan " ";
    Id.output_id outchan t3;
  )
  | ExtArray (t, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "EXTARRAY ";
    Id.output_id outchan t;
  )
  | ExtFunApp (t, ts, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "EXTFUNAPP ";
    Id.output_id outchan t;
    output_string outchan " ";
    Id.output_id_list outchan ts;
  )
and output_prog outchan k = 
(* 
    与えられた正規化後の式kをチャネルoutchanに出力する.

    Args
        outchan : out_channel
          出力先のチャンネル
        k : KNormal.t
          出力する正規化後の式

    Returns
        retval : unit
          なし            
*)
  (
    match k with
  | Unit(p) -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
  )
  | Int (i, p) -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan ("INT " ^ (string_of_int i))
  )
  | Float (f, p) -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan ("FLOAT " ^ (string_of_float f))
  )
  | Neg (t, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "NEG ";
    Id.output_id outchan t;
  )
  | Add (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "ADD ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | Sub (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "SUB ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FNeg (t, p) -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FNEG ";
    Id.output_id outchan t;
  )
  | FSqrt (t, p) -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FSQRT ";
    Id.output_id outchan t;
  )
  | Floor (t, p) -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FLOOR ";
    Id.output_id outchan t;
  )
  | FAdd (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FADD ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FSub (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FSUB ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FMul (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FMUL ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FDiv (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FDIV ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | IfEq (t1, t2, t3, t4, p) -> (* 比較 + 分岐 (caml2html: knormal_branch) *)
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "IFEQ ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_knormal outchan t3 1;
    output_knormal outchan t4 1;
  )
  | IfLE (t1, t2, t3, t4, p) -> (* 比較 + 分岐 (caml2html: knormal_branch) *)
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "IFLE ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_knormal outchan t3 1;
    output_knormal outchan t4 1;
  )
  | Let (t1, t2, t3, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "LET ";
    Id.output_id outchan (fst t1);
    output_string outchan " : ";
    Type.output_type outchan (snd t1);
    output_knormal outchan t2 1;
    output_knormal outchan t3 1;
  )
  | Var (x, p) -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "VAR ";
    Id.output_id outchan x;
  )
  | LetRec ({ name = f; args = a; body = b }, t, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "LETREC ";
    Id.output_tab2 outchan 0 p;
    output_string outchan "{";
    Id.output_tab2 outchan 1 p;
    output_string outchan "name = ";
    Id.output_id outchan (fst f);
    Id.output_tab2 outchan 1 p;
    output_string outchan "args = ";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split a));
    output_string outchan ")";
    Id.output_tab2 outchan 1 p;
    output_string outchan "body = ";
    output_knormal outchan b 2;
    Id.output_tab2 outchan 0 p;
    output_string outchan "}";
    output_knormal outchan t 1; 
  )
  | App (t, ts, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "APP ";
    Id.output_id outchan t;
    output_string outchan " ";
    Id.output_id_list outchan ts;
  )
  | Tuple (ts, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "(";
    Id.output_id_list outchan ts;
    output_string outchan ")"
  )
  | LetTuple (t1s, t2, t3, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "LET ";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan ")";
    output_string outchan " ";
    Id.output_id outchan t2;
    output_knormal outchan t3 1;
  )
  | Get (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "GET ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | Put (t1, t2, t3, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "PUT ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_string outchan " ";
    Id.output_id outchan t3;
  )
  | ExtArray (t, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "EXTARRAY ";
    Id.output_id outchan t;
  )
  | ExtFunApp (t, ts, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "EXTFUNAPP ";
    Id.output_id outchan t;
    output_string outchan " ";
    Id.output_id_list outchan ts;
  )
  );
  output_string outchan "\n";