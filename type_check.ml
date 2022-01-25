let map_from_list l = 
  let rec map_from_list_sub l m = 
    match l with
    | [] -> m
    | (fh, sh) :: t -> map_from_list_sub t (M.add fh sh m)
  in map_from_list_sub l (M.empty)

let map f l = 
  let rec map_sub f l acc = 
    match l with
    | [] -> List.rev acc
    | lh ::lt -> map_sub f lt ((f lh) :: acc)
  in map_sub f l []

exception TypeErr of string

open Closure

let funcenv = ref (map_from_list [("min_caml_create_array", let t = Type.gentyp() in Type.Fun([Type.Int; t], Type.Array(t)));
("min_caml_create_float_array", Type.Fun([Type.Int; Type.Float], Type.Array(Type.Float)));
("min_caml_print_int", Type.Fun([Type.Int], Type.Unit));
("min_caml_print_newline", Type.Fun([Type.Unit], Type.Unit));
("min_caml_truncate", Type.Fun([Type.Float], Type.Int));
("min_caml_print_char", Type.Fun([Type.Int], Type.Unit))
])

let rec type_check_id env x = M.find x env

exception UnifyErr

let rec unify t1 t2 = 
  match t1, t2 with
  | Type.Unit, Type.Unit -> Type.Unit
  | Type.Int, Type.Int -> Type.Int
  | Type.Bool, Type.Bool -> Type.Bool
  | Type.Float, Type.Float -> Type.Float
  | Type.Fun(args1, r1), Type.Fun(args2, r2) -> 
    let args = List.map2 unify args1 args2 in
    let r = unify r1 r2 in Type.Fun(args, r)
  | Type.Tuple(xs1), Type.Tuple(xs2) -> 
    let xs = List.map2 unify xs1 xs2 in Type.Tuple(xs)
  | Type.Array(t1), Type.Array(t2) -> 
    let t = unify t1 t2 in Type.Array(t)
  | Type.Var(t1ref), Type.Var(t2ref) when (Option.is_none !t1ref) && (Option.is_none !t2ref) -> t1
  | Type.Var(t1ref), Type.Var(t2ref) when (Option.is_none !t1ref) && (Option.is_some !t2ref) -> Option.get !t2ref
  | Type.Var(t1ref), t2 when (Option.is_none !t1ref) -> t2
  | Type.Var(t1ref), Type.Var(t2ref) when (Option.is_some !t1ref) && (Option.is_none !t2ref) -> Option.get !t1ref
  | Type.Var(t1ref), Type.Var(t2ref) when (Option.is_some !t1ref) && (Option.is_some !t2ref) -> 
    let t1' = Option.get !t1ref in
    let t2' = Option.get !t2ref in unify t1' t2'
  | Type.Var(t1ref), t2 when (Option.is_some !t1ref) -> 
    let t1' = Option.get !t1ref in unify t1' t2 
  | t1, Type.Var(t2ref) when (Option.is_none !t2ref) -> t1
  | t1, Type.Var(t2ref) when (Option.is_some !t2ref) ->
    let t2' = Option.get !t2ref in unify t1 t2'
  | _ -> raise UnifyErr

