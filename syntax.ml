type t = (* MinCamlの構文を表現するデータ型 (caml2html: syntax_t) *)
  | Unit
  | Bool of bool
  | Int of int
  | Float of float
  | Not of t
  | Neg of t
  | Add of t * t
  | Sub of t * t
  | FNeg of t
  | FAdd of t * t
  | FSub of t * t
  | FMul of t * t
  | FDiv of t * t
  | Eq of t * t
  | LE of t * t
  | If of t * t * t
  | Let of (Id.t * Type.t) * t * t
  | Var of Id.t
  | LetRec of fundef * t
  | App of t * t list
  | Tuple of t list
  | LetTuple of (Id.t * Type.t) list * t * t
  | Array of t * t
  | Get of t * t
  | Put of t * t * t
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }

let output_tab outchan depth = 
  let rec _output_tab iter = 
    match iter with
    | 0 -> ()
    | _ -> 
    (
      output_string outchan "\t";
      _output_tab (iter-1)
    )
    in _output_tab depth


let rec output_syntax outchan s depth = 
(* 
    与えられた式sをチャネルoutchanに出力する.

    Args
        outchan : out_channel
          出力先のチャンネル
        s : Syntax.t
          出力する式

    Returns
        retval : unit
          なし            
*)
  match s with
  | Unit -> ()
  | Bool b -> 
  (
    if b then output_string outchan "B00L TRUE\n"
    else output_string outchan "BOOL FALSE\n"
  )
  | Int i -> output_string outchan ("INT " ^ (string_of_int i) ^ "\n")
  | Float f -> output_string outchan ("FLOAT " ^ (string_of_float f) ^ "\n")
  | Not t ->
  (
    output_string outchan "NOT\n\t";
    output_tab outchan depth;
    output_syntax outchan t (depth + 1);
    output_string outchan "\n";
  )
  | Neg t ->
  (
    output_string outchan "NEG\n\t";
    output_tab outchan depth;
    output_syntax outchan t (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | Add (t1, t2) ->
  (
    output_string outchan "ADD\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | Sub (t1, t2) ->
  (
    output_string outchan "SUB\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;


  )
  | FNeg t ->
  (
    output_string outchan "FNEG\n\t";
    output_tab outchan depth;
    output_syntax outchan t (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | FAdd (t1, t2) ->
  (
    output_string outchan "FADD\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | FSub (t1, t2) ->
  (
    output_string outchan "FSUB\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | FMul (t1, t2) ->
  (
    output_string outchan "FMUL\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | FDiv (t1, t2) ->
  (
    output_string outchan "FDIV\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | Eq (t1, t2) ->
  (
    output_string outchan "EQ\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | LE (t1, t2) ->
  (
    output_string outchan "LE\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | If (c, t1, t2) ->
  (
    output_string outchan "IF\n\t";
    output_tab outchan depth;
    output_syntax outchan c (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | Let (t1, t2, t3) ->
  (
    output_string outchan "LET\n\t";
    output_tab outchan depth;
    Id.output_id outchan (fst t1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t3 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | Var (x) -> 
  (
    output_string outchan "VAR\n\t";
    output_tab outchan depth;
    Id.output_id outchan x;
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | LetRec ({ name = f; args = a; body = b }, t) ->
  (
    output_string outchan "LETREC\n";
    output_tab outchan depth;
    output_string outchan "{\n";
    output_tab outchan depth;
    output_string outchan "name = ";
    Id.output_id outchan (fst f);
    output_string outchan "\n";
    output_tab outchan depth;
    output_string outchan "args = \n";
    output_tab outchan depth;
    output_string outchan "(\n";
    output_tab outchan depth;
    Id.output_id_list outchan (fst (List.split a));
    output_string outchan " )\n";
    output_tab outchan depth;
    output_string outchan "body = ";
    output_syntax outchan b (depth + 1);
    output_string outchan " }\n";
    output_syntax outchan t (depth + 1); 
    output_string outchan "\n";
  )

  | App (t, ts) ->
  (
    output_string outchan "APP\n\t";
    output_syntax outchan t (depth + 1);
    output_syntax_list outchan ts (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | Tuple (ts) ->
  (
    output_string outchan "(\n\t";
    output_tab outchan depth;
    output_syntax_list outchan ts (depth + 1);
    output_tab outchan depth;
    output_string outchan ")\n";
    output_tab outchan depth;
  )
  | LetTuple (t1s, t2, t3) ->
  (
    output_string outchan "LET\n";
    output_tab outchan depth;
    output_string outchan "(\n";
    output_tab outchan depth;
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan ")\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t3 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | Array (t1, t2) ->
  (
    output_string outchan "ARRAY\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | Get (t1, t2) ->
  (
    output_string outchan "GET\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
  | Put (t1, t2, t3) ->
  (
    output_string outchan "PUT\n\t";
    output_tab outchan depth;
    output_syntax outchan t1 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t2 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t3 (depth + 1);
    output_string outchan "\n";
    output_tab outchan depth;
  )
and output_syntax_list outchan ts depth = 
  let f t = 
    output_string outchan "\n";
    output_tab outchan depth;
    output_syntax outchan t (depth + 1) in
  output_syntax outchan (List.hd ts) (depth + 1);
  List.iter f (List.tl ts)