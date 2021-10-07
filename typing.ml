(* type inference/reconstruction *)

open Syntax

exception Unify of Type.t * Type.t * Syntax.position
exception Error of t * Type.t * Type.t * Syntax.position

let extenv = ref M.empty

(* for pretty printing (and type normalization) *)
let rec deref_typ = (* ���ѿ�����ȤǤ���������ؿ� *)
(* 
    Ϳ����줿��t���Ф���, t��˸�������Ƥη��ѿ��򤽤λ�����(���)���֤�������.
    ���ѿ��λ����褬None�ΤȤ�(���ѿ���̤����Ǥ���Ȥ�)�ϻ������Type.Int�ˤ���.

    Args
        t : Type.t
            ��

    Returns
        retval : Type.t
            �Ѵ���η�

*)
    function
  | Type.Fun(t1s, t2) -> Type.Fun(List.map deref_typ t1s, deref_typ t2)
  | Type.Tuple(ts) -> Type.Tuple(List.map deref_typ ts)
  | Type.Array(t) -> Type.Array(deref_typ t)
  | Type.Var({ contents = None } as r) ->
      Format.eprintf "uninstantiated type variable detected; assuming int@.";
      r := Some(Type.Int);
      Type.Int
  | Type.Var({ contents = Some(t) } as r) ->
      let t' = deref_typ t in
      r := Some(t');
      t'
  | t -> t
let rec deref_id_typ (x, t) = 
(* 
    �ѿ�̾x�ȷ�t���Ȥ�����ˤȤ�, x��deref_typ t���Ȥ��֤�.

    Args
        xt : Id.t * Type.t
            �ѿ�̾�ȷ�����

    Returns
        retval : Id.t * Type.t
            �Ѵ�����ѿ�̾�ȷ�����

*)
    (x, deref_typ t)

let rec deref_term = 
(* 
    ��e��˸���뷿���Ф���, ���ѿ��򤽤λ�������֤��������Ѵ���Ƶ�Ū�˹Ԥ�.

    Args
        e : Syntax.t
            ��

    Returns
        retval : Syntax.t
            �Ѵ���μ�

*)
    function
  | Not(e, p) -> Not(deref_term e, p)
  | Neg(e, p) -> Neg(deref_term e, p)
  | Add(e1, e2, p) -> Add(deref_term e1, deref_term e2, p)
  | Sub(e1, e2, p) -> Sub(deref_term e1, deref_term e2, p)
  | Eq(e1, e2, p) -> Eq(deref_term e1, deref_term e2, p)
  | LE(e1, e2, p) -> LE(deref_term e1, deref_term e2, p)
  | FNeg(e, p) -> FNeg(deref_term e, p)
  | FAdd(e1, e2, p) -> FAdd(deref_term e1, deref_term e2, p)
  | FSub(e1, e2, p) -> FSub(deref_term e1, deref_term e2, p)
  | FMul(e1, e2, p) -> FMul(deref_term e1, deref_term e2, p)
  | FDiv(e1, e2, p) -> FDiv(deref_term e1, deref_term e2, p)
  | If(e1, e2, e3, p) -> If(deref_term e1, deref_term e2, deref_term e3, p)
  | Let(xt, e1, e2, p) -> Let(deref_id_typ xt, deref_term e1, deref_term e2, p)
  | LetRec({ name = xt; args = yts; body = e1 }, e2, p) ->
      LetRec({ name = deref_id_typ xt;
               args = List.map deref_id_typ yts;
               body = deref_term e1 },
             deref_term e2, p)
  | App(e, es, p) -> App(deref_term e, List.map deref_term es, p)
  | Tuple(es, p) -> Tuple(List.map deref_term es, p)
  | LetTuple(xts, e1, e2, p) -> LetTuple(List.map deref_id_typ xts, deref_term e1, deref_term e2, p)
  | Array(e1, e2, p) -> Array(deref_term e1, deref_term e2, p)
  | Get(e1, e2, p) -> Get(deref_term e1, deref_term e2, p)
  | Put(e1, e2, e3, p) -> Put(deref_term e1, deref_term e2, deref_term e3, p)
  | e -> e

let rec occur r1 = (* occur check *)
(* 
    Ϳ����줿2�Ĥη�r1, r2���Ф���, ������¾���˴ޤޤ�Ƥ��뤫�ݤ���bool�ͤ��֤�.

    Args
        r1 : Type.t
            ��
        r2 : Type.t
            ��
    Returns
        retval : bool
            r1��r2�˴ޤޤ�Ƥ������ݤ�.

*)
    function 
  | Type.Fun(t2s, t2) -> List.exists (occur r1) t2s || occur r1 t2
  | Type.Tuple(t2s) -> List.exists (occur r1) t2s
  | Type.Array(t2) -> occur r1 t2
  | Type.Var(r2) when r1 == r2 -> true
  | Type.Var({ contents = None }) -> false
  | Type.Var({ contents = Some(t2) }) -> occur r1 t2
  | _ -> false

let rec unify t1 t2 (p:Syntax.position) = (* �����礦�褦�ˡ����ѿ��ؤ������򤹤� *)
(* 
    Ϳ����줿2�Ĥη�t1, t2�����������ɤ���������å����Ƥ���, ������̤����η��ѿ�Type.Var(ref None)�Ǥ��ä���¾�����������ʤ�褦��������Ԥ�.
    ������, ���ΤȤ��˰����η��ѿ���¾���˴ޤޤ�Ƥ��ʤ����Ȥ��ǧ����(occur check).

    Args
        t1 : Type.t
            ��
        e : Type.t
            ��
    Returns
        retval : unit

*)
  match t1, t2 with
  | Type.Unit, Type.Unit | Type.Bool, Type.Bool | Type.Int, Type.Int | Type.Float, Type.Float -> ()
  | Type.Fun(t1s, t1'), Type.Fun(t2s, t2') ->
      (try List.iter2 (let u x y = unify x y p in u) t1s t2s
      with Invalid_argument(_) -> raise (Unify(t1, t2, p)));
      unify t1' t2' p
  | Type.Tuple(t1s), Type.Tuple(t2s) ->
      (try List.iter2 (let u x y = unify x y p in u) t1s t2s
      with Invalid_argument(_) -> raise (Unify(t1, t2, p)))
  | Type.Array(t1), Type.Array(t2) -> unify t1 t2 p
  | Type.Var(r1), Type.Var(r2) when r1 == r2 -> ()
  | Type.Var({ contents = Some(t1') }), _ -> unify t1' t2 p
  | _, Type.Var({ contents = Some(t2') }) -> unify t1 t2' p
  | Type.Var({ contents = None } as r1), _ -> (* ������̤����η��ѿ��ξ�� *)
      if occur r1 t2 then raise (Unify(t1, t2, p));
      r1 := Some(t2)
  | _, Type.Var({ contents = None } as r2) ->
      if occur r2 t1 then raise (Unify(t1, t2, p));
      r2 := Some(t1)
  | _, _ -> raise (Unify(t1, t2, p))

let rec g env e = (* �������롼���� *)
(* 
    ���Ķ�env�β��Ǽ�e�η������������̤��֤�.
    �ޤ�, ����˽ФƤ����ѿ��η������äƤ��뤫�ɤ�����Ĵ�٤�.
    �⤷, ̤����η��ѿ������ä���, Ŭ�ڤʷ�����������.

    Args
        env : (Id.t * Type.t) list
            ���Ķ�
        e : Syntax.t
            ��������������оݤμ�
    Returns
        retval : Type.t
            ���η��ο������
    
*)
  try
    match e with
    | Unit -> Type.Unit
    | Bool(_) -> Type.Bool
    | Int(_) -> Type.Int
    | Float(_) -> Type.Float
    | Not(e, p) ->
        unify Type.Bool (g env e) p;
        Type.Bool
    | Neg(e, p) ->
        unify Type.Int (g env e) p;
        Type.Int
    | Add(e1, e2, p) | Sub(e1, e2, p) -> (* ­�����ʤȰ������ˤη����� *)
        unify Type.Int (g env e1) p;
        unify Type.Int (g env e2) p;
        Type.Int
    | FNeg(e, p) ->
        unify Type.Float (g env e) p;
        Type.Float
    | FAdd(e1, e2, p) | FSub(e1, e2, p) | FMul(e1, e2, p) | FDiv(e1, e2, p) ->
        unify Type.Float (g env e1) p;
        unify Type.Float (g env e2) p;
        Type.Float
    | Eq(e1, e2, p) | LE(e1, e2, p) ->
        unify (g env e1) (g env e2) p;
        Type.Bool
    | If(e1, e2, e3, p) ->
        unify (g env e1) Type.Bool p;
        let t2 = g env e2 in
        let t3 = g env e3 in
        unify t2 t3 p;
        t2
    | Let((x, t), e1, e2, p) -> (* let�η����� *)
        unify t (g env e1) p;
        g (M.add x t env) e2
    | Var(x, _) when M.mem x env -> M.find x env (* �ѿ��η����� *)
    | Var(x, _) when M.mem x !extenv -> M.find x !extenv
    | Var(x, _) -> (* �����ѿ��η����� *)
        Format.eprintf "free variable %s assumed as external@." x;
        let t = Type.gentyp () in
        extenv := M.add x t !extenv;
        t
    | LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) -> (* let rec�η����� *)
        let env = M.add x t env in
        unify t (Type.Fun(List.map snd yts, g (M.add_list yts env) e1)) p;
        g env e2
    | App(e, es, p) -> (* �ؿ�Ŭ�Ѥη����� *)
        let t = Type.gentyp () in
        unify (g env e) (Type.Fun(List.map (g env) es, t)) p;
        t
    | Tuple(es, p) -> Type.Tuple(List.map (g env) es)
    | LetTuple(xts, e1, e2, p) ->
        unify (Type.Tuple(List.map snd xts)) (g env e1) p;
        g (M.add_list xts env) e2
    | Array(e1, e2, p) -> (* must be a primitive for "polymorphic" typing *)
        unify (g env e1) Type.Int p;
        Type.Array(g env e2)
    | Get(e1, e2, p) ->
        let t = Type.gentyp () in
        unify (Type.Array(t)) (g env e1) p;
        unify Type.Int (g env e2) p;
        t
    | Put(e1, e2, e3, p) ->
        let t = g env e3 in
        unify (Type.Array(t)) (g env e1) p;
        unify Type.Int (g env e2) p;
        Type.Unit
  with 
    | Unify(t1, t2, p) -> raise (Error(deref_term e, deref_typ t1, deref_typ t2, p))
    | Error(e, t1, t2, p) -> raise (Error(e, t1, t2, p))

let f e =
  extenv := M.empty;
(*
  (match deref_typ (g M.empty e) with
  | Type.Unit -> ()
  | _ -> Format.eprintf "warning: final result does not have type unit@.");
*)
  (try unify Type.Unit (g M.empty e) top_position
  with 
    | Unify _ -> failwith "top level does not have type unit";
    | Error (e, t1, t2, p) -> failwith (Printf.sprintf "type error in line%d-%d" (fst p) (snd p)));
  extenv := M.map deref_typ !extenv;
  deref_term e
