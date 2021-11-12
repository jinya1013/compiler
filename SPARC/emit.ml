open Asm

external gethi : float -> int32 = "gethi"
external getlo : float -> int32 = "getlo"

let stackset = ref S.empty (* ���Ǥ�Save���줿�ѿ��ν��� (caml2html: emit_stackset) *)
let stackmap = ref [] (* Save���줿�ѿ��Ρ������å��ˤ�������� (caml2html: emit_stackmap) *)
let save x =
  stackset := S.add x !stackset; (* ����save���줿�ѿ��ν����x���ɲä�, stackmap��x���ʤ����, stackmap�α�ü��x���ɲä��� *)
  if not (List.mem (x, Type.Int) !stackmap) then
    stackmap := !stackmap @ [(x, Type.Int)]
let savef x =
  stackset := S.add x !stackset; (* ��ư�������礭����32bit�ʤΤ�, ���Τ褦�ˤʤä�. *)
  if not (List.mem (x, Type.Float) !stackmap) then
    stackmap := !stackmap @ [(x, Type.Float)]
let locate x = (* stackmap(stack��save����Ƥ����ѿ��Υꥹ��)��Ƶ�Ū�˸���, �����å���Ǥ��ѿ��ΰ��֤��֤��ؿ� *)
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

(* �ؿ��ƤӽФ��Τ���˰������¤��ؤ���(register shuffling) (caml2html: emit_shuffle) *)
let rec shuffle sw xys = (* sw: ����å��ѤΥ쥸����, xys: �������ѿ�̾�ȥ쥸������̾���Υꥹ�� *)
  (* remove identical moves *)
  let _, xys = List.partition (fun (x, y) -> x = y) xys in (* ��(x, y)�Υꥹ�Ȥ��Ф���, x != y ����ʬ�������Ф�  *)
  (* find acyclic moves *)
  match List.partition (fun (_, y) -> List.mem_assoc y xys) xys with (* �ꥹ�Ȥ����Ǥ�(_, y);(y, __) �Τ褦�ˤʤäƤ����Τ���Ф� *)
  | [], [] -> []
  | (x, y) :: xys, [] -> (* no acyclic moves; resolve a cyclic move *)
      (y, sw) :: (x, y) :: shuffle sw (List.map
                                         (function
                                           | (y', z) when y = y' -> (sw, z)
                                           | yz -> yz)
                                         xys)
  | xys, acyc -> acyc @ shuffle sw xys

type dest = Tail | NonTail of Id.t (* �������ɤ�����ɽ���ǡ����� (caml2html: emit_dest) *)
let rec g oc = function (* ̿����Υ�����֥����� (caml2html: emit_g) *)
  | dest, Ans(exp, p) -> g' p oc (dest, exp)
  | dest, Let((x, t), exp, e, p) ->
      g' p oc (NonTail(x), exp);
      g oc (dest, e)
and g' p oc = function (* ��̿��Υ�����֥����� (caml2html: emit_gprime) *)
  (* �����Ǥʤ��ä���׻���̤�dest�˥��å� (caml2html: emit_nontail) *)
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
      Printf.fprintf oc "\titof\t%s %%x0\t# %d \n" reg_fsw p;  (* ��ư������0���Ѱ� *)
      Printf.fprintf oc "\tfadd\t%s %s %s\t# %d \n" x y reg_fsw p; (* f0��y���¤�x������� *)
  | NonTail(x), FNegD(y) ->
      Printf.fprintf oc "\tfneg\t%s %s\t# %d \n" x y p;
  | NonTail(x), FAddD(y, z) -> Printf.fprintf oc "\tfadd\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), FSubD(y, z) -> Printf.fprintf oc "\tfsub\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), FMulD(y, z) -> Printf.fprintf oc "\tfmul\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), FDivD(y, z) -> Printf.fprintf oc "\tfdiv\t%s %s %s\t# %d \n" x y z p
  | NonTail(x), LdDF(y, z') -> Printf.fprintf oc "\tflw\t%s (%s)%s\t# %d \n" x (pp_id_or_imm z') y p
  | NonTail(_), StDF(x, y, z') -> Printf.fprintf oc "\tfsw\t%s (%s)%s\t# %d \n\n" x (pp_id_or_imm z') y p

  | NonTail(_), Comment(s) -> Printf.fprintf oc "\t# %s\t# %d \n" s p

  (* ����β���̿��μ��� (caml2html: emit_save) *)
  | NonTail(_), Save(x, y) when List.mem x allregs && not (S.mem y !stackset) -> (* �����쥸����x�����äƤ����ѿ�y�򥹥��å������� *)
      save y; (* ����ѥ������������򹹿�(y�򥹥��å��ˤΤä���) *)
      Printf.fprintf oc "\tsw\t%s %d(%s)\t# %d \n" x (offset y) reg_sp p
  | NonTail(_), Save(x, y) when List.mem x allfregs && not (S.mem y !stackset) ->
      savef y;
      Printf.fprintf oc "\tfsw\t%s %d(%s)\t# %d \n" x (offset y) reg_sp p
  | NonTail(_), Save(x, y) -> assert (S.mem y !stackset); () (* �嵭2�İʳ��ϥ��顼 *)

  (* �����β���̿��μ��� (caml2html: emit_restore) *)
  | NonTail(x), Restore(y) when List.mem x allregs -> 
      Printf.fprintf oc "\tlw\t%s %d(%s)\t# %d \n" x (offset y) reg_sp p
  | NonTail(x), Restore(y) ->
      (* Id.output_id stdout x; *)
      assert (List.mem x allfregs);
      Printf.fprintf oc "\tflw\t%s %d(%s)\t# %d \n" x (offset y) reg_sp p
  (* �������ä���׻���̤����쥸�����˥��åȤ��ƥ꥿���� (caml2html: emit_tailret) *) (* �֤��ͤ��ʤ�̿�� *)
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
        match locate x with (* �����å���Ǥ��ѿ�x�ΰ��֤�Ĵ�٤� *)
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
        | V(y) -> Printf.fprintf oc "\tbne\t%s %s %s\t# %d \n" x y b_else p; (* (x - 1 < y���ʤ�����) *)
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
      (
        match y' with
        | V(y) -> Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" y x b p; (* (y lt x �ʤ�����) *)
        | C(i) -> 
        (
          Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" reg_sw x b p
        )
      );
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      g oc (Tail, e1);
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (Tail, e2)
  | Tail, IfGE(x, y', e1, e2) ->
      let b_else = Id.genid ("bge_else") in
      (
        match y' with
        | V(y) -> Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x y b_else p; (* (x - 1 < y���ʤ�����) *)
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

  (* Risc-V�Ǥ���ư��������ӱ黻�����Ĥ���ʤ��ä��Τ�, ����Ū *)
  | Tail, IfFEq(x, y, e1, e2) ->
      let b = Id.genid ("feq") in
      Printf.fprintf oc "\tfeq\t%s %s %s\t# %d \n" x y b p;
      Printf.fprintf oc "\tnop\t# %d \n" p;
      let stackset_back = !stackset in
      g oc (Tail, e2);
      Printf.fprintf oc "%s:\t# %d \n" b p;
      stackset := stackset_back;
      g oc (Tail, e1)
  | Tail, IfFLE(x, y, e1, e2) ->
      let b = Id.genid ("fle") in
      Printf.fprintf oc "\tfle\t%s %s %s\t# %d \n" x y b p;
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
        | V(y) -> Printf.fprintf oc "\tbne\t%s %s %s\t# %d \n" x y b_else p; (* (x ne y���ʤ�����) *)
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
      (
        match y' with
        | V(y) -> Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" y x b p; (* (y le x���ʤ�����) *)
        | C(i) -> 
        (
          Printf.fprintf oc "\taddi\t%s %%x0 %d\t# %d \n" reg_sw i p;
          Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" reg_sw x b p
        )
      );
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
  | NonTail(z), IfGE(x, y', e1, e2) ->
      let b_else = Id.genid ("beq_else") in
      let b_cont = Id.genid ("beq_cont") in
      let dest = NonTail(z) in
      (
        match y' with
        | V(y) -> Printf.fprintf oc "\tblt\t%s %s %s\t# %d \n" x y b_else p; (* (x - 1 < y���ʤ�����) *)
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
      let b = Id.genid ("feq") in
      let b_cont = Id.genid ("feq_cont") in
      let dest = NonTail(z) in
      Printf.fprintf oc "\tfeq\t%s %s %s\t# %d \n" x y b p;
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
      
  (* �ؿ��ƤӽФ��β���̿��μ��� (caml2html: emit_call) *)
  | Tail, CallCls(x, ys, zs) -> (* �����ƤӽФ� (caml2html: emit_tailcall) *) (* x : �ؿ���̾��, ys : ��������, zs : ��ư�������� *)
      g'_args oc [(x, reg_cl)] ys zs p;
      Printf.fprintf oc "\tlw\t%s 0(%s)\t# %d \n" reg_sw reg_cl p; (* ��������쥸�������ؤ�����������Ƭ�Υ��ɥ쥹�򥹥�åץ쥸�����˰�ư������ *)
      Printf.fprintf oc "\tjr\t0(%s)\t# %d \n" reg_sw p;
      Printf.fprintf oc "\tnop\t# %d \n" p
  | Tail, CallDir(Id.L(x), ys, zs) -> (* �����ƤӽФ� *)
      g'_args oc [] ys zs p;
      Printf.fprintf oc "\tj\t%s\t# %d \n" x p; (* ��٥�x������ *)
      Printf.fprintf oc "\tnop\t# %d \n" p
  | NonTail(a), CallCls(x, ys, zs) ->
      g'_args oc [(x, reg_cl)] ys zs p;
      let ss = stacksize () in
      Printf.fprintf oc "\tsw\t%s %d(%s)\t# %d \n" reg_ra (ss - 4) reg_sp p; (* �꥿���󥢥ɥ쥹������ *)
      Printf.fprintf oc "\tlw\t%s 0(%s)\t# %d \n" reg_sw reg_cl p;
    (* �褯�狼��ʤ� *)
      Printf.fprintf oc "\taddi\t%s %s %d\t# %d \n" reg_sp reg_sp ss p; (* �쥸�������ˤ�ä����򤹤�ʬ���������å����ĥ���Ƥ��� *)
      Printf.fprintf oc "\tjalr\t%%x1 %s\t# %d \n" reg_sw p;
      Printf.fprintf oc "\taddi\t%s %s -%d\t# %d \n" reg_sp reg_sp ss p; (* ��ĥ����ʬ���᤹ *)

      Printf.fprintf oc "\tlw\t%s %d(%s)\t# %d \n" reg_ra (ss - 4) reg_sp p;  (* �꥿���󥢥ɥ쥹������ *)
      if List.mem a allregs && a <> regs.(0) then (* �ؿ��������֤��ͥ쥸������reg.(0)�Ǥʤ���� *)
        Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" a regs.(0) p (* reg.(0)����a�˥ǡ������ư *)
      else if List.mem a allfregs && a <> fregs.(0) then (* �ؿ�����ư�����֤��ͥ쥸������freg.(0)�Ǥʤ���� *)
        (
          Printf.fprintf oc "\tfadd\t%s %s %%f0\t# %d \n" a fregs.(0) p;
        );
  | NonTail(a), CallDir(Id.L(x), ys, zs) ->
      g'_args oc [] ys zs p;
      let ss = stacksize () in
      Printf.fprintf oc "\tsw\t%s %d(%s)\t# %d \n" reg_ra (ss - 4) reg_sp p;

    (* �褯�狼��ʤ� *)
      Printf.fprintf oc "\taddi\t%s %s %d\t# %d \n" reg_sp reg_sp ss p;

      Printf.fprintf oc "\tjal\t %%x1 %s\t# %d \n" x p;

      Printf.fprintf oc "\taddi\t%s %s -%d\t# %d \n" reg_sp reg_sp ss p;


      Printf.fprintf oc "\tlw\t%s %d(%s)\t# %d \n" reg_ra (ss - 4) reg_sp p;
      if List.mem a allregs && a <> regs.(0) then
        Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" a regs.(0) p
      else if List.mem a allfregs && a <> fregs.(0) then
        (
          Printf.fprintf oc "\tfadd\t%s %s %%f0\t# %d \n" a fregs.(0) p;
        );
and g'_args oc x_reg_cl ys zs p = (* x_reg_cl *)
  let (i, yrs) =
    List.fold_left
      (fun (i, yrs) y -> (i + 1, (y, regs.(i)) :: yrs))
      (0, x_reg_cl)
      ys in
  (*
    (i, yrs) =  (len(n), [(y[n], reg[n]); ...;(y[0], reg[0]); (x, reg_cl)]). yrs�ϰ������Ϥ��ѿ�̾�ȥ쥸��������
  *)
  List.iter
    (fun (y, r) -> Printf.fprintf oc "\tadd\t%s %%x0 %s\t# %d \n" r y p)
    (shuffle reg_sw yrs);
  (* �ѿ���ؿ��ƤӽФ�����˽��ä��쥸�����˰�ư�����Ƥ��� *)
  let (d, zfrs) =
    List.fold_left
      (fun (d, zfrs) z -> (d + 1, (z, fregs.(d)) :: zfrs))
      (0, [])
      zs in
  List.iter
    (fun (z, fr) ->
      Printf.fprintf oc "\tfadd\t%s %s %%f0\t# %d \n" fr z p;
    )
    (shuffle reg_fsw zfrs)

let h oc { name = Id.L(x); args = _; fargs = _; body = e; ret = _ } =
  Printf.fprintf oc "%s:\n" x;
  stackset := S.empty;
  stackmap := [];
  g oc (Tail, e)

let f oc (Prog(data, fundefs, e)) =
  Format.eprintf "generating assembly...@.";
  Printf.fprintf oc "float_table:\t\n";
  List.iter
    (fun (Id.L(x), d) -> 
    let bof = Int32.bits_of_float d in (* ��ư������bitɽ�����Ѵ� *)
    let l11_0 = Int32.logand (Int32.of_string "0xfff") bof in
    let m23_12 = Int32.logand (Int32.of_string "0xfff") (Int32.shift_right_logical bof 12) in
    let h31_24 = Int32.logand (Int32.of_string "0xfff") (Int32.shift_right_logical bof 24) in
    Printf.fprintf oc "\taddi\t%%x1 %%x0 %ld\n" h31_24;
    Printf.fprintf oc "\taddi\t%%x2 %%x0 8\n";
    Printf.fprintf oc "\taddi\t%%x3 %%x0 12\n";
    Printf.fprintf oc "\tsll\t%%x1 %%x1 %%x2\n";
    Printf.fprintf oc "\taddi\t%%x1 %%x1 %ld\n" m23_12;
    Printf.fprintf oc "\tsll\t%%x1 %%x1 %%x3\n";
    Printf.fprintf oc "\taddi\t%%x1 %%x1 %ld\n" l11_0;
    Printf.fprintf oc "\taddi\t%%x1 %%x1 %ld\n" l11_0;
    Printf.fprintf oc "\tfsw\t%%x1 0(%s)\n" reg_ftp;

    )
    data;
  List.iter (fun fundef -> h oc fundef) fundefs;
  Printf.fprintf oc "min_caml_start:\n";
  stackset := S.empty;
  stackmap := [];
  g oc (NonTail("%%x0"), e);
