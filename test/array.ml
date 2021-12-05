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
let rec mat_add x y = 
  x.(0) <- x.(0) + y.(0);
  x.(1) <- x.(1) - y.(1);
  x.(2) <- x.(2) * y.(2);
in
let a = Array.make 3 5 in
let b = Array.make 3 4 in
let z = mat_add a b in
let x = a.(0) in
let y = a.(1) in
let z = a.(2) in
print_int x;
print_int y;
print_int z;