type closure = { entry : Id.l; actual_fv : Id.t list } (* �ȥåץ�٥�ؿ��Υ�٥�, ��ͳ�ѿ��Υꥹ�� *)
type t = (* ���������Ѵ���μ� (caml2html: closure_t) *)
  | Unit
  | Int of int
  | Float of float
  | Neg of Id.t
  | Add of Id.t * Id.t
  | Sub of Id.t * Id.t
  | FNeg of Id.t
  | FAdd of Id.t * Id.t
  | FSub of Id.t * Id.t
  | FMul of Id.t * Id.t
  | FDiv of Id.t * Id.t
  | IfEq of Id.t * Id.t * t * t
  | IfLE of Id.t * Id.t * t * t
  | Let of (Id.t * Type.t) * t * t
  | Var of Id.t
  | MakeCls of (Id.t * Type.t) * closure * t  (*(�ؿ�̾, �ؿ��η�), ��������, �ؿ������� *)
  | AppCls of Id.t * Id.t list
  | AppDir of Id.l * Id.t list
  | Tuple of Id.t list
  | LetTuple of (Id.t * Type.t) list * Id.t * t
  | Get of Id.t * Id.t
  | Put of Id.t * Id.t * Id.t
  | ExtArray of Id.l
type fundef = { name : Id.l * Type.t;
                args : (Id.t * Type.t) list;
                formal_fv : (Id.t * Type.t) list;
                body : t }
type prog = Prog of fundef list * t

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
  | Unit | Int(_) | Float(_) | ExtArray(_) -> S.empty
  | Neg(x) | FNeg(x) -> S.singleton x
  | Add(x, y) | Sub(x, y) | FAdd(x, y) | FSub(x, y) | FMul(x, y) | FDiv(x, y) | Get(x, y) -> S.of_list [x; y]
  | IfEq(x, y, e1, e2)| IfLE(x, y, e1, e2) -> S.add x (S.add y (S.union (fv e1) (fv e2)))
  | Let((x, t), e1, e2) -> S.union (fv e1) (S.remove x (fv e2))
  | Var(x) -> S.singleton x
  | MakeCls((x, t), { entry = l; actual_fv = ys }, e) -> S.remove x (S.union (S.of_list ys) (fv e))
  | AppCls(x, ys) -> S.of_list (x :: ys)
  | AppDir(_, xs) | Tuple(xs) -> S.of_list xs
  | LetTuple(xts, y, e) -> S.add y (S.diff (fv e) (S.of_list (List.map fst xts)))
  | Put(x, y, z) -> S.of_list [x; y; z]

