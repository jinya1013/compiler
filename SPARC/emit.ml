open Asm

external gethi : float -> int32 = "gethi"
external getlo : float -> int32 = "getlo"

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
let stacksize () = align ((List.length !stackmap + 1) * 4)

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

type dest = Tail | NonTail of Id.t (* 末尾かどうかを表すデータ型 (caml2html: emit_dest) *)
let rec g oc = function (* 命令列のアセンブリ生成 (caml2html: emit_g) *)
  | dest, Ans(exp, p) -> g' p oc (dest, exp)
  | dest, Let((x, t), exp, e, p) ->
      g' p oc (NonTail(x), exp);
      g oc (dest, e)
and g' p oc = function (* 各命令のアセンブリ生成 (caml2html: emit_gprime) *)
  (* 末尾でなかったら計算結果をdestにセット (caml2html: emit_nontail) *)
  | NonTail(_), Nop -> ()
  | NonTail(x), Set(i) -> Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" x i p
  | NonTail(x), SetL(Id.L(y)) -> Printf.fprintf oc "\taddi\t%s %%x0 %s\t# %d \n" x y p
  | NonTail(x), Mov(y) when x = y -> ()
  | NonTail(x), Mov(y) -> Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" x y p
  | NonTail(x), Neg(y) -> Printf.fprintf oc "\tsub\t%s %%x0 %s\t# %d \n" x y p
  | NonTail(x), Add(y, z') -> 
  (
    match z' with 
    | V(v) -> Printf.fprintf oc "\tadd\t%s %s %s\t# %d \n" x y (pp_id_or_imm z') p
    | C(c) -> Printf.fprintf oc "\taddi\t%s %s %s\t# %d \n" x y (pp_id_or_imm z') p
  )
  | NonTail(x), Sub(y, z') -> 
  (
    match z' with 
    | V(v) -> Printf.fprintf oc "\tsub\t%s %s %s\t# %d \n" x y (np_id_or_imm z') p
    | C(c) -> Printf.fprintf oc "\taddi\t%s %s %s\t# %d \n" x y (np_id_or_imm z') p
  )
  | NonTail(x), SLL(y, z') -> Printf.fprintf oc "\tsll\t%s %s %s\t# %d \n" x y (pp_id_or_imm z') p
  | NonTail(x), Ld(y, z') -> Printf.fprintf oc "\tlw\t%s %s(%s)\t# %d \n" x (pp_id_or_imm z') y p
  | NonTail(_), St(x, y, z') -> Printf.fprintf oc "\tsw\t%s %s(%s)\t# %d \n" x (pp_id_or_imm z') y p

  | NonTail(x), FMovD(y) when x = y -> ()
  | NonTail(x), FMovD(y) ->
      Printf.fprintf oc "\titof\t%s %%x0\t# %d \n" reg_fsw p;  (* 浮動小数の0を用意 *)
      Printf.fprintf oc "\tfadd\t%s %s %s\t# %d \n" x y reg_fsw p; (* f0とyの和をxに入れる *)
  | NonTail(x), FNegD(y) ->
      Printf.fprintf oc "\tfnegs\t%s %s\t# %d \n" x y p;
  | NonTail(x), FAddD(y, z) -> Printf.fprintf oc "\tfaddd\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), FSubD(y, z) -> Printf.fprintf oc "\tfsubd\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), FMulD(y, z) -> Printf.fprintf oc "\tfmuld\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), FDivD(y, z) -> Printf.fprintf oc "\tfdivd\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), LdDF(y, z') -> Printf.fprintf oc "\tlw\t%s (%s)%s\t# %d \n" x (pp_id_or_imm z') y p
  | NonTail(_), StDF(x, y, z') -> Printf.fprintf oc "\tsw\t%s (%s)%s\t# %d \n\n" x (pp_id_or_imm z') y p

  | NonTail(_), Comment(s) -> Printf.fprintf oc "\t# %s\t# %d \n" s p

  (* 退避の仮想命令の実装 (caml2html: emit_save) *)
  | NonTail(_), Save(x, y) when List.mem x allregs && not (S.mem y !stackset) -> (* 整数レジスタxに入っている変数yをスタックに退避 *)
      save y; (* コンパイラの内部情報を更新(yをスタックにのっける) *)
      Printf.fprintf oc "\tsw\t%s %d(%s)\t# %d \n" x (offset y) reg_sp p
  | NonTail(_), Save(x, y) when List.mem x allfregs && not (S.mem y !stackset) ->
      savef y;
      Printf.fprintf oc "\tsw\t%s %d(%s)\t# %d \n" x (offset y) reg_sp p
  | NonTail(_), Save(x, y) -> assert (S.mem y !stackset); () (* 上記2つ以外はエラー *)

  (* 復帰の仮想命令の実装 (caml2html: emit_restore) *)
  | NonTail(x), Restore(y) when List.mem x allregs -> 
      Printf.fprintf oc "\tlw\t%s %d(%s)\t# %d \n" x (offset y) reg_sp p
  | NonTail(x), Restore(y) ->
      Id.output_id stdout x;
      assert (List.mem x allfregs);
      Printf.fprintf oc "\tlw\t%s %d(%s)\t# %d \n" x (offset y) reg_sp p
  (* 末尾だったら計算結果を第一レジスタにセットしてリターン (caml2html: emit_tailret) *) (* 返り値がない命令 *)
  | Tail, (Nop | St _ | StDF _ | Comment _ | Save _ as exp) ->
      g' p oc (NonTail(Id.gentmp Type.Unit), exp);
      Printf.fprintf oc "\tjr\t0(%%x1)\t# %d \n" p;
      Printf.fprintf oc "\tnop\t# %d \n" p
  | Tail, (Set _ | SetL _ | Mov _ | Neg _ | Add _ | Sub _ | SLL _ | Ld _ as exp) ->
      g' p oc (NonTail(regs.(0)), exp);
      Printf.fprintf oc "\tjr\t0(%%x1)\t# %d \n" p;
      Printf.fprintf oc "\tnop\t# %d \n" p
  | Tail, (FMovD _ | FNegD _ | FAddD _ | FSubD _ | FMulD _ | FDivD _ | LdDF _ as exp) ->
      g' p oc (NonTail(fregs.(0)), exp);
      Printf.fprintf oc "\tjr\t0(%%x1)\t# %d \n" p;
      Printf.fprintf oc "\tnop\t# %d \n" p



  | Tail, (Restore(x) as exp) ->
      (
        match locate x with (* スタック中での変数xの位置を調べる *)
        | [(i, Type.Int)] -> g' p oc (NonTail(regs.(0)), exp)
        | [(i, Type.Float)] -> g' p oc (NonTail(fregs.(0)), exp)
        | _ -> assert false
      );

      Printf.fprintf oc "\tjr\t0(%%x1)\t# %d \n" p;
      Printf.fprintf oc "\tnop\t# %d \n" p

  | Tail, IfEq(x, y', e1, e2) ->
      let b_else = Id.genid ("beq_else") in
      (
        match y' with
        | V(y) -> Printf.fprintf oc "\tbne\t%s %s %s\t# %d \n" x y b_else p; (* (x - 1 < y　なら飛ぶ) *)
        | C(i) -> 
        (
          Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          Printf.fprintf oc "\tbne\t%s %s %s\t# %d \n" x reg_sw b_else p
        )
      );
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      g oc (Tail, e1);
      Printf.fprintf oc "%s:\t# %d \n" b_else p;
      stackset := stackset_back;
      g oc (Tail, e2)
  | Tail, IfLE(x, y', e1, e2) ->
      let b = Id.genid ("blt") in
      Printf.fprintf oc "\taddi\t%s %s -1\t# %d \n" x x p;
      (
        match y' with
        | V(y) -> Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x y b p; (* (x - 1 < y　なら飛ぶ) *)
        | C(i) -> 
        (
          Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x reg_sw b p
        )
      );
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      Printf.fprintf oc "\taddi\t%s %s 1\t# %d \n" x x p;
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      Printf.fprintf oc "\taddi\t%s %s 1\t# %d \n" x x p;
      g oc (Tail, e1)
  | Tail, IfGE(x, y', e1, e2) ->
      let b_else = Id.genid ("bge_else") in
      (
        match y' with
        | V(y) -> Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x y b_else p; (* (x - 1 < y　なら飛ぶ) *)
        | C(i) -> 
        (
          Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x reg_sw b_else p
        )
      );
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      g oc (Tail, e1);
      Printf.fprintf oc "%s:\t# %d \n" b_else p;
      stackset := stackset_back;
      g oc (Tail, e2)

  (* Risc-Vでは浮動小数の比較演算が見つからなかったので, 暫定的 *)
  | Tail, IfFEq(x, y, e1, e2) ->
      let b = Id.genid ("fbeq") in
      Printf.fprintf oc "\tfbeq\t%s %s %s\t# %d \n" x y b p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (Tail, e1)
  | Tail, IfFLE(x, y, e1, e2) ->
      let b = Id.genid ("fblt") in
      Printf.fprintf oc "\tfblt\t%s %s %s\t# %d \n" x y b p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
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
        | V(y) -> Printf.fprintf oc "\tbne\t%s %s %s\t# %d \n" x y b_else p; (* (x - 1 < y　なら飛ぶ) *)
        | C(i) -> 
        (
          Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          Printf.fprintf oc "\tbne\t%s %s %s\t# %d \n" x reg_sw b_else p
        )
      );
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      g oc (dest, e1);
      let stackset1 = !stackset in
      Printf.fprintf oc "\tj\t%s\t# %d \n" b_cont p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
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
      Printf.fprintf oc "\taddi\t%s %s -1\t# %d \n" x x p;
      (
        match y' with
        | V(y) -> Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x y b p; (* (x - 1 < y　なら飛ぶ) *)
        | C(i) -> 
        (
          Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x reg_sw b p
        )
      );
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      Printf.fprintf oc "\taddi\t%s %s 1\t# %d \n" x x p;
      g oc (dest, e2);
      let stackset1 = !stackset in
      Printf.fprintf oc "\tj\t%s\t# %d \n" b_cont p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      Printf.fprintf oc "\taddi\t%s %s 1\t# %d \n" x x p;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\t# %d \n" b_cont p;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfGE(x, y', e1, e2) ->
      let b_else = Id.genid ("beq_else") in
      let b_cont = Id.genid ("beq_cont") in
      let dest = NonTail(z) in
      (
        match y' with
        | V(y) -> Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x y b_else p; (* (x - 1 < y　なら飛ぶ) *)
        | C(i) -> 
        (
          Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x reg_sw b_else p
        )
      );
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      g oc (dest, e1);
      let stackset1 = !stackset in
      Printf.fprintf oc "\tj\t%s\t# %d \n" b_cont p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      Printf.fprintf oc "%s:\t# %d \n" b_else p;
      stackset := stackset_back;
      g oc (dest, e2);
      Printf.fprintf oc "%s:\t# %d \n" b_cont p;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2

  | NonTail(z), IfFEq(x, y, e1, e2) ->
      let b = Id.genid ("fbeq") in
      let b_cont = Id.genid ("fbeq_cont") in
      let dest = NonTail(z) in
      Printf.fprintf oc "\tfbeq\t%s %s %s\t# %d \n" x y b p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      Printf.fprintf oc "\tj\t%s\t# %d \n" b_cont p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\t# %d \n" b_cont p;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
  | NonTail(z), IfFLE(x, y, e1, e2) ->
      let b = Id.genid ("fblt") in
      let b_cont = Id.genid ("fblt_cont") in
      let dest = NonTail(z) in
      Printf.fprintf oc "\tfblt\t%s %s %s\t# %d \n" x y b p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      g oc (dest, e2);
      let stackset1 = !stackset in
      Printf.fprintf oc "\tj\t%s\t# %d \n" b_cont p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (dest, e1);
      Printf.fprintf oc "%s:\t# %d \n" b_cont p;
      let stackset2 = !stackset in
      stackset := S.inter stackset1 stackset2
      
  (* 関数呼び出しの仮想命令の実装 (caml2html: emit_call) *)
  | Tail, CallCls(x, ys, zs) -> (* 末尾呼び出し (caml2html: emit_tailcall) *) (* x : 関数の名前, ys : 整数引数, zs : 浮動小数引数 *)
      g'_args oc [(x, reg_cl)] ys zs p;
      Printf.fprintf oc "\tlw\t%s 0(%s)\t# %d \n" reg_sw reg_cl p; (* クロージャレジスタが指すクロージャ先頭のアドレスをスワップレジスタに移動させる *)
      Printf.fprintf oc "\tjr\t0(%s)\t# %d \n" reg_sw p;
      Printf.fprintf oc "\tnop\t# %d \n" p
  | Tail, CallDir(Id.L(x), ys, zs) -> (* 末尾呼び出し *)
      g'_args oc [] ys zs p;
      Printf.fprintf oc "\tj\t%s\t# %d \n" x p; (* ラベルxに飛ぶ *)
      Printf.fprintf oc "\tnop\t# %d \n" p
  | NonTail(a), CallCls(x, ys, zs) ->
      g'_args oc [(x, reg_cl)] ys zs p;
      let ss = stacksize () in
      Printf.fprintf oc "\tsw\t%s %d(%s)\t# %d \n" reg_ra (ss - 4) reg_sp p; (* リターンアドレスの退避 *)
      Printf.fprintf oc "\tlw\t%s 0(%s)\t# %d \n" reg_sw reg_cl p;
    (* よくわからない *)
      Printf.fprintf oc "\taddi\t%s %s %d\t# %d \n" reg_sp reg_sp ss p; (* レジスタ溢れによって退避する分だけスタックを拡張しておく *)
      Printf.fprintf oc "\tjalr\t%%x1 %s\t# %d \n" reg_sw p;
      Printf.fprintf oc "\taddi\t%s %s -%d\t# %d \n" reg_sp reg_sp ss p; (* 拡張した分を戻す *)

      Printf.fprintf oc "\tlw\t%s %d(%s)\t# %d \n" reg_ra (ss - 4) reg_sp p;  (* リターンアドレスの復帰 *)
      if List.mem a allregs && a <> regs.(0) then (* 関数の整数返り値レジスタがreg.(0)でなければ *)
        Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" a regs.(0) p (* reg.(0)からaにデータを移動 *)
      else if List.mem a allfregs && a <> fregs.(0) then (* 関数の浮動小数返り値レジスタがfreg.(0)でなければ *)
        (
          Printf.fprintf oc "\titof\t%s %%x0\t# %d \n" reg_fsw p;  (* 浮動小数の0を用意 *)
          Printf.fprintf oc "\tfadd\t%s %s %s\t# %d \n" a fregs.(0) reg_fsw p;
        );
  | NonTail(a), CallDir(Id.L(x), ys, zs) ->
      g'_args oc [] ys zs p;
      let ss = stacksize () in
      Printf.fprintf oc "\tsw\t%s %d(%s)\t# %d \n" reg_ra (ss - 4) reg_sp p;

    (* よくわからない *)
      Printf.fprintf oc "\taddi\t%s %s %d\t# %d \n" reg_sp reg_sp ss p;

      Printf.fprintf oc "\tjal\t %%x1 %s\t# %d \n" x p;

      Printf.fprintf oc "\taddi\t%s %s -%d\t# %d \n" reg_sp reg_sp ss p;


      Printf.fprintf oc "\tlw\t%s %d(%s)\t# %d \n" reg_ra (ss - 4) reg_sp p;
      if List.mem a allregs && a <> regs.(0) then
        Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" a regs.(0) p
      else if List.mem a allfregs && a <> fregs.(0) then
        (
          Printf.fprintf oc "\titof\t%s %%x0\t# %d \n" reg_fsw p;  (* 浮動小数の0を用意 *)
          Printf.fprintf oc "\tfadd\t%s %s %s\t# %d \n" a fregs.(0) reg_fsw p;
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
    (fun (y, r) -> Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" r y p)
    (shuffle reg_sw yrs);
  (* 変数を関数呼び出し規約に従ったレジスタに移動させている *)
  let (d, zfrs) =
    List.fold_left
      (fun (d, zfrs) z -> (d + 1, (z, fregs.(d)) :: zfrs))
      (0, [])
      zs in
  List.iter
    (fun (z, fr) ->
      Printf.fprintf oc "\titof\t%s %%x0\t# %d \n" reg_fsw p;  (* 浮動小数の0を用意 *)
      Printf.fprintf oc "\tfadd\t%s %s %s\t# %d \n" fr z reg_fsw p;
    )
    (shuffle reg_fsw zfrs)

let h oc { name = Id.L(x); args = _; fargs = _; body = e; ret = _ } =
  Printf.fprintf oc "%s:\n" x;
  stackset := S.empty;
  stackmap := [];
  g oc (Tail, e)

let f oc (Prog(data, fundefs, e)) =
  Format.eprintf "generating assembly...@.";
  List.iter
    (fun (Id.L(x), d) ->
      Printf.fprintf oc "%s:\t! %f\n" x d;
      Printf.fprintf oc "\t.long\t0x%lx\n" (gethi d);
      Printf.fprintf oc "\t.long\t0x%lx\n" (getlo d))
    data;
  List.iter (fun fundef -> h oc fundef) fundefs;
  Printf.fprintf oc "min_caml_start:\n";
  stackset := S.empty;
  stackmap := [];
  g oc (NonTail("%%x0"), e);
