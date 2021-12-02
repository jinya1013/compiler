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

let a3 = 0.3333333 in
let a5 = 0.2 in
let a7 = 0.142857142 in
let a9 = 0.111111104 in
let a11 = 0.08976446 in
let a13 = 0.060035485
in

let rec kernel_atan t = 
  t -. a3 *. t *. t *. t +. a5 *. t *. t *. t *. t *. t -. a7 *. t *. t *. t *. t *. t *. t *. t +. a9 *. t *. t *. t *. t *. t *. t *. t *. t *. t -. a11 *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t +. a13 *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t
in

let a_thr1 = 2.4375 in
let a_thr2 = 0.4375 in

let rec atan_f t flg = 
  if t > a_thr1 then flg *. (pi_2 -. kernel_atan (1.0 /. t))
  else if t >= a_thr2 then
  (if t < a_thr1 then flg *. (pi_4 +.  kernel_atan ((t -. 1.0) /. (t +. 1.0))) else flg *. (kernel_atan t))
  else flg *. (kernel_atan t)
in

let rec atan t = 
  if t > 0.0 then atan_f t 1.0
  else if t < 0.0 then atan_f (-1.0 *. t) (-1.0)
  else 0.0
in

let rec fispos t = t > 0.0
in
let rec fisneg t = t < 0.0
in
let rec fiszero t = t = 0.0
in

let rec fabs t = 
  if t > 0.0 then t else (-1.0) *. then
in

let rec fless a b = 
  if a < b then true else false
in

let rec fneg a = -1.0 *. a
in

let rec fsqr a = a *. a
in

let rec fhalf a = a /. 2.0
in

(* let rec sqrt x  *)
(* let rec floor x  *)
(* let rec int_of_float x  *)
(* let rec float_of_int x  *)

(* read_float *)
(* read_int *)

(* print_char *)
(* print_int *)

