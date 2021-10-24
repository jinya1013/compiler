open Asm

external gethi : float -> int32 = "gethi"
external getlo : float -> int32 = "getlo"

let stackset = ref S.empty (* すでにSaveされた変数の集合 (caml2html: emit_stackset) *)
let stackmap = ref [] (* Saveされた変数の、スタックにおける位置 (caml2html: emit_stackmap) *)
let save x =
  stackset := S.add x !stackset;
  if not (List.mem x !stackmap) then
    stackmap := !stackmap @ [x]
let savef x =
  stackset := S.add x !stackset;
  if not (List.mem x !stackmap) then
    (let pad =
      if List.length !stackmap mod 2 = 0 then [] else [Id.gentmp Type.Int] in
    stackmap := !stackmap @ pad @ [x; x])
let locate x =
  let rec loc = function
    | [] -> []
    | y :: zs when x = y -> 0 :: List.map succ (loc zs)
    | y :: zs -> List.map succ (loc zs) in
  loc !stackmap
let offset x = 4 * List.hd (locate x)
let stacksize () = align ((List.length !stackmap + 1) * 4) (* 関数のリターンアドレス格納用に, 1だけサイズを大きくしておく *)

let pp_id_or_imm = function
  | V(x) -> x
  | C(i) -> string_of_int i

