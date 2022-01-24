type closure = { entry : Id.l; actual_fv : Id.t list } (* トップレベル関数のラベル, 自由変数のリスト *)
type t = (* クロージャ変換後の式 (caml2html: closure_t) *)
  | Unit of Syntax.pos
  | Int of int * Syntax.pos
  | Float of float * Syntax.pos
  | Neg of Id.t * Syntax.pos
  | Add of Id.t * Id.t * Syntax.pos
  | Sub of Id.t * Id.t * Syntax.pos
  | FNeg of Id.t * Syntax.pos
  | FSqrt of Id.t * Syntax.pos
  | Floor of Id.t * Syntax.pos
  | FAdd of Id.t * Id.t * Syntax.pos
  | FSub of Id.t * Id.t * Syntax.pos
  | FMul of Id.t * Id.t * Syntax.pos
  | FDiv of Id.t * Id.t * Syntax.pos
  | IfEq of Id.t * Id.t * t * t * Syntax.pos
  | IfLE of Id.t * Id.t * t * t * Syntax.pos
  | Let of (Id.t * Type.t) * t * t * Syntax.pos
  | Var of Id.t * Syntax.pos
  | MakeCls of (Id.t * Type.t) * closure * t * Syntax.pos  (*(関数名, 関数の型), クロージャ, 関数の本体 *)
  | AppCls of Id.t * Id.t list * Syntax.pos
  | AppDir of Id.l * Id.t list * Syntax.pos
  | Tuple of Id.t list * Syntax.pos
  | LetTuple of (Id.t * Type.t) list * Id.t * t * Syntax.pos
  | Get of Id.t * Id.t * Syntax.pos
  | Put of Id.t * Id.t * Id.t * Syntax.pos
  | ExtArray of Id.l * Syntax.pos
type fundef = { name : Id.l * Type.t; (* 多分これはシンプルに関数の型 *)
                args : (Id.t * Type.t) list;
                formal_fv : (Id.t * Type.t) list;
                body : t }
type prog = Prog of fundef list * t

type t = (* MinCamlの型を表現するデータ型 (caml2html: type_t) *)
  | Unit
  | Bool
  | Int
  | Float
  | Fun of t list * t (* arguments are uncurried *)
  | Tuple of t list
  | Array of t
  | Var of t option ref

exception TypeErr of String


