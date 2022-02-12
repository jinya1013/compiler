(* translation into SPARC assembly with infinite number of virtual registers *)
open Asm

let data = ref [] (* ��ư��������������ơ��֥� (caml2html: virtual_data) *)

let classify xts ini addf addi =
  List.fold_left
    (fun acc (x, t) ->
      match t with
      | Type.Unit -> acc (* Unit���ξ��ϲ��⤷�ʤ� *)
      | Type.Float -> addf acc x
      | _ -> addi acc x t)
    ini
    xts

let separate xts =
  classify
    xts
    ([], [])
    (fun (int, float) x -> (int, float @ [x]))
    (fun (int, float) x _ -> (int @ [x], float))

let expand xts ini addf addi =
  classify
    xts
    ini
    (fun (offset, acc) x ->
      (* let offset = align offset in *)
      (offset + 4, addf x offset acc)) (* mincaml�ξ�����ñ���٤ǽ�ʬ *)
    (fun (offset, acc) x t ->
      (offset + 4, addi x t offset acc))

let counter = ref (-4)
let gen_offset_ft () = 
  counter := !counter + 4;
  !counter

let rec g env e =  (* ���β��ۥޥ��󥳡������� (caml2html: virtual_g) *)

  match e with
  | Closure.Unit(p) -> Ans(Nop, p)
  | Closure.Int(i, p) -> Ans(Set(i), p)
  | Closure.Float(d, p) ->
      let l =
        try
          (* ���Ǥ�����ơ��֥�ˤ��ä�������� *)
          let (l, _) = List.find (fun (_, d') -> d = d') !data in
          l
        with Not_found ->
          let l = gen_offset_ft () in
          data := (l, d) :: !data; (* ��������ư�����Υ�٥���������Ƽ�����ɲ� *)
          l in
      (* let x = Id.genid "l" in
      Let((x, Type.Int), SetL(l), Ans(Ld(x, 0), p), p) *)
      Ans(LdDF(reg_ftp, l), p)
  | Closure.Neg(x, p) -> Ans(Neg(x), p)
  | Closure.Add(x, y, p) -> Ans(Add(x, V(y)), p)
  | Closure.Sub(x, y, p) -> Ans(Sub(x, V(y)), p)
  | Closure.FNeg(x, p) -> Ans(FNegD(x), p)
  | Closure.FSqrt(x, p) -> Ans(FSqrtD(x), p)
  | Closure.Floor(x, p) -> Ans(FloorD(x), p)
  | Closure.FAdd(x, y, p) -> Ans(FAddD(x, y), p)
  | Closure.FSub(x, y, p) -> Ans(FSubD(x, y), p)
  | Closure.FMul(x, y, p) -> Ans(FMulD(x, y), p)
  | Closure.FDiv(x, y, p) -> Ans(FDivD(x, y), p)
  | Closure.IfEq(x, y, e1, e2, p) ->
      (match M.find x env with
      | Type.Bool | Type.Int -> Ans(IfEq(x, V(y), g env e1, g env e2), p)
      | Type.Float -> Ans(IfFEq(x, y, g env e1, g env e2), p)
      | _ -> failwith "equality supported only for bool, int, and float")
  | Closure.IfLE(x, y, e1, e2, p) ->
      (match M.find x env with
      | Type.Bool | Type.Int -> Ans(IfLE(x, V(y), g env e1, g env e2), p)
      | Type.Float -> Ans(IfFLE(x, y, g env e1, g env e2), p)
      | _ -> failwith "inequality supported only for bool, int, and float")
  | Closure.Let((x, t1), e1, e2, p) ->
      let e1' = g env e1 in
      let e2' = g (M.add x t1 env) e2 in
      concat e1' (x, t1) e2'
  | Closure.Var(x, p) ->
      (match M.find x env with
      | Type.Unit -> Ans(Nop, p)
      | Type.Float -> Ans(FMovD(x), p)
      | _ -> Ans(Mov(x), p)) (* ¿ʬType.Int��Type.Bool *)
  | Closure.MakeCls((x, t), { Closure.entry = l; Closure.actual_fv = ys }, e2, p) -> (* ��ͳ�ѿ�����Ĵؿ�x�Υ������������ *)
      (* Closure�Υ��ɥ쥹�򥻥åȤ��Ƥ��顢��ͳ�ѿ����ͤ򥹥ȥ� *)
      let e2' = g (M.add x t env) e2 in
      let offset, store_fv =
        expand
          (List.map (fun y -> (y, M.find y env)) ys)
          (4, e2')
          (fun y offset store_fv -> seq(StDF(y, x, offset), store_fv, p))
          (fun y _ offset store_fv -> seq(St(y, x, offset), store_fv, p)) in
      (* let seq(e1, e2, p) = Let((Id.gentmp Type.Unit, Type.Unit), e1, e2, p) *)
      Let((x, t), Mov(reg_hp), (* �ҡ��ץݥ��󥿤�x�ˤ���� *)
          Let((reg_hp, Type.Int), Add(reg_hp, C(offset)), (* �ҡ��ץݥ��󥿤����ѿ��ο������û����� *)
              (let z = Id.genid "l" in
              Let((z, Type.Int), SetL(l), (* �ѿ�z�˥�٥�l��̿�ᥢ�ɥ쥹������� *)
                  (seq (St(z, x, 0), store_fv, p)), p)), p), p) (* z(��٥�l��̿�ᥢ�ɥ쥹)��ҡ��ץݥ��󥿤���Ƭ�������,����ʹߤ˼�ͳ�ѿ��⤤��� *)
                  (* ��̤Ȥ���, �ѿ�x�ˤ�, �����������Ƭ�Υ��ɥ쥹�����äƤ��� *)
  | Closure.AppCls(x, ys, p) -> (* �ؿ�x�򥯥������ͳ�ǸƤӽФ���, ����ys��Ŭ�Ѥ��� *)
      let args = List.map (fun y -> (y, M.find y env)) ys in
      Ans(CallCls(x, args), p)
  | Closure.AppDir(Id.L(x), ys, p) ->
      let args = List.map (fun y -> (y, M.find y env)) ys in
      Ans(CallDir(Id.L(x), args), p)
  | Closure.Tuple(xs, p) -> (* �Ȥ����� (caml2html: virtual_tuple) *)
      let y = Id.genid "t" in
      let (offset, store) =
        expand
          (List.map (fun x -> (x, M.find x env)) xs)
          (0, Ans(Mov(y), p))
          (fun x offset store -> seq(StDF(x, y, offset), store, p))
          (fun x _ offset store -> seq(St(x, y, offset), store, p)) in
      Let((y, Type.Tuple(List.map (fun x -> M.find x env) xs)), Mov(reg_hp),
          Let((reg_hp, Type.Int), Add(reg_hp, C(offset)),
              store, p), p)
  | Closure.LetTuple(xts, y, e2, p) ->
      let s = Closure.fv e2 in
      let (offset, load) =
        expand
          xts
          (0, g (M.add_list xts env) e2)
          (fun x offset load ->
            if not (S.mem x s) then load else (* [XX] a little ad hoc optimization *)
            fletd(x, LdDF(y, offset), load, p))
          (fun x t offset load ->
            if not (S.mem x s) then load else (* [XX] a little ad hoc optimization *)
            Let((x, t), Ld(y, offset), load, p)) in
      load
  | Closure.Get(x, y, p) -> (* ������ɤ߽Ф� (caml2html: virtual_get) *)
      let offset = Id.genid "o" in
      let tmp = Id.genid "tmp" in
      (match M.find x env with
      | Type.Array(Type.Unit) -> Ans(Nop, p)
      | Type.Array(Type.Float) ->
            Let((tmp, Type.Int), SLL(y, reg2),
              Let((offset, Type.Int), Add(x, V(tmp)), (* offset = y * 4 �Ȥ��� *)
                Ans(LdDF(offset, 0), p), p), p)
      | Type.Array(_) ->
            Let((tmp, Type.Int), SLL(y, reg2),
              Let((offset, Type.Int), Add(x, V(tmp)), (* offset = y * 4 �Ȥ��� *)
                Ans(Ld(offset, 0), p), p), p)
      | _ -> assert false)
  | Closure.Put(x, y, z, p) -> (* ����x��y���ܤ�z���ѹ����� *)
      let offset = Id.genid "o" in
      let tmp = Id.genid "tmp" in
      (match M.find x env with
      | Type.Array(Type.Unit) -> Ans(Nop, p)
      | Type.Array(Type.Float) ->
            Let((tmp, Type.Int), SLL(y, reg2),
              Let((offset, Type.Int), Add(x, V(tmp)), (* offset = y * 4 �Ȥ��� *)
                Ans(StDF(z, offset, 0), p), p), p)
      | Type.Array(_) ->
            Let((tmp, Type.Int), SLL(y, reg2),
              Let((offset, Type.Int), Add(x, V(tmp)), (* offset = y * 4 �Ȥ��� *)
                Ans(St(z, offset, 0), p), p), p)
      | _ -> assert false)
  | Closure.ExtArray(Id.L(x), p) -> Ans(SetL(Id.L("min_caml_" ^ x)), p)

(* �ؿ��β��ۥޥ��󥳡������� (caml2html: virtual_h) *)
let h { Closure.name = (Id.L(x), t); Closure.args = yts; Closure.formal_fv = zts; Closure.body = e } =
  let p = Closure.pos_of_t e in (* �ؿ��Υܥǥ���ʬ�������Υ����ɤΤɤ���ʬ���б����뤫 *)

  (* �������㤫��ؿ�̾�����, ��ͳ�ѿ���쥸�����˰ܤ�. *)
  let (offset, load) =
    expand
      zts (* ����������μ�ͳ�ѿ��ν����, (�ѿ�̾, ��)�Υꥹ�Ȥ��Ф��� *)
      (4, g (M.add x t (M.add_list yts (M.add_list zts !(GlobalVar.gtenv)))) e) (* (4, [(x, t);(y1, t1); ...;(yn, tn);(z1, t1); ...(zn, tn)]) *)
      (fun z offset load -> fletd(z, LdDF(x, offset), load, p))
      (* -> Let((z, Type.Float), LdDF(x, C(offset)), load, p) *)
      (fun z t offset load -> Let((z, t), Ld(x, offset), load, p)) in
  match t with
  | Type.Fun(_, t2) ->
      { name = Id.L(x); args = yts; body = load; ret = t2 }
  | _ -> assert false

(* �ץ�������Τβ��ۥޥ��󥳡������� (caml2html: virtual_f) *)
let f (Closure.Prog(fundefs, e)) =
  print_string "starting to virtualize the code...\n";
  data := [];
  let fundefs = List.map h fundefs in (* fundef���Ѵ� *)
  let e = g M.empty e in (* �������Τ��Ѵ� *)
  Prog(!data, fundefs, e)