(* 関数呼び出しのために引数を並べ替える(register shuffling) (caml2html: emit_shuffle) *)
let rec shuffle sw xys =
  (* remove identical moves *)
  let _, xys = List.partition (fun (x, y) -> x = y) xys in
  (* find acyclic moves *)
  match List.partition (fun (_, y) -> List.mem_assoc y xys) xys with
  | [], [] -> []
  | (x, y) :: xys, [] -> (* no acyclic moves; resolve a cyclic move *)
      (y, sw) :: (x, y) :: shuffle sw (List.map
                                         (function
                                           | (y', z) when y = y' -> (sw, z)
                                           | yz -> yz)
                                         xys)
  | xys, acyc -> acyc @ shuffle sw xys

type dest = Tail | NonTail of Id.t (* 末尾かどうかを表すデータ型 (caml2html: emit_dest) *)
let rec g oc = function (* 命令列のアセンブリ生成 (caml2html: emit_g) *)
  | dest, Ans(exp, p) -> g' p oc (dest, exp)
  | dest, Let((x, t), exp, e, p) ->
      g' p oc (NonTail(x), exp);
      g oc (dest, e)
and g' p oc = function (* 各命令のアセンブリ生成 (caml2html: emit_gprime) *)
  (* 末尾でなかったら計算結果をdestにセット (caml2html: emit_nontail) *)
  | NonTail(_), Nop -> ()
  | NonTail(x), Set(i) -> Printf.fprintf oc "\tset\t%d, %s\t# %d \n" i x p
  | NonTail(x), SetL(Id.L(y)) -> Printf.fprintf oc "\tset\t%s, %s\t# %d \n" y x p
  | NonTail(x), Mov(y) when x = y -> ()
  | NonTail(x), Mov(y) -> Printf.fprintf oc "\tmov\t%s, %s\t# %d \n" y x p
  | NonTail(x), Neg(y) -> Printf.fprintf oc "\tneg\t%s, %s\t# %d \n" y x p
  | NonTail(x), Add(y, z') -> Printf.fprintf oc "\tadd\t%s, %s, %s\t# %d \n" y (pp_id_or_imm z') x p
  | NonTail(x), Sub(y, z') -> Printf.fprintf oc "\tsub\t%s, %s, %s\t# %d \n" y (pp_id_or_imm z') x p
  | NonTail(x), SLL(y, z') -> Printf.fprintf oc "\tsll\t%s, %s, %s\t# %d \n" y (pp_id_or_imm z') x p
  | NonTail(x), Ld(y, z') -> Printf.fprintf oc "\tld\t[%s + %s], %s\t# %d \n" y (pp_id_or_imm z') x p
  | NonTail(_), St(x, y, z') -> Printf.fprintf oc "\tst\t%s, [%s + %s]\t# %d \n" x y (pp_id_or_imm z') p
  | NonTail(x), FMovD(y) when x = y -> ()
  | NonTail(x), FMovD(y) ->
      Printf.fprintf oc "\tfmovs\t%s, %s\t# %d \n" y x p;
      Printf.fprintf oc "\tfmovs\t%s, %s\t# %d \n" (co_freg y) (co_freg x) p
  | NonTail(x), FNegD(y) ->
      Printf.fprintf oc "\tfnegs\t%s, %s\t# %d \n" y x p;
      if x <> y then Printf.fprintf oc "\tfmovs\t%s, %s\t# %d \n" (co_freg y) (co_freg x) p
  | NonTail(x), FAddD(y, z) -> Printf.fprintf oc "\tfaddd\t%s, %s, %s\t# %d \n" y z x p
  | NonTail(x), FSubD(y, z) -> Printf.fprintf oc "\tfsubd\t%s, %s, %s\t# %d \n" y z x p
  | NonTail(x), FMulD(y, z) -> Printf.fprintf oc "\tfmuld\t%s, %s, %s\t# %d \n" y z x p
  | NonTail(x), FDivD(y, z) -> Printf.fprintf oc "\tfdivd\t%s, %s, %s\t# %d \n" y z x p
  | NonTail(x), LdDF(y, z') -> Printf.fprintf oc "\tldd\t[%s + %s], %s\t# %d \n" y (pp_id_or_imm z') x p
  | NonTail(_), StDF(x, y, z') -> Printf.fprintf oc "\tstd\t%s, [%s + %s]\t# %d \n\n" x y (pp_id_or_imm z') p
  | NonTail(_), Comment(s) -> Printf.fprintf oc "\t! %s\t# %d \n" s p
  (* 退避の仮想命令の実装 (caml2html: emit_save) *)
  | NonTail(_), Save(x, y) when List.mem x allregs && not (S.mem y !stackset) ->
      save y;
      Printf.fprintf oc "\tst\t%s, [%s + %d]\t# %d \n" x reg_sp (offset y) p
  | NonTail(_), Save(x, y) when List.mem x allfregs && not (S.mem y !stackset) ->
      savef y;
      Printf.fprintf oc "\tstd\t%s, [%s + %d]\t# %d \n" x reg_sp (offset y) p
  | NonTail(_), Save(x, y) -> assert (S.mem y !stackset); ()
  (* 復帰の仮想命令の実装 (caml2html: emit_restore) *)
  | NonTail(x), Restore(y) when List.mem x allregs ->
      Printf.fprintf oc "\tld\t[%s + %d], %s\t# %d \n" reg_sp (offset y) x p
  | NonTail(x), Restore(y) ->
      assert (List.mem x allfregs);
      Printf.fprintf oc "\tldd\t[%s + %d], %s\t# %d \n" reg_sp (offset y) x p
  (* 末尾だったら計算結果を第一レジスタにセットしてリターン (caml2html: emit_tailret) *)
  | Tail, (Nop | St _ | StDF _ | Comment _ | Save _ as exp) ->
      g' p oc (NonTail(Id.gentmp Type.Unit), exp);
      Printf.fprintf oc "\tretl\t# %d \n" p;
      Printf.fprintf oc "\tnop\t# %d \n" p
  | Tail, (Set _ | SetL _ | Mov _ | Neg _ | Add _ | Sub _ | SLL _ | Ld _ as exp) ->
      g' p oc (NonTail(regs.(0)), exp);
      Printf.fprintf oc "\tretl\t# %d \n" p;
      Printf.fprintf oc "\tnop\t# %d \n" p
  | Tail, (FMovD _ | FNegD _ | FAddD _ | FSubD _ | FMulD _ | FDivD _ | LdDF _ as exp) ->
      g' p oc (NonTail(fregs.(0)), exp);
      Printf.fprintf oc "\tretl\t# %d \n" p;
      Printf.fprintf oc "\tnop\t# %d \n" p
  | Tail, (Restore(x) as exp) ->
      (match locate x with
      | [i] -> g' p oc (NonTail(regs.(0)), exp)
      | [i; j] when i + 1 = j -> g' p oc (NonTail(fregs.(0)), exp)
      | _ -> assert false);
      Printf.fprintf oc "\tretl\t# %d \n" p;
      Printf.fprintf oc "\tnop\t# %d \n" p
  | Tail, IfEq(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\t# %d \n" x (pp_id_or_imm y') p;
      g'_tail_if oc e1 e2 "be" "bne" p
  | Tail, IfLE(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\t# %d \n" x (pp_id_or_imm y') p;
      g'_tail_if oc e1 e2 "ble" "bg" p
  | Tail, IfGE(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\t# %d \n" x (pp_id_or_imm y') p;
      g'_tail_if oc e1 e2 "bge" "bl" p
  | Tail, IfFEq(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\t# %d \n" x y p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      g'_tail_if oc e1 e2 "fbe" "fbne" p
  | Tail, IfFLE(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\t# %d \n" x y p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      g'_tail_if oc e1 e2 "fble" "fbg" p
  | NonTail(z), IfEq(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\t# %d \n" x (pp_id_or_imm y') p;
      g'_non_tail_if oc (NonTail(z)) e1 e2 "be" "bne" p
  | NonTail(z), IfLE(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\t# %d \n" x (pp_id_or_imm y') p;
      g'_non_tail_if oc (NonTail(z)) e1 e2 "ble" "bg" p
  | NonTail(z), IfGE(x, y', e1, e2) ->
      Printf.fprintf oc "\tcmp\t%s, %s\t# %d \n" x (pp_id_or_imm y') p;
      g'_non_tail_if oc (NonTail(z)) e1 e2 "bge" "bl" p
  | NonTail(z), IfFEq(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\t# %d \n" x y p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      g'_non_tail_if oc (NonTail(z)) e1 e2 "fbe" "fbne" p
  | NonTail(z), IfFLE(x, y, e1, e2) ->
      Printf.fprintf oc "\tfcmpd\t%s, %s\t# %d \n" x y p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      g'_non_tail_if oc (NonTail(z)) e1 e2 "fble" "fbg" p
  (* 関数呼び出しの仮想命令の実装 (caml2html: emit_call) *)
  | Tail, CallCls(x, ys, zs) -> (* 末尾呼び出し (caml2html: emit_tailcall) *)
      g'_args oc [(x, reg_cl)] ys zs p;
      Printf.fprintf oc "\tld\t[%s + 0], %s\t# %d \n" reg_cl reg_sw p; (* クロージャポインタから, スワップポインタにクロージャのアドレスをダウンロード *)
      Printf.fprintf oc "\tjmp\t%s\t# %d \n" reg_sw p; (* クロージャのアドレスに飛ぶ *)
      Printf.fprintf oc "\tnop\t# %d \n" p
  | Tail, CallDir(Id.L(x), ys, zs) -> (* 末尾呼び出し *)
      g'_args oc [] ys zs p;
      Printf.fprintf oc "\tb\t%s\t# %d \n" x p; (* ラベルxに飛ぶ *)
      Printf.fprintf oc "\tnop\t# %d \n" p
  | NonTail(a), CallCls(x, ys, zs) ->
      g'_args oc [(x, reg_cl)] ys zs p;
      let ss = stacksize () in
      Printf.fprintf oc "\tst\t%s, [%s + %d]\t# %d \n" reg_ra reg_sp (ss - 4) p; (* リターンアドレスレジスタのデータをスタックの末尾に追加する *)
      Printf.fprintf oc "\tld\t[%s + 0], %s\t# %d \n" reg_cl reg_sw p; 8 (* クロージャの先頭のデータをスワップレジスタに移動する *)
      Printf.fprintf oc "\tcall\t%s\t# %d \n" reg_sw p;
      Printf.fprintf oc "\tadd\t%s, %d, %s\t! delay slot\t# %d \n" reg_sp ss reg_sp p;
      Printf.fprintf oc "\tsub\t%s, %d, %s\t# %d \n" reg_sp ss reg_sp p;
      Printf.fprintf oc "\tld\t[%s + %d], %s\t# %d \n" reg_sp (ss - 4) reg_ra p;
      if List.mem a allregs && a <> regs.(0) then
        Printf.fprintf oc "\tmov\t%s, %s\t# %d \n" regs.(0) a p
      else if List.mem a allfregs && a <> fregs.(0) then
        (Printf.fprintf oc "\tfmovs\t%s, %s\t# %d \n" fregs.(0) a p;
         Printf.fprintf oc "\tfmovs\t%s, %s\t# %d \n" (co_freg fregs.(0)) (co_freg a) p)
  | NonTail(a), CallDir(Id.L(x), ys, zs) ->
      g'_args oc [] ys zs p;
      let ss = stacksize () in
      Printf.fprintf oc "\tst\t%s, [%s + %d]\t# %d \n" reg_ra reg_sp (ss - 4) p;
      Printf.fprintf oc "\tcall\t%s\t# %d \n" x p;
      Printf.fprintf oc "\tadd\t%s, %d, %s\t! delay slot\t# %d \n" reg_sp ss reg_sp p;
      Printf.fprintf oc "\tsub\t%s, %d, %s\t# %d \n" reg_sp ss reg_sp p;
      Printf.fprintf oc "\tld\t[%s + %d], %s\t# %d \n" reg_sp (ss - 4) reg_ra p;
      if List.mem a allregs && a <> regs.(0) then
        Printf.fprintf oc "\tmov\t%s, %s\t# %d \n" regs.(0) a p
      else if List.mem a allfregs && a <> fregs.(0) then
        (Printf.fprintf oc "\tfmovs\t%s, %s\t# %d \n" fregs.(0) a p;
         Printf.fprintf oc "\tfmovs\t%s, %s\t# %d \n" (co_freg fregs.(0)) (co_freg a) p)
and g'_tail_if oc e1 e2 b bn p =
  let b_else = Id.genid (b ^ "_else") in
  Printf.fprintf oc "\t%s\t%s\t# %d \n" bn b_else p;
  Printf.fprintf oc "\tnop\t# %d \n" p;
  let stackset_back = !stackset in
  g oc (Tail, e1);
  Printf.fprintf oc "%s:\t# %d \n" b_else p;
  stackset := stackset_back;
  g oc (Tail, e2)
and g'_non_tail_if oc dest e1 e2 b bn p =
  let b_else = Id.genid (b ^ "_else") in
  let b_cont = Id.genid (b ^ "_cont") in
  Printf.fprintf oc "\t%s\t%s\t# %d \n" bn b_else p;
  Printf.fprintf oc "\tnop\t# %d \n" p;
  let stackset_back = !stackset in
  g oc (dest, e1);
  let stackset1 = !stackset in
  Printf.fprintf oc "\tb\t%s\t# %d \n" b_cont p;
  Printf.fprintf oc "\tnop\t# %d \n" p;
  Printf.fprintf oc "%s:\t# %d \n" b_else p;
  stackset := stackset_back;
  g oc (dest, e2);
  Printf.fprintf oc "%s:\t# %d \n" b_cont p;
  let stackset2 = !stackset in
  stackset := S.inter stackset1 stackset2
and g'_args oc x_reg_cl ys zs p =
  let (i, yrs) =
    List.fold_left
      (fun (i, yrs) y -> (i + 1, (y, regs.(i)) :: yrs))
      (0, x_reg_cl)
      ys in
  List.iter
    (fun (y, r) -> Printf.fprintf oc "\tmov\t%s, %s\t# %d \n" y r p)
    (shuffle reg_sw yrs);
  let (d, zfrs) =
    List.fold_left
      (fun (d, zfrs) z -> (d + 1, (z, fregs.(d)) :: zfrs))
      (0, [])
      zs in
  List.iter
    (fun (z, fr) ->
      Printf.fprintf oc "\tfmovs\t%s, %s\t# %d \n" z fr p;
      Printf.fprintf oc "\tfmovs\t%s, %s\t# %d \n" (co_freg z) (co_freg fr) p)
    (shuffle reg_fsw zfrs)

let h oc { name = Id.L(x); args = _; fargs = _; body = e; ret = _ } =
  Printf.fprintf oc "%s:\n" x;
  stackset := S.empty;
  stackmap := [];
  g oc (Tail, e)

let f oc (Prog(data, fundefs, e)) =
  Format.eprintf "generating assembly...@.";
  Printf.fprintf oc ".section\t\".rodata\"\n";
  Printf.fprintf oc ".align\t8\n";
  List.iter
    (fun (Id.L(x), d) ->
      Printf.fprintf oc "%s:\t! %f\n" x d;
      Printf.fprintf oc "\t.long\t0x%lx\n" (gethi d);
      Printf.fprintf oc "\t.long\t0x%lx\n" (getlo d))
    data;
  Printf.fprintf oc ".section\t\".text\"\n";
  List.iter (fun fundef -> h oc fundef) fundefs;
  Printf.fprintf oc ".global\tmin_caml_start\n";
  Printf.fprintf oc "min_caml_start:\n";
  Printf.fprintf oc "\tsave\t%%sp, -112, %%sp\n"; (* from gcc; why 112? *)
  stackset := S.empty;
  stackmap := [];
  g oc (NonTail("%g0"), e);
  Printf.fprintf oc "\tret\n";
  Printf.fprintf oc "\trestore\n"
