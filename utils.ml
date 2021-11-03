let utils_pi = 3.141592653589793 in

let rec _newton x a iter =
  if iter = 0
  then x
  else _newton (x -. (x *. x -. a) /. (2.0 *. x)) a (iter - 1) in
let rec sqrt a = _newton a a 5 in 

let rec _power x n  = 
  if n = 0
  then 1.0
  else x *. (_power x (n - 1)) in
let rec _fact n = 
  if n <= 1
  then 1
  else n * (_fact (n - 1)) in
let rec _sgn x =
  if 0.0 < x then 1.0
  else -1.0 in
let rec _g p1 p2 = 
  let (p1x, p1y) = p1 in
  let (p2x, p2y) = p2 in
  if p1x +. p2x = 0.0 then 
  0.0, 1.0
  else
    let qx = (p1x +. p2x) /. 2.0 in
    let qy = (p1y +. p2y) /. 2.0 in
    let k = sqrt(qx *. qx +. qy *. qy) in
    qx /. k, qy /. k in
let rec _f_sub t t1 t2 p1 p2 = 
  if (t2 -. t1) > 0.0000000001
  then
    let t3 = (t1 +. t2) /. 2 in
    if t3 < t
    then
      _f_sub t t3 t2 (_g (p1, p2)) p2
    else
      _f_sub t t1 t3 p1 (_g (p1, p2))
  else
    p1 in
let rec _f t = 
  let t1 = 0.0 in
  let t2 = utils_pi in
  let p1 = (1.0, 0.0) in
  let p2 = (-1.0, 0.0) in
  _f_sub t t1 t2 p1 p2 in
let rec sin t =
  let (s, c) = f t in s in
let rec cos t =
  let (s, c) = f t in c in
let rec atan_sub x acc iter = 
  if iter = 10
  then
    acc
  else
    (_power (-1.0) (iter - 1)) /. (2 *. (itof iter) -. 1.0) *. (_power x (2 * iter - 1)) +. (atan_sub x acc (iter + 1)) in
let rec atan x =
  atan_sub x 0.0 0 in
let rec floor x = 

(* 
def f(t):
    t1 = 0
    t2 = pi
    p1 = [1.0, 0.0]
    p2 = [-1.0, 0.0]
    while t2 - t1 > 0.000000000000001:
        t3 = (t1 + t2) / 2
        if t3 < t:
            t1 = t3
            p1 = g(p1, p2)
        else:
            t2 = t3
            p2 = g(p1, p2)
    return p1 
*)


let rec sin x = 
  
(* def g(p1, p2):
    if (p1[0] + p2[0]) == 0:
        return [0.0, 1.0]
    p = [(p1[0] + p2[0]) / 2, (p1[1] + p2[1]) / 2]
    k = math.sqrt(p[0] ** 2 + p[1] ** 2)
    return [p[0] / k, p[1] / k] *)