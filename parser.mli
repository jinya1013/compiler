type token =
  | BOOL of (bool)
  | INT of (int)
  | FLOAT of (float)
  | NOT
  | MINUS
  | PLUS
  | AST
  | SLASH
  | MINUS_DOT
  | PLUS_DOT
  | AST_DOT
  | SLASH_DOT
  | EQUAL
  | LESS_GREATER
  | LESS_EQUAL
  | GREATER_EQUAL
  | LESS
  | GREATER
  | IF
  | THEN
  | ELSE
  | IDENT of (Id.t)
  | LET
  | IN
  | REC
  | COMMA
  | ARRAY_CREATE
  | DOT
  | LESS_MINUS
  | SEMICOLON
  | LPAREN
  | RPAREN
  | F_IS_POS
  | F_IS_NEG
  | F_IS_ZERO
  | F_ABS
  | F_LESS
  | F_NEG
  | F_SQR
  | F_HALF
  | SQRT
  | FLOOR
  | EOF

val exp :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.t
