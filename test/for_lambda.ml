let rec f x =
  let rec g s = 
    let rec h a = 
      x + s - a in
    x + (h 0) in
  g x in
print_int (f 2)