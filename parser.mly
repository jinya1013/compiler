%{
(* parser�����Ѥ����ѿ����ؿ������ʤɤ���� *)
open Syntax
let addtyp x = (x, Type.gentyp ())
%}

/* (* �����ɽ���ǡ���������� (caml2html: parser_token) *) */
%token <bool> BOOL
%token <int> INT
%token <float> FLOAT
%token NOT
%token MINUS
%token PLUS
%token AST
%token SLASH
%token MINUS_DOT
%token PLUS_DOT
%token AST_DOT
%token SLASH_DOT
%token EQUAL
%token LESS_GREATER
%token LESS_EQUAL
%token GREATER_EQUAL
%token LESS
%token GREATER
%token IF
%token THEN
%token ELSE
%token <Id.t> IDENT
%token LET
%token IN
%token REC
%token LOOP
%token RECUR
%token COMMA
%token ARRAY_CREATE
%token DOT
%token LESS_MINUS
%token SEMICOLON
%token LPAREN
%token RPAREN
%token F_IS_POS
%token F_IS_NEG
%token F_IS_ZERO
%token F_ABS
%token F_LESS
%token F_NEG
%token F_SQR
%token F_HALF
%token SQRT
%token FLOOR
%token EOF



/* (* ͥ���̤�associativity��������㤤������⤤���ء� (caml2html: parser_prior) *) */
%nonassoc IN
%nonassoc LOOP RECUR
%right prec_let
%right SEMICOLON
%right prec_if
%right LESS_MINUS
%nonassoc prec_tuple
%left COMMA
%left EQUAL LESS_GREATER LESS GREATER LESS_EQUAL GREATER_EQUAL F_LESS
%left PLUS MINUS PLUS_DOT MINUS_DOT
%left AST SLASH AST_DOT SLASH_DOT
%nonassoc F_IS_POS F_IS_NEG F_IS_ZERO F_ABS F_NEG F_SQR F_HALF SQRT FLOOR
%right prec_unary_minus
%left prec_app
%left DOT

/* (* ���ϵ������� *) */
%type <Syntax.t> exp
%start exp

%%

simple_exp: /* (* ��̤�Ĥ��ʤ��Ƥ�ؿ��ΰ����ˤʤ�뼰 (caml2html: parser_simple) *) */
| LPAREN exp RPAREN
    { $2 }
| LPAREN RPAREN
    { Unit((Parsing.symbol_start_pos ()).pos_lnum) }
| BOOL
    { Bool($1, ((Parsing.symbol_start_pos ()).pos_lnum)) }
| INT
    { Int($1, ((Parsing.symbol_start_pos ()).pos_lnum)) }
| FLOAT
    { Float($1, ((Parsing.symbol_start_pos ()).pos_lnum)) }
| IDENT
    { Var($1, ((Parsing.symbol_start_pos ()).pos_lnum)) }
| simple_exp DOT LPAREN exp RPAREN
    { Get($1, $4, ((Parsing.symbol_start_pos ()).pos_lnum)) }

exp: /* (* ���̤μ� (caml2html: parser_exp) *) */
| simple_exp
    { $1 }
| NOT exp
    %prec prec_app
    { Not($2, ((Parsing.symbol_start_pos ()).pos_lnum)) }
| MINUS exp
    %prec prec_unary_minus
    { match $2 with
    | Float(f, p) -> Float((-.f), p) (* -1.23�ʤɤϷ����顼�ǤϤʤ��Τ��̰��� *)
    | e -> (Neg(e, (Parsing.symbol_start_pos ()).pos_lnum)) }
| F_NEG exp
    { FMul(Float(-1.0, (Parsing.symbol_start_pos ()).pos_lnum), $2, (Parsing.symbol_start_pos ()).pos_lnum) }

| exp PLUS exp /* (* ­������ʸ���Ϥ���롼�� (caml2html: parser_add) *) */
    { Add($1, $3, (Parsing.symbol_start_pos ()).pos_lnum) }
| exp MINUS exp
    { Sub($1, $3, (Parsing.symbol_start_pos ()).pos_lnum) }
| exp AST exp
    { App(Var("mul_exp2", (Parsing.symbol_start_pos ()).pos_lnum), [$1;$3], (Parsing.symbol_start_pos ()).pos_lnum) }
| exp SLASH exp
    { App(Var("div_exp2", (Parsing.symbol_start_pos ()).pos_lnum), [$1;$3], (Parsing.symbol_start_pos ()).pos_lnum) }

| exp EQUAL exp
    { Eq($1, $3, (Parsing.symbol_start_pos ()).pos_lnum) }
| exp LESS_GREATER exp
    { Not(Eq($1, $3, (Parsing.symbol_start_pos ()).pos_lnum), (Parsing.symbol_start_pos ()).pos_lnum) }
| exp LESS exp
    { Not(LE($3, $1, (Parsing.symbol_start_pos ()).pos_lnum), (Parsing.symbol_start_pos ()).pos_lnum) }
| exp GREATER exp
    { Not(LE($1, $3, (Parsing.symbol_start_pos ()).pos_lnum), (Parsing.symbol_start_pos ()).pos_lnum) }
| exp LESS_EQUAL exp
    { LE($1, $3, (Parsing.symbol_start_pos ()).pos_lnum) }
| exp GREATER_EQUAL exp
    { LE($3, $1, (Parsing.symbol_start_pos ()).pos_lnum) }

