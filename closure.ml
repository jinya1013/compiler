type closure = { entry : Id.l; actual_fv : Id.t list }
type t = (* ���������Ѵ���μ� (caml2html: closure_t) *)
  | Unit of Syntax.position
  | Int of int * Syntax.position
  | Float of float * Syntax.position
  | Neg of Id.t * Syntax.position
  | Add of Id.t * Id.t * Syntax.position
  | Sub of Id.t * Id.t * Syntax.position
  | FNeg of Id.t * Syntax.position
  | FAdd of Id.t * Id.t * Syntax.position
  | FSub of Id.t * Id.t * Syntax.position
  | FMul of Id.t * Id.t * Syntax.position
  | FDiv of Id.t * Id.t * Syntax.position
  | IfEq of Id.t * Id.t * t * t * Syntax.position
  | IfLE of Id.t * Id.t * t * t * Syntax.position
  | Let of (Id.t * Type.t) * t * t * Syntax.position
  | Var of Id.t * Syntax.position
  | MakeCls of (Id.t * Type.t) * closure * t * Syntax.position
  | AppCls of Id.t * Id.t list * Syntax.position
  | AppDir of Id.l * Id.t list * Syntax.position
  | Tuple of Id.t list * Syntax.position
  | LetTuple of (Id.t * Type.t) list * Id.t * t * Syntax.position
  | Get of Id.t * Id.t * Syntax.position
  | Put of Id.t * Id.t * Id.t * Syntax.position
  | ExtArray of Id.l * Syntax.position
type fundef = { name : Id.l * Type.t;
                args : (Id.t * Type.t) list;
                formal_fv : (Id.t * Type.t) list;
                body : t }
type prog = Prog of fundef list * t

let rec fv = function
  | Unit(p) | Int(_, p) | Float(_, p) | ExtArray(_, p) -> S.empty
  | Neg(x, p) | FNeg(x, p) -> S.singleton x
  | Add(x, y, p) | Sub(x, y, p) | FAdd(x, y, p) | FSub(x, y, p) | FMul(x, y, p) | FDiv(x, y, p) | Get(x, y, p) -> S.of_list [x; y]
  | IfEq(x, y, e1, e2, p)| IfLE(x, y, e1, e2, p) -> S.add x (S.add y (S.union (fv e1) (fv e2)))
  | Let((x, t), e1, e2, p) -> S.union (fv e1) (S.remove x (fv e2))
  | Var(x, p) -> S.singleton x
  | MakeCls((x, t), { entry = l; actual_fv = ys }, e, p) -> S.remove x (S.union (S.of_list ys) (fv e))
  | AppCls(x, ys, p) -> S.of_list (x :: ys)
  | AppDir(_, xs, p) | Tuple(xs, p) -> S.of_list xs
  | LetTuple(xts, y, e, p) -> S.add y (S.diff (fv e) (S.of_list (List.map fst xts)))
  | Put(x, y, z, p) -> S.of_list [x; y; z]

let toplevel : fundef list ref = ref []

let rec g env known = function (* ���������Ѵ��롼�������� (caml2html: closure_g) *)
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

let f e =
  toplevel := [];
  let e' = g M.empty S.empty e in
  Prog(List.rev !toplevel, e')
