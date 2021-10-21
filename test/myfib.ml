let a = Array.create 5 3 in
let x = a.(0) in
a.(0) <- 1;
let y = a.(0) in
let z = print_int (x - y) in
let x = let z = 12 in z + 2 in
let y = let n = 12 in n + 2 in
let z = print_int (x + y) in
let x = print_int 12 in 
let y = print_int 12 in ()
