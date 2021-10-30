let rec fib n =
  if n <= 1 then n else
  fib (n - 1) + fib (n - 2) in
print_int (fib 30)


(* fib 3 
-> 
if 3 <= 1 then 3 else
  fib (2) + fib (1)
->
fib (2) + fib (1)
-> 
(if 2 <= 1 then 2 else
  fib (1) + fib (0)) + fib(1)
->
fib (1) + fib (0) + fib(1)
-> 
(if 1 <= 1 then 1 else
  fib (0) + fib (-1)) + fib(0) + fib(1)
->
1 + fib(0) + fib(1)
->
1 + 0 + 1
->
2 *)