let rec type_check_exp env e =
  match e with
  | Unit(_) -> Type.Unit
  | Int(_) -> Type.Int
  | Float(_) -> Type.Float
  | Neg(x, _) ->
    let t = type_check_id env x in
    (
      try
        unify t Type.Int
      with
        e -> raise (TypeErr ("Neg演算子のオペランドの型がIntではなく, "^(Type.str_of_type t)^"です."))
    )
  | Add(x1, x2, _) -> 
    let t1 = type_check_id env x1 in
    let t2 = type_check_id env x2 in
    (
      try
        unify t2 (unify t1 Type.Int)
      with
        e -> raise (TypeErr ("Add演算子のオペランドの型が(Int, Int)ではなく, ("^(Type.str_of_type t1)^", "^(Type.str_of_type t2)^")です."))
    )
  | Sub(x1, x2, _) -> 
    let t1 = type_check_id env x1 in
    let t2 = type_check_id env x2 in
    (
      try
        unify t2 (unify t1 Type.Int)
      with
        e -> raise (TypeErr ("Sub演算子のオペランドの型が(Int, Int)ではなく, ("^(Type.str_of_type t1)^", "^(Type.str_of_type t2)^")です."))
    )
  | FNeg(x, _) ->
    let t = type_check_id env x in
    (
      try
        unify t Type.Float
      with
        e -> raise (TypeErr ("FNeg演算子のオペランドの型がFloatではなく, "^(Type.str_of_type t)^"です."))
    )
  | FSqrt(x, _) ->
    let t = type_check_id env x in
    (
      try
        unify t Type.Float
      with
        e -> raise (TypeErr ("FSqrt演算子のオペランドの型がFloatではなく, "^(Type.str_of_type t)^"です."))
    )
  | Floor(x, _) ->
    let t = type_check_id env x in
    (
      try
        unify t Type.Float
      with
        e -> raise (TypeErr ("Float演算子のオペランドの型がFloatではなく, "^(Type.str_of_type t)^"です."))
    )
  | FAdd(x1, x2, _) -> 
    let t1 = type_check_id env x1 in
    let t2 = type_check_id env x2 in
    (
      try
        unify t2 (unify t1 Type.Float)
      with
        e -> raise (TypeErr ("FAdd演算子のオペランドの型が(Float, Float)ではなく, ("^(Type.str_of_type t1)^", "^(Type.str_of_type t2)^")です."))
    )
  | FSub(x1, x2, _) -> 
    let t1 = type_check_id env x1 in
    let t2 = type_check_id env x2 in
    (
      try
        unify t2 (unify t1 Type.Float)
      with
        e -> raise (TypeErr ("FSub演算子のオペランドの型が(Float, Float)ではなく, ("^(Type.str_of_type t1)^", "^(Type.str_of_type t2)^")です."))
    )
  | FMul(x1, x2, _) -> 
    let t1 = type_check_id env x1 in
    let t2 = type_check_id env x2 in
    (
      try
        unify t2 (unify t1 Type.Float)
      with
        e -> raise (TypeErr ("FMul演算子のオペランドの型が(Float, Float)ではなく, ("^(Type.str_of_type t1)^", "^(Type.str_of_type t2)^")です."))
    )
  | FDiv(x1, x2, _) -> 
    let t1 = type_check_id env x1 in
    let t2 = type_check_id env x2 in
    (
      try
        unify t2 (unify t1 Type.Float)
      with
        e -> raise (TypeErr ("FDiv演算子のオペランドの型が(Float, Float)ではなく, ("^(Type.str_of_type t1)^", "^(Type.str_of_type t2)^")です."))
    )
  | IfEq(a1, a2, e1, e2, _) ->
    let ta1 = type_check_id env a1 in
    let ta2 = type_check_id env a2 in
    let te1 = type_check_exp env e1 in
    let te2 = type_check_exp env e2 in
    let ta = 
      (
        try
          unify ta1 ta2
        with
          e -> raise (TypeErr ("IfEq演算子の条件部の型が一致していません. a1 : "^(Type.str_of_type ta1)^", a2 : "^(Type.str_of_type ta2)))
      ) in
    let te = 
      (
        try
          unify te1 te2
        with
          e -> raise (TypeErr ("IfEq演算子の型が2つのブランチで一致していません. e1 : "^(Type.str_of_type te1)^", a2 : "^(Type.str_of_type te2)))
      ) in
    (match ta with
    | Type.Int | Type.Bool | Type.Float -> te
    | _ -> raise (TypeErr ("IfEq演算子の型がInt, Bool, Float以外の型になっています. a : "^(Type.str_of_type ta))))
  | IfLE(a1, a2, e1, e2, _) ->
    let ta1 = type_check_id env a1 in
    let ta2 = type_check_id env a2 in
    let te1 = type_check_exp env e1 in
    let te2 = type_check_exp env e2 in
    let ta = 
      (
        try
          unify ta1 ta2
        with
          e -> raise (TypeErr ("IfLE演算子の条件部の型が一致していません. a1 : "^(Type.str_of_type ta1)^", a2 : "^(Type.str_of_type ta2)))
      ) in
    let te = 
      (
        try
          unify te1 te2
        with
          e -> raise (TypeErr ("IfLE演算子の型が2つのブランチで一致していません. e1 : "^(Type.str_of_type te1)^", a2 : "^(Type.str_of_type te2)))
      ) in
    (match ta with
    | Type.Int | Type.Bool | Type.Float -> te
    | _ -> raise (TypeErr ("IfLE演算子の型がInt, Bool, Float以外の型になっています. a : "^(Type.str_of_type ta))))
  | Let((x, t), e1, e2, _) -> 
    let te1 = type_check_exp env e1 in
    let t = 
      (
        try
          unify t te1
        with
          e -> raise (TypeErr ("Let演算子で宣言されている式の型が異なります. x : "^(Type.str_of_type t)^"e : "^(Type.str_of_type te1)))
      ) in
    type_check_exp (M.add x t env) e2
  | Var(x, _) -> type_check_id env x
  | MakeCls((x, t), { entry = Id.L(f); actual_fv = s }, e, _) -> type_check_exp (M.add x t env) e
  | AppCls(f, xs, _) ->
    let tf = type_check_id env f in
    let txs = map (fun x -> type_check_id env x) xs in
    let tf' = (
      try
        unify tf (Type.Fun(txs, Type.gentyp()))
      with
        e -> raise (TypeErr ("AppDirで定義されている関数の引数の型と与えられている引数の型が異なります. f : "^(Type.str_of_type tf)^" xs : "^(List.fold_left (fun a b -> a^", "^(Type.str_of_type b)) (Type.str_of_type (List.hd(txs))) (List.tl(txs)))))
    ) in
    (match tf' with
    | Type.Fun(args, r) -> r
    | _ -> raise (TypeErr ("AppDirで定義されている関数の引数の型と与えられている引数の型が異なります. f : "^(Type.str_of_type tf)^" xs : "^(List.fold_left (fun a b -> a^", "^(Type.str_of_type b)) (Type.str_of_type (List.hd(txs))) (List.tl(txs))))))
  | AppDir(Id.L(f), xs, _) ->
    let tf = type_check_id env f in
    let txs = map (fun x -> type_check_id env x) xs in
    let tf' = (
      try
        unify tf (Type.Fun(txs, Type.gentyp()))
      with
        e -> raise (TypeErr ("AppDirで定義されている関数の引数の型と与えられている引数の型が異なります. f : "^(Type.str_of_type tf)^" xs : "^(List.fold_left (fun a b -> a^", "^(Type.str_of_type b)) (Type.str_of_type (List.hd(txs))) (List.tl(txs)))))
    ) in
    (match tf' with
    | Type.Fun(args, r) -> r
    | _ -> raise (TypeErr ("AppDirで定義されている関数の引数の型と与えられている引数の型が異なります. f : "^(Type.str_of_type tf)^" xs : "^(List.fold_left (fun a b -> a^", "^(Type.str_of_type b)) (Type.str_of_type (List.hd(txs))) (List.tl(txs))))))
  | Tuple(xs, _) -> Type.Tuple(List.map (fun x -> type_check_id env x) xs)
  | LetTuple(xts, e1, e2, _) ->
    let te1 = type_check_id env e1 in
    let ts = (List.map snd xts) in
    let _ = (
      try
        unify (Type.Tuple(ts)) te1
      with
        e -> raise (TypeErr ("LetTuple演算子で宣言されている式の型が異なります."))
    ) in type_check_exp (map_from_list (xts @ (M.bindings env))) e2
  | Get(x, y, _) ->
    let tx = type_check_id env x in
    let tx = 
      (
        try
          unify tx (Type.Array(Type.gentyp()))
        with
          e -> raise (TypeErr ("Get演算子の第1引数の型がArray(s)ではありません. x : "^(Type.str_of_type tx)))
      ) in
    let ty = type_check_id env y in
    let _ = 
      (
        try
          unify ty Type.Int
        with
          e -> raise (TypeErr ("Get演算子の第2引数の型がIntではありません. y : "^(Type.str_of_type ty)))
      ) in
    (match tx with
    | Type.Array(s) -> s
    | _ -> raise (TypeErr ("Get演算子の第1引数の型がArray(s)ではありません. x : "^(Type.str_of_type tx)))
    )
  | Put(x, y, z, _) -> 
    let tx = type_check_id env x in
    let tx = 
      (
        try
          unify tx (Type.Array(Type.gentyp()))
        with
          e -> raise (TypeErr ("Put演算子の第1引数の型がArray(s)ではありません. x : "^(Type.str_of_type tx)))
      ) in
    let ty = type_check_id env y in
    let _ = 
      (
        try
          unify ty Type.Int
        with
          e -> raise (TypeErr ("Put演算子の第2引数の型がIntではありません. y : "^(Type.str_of_type ty)))
      ) in
    let s = (match tx with
    | Type.Array(s) -> s
    | _ -> raise (TypeErr ("Put演算子の第1引数の型がArray(s)ではありません. x : "^(Type.str_of_type tx)))
    ) in
    let tz = type_check_id env z in
    let _ = 
      (
        try
          unify tz s
        with
          e -> raise (TypeErr ("Put演算子の第3引数の型が第1引数の型の中身と一致しません. z : "^(Type.str_of_type tz)^", x : "^(Type.str_of_type tx)))
      )
    in Type.Unit
  | ExtArray(Id.L(x), _) -> M.find x env

let rec type_add_fun { name = (Id.L(x), t); args = yts; formal_fv = zts; body = e } = 
    funcenv := M.add x t !funcenv

let rec type_check_fun env { name = (Id.L(x), t); args = yts; formal_fv = zts; body = e } = 
  let env' = map_from_list (yts @ zts @ (M.bindings env)) in
  let te = type_check_exp env' e in
  if t = Type.Fun(List.map snd yts, te) then () else raise (TypeErr ("関数の型が合致しません."))

let rec type_check_prog (Prog(funs, e)) = 
  List.iter type_add_fun funs;
  List.iter (fun f -> type_check_fun !funcenv f) funs;
  let _ = type_check_exp !funcenv e in Prog(funs, e)
