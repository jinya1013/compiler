type closure = { entry : Id.l; actual_fv : Id.t list } (* トップレベル関数のラベル, 自由変数のリスト *)
type t = (* クロージャ変換後の式 (caml2html: closure_t) *)
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
  | IfEq of Id.t * Id.t * t * t
  | IfLE of Id.t * Id.t * t * t
  | Let of (Id.t * Type.t) * t * t
  | Var of Id.t
  | MakeCls of (Id.t * Type.t) * closure * t  (*(関数名, 関数の型), クロージャ, 関数の本体 *)
  | AppCls of Id.t * Id.t list
  | AppDir of Id.l * Id.t list
  | Tuple of Id.t list
  | LetTuple of (Id.t * Type.t) list * Id.t * t
  | Get of Id.t * Id.t
  | Put of Id.t * Id.t * Id.t
  | ExtArray of Id.l
type fundef = { name : Id.l * Type.t;
                args : (Id.t * Type.t) list;
                formal_fv : (Id.t * Type.t) list;
                body : t }
type prog = Prog of fundef list * t

let rec fv = function
(* 
    与えられたクロージャ変換後の式cの中に含まれる自由変数のリストを出力する.

    Args
        c : Closure.t
          自由変数の変数を計算したいクロージャ変換後の式

    Returns
        retval : S.t
          cが含む自由変数の集合            
*)
  | Unit | Int(_) | Float(_) | ExtArray(_) -> S.empty
  | Neg(x) | FNeg(x) -> S.singleton x
  | Add(x, y) | Sub(x, y) | FAdd(x, y) | FSub(x, y) | FMul(x, y) | FDiv(x, y) | Get(x, y) -> S.of_list [x; y]
  | IfEq(x, y, e1, e2)| IfLE(x, y, e1, e2) -> S.add x (S.add y (S.union (fv e1) (fv e2)))
  | Let((x, t), e1, e2) -> S.union (fv e1) (S.remove x (fv e2))
  | Var(x) -> S.singleton x
  | MakeCls((x, t), { entry = l; actual_fv = ys }, e) -> S.remove x (S.union (S.of_list ys) (fv e))
  | AppCls(x, ys) -> S.of_list (x :: ys)
  | AppDir(_, xs) | Tuple(xs) -> S.of_list xs
  | LetTuple(xts, y, e) -> S.add y (S.diff (fv e) (S.of_list (List.map fst xts)))
  | Put(x, y, z) -> S.of_list [x; y; z]

let toplevel : fundef list ref = ref []