let toplevel : fundef list ref = ref []

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
  | KNormal.Unit -> Unit
  | KNormal.Int(i) -> Int(i)
  | KNormal.Float(d) -> Float(d)
  | KNormal.Neg(x) -> Neg(x)
  | KNormal.Add(x, y) -> Add(x, y)
  | KNormal.Sub(x, y) -> Sub(x, y)
  | KNormal.FNeg(x) -> FNeg(x)
  | KNormal.FAdd(x, y) -> FAdd(x, y)
  | KNormal.FSub(x, y) -> FSub(x, y)
  | KNormal.FMul(x, y) -> FMul(x, y)
  | KNormal.FDiv(x, y) -> FDiv(x, y)
  | KNormal.IfEq(x, y, e1, e2) -> IfEq(x, y, g env known e1, g env known e2)
  | KNormal.IfLE(x, y, e1, e2) -> IfLE(x, y, g env known e1, g env known e2)
  | KNormal.Let((x, t), e1, e2) -> Let((x, t), g env known e1, g (M.add x t env) known e2)
  | KNormal.Var(x) -> Var(x)
  | KNormal.LetRec({ KNormal.name = (x, t); KNormal.args = yts; KNormal.body = e1 }, e2) -> (* �ؿ�����ξ�� (caml2html: closure_letrec) *)
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
        (* e1�˼�ͳ�ѿ����ޤޤ��ʤ����(toplevel����)���ᤷ�ơ����������Ѵ�����ľ�� *)
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
        MakeCls((x, t), { entry = Id.L(x); actual_fv = zs }, e2') (* �и����Ƥ����������ʤ� *)
      else
        (Format.eprintf "eliminating closure(s) %s@." x;
         e2') (* �и����ʤ����MakeCls���� *)
  | KNormal.App(x, ys) when S.mem x known -> (* �ؿ�Ŭ�Ѥξ�� (caml2html: closure_app) *)
      Format.eprintf "directly applying %s@." x;
      AppDir(Id.L(x), ys)
  | KNormal.App(f, xs) -> AppCls(f, xs)
  | KNormal.Tuple(xs) -> Tuple(xs)
  | KNormal.LetTuple(xts, y, e) -> LetTuple(xts, y, g (M.add_list xts env) known e)
  | KNormal.Get(x, y) -> Get(x, y)
  | KNormal.Put(x, y, z) -> Put(x, y, z)
  | KNormal.ExtArray(x) -> ExtArray(Id.L(x))
  | KNormal.ExtFunApp(x, ys) -> AppDir(Id.L("min_caml_" ^ x), ys)

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
  | Unit -> ()
  | Int i -> 
  (
    Id.output_tab outchan depth;
    output_string outchan ("INT " ^ (string_of_int i))
  )
  | Float f -> 
  (
    Id.output_tab outchan depth;
    output_string outchan ("FLOAT " ^ (string_of_float f))
  )
  | Neg t ->
  (
    Id.output_tab outchan depth;
    output_string outchan "NEG ";
    Id.output_id outchan t;
  )
  | Add (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "ADD ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | Sub (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "SUB ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FNeg (t) -> 
  (
    Id.output_tab outchan depth;
    output_string outchan "FNEG ";
    Id.output_id outchan t;
  )
  | FAdd (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FADD ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FSub (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FSUB ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FMul (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FMUL ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | FDiv (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FDIV ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | IfEq (t1, t2, t3, t4) -> (* ��� + ʬ�� (caml2html: knormal_branch) *)
  (
    Id.output_tab outchan depth;
    output_string outchan "IFEQ ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_closure outchan t3 (depth + 1);
    output_closure outchan t4 (depth + 1);
  )
  | IfLE (t1, t2, t3, t4) -> (* ��� + ʬ�� (caml2html: knormal_branch) *)
  (
    Id.output_tab outchan depth;
    output_string outchan "IFLE ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_closure outchan t3 (depth + 1);
    output_closure outchan t4 (depth + 1);
  )
  | Let (t1, t2, t3) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "LET ";
    Id.output_id outchan (fst t1);
    output_closure outchan t2 (depth + 1);
    output_closure outchan t3 (depth + 1);
  )
  | Var (x) -> 
  (
    Id.output_tab outchan depth;
    output_string outchan "VAR ";
    Id.output_id outchan x;
  )
  | MakeCls ((funname, funtype), funclosure, funbody) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "MAKECLS { funname = ";
    Id.output_id outchan funname;
    output_string outchan " funtype = ";
    Type.output_type outchan funtype;
    Id.output_tab outchan (depth + 1);
    output_string outchan "funclosure = { ";
    output_funclosure outchan funclosure;
    output_string outchan " }";
    Id.output_tab outchan (depth + 1);
    output_string outchan "funcbody = { ";
    output_closure outchan funbody (depth + 1);
    output_string outchan " }";
  )
  | AppCls (funname, funargs) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "APPCLS ";
    Id.output_id outchan funname;
    output_string outchan " "; 
    Id.output_id_list outchan funargs;
  )
  | AppDir (funlabel, funargs) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "APPDIR ";
    Id.output_label outchan funlabel;
    output_string outchan " "; 
    Id.output_id_list outchan funargs;
  )
  | Tuple (ts) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "(";
    Id.output_id_list outchan ts;
    output_string outchan ")"
  )
  | LetTuple (t1s, t2, t3) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "LET ";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan ")";
    output_string outchan " ";
    Id.output_id outchan t2;
    output_closure outchan t3 (depth + 1);
  )
  | Get (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "GET ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
  )
  | Put (t1, t2, t3) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "PUT ";
    Id.output_id outchan t1;
    output_string outchan " ";
    Id.output_id outchan t2;
    output_string outchan " ";
    Id.output_id outchan t3;
  )
  | ExtArray (t) ->
  (
    Id.output_tab outchan depth;
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

and output_prog outchan (Prog (top, e)) depth = 
  output_string outchan "TOPLEVEL";
  output_fundef_list outchan top (depth + 1);
  Id.output_tab outchan depth;
  output_string outchan "MAIN";
  output_closure outchan e (depth + 1)