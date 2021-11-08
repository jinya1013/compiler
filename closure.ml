type closure = { entry : Id.l; actual_fv : Id.t list } (* �ȥåץ�٥�ؿ��Υ�٥�, ��ͳ�ѿ��Υꥹ�� *)
type t = (* ���������Ѵ���μ� (caml2html: closure_t) *)
  | Unit of Syntax.pos
  | Int of int * Syntax.pos
  | Float of float * Syntax.pos
  | Neg of Id.t * Syntax.pos
  | Add of Id.t * Id.t * Syntax.pos
  | Sub of Id.t * Id.t * Syntax.pos
  | FNeg of Id.t * Syntax.pos
  | FAdd of Id.t * Id.t * Syntax.pos
  | FSub of Id.t * Id.t * Syntax.pos
  | FMul of Id.t * Id.t * Syntax.pos
  | FDiv of Id.t * Id.t * Syntax.pos
  | IfEq of Id.t * Id.t * t * t * Syntax.pos
  | IfLE of Id.t * Id.t * t * t * Syntax.pos
  | Let of (Id.t * Type.t) * t * t * Syntax.pos
  | Var of Id.t * Syntax.pos
  | MakeCls of (Id.t * Type.t) * closure * t * Syntax.pos  (*(�ؿ�̾, �ؿ��η�), ��������, �ؿ������� *)
  | AppCls of Id.t * Id.t list * Syntax.pos
  | AppDir of Id.l * Id.t list * Syntax.pos
  | Tuple of Id.t list * Syntax.pos
  | LetTuple of (Id.t * Type.t) list * Id.t * t * Syntax.pos
  | Get of Id.t * Id.t * Syntax.pos
  | Put of Id.t * Id.t * Id.t * Syntax.pos
  | ExtArray of Id.l * Syntax.pos
type fundef = { name : Id.l * Type.t;
                args : (Id.t * Type.t) list;
                formal_fv : (Id.t * Type.t) list;
                body : t }
type prog = Prog of fundef list * t

let pos_of_t = function
  | Unit (p) -> p
  | Int (_, p) -> p
  | Float (_, p) -> p
  | Neg (_, p) -> p
  | FNeg (_, p) -> p
  | Add (_, _, p) -> p
  | Sub (_, _, p) -> p
  | FAdd(_, _, p) -> p
  | FSub(_, _, p) -> p
  | FMul (_, _, p) -> p 
  | FDiv (_, _, p) -> p
  | IfEq (_, _, _,_, p) -> p
  | IfLE (_, _,_, _, p) -> p 
  | Let  (_, _,_, p) -> p
  | Var  (_, p) -> p
  | MakeCls(_, _, _, p) -> p
  | AppCls( _, _, p) -> p
  | AppDir(_, _, p) -> p
  | Tuple (_, p) -> p
  | LetTuple(_, _, _, p) -> p
  | Get (_, _, p) -> p
  | Put (_, _, _, p) -> p  
  | ExtArray(_, p) -> p



(*
    ��s�������ꡤ��ͳ�ѿ���MapS���֤�

    Args
        s : Closure.t
          ��

    Returns
      retval: S.t
        Id.t�ν���
*)
let rec fv = function
(* 
    Ϳ����줿���������Ѵ���μ�c����˴ޤޤ�뼫ͳ�ѿ��Υꥹ�Ȥ���Ϥ���.

    Args
        c : Closure.t
          ��ͳ�ѿ����ѿ���׻����������������Ѵ���μ�

    Returns
        retval : S.t
          c���ޤ༫ͳ�ѿ��ν���            
*)
  | Unit(_) | Int(_) | Float(_) | ExtArray(_) -> S.empty
  | Neg(x, _) | FNeg(x, _) -> S.singleton x
  | Add(x, y, _) | Sub(x, y, _) | FAdd(x, y, _) | FSub(x, y, _) | FMul(x, y, _) | FDiv(x, y, _) | Get(x, y, _) -> S.of_list [x; y]
  | IfEq(x, y, e1, e2, _)| IfLE(x, y, e1, e2, _) -> S.add x (S.add y (S.union (fv e1) (fv e2)))
  | Let((x, t), e1, e2, _) -> S.union (fv e1) (S.remove x (fv e2))
  | Var(x, _) -> S.singleton x
  | MakeCls((x, t), { entry = l; actual_fv = ys }, e, _) -> S.remove x (S.union (S.of_list ys) (fv e))
  | AppCls(x, ys, _) -> S.of_list (x :: ys)
  | AppDir(_, xs, _) | Tuple(xs, _) -> S.of_list xs
  | LetTuple(xts, y, e, _) -> S.add y (S.diff (fv e) (S.of_list (List.map fst xts)))
  | Put(x, y, z, _) -> S.of_list [x; y; z]

