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

open Parsing;;
let _ = parse_error;;
# 4 "parser.mly"
 
open Keiko
open Tree
# 42 "parser.ml"
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
\007\000\007\000\007\000\008\000\009\000\009\000\006\000\006\000\
\010\000\010\000\010\000\011\000\011\000\012\000\012\000\012\000\
\012\000\012\000\005\000\000\000"

let yylen = "\002\000\
\004\000\001\000\001\000\003\000\000\000\003\000\002\000\001\000\
\005\000\007\000\005\000\004\000\003\000\001\000\005\000\007\000\
\000\000\001\000\003\000\003\000\001\000\003\000\001\000\003\000\
\001\000\003\000\003\000\001\000\003\000\001\000\001\000\002\000\
\002\000\003\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\036\000\035\000\000\000\000\000\000\000\
\008\000\000\000\000\000\014\000\000\000\000\000\002\000\000\000\
\000\000\000\000\031\000\000\000\000\000\030\000\000\000\000\000\
\000\000\028\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\032\000\000\000\033\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\013\000\000\000\001\000\004\000\
\000\000\034\000\000\000\000\000\000\000\000\000\029\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\009\000\011\000\
\000\000\000\000\015\000\000\000\000\000\000\000\022\000\000\000\
\019\000\020\000\010\000\016\000"

let yydgoto = "\002\000\
\004\000\014\000\015\000\016\000\022\000\023\000\059\000\060\000\
\061\000\024\000\025\000\026\000"

let yysindex = "\013\000\
\002\255\000\000\020\255\000\000\000\000\075\255\075\255\075\255\
\000\000\020\255\020\255\000\000\075\255\019\255\000\000\055\255\
\057\255\075\255\000\000\075\255\075\255\000\000\012\255\091\255\
\067\255\000\000\010\255\070\255\062\255\074\255\252\254\092\255\
\020\255\075\255\000\000\046\255\000\000\075\255\020\255\075\255\
\075\255\075\255\020\255\075\255\000\000\090\255\000\000\000\000\
\070\255\000\000\091\255\018\255\067\255\067\255\000\000\094\255\
\070\255\109\255\036\255\118\255\125\255\020\255\000\000\000\000\
\090\255\020\255\000\000\090\255\020\255\116\255\000\000\121\255\
\000\000\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\009\255\000\000\000\000\000\000\000\000\000\000\
\000\000\253\254\009\255\000\000\000\000\000\000\000\000\033\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\108\255\
\060\255\000\000\000\000\135\255\000\000\000\000\000\000\000\000\
\144\255\000\000\000\000\000\000\000\000\000\000\003\255\000\000\
\000\000\000\000\009\255\000\000\000\000\049\255\000\000\000\000\
\153\255\000\000\126\255\000\000\079\255\098\255\000\000\000\000\
\162\255\129\255\000\000\088\255\000\000\009\255\000\000\000\000\
\000\000\009\255\000\000\049\255\006\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\248\255\110\000\000\000\253\255\254\255\079\000\000\000\
\085\000\114\000\083\000\247\255"

let yytablesize = 189
let yytable = "\017\000\
\038\000\029\000\030\000\005\000\027\000\028\000\017\000\017\000\
\035\000\005\000\031\000\037\000\005\000\001\000\038\000\005\000\
\038\000\036\000\003\000\005\000\005\000\005\000\005\000\005\000\
\005\000\005\000\046\000\043\000\005\000\017\000\052\000\049\000\
\055\000\039\000\056\000\017\000\062\000\063\000\032\000\017\000\
\006\000\057\000\007\000\008\000\009\000\010\000\003\000\011\000\
\012\000\013\000\038\000\003\000\003\000\070\000\066\000\067\000\
\050\000\072\000\017\000\003\000\074\000\033\000\017\000\025\000\
\025\000\017\000\025\000\017\000\017\000\042\000\025\000\034\000\
\025\000\025\000\038\000\005\000\018\000\025\000\025\000\025\000\
\019\000\025\000\026\000\026\000\020\000\026\000\025\000\021\000\
\044\000\026\000\025\000\026\000\026\000\045\000\040\000\058\000\
\026\000\026\000\026\000\047\000\026\000\027\000\027\000\041\000\
\027\000\026\000\018\000\018\000\027\000\026\000\027\000\027\000\
\023\000\064\000\023\000\027\000\027\000\027\000\023\000\027\000\
\065\000\023\000\053\000\054\000\027\000\023\000\023\000\023\000\
\027\000\023\000\024\000\068\000\024\000\069\000\023\000\075\000\
\024\000\021\000\023\000\024\000\076\000\007\000\048\000\024\000\
\024\000\024\000\073\000\024\000\007\000\071\000\005\000\051\000\
\024\000\007\000\007\000\000\000\024\000\005\000\000\000\006\000\
\000\000\007\000\005\000\005\000\000\000\000\000\006\000\000\000\
\012\000\000\000\005\000\006\000\006\000\000\000\000\000\012\000\
\000\000\000\000\000\000\006\000\012\000\012\000\000\000\000\000\
\000\000\000\000\000\000\000\000\012\000"

