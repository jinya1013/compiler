type t = (* MinCaml�η���ɽ������ǡ����� (caml2html: type_t) *)
  | Unit
  | Bool
  | Int
  | Float
  | Fun of t list * t (* arguments are uncurried *)
  | Tuple of t list
  | Array of t
  | Var of t option ref

let gentyp () = Var(ref None) (* ���������ѿ����� *)

let rec str_of_type = function
| Unit -> "Unit"
| Bool -> "Bool"
| Int -> "Int"
| Float -> "Float"
| Fun(ts, t) -> "Fun("^(List.fold_left (fun a b -> a^", "^b) (List.hd(ts)) (List.tl(ts)))^", "^(str_of_type t)^")"
| Tuple(ts) -> "Tuple("^(List.fold_left (fun a b -> a^", "^b) (List.hd(ts)) (List.tl(ts)))^")"


let rec output_type outchan s = 
  match s with
  | Unit -> output_string outchan "Unit"
  | Bool -> output_string outchan "Bool"
  | Int -> output_string outchan "Int"
  | Float -> output_string outchan "Float"
  | Fun(ts, t) -> 
  (
    List.iter (fun t -> output_type outchan t; output_string outchan " -> ") ts;
    output_type outchan t;
  )
  | Tuple(ts) -> 
  (
    match ts with
    | th :: tt -> 
    (
      output_type outchan th;
      List.iter (fun t -> output_string outchan " * "; output_type outchan t) ts
    )
    | _ -> ()
  )
  | Array(t) ->
  (
    output_string outchan "Array( ";
    output_type outchan t;
    output_string outchan " )"
  )
  | Var(tref) ->
  (
    output_string outchan "Var( ";
    output_type outchan (Option.get !tref);
    output_string outchan " )";
  )
  and output_type_list outchan ts = 
    let f t = 
      output_string outchan ", ";
      output_type outchan t in
    output_type outchan (List.hd ts);
    List.iter f ts