| F_IS_POS exp
    { Not(LE($2, Float(0.0, (Parsing.symbol_start_pos ()).pos_lnum), (Parsing.symbol_start_pos ()).pos_lnum), (Parsing.symbol_start_pos ()).pos_lnum) }
| F_IS_NEG exp
    { Not(LE(Float(0.0, (Parsing.symbol_start_pos ()).pos_lnum), $2, (Parsing.symbol_start_pos ()).pos_lnum), (Parsing.symbol_start_pos ()).pos_lnum) }
| F_IS_ZERO exp
    { Eq($2, Float(0.0, (Parsing.symbol_start_pos ()).pos_lnum), (Parsing.symbol_start_pos ()).pos_lnum) }
| F_LESS simple_exp simple_exp
    { Not(LE($3, $2, (Parsing.symbol_start_pos ()).pos_lnum), (Parsing.symbol_start_pos ()).pos_lnum) }
| F_ABS exp
    { If(LE($2, Float(0.0, (Parsing.symbol_start_pos ()).pos_lnum), (Parsing.symbol_start_pos ()).pos_lnum),
    FMul(Float(-1.0, (Parsing.symbol_start_pos ()).pos_lnum), $2, (Parsing.symbol_start_pos ()).pos_lnum), 
    $2,
    (Parsing.symbol_start_pos ()).pos_lnum) }


| IF exp THEN exp ELSE exp
    %prec prec_if
    { If($2, $4, $6, (Parsing.symbol_start_pos ()).pos_lnum) }
| MINUS_DOT exp
    %prec prec_unary_minus
    { FNeg($2, (Parsing.symbol_start_pos ()).pos_lnum) }
| exp PLUS_DOT exp
    { FAdd($1, $3, (Parsing.symbol_start_pos ()).pos_lnum) }
| exp MINUS_DOT exp
    { FSub($1, $3, (Parsing.symbol_start_pos ()).pos_lnum) }
| exp AST_DOT exp
    { FMul($1, $3, (Parsing.symbol_start_pos ()).pos_lnum) }
| exp SLASH_DOT exp
    { FDiv($1, $3, (Parsing.symbol_start_pos ()).pos_lnum) }

| F_SQR exp
    { FMul($2, $2, (Parsing.symbol_start_pos ()).pos_lnum) }
| F_HALF exp
    { FDiv($2, Float(2.0, (Parsing.symbol_start_pos ()).pos_lnum), (Parsing.symbol_start_pos ()).pos_lnum) }
| SQRT exp
    { FSqrt($2, (Parsing.symbol_start_pos ()).pos_lnum) }
| FLOOR exp
    { Floor($2, (Parsing.symbol_start_pos ()).pos_lnum) }
| LET IDENT EQUAL exp IN exp SEMICOLON
    %prec prec_let
    { Let(addtyp $2, $4, $6, (Parsing.symbol_start_pos ()).pos_lnum) }
| LET IDENT EQUAL exp IN exp
    %prec prec_let
    { Let(addtyp $2, $4, $6, (Parsing.symbol_start_pos ()).pos_lnum) }
| LET REC fundef IN exp
    %prec prec_let
    { LetRec($3, $5, (Parsing.symbol_start_pos ()).pos_lnum) }
| simple_exp actual_args
    %prec prec_app
    { App($1, $2, (Parsing.symbol_start_pos ()).pos_lnum) }
| elems
    %prec prec_tuple
    { Tuple($1, (Parsing.symbol_start_pos ()).pos_lnum) }
| LET LPAREN pat RPAREN EQUAL exp IN exp
    { LetTuple($3, $6, $8, (Parsing.symbol_start_pos ()).pos_lnum) }
| simple_exp DOT LPAREN exp RPAREN LESS_MINUS exp
    { Put($1, $4, $7, (Parsing.symbol_start_pos ()).pos_lnum) }
| exp SEMICOLON exp SEMICOLON
    { Let((Id.gentmp Type.Unit, Type.Unit), $1, $3, (Parsing.symbol_start_pos ()).pos_lnum) }
| exp SEMICOLON exp
    { Let((Id.gentmp Type.Unit, Type.Unit), $1, $3, (Parsing.symbol_start_pos ()).pos_lnum) }
| ARRAY_CREATE simple_exp simple_exp
    %prec prec_app
    { Array($2, $3, (Parsing.symbol_start_pos ()).pos_lnum) }
| LOOP IDENT EQUAL exp IN exp
    { Loop(addtyp $2, $4, $5, (Parsing.symbol_start_pos ()).pos_lnum) }
| RECUR exp
    { Recur($2, (Parsing.symbol_start_pos ()).pos_lnum) }
| error
    { failwith
        (Printf.sprintf "parse error near characters %d-%d in line %d-%d"
           (Parsing.symbol_start ())
           (Parsing.symbol_end ())
           ((Parsing.symbol_start_pos ()).pos_lnum)
           ((Parsing.symbol_end_pos ()).pos_lnum)) }

fundef:
| IDENT formal_args EQUAL exp
    { { name = addtyp $1; args = $2; body = $4 } }

formal_args:
| IDENT formal_args
    { addtyp $1 :: $2 }
| IDENT
    { [addtyp $1] }

actual_args:
| actual_args simple_exp
    %prec prec_app
    { $1 @ [$2] }
| simple_exp
    %prec prec_app
    { [$1] }

elems:
| elems COMMA exp
    { $1 @ [$3] }
| exp COMMA exp
    { [$1; $3] }

pat:
| pat COMMA IDENT
    { $1 @ [addtyp $3] }
| IDENT COMMA IDENT
    { [addtyp $1; addtyp $3] }
