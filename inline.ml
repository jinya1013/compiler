open KNormal

(* インライン展開する関数の最大サイズ (caml2html: inline_threshold) *)
let threshold = ref 60 (* Mainで-inlineオプションによりセットされる *) (* 10 で 10000命令切る *)


(* let heavy_funcs = ["init_vecset_constants"] *)

let is_heavy_func = function
  | x when String.length x >= String.length "solve_each_element_fast" && String.sub x 0 (String.length "solve_each_element_fast") = "solve_each_element_fast" -> true
  (* | x when String.length x >= String.length "init_vecset_constants" && String.sub x 0 (String.length "init_vecset_constants") = "init_vecset_constants" -> true *)
  | x when String.length x >= String.length "trace_ray" && String.sub x 0 (String.length "trace_ray") = "trace_ray" -> true
  | x when String.length x >= String.length "check_all_inside" && String.sub x 0 (String.length "check_all_inside") = "check_all_inside" -> true
  | x when String.length x >= String.length "vecset" && String.sub x 0 (String.length "vecset") = "vecset" -> true
  | x when String.length x >= String.length "o_isinvert" && String.sub x 0 (String.length "o_isinvert") = "o_isinvert" -> true
  | _ -> false

let rec size = function
  | IfEq(_, _, e1, e2, p) | IfLE(_, _, e1, e2, p)
  | Let(_, e1, e2, p) | LetRec({ body = e1 }, e2, p) -> 1 + size e1 + size e2
  | LetTuple(_, _, e, p) -> 1 + size e
  | _ -> 1

let rec g env = function (* インライン展開ルーチン本体 (caml2html: inline_g) *)
  | IfEq(x, y, e1, e2, p) -> IfEq(x, y, g env e1, g env e2, p)
  | IfLE(x, y, e1, e2, p) -> IfLE(x, y, g env e1, g env e2, p)
  | Let(xt, e1, e2, p) -> Let(xt, g env e1, g env e2, p)
  | LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) -> (* 関数定義の場合 (caml2html: inline_letrec) *)
      (* let is_recur = S.mem x (fv (g env e1)) in *)
      let env = if (size e1 <= !threshold (* || (is_heavy_func x && size e1 <= 200) *) ) then M.add x (yts, e1) env else env in
      LetRec({ name = (x, t); args = yts; body = g env e1}, g env e2, p)
  | App(x, ys, p) when M.mem x env -> (* 関数適用の場合 (caml2html: inline_app) *)
      let (zs, e) = M.find x env in
      Format.eprintf "inlining %s@." x;
      let env' =
        List.fold_left2
          (fun env' (z, t) y -> M.add z y env')
          M.empty
          zs
          ys in
      Alpha.g env' e
  | LetTuple(xts, y, e, p) -> LetTuple(xts, y, g env e, p)
  | e -> e

let f e = g M.empty e
