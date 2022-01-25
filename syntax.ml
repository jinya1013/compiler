exception CombineError

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
  | FSqrt of t * pos
  | Floor of t * pos
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

let none_pos:pos = -1
let top_pos:pos = 0

let get_pos = function
  | Unit(p) -> p
  | Bool (_, p) | Int (_, p) | Float (_, p) | Not (_, p) | Neg (_, p) | FNeg (_, p) | FSqrt (_, p) | Floor (_, p) | Var (_, p) | Tuple (_, p) -> p
  | Add (_, _, p) | Sub (_, _, p) | FAdd (_, _, p) | FSub (_, _, p) | FMul (_, _, p) | FDiv (_, _, p) | LetRec (_, _, p) | App (_, _, p) -> p
  | Eq (_, _, p) | LE (_, _, p) | Array (_, _, p) | Get (_, _, p) -> p
  | If (_, _, _, p) | Let (_, _, _, p) | LetTuple (_, _, _, p) | Put (_, _, _, p) -> p

let rec combine e1 e2 = 
  match e1 with
| Let((x, t), f1, f2, _) -> Let((x, t), f1, combine f2 e2, 0)
| LetRec({ name=(x, t); args=yts; body=f1 }, f2, _) -> LetRec({ name=(x, t); args=yts; body=f1 }, combine f2 e2, 0)
| Unit(_) -> e2
| _ -> raise CombineError
  

