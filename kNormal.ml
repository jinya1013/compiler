(* give names to intermediate values (K-normalization) *)

type t = (* K��������μ� (caml2html: knormal_t) *)
  | Unit
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
  | IfEq of Id.t * Id.t * t * t * Syntax.position (* ��� + ʬ�� (caml2html: knormal_branch) *)
  | IfLE of Id.t * Id.t * t * t * Syntax.position (* ��� + ʬ�� *)
  | Let of (Id.t * Type.t) * t * t * Syntax.position
  | Var of Id.t * Syntax.position
  | LetRec of fundef * t * Syntax.position
  | App of Id.t * Id.t list * Syntax.position
  | Tuple of Id.t list * Syntax.position
  | LetTuple of (Id.t * Type.t) list * Id.t * t * Syntax.position
  | Get of Id.t * Id.t * Syntax.position
  | Put of Id.t * Id.t * Id.t * Syntax.position
  | ExtArray of Id.t * Syntax.position
  | ExtFunApp of Id.t * Id.t list * Syntax.position
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }

let rec fv = function (* ���˽и�����ʼ�ͳ�ʡ��ѿ� (caml2html: knormal_fv) *)
  | Unit | Int(_) | Float(_) | ExtArray(_) -> S.empty
  | Neg(x) | FNeg(x) -> S.singleton x
  | Add(x, y) | Sub(x, y) | FAdd(x, y) | FSub(x, y) | FMul(x, y) | FDiv(x, y) | Get(x, y) -> S.of_list [x; y]
  | IfEq(x, y, e1, e2) | IfLE(x, y, e1, e2) -> S.add x (S.add y (S.union (fv e1) (fv e2)))
  | Let((x, t), e1, e2) -> S.union (fv e1) (S.remove x (fv e2))
  | Var(x) -> S.singleton x
  | LetRec({ name = (x, t); args = yts; body = e1 }, e2) ->
      let zs = S.diff (fv e1) (S.of_list (List.map fst yts)) in
      S.diff (S.union zs (fv e2)) (S.singleton x)
  | App(x, ys) -> S.of_list (x :: ys)
  | Tuple(xs) | ExtFunApp(_, xs) -> S.of_list xs
  | Put(x, y, z) -> S.of_list [x; y; z]
  | LetTuple(xs, y, e) -> S.add y (S.diff (fv e) (S.of_list (List.map fst xs)))

