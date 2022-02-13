open Asm

let rec g' = function
  | IfEq(x, y', e1, e2) -> IfEq(x, y', g e1, g e2)
  | IfLE(x, y', e1, e2) -> IfLE(x, y', g e1, g e2)
  | IfGE(x, y', e1, e2) -> IfGE(x, y', g e1, g e2)
  | IfFEq(x, y, e1, e2) -> IfFEq(x, y, g e1, g e2)
  | IfFLE(x, y, e1, e2) -> IfFLE(x, y, g e1, g e2)
  | e -> e

and g = function (* 命令列の浮動小数テーブル最適化 (caml2html: simm13_g) *)
  | Ans(exp, p) -> Ans(g' exp, p)
  | Let((x, t), Add(y, C(0)), e, p) when x = y ->  (* 浮動小数テーブルから浮動小数をとってくる命令 *)
      Format.eprintf "found addi x x 0 and removed\n";
      g e
  | Let(xt, exp, e, p) -> Let(xt, g' exp, g e, p)

let h { name = l; args = xs; fargs = ys; body = e; ret = t } = (* トップレベル関数の浮動小数テーブル最適化 *)
  { name = l; args = xs; fargs = ys; body = g  e; ret = t }

let f (Prog(data, fundefs, e)) = (* プログラム全体の浮動小数テーブル最適化 *)
  Format.eprintf "optimizing float table...\n";
  Prog(data, List.map h fundefs, g e)