let rec output_syntax outchan s depth = 
(* 
    与えられた式sをチャネルoutchanに出力する.

    Args
        outchan : out_channel
          出力先のチャンネル
        s : Syntax.t
          出力する式
        depth : int
          構文解析木の深さ

    Returns
        retval : unit
          なし            
*)
  match s with
  | Unit(p)  -> 
  (
    Id.output_tab2 outchan (depth + 1) p
  )
  | Bool(b,p) -> 
  (
    if b then 
    (
      Id.output_tab2 outchan depth p;
      output_string outchan "BOOL TRUE"
    )
    else 
    (
      Id.output_tab2 outchan depth p;
      output_string outchan "BOOL FALSE"
    )
  )
  | Int (i,p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan ("INT " ^ (string_of_int i))
  )
  | Float (f,p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan ("FLOAT " ^ (string_of_float f))
  )
  | Not (t,p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "NOT";
    output_syntax outchan t (depth + 1);
  )
  | Neg (t,p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "NEG";
    output_syntax outchan t (depth + 1);
  )
  | Add (t1, t2,p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "ADD";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | Sub (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "SUB";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | FNeg (t,p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FNEG";
    output_syntax outchan t (depth + 1);
  )
  | FAdd (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FADD";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | FSub (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FSUB";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | FMul (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FMUL";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | FDiv (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FDIV";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
   | FSqrt (t,p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FSQRT";
    output_syntax outchan t (depth + 1);
  )
   | Floor (t,p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "FLOOR";
    output_syntax outchan t (depth + 1);
  )
  | Eq (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "EQ";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | LE (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LE";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | If (c, t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "IF";
    output_syntax outchan c (depth + 1);
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | Let (t1, t2, t3, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LET ";
    Id.output_id outchan (fst t1);
    output_string outchan " : ";
    Type.output_type outchan (snd t1);
    output_syntax outchan t2 (depth + 1);
    output_syntax outchan t3 (depth + 1);
  )
  | Var (x, p) -> 
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "VAR ";
    Id.output_id outchan x;
  )
  | LetRec ({ name = f; args = a; body = b }, t, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LETREC";
    Id.output_tab2 outchan depth p;
    output_string outchan "{";
    Id.output_tab2 outchan (depth + 1) p;
    output_string outchan "name = ";
    Id.output_id outchan (fst f);
    Id.output_tab2 outchan (depth + 1) p;
    output_string outchan "args = ";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split a));
    output_string outchan ")";
    Id.output_tab2 outchan (depth + 1) p;
    output_string outchan "body = ";
    output_syntax outchan b (depth + 2);
    Id.output_tab2 outchan depth p;
    output_string outchan "}";
    output_syntax outchan t (depth + 1); 
  )

  | App (t, ts, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "APP";
    output_syntax outchan t (depth + 1);
    output_syntax_list outchan ts (depth + 1);
  )
  | Tuple (ts, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "(";
    output_syntax_list outchan ts (depth + 1);
    output_string outchan ")";
  )
  | LetTuple (t1s, t2, t3, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "LET";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan ")";
    output_syntax outchan t2 (depth + 1);
    output_syntax outchan t3 (depth + 1);
  )
  | Array (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "ARRAY";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | Get (t1, t2, p) ->
  (
    Id.output_tab2 outchan depth p;
    output_string outchan "GET";
    output_syntax outchan t1 (depth + 1);
    output_syntax outchan t2 (depth + 1);
  )
  | Put (t1, t2, t3, p) ->
  (
    Id.output_tab2 outchan depth p;
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
and output_prog outchan s = 
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
  (
    match s with
  | Unit(p)  -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
  )
  | Bool(b,p) -> 
  (
    if b then 
    (
    output_string outchan ((string_of_int p) ^ "\t");
      output_string outchan "BOOL TRUE"
    )
    else 
    (
    output_string outchan ((string_of_int p) ^ "\t");
      output_string outchan "BOOL FALSE"
    )
  )
  | Int (i,p) -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan ("INT " ^ (string_of_int i))
  )
  | Float (f,p) -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan ("FLOAT " ^ (string_of_float f))
  )
  | Not (t,p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "NOT";
    output_syntax outchan t 1;
  )
  | Neg (t,p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "NEG";
    output_syntax outchan t 1;
  )
  | Add (t1, t2,p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "ADD";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | Sub (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "SUB";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | FNeg (t,p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FNEG";
    output_syntax outchan t 1;
  )
  | FAdd (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FADD";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | FSub (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FSUB";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | FMul (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FMUL";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | FDiv (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FDIV";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | FSqrt (t,p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FSQRT";
    output_syntax outchan t 1;
  )
  | Floor (t,p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "FLOOR";
    output_syntax outchan t 1;
  )
  | Eq (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "EQ";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | LE (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "LE";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | If (c, t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "IF";
    output_syntax outchan c 1;
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | Let (t1, t2, t3, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "LET ";
    Id.output_id outchan (fst t1);
    output_string outchan " : ";
    Type.output_type outchan (snd t1);
    output_syntax outchan t2 1;
    output_syntax outchan t3 1;
  )
  | Var (x, p) -> 
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "VAR ";
    Id.output_id outchan x;
  )
  | LetRec ({ name = f; args = a; body = b }, t, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "LETREC";
    Id.output_tab2 outchan 0 p;
    output_string outchan "{";
    Id.output_tab2 outchan 1 p;
    output_string outchan "name = ";
    Id.output_id outchan (fst f);
    Id.output_tab2 outchan 1 p;
    output_string outchan "args = ";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split a));
    output_string outchan ")";
    Id.output_tab2 outchan 1 p;
    output_string outchan "body = ";
    output_syntax outchan b 2;
    Id.output_tab2 outchan 0 p;
    output_string outchan "}";
    output_syntax outchan t 1; 
  )

  | App (t, ts, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "APP";
    output_syntax outchan t 1;
    output_syntax_list outchan ts 1;
  )
  | Tuple (ts, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "(";
    output_syntax_list outchan ts 1;
    output_string outchan ")";
  )
  | LetTuple (t1s, t2, t3, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "LET";
    output_string outchan "(";
    Id.output_id_list outchan (fst (List.split t1s));
    output_string outchan ")";
    output_syntax outchan t2 1;
    output_syntax outchan t3 1;
  )
  | Array (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "ARRAY";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | Get (t1, t2, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "GET";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
  )
  | Put (t1, t2, t3, p) ->
  (
    output_string outchan ((string_of_int p) ^ "\t");
    output_string outchan "PUT";
    output_syntax outchan t1 1;
    output_syntax outchan t2 1;
    output_syntax outchan t3 1;
  )
  );
  output_string outchan "\n";