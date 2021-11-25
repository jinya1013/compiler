let pi = 3.141592653589793 in
let pi_2 = pi /. 2.0 in
let pi_4 = pi /. 4.0 in

let s3 = 0.16666668 in
let s5 = 0.008332824 in
let s7 = 0.00019587841 in
let rec kernel_sin t = 
  t -. s3 *. t *. t*. t +. s5 *. t *. t *. t *. t *. t -. s7 *. t *. t *. t *. t *. t *. t *. t
in

let c2 = 0.5 in
let c4 = 0.04166368 in
let c6 = 0.0013695068 in
let rec kernel_cos t = 
  1.0 -. c2 *. t *. t +. c4 *. t *. t *. t *. t -. c6 *. t *. t *. t *. t *. t *. t
in


let rec sin_h t flg = 
  if t >= pi_4 then flg *. (kernel_sin (pi_2 -. t))
  else flg *. (kernel_sin t)
in

let rec cos_h t flg = 
  if t >= pi_4 then flg *. (kernel_cos (pi_2 -. t))
  else flg *. (kernel_cos t)
in

let rec sin_g t flg = 
  if t >= pi_2 then sin_h (pi -. t) flg
  else sin_h t flg
in

let rec cos_g t flg = 
  if t >= pi_2 then cos_h (pi -. t) (-1.0 *. flg)
  else cos_h t flg
in

let rec sin_f t flg = 
  if t >= pi then sin_f (t -. pi) (-1.0 *. flg)
  else sin_g t flg
in

let rec cos_f t flg = 
  if t >= pi then cos_f (t -. pi) (-1.0 *. flg)
  else cos_g t flg
in

let rec sin t = 
  if t > 0.0 then sin_f t 1.0
  else if t < 0.0 then sin_f (-1.0 *. t) (-1.0)
  else 0.0
in

let rec cos t = 
  if t > 0.0 then cos_f t 1.0
  else if t < 0.0 then cos_f (-1.0 *. t) 1.0
  else 1.0
in

let x = cos 10.0 in ()
