open Asm

let inst_address = ref 4
let address_env = ref []

let stackset = ref S.empty (* すでにSaveされた変数の集合 (caml2html: emit_stackset) *)
let stackmap = ref [] (* Saveされた変数の、スタックにおける位置 (caml2html: emit_stackmap) *)
let save x =
  stackset := S.add x !stackset; (* 既にsaveされた変数の集合にxを追加し, stackmapにxがなければ, stackmapの右端にxを追加する *)
  if not (List.mem (x, Type.Int) !stackmap) then
    stackmap := !stackmap @ [(x, Type.Int)]
let savef x =
  stackset := S.add x !stackset; (* 浮動小数の大きさが32bitなので, このようになった. *)
  if not (List.mem (x, Type.Float) !stackmap) then
    stackmap := !stackmap @ [(x, Type.Float)]
let locate x = (* stackmap(stackにsaveされている変数のリスト)を再帰的に見て, スタック中での変数の位置を返す関数 *)
(*
  stackmap := [y; z; x; w; x];
  locate x = loc [y; z; x; w; x]
           = List.map succ (loc [z; x; w; x])
           = List.map succ (List.map succ (loc [x; w; x]))
           = List.map succ (List.map succ (0 :: (List.map succ [w; x])))
           = List.map succ (List.map succ (0 :: (List.map succ (List.map succ [x]))))
           = List.map succ (List.map succ (0 :: (List.map succ (0 :: (List.map succ [])))))
           = List.map succ (List.map succ (0 :: (List.map succ (0 :: []))))
           = List.map succ (List.map succ (0 :: (List.map succ [0])))
           = List.map succ (List.map succ (0 :: [1]))
           = List.map succ (List.map succ [0;1])
           = List.map succ [1;2]
           = [2;3]
*)
  let rec loc = function
    | [] -> []
    | y :: zs when x = (fst y) && (snd y) = Type.Int -> 
      (0, Type.Int) :: List.map (fun (x, t) -> (x + 1, t)) (loc zs)
    | y :: zs when x = (fst y) && (snd y) = Type.Float -> 
      (0, Type.Float) :: List.map (fun (x, t) -> (x + 1, t)) (loc zs)
    | y :: zs -> List.map (fun (x, t) -> (x + 1, t)) (loc zs) in
  loc !stackmap
let offset x = 4 * (fst (List.hd (locate x)))
let stacksize () = (List.length !stackmap + 1) * 4

let pp_id_or_imm = function
  | V(x) -> x
  | C(i) -> string_of_int i

let np_id_or_imm = function
  | V(x) -> x
  | C(i) -> string_of_int (-i)

