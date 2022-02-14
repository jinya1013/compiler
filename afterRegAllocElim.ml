open Asm

let rec is_used_after_id_or_imm z = function
  | V(y) -> z = y
  | C(i) -> false

let rec is_used_after' z = function
  | Nop -> false
  | Set(i) -> false
  | SetL(l) -> false
  | Mov(x) -> z = x
  | Neg(x) -> z = x
  | Add(x, y) -> z = x || is_used_after_id_or_imm z y
  | Sub(x, y) -> z = x || is_used_after_id_or_imm z y
  | SLL(x, y) -> z = x || is_used_after_id_or_imm z y
  | Ld(x, i) -> z = x
  | St(x, y, i) -> z = x || z = y
  | FMovD(x) -> z = x
  | FNegD(x) -> z = x
  | FSqrtD(x) -> z = x
  | FloorD(x) -> z = x
  | FAddD(x, y) -> z = x || z = y
  | FSubD(x, y) -> z = x || z = y
  | FMulD(x, y) -> z = x || z = y
  | FDivD(x, y) -> z = x || z = y
  | LdDF(x, i) -> z = x
  | StDF(x, y, i) -> z = x || z = y
  | Comment(s) -> false
  | IfEq(x, y, e1, e2) -> 
  z = x || is_used_after_id_or_imm z y || is_used_after z e1 || is_used_after z e2
  | IfLE(x, y, e1, e2) -> 
  z = x || is_used_after_id_or_imm z y || is_used_after z e1 || is_used_after z e2
  | IfGE(x, y, e1, e2) -> 
  z = x || is_used_after_id_or_imm z y || is_used_after z e1 || is_used_after z e2
  | IfFEq(x, y, e1, e2) -> 
  z = x || z = y || is_used_after z e1 || is_used_after z e2
  | IfFLE(x, y, e1, e2) -> 
  z = x || z = y || is_used_after z e1 || is_used_after z e2
  | CallCls(f, ixs, fxs) -> true
  (* z = f || List.exists (fun i -> z = i) ixs || List.exists (fun f -> z = f) fxs *)
  | CallDir(l, ixs, fxs) -> true
  (* List.exists (fun i -> z = i) ixs || List.exists (fun f -> z = f) fxs *)
  | Save(x, y) -> z = x || z = y 
  | Restore(x) -> z = x 
and is_used_after x = function
  | Ans(exp, p) -> is_used_after' x exp
  | Let((y, t), exp, e, p) when y = x -> is_used_after' x exp (* 変数の定義で使われていなければOK *)
  | Let((y, t), exp, e, p) -> is_used_after' x exp || is_used_after x e

let rec g' = function
  | IfEq(x, y', e1, e2) -> IfEq(x, y', g e1, g e2)
  | IfLE(x, y', e1, e2) -> IfLE(x, y', g e1, g e2)
  | IfGE(x, y', e1, e2) -> IfGE(x, y', g e1, g e2)
  | IfFEq(x, y, e1, e2) -> IfFEq(x, y, g e1, g e2)
  | IfFLE(x, y, e1, e2) -> IfFLE(x, y, g e1, g e2)
  | e -> e

and g = function (* 命令列の浮動小数テーブル最適化 (caml2html: simm13_g) *)
  | Ans(exp, p) -> Ans(g' exp, p)
  | Let((z, t), Save(x, y), e, p) -> Let((z, t), g' (Save(x, y)), g e, p) 
  | Let((z, t), St(x, y, i), e, p) -> Let((z, t), g' (St(x, y, i)), g e, p) 
  | Let((z, t), StDF(x, y, i), e, p) -> Let((z, t), g' (StDF(x, y, i)), g e, p) 
  | Let((z, t), exp, e, p) when List.mem z allregs || List.mem z allfregs -> 
    if is_used_after z e then Let((z, t), g' exp, g e, p) 
    else
    (Format.eprintf "eliminating unused variable definition %s in line %d.\n" z p;
    g e)
  | Let((z, t), exp, e, p) -> Let((z, t), g' exp, g e, p) 

let h { name = l; args = xs; fargs = ys; body = e; ret = t } = (* トップレベル関数の浮動小数テーブル最適化 *)
  { name = l; args = xs; fargs = ys; body = g  e; ret = t }

let f (Prog(data, fundefs, e)) = (* プログラム全体の浮動小数テーブル最適化 *)
  Format.eprintf "optimizing float table...\n";
  Prog(data, List.map h fundefs, g e)
