type t = (* MinCamlの型を表現するデータ型 (caml2html: type_t) *)
  | Unit
  | Bool
  | Int
  | Float
  | Fun of t list * t (* arguments are uncurried *)
  | Tuple of t list
  | Array of t
  | Var of t option ref

let gentyp () = Var(ref None) (* 新しい型変数を作る *)

let rec output_type outchan s = 
  match s with
  | Unit -> output_string outchan "Unit"
  | Bool -> output_string outchan "Bool"
  | Int -> output_string outchan "Int"
  | Float -> output_string outchan "Float"
  | Fun(t1s, t2) -> 
  (
    output_string outchan " Fun ( (";
    (
      match t1s with
      | th :: tt ->
      (
        output_type outchan th;
        List.iter (fun t -> output_string outchan ", "; output_type outchan t) tt; 
      )
      | _ -> ()
    );
    output_string outchan ") -> ";
    output_type outchan t2;
    output_string outchan " )";
  )
  | Tuple(ts) -> 
  (
    match ts with
    | th :: tt -> 
    (
      output_string outchan "(";
      output_type outchan th;
      List.iter (fun t -> output_string outchan " * "; output_type outchan t) tt;
      output_string outchan ")";

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
    (
      match  !tref with
    | None -> output_string outchan "None"
    | Some(x) -> output_type outchan x
    );
    output_string outchan " )";
  )
  and output_type_list outchan ts = 
    let f t = 
      output_string outchan ", ";
      output_type outchan t in
    output_type outchan (List.hd ts);
    List.iter f ts


