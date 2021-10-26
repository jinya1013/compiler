let rec make_adder x =
  let rec adder y = x + y in
  adder in
print_int ((make_adder 3) 7)


(*
  let rec adder y x = x + y in
  let rec make_adder x = adder in
  print_int ((make_adder 3) 7)
  let rec make_adder x =
    let rec adder y = x + y in
    adder in
  print_int ((make_adder 3) 7)

  になって欲しいが....
*)
