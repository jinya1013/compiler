let rec ack x y k =
	if x <= 0 then k (y + 1) else
	if y <= 0 then ack (x - 1) 1 (fun r -> k r)
	else ack x (y - 1) (fun r -> ack (x - 1) r k)
in ack 3 10 (fun k -> print_int k)