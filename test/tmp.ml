let insert_let p (e, t) k = (* letを挿入する補助関数 (caml2html: knormal_insert) *)
  match e with
  | Var(x, _) -> k x
  | _ ->
      let x = Id.gentmp t in
      let e', t' = k x in
      Let((x, t), e, e', p), t'


  | Syntax.Floor(e, p) ->
      insert_let p (g env e)
        (fun x -> Floor(x, p), Type.Float)

  | Syntax.Recur(x, p) ->
      let (x', t) = g env x in
      insert_let p (x', t) (fun x -> Recur(x, p), t)

insert_let (rx, rt) (fun a -> Recur(a, p), rt) ->


let x = Id.gentmp rt in
let e', t' = (fun a -> Recur(a, p), rt) x in

e' = Recur(x, p), t' = rt

Let((x, t), rx, Recur(x, p), p), rt



(fun a -> Recur(a, p), t) x -> Recur(x, p), rt
