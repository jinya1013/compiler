type t = string (* 変数の名前 (caml2html: id_t) *)
type l = L of string (* トップレベル関数やグローバル配列のラベル (caml2html: id_l) *)

let output_tab outchan depth = 
  let rec _output_tab iter = 
    match iter with
    | 0 -> ()
    | _ -> 
    (
      output_string outchan "\t";
      _output_tab (iter-1)
    )
    in output_string outchan "\n"; _output_tab depth

let rec pp_list = function
  | [] -> ""
  | [x] -> x
  | x :: xs -> x ^ " " ^ pp_list xs

let counter = ref 0
let genid s =
  incr counter;
  Printf.sprintf "%s.%d" s !counter

let rec id_of_typ = function
  | Type.Unit -> "u"
  | Type.Bool -> "b"
  | Type.Int -> "i"
  | Type.Float -> "d"
  | Type.Fun _ -> "f"
  | Type.Tuple _ -> "t"
  | Type.Array _ -> "a" 
  | Type.Var _ -> assert false
let gentmp typ =
  incr counter;
  Printf.sprintf "T%s%d" (id_of_typ typ) !counter

let output_id outchan i = 
  output_string outchan i

let output_id_list outchan is = 
  let f i = 
    output_string outchan ", ";
    output_id outchan i in
  output_id outchan (List.hd is);
  List.iter f is