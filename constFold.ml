open KNormal

let rec encode n = 
  if n = 0 then 48 else
  if n = 1 then 49 else
  if n = 2 then 50 else
  if n = 3 then 51 else
  if n = 4 then 52 else
  if n = 5 then 53 else
  if n = 6 then 54 else
  if n = 7 then 55 else
  if n = 8 then 56
  else 57

let rec hundredth n count = 
  if n - 100 < 0 then (n, count)
  else hundredth (n - 100) (count + 1)

let rec tenth n count = 
  if n - 10 < 0 then (n, count)
  else tenth (n - 10) (count + 1)

let rec oneth n count = 
  if n - 1 < 0 then (n, count)
  else oneth (n - 1) (count + 1)

let memi x env =
  try (match M.find x env with Int(_, p) -> true | _ -> false)
  with Not_found -> false
let memf x env =
  try (match M.find x env with Float(_, p) -> true | _ -> false)
  with Not_found -> false
let memt x env =
  try (match M.find x env with Tuple(_, p) -> true | _ -> false)
  with Not_found -> false

let findi x env = (match M.find x env with Int(i, p) -> i | _ -> raise Not_found)
let findf x env = (match M.find x env with Float(d, p) -> d | _ -> raise Not_found)
let findt x env = (match M.find x env with Tuple(ys, p) -> ys | _ -> raise Not_found)

let rec g env = function (* 定数畳み込みルーチン本体 (caml2html: constfold_g) *)
  | Var(x, p) when memi x env -> Int(findi x env, p)
  (* | Var(x, p) when memf x env -> Float(findf x env, p) *)
  (* | Var(x, p) when memt x env -> Tuple(findt x env, p) *)
  | Neg(x, p) when memi x env -> Int(-(findi x env), p)
  | Add(x, y, p) when memi x env && memi y env -> Int(findi x env + findi y env, p) (* 足し算のケース (caml2html: constfold_add) *)
  | Sub(x, y, p) when memi x env && memi y env -> Int(findi x env - findi y env, p)
  | FNeg(x, p) when memf x env -> Float(-.(findf x env), p)
  | FSqrt(x, p) when memf x env -> Float(sqrt (findf x env) , p)
  | Floor(x, p) when memf x env -> Float(floor (findf x env) , p)
  | FAdd(x, y, p) when memf x env && memf y env -> Float(findf x env +. findf y env, p)
  | FSub(x, y, p) when memf x env && memf y env -> Float(findf x env -. findf y env, p)
  | FMul(x, y, p) when memf x env && memf y env -> Float(findf x env *. findf y env, p)
  | FDiv(x, y, p) when memf x env && memf y env -> Float(findf x env /. findf y env, p)
  | IfEq(x, y, e1, e2, p) when memi x env && memi y env -> if findi x env = findi y env then g env e1 else g env e2
  | IfEq(x, y, e1, e2, p) when memf x env && memf y env -> if findf x env = findf y env then g env e1 else g env e2
  | IfEq(x, y, e1, e2, p) -> IfEq(x, y, g env e1, g env e2, p)
  | IfLE(x, y, e1, e2, p) when memi x env && memi y env -> if findi x env <= findi y env then g env e1 else g env e2
  | IfLE(x, y, e1, e2, p) when memf x env && memf y env -> if findf x env <= findf y env then g env e1 else g env e2
  | IfLE(x, y, e1, e2, p) -> IfLE(x, y, g env e1, g env e2, p)
  | Let((x, t), e1, e2, p) -> (* letのケース (caml2html: constfold_let) *)
      let e1' = g env e1 in
      let e2' = g (M.add x e1' env) e2 in
      Let((x, t), e1', e2', p)
  | Loop((x, t), e1, e2, p) -> (* loopのケース (caml2html: constfold_let) *)
      let e1' = g env e1 in
      let e2' = g (M.add x e1' env) e2 in
      Let((x, t), e1', e2', p)
  | Recur(e, p) ->
      Recur(g env e, p)
  | LetRec({ name = x; args = ys; body = e1 }, e2, p) ->
      LetRec({ name = x; args = ys; body = g env e1 }, g env e2, p)
  | LetTuple(xts, y, e, p) when memt y env ->
      List.fold_left2
        (fun e' xt z -> Let(xt, Var(z, p), e', p))
        (g env e)
        xts
        (findt y env)
  | LetTuple(xts, y, e, p) -> LetTuple(xts, y, g env e, p)
  | App(x, ys, p) as e ->
  (try
    (
    match x, ys with
      | f, [y] when ((String.sub f 0 9) = "print_int") && (memi y env) -> (* print_int の畳み込み *)
      (
        let n = findi y env in
        Format.eprintf "const fold print_int %d@." n;
        let (n, h) = hundredth n 0 in
        let (n, t) = tenth n 0 in
        let (n, o) = oneth n 0 in

        let tmph = Id.gentmp Type.Int in
        let tmpt = Id.gentmp Type.Int in
        let tmpo = Id.gentmp Type.Int in

        Let((tmph, Type.Int), Int(encode h, p),
        Let((tmpt, Type.Int), Int(encode t, p),
        Let((tmpo, Type.Int), Int(encode o, p),
        Let((Id.gentmp Type.Unit, Type.Unit), 
        ExtFunApp("print_char", [tmph], p),
        Let((Id.gentmp Type.Unit, Type.Unit), 
        ExtFunApp("print_char", [tmpt], p),
        Let((Id.gentmp Type.Unit, Type.Unit),
        ExtFunApp("print_char", [tmpo], p), Unit(p), p), p), p), p), p), p)
      )
      | _ -> e
    )
    with Invalid_argument _ -> e
  )
  | e -> e

let f = g M.empty