(* 関数呼び出しのために引数を並べ替える(register shuffling) (caml2html: emit_shuffle) *)
let rec shuffle sw xys = (* sw: スワップ用のレジスタ, xys: 引数の変数名とレジスタの名前のリスト *)
  (* remove identical moves *)
  let _, xys = List.partition (fun (x, y) -> x = y) xys in (* 組(x, y)のリストに対して, x != y の成分だけ取り出す  *)
  (* find acyclic moves *)
  match List.partition (fun (_, y) -> List.mem_assoc y xys) xys with (* リストの要素で(_, y);(y, __) のようになっているものを取り出す *)
  | [], [] -> []
  | (x, y) :: xys, [] -> (* no acyclic moves; resolve a cyclic move *)
      (y, sw) :: (x, y) :: shuffle sw (List.map
                                         (function
                                           | (y', z) when y = y' -> (sw, z)
                                           | yz -> yz)
                                         xys)
  | xys, acyc -> acyc @ shuffle sw xys

let set_int oc x i p = 
  let upper = i / 4096 in
  let lower = i mod 4096 in 
  (
    match upper, p with
    | t, p when (t > 0 && lower > 2047 && p > 0) ->
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\tlui\t%s %d\t# %d\n" x i p;
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %s 2047\t# %d\n" x x p;
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %s %d\t# %d\n" x x (lower - 2047) p;
    )
    | t, p when (t > 0 && lower = 0 && p > 0) ->
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\tlui\t%s %d\t# %d\n" x i p;
    )
    | t, p when (t > 0 && lower <= 2047 && p > 0) ->
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\tlui\t%s %d\t# %d\n" x i p;
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %s %d\t# %d\n" x x lower p;
    )
    | t, p when (lower > 2047 && p > 0) ->
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %%x0 2047\t# %d\n" x p;
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %s %d\t# %d\n" x x (lower - 2047) p;
    )
    | t, p when (lower = 0 && p > 0) ->
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %%x0 0\t# %d\n" x p;
    )
    | t, p when p > 0 -> 
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d\n" x lower p;
    )

    | t, p when (t > 0 && lower > 2047) ->
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\tlui\t%s %d\n" x i;
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %s 2047\n" x x;
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %s %d\n" x x (lower - 2047);
    )
    | t, p when (t > 0 && lower = 0) ->
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\tlui\t%s %d\n" x i;
    )
    | t, p when (t > 0 && lower <= 2047) ->
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\tlui\t%s %d\n" x i;
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %s %d\n" x x lower;
    )
    | t, p when (lower > 2047) ->
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %%x0 2047\n" x;
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %s %d\n" x x (lower - 2047);
    )
    | t, p when (lower = 0) ->
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %%x0 0\n" x;
    )
    | t, p -> 
    (
      inst_address := !inst_address + 4; Printf.fprintf oc "\taddi\t%s %%x0 %d\n" x lower;
    )
  )

type dest = Tail | NonTail of Id.t (* 末尾かどうかを表すデータ型 (caml2html: emit_dest) *)
let rec g oc = function (* 命令列のアセンブリ生成 (caml2html: emit_g) *)
  | dest, Ans(exp, p) -> g' p oc (dest, exp)
  | dest, Let((x, t), exp, e, p) ->
      g' p oc (NonTail(x), exp);
      g oc (dest, e)
