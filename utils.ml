let rec kernel_sin t = 
  t -. 0.16666668 *. t *. t*. t +. 0.008332824 *. t *. t *. t *. t *. t -. 0.00019587841 *. t *. t *. t *. t *. t *. t *. t
in

let rec kernel_cos t = 
  1.0 -. 0.5 *. t *. t +. 0.04166368 *. t *. t *. t *. t -. 0.0013695068 *. t *. t *. t *. t *. t *. t
in

let rec sin_h t flg = 
  if t > 0.78539816339 then flg *. (kernel_cos (1.57079632679 -. t))
  else flg *. (kernel_sin t)
in

let rec cos_h t flg = 
  if t > 0.78539816339 then flg *. (kernel_sin (1.57079632679 -. t))
  else flg *. (kernel_cos t)
in

let rec sin_g t flg = 
  if t >= 1.57079632679 then sin_h (3.141592653589793 -. t) flg
  else sin_h t flg
in

let rec cos_g t flg = 
  if t >= 1.57079632679 then cos_h (3.141592653589793 -. t) (-1.0 *. flg)
  else cos_h t flg
in

let rec sin_f t flg = 
  if t >= 3.141592653589793 then sin_g (t -. 3.141592653589793) (-1.0 *. flg)
  else sin_g t flg
in

let rec cos_f t flg = 
  if t >= 3.141592653589793 then cos_g (t -. 3.141592653589793) (-1.0 *. flg)
  else cos_g t flg
in

let rec reduction_g t p = 
  if t >= 6.28318530718 then
  (if t >= p then reduction_g (t -. p) (p /. 2.0) else reduction_g t (p /. 2.0))
  else t
in

let rec reduction_f t p = 
  if t >= p then reduction_f t (2.0 *. p)
  else reduction_g t p
in

let rec sin t = 
  if t > 0.0 then sin_f (reduction_f t 6.28318530718) 1.0
  else if t < 0.0 then sin_f (reduction_f (-1.0 *. t) 6.28318530718) (-1.0)
  else 0.0
in

let rec cos t = 
  if t > 0.0 then cos_f (reduction_f t 6.28318530718) 1.0
  else if t < 0.0 then cos_f (reduction_f (-1.0 *. t) 6.28318530718) 1.0
  else 1.0
in

let rec kernel_atan t = 
  t -. 0.3333333 *. t *. t *. t +. 0.2 *. t *. t *. t *. t *. t -. 0.142857142 *. t *. t *. t *. t *. t *. t *. t +. 0.111111104 *. t *. t *. t *. t *. t *. t *. t *. t *. t -. 0.08976446 *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t +. 0.060035485 *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t *. t
in

let rec atan_f t flg = 
  if t > 2.4375 then flg *. (1.57079632679 -. kernel_atan (1.0 /. t))
  else if t >= 0.4375 then flg *. (0.78539816339 +. kernel_atan ((t -. 1.0) /. (t +. 1.0)))
  else flg *. (kernel_atan t)
in

let rec atan t = 
  if t > 0.0 then atan_f t 1.0
  else if t < 0.0 then atan_f (-1.0 *. t) (-1.0)
  else 0.0
in

(* 整数の掛け算用 *)
let rec mul_exp2 x y2 = sll x 2
in
(* 整数の割り用 *)
let rec div_exp2 x y2 = sra x 1
in

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
in
let rec hundredth n count = 
  if n - 100 < 0 then (n, count)
  else hundredth (n - 100) (count + 1)
in
let rec tenth n count = 
  if n - 10 < 0 then (n, count)
  else tenth (n - 10) (count + 1)
in
let rec oneth n count = 
  if n - 1 < 0 then (n, count)
  else oneth (n - 1) (count + 1)
in
let rec print_int n = 
  let (n, h) = hundredth n 0 in
  let (n, t) = tenth n 0 in
  let (n, o) = oneth n 0 in
  print_char (encode h);
  print_char (encode t);
  print_char (encode o);
in

let rec fispos t = t > 0.0
in
let rec fisneg t = t < 0.0
in
let rec fiszero t = t = 0.0
in

let rec fabs t = 
  if t > 0.0 then t else (-1.0) *. t
in

let rec fless a b = a < b
in

let rec fneg a = -1.0 *. a
in

let rec fsqr a = a *. a
in

let rec fhalf a = a /. 2.0
in
()