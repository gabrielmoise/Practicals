type token =
  | IDENT of (Dict.ident)
  | MULOP of (Keiko.op)
  | ADDOP of (Keiko.op)
  | RELOP of (Keiko.op)
  | MONOP of (Keiko.op)
  | NUMBER of (int)
  | BOOLCONST of (int)
  | SEMI
  | DOT
  | COLON
  | LPAR
  | RPAR
  | COMMA
  | EQUAL
  | MINUS
  | ASSIGN
  | EOF
  | BADTOK
  | SUB
  | BUS
  | BEGIN
  | DO
  | ELSE
  | END
  | IF
  | THEN
  | VAR
  | WHILE
  | PRINT
  | NEWLINE
  | ARRAY
  | OF
  | INTEGER
  | BOOLEAN
  | LOCAL
  | IN

open Parsing;;
let _ = parse_error;;
# 5 "parser.mly"
open Keiko
open Dict 
open Tree
# 46 "parser.ml"
let yytransl_const = [|
  264 (* SEMI *);
  265 (* DOT *);
  266 (* COLON *);
  267 (* LPAR *);
  268 (* RPAR *);
  269 (* COMMA *);
  270 (* EQUAL *);
  271 (* MINUS *);
  272 (* ASSIGN *);
    0 (* EOF *);
  273 (* BADTOK *);
  274 (* SUB *);
  275 (* BUS *);
  276 (* BEGIN *);
  277 (* DO *);
  278 (* ELSE *);
  279 (* END *);
  280 (* IF *);
  281 (* THEN *);
  282 (* VAR *);
  283 (* WHILE *);
  284 (* PRINT *);
  285 (* NEWLINE *);
  286 (* ARRAY *);
  287 (* OF *);
  288 (* INTEGER *);
  289 (* BOOLEAN *);
  290 (* LOCAL *);
  291 (* IN *);
    0|]