let rec g env known = function (* クロージャ変換ルーチン本体 (caml2html: closure_g) *)
(* 
    環境envと自由変数がないとわかっている関数の集合known, K正規化後の式kを受け取ってそれをクロージャ変換する.

    Args
        env : M.t
          現在の変数名と,その型のマッピング
        known : S.t
          自由変数を持たないことがわかっているトップレベル関数の集合

        k : KNormal.t
          変換したいK正規化後の式

    Returns
        retval : Closure.t
          クロージャ変換後の式   

*)
  | KNormal.Unit -> Unit
  | KNormal.Int(i) -> Int(i)
  | KNormal.Float(d) -> Float(d)
  | KNormal.Neg(x) -> Neg(x)
  | KNormal.Add(x, y) -> Add(x, y)
  | KNormal.Sub(x, y) -> Sub(x, y)
  | KNormal.FNeg(x) -> FNeg(x)
  | KNormal.FAdd(x, y) -> FAdd(x, y)
  | KNormal.FSub(x, y) -> FSub(x, y)
  | KNormal.FMul(x, y) -> FMul(x, y)
  | KNormal.FDiv(x, y) -> FDiv(x, y)
  | KNormal.IfEq(x, y, e1, e2) -> IfEq(x, y, g env known e1, g env known e2)
  | KNormal.IfLE(x, y, e1, e2) -> IfLE(x, y, g env known e1, g env known e2)
  | KNormal.Let((x, t), e1, e2) -> Let((x, t), g env known e1, g (M.add x t env) known e2)
  | KNormal.Var(x) -> Var(x)
  | KNormal.LetRec({ KNormal.name = (x, t); KNormal.args = yts; KNormal.body = e1 }, e2) -> (* 関数定義の場合 (caml2html: closure_letrec) *)
      (* 関数定義let rec x y1 ... yn = e1 in e2の場合は、
         xに自由変数がない(closureを介さずdirectに呼び出せる)
         と仮定し、knownに追加してe1をクロージャ変換してみる *)
      let toplevel_backup = !toplevel in
      let env' = M.add x t env in
      let known' = S.add x known in
      let e1' = g (M.add_list yts env') known' e1 in
      (* 本当に自由変数がなかったか、変換結果e1'を確認する *)
      (* 注意: e1'にx自身が変数として出現する場合はclosureが必要!
         (thanks to nuevo-namasute and azounoman; test/cls-bug2.ml参照) *)
      let zs = S.diff (fv e1') (S.of_list (List.map fst yts)) in
      let known', e1' =
        if S.is_empty zs then known', e1' else
        (* e1に自由変数が含まれるなら状態(toplevelの値)を戻して、クロージャ変換をやり直す *)
        (Format.eprintf "free variable(s) %s found in function %s@." (Id.pp_list (S.elements zs)) x;
         Format.eprintf "function %s cannot be directly applied in fact@." x;
         toplevel := toplevel_backup;
         let e1' = g (M.add_list yts env') known e1 in
         known, e1') in
      let zs = S.elements (S.diff (fv e1') (S.add x (S.of_list (List.map fst yts)))) in (* 自由変数のリスト *)
      let zts = List.map (fun z -> (z, M.find z env')) zs in (* ここで自由変数zの型を引くために引数envが必要 *)
      toplevel := { name = (Id.L(x), t); args = yts; formal_fv = zts; body = e1' } :: !toplevel; (* トップレベル関数を追加 *)
      let e2' = g env' known' e2 in
      if S.mem x (fv e2') then (* xが変数としてe2'に出現するか *)
        MakeCls((x, t), { entry = Id.L(x); actual_fv = zs }, e2') (* 出現していたら削除しない *)
      else
        (Format.eprintf "eliminating closure(s) %s@." x;
         e2') (* 出現しなければMakeClsを削除 *)
  | KNormal.App(x, ys) when S.mem x known -> (* 関数適用の場合 (caml2html: closure_app) *)
      Format.eprintf "directly applying %s@." x;
      AppDir(Id.L(x), ys)
  | KNormal.App(f, xs) -> AppCls(f, xs)
  | KNormal.Tuple(xs) -> Tuple(xs)
  | KNormal.LetTuple(xts, y, e) -> LetTuple(xts, y, g (M.add_list xts env) known e)
  | KNormal.Get(x, y) -> Get(x, y)
  | KNormal.Put(x, y, z) -> Put(x, y, z)
  | KNormal.ExtArray(x) -> ExtArray(Id.L(x))
  | KNormal.ExtFunApp(x, ys) -> AppDir(Id.L("min_caml_" ^ x), ys)

let f e =
(*
  モジュール内の変数toplevelを空リストで初期化して, Closure.gを呼ぶ.
  この空リストはトップレベル関数を記録するのに使われる.

  Args
    e : KNormal.t
    変換前の式(プログラム)

  Returns
    retval : Closure.plog
      変換後のプログラム(トップレベル関数のリストと変換後の式の組) 
*)
  toplevel := [];
  let e' = g M.empty S.empty e in
  Prog(List.rev !toplevel, e')

let rec output_closure outchan e depth = 
(* 
    与えられた正規化後の式kをチャネルoutchanに出力する.

    Args
        outchan : out_channel
          出力先のチャンネル
        e : Closure.t
          出力するクロージャ変換後の式
        depth : int
          構文解析木の深さ

    Returns
        retval : unit
          なし            
*)
  match e with
  | Unit -> ()
  | Int i -> 
  (
    Id.output_tab outchan depth;
    output_string outchan ("INT " ^ (string_of_int i))
  )
  | Float f -> 
  (
    Id.output_tab outchan depth;
    output_string outchan ("FLOAT " ^ (string_of_float f))
  )
  | Neg t ->
  (
    Id.output_tab outchan depth;
    output_string outchan "NEG ";
    Id.output_id outchan t;
  )
  | Add (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "ADD ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | Sub (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "SUB ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FNeg (t) -> 
  (
    Id.output_tab outchan depth;
    output_string outchan "FNEG ";
    Id.output_id outchan t;
  )
  | FAdd (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FADD ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FSub (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FSUB ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FMul (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FMUL ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FDiv (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FDIV ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | IfEq (t1, t2, t3, t4) -> (* 比較 + 分岐 (caml2html: knormal_branch) *)
  (
    Id.output_tab outchan depth;
    output_string outchan "IFEQ ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_closure outchan t3 (depth + 1);
    output_closure outchan t4 (depth + 1);
  )
  | IfLE (t1, t2, t3, t4) -> (* 比較 + 分岐 (caml2html: knormal_branch) *)
  (
    Id.output_tab outchan depth;
    output_string outchan "IFLE ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_closure outchan t3 (depth + 1);
    output_closure outchan t4 (depth + 1);
  )
  | Let (t1, t2, t3) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "LET ";
    Id.output_id outchan (fst t1);
    output_closure outchan t2 (depth + 1);
    output_closure outchan t3 (depth + 1);
  )
  | Var (x) -> 
  (
    Id.output_tab outchan depth;
    output_string outchan "VAR ";
    Id.output_id outchan x;
  )
  | MakeCls ((funname, funtype), funclosure, funbody) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "MAKECLS { funname = ";
    Id.output_id outchan funname;
    output_string outchan " funtype = ";
    Type.output_type outchan funtype;
    Id.output_tab outchan (depth + 1);
    output_string outchan "funclosure = { ";
    output_funclosure outchan funclosure;
    output_string outchan " }";
    Id.output_tab outchan (depth + 1);
    output_string outchan "funcbody = { ";
    output_closure outchan funbody (depth + 1);
    output_string outchan " }";
  )
  | AppCls (funname, funargs) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "APPCLS ";
    Id.output_id outchan funname;
    output_string outchan " "; 
    Id.output_id_list outchan funargs;
  )
  | AppDir (funlabel, funargs) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "APPDIR ";
    Id.output_label outchan funlabel;
    output_string outchan " "; 
    Id.output_id_list outchan funargs;
  )
  | Tuple (ts) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "(";
    Id.output_id_list outchan ts;
    output_string outchan ")"
  )
  | LetTuple (t1s, t2, t3) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "LET ";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan ")";
    output_string outchan " ";
    Id.output_id outchan t2;
    output_closure outchan t3 (depth + 1);
  )
  | Get (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "GET ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | Put (t1, t2, t3) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "PUT ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_string outchan " ";
    Id.output_id outchan t3;
  )
  | ExtArray (t) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "EXTARRAY ";
    Id.output_label outchan t;
  )

and output_funclosure outchan { entry = funlabel; actual_fv = funfv } = 
    output_string outchan "{ entry : ";
    Id.output_label outchan funlabel;
    output_string outchan " , actual_fv : ";
    Id.output_id_list outchan funfv;
    output_string outchan " }";

and output_fundef outchan { name = funname; args = funargs; formal_fv = funfv; body = funbody } depth = 
    Id.output_tab outchan depth;
    output_string outchan "{ name : ";
    Id.output_label outchan (fst(funname));
    output_string outchan " , args : ";
    Id.output_id_list outchan (fst (List.split funargs));
    output_string outchan " , formal_fv : ";
    Id.output_id_list outchan (fst (List.split funfv));
    output_string outchan " , body : ";
    output_closure outchan funbody depth;
    output_string outchan " }";

and output_fundef_list outchan ds depth = 
  let f d =
      output_fundef outchan d depth
  in List.iter f ds;

and output_prog outchan (Prog (top, e)) depth = 
  output_string outchan "TOPLEVEL";
  output_fundef_list outchan top (depth + 1);
  Id.output_tab outchan depth;
  output_string outchan "MAIN";
  output_closure outchan e (depth + 1)