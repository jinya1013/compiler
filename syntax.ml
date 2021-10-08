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
    if b then 
    (
      Id.output_tab outchan depth;
      output_string outchan "B00L TRUE"
    )
    else 
    (
      Id.output_tab outchan depth;
      output_string outchan "BOOL FALSE"
    )
  )
  | Int i -> 
  (
    Id.output_tab outchan depth;
    output_string outchan ("INT " ^ (string_of_int i))
  )
  | Float f -> 
  (
    Id.output_tab outchan depth;
    output_string outchan ("FLOAT " ^ (string_of_float f))
  )
  | Not t ->
  (
    Id.output_tab outchan depth;
    output_string outchan "NOT";
    output_syntax outchan t (depth + 1);
  )
  | Neg t ->
  (
    Id.output_tab outchan depth;
    output_string outchan "NEG";
    output_syntax outchan t (depth + 1);
  )
  | Add (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "ADD";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | Sub (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "SUB";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | FNeg t ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FNEG";
    output_syntax outchan t (depth + 1);
  )
  | FAdd (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FADD";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | FSub (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FSUB";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | FMul (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FMUL";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | FDiv (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "FDIV";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | Eq (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "EQ";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | LE (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "LE";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | If (c, t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "IF";
    output_syntax outchan c (depth + 1);
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | Let (t1, t2, t3) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "LET";
    Id.output_id outchan (fst t1);
    output_syntax outchan t2 (depth + 1);
    output_syntax outchan t3 (depth + 1);
  )
  | Var (x) -> 
  (
    Id.output_tab outchan depth;
    output_string outchan "VAR ";
    Id.output_id outchan x;
  )
  | LetRec ({ name = f; args = a; body = b }, t) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "LETREC";
    Id.output_tab outchan depth;
    output_string outchan "{";
    Id.output_tab outchan (depth + 1);
    output_string outchan "name = ";
    Id.output_id outchan (fst f);
    Id.output_tab outchan (depth + 1);
    output_string outchan "args = ";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split a));
    output_string outchan ")";
    Id.output_tab outchan (depth + 1);
    output_string outchan "body = ";
    output_syntax outchan b (depth + 2);
    Id.output_tab outchan depth;
    output_string outchan "}";
    output_syntax outchan t (depth + 1); 
  )

  | App (t, ts) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "APP";
    output_syntax outchan t (depth + 1);
    output_syntax_list outchan ts (depth + 1);
  )
  | Tuple (ts) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "(";
    output_syntax_list outchan ts (depth + 1);
    output_string outchan ")";
  )
  | LetTuple (t1s, t2, t3) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "LET";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan ")";
    output_syntax outchan t2 (depth + 1);
    output_syntax outchan t3 (depth + 1);
  )
  | Array (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "ARRAY";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | Get (t1, t2) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "GET";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | Put (t1, t2, t3) ->
  (
    Id.output_tab outchan depth;
    output_string outchan "PUT";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
    output_syntax outchan t3 (depth + 1);
  )
and output_syntax_list outchan ts depth = 
  let f t = 
    output_syntax outchan t (depth + 1) in
  output_syntax outchan (List.hd ts) (depth + 1);
  List.iter f (List.tl ts)