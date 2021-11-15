(* type inference/reconstruction *)

open Syntax

exception Unify of Type.t * Type.t * Syntax.pos
exception Error of t * Type.t * Type.t * Syntax.pos

exception AppError
exception UncurryError
exception UndefinedVarError

let extenv = ref M.empty

(* �Ķ�����Ϥ���ؿ�, �ǥХå��� *)
let output_env outchan m = 
    match M.bindings m with
    | (x, t) :: xts ->
    (
        output_string outchan "(";
        Id.output_id outchan x;
        output_string outchan ", ";
        Type.output_type outchan t;
        output_string outchan ")";

        List.iter (fun (x, t) -> 
        output_string outchan ", ";
        output_string outchan "(";
        Id.output_id outchan x;
        output_string outchan ", ";
        Type.output_type outchan t;
        output_string outchan ")") xts
    )
    | _ -> ()

(* FunCurry��Fun��ľ��(uncurry����)�ؿ�, n��FunCurry�Υ�٥� *)
let rec uncurry n = function
| Type.FunCurry(t1, t2, n) -> 
    uncurry n (Type.Fun([t1], t2))
| Type.Fun(t1s, Type.FunCurry(t1', t2', m)) when n = m -> uncurry n (Type.Fun(t1s @ [uncurry_typ t1'], t2'))
| Type.Fun(t1s, Type.FunCurry(t1', t2', m)) -> Type.Fun(t1s, (uncurry m (Type.FunCurry(t1', t2', m))))
| Type.Fun(t1s, t2) as e -> e
| _ -> raise UncurryError

and uncurry_typ = 
    function
  | Type.FunCurry(t1, t2, n) as e-> uncurry n e
  | Type.Tuple(ts) -> Type.Tuple(List.map uncurry_typ ts)
  | Type.Array(t) -> Type.Array(uncurry_typ t)
  | t -> t

let rec uncurry_id_typ (x, t) = 
    (x, uncurry_typ t)

let rec uncurry_term = 
    function
  | Not(e, p) -> Not(uncurry_term e, p)
  | Neg(e, p) -> Neg(uncurry_term e, p)
  | Add(e1, e2, p) -> Add(uncurry_term e1, uncurry_term e2, p)
  | Sub(e1, e2, p) -> Sub(uncurry_term e1, uncurry_term e2, p)
  | Eq(e1, e2, p) -> Eq(uncurry_term e1, uncurry_term e2, p)
  | LE(e1, e2, p) -> LE(uncurry_term e1, uncurry_term e2, p)
  | FNeg(e, p) -> FNeg(uncurry_term e, p)
  | FAdd(e1, e2, p) -> FAdd(uncurry_term e1, uncurry_term e2, p)
  | FSub(e1, e2, p) -> FSub(uncurry_term e1, uncurry_term e2, p)
  | FMul(e1, e2, p) -> FMul(uncurry_term e1, uncurry_term e2, p)
  | FDiv(e1, e2, p) -> FDiv(uncurry_term e1, uncurry_term e2, p)
  | If(e1, e2, e3, p) -> If(uncurry_term e1, uncurry_term e2, uncurry_term e3, p)
  | Let(xt, e1, e2, p) -> Let(uncurry_id_typ xt, uncurry_term e1, uncurry_term e2, p)
  | LetRec({ name = xt; args = yts; body = e1 }, e2, p) ->
      LetRec({ name = uncurry_id_typ xt;
               args = List.map uncurry_id_typ yts;
               body = uncurry_term e1 },
             uncurry_term e2, p)
  | App(e, es, p) -> App(uncurry_term e, List.map uncurry_term es, p)
  | Tuple(es, p) -> Tuple(List.map uncurry_term es, p)
  | LetTuple(xts, e1, e2, p) -> LetTuple(List.map uncurry_id_typ xts, uncurry_term e1, uncurry_term e2, p)
  | Array(e1, e2, p) -> Array(uncurry_term e1, uncurry_term e2, p)
  | Get(e1, e2, p) -> Get(uncurry_term e1, uncurry_term e2, p)
  | Put(e1, e2, e3, p) -> Put(uncurry_term e1, uncurry_term e2, uncurry_term e3, p)
  | e -> e

let rec map_from_list m = function
| (x, t) :: xts -> map_from_list (M.add x t m) xts
| [] -> m

let uncurry_env env = 
    let env' = M.bindings env in
    let new_env' = List.map (fun (x, t) -> (x, uncurry_typ t)) env' in
    map_from_list M.empty new_env'

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
  | Type.FunCurry(t1, t2, n) -> Type.FunCurry(deref_typ t1, deref_typ t2, n)
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


let counter = ref 0
(* 
    �����η��Υꥹ��ts�ȼ��η�e�������ä�, Type.FunCurry(t1, (Type.FunCurry(t2, ...(Type.FunCurry(tn,g (M.add_list yts env) e1) )))) �Ȥ�������Ҥδؿ��η����������.
    ���κ�, Ʊ���ؿ��򥫥꡼�����������ɤ���Ƚ�̤��뤿����ֹ椬counter�Ǥ���.
*)
let seq ts e = 
    incr counter;
    List.fold_right (fun t e -> Type.FunCurry(t, e, !counter)) ts e



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
  | Type.FunCurry(t1, t2, _) -> occur r1 t1 || occur r1 t2
  | Type.Tuple(t2s) -> List.exists (occur r1) t2s
  | Type.Array(t2) -> occur r1 t2
  | Type.Var(r2) when r1 == r2 -> true
  | Type.Var({ contents = None }) -> false
  | Type.Var({ contents = Some(t2) }) -> occur r1 t2
  | _ -> false

let rec unify p t1 t2 = (* �����礦�褦�ˡ����ѿ��ؤ������򤹤� *)
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
  | Type.FunCurry(t1, t1', _), Type.FunCurry(t2, t2', _) ->
      (try unify p t1 t2
      with Invalid_argument(_) -> raise (Unify(t1, t2, p)));
      unify p t1' t2'
  | Type.Tuple(t1s), Type.Tuple(t2s) ->
      (try List.iter2 (unify p) t1s t2s
      with Invalid_argument(_) -> raise (Unify(t1, t2, p)))
  | Type.Array(t1), Type.Array(t2) -> unify p t1 t2
  | Type.Var(r1), Type.Var(r2) when r1 == r2 -> ()
  | Type.Var({ contents = Some(t1') }), _ -> unify p t1' t2
  | _, Type.Var({ contents = Some(t2') }) -> unify p t1 t2'
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
    | Unit(p) -> Type.Unit
    | Bool(_, p) -> Type.Bool
    | Int(_, p) -> Type.Int
    | Float(_, p) -> Type.Float
    | Not(e, p) ->
        unify p Type.Bool (g env e);
        Type.Bool
    | Neg(e, p) ->
        unify p Type.Int (g env e);
        Type.Int
    | Add(e1, e2, p) | Sub(e1, e2, p) -> (* ­�����ʤȰ������ˤη����� *)
        unify p Type.Int (g env e1);
        unify p Type.Int (g env e2);
        Type.Int
    | FNeg(e, p) ->
        unify p Type.Float (g env e);
        Type.Float
    | FAdd(e1, e2, p) | FSub(e1, e2, p) | FMul(e1, e2, p) | FDiv(e1, e2, p) ->
        unify p Type.Float (g env e1);
        unify p Type.Float (g env e2);
        Type.Float
    | Eq(e1, e2, p) | LE(e1, e2, p) ->
        unify p (g env e1) (g env e2);
        Type.Bool
    | If(e1, e2, e3, p) ->
        unify p (g env e1) Type.Bool;
        let t2 = g env e2 in
        let t3 = g env e3 in
        unify p t2 t3;
        t2
    | Let((x, t), e1, e2, p) -> (* let�η����� *)
        unify p t (g env e1);
        g (M.add x t env) e2
    | Var(x, p) when M.mem x env -> M.find x env (* �ѿ��η����� *)
    | Var(x, p) when M.mem x !extenv -> M.find x !extenv
    | Var(x, p) -> (* �����ѿ��η����� *)
        Format.eprintf "free variable %s assumed as external@." x;
        let t = Type.gentyp () in
        extenv := M.add x t !extenv;
        t
    | LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) -> (* let rec�η����� *)
        let env = M.add x t env in
        (* unify p t (Type.FunCurry(List.map snd yts, g (M.add_list yts env) e1)); *)
        unify p t (seq (List.map snd yts) (g (M.add_list yts env) e1));
        g env e2
    | App(e, es, p) -> (* �ؿ�Ŭ�Ѥη����� *)
        let t = Type.gentyp () in
        (* unify p (g env e) (Type.FunCurry(List.map (g env) es, t)); *)
        unify p (g env e) (seq (List.map (g env) es) t);
        t
    | Tuple(es, p) -> Type.Tuple(List.map (g env) es)
    | LetTuple(xts, e1, e2, p) ->
        unify p (Type.Tuple(List.map snd xts)) (g env e1);
        g (M.add_list xts env) e2
    | Array(e1, e2, p) -> (* must be a primitive for "polymorphic" typing *)
        unify p (g env e1) Type.Int;
        Type.Array(g env e2)
    | Get(e1, e2, p) ->
        let t = Type.gentyp () in
        unify p (Type.Array(t)) (g env e1);
        unify p Type.Int (g env e2);
        t
    | Put(e1, e2, e3, p) ->
        let t = g env e3 in
        unify p (Type.Array(t)) (g env e1);
        unify p Type.Int (g env e2);
        Type.Unit
  with 
    | Unify(t1, t2, p) -> raise (Error(deref_term e, deref_typ t1, deref_typ t2, p))
    | Error(e, t1, t2, p) -> raise (Error(deref_term e, deref_typ t1, deref_typ t2, p))

let rec make_abst_args acc = function
| Type.FunCurry(t1, t2, n) -> make_abst_args (acc @ [(Id.genid "abst_args", t1)]) t2
| _ -> acc

(* ��tf�δؿ�f�˷�tes�ΰ���es��Ŭ�Ѥ����Ȥ���Ŭ�Ѹ�η����֤��ؿ� *)
(* let rec get_typ_app' tf tes n = 
    match tes with
    | [] -> tf (* tes�����ꥹ�Ȥ��ä���, tf���֤��ͤη� *)
    | th :: tt -> (* tes�����ꥹ�ȤǤϤʤ��Ȥ� *)
        (
            match tf with
            | Type.FunCurry(t1, t2, m) when t1 = th && m = n -> get_typ_app' t2 tt m (* tf��FunCurry��, tf���åפ��Ƥ���FunCurry��Ʊ���ؿ��򥫥꡼���������(m=n)���ä���t2���Ф��ƺƵ�Ū��tt��Ŭ�� *)
            | _ -> Type.output_type stdout tf; List.iter (fun e -> Type.output_type stdout e) tes; raise AppError (* ����ʳ���Ϳ���������ο���, �ؿ��μ°�������¿���Τǥ��顼 *)
        ) *)

let same_funcurry s t = 
    match s, t with
    | Type.FunCurry(s1, s2, _), Type.FunCurry(t1, t2, _) when s1 = t1 && s2 = t2 -> true
    | _ -> false

(* get_typ_app'�Υȥåץ�٥�ؿ� *)
let rec get_typ_app tf tes = 
    match tes with
    | [] -> tf
    | th :: tt -> 
        (
            match tf with
            | Type.FunCurry(t1, t2, n) when t1 = th || same_funcurry t1 th  -> get_typ_app t2 tt
            | _ -> output_string stdout "TF:\n"; Type.output_type stdout tf; output_string stdout "\nTES:\n"; List.iter (fun e -> Type.output_type stdout e) tes; raise AppError
        )
(* ���Ķ�env�θ���, ��e�η����֤� *)
let rec get_typ env = function
| Unit(p) -> Type.Unit
| Bool(_, p) -> Type.Bool
| Int(_, p) -> Type.Int
| Float(_, p) -> Type.Float
| Not(e, p) -> Type.Bool
| Neg(e, p) -> Type.Int
| Add(e1, e2, p) | Sub(e1, e2, p) -> (* ­�����ʤȰ������ˤη����� *)
    Type.Int
| FNeg(e, p) ->
    Type.Float
| FAdd(e1, e2, p) | FSub(e1, e2, p) | FMul(e1, e2, p) | FDiv(e1, e2, p) ->
    Type.Float
| Eq(e1, e2, p) | LE(e1, e2, p) ->
    Type.Bool
| If(e1, e2, e3, p) ->
    get_typ env e2
| Let((x, t), e1, e2, p) -> (* let�η����� *)
    get_typ (M.add x t env) e2
| Var(x, p) when M.mem x env -> M.find x env (* �ѿ��η����� *)
| Var(x, p) when M.mem x !extenv -> M.find x !extenv
| Var(x, p) -> raise UndefinedVarError
| LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) -> (* let rec�η����� *)
    get_typ (M.add x t env) e2
| App(e, es, p) -> (* �ؿ�Ŭ�Ѥη����� *)
    let te = get_typ env e in
    let tes = List.map (fun e -> get_typ env e) es in
    get_typ_app te tes
| Tuple(es, p) -> Type.Tuple(List.map (get_typ env) es)
| LetTuple(xts, e1, e2, p) ->
    get_typ (M.add_list xts env) e2
| Array(e1, e2, p) -> (* must be a primitive for "polymorphic" typing *)
    Type.Array(get_typ env e2)
| Get(e1, e2, p) ->
    let t = Type.gentyp () in
    unify p (Type.Array(t)) (g env e1);
    unify p Type.Int (g env e2);
    (
        match get_typ env e1 with
        | Type.Array(tt) -> tt
        | e -> e
    )
| Put(e1, e2, e3, p) ->
    Type.Unit

(* �Ķ�env�β���, ��e��etaŸ����Ԥ��ؿ� *)
let rec eta env = function
| App(e1, e2, p) ->
(
    let e1 = eta env e1 in (* e1(�ؿ�)��etaŸ�� *)
    let e2 = List.map (fun e -> eta env e) e2 in (* e2(�����Υꥹ��)��etaŸ�� *)
    let e = App(e1, e2, p) in (* e�򹹿� *)
    (* output_string stdout "EXP:\n"; *)
    (* Syntax.output_prog stdout e; *)
    let t = get_typ env e in (* e�η� *)
    (* output_string stdout "\nt1\n"; *)
    (* Type.output_type stdout t1; *)
    let t1 = get_typ env e1 in (* e1�η� *)
    (* output_string stdout "\nt\n"; *)
    (* Type.output_type stdout t; *)
    match t, t1 with
    | FunCurry(f, g, n), FunCurry(f1, g1, m) when n = m -> (* Ŭ�Ѥ���ʬŬ�Ѥ��ä��� *)
    (
        let yts = make_abst_args [] t in (* �������ؿ�����Ѥΰ����η����� *)
        let yts' = List.map (fun (x, t) -> Var(x, p)) yts in (* �ؿ�Ŭ�Ѥϼ����Ϥ� *)
        let x = Id.genid "lambda_abst" in 
        LetRec({ name = (x, t); args = yts; body = App(e1, e2 @ yts', p) }, Var(x, p), p)
    )
    | _ -> e (* Ŭ�Ѥ���ʬŬ�ѤǤϤʤ��Ȥ��Ϥ��Τޤ� *)
)
| Unit(_) | Bool(_) | Int(_) | Float(_) | Var(_) as e -> e
| Not(e, p) -> Not(eta env e, p)
| Neg(e, p) -> Neg(eta env e, p)
| Add(e1, e2, p) -> Add(eta env e1, eta env e2, p) 
| Sub(e1, e2, p) -> Sub(eta env e1, eta env e2, p) 
| FNeg(e, p) -> FNeg(eta env e, p)
| FAdd(e1, e2, p) -> FAdd(eta env e1, eta env e2, p) 
| FSub(e1, e2, p) -> FSub(eta env e1, eta env e2, p) 
| FMul(e1, e2, p) -> FMul(eta env e1, eta env e2, p) 
| FDiv(e1, e2, p) -> FDiv(eta env e1, eta env e2, p) 
| Eq(e1, e2, p) -> Eq(eta env e1, eta env e2, p) 
| LE(e1, e2, p) -> LE(eta env e1, eta env e2, p) 
| If(e1, e2, e3, p) -> If(eta env e1, eta env e2, eta env e3, p) 
| Let((x, t), e1, e2, p) -> Let((x, t), eta env e1, eta (M.add x t env) e2, p)
| LetRec({ name = (x, t); args = yts; body = e1 }, e2, p) -> 
    let env = M.add x t env in
    LetRec({ name = (x, t); args = yts; body = eta (M.add_list yts env) e1 }, eta env e2, p)
| Tuple(es, p) -> Tuple((List.map (fun e -> eta env e) es), p)
| LetTuple(xts, e1, e2, p) -> LetTuple(xts, eta env e1, eta (M.add_list xts env) e2, p)
| Array(e1, e2, p) -> Array(eta env e1, eta env e2, p) 
| Get(e1, e2, p) -> Get(eta env e1, eta env e2, p) 
| Put(e1, e2, e3, p) -> Put(eta env e1, eta env e2, eta env e3, p) 

let f e =
  extenv := M.empty;

  (* (match deref_typ (g M.empty e) with
  | Type.Unit -> ()
  | _ -> Format.eprintf "warning: final result does not have type unit@."); *)

  (try unify Syntax.top_pos Type.Unit (g M.empty e)
  with 
    | Unify _ -> failwith "top level does not have type unit"
    | Error (_, _, _, p) -> print_newline (); failwith (Printf.sprintf "top level Error in line %d" p));
  extenv := M.map deref_typ !extenv;
  let e' = deref_term e in 
  let e' = eta M.empty e' in
  Syntax.output_prog stdout e';
  extenv := uncurry_env !extenv;
  uncurry_term e'
