open Asm


let rec sbst_id x1 x2 x =
  if x = x1 then x2 else x

let rec sbst_id_or_imm x1 x2 = function
| V(x) -> V(sbst_id x1 x2 x)
| C(i) -> C(i)

let rec sbst' x1 x2 = function
  | Mov(x) -> Mov(sbst_id x1 x2 x)
  | Neg(x) -> Neg(sbst_id x1 x2 x)
  | Add(x, y') -> Add(sbst_id x1 x2 x, sbst_id_or_imm x1 x2 y')
  | Sub(x, y') -> Sub(sbst_id x1 x2 x, sbst_id_or_imm x1 x2 y')
  | SLL(x, y') -> SLL(sbst_id x1 x2 x, sbst_id_or_imm x1 x2 y')
  | Ld(x, i) -> Ld(sbst_id x1 x2 x, i)
  | St(x, y, i) -> St(sbst_id x1 x2 x, sbst_id x1 x2 y, i)
  | FMovD(x) -> FMovD(sbst_id x1 x2 x)
  | FNegD(x) -> FNegD(sbst_id x1 x2 x)
  | FSqrtD(x) -> FSqrtD(sbst_id x1 x2 x)
  | FloorD(x) -> FloorD(sbst_id x1 x2 x)
  | FAddD(x, y) -> FAddD(sbst_id x1 x2 x, sbst_id x1 x2 y)
  | FSubD(x, y) -> FSubD(sbst_id x1 x2 x, sbst_id x1 x2 y)
  | FMulD(x, y) -> FMulD(sbst_id x1 x2 x, sbst_id x1 x2 y)
  | FDivD(x, y) -> FDivD(sbst_id x1 x2 x, sbst_id x1 x2 y)
  | LdDF(x, i) -> LdDF(sbst_id x1 x2 x, i)
  | StDF(x, y, i) -> StDF(sbst_id x1 x2 x, sbst_id x1 x2 y, i)
  (* virtual instructions *)
  | IfEq(x, y', e1, e2) -> IfEq(sbst_id x1 x2 x, sbst_id_or_imm x1 x2 y', sbst x1 x2 e1, sbst x1 x2 e2)
  | IfLE(x, y', e1, e2) -> IfLE(sbst_id x1 x2 x, sbst_id_or_imm x1 x2 y', sbst x1 x2 e1, sbst x1 x2 e2)
  | IfGE(x, y', e1, e2) -> IfGE(sbst_id x1 x2 x, sbst_id_or_imm x1 x2 y', sbst x1 x2 e1, sbst x1 x2 e2)
  | IfFEq(x, y, e1, e2) -> IfFEq(sbst_id x1 x2 x, sbst_id x1 x2 y, sbst x1 x2 e1, sbst x1 x2 e2)
  | IfFLE(x, y, e1, e2) -> IfFLE(sbst_id x1 x2 x, sbst_id x1 x2 y, sbst x1 x2 e1, sbst x1 x2 e2)
  (* closure address, integer arguments, and float arguments *)
  | CallCls(x, iargs, fargs) -> CallCls(sbst_id x1 x2 x, List.map (fun i -> sbst_id x1 x2 i) iargs, List.map (fun f -> sbst_id x1 x2 f) fargs)
  | CallDir(xl, iargs, fargs) -> CallDir(xl, List.map (fun i -> sbst_id x1 x2 i) iargs, List.map (fun f -> sbst_id x1 x2 f) fargs)
  | Save(x, y) -> Save(sbst_id x1 x2 x, sbst_id x1 x2 y)
  | Restore(x) -> Restore(sbst_id x1 x2 x)
  | e -> e
and sbst x1 x2 = function (* 命令列中の変数x1をx2で置き換える. ただし, 新たにx1への代入が行われている命令があればそれ以降は代入を行わない. *)
  | Ans(exp, p) -> Ans(sbst' x1 x2 exp, p)
  | Let((x, t), exp, e, p) when x = x1 -> Let((x, t), exp, e, p)
  | Let((x, t), exp, e, p) -> Let((x, t), sbst' x1 x2 exp, sbst x1 x2 e, p)


let allcregs = [(52, "%f0"); (48, "%f30")]


let rec g' = function
  | IfEq(x, y', e1, e2) -> IfEq(x, y', g e1, g e2)
  | IfLE(x, y', e1, e2) -> IfLE(x, y', g e1, g e2)
  | IfGE(x, y', e1, e2) -> IfGE(x, y', g e1, g e2)
  | IfFEq(x, y, e1, e2) -> IfFEq(x, y, g e1, g e2)
  | IfFLE(x, y, e1, e2) -> IfFLE(x, y, g e1, g e2)
  | e -> e

and g = function (* 命令列の浮動小数テーブル最適化 (caml2html: simm13_g) *)
  | Ans(exp, p) -> Ans(g' exp, p)
  | Let((x, t), LdDF(reg_ftp, l), e, p) when List.mem l (List.map fst allcregs) ->  (* 浮動小数テーブルから浮動小数をとってくる命令 *)
      Format.eprintf "found load of float.\n";
      let creg = List.assoc l allcregs in
      let e' = sbst x creg e in
      g e'
  | Let(xt, exp, e, p) -> Let(xt, g' exp, g e, p)

let h { name = l; args = xs; fargs = ys; body = e; ret = t } = (* トップレベル関数の浮動小数テーブル最適化 *)
  { name = l; args = xs; fargs = ys; body = g  e; ret = t }

let f (Prog(data, fundefs, e)) = (* プログラム全体の浮動小数テーブル最適化 *)
  Format.eprintf "optimizing float table...\n";
  Prog(data, List.map h fundefs, g e)
