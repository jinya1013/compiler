open Asm

let fv_id_or_imm = function
  | V(x) -> S.singleton x
  | C(i) -> S.empty

let rec fv_h = function
  | Nop -> S.empty
  | Set(i) -> S.empty
  | SetL(l) -> S.empty
  | Mov(x) -> S.singleton x
  | Neg(x) -> S.singleton x
  | Add(x, y) -> S.union (S.singleton x) (fv_id_or_imm y)
  | Sub(x, y) -> S.union (S.singleton x) (fv_id_or_imm y)
  | SLL(x, y) -> S.union (S.singleton x) (fv_id_or_imm y)
  | Ld(x, i) -> S.singleton x
  | St(x, y, i) -> S.of_list [x; y]
  | FMovD(x) -> S.singleton x
  | FNegD(x) -> S.singleton x
  | FSqrtD(x) -> S.singleton x
  | FloorD(x) -> S.singleton x
  | FAddD(x, y) -> S.of_list [x; y]
  | FSubD(x, y) -> S.of_list [x; y]
  | FMulD(x, y) -> S.of_list [x; y]
  | FDivD(x, y) -> S.of_list [x; y]
  | LdDF(x, i) -> S.singleton x
  | StDF(x, y, i) -> S.of_list [x; y]
  | Comment(s) -> S.empty
  (* virtual instructions *)
  | IfEq(x, y, e1, e2) -> S.add x (S.union (fv_id_or_imm y) (S.union (fv_g e1) (fv_g e2)))
  | IfLE(x, y, e1, e2) -> S.add x (S.union (fv_id_or_imm y) (S.union (fv_g e1) (fv_g e2)))
  | IfGE(x, y, e1, e2) -> S.add x (S.union (fv_id_or_imm y) (S.union (fv_g e1) (fv_g e2))) (* 左右対称ではないので必要 *)
  | IfFEq(x, y, e1, e2) -> S.add x (S.add y (S.union (fv_g e1) (fv_g e2)))
  | IfFLE(x, y, e1, e2) -> S.add x (S.add y (S.union (fv_g e1) (fv_g e2)))
  (* closure address, integer arguments, and float arguments *)
  | CallCls(f, ixs, fxs) -> S.add f (S.union (S.of_list ixs) (S.of_list fxs))
  | CallDir(l, ixs, fxs) -> (S.union (S.of_list ixs) (S.of_list fxs))
  | Save(x, y) -> S.of_list [x; y] (* レジスタ変数の値をスタック変数へ保存 (caml2html: sparcasm_save) *)
  | Restore(x) -> S.singleton x (* スタック変数から値を復元 (caml2html: sparcasm_restore) *)

and fv_g = function
  | Ans(e, p) -> fv_h e
  | Let((x, t), e, c, p) -> S.union (fv_h e) (S.remove x (fv_g c))

let rec effect_h = function
  | IfEq(x, y, e1, e2) | IfLE(x, y, e1, e2) | IfGE(x, y, e1, e2) -> effect_g e1 || effect_g e2
  | IfFEq(x, y, e1, e2) | IfFLE(x, y, e1, e2) -> effect_g e1 || effect_g e2
  | St(_) | StDF(_) | Save(_) | CallCls(_) | CallDir(_) -> true
  | _ -> false

and effect_g = function
  | Ans(e, p) -> effect_h e
  | Let((x, t), e, c, p) -> effect_h e || effect_g c

let rec h = function
  | IfEq(x, y, e1, e2) -> IfEq(x, y, g e1, g e2)
  | IfLE(x, y, e1, e2) -> IfLE(x, y, g e1, g e2)
  | IfGE(x, y, e1, e2) -> IfGE(x, y, g e1, g e2) (* 左右対称ではないので必要 *)
  | IfFEq(x, y, e1, e2) -> IfFEq(x, y, g e1, g e2)
  | IfFLE(x, y, e1, e2) -> IfFLE(x, y, g e1, g e2)
  | e -> e

and g = function
  | Ans(e, p) -> Ans(h e, p)
  | Let((x, t), e, c, p) -> 
    let e' = h e in
    let c' = g c in
    if effect_h e' || S.mem x (S.add "%x3" (fv_g c')) then Let((x, t), e', c', p) else
    (
      Format.eprintf "eliminating variable %s@." x;
      c'
    )

let fun_f fundefs =
  List.map
  (fun { name = l; args = ixs; fargs = fxs; body = c; ret = t } -> { name = l; args = ixs; fargs = fxs; body = g c; ret = t })
  fundefs

let f (Prog(float_table, fundefs, c)) = 
  let fundefs' = fun_f fundefs in
  let c' = g c in
  Prog(float_table, fundefs', c')