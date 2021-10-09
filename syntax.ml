type pos = int
type t = (* MinCamlの構文を表現するデータ型 (caml2html: syntax_t) *)
  | Unit of pos
  | Bool of bool * pos 
  | Int of int * pos 
  | Float of float * pos 
  | Not of t * pos 
  | Neg of t * pos 
  | Add of t * t * pos 
  | Sub of t * t * pos 
  | FNeg of t * pos 
  | FAdd of t * t * pos 
  | FSub of t * t * pos 
  | FMul of t * t * pos 
  | FDiv of t * t * pos 
  | Eq of t * t * pos 
  | LE of t * t * pos 
  | If of t * t * t * pos 
  | Let of (Id.t * Type.t) * t * t * pos 
  | Var of Id.t * pos 
  | LetRec of fundef * t * pos 
  | App of t * t list * pos
  | Tuple of t list * pos
  | LetTuple of (Id.t * Type.t) list * t * t * pos
  | Array of t * t * pos
  | Get of t * t * pos
  | Put of t * t * t * pos
and fundef = { name : Id.t * Type.t; args : (Id.t * Type.t) list; body : t }


let top_pos:pos = 0


let rec output_syntax outchan s = 
  match s with
  | Unit(p)  -> ()
  | Bool(b,p) -> 
  (
    if b then output_string outchan "true"
    else output_string outchan "false"
  )
  | Int(i,p) -> output_string outchan (string_of_int i)
  | Float (f,p) -> output_string outchan (string_of_float f)
  | Not (t,p) ->
  (
    output_string outchan "Not( ";
    output_syntax outchan t;
    output_string outchan " )"
  )
  | Neg (t,p) ->
  (
    output_string outchan "Neg( ";
    output_syntax outchan t;
    output_string outchan " )"
  )
  | Add (t1, t2,p) ->
  (
    output_string outchan "Add( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | Sub (t1, t2, p) ->
  (
    output_string outchan "Sub( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | FNeg (t,p) ->
  (
    output_string outchan "FNeg( ";
    output_syntax outchan t;
    output_string outchan " )"
  )
  | FAdd (t1, t2, p) ->
  (
    output_string outchan "FAdd( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | FSub (t1, t2, p) ->
  (
    output_string outchan "FSub( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | FMul (t1, t2, p) ->
  (
    output_string outchan "FMul( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | FDiv (t1, t2, p) ->
  (
    output_string outchan "FDiv( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | Eq (t1, t2, p) ->
  (
    output_string outchan "Eq( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | LE (t1, t2, p) ->
  (
    output_string outchan "LE( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | If (c, t1, t2, p) ->
  (
    output_string outchan "If( ";
    output_syntax outchan c;
    output_string outchan ", ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | Let (t1, t2, t3, p) ->
  (
    output_string outchan "Let( ";
    Id.output_id outchan (fst t1);
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan ", ";
    output_syntax outchan t3;
    output_string outchan " )"
  )
  | Var (x, p) -> Id.output_id outchan x
  | LetRec ({ name = f; args = a; body = b }, t, p) ->
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

  | App (t, ts, p) ->
  (
    output_string outchan "App( ";
    output_syntax outchan t;
    output_syntax_list outchan ts;
    output_string outchan " )"
  )
  | Tuple (ts, p) ->
  (
    output_string outchan "( ";
    output_syntax_list outchan ts;
    output_string outchan " )";
  )
  | LetTuple (t1s, t2, t3, p) ->
  (
    output_string outchan "Let( ( ";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan " ), ";
    output_syntax outchan t2;
    output_string outchan ", ";
    output_syntax outchan t3;
    output_string outchan " )";
  )
  | Array (t1, t2, p) ->
  (
    output_string outchan "Array( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | Get (t1, t2, p) ->
  (
    output_string outchan "Get( ";
    output_syntax outchan t1;
    output_string outchan ", ";
    output_syntax outchan t2;
    output_string outchan " )"
  )
  | Put (t1, t2, t3, p) ->
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
    



