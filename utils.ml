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

(* 整数の掛け算用 *)
let rec mul_exp2 x y2 = 
  if y2 = 0 then 0 else
  if y2 = 1 then x else
  if y2 = 2 then sll x 1 else
  sll x 2
in
(* 整数の割り用 *)
let rec div_exp2 x y2 = 
  if y2 = 1 then x else
  if y2 = 2 then sra x 1 else
  sra x 2
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

(* min_caml_print_int:
    addi %x7 %x0 1
    addi %x8 %x0 20
    addi %x9 %x0 8
    sll %x7 %x7 %x8
    addi %x7 %x7 -3 #ロード可能かどうかのフラグが格納されているアドレス
    sb %x6 2(%x7) # データを1バイト書く
    sra %x6 %x6 %x9 # 右に8ビットシフト
    sb %x6 2(%x7) # データを1バイト書く
    sra %x6 %x6 %x9 # 右に8ビットシフト
    sb %x6 2(%x7) # データを1バイト書く
    sra %x6 %x6 %x9 # 右に8ビットシフト
    sb %x6 2(%x7) # データを1バイト書く
    jr 0(%x1) *)

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