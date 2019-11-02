type token =
  | IDENT of (Tree.ident)
  | MONOP of (Keiko.op)
  | MULOP of (Keiko.op)
  | ADDOP of (Keiko.op)
  | RELOP of (Keiko.op)
  | NUMBER of (int)
  | SEMI
  | DOT
  | COLON
  | LPAR
  | RPAR
  | COMMA
  | MINUS
  | VBAR
  | ASSIGN
  | EOF
  | BADTOK
  | BEGIN
  | DO
  | ELSE
  | END
  | IF
  | THEN
  | WHILE
  | PRINT
  | NEWLINE
  | REPEAT
  | UNTIL
  | LOOP
  | EXIT
  | CASE
  | OF
  | ELSIF

open Parsing;;
let _ = parse_error;;
# 4 "parser.mly"
 
open Keiko
open Tree
# 43 "parser.ml"
let yytransl_const = [|
  263 (* SEMI *);
  264 (* DOT *);
  265 (* COLON *);
  266 (* LPAR *);
  267 (* RPAR *);
  268 (* COMMA *);
  269 (* MINUS *);
  270 (* VBAR *);
  271 (* ASSIGN *);
    0 (* EOF *);
  272 (* BADTOK *);
  273 (* BEGIN *);
  274 (* DO *);
  275 (* ELSE *);
  276 (* END *);
  277 (* IF *);
  278 (* THEN *);
  279 (* WHILE *);
  280 (* PRINT *);
  281 (* NEWLINE *);
  282 (* REPEAT *);
  283 (* UNTIL *);
  284 (* LOOP *);
  285 (* EXIT *);
  286 (* CASE *);
  287 (* OF *);
  288 (* ELSIF *);
    0|]