let insert_let (e, t) k = (* let��������������ؿ� (caml2html: knormal_insert) *)
  match e with
  | Var(x) -> k x
  | _ ->
      let x = Id.gentmp t in
      let e', t' = k x in
      Let((x, t), e, e'), t'

let rec g env = function (* K�������롼�������� (caml2html: knormal_g) *)
  | Syntax.Unit -> Unit, Type.Unit
  | Syntax.Bool(b, p) -> Int(if b then 1 else 0, p), Type.Int (* ������true, false������1, 0���Ѵ� (caml2html: knormal_bool) *)
  | Syntax.Int(i, p) -> Int(i, p), Type.Int
  | Syntax.Float(d, p) -> Float(d, p), Type.Float
  | Syntax.Not(e, p) -> g env (Syntax.If(e, Syntax.Bool(false, p), Syntax.Bool(true, p), p))
  | Syntax.Neg(e, p) ->
      insert_let (g env e)
        (fun x -> Neg(x, p), Type.Int)
  | Syntax.Add(e1, e2, p) -> (* ­������K������ (caml2html: knormal_add) *)
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> Add(x, y, p), Type.Int))
  | Syntax.Sub(e1, e2, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> Sub(x, y, p), Type.Int))
  | Syntax.FNeg(e, p) ->
      insert_let (g env e)
        (fun x -> FNeg(x, p), Type.Float)
  | Syntax.FAdd(e1, e2, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> FAdd(x, y, p), Type.Float))
  | Syntax.FSub(e1, e2, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> FSub(x, y, p), Type.Float))
  | Syntax.FMul(e1, e2, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> FMul(x, y. p), Type.Float))
  | Syntax.FDiv(e1, e2, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> FDiv(x, y, p), Type.Float))
  | Syntax.Eq (_, _, p) | Syntax.LE (_, _, p) as cmp ->
      g env (Syntax.If(cmp, Syntax.Bool(true, p), Syntax.Bool(false, p), p))
  | Syntax.If(Syntax.Not(e1, _), e2, e3, p2) -> g env (Syntax.If(e1, e3, e2, p2)) (* not�ˤ��ʬ�����Ѵ� (caml2html: knormal_not) *)
  | Syntax.If(Syntax.Eq(e1, e2, _), e3, e4, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y ->
              let e3', t3 = g env e3 in
              let e4', t4 = g env e4 in
              IfEq(x, y, e3', e4'), t3, p))
  | Syntax.If(Syntax.LE(e1, e2, _), e3, e4, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y ->
              let e3', t3 = g env e3 in
              let e4', t4 = g env e4 in
              IfLE(x, y, e3', e4', p), t3))
  | Syntax.If(e1, e2, e3, p) -> g env (Syntax.If(Syntax.Eq(e1, Syntax.Bool(false, p), p), e3, e2, p)) (* ��ӤΤʤ�ʬ�����Ѵ� (caml2html: knormal_if) *)
  | Syntax.Let((x, t), e1, e2, p) ->
      let e1', t1 = g env e1 in
      let e2', t2 = g (M.add x t env) e2 in
      Let((x, t), e1', e2'), t2
  | Syntax.Var(x, p) when M.mem x env -> Var(x, p), M.find x env
  | Syntax.Var(x, p) -> (* ��������λ��� (caml2html: knormal_extarray) *)
      (match M.find x !Typing.extenv with
      | Type.Array(_) as t -> ExtArray x, t
      | _ -> failwith (Printf.sprintf "external variable %s does not have an array type" x))
  | Syntax.LetRec({ Syntax.name = (x, t); Syntax.args = yts; Syntax.body = e1 }, e2) ->
      let env' = M.add x t env in
      let e2', t2 = g env' e2 in
      let e1', t1 = g (M.add_list yts env') e1 in
      LetRec({ name = (x, t); args = yts; body = e1' }, e2'), t2
  | Syntax.App(Syntax.Var(f, p), e2s, p) when not (M.mem f env) -> (* �����ؿ��θƤӽФ� (caml2html: knormal_extfunapp) *)
      (match M.find f !Typing.extenv with
      | Type.Fun(_, t) ->
          let rec bind xs = function (* "xs" are identifiers for the arguments *)
            | [] -> ExtFunApp(f, xs, p), t
            | e2 :: e2s ->
                insert_let (g env e2)
                  (fun x -> bind (xs @ [x]) e2s) in
          bind [] e2s (* left-to-right evaluation *)
      | _ -> assert false)
  | Syntax.App(e1, e2s, p) ->
      (match g env e1 with
      | _, Type.Fun(_, t) as g_e1 ->
          insert_let g_e1
            (fun f ->
              let rec bind xs = function (* "xs" are identifiers for the arguments *)
                | [] -> App(f, xs, p), t
                | e2 :: e2s ->
                    insert_let (g env e2)
                      (fun x -> bind (xs @ [x]) e2s) in
              bind [] e2s) (* left-to-right evaluation *)
      | _ -> assert false)
  | Syntax.Tuple(es, p) ->
      let rec bind xs ts = function (* "xs" and "ts" are identifiers and types for the elements *)
        | [] -> Tuple(xs), Type.Tuple(ts)
        | e :: es ->
            let _, t as g_e = g env e in
            insert_let g_e
              (fun x -> bind (xs @ [x]) (ts @ [t]) es) in
      bind [] [] es
  | Syntax.LetTuple(xts, e1, e2, p) ->
      insert_let (g env e1)
        (fun y ->
          let e2', t2 = g (M.add_list xts env) e2 in
          LetTuple(xts, y, e2', p), t2)
  | Syntax.Array(e1, e2, p) ->
      insert_let (g env e1)
        (fun x ->
          let _, t2 as g_e2 = g env e2 in
          insert_let g_e2
            (fun y ->
              let l =
                match t2 with
                | Type.Float -> "create_float_array"
                | _ -> "create_array" in
              ExtFunApp(l, [x; y], p), Type.Array(t2)))
  | Syntax.Get(e1, e2, p) ->
      (match g env e1 with
      |        _, Type.Array(t) as g_e1 ->
          insert_let g_e1
            (fun x -> insert_let (g env e2)
                (fun y -> Get(x, y, p), t))
      | _ -> assert false)
  | Syntax.Put(e1, e2, e3, p) ->
      insert_let (g env e1)
        (fun x -> insert_let (g env e2)
            (fun y -> insert_let (g env e3)
                (fun z -> Put(x, y, z, p), Type.Unit)))

let f e = fst (g M.empty e)