let yycheck = "\003\000\
\005\001\010\000\011\000\007\001\007\000\008\000\010\000\011\000\
\018\000\007\001\013\000\021\000\007\001\001\000\005\001\007\001\
\005\001\020\000\017\001\014\001\001\001\019\001\020\001\027\001\
\019\001\020\001\031\001\018\001\020\001\033\000\039\000\034\000\
\042\000\022\001\043\000\039\000\019\001\020\001\020\001\043\000\
\021\001\044\000\023\001\024\001\025\001\026\001\014\001\028\001\
\029\001\030\001\005\001\019\001\020\001\062\000\019\001\020\001\
\011\001\066\000\062\000\027\001\069\000\007\001\066\000\004\001\
\005\001\069\000\007\001\019\001\020\001\003\001\011\001\015\001\
\013\001\014\001\005\001\001\001\002\001\018\001\019\001\020\001\
\006\001\022\001\004\001\005\001\010\001\007\001\027\001\013\001\
\027\001\011\001\031\001\013\001\014\001\020\001\004\001\006\001\
\018\001\019\001\020\001\008\001\022\001\004\001\005\001\013\001\
\007\001\027\001\019\001\020\001\011\001\031\001\013\001\014\001\
\005\001\020\001\007\001\018\001\019\001\020\001\011\001\022\001\
\012\001\014\001\040\000\041\000\027\001\018\001\019\001\020\001\
\031\001\022\001\005\001\014\001\007\001\009\001\027\001\020\001\
\011\001\009\001\031\001\014\001\020\001\007\001\033\000\018\001\
\019\001\020\001\068\000\022\001\014\001\065\000\007\001\038\000\
\027\001\019\001\020\001\255\255\031\001\014\001\255\255\007\001\
\255\255\027\001\019\001\020\001\255\255\255\255\014\001\255\255\
\007\001\255\255\027\001\019\001\020\001\255\255\255\255\014\001\
\255\255\255\255\255\255\027\001\019\001\020\001\255\255\255\255\
\255\255\255\255\255\255\255\255\027\001"

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
# 28 "parser.mly"
                                        ( Program _2 )
# 237 "parser.ml"
               : Tree.program))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 31 "parser.mly"
                                        ( seq _1 )
# 244 "parser.ml"
               : 'stmts))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 34 "parser.mly"
                                        ( [_1] )
# 251 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 35 "parser.mly"
                                        ( _1 :: _3 )
# 259 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 38 "parser.mly"
                                        ( Skip )
# 265 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'name) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 39 "parser.mly"
                                        ( Assign (_1, _3) )
# 273 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 40 "parser.mly"
                                        ( Print _2 )
# 280 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 41 "parser.mly"
                                        ( Newline )
# 286 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 42 "parser.mly"
                                        ( IfStmt (_2, _4, Skip) )
# 294 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'stmts) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 43 "parser.mly"
                                        ( IfStmt (_2, _4, _6) )
# 303 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 44 "parser.mly"
                                        ( WhileStmt (_2, _4) )
# 311 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'stmts) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 45 "parser.mly"
                                        ( RepeatStmt (_2, _4) )
# 319 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 46 "parser.mly"
                                        ( LoopStmt _2 )
# 326 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 47 "parser.mly"
                                        ( Exit )
# 332 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'cases) in
    Obj.repr(
# 48 "parser.mly"
                                        ( CaseStmt (_2, _4, Skip) )
# 340 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'cases) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 49 "parser.mly"
                                        ( CaseStmt (_2, _4, _6) )
# 349 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 52 "parser.mly"
                                        ( [] )
# 355 "parser.ml"
               : 'cases))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'case) in
    Obj.repr(
# 53 "parser.mly"
                                        ( [_1] )
# 362 "parser.ml"
               : 'cases))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'case) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'cases) in
    Obj.repr(
# 54 "parser.mly"
                                        ( _1 :: _3 )
# 370 "parser.ml"
               : 'cases))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'numbers) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'stmts) in
    Obj.repr(
# 57 "parser.mly"
                                        ( (_1, _3) )
# 378 "parser.ml"
               : 'case))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 60 "parser.mly"
                                        ( [_1] )
# 385 "parser.ml"
               : 'numbers))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'numbers) in
    Obj.repr(
# 61 "parser.mly"
                                        ( _1 :: _3 )
# 393 "parser.ml"
               : 'numbers))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'simple) in
    Obj.repr(
# 64 "parser.mly"
                                        ( _1 )
# 400 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'simple) in
    Obj.repr(
# 65 "parser.mly"
                                        ( Binop (_2, _1, _3) )
# 409 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 68 "parser.mly"
                                        ( _1 )
# 416 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 69 "parser.mly"
                                        ( Binop (_2, _1, _3) )
# 425 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 70 "parser.mly"
                                        ( Binop (Minus, _1, _3) )
# 433 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 73 "parser.mly"
                                        ( _1 )
# 440 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 74 "parser.mly"
                                        ( Binop (_2, _1, _3) )
# 449 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'name) in
    Obj.repr(
# 77 "parser.mly"
                                        ( Variable _1 )
# 456 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 78 "parser.mly"
                                        ( Constant _1 )
# 463 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 79 "parser.mly"
                                        ( Monop (_1, _2) )
# 471 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 80 "parser.mly"
                                        ( Monop (Uminus, _2) )
# 478 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 81 "parser.mly"
                                        ( _2 )
# 485 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Tree.ident) in
    Obj.repr(
# 84 "parser.mly"
                                        ( make_name _1 !Lexer.lineno )
# 492 "parser.ml"
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