let toplevel : fundef list ref = ref [] (* �ȥåץ�٥�ؿ��ν��� *)

(*
    Ϳ����줿��s��δؿ�����ˤĤ��ơ��ȥåץ�٥�˻��äƤ����ʤ��ʤ���Τϥ������㡼�Ȥ���
    ������Ԥ������κݡ��ؿ�������ѿ��Ȥ��ƻ��Ȥ��줦�뤿�ᡤ�����˥������㡼�Ȥ��Ƥ�Ƚ��Ǥ��ʤ�
    �ؿ�Ŭ�ѤˤĤ��Ƥϡ�known�����õ�����������㡼��Ŭ�Ѥ������Ǥʤ�������̤���

    Args
        env : Id.t * Type.t list
          �ѿ�̾�ȷ��δĶ�
        known : Id.t list
          ��ͳ�ѿ���Ȥ�ʤ��ؿ��ν���
        s : KNormal.t
          ��
    
    Returns
        retval = Closure.t
          �������㡼�ִԸ�μ�
*)
let rec g env known = function (* ���������Ѵ��롼�������� (caml2html: closure_g) *)
(* 
    �Ķ�env�ȼ�ͳ�ѿ����ʤ��Ȥ狼�äƤ���ؿ��ν���known, K��������μ�k�������äƤ���򥯥������Ѵ�����.

    Args
        env : M.t
          ���ߤ��ѿ�̾��,���η��Υޥåԥ�
        known : S.t
          ��ͳ�ѿ�������ʤ����Ȥ��狼�äƤ���ȥåץ�٥�ؿ��ν���

        k : KNormal.t
          �Ѵ�������K��������μ�

    Returns
        retval : Closure.t
          ���������Ѵ���μ�   

*)
  | KNormal.Unit(p) -> Unit(p)
  | KNormal.Int(i, p) -> Int(i, p)
  | KNormal.Float(d, p) -> Float(d, p)
  | KNormal.Neg(x, p) -> Neg(x, p)
  | KNormal.Add(x, y, p) -> Add(x, y, p)
  | KNormal.Sub(x, y, p) -> Sub(x, y, p)
  | KNormal.FNeg(x, p) -> FNeg(x, p)
  | KNormal.FAdd(x, y, p) -> FAdd(x, y, p)
  | KNormal.FSub(x, y, p) -> FSub(x, y, p)
  | KNormal.FMul(x, y, p) -> FMul(x, y, p)
  | KNormal.FDiv(x, y, p) -> FDiv(x, y, p)
  | KNormal.IfEq(x, y, e1, e2, p) -> IfEq(x, y, g env known e1, g env known e2, p)
  | KNormal.IfLE(x, y, e1, e2, p) -> IfLE(x, y, g env known e1, g env known e2, p)
  | KNormal.Let((x, t), e1, e2, p) -> Let((x, t), g env known e1, g (M.add x t env) known e2, p)
  | KNormal.Var(x, p) -> Var(x, p)
  (* | KNormal.LetRec({ KNormal.name = (x, t); KNormal.args = yts; KNormal.body = e1 }, e2, p) as exp -> �ؿ�����ξ�� (caml2html: closure_letrec) 
     ( (* �ؿ����let rec x y1 ... yn = e1 in e2�ξ��ϡ�
         x�˼�ͳ�ѿ����ʤ�(closure��𤵤�direct�˸ƤӽФ���)
         �Ȳ��ꤷ��known���ɲä���e1�򥯥������Ѵ����Ƥߤ� *)
      let toplevel_backup = !toplevel in (* �Хå����å��ѤΤ��λ����ǤΥȥåץ�٥�ؿ��ν��� *)
      let env' = M.add x t env in (* �Ķ�(�ѿ�̾�ȷ��ν���)��(x, t)���ɲ� *)
      let known' = S.add x known in (* ���ä���, x�˼�ͳ�ѿ����ʤ��Ȥ��Ƥߤ� *)
      let e1' = g (M.add_list yts env') known' e1 in (* ������Ķ��˲ä�����Ȥ�, x�˼�ͳ�ѿ����ʤ��Ȥ���, e1�򥯥������Ѵ����Ƥߤ� *)
      (* �����˼�ͳ�ѿ����ʤ��ä������Ѵ����e1'���ǧ���� *)
      (* ���: e1'��x���Ȥ��ѿ��Ȥ��ƽи��������closure��ɬ��!
         (thanks to nuevo-namasute and azounoman; test/cls-bug2.ml����) *)
      let zs = S.diff (fv e1') (S.of_list (List.map fst yts)) in (* �Ѵ����e1'�μ�ͳ�ѿ���, �ؿ��ΰ����κ����� *)
      if S.is_empty zs then  (* zs��������ʤ�, e1�Υ��������Ѵ��Ϥ��ޤ��Ԥä�(=�ؿ���ƤӽФ��Ȥ���AppDir���ɤ�����)�Ȥ������� *)
        let zs = S.elements (S.diff (fv e1') (S.add x (S.of_list (List.map fst yts)))) in (* ���λ�, �ؿ�x�ϼ�ͳ�ѿ�����Ĥ�, e1'�˴ޤޤ�뼫ͳ�ѿ��Ȱ����κ������ȤäƼ�ͳ�ѿ��ν������ *)
        let zts = List.map (fun z -> (z, M.find z env')) zs in (* �����Ǽ�ͳ�ѿ�z�η����������˰���env��ɬ�� *)
        toplevel := { name = (Id.L(x), t); args = yts; formal_fv = zts; body = e1' } :: !toplevel; (* ���ϤȤ⤢��, �ȥåץ�٥�ؿ����ɲ� *)
        let e2' = g env' known' e2 in (* ���δĶ��Τ�Ȥ�, e2�򥯥������Ѵ����� *)
        if S.mem x (fv e2') then (* x���ѿ��Ȥ���e2'�˽и����뤫 *)
          MakeCls((x, t), { entry = Id.L(x); actual_fv = zs }, e2', p) (* �и����Ƥ����饯��������� *)
        else
          (Format.eprintf "eliminating closure(s) %s@." x;
          e2') (* �и����ʤ����MakeCls���� *)
      else ( (* �Ѵ����e1'�˼�ͳ�ѿ����ĤäƤ��ޤä���, lambda-lifting�˥ȥ饤 *)
          Format.eprintf "free variable(s) %s found in function %s@." (Id.pp_list (S.elements zs)) x;
          Format.eprintf "Trying to lambda lifting...\n";
          toplevel := toplevel_backup; (* �ȥåץ�٥�ؿ��ΥХå����åפ�ƤӽФ� *)
          let KNormal.LetRec({ KNormal.name = (xl, tl); KNormal.args = ytsl; KNormal.body = e1l }, e2l, pl) as exp' = Lambda.g (M.bindings env) exp in 
          (* exp��lambda-lifting����, ��ͳ�ѿ���ʤ������Ȥ��� *)
          let e1l' = g (M.add_list ytsl env') known e1l in (* ���٥��������Ѵ����� *)
          let zs = S.diff (fv e1l') (S.of_list (List.map fst ytsl)) in (* ����, �����˼�ͳ�ѿ���̵ͭ��Τ���� *)
          if S.is_empty zs then(* ��ͳ�ѿ����ʤ����, ���������Ѵ����� *)
            (
              Format.eprintf "*****************Lambda-lifting has successfully been done.\n";
              let zs = S.elements (S.diff (fv e1l') (S.add x (S.of_list (List.map fst ytsl)))) in (* ���λ�, �ؿ�x�ϼ�ͳ�ѿ�����Ĥ�, e1'�˴ޤޤ�뼫ͳ�ѿ��Ȱ����κ������ȤäƼ�ͳ�ѿ��ν������ *)
              let zts = List.map (fun z -> (z, M.find z env')) zs in (* �����Ǽ�ͳ�ѿ�z�η����������˰���env��ɬ�� *)
              toplevel := { name = (Id.L(x), t); args = ytsl; formal_fv = zts; body = e1l' } :: !toplevel; (* ���ϤȤ⤢��, �ȥåץ�٥�ؿ����ɲ� *)
              let e2l' = g env' known' e2l in (* ���δĶ��Τ�Ȥ�, e2l�򥯥������Ѵ����� *)
              if S.mem x (fv e2l') then (* x���ѿ��Ȥ���e2l'�˽и�������, ���������Ѵ�����ľ��. *)
                (
                  Format.eprintf "This function %s is used as a variable in the later expression.\n" x;
                  Format.eprintf "function %s cannot be directly applied in fact@.It will be called by using closure.\n" x;
                  toplevel := toplevel_backup;
                  let e1' = g (M.add_list yts env') known e1 in (* ����Ǥ⼫ͳ�ѿ��������, ��ͤ������������Ѵ����� *)
                  let zs = S.elements (S.diff (fv e1') (S.add x (S.of_list (List.map fst yts)))) in (* ���λ�, �ؿ�x�ϼ�ͳ�ѿ�����Ĥ�, e1'�˴ޤޤ�뼫ͳ�ѿ��Ȱ����κ������ȤäƼ�ͳ�ѿ��ν������ *)
                  let zts = List.map (fun z -> (z, M.find z env')) zs in (* �����Ǽ�ͳ�ѿ�z�η����������˰���env��ɬ�� *)
                  toplevel := { name = (Id.L(x), t); args = yts; formal_fv = zts; body = e1' } :: !toplevel; (* ���ϤȤ⤢��, �ȥåץ�٥�ؿ����ɲ� *)
                  let e2' = g env' known e2 in (* ���δĶ��Τ�Ȥ�, e2�򥯥������Ѵ����� *)
                  if S.mem x (fv e2') then (* x���ѿ��Ȥ���e2'�˽и����뤫 *)
                    MakeCls((x, t), { entry = Id.L(x); actual_fv = zs }, e2', p) (* �и����Ƥ����饯��������� *)
                  else
                    (
                      Format.eprintf "eliminating closure(s) %s@." x;
                      e2'
                    ) (* �и����ʤ����MakeCls���� *)
                )
              else
              (
                Format.eprintf "eliminating closure(s) %s@." x;
                e2l'
              ) (* �и����ʤ����MakeCls���� *)
            )
          else
            (
              Format.eprintf "free variable(s) %s still found in function %s@." (Id.pp_list (S.elements zs)) x;
              Format.eprintf "function %s cannot be directly applied in fact@.It will be called by using closure.\n" x;
              toplevel := toplevel_backup;
              let e1' = g (M.add_list yts env') known e1 in (* ����Ǥ⼫ͳ�ѿ��������, ��ͤ������������Ѵ����� *)
              let zs = S.elements (S.diff (fv e1') (S.add x (S.of_list (List.map fst yts)))) in (* ���λ�, �ؿ�x�ϼ�ͳ�ѿ�����Ĥ�, e1'�˴ޤޤ�뼫ͳ�ѿ��Ȱ����κ������ȤäƼ�ͳ�ѿ��ν������ *)
              let zts = List.map (fun z -> (z, M.find z env')) zs in (* �����Ǽ�ͳ�ѿ�z�η����������˰���env��ɬ�� *)
              toplevel := { name = (Id.L(x), t); args = yts; formal_fv = zts; body = e1' } :: !toplevel; (* ���ϤȤ⤢��, �ȥåץ�٥�ؿ����ɲ� *)
              let e2' = g env' known e2 in (* ���δĶ��Τ�Ȥ�, e2�򥯥������Ѵ����� *)
              if S.mem x (fv e2') then (* x���ѿ��Ȥ���e2'�˽и����뤫 *)
                MakeCls((x, t), { entry = Id.L(x); actual_fv = zs }, e2', p) (* �и����Ƥ����饯��������� *)
              else
                (
                  Format.eprintf "eliminating closure(s) %s@." x;
                  e2'
                ) (* �и����ʤ����MakeCls���� *)
            )
          )
    ) *)
    | KNormal.LetRec({ KNormal.name = (x, t); KNormal.args = yts; KNormal.body = e1 }, e2, p) -> (* �ؿ�����ξ�� (caml2html: closure_letrec) *)
      (* �ؿ����let rec x y1 ... yn = e1 in e2�ξ��ϡ�
         x�˼�ͳ�ѿ����ʤ�(closure��𤵤�direct�˸ƤӽФ���)
         �Ȳ��ꤷ��known���ɲä���e1�򥯥������Ѵ����Ƥߤ� *)
      let toplevel_backup = !toplevel in
      let env' = M.add x t env in
      let known' = S.add x known in
      let e1' = g (M.add_list yts env') known' e1 in
      (* �����˼�ͳ�ѿ����ʤ��ä������Ѵ����e1'���ǧ���� *)
      (* ���: e1'��x���Ȥ��ѿ��Ȥ��ƽи��������closure��ɬ��!
         (thanks to nuevo-namasute and azounoman; test/cls-bug2.ml����) *)
      let zs = S.diff (fv e1') (S.of_list (List.map fst yts)) in
      let known', e1' =
        if S.is_empty zs then known', e1' else
        (* ���ܤ��ä������(toplevel����)���ᤷ�ơ����������Ѵ�����ľ�� *)
        (Format.eprintf "free variable(s) %s found in function %s@." (Id.pp_list (S.elements zs)) x;
         Format.eprintf "function %s cannot be directly applied in fact@." x;
         toplevel := toplevel_backup;
         let e1' = g (M.add_list yts env') known e1 in
         known, e1') in
      let zs = S.elements (S.diff (fv e1') (S.add x (S.of_list (List.map fst yts)))) in (* ��ͳ�ѿ��Υꥹ�� *)
      let zts = List.map (fun z -> (z, M.find z env')) zs in (* �����Ǽ�ͳ�ѿ�z�η����������˰���env��ɬ�� *)
      toplevel := { name = (Id.L(x), t); args = yts; formal_fv = zts; body = e1' } :: !toplevel; (* �ȥåץ�٥�ؿ����ɲ� *)
      let e2' = g env' known' e2 in
      if S.mem x (fv e2') then (* x���ѿ��Ȥ���e2'�˽и����뤫 *)
        MakeCls((x, t), { entry = Id.L(x); actual_fv = zs }, e2', p) (* �и����Ƥ����������ʤ� *)
      else
        (Format.eprintf "eliminating closure(s) %s@." x;
         e2') (* �и����ʤ����MakeCls���� *)
  | KNormal.App(x, ys, p) when S.mem x known -> (* �ؿ�Ŭ�Ѥξ�� (caml2html: closure_app) *)
      Format.eprintf "directly applying %s@." x;
      AppDir(Id.L(x), ys, p)
  | KNormal.App(f, xs, p) -> AppCls(f, xs, p)
  | KNormal.Tuple(xs, p) -> Tuple(xs, p)
  | KNormal.LetTuple(xts, y, e, p) -> LetTuple(xts, y, g (M.add_list xts env) known e, p)
  | KNormal.Get(x, y, p) -> Get(x, y, p)
  | KNormal.Put(x, y, z, p) -> Put(x, y, z, p)
  | KNormal.ExtArray(x, p) -> ExtArray(Id.L(x), p)
  | KNormal.ExtFunApp(x, ys, p) -> AppDir(Id.L("min_caml_" ^ x), ys, p)

(*
  �����μ�����ʬ��toplevel�ϴؿ�����ν���
*)
let f e =
(*
  �⥸�塼������ѿ�toplevel����ꥹ�Ȥǽ��������, Closure.g��Ƥ�.
  ���ζ��ꥹ�Ȥϥȥåץ�٥�ؿ���Ͽ����Τ˻Ȥ���.

  Args
    e : KNormal.t
    �Ѵ����μ�(�ץ����)

  Returns
    retval : Closure.plog
      �Ѵ���Υץ����(�ȥåץ�٥�ؿ��Υꥹ�Ȥ��Ѵ���μ�����) 
*)
  toplevel := [];
  let e' = g M.empty S.empty e in
  Prog(List.rev !toplevel, e')

let rec output_closure outchan e depth = 
(* 
    Ϳ����줿��������μ�k�����ͥ�outchan�˽��Ϥ���.

    Args
        outchan : out_channel
          ������Υ����ͥ�
        e : Closure.t
          ���Ϥ��륯�������Ѵ���μ�
        depth : int
          ��ʸ�����ڤο���

    Returns
        retval : unit
          �ʤ�            
*)
  match e with
  | Unit(p) -> 
  (
    Id.output_tab2 outchan (depth + 1) p
  )
  | Int (i, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan ("INT " ^ (string_of_int i))
  )
  | Float (f, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan ("FLOAT " ^ (string_of_float f))
  )
  | Neg (t, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "NEG ";
    Id.output_id outchan t;
  )
  | Add (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "ADD ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | Sub (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "SUB ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FNeg (t, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FNEG ";
    Id.output_id outchan t;
  )
  | FAdd (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FADD ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FSub (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FSUB ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FMul (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FMUL ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FDiv (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FDIV ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | IfEq (t1, t2, t3, t4, p) -> (* ��� + ʬ�� (caml2html: knormal_branch) *)
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "IFEQ ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_closure outchan t3 (depth + 1);
    output_closure outchan t4 (depth + 1);
  )
  | IfLE (t1, t2, t3, t4, p) -> (* ��� + ʬ�� (caml2html: knormal_branch) *)
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "IFLE ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_closure outchan t3 (depth + 1);
    output_closure outchan t4 (depth + 1);
  )
  | Let (t1, t2, t3, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LET ";
    Id.output_id outchan (fst t1);
    output_closure outchan t2 (depth + 1);
    output_closure outchan t3 (depth + 1);
  )
  | Var (x, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "VAR ";
    Id.output_id outchan x;
  )
  | MakeCls ((funname, funtype), funclosure, funbody, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "MAKECLS { funname = ";
    Id.output_id outchan funname;
    output_string outchan " funtype = ";
    Type.output_type outchan funtype;
    Id.output_tab2 outchan (depth + 1) p;
    output_string outchan "funclosure = { ";
    output_funclosure outchan funclosure;
    output_string outchan " }";
    Id.output_tab2 outchan (depth + 1) p;
    output_string outchan "funcbody = { ";
    output_closure outchan funbody (depth + 1);
    output_string outchan " }";
  )
  | AppCls (funname, funargs, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "APPCLS ";
    Id.output_id outchan funname;
    output_string outchan " "; 
    Id.output_id_list outchan funargs;
  )
  | AppDir (funlabel, funargs, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "APPDIR ";
    Id.output_label outchan funlabel;
    output_string outchan " "; 
    Id.output_id_list outchan funargs;
  )
  | Tuple (ts, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "(";
    Id.output_id_list outchan ts;
    output_string outchan ")"
  )
  | LetTuple (t1s, t2, t3, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LET ";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan ")";
    output_string outchan " ";
    Id.output_id outchan t2;
    output_closure outchan t3 (depth + 1);
  )
  | Get (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "GET ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | Put (t1, t2, t3, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "PUT ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_string outchan " ";
    Id.output_id outchan t3;
  )
  | ExtArray (t, p) ->
  (
    Id.output_tab2 outchan depth p;
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

and output_prog outchan (Prog (top, e)) = 
  output_string outchan (" \t");
  output_string outchan "TOPLEVEL";
  output_fundef_list outchan top 1;
  Id.output_tab2 outchan 0 (-1);
  output_string outchan "MAIN";
  output_closure outchan e 1;
  output_string outchan "\n";