let yytransl_block = [|
  257 (* IDENT *);
  258 (* MULOP *);
  259 (* ADDOP *);
  260 (* RELOP *);
  261 (* MONOP *);
  262 (* NUMBER *);
  263 (* BOOLCONST *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\004\000\005\000\005\000\006\000\006\000\
\006\000\003\000\008\000\008\000\009\000\009\000\009\000\009\000\
\009\000\009\000\009\000\009\000\011\000\011\000\011\000\012\000\
\012\000\012\000\013\000\013\000\014\000\014\000\014\000\014\000\
\014\000\014\000\010\000\010\000\007\000\000\000"

let yylen = "\002\000\
\005\000\000\000\002\000\005\000\001\000\003\000\001\000\001\000\
\004\000\001\000\001\000\003\000\000\000\003\000\002\000\001\000\
\005\000\007\000\005\000\005\000\001\000\003\000\003\000\001\000\
\003\000\003\000\001\000\003\000\001\000\001\000\001\000\002\000\
\002\000\003\000\001\000\004\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\038\000\000\000\000\000\037\000\000\000\
\000\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000\
\016\000\000\000\000\000\035\000\010\000\000\000\000\000\000\000\
\007\000\008\000\000\000\006\000\000\000\030\000\031\000\000\000\
\000\000\000\000\000\000\000\000\000\000\027\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\004\000\032\000\
\000\000\033\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\001\000\012\000\000\000\000\000\000\000\034\000\
\000\000\000\000\000\000\000\000\000\000\028\000\000\000\000\000\
\036\000\009\000\000\000\017\000\019\000\020\000\000\000\018\000"

let yydgoto = "\002\000\
\004\000\005\000\019\000\006\000\008\000\027\000\020\000\021\000\
\022\000\034\000\035\000\036\000\037\000\038\000"

let yysindex = "\005\000\
\248\254\000\000\036\255\000\000\030\255\248\254\000\000\043\255\
\058\255\000\255\000\000\103\255\036\255\165\255\165\255\165\255\
\000\000\248\254\053\255\000\000\000\000\072\255\249\254\078\255\
\000\000\000\000\082\255\000\000\165\255\000\000\000\000\165\255\
\165\255\076\255\001\255\051\255\094\255\000\000\009\255\063\255\
\068\255\098\255\000\255\165\255\165\255\086\255\000\000\000\000\
\032\255\000\000\165\255\165\255\000\255\165\255\165\255\165\255\
\000\255\000\255\000\000\000\000\063\255\003\255\103\255\000\000\
\051\255\051\255\066\255\094\255\094\255\000\000\090\255\096\255\
\000\000\000\000\000\255\000\000\000\000\000\000\122\255\000\000"

let yyrindex = "\000\000\
\127\255\000\000\000\000\000\000\000\000\246\254\000\000\000\000\
\138\255\034\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\123\255\000\000\000\000\000\000\077\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\037\255\000\000\118\255\060\255\000\000\000\000\047\255\
\000\000\000\000\070\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\070\255\000\000\000\000\000\000\
\034\255\034\255\000\000\000\000\093\255\000\000\000\000\000\000\
\130\255\142\255\000\000\083\255\106\255\000\000\000\000\000\000\
\000\000\000\000\034\255\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\055\000\219\255\000\000\144\000\096\000\001\000\117\000\
\000\000\246\255\243\255\060\000\069\000\235\255"

let yytablesize = 180
let yytable = "\023\000\
\007\000\039\000\040\000\009\000\051\000\001\000\051\000\048\000\
\044\000\002\000\045\000\050\000\051\000\009\000\052\000\067\000\
\052\000\003\000\049\000\071\000\072\000\073\000\052\000\014\000\
\002\000\053\000\015\000\016\000\017\000\057\000\061\000\062\000\
\023\000\018\000\070\000\051\000\007\000\079\000\029\000\029\000\
\029\000\013\000\023\000\064\000\029\000\052\000\023\000\023\000\
\029\000\010\000\029\000\029\000\012\000\054\000\015\000\029\000\
\013\000\029\000\029\000\029\000\011\000\029\000\024\000\024\000\
\023\000\055\000\051\000\024\000\015\000\015\000\013\000\024\000\
\041\000\024\000\024\000\042\000\052\000\013\000\024\000\043\000\
\024\000\024\000\024\000\046\000\024\000\025\000\025\000\075\000\
\076\000\047\000\025\000\013\000\013\000\045\000\025\000\056\000\
\025\000\025\000\011\000\011\000\014\000\025\000\058\000\025\000\
\025\000\025\000\059\000\025\000\026\000\026\000\065\000\066\000\
\077\000\026\000\014\000\014\000\063\000\026\000\078\000\026\000\
\026\000\021\000\068\000\069\000\026\000\021\000\026\000\026\000\
\026\000\021\000\026\000\021\000\024\000\022\000\025\000\026\000\
\021\000\022\000\021\000\021\000\021\000\022\000\021\000\022\000\
\080\000\023\000\002\000\005\000\022\000\023\000\022\000\022\000\
\022\000\023\000\022\000\023\000\028\000\002\000\074\000\060\000\
\023\000\000\000\023\000\023\000\023\000\007\000\023\000\000\000\
\000\000\029\000\030\000\031\000\000\000\000\000\000\000\032\000\
\000\000\000\000\000\000\033\000"

let yycheck = "\010\000\
\001\001\015\000\016\000\003\000\004\001\001\000\004\001\029\000\
\016\001\020\001\018\001\033\000\004\001\013\000\014\001\053\000\
\014\001\026\001\032\000\057\000\058\000\019\001\014\001\024\001\
\035\001\025\001\027\001\028\001\029\001\021\001\044\000\045\000\
\043\000\034\001\056\000\004\001\001\001\075\000\002\001\003\001\
\004\001\008\001\053\000\012\001\008\001\014\001\057\000\058\000\
\012\001\020\001\014\001\015\001\010\001\003\001\008\001\019\001\
\023\001\021\001\022\001\023\001\006\000\025\001\003\001\004\001\
\075\000\015\001\004\001\008\001\022\001\023\001\013\001\012\001\
\018\000\014\001\015\001\023\001\014\001\008\001\019\001\008\001\
\021\001\022\001\023\001\006\001\025\001\003\001\004\001\022\001\
\023\001\008\001\008\001\022\001\023\001\018\001\012\001\002\001\
\014\001\015\001\022\001\023\001\008\001\019\001\035\001\021\001\
\022\001\023\001\009\001\025\001\003\001\004\001\051\000\052\000\
\023\001\008\001\022\001\023\001\031\001\012\001\023\001\014\001\
\015\001\004\001\054\000\055\000\019\001\008\001\021\001\022\001\
\023\001\012\001\025\001\014\001\030\001\004\001\032\001\033\001\
\019\001\008\001\021\001\022\001\023\001\012\001\025\001\014\001\
\023\001\004\001\020\001\010\001\019\001\008\001\021\001\022\001\
\023\001\012\001\025\001\014\001\013\000\035\001\063\000\043\000\
\019\001\255\255\021\001\022\001\023\001\001\001\025\001\255\255\
\255\255\005\001\006\001\007\001\255\255\255\255\255\255\011\001\
\255\255\255\255\255\255\015\001"

let yynames_const = "\
  SEMI\000\
  DOT\000\
  COLON\000\
  LPAR\000\
  RPAR\000\
  COMMA\000\
  EQUAL\000\
  MINUS\000\
  ASSIGN\000\
  EOF\000\
  BADTOK\000\
  SUB\000\
  BUS\000\
  BEGIN\000\
  DO\000\
  ELSE\000\
  END\000\
  IF\000\
  THEN\000\
  VAR\000\
  WHILE\000\
  PRINT\000\
  NEWLINE\000\
  ARRAY\000\
  OF\000\
  INTEGER\000\
  BOOLEAN\000\
  LOCAL\000\
  IN\000\
  "

let yynames_block = "\
  IDENT\000\
  MULOP\000\
  ADDOP\000\
  RELOP\000\
  MONOP\000\
  NUMBER\000\
  BOOLCONST\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'decls) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'stmts) in
    Obj.repr(
# 33 "parser.mly"
                                        ( Program (_1, _3) )
# 248 "parser.ml"
               : Tree.program))
; (fun __caml_parser_env ->
    Obj.repr(
# 36 "parser.mly"
                                        ( [] )
# 254 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'decl) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'decls) in
    Obj.repr(
# 37 "parser.mly"
                                        ( _1 :: _2 )
# 262 "parser.ml"
               : 'decls))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'name_list) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'typexp) in
    Obj.repr(
# 40 "parser.mly"
                                        ( Decl (_2, _4) )
# 270 "parser.ml"
               : 'decl))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'name) in
    Obj.repr(
# 43 "parser.mly"
                                        ( [_1] )
# 277 "parser.ml"
               : 'name_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'name) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'name_list) in
    Obj.repr(
# 44 "parser.mly"
                                        ( _1 :: _3 )
# 285 "parser.ml"
               : 'name_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 47 "parser.mly"
                                        ( Integer )
# 291 "parser.ml"
               : 'typexp))
; (fun __caml_parser_env ->
    Obj.repr(
# 48 "parser.mly"
                                        ( Boolean )
# 297 "parser.ml"
               : 'typexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'typexp) in
    Obj.repr(
# 49 "parser.mly"
                                        ( Array (_2, _4) )
# 305 "parser.ml"
               : 'typexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 52 "parser.mly"
                                        ( seq _1 )
# 312 "parser.ml"
               : 'stmts))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'stmt) in
    Obj.repr(
# 55 "parser.mly"
                                        ( [_1] )
# 319 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'stmt) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 56 "parser.mly"
                                        ( _1 :: _3 )
# 327 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    Obj.repr(
# 59 "parser.mly"
                                        ( Skip )
# 333 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'variable) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 60 "parser.mly"
                                        ( Assign (_1, _3) )
# 341 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 61 "parser.mly"
                                        ( Print _2 )
# 348 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 62 "parser.mly"
                                        ( Newline )
# 354 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 63 "parser.mly"
                                        ( IfStmt (_2, _4, Skip) )
# 362 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'stmts) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 64 "parser.mly"
                                        ( IfStmt (_2, _4, _6) )
# 371 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 65 "parser.mly"
                                        ( WhileStmt (_2, _4) )
# 379 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'decls) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'stmts) in
    Obj.repr(
# 66 "parser.mly"
                                        ( LocalStmt (_2, _4) )
# 387 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'simple) in
    Obj.repr(
# 69 "parser.mly"
                                        ( _1 )
# 394 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'simple) in
    Obj.repr(
# 70 "parser.mly"
                                        ( makeExpr (Binop (_2, _1, _3)) )
# 403 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'simple) in
    Obj.repr(
# 71 "parser.mly"
                                        ( makeExpr (Binop (Eq, _1, _3)) )
# 411 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 74 "parser.mly"
                                        ( _1 )
# 418 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 75 "parser.mly"
                                        ( makeExpr (Binop (_2, _1, _3)) )
# 427 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'simple) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 76 "parser.mly"
                                        ( makeExpr (Binop (Minus, _1, _3)) )
# 435 "parser.ml"
               : 'simple))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 79 "parser.mly"
                                        ( _1 )
# 442 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 80 "parser.mly"
                                        ( makeExpr (Binop (_2, _1, _3)) )
# 451 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'variable) in
    Obj.repr(
# 83 "parser.mly"
                                        ( _1 )
# 458 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 84 "parser.mly"
                                        ( makeExpr (Constant (_1, Integer)) )
# 465 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 85 "parser.mly"
                                        ( makeExpr (Constant (_1, Boolean)) )
# 472 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Keiko.op) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 86 "parser.mly"
                                        ( makeExpr (Monop (_1, _2)) )
# 480 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'factor) in
    Obj.repr(
# 87 "parser.mly"
                                        ( makeExpr (Monop (Uminus, _2)) )
# 487 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 88 "parser.mly"
                                        ( _2 )
# 494 "parser.ml"
               : 'factor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'name) in
    Obj.repr(
# 91 "parser.mly"
                                        ( makeExpr (Variable _1) )
# 501 "parser.ml"
               : 'variable))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'variable) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 92 "parser.mly"
                                        ( makeExpr (Sub (_1, _3)) )
# 509 "parser.ml"
               : 'variable))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Dict.ident) in
    Obj.repr(
# 95 "parser.mly"
                                        ( makeName _1 !Lexer.lineno )
# 516 "parser.ml"
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
