(* ��ͳ�ѿ��Τ���Ƶ��ؿ� *)
let x = 10 in
let rec f y =
  if y = 0 then 0 else
  x + f (y - 1) in
print_int (f 123)

(*
let rec f y z =
  if y = 0 then 0 else
  z + f (y - 1) z in
let x = 10 in
print_int (f 123 x)
*)
