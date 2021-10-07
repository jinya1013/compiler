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


let rec output_syntax outchan s = 
  match s with
  | Unit -> ()
  | Bool b -> 
  (
    if b then output_string outchan "true"
    else output_string outchan "false"
  )
  | Int i -> output_string outchan (string_of_int i)
  | Float f -> output_string outchan (string_of_float f)
  | Not t ->
  (
    output_string outchan "Not( ";
    output_syntax outchan t;
    output_string outchan " )"
  )
  | Neg t ->
  (
    output_string outchan "Neg( ";
    output_syntax outchan t;
    output_string outchan " )"
  )
  | Add (t1, t2) ->
  (
    output_string outchan "Add( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | Sub (t1, t2) ->
  (
    output_string outchan "Sub( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | FNeg t ->
  (
    output_string outchan "FNeg( ";
    output_syntax outchan t;
    output_string outchan " )"
  )
  | FAdd (t1, t2) ->
  (
    output_string outchan "FAdd( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | FSub (t1, t2) ->
  (
    output_string outchan "FSub( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | FMul (t1, t2) ->
  (
    output_string outchan "FMul( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | FDiv (t1, t2) ->
  (
    output_string outchan "FDiv( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | Eq (t1, t2) ->
  (
    output_string outchan "Eq( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | LE (t1, t2) ->
  (
    output_string outchan "LE( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | If (c, t1, t2) ->
  (
    output_string outchan "If( ";
    output_syntax outchan c;
    output_string outchan ", ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | Let (t1, t2, t3) ->
  (
    output_string outchan "Let( ";
    Id.output_id outchan (fst t1);
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan ", ";
    output_syntax outchan t3;
    output_string outchan " )"
  )
  | Var (x) -> Id.output_id outchan x
  | LetRec ({ name = f; args = a; body = b }, t) ->
  (
    output_string outchan "LetRec( { name = ";
    Id.output_id outchan (fst f);
    output_string outchan ", args = ( ";
    Id.output_id_list outchan (fst (List.split a));
    output_string outchan " ), body = ";
    output_syntax outchan b;
    output_string outchan " }, ";
    output_syntax outchan t;
    output_string outchan " )";
  )

  | App (t, ts) ->
  (
    output_string outchan "App( ";
    output_syntax outchan t;
    output_syntax_list outchan ts;
    output_string outchan " )"
  )
  | Tuple (ts) ->
  (
    output_string outchan "( ";
    output_syntax_list outchan ts;
    output_string outchan " )";
  )
  | LetTuple (t1s, t2, t3) ->
  (
    output_string outchan "Let( ( ";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan " ), ";
    output_syntax outchan t2;
    output_string outchan ", ";
    output_syntax outchan t3;
    output_string outchan " )";
  )
  | Array (t1, t2) ->
  (
    output_string outchan "Array( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | Get (t1, t2) ->
  (
    output_string outchan "Get( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | Put (t1, t2, t3) ->
  (
    output_string outchan "Put( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan ", ";
    output_syntax outchan t3;
    output_string outchan " )"
  )
and output_syntax_list outchan ts = 
  let f t = 
    output_string outchan ", ";
    output_syntax outchan t in
  output_syntax outchan (List.hd ts);
  List.iter f (List.tl ts)
    