let yytransl_block = [|
  257 (* IDENT *);
  258 (* MONOP *);
  259 (* MULOP *);
  260 (* ADDOP *);
  261 (* RELOP *);
  262 (* NUMBER *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\003\000\003\000\004\000\004\000\004\000\004\000\
\004\000\004\000\004\000\004\000\004\000\004\000\004\000\004\000\
\004\000\008\000\008\000\007\000\007\000\007\000\009\000\010\000\
\010\000\006\000\006\000\011\000\011\000\011\000\011\000\012\000\
\012\000\013\000\013\000\013\000\013\000\013\000\005\000\000\000"

let yylen = "\002\000\
\004\000\001\000\001\000\003\000\000\000\003\000\002\000\001\000\
\005\000\007\000\005\000\004\000\003\000\001\000\005\000\007\000\
\006\000\004\000\005\000\000\000\001\000\003\000\003\000\001\000\
\003\000\001\000\003\000\001\000\003\000\003\000\006\000\001\000\
\003\000\001\000\001\000\002\000\002\000\003\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\040\000\039\000\000\000\000\000\000\000\
\008\000\000\000\000\000\014\000\000\000\000\000\002\000\000\000\
\000\000\000\000\035\000\000\000\000\000\000\000\034\000\000\000\
\000\000\000\000\032\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\036\000\000\000\037\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\013\000\000\000\
\001\000\004\000\000\000\038\000\000\000\000\000\000\000\000\000\
\000\000\033\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\009\000\011\000\000\000\000\000\000\000\000\000\
\015\000\000\000\000\000\000\000\000\000\000\000\017\000\025\000\
\000\000\022\000\023\000\000\000\010\000\000\000\016\000\000\000\
\019\000"

let yydgoto = "\002\000\
\004\000\014\000\015\000\016\000\023\000\024\000\062\000\070\000\
\063\000\064\000\025\000\026\000\027\000"

let yysindex = "\018\000\
\037\255\000\000\061\255\000\000\000\000\183\255\183\255\183\255\
\000\000\061\255\061\255\000\000\183\255\045\255\000\000\064\255\
\079\255\132\255\000\000\183\255\132\255\183\255\000\000\030\255\
\084\255\095\255\000\000\041\255\091\255\076\255\085\255\001\255\
\101\255\061\255\183\255\000\000\009\255\000\000\048\255\183\255\
\061\255\132\255\132\255\132\255\061\255\183\255\000\000\108\255\
\000\000\000\000\091\255\000\000\183\255\084\255\025\255\095\255\
\095\255\000\000\249\254\091\255\111\255\055\255\104\255\118\255\
\036\255\061\255\000\000\000\000\183\255\109\255\108\255\061\255\
\000\000\108\255\061\255\183\255\112\255\063\255\000\000\000\000\
\120\255\000\000\000\000\091\255\000\000\061\255\000\000\114\255\
\000\000"

let yyrindex = "\000\000\
\000\000\000\000\059\255\000\000\000\000\000\000\000\000\000\000\
\000\000\002\255\059\255\000\000\000\000\000\000\000\000\252\254\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\029\255\088\255\000\000\000\000\196\255\000\000\000\000\000\000\
\000\000\206\255\000\000\000\000\000\000\000\000\000\000\000\000\
\093\255\000\000\000\000\000\000\254\254\000\000\000\000\057\255\
\000\000\000\000\210\255\000\000\000\000\187\255\000\000\117\255\
\146\255\000\000\000\000\220\255\134\255\000\000\106\255\000\000\
\000\000\059\255\000\000\000\000\000\000\000\000\000\000\059\255\
\000\000\057\255\097\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\168\255\000\000\254\254\000\000\121\255\
\000\000"

let yygindex = "\000\000\
\000\000\248\255\113\000\000\000\253\255\004\000\078\000\066\000\
\000\000\084\000\116\000\235\255\239\255"

let yytablesize = 252
let yytable = "\017\000\
\036\000\030\000\031\000\038\000\005\000\040\000\017\000\017\000\
\005\000\003\000\028\000\029\000\068\000\040\000\003\000\003\000\
\032\000\005\000\001\000\052\000\056\000\057\000\003\000\037\000\
\069\000\039\000\058\000\003\000\005\000\005\000\017\000\048\000\
\055\000\026\000\040\000\026\000\059\000\017\000\051\000\026\000\
\040\000\017\000\026\000\066\000\067\000\040\000\026\000\026\000\
\026\000\060\000\026\000\041\000\040\000\003\000\076\000\026\000\
\065\000\077\000\045\000\026\000\026\000\005\000\017\000\081\000\
\033\000\005\000\083\000\040\000\017\000\053\000\034\000\017\000\
\078\000\072\000\073\000\020\000\020\000\088\000\005\000\084\000\
\086\000\006\000\017\000\007\000\008\000\009\000\010\000\042\000\
\011\000\012\000\013\000\028\000\028\000\035\000\028\000\040\000\
\043\000\044\000\028\000\005\000\028\000\028\000\046\000\005\000\
\047\000\028\000\028\000\028\000\049\000\028\000\005\000\005\000\
\005\000\061\000\028\000\005\000\005\000\074\000\028\000\028\000\
\029\000\029\000\071\000\029\000\021\000\021\000\075\000\029\000\
\079\000\029\000\029\000\085\000\005\000\018\000\029\000\029\000\
\029\000\019\000\029\000\087\000\018\000\020\000\024\000\029\000\
\021\000\069\000\050\000\029\000\029\000\030\000\030\000\082\000\
\030\000\089\000\080\000\054\000\030\000\000\000\030\000\030\000\
\000\000\000\000\000\000\030\000\030\000\030\000\000\000\030\000\
\000\000\000\000\000\000\031\000\030\000\000\000\031\000\000\000\
\030\000\030\000\031\000\000\000\031\000\031\000\000\000\005\000\
\018\000\031\000\031\000\031\000\019\000\031\000\000\000\027\000\
\020\000\027\000\031\000\021\000\000\000\027\000\031\000\031\000\
\027\000\000\000\007\000\022\000\027\000\027\000\027\000\000\000\
\027\000\007\000\000\000\000\000\005\000\027\000\007\000\007\000\
\006\000\027\000\027\000\005\000\000\000\000\000\007\000\006\000\
\005\000\005\000\012\000\007\000\006\000\006\000\000\000\000\000\
\005\000\012\000\000\000\000\000\006\000\005\000\012\000\012\000\
\000\000\006\000\000\000\000\000\000\000\000\000\012\000\000\000\
\000\000\000\000\000\000\012\000"

let yycheck = "\003\000\
\018\000\010\000\011\000\021\000\007\001\005\001\010\000\011\000\
\007\001\014\001\007\000\008\000\020\001\005\001\019\001\020\001\
\013\000\020\001\001\000\011\001\042\000\043\000\027\001\020\000\
\032\001\022\000\044\000\032\001\027\001\032\001\034\000\031\001\
\041\000\005\001\005\001\007\001\045\000\041\000\035\000\011\001\
\005\001\045\000\014\001\019\001\020\001\005\001\018\001\019\001\
\020\001\046\000\022\001\022\001\005\001\017\001\019\001\027\001\
\053\000\066\000\018\001\031\001\032\001\001\001\066\000\072\000\
\020\001\007\001\075\000\005\001\072\000\022\001\007\001\075\000\
\069\000\019\001\020\001\019\001\020\001\086\000\020\001\076\000\
\018\001\021\001\086\000\023\001\024\001\025\001\026\001\004\001\
\028\001\029\001\030\001\004\001\005\001\015\001\007\001\005\001\
\013\001\003\001\011\001\007\001\013\001\014\001\027\001\007\001\
\020\001\018\001\019\001\020\001\008\001\022\001\014\001\019\001\
\020\001\006\001\027\001\019\001\020\001\014\001\031\001\032\001\
\004\001\005\001\012\001\007\001\019\001\020\001\009\001\011\001\
\020\001\013\001\014\001\020\001\001\001\002\001\018\001\019\001\
\020\001\006\001\022\001\020\001\020\001\010\001\009\001\027\001\
\013\001\032\001\034\000\031\001\032\001\004\001\005\001\074\000\
\007\001\088\000\071\000\040\000\011\001\255\255\013\001\014\001\
\255\255\255\255\255\255\018\001\019\001\020\001\255\255\022\001\
\255\255\255\255\255\255\004\001\027\001\255\255\007\001\255\255\
\031\001\032\001\011\001\255\255\013\001\014\001\255\255\001\001\
\002\001\018\001\019\001\020\001\006\001\022\001\255\255\005\001\
\010\001\007\001\027\001\013\001\255\255\011\001\031\001\032\001\
\014\001\255\255\007\001\021\001\018\001\019\001\020\001\255\255\
\022\001\014\001\255\255\255\255\007\001\027\001\019\001\020\001\
\007\001\031\001\032\001\014\001\255\255\255\255\027\001\014\001\
\019\001\020\001\007\001\032\001\019\001\020\001\255\255\255\255\
\027\001\014\001\255\255\255\255\027\001\032\001\019\001\020\001\
\255\255\032\001\255\255\255\255\255\255\255\255\027\001\255\255\
\255\255\255\255\255\255\032\001"

let yynames_const = "\
  SEMI\000\
  DOT\000\
  COLON\000\
  LPAR\000\
  RPAR\000\
  COMMA\000\
  MINUS\000\
  VBAR\000\
  ASSIGN\000\
  EOF\000\
  BADTOK\000\
  BEGIN\000\
  DO\000\
  ELSE\000\
  END\000\
  IF\000\
  THEN\000\
  WHILE\000\
  PRINT\000\
  NEWLINE\000\
  REPEAT\000\
  UNTIL\000\
  LOOP\000\
  EXIT\000\
  CASE\000\
  OF\000\
  ELSIF\000\
  "

let yynames_block = "\
  IDENT\000\
  MONOP\000\
  MULOP\000\
  ADDOP\000\
  RELOP\000\
  NUMBER\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'stmts) in
    Obj.repr(
# 29 "parser.mly"
                                        ( Program _2 )
# 262 "parser.ml"
               : Tree.program))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 32 "parser.mly"
                                        ( seq _1 )
# 269 "parser.ml"
               : 'stmts))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 35 "parser.mly"
                                        ( [_1] )
# 276 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 36 "parser.mly"
                                        ( _1 :: _3 )
# 284 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 39 "parser.mly"
                                        ( Skip )
# 290 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'name) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 40 "parser.mly"
                                        ( Assign (_1, _3) )
# 298 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 41 "parser.mly"
                                        ( Print _2 )
# 305 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 42 "parser.mly"
                                        ( Newline )
# 311 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 43 "parser.mly"
                                        ( IfStmt (_2, _4, Skip) )
# 319 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'stmts) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 44 "parser.mly"
                                        ( IfStmt (_2, _4, _6) )
# 328 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 45 "parser.mly"
                                        ( WhileStmt (_2, _4) )
# 336 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'stmts) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 46 "parser.mly"
                                        ( RepeatStmt (_2, _4) )
# 344 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 47 "parser.mly"
                                        ( LoopStmt _2 )
# 351 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 48 "parser.mly"
                                        ( Exit )
# 357 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'cases) in
    Obj.repr(
# 49 "parser.mly"
                                        ( CaseStmt (_2, _4, Skip) )
# 365 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'cases) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 50 "parser.mly"
                                        ( CaseStmt (_2, _4, _6) )
# 374 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'stmts) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'elsifs) in
    Obj.repr(
# 51 "parser.mly"
                                        ( MultipleWhileStmt ((_2, _4) :: _5))
# 383 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'stmts) in
    Obj.repr(
# 54 "parser.mly"
                                        ( [(_2, _4)] )
# 391 "parser.ml"
               : 'elsifs))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'elsifs) in
    Obj.repr(
# 55 "parser.mly"
                                        ( (_2, _4) :: _5 )
# 400 "parser.ml"
               : 'elsifs))
; (fun __caml_parser_env ->
    Obj.repr(
# 58 "parser.mly"
                                        ( [] )
# 406 "parser.ml"
               : 'cases))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'case) in
    Obj.repr(
# 59 "parser.mly"
                                        ( [_1] )
# 413 "parser.ml"
               : 'cases))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'case) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'cases) in
    Obj.repr(
# 60 "parser.mly"
                                        ( _1 :: _3 )
# 421 "parser.ml"
               : 'cases))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'numbers) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'stmts) in
    Obj.repr(
# 63 "parser.mly"
                                        ( (_1, _3) )
# 429 "parser.ml"
               : 'case))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 66 "parser.mly"
                                        ( [_1] )
# 436 "parser.ml"
               : 'numbers))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'numbers) in
    Obj.repr(
# 67 "parser.mly"
                                        ( _1 :: _3 )
# 444 "parser.ml"
               : 'numbers))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'simple) in
    Obj.repr(
# 70 "parser.mly"
                                        ( _1 )
# 451 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'simple) in
    Obj.repr(
# 71 "parser.mly"
                                        ( Binop (_2, _1, _3) )
# 460 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 74 "parser.mly"
                                        ( _1 )
# 467 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 75 "parser.mly"
                                        ( Binop (_2, _1, _3) )
# 476 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 76 "parser.mly"
                                        ( Binop (Minus, _1, _3) )
# 484 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 77 "parser.mly"
                                        ( IfExpr (_2, _4, _6) )
# 493 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 80 "parser.mly"
                                        ( _1 )
# 500 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 81 "parser.mly"
                                        ( Binop (_2, _1, _3) )
# 509 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'name) in
    Obj.repr(
# 84 "parser.mly"
                                        ( Variable _1 )
# 516 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 85 "parser.mly"
                                        ( Constant _1 )
# 523 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 86 "parser.mly"
                                        ( Monop (_1, _2) )
# 531 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 87 "parser.mly"
                                        ( Monop (Uminus, _2) )
# 538 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 88 "parser.mly"
                                        ( _2 )
# 545 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Tree.ident) in
    Obj.repr(
# 91 "parser.mly"
                                        ( make_name _1 !Lexer.lineno )
# 552 "parser.ml"
               : 'name))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Tree.program)