let rec type_check_exp env = function
  | Unit(_) -> Type.Unit
  | Int(_) -> Type.Int
  | Float(_) -> Type.Float
  | Neg(x, _) ->
    let t = type_check_exp env x in
    if t = Type.Int then Type.Int else raise (TypeErr "Neg演算子のオペランドの型がIntではなく, "^(str_of_type t)^"です.")
  | Add(x1, x2, _) -> 
    let t1 = type_check_exp env x1 in
    let t2 = type_check_exp env x2 in
    match t1, t2 with
    | s1, s2 when (s1 = s2 && s1 = Type.Int) -> Type.Int
    | _ -> raise (TypeErr "Add演算子のオペランドの型が(Int, Int)ではなく, ("^(str_of_type t1)^", "^(str_of_type t2)^")です.")
  | Sub(x1, x2, _) -> 
    let t1 = type_check_exp env x1 in
    let t2 = type_check_exp env x2 in
    match t1, t2 with
    | s1, s2 when (s1 = s2 && s1 = Type.Int) -> Type.Int
    | _ -> raise (TypeErr "Sub演算子のオペランドの型が(Int, Int)ではなく, ("^(str_of_type t1)^", "^(str_of_type t2)^")です.")
  | FNeg(x, _) ->
    let t = type_check_exp env x in
    if t = Type.Int then Type.Int else raise (TypeErr "FNeg演算子のオペランドの型がFloatではなく, "^(str_of_type t)^"です.")
  | FSqrt(x, _) ->
    let t = type_check_exp env x in
    if t = Type.Int then Type.Int else raise (TypeErr "FSqrt演算子のオペランドの型がFloatではなく, "^(str_of_type t)^"です.")
  | Floor(x, _) ->
    let t = type_check_exp env x in
    if t = Type.Int then Type.Int else raise (TypeErr "Floor演算子のオペランドの型がFloatではなく, "^(str_of_type t)^"です.")
  | FAdd(x1, x2, _) -> 
    let t1 = type_check_exp env x1 in
    let t2 = type_check_exp env x2 in
    match t1, t2 with
    | s1, s2 when (s1 = s2 && s1 = Type.Int) -> Type.Int
    | _ -> raise (TypeErr "FAdd演算子のオペランドの型が(Float, Float)ではなく, ("^(str_of_type t1)^", "^(str_of_type t2)^")です.")
  | FSub(x1, x2, _) -> 
    let t1 = type_check_exp env x1 in
    let t2 = type_check_exp env x2 in
    match t1, t2 with
    | s1, s2 when (s1 = s2 && s1 = Type.Int) -> Type.Int
    | _ -> raise (TypeErr "FSub演算子のオペランドの型が(Float, Float)ではなく, ("^(str_of_type t1)^", "^(str_of_type t2)^")です.")
  | FMul(x1, x2, _) -> 
    let t1 = type_check_exp env x1 in
    let t2 = type_check_exp env x2 in
    match t1, t2 with
    | s1, s2 when (s1 = s2 && s1 = Type.Int) -> Type.Int
    | _ -> raise (TypeErr "FMul演算子のオペランドの型が(Float, Float)ではなく, ("^(str_of_type t1)^", "^(str_of_type t2)^")です.")
  | FDiv(x1, x2, _) -> 
    let t1 = type_check_exp env x1 in
    let t2 = type_check_exp env x2 in
    match t1, t2 with
    | s1, s2 when (s1 = s2 && s1 = Type.Int) -> Type.Int
    | _ -> raise (TypeErr "FDiv演算子のオペランドの型が(Float, Float)ではなく, ("^(str_of_type t1)^", "^(str_of_type t2)^")です.")
  | IfEq(a1, a2, e1, e2, _) ->
    let ta1 = M.find a1 env in
    let ta2 = M.find a2 env in
    let te1 = type_check_exp env e1 in
    let te2 = type_check_exp env e2 in
    match te1, te2, te3, te4 with
    | se1, se2, se3, se4 when (se1 = Type.Int && se2 = Type.Int && se3 = se4) -> te3
    | _ -> raise (TypeErr "IfEq演算子のオペランドの型が(Int, Int, t, t)ではなく, ("^(str_of_type ta1)^", "^(str_of_type ta2)^", "^(str_of_type te1)^", "^(str_of_type te2)^")です.")
  | IfEq(a1, a2, e1, e2, _) ->
    let ta1 = M.find a1 env in
    let ta2 = M.find a2 env in
    let te1 = type_check_exp env e1 in
    let te2 = type_check_exp env e2 in
    match te1, te2, te3, te4 with
    | se1, se2, se3, se4 when (se1 = Type.Int && se2 = Type.Int && se3 = se4) -> te3
    | se1, se2, se3, se4 when (se1 = Type.Bool && se2 = Type.Bool && se3 = se4) -> te3
    | se1, se2, se3, se4 when (se1 = Type.Float && se2 = Type.Float && se3 = se4) -> te3
    | _ -> raise (TypeErr "IfEq演算子のオペランドの型が(Int/Bool/Float, Int/Bool/Float, t, t)ではなく, ("^(str_of_type ta1)^", "^(str_of_type ta2)^", "^(str_of_type te1)^", "^(str_of_type te2)^")です.")
  | IfFE(a1, a2, e1, e2, _) ->
    let ta1 = M.find a1 env in
    let ta2 = M.find a2 env in
    let te1 = type_check_exp env e1 in
    let te2 = type_check_exp env e2 in
    match te1, te2, te3, te4 with
    | se1, se2, se3, se4 when (se1 = Type.Int && se2 = Type.Int && se3 = se4) -> te3
    | se1, se2, se3, se4 when (se1 = Type.Bool && se2 = Type.Bool && se3 = se4) -> te3
    | se1, se2, se3, se4 when (se1 = Type.Float && se2 = Type.Float && se3 = se4) -> te3
    | _ -> raise (TypeErr "IfFE演算子のオペランドの型が(Int/Bool/Float, Int/Bool/Float, t, t)ではなく, ("^(str_of_type ta1)^", "^(str_of_type ta2)^", "^(str_of_type te1)^", "^(str_of_type te2)^")です.")
  | Let((x, t), e1, e2, _) -> 
    let te1 = type_check_exp env e1 in
    if t = te1 then type_check_exp (M.add x t env) e2 else raise (TypeErr "Let演算子で宣言されている式の型が異なります.")
  | Var(x, _) -> M.find x env
  | MakeCls((x, t), { entry = Id.L(f); actual_fv = ts }, tf, _) ->
    let 

  | MakeCls of (Id.t * Type.t) * closure * t * Syntax.pos  (*(関数名, 関数の型), クロージャ, 関数の本体 *)
  | AppCls(f, xs, _) ->
    let tf = type_check_exp env f in
    let txs = List.map((fun x -> type_check_exp env x) xs) in
    match tf with
    | Type.Fun(txs, s) -> s
    | _ -> raise (TypeErr "AppClsで定義されている関数の引数の型と与えられている引数の型が異なります.")
  | AppDir(Id.L(f), x, _) ->
    let tf = type_check_exp env f in
    let txs = List.map((fun x -> type_check_exp env x) xs) in
    match tf with
    | Type.Fun(txs, s) -> s
    | _ -> raise (TypeErr "AppDirで定義されている関数の引数の型と与えられている引数の型が異なります.")
  | Tuple(xs, _) -> Type.Tuple(List.map (fun x -> M.find x env) xs)
  | LetTuple((x, t), e1, e2, _) ->
    let te1 = M.find e1 env in
    if te1 = t then type_check_exp (M.add x t env) e2 else raise (TypeErr "LetTuple演算子で宣言されている式の型が異なります.")
  | Get(x, y, _) ->
    let tx = type_check_exp env x in
    let ty = type_check_exp env y in
    match tx, ty with
    | Type.Array(s), Type.Int -> s
    | _ -> raise (TypeErr "Get演算子のオペランドの型が(Array(s), Int)ではなく, ("^(str_of_type tx)^", "^(str_of_type ty)^")です.")
  | Put(x, y, z, _) -> 
    let tx = type_check_exp env x in
    let ty = type_check_exp env y in
    let tz = type_check_exp env z in
    match tx, ty, tz with
    | Type.Array(s), Type.Int, s -> Type.Unit
    | _ -> raise (TypeErr "Put演算子のオペランドの型が(Array(s), Int, s)ではなく, ("^(str_of_type tx)^", "^(str_of_type ty)^", "^(str_of_type tz)^")です.")
  | ExtArray(Id.L(x), _) -> M.find x env