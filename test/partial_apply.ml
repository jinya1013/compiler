let rec sum n k = if n < 1 then (k 0) else (sum (n-1) (fun x -> (n + x))) in
let result = sum 4 (fun x -> x) in
print_int result