and g' p oc e =  (* 各命令のアセンブリ生成 (caml2html: emit_gprime) *)
  (* 末尾でなかったら計算結果をdestにセット (caml2html: emit_nontail) *)
  match e with
  | NonTail(_), Nop -> ()
  | NonTail(x), Set(i) ->
    set_int oc x i p;
  | NonTail(x), SetL(Id.L(y)) ->
    let ad = List.assoc (Id.L(y)) !address_env in
    set_int oc x ad p;
  | NonTail(x), Mov(y) when x = y -> ()
  | NonTail(x), Mov(y) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" x y p
  | NonTail(x), Neg(y) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tsub\t%s %%x0 %s\t# %d \n" x y p
  | NonTail(x), Add(y, z') -> 
  (
    match z' with 
    | V(v) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tadd\t%s %s %s\t# %d \n" x y (pp_id_or_imm z') p
    | C(c) -> inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %s %s\t# %d \n" x y (pp_id_or_imm z') p
  )
  | NonTail(x), Sub(y, z') -> 
  (
    match z' with 
    | V(v) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tsub\t%s %s %s\t# %d \n" x y (np_id_or_imm z') p
    | C(c) -> inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %s %s\t# %d \n" x y (np_id_or_imm z') p
  )
  | NonTail(x), SLL(y, z') -> inst_address := !inst_address + 4;Printf.fprintf oc "\tsll\t%s %s %s\t# %d \n" x y z' p
  | NonTail(x), Ld(y, z') -> inst_address := !inst_address + 4;Printf.fprintf oc "\tlw\t%s %d(%s)\t# %d \n" x z' y p
  | NonTail(_), St(x, y, z') -> inst_address := !inst_address + 4;Printf.fprintf oc "\tsw\t%s %d(%s)\t# %d \n" x z' y p

  | NonTail(x), FMovD(y) when x = y -> ()
  | NonTail(x), FMovD(y) ->
      inst_address := !inst_address + 4;Printf.fprintf oc "\titof\t%s %%x0\t# %d \n" reg_fsw p;  (* 浮動小数の0を用意 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfadd\t%s %s %s\t# %d \n" x y reg_fsw p; (* f0とyの和をxに入れる *)
  | NonTail(x), FNegD(y) ->
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfneg\t%s %s\t# %d \n" x y p;
  | NonTail(x), FSqrtD(y) ->
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfsqrt\t%s %s\t# %d \n" x y p;
  | NonTail(x), FloorD(y) ->
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfloor\t%s %s\t# %d \n" x y p;
  | NonTail(x), FAddD(y, z) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tfadd\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), FSubD(y, z) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tfsub\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), FMulD(y, z) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tfmul\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), FDivD(y, z) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tfdiv\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), LdDF(y, z') -> inst_address := !inst_address + 4;Printf.fprintf oc "\tflw\t%s %d(%s)\t# %d \n" x z' y p
  | NonTail(_), StDF(x, y, z') -> inst_address := !inst_address + 4;Printf.fprintf oc "\tfsw\t%s %d(%s)\t# %d \n" x z' y p

  | NonTail(_), Comment(s) -> inst_address := !inst_address + 4;Printf.fprintf oc "\t# %s\t# %d \n" s p

  (* 退避の仮想命令の実装 (caml2html: emit_save) *)
  | NonTail(_), Save(x, y) when List.mem x allregs && not (S.mem y !stackset) -> (* 整数レジスタxに入っている変数yをスタックに退避 *)
      save y; (* コンパイラの内部情報を更新(yをスタックにのっける) *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tsw\t%s -%d(%s)\t# %d \n" x (offset y) reg_sp p
  | NonTail(_), Save(x, y) when List.mem x allfregs && not (S.mem y !stackset) -> (* yが既に保存された変数の集合に入っていなかったら *)
      savef y;
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfsw\t%s -%d(%s)\t# %d \n" x (offset y) reg_sp p
  | NonTail(_), Save(x, y) -> 
  assert (S.mem y !stackset); () (* 上記2つ以外はエラー *)

  (* 復帰の仮想命令の実装 (caml2html: emit_restore) *)
  | NonTail(x), Restore(y) when List.mem x allregs -> 
      inst_address := !inst_address + 4;Printf.fprintf oc "\tlw\t%s -%d(%s)\t# %d \n" x (offset y) reg_sp p
  | NonTail(x), Restore(y) ->
      assert (List.mem x allfregs);
      inst_address := !inst_address + 4;Printf.fprintf oc "\tflw\t%s -%d(%s)\t# %d \n" x (offset y) reg_sp p
  (* 末尾だったら計算結果を第一レジスタにセットしてリターン (caml2html: emit_tailret) *) (* 返り値がない命令 *)
  | Tail, (Nop | St _ | StDF _ | Comment _ | Save _ as exp) ->
      g' p oc (NonTail(Id.gentmp Type.Unit), exp);
      inst_address := !inst_address + 4;Printf.fprintf oc "\tjr\t0(%%x1)\t# %d \n" p;
  | Tail, (Set _ | SetL _ | Mov _ | Neg _ | Add _ | Sub _ | SLL _ | Ld _ as exp) ->
      g' p oc (NonTail(regs.(0)), exp);
      inst_address := !inst_address + 4;Printf.fprintf oc "\tjr\t0(%%x1)\t# %d \n" p;
  | Tail, (FMovD _ | FNegD _ | FSqrtD _ | FloorD _ | FAddD _ | FSubD _ | FMulD _ | FDivD _ | LdDF _ as exp) ->
      g' p oc (NonTail(fregs.(0)), exp);
      inst_address := !inst_address + 4;Printf.fprintf oc "\tjr\t0(%%x1)\t# %d \n" p;
  | Tail, (Restore(x) as exp) ->
      (
        match locate x with (* スタック中での変数xの位置を調べる *)
        | [(i, Type.Int)] -> g' p oc (NonTail(regs.(0)), exp)
        | [(i, Type.Float)] -> g' p oc (NonTail(fregs.(0)), exp)
        | _ -> assert false
      );

      inst_address := !inst_address + 4;Printf.fprintf oc "\tjr\t0(%%x1)\t# %d \n" p;

  | Tail, IfEq(x, y', e1, e2) -> (* x = y then e1 else e2 *)
      let b_else = Id.genid ("beq_else") in
      (
        match y' with
        | V(y) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tbne\t%s %s %s\t# %d \n" x y b_else p; (* (x != y なら飛ぶ) *)
        | C(i) when i = 0 -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\tbne\t%s %%x0 %s\t# %d \n" x b_else p
        )
        | C(i) -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          inst_address := !inst_address + 4;Printf.fprintf oc "\tbne\t%s %s %s\t# %d \n" x reg_sw b_else p
        )
      );
      let stackset_back = !stackset in
      g oc (Tail, e1);
      Printf.fprintf oc "%s:\t# %d \n" b_else p;
      stackset := stackset_back;
      g oc (Tail, e2)
  | Tail, IfLE(x, y', e1, e2) -> (* y < x then e2 else e1 *)
      let b = Id.genid ("blt") in
      (
        match y' with
        | V(y) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" y x b p; (* (y < x なら飛ぶ) *)
        | C(i) when i = 0 -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%%x0 %s %s\t# %d \n" x b p
        )
        | C(i) -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" reg_sw x b p
        )
      );
      let stackset_back = !stackset in
      g oc (Tail, e1);
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (Tail, e2)
  | Tail, IfGE(x, y', e1, e2) ->
      let b_else = Id.genid ("bge_else") in
      (
        match y' with
        | V(y) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x y b_else p; (* (x < y なら飛ぶ) *)
        | C(i) when i = 0 -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%s %%x0 %s\t# %d \n" x b_else p
        )
        | C(i) -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x reg_sw b_else p
        )
      );
      let stackset_back = !stackset in
      g oc (Tail, e1);
      Printf.fprintf oc "%s:\t# %d \n" b_else p;
      stackset := stackset_back;
      g oc (Tail, e2)

  (* Risc-Vでは浮動小数の比較演算が見つからなかったので, 暫定的 *)
  | Tail, IfFEq(x, y, e1, e2) ->
      let b = Id.genid ("feq") in
      (* inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 0\t# %d \n" reg_sw p; reg_sw に 0 を代入 *)
      (* inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 0\t# %d \n" reg_sw2 p; reg_sw2 に 0 を代入 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfle\t%s %s %s\t# %d \n" reg_sw x y p; (* x <= y なら 1 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfle\t%s %s %s\t# %d \n" reg_sw2 y x p; (* y <= x なら 1 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tand\t%s %s %s\t# %d \n" reg_sw reg_sw reg_sw2 p; (* x = y なら 1 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tbne\t%s %%x0 %s\t# %d \n" reg_sw b p; (* x = y なら 飛ぶ *)
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (Tail, e1)
  | Tail, IfFLE(x, y, e1, e2) ->
      let b = Id.genid ("fle_else") in
      (* inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 0\t# %d \n" reg_sw p; reg_sw に 0 を代入 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfle\t%s %s %s\t# %d \n" reg_sw x y p; (* x <= y なら 1 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tbne\t%s %%x0 %s\t# %d \n" reg_sw b p; (* x <= y なら 飛ぶ *)
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (Tail, e1)
  | NonTail(z), IfEq(x, y', e1, e2) ->
      let b_else = Id.genid ("beq_else") in
      let b_cont = Id.genid ("beq_cont") in
      let dest = NonTail(z) in
      (
        match y' with
        | V(y) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tbne\t%s %s %s\t# %d \n" x y b_else p;
        | C(i) when i = 0 -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\tbne\t%s %%x0 %s\t# %d \n" x b_else p
        )
        | C(i) -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          inst_address := !inst_address + 4;Printf.fprintf oc "\tbne\t%s %s %s\t# %d \n" x reg_sw b_else p
        )
      );
      let stackset_back = !stackset in
      g oc (dest, e1);
      let stackset1 = !stackset in
      inst_address := !inst_address + 4;Printf.fprintf oc "\tj\t%s\t# %d \n" b_cont p;
      Printf.fprintf oc "%s:\t# %d \n" b_else p;
      stackset := stackset_back;
      g oc (dest, e2);
      Printf.fprintf oc "%s:\t# %d \n" b_cont p;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfLE(x, y', e1, e2) ->
      let b = Id.genid ("blt") in
      let b_cont = Id.genid ("blt_cont") in
      let dest = NonTail(z) in
      (
        match y' with
        | V(y) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" y x b p; (* (y < x なら飛ぶ) *)
        | C(i) when i = 0-> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%%x0 %s %s\t# %d \n" x b p
        )
        | C(i) -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" reg_sw x b p
        )
      );
      let stackset_back = !stackset in
      g oc (dest, e1);
      let stackset1 = !stackset in
      inst_address := !inst_address + 4;Printf.fprintf oc "\tj\t%s\t# %d \n" b_cont p;
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (dest, e2);
      Printf.fprintf oc "%s:\t# %d \n" b_cont p;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfGE(x, y', e1, e2) ->
      let b_else = Id.genid ("bge") in
      let b_cont = Id.genid ("beq_cont") in
      let dest = NonTail(z) in
      (
        match y' with
        | V(y) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x y b_else p; (* (x - 1 < y なら飛ぶ) *)
        | C(i) when i = 0 -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%s %%x0 %s\t# %d \n" x b_else p
        )
        | C(i) -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          inst_address := !inst_address + 4;Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x reg_sw b_else p
        )
      );
      let stackset_back = !stackset in
      g oc (dest, e1);
      let stackset1 = !stackset in
      inst_address := !inst_address + 4;Printf.fprintf oc "\tj\t%s\t# %d \n" b_cont p;
      Printf.fprintf oc "%s:\t# %d \n" b_else p;
      stackset := stackset_back;
      g oc (dest, e2);
      Printf.fprintf oc "%s:\t# %d \n" b_cont p;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2

  | NonTail(z), IfFEq(x, y, e1, e2) ->
      let b = Id.genid ("feq") in
      let b_cont = Id.genid ("feq_cont") in
      let dest = NonTail(z) in
      (* inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 0\t# %d \n" reg_sw p; reg_sw に 0 を代入 *)
      (* inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 0\t# %d \n" reg_sw2 p; reg_sw2 に 0 を代入 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfle\t%s %s %s\t# %d \n" reg_sw x y p; (* x <= y なら 1 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfle\t%s %s %s\t# %d \n" reg_sw2 y x p; (* y <= x なら 1 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tand\t%s %s %s\t# %d \n" reg_sw reg_sw reg_sw2 p; (* x = y なら 1 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tbne\t%s %%x0 %s\t# %d \n" reg_sw b p; (* x = y なら飛ぶ *)
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      inst_address := !inst_address + 4;Printf.fprintf oc "\tj\t%s\t# %d \n" b_cont p;
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\t# %d \n" b_cont p;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfFLE(x, y, e1, e2) ->
      let b = Id.genid ("fle") in
      let b_cont = Id.genid ("fle_cont") in
      let dest = NonTail(z) in
      (* inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %%x0 0\t# %d \n" reg_sw p; reg_sw に 0 を代入 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfle\t%s %s %s\t# %d \n" reg_sw x y p; (* x <= y なら 1 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tbne\t%s %%x0 %s\t# %d \n" reg_sw b p; (* x <= y なら 飛ぶ *)
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      inst_address := !inst_address + 4;Printf.fprintf oc "\tj\t%s\t# %d \n" b_cont p;
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\t# %d \n" b_cont p;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
      
  (* 関数呼び出しの仮想命令の実装 (caml2html: emit_call) *)
  | Tail, CallCls(x, ys, zs) -> (* 末尾呼び出し (caml2html: emit_tailcall) *) (* x : 関数の名前, ys : 整数引数, zs : 浮動小数引数 *)
      g'_args oc [(x, reg_cl)] ys zs p;
      inst_address := !inst_address + 4;Printf.fprintf oc "\tlw\t%s 0(%s)\t# %d \n" reg_sw reg_cl p; (* クロージャレジスタが指すクロージャ先頭のアドレスをスワップレジスタに移動させる *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tjr\t0(%s)\t# %d \n" reg_sw p;
  | Tail, CallDir(Id.L(x), ys, zs) -> (* 末尾呼び出し *)
      g'_args oc [] ys zs p;
      inst_address := !inst_address + 4;Printf.fprintf oc "\tj\t%s\t# %d \n" x p; (* ラベルxに飛ぶ *)
  | NonTail(a), CallCls(x, ys, zs) ->
      g'_args oc [(x, reg_cl)] ys zs p;
      let ss = stacksize () in
      inst_address := !inst_address + 4;Printf.fprintf oc "\tsw\t%s %d(%s)\t# %d \n" reg_ra (-ss + 4) reg_sp p; (* リターンアドレスの退避 *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tlw\t%s 0(%s)\t# %d \n" reg_sw reg_cl p; (* クロージャの先頭のデータをスワップレジスタに移動する *)
    (* よくわからない *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %s -%d\t# %d \n" reg_sp reg_sp ss p; (* レジスタ溢れによって退避する分だけスタックを拡張しておく *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\tjalr\t%%x1 0(%s)\t# %d \n" reg_sw p;
      inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %s %d\t# %d \n" reg_sp reg_sp ss p; (* 拡張した分を戻す *)

      inst_address := !inst_address + 4;Printf.fprintf oc "\tlw\t%s %d(%s)\t# %d \n" reg_ra (-ss + 4) reg_sp p;  (* リターンアドレスの復帰 *)
      if List.mem a allregs && a <> regs.(0) then (* 関数の整数返り値レジスタがreg.(0)でなければ *)
        (inst_address := !inst_address + 4;Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" a regs.(0) p) (* reg.(0)からaにデータを移動 *)
      else if List.mem a allfregs && a <> fregs.(0) then (* 関数の浮動小数返り値レジスタがfreg.(0)でなければ *)
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\titof\t%s %%x0\t# %d \n" reg_fsw p;  (* 浮動小数の0を用意 *)
          inst_address := !inst_address + 4;Printf.fprintf oc "\tfadd\t%s %s %s\t# %d \n" a fregs.(0) reg_fsw p;
        );
  | NonTail(a), CallDir(Id.L(x), ys, zs) ->
      g'_args oc [] ys zs p;
      let ss = stacksize () in
      inst_address := !inst_address + 4;Printf.fprintf oc "\tsw\t%s %d(%s)\t# %d \n" reg_ra (-ss + 4) reg_sp p; (* リターンアドレスレジスタのデータをスタックの末尾に追加する *)
    (* よくわからない *)
      inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %s -%d\t# %d \n" reg_sp reg_sp ss p; (* レジスタ溢れによって退避する分だけスタックを拡張しておく *)

      inst_address := !inst_address + 4;Printf.fprintf oc "\tjal\t %%x1 %s\t# %d \n" x p;

      inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%s %s %d\t# %d \n" reg_sp reg_sp ss p;


      inst_address := !inst_address + 4;Printf.fprintf oc "\tlw\t%s %d(%s)\t# %d \n" reg_ra (-ss + 4) reg_sp p;
      if List.mem a allregs && a <> regs.(0) then
        (inst_address := !inst_address + 4;Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" a regs.(0) p)
      else if List.mem a allfregs && a <> fregs.(0) then
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\titof\t%s %%x0\t# %d \n" reg_fsw p;  (* 浮動小数の0を用意 *)
          inst_address := !inst_address + 4;Printf.fprintf oc "\tfadd\t%s %s %s\t# %d \n" a fregs.(0) reg_fsw p;
        );
and g'_args oc x_reg_cl ys zs p = (* x_reg_cl *)
  let (i, yrs) =
    List.fold_left
      (fun (i, yrs) y -> (i + 1, (y, regs.(i)) :: yrs))
      (0, x_reg_cl)
      ys in
  (*
    (i, yrs) =  (len(n), [(y[n], reg[n]); ...;(y[0], reg[0]); (x, reg_cl)]). yrsは引数に渡す変数名とレジスタの組
  *)
  List.iter
    (fun (y, r) -> inst_address := !inst_address + 4;Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" r y p)
    (shuffle reg_sw yrs);
  (* 変数を関数呼び出し規約に従ったレジスタに移動させている *)
  let (d, zfrs) =
    List.fold_left
      (fun (d, zfrs) z -> (d + 1, (z, fregs.(d)) :: zfrs))
      (0, [])
      zs in
  List.iter
    (fun (z, fr) ->
      inst_address := !inst_address + 4;Printf.fprintf oc "\tfadd\t%s %%f0 %s\t# %d \n" fr z p;
    )
    (shuffle reg_fsw zfrs)

let h oc { name = Id.L(x); args = _; fargs = _; body = e; ret = _ } =
  address_env := (Id.L(x), !inst_address) :: !address_env;
  Printf.fprintf oc "%s:\t#- %d\n" x !inst_address;
  stackset := S.empty;
  stackmap := [];
  g oc (Tail, e)

let ftp_address = ref 0x200000
let sp_address = ref (0x200000 - 4)
let hp_address = ref (0x200000 + 256)

let allocate_st_and_hp oc = 
  set_int oc reg_sp !sp_address 0;
  set_int oc reg_hp !hp_address 0;
  set_int oc reg2 2 0

let output_float_table oc data = 
  set_int oc reg_ftp !ftp_address 0;
  List.iter
    (fun (offset, d) -> 
    let bof = Int32.bits_of_float d in (* 64ビット浮動小数を32bit表現に変換 *)
    let l11_0 = Int32.logand (Int32.of_string "0xfff") bof in (* 下位12ビット *)

    inst_address := !inst_address + 4; Printf.fprintf oc "\tlui\t%%x6 %ld\n" bof; (*上位20ビットを%x6に入れる *)

    (
      match l11_0 with
      | x when x > Int32.of_string "0x7ff" -> 
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%%x6 %%x6 2047\n";
          inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%%x6 %%x6 %ld\n" (Int32.sub l11_0 (Int32.of_string "0x7ff"));
        )
      | x when x = Int32.of_string "0" -> ()
      | _ ->
        (
          inst_address := !inst_address + 4;Printf.fprintf oc "\taddi\t%%x6 %%x6 %ld\n" l11_0;
        )
    ); (* 下位12ビットを%x6に入れる *)

    inst_address := !inst_address + 4;Printf.fprintf oc "\tsw\t%%x6 %d(%s)\n" offset reg_ftp;
    )
    data;
  inst_address := !inst_address + 4;
  Printf.fprintf oc "\tj\tmin_caml_start2\n"

let s = ref ""

let output_utils_s oc ic = 
  while (s := input_line ic; !s <> "END") do
    (match !s with
    | x when String.get x 0 = ' ' -> 
      inst_address := !inst_address + 4; output_string oc (x^"\n")
    | x -> output_string oc (x^"\n"));
  done

let f oc ic (Prog(data, fundefs, e)) =
  Format.eprintf "generating assembly...@.";
  Printf.fprintf oc ".global min_caml_start\n";
  Printf.fprintf oc "min_caml_start:\t\n";
  output_float_table oc data;
  output_utils_s oc ic;
  List.iter (fun fundef -> h oc fundef) fundefs;
  Printf.fprintf oc "min_caml_start2:\n";
  allocate_st_and_hp oc;
  stackset := S.empty;
  stackmap := [];
  g oc (NonTail(zero_reg), e);