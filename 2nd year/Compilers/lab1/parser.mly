/* lab1/parser.mly */
/* Copyright (c) 2017 J. M. Spivey */

%{ 
open Keiko
open Tree
%}

%token <Tree.ident>     IDENT
%token <Keiko.op>       MONOP MULOP ADDOP RELOP
%token <int>            NUMBER

/* punctuation and keywords */
%token                  SEMI DOT COLON LPAR RPAR COMMA MINUS VBAR
%token                  ASSIGN EOF BADTOK
%token                  BEGIN DO ELSE END IF THEN WHILE PRINT NEWLINE
%token                  REPEAT UNTIL
%token                  LOOP EXIT
%token                  CASE OF
%token                  ELSIF

%type <Tree.program>    program

%start                  program

%%

program :       
    BEGIN stmts END DOT                 { Program $2 } ;

stmts : 
    stmt_list                           { seq $1 } ;

stmt_list :
    stmt                                { [$1] }
  | stmt SEMI stmt_list                 { $1 :: $3 } ;

stmt :  
    /* empty */                         { Skip }
  | name ASSIGN expr                    { Assign ($1, $3) }
  | PRINT expr                          { Print $2 }
  | NEWLINE                             { Newline }
  | IF expr THEN stmts END              { IfStmt ($2, $4, Skip) }
  | IF expr THEN stmts ELSE stmts END   { IfStmt ($2, $4, $6) }
  | WHILE expr DO stmts END             { WhileStmt ($2, $4) } ;
  | REPEAT stmts UNTIL expr             { RepeatStmt ($2, $4) }
  | LOOP stmts END                      { LoopStmt $2 }
  | EXIT                                { Exit }
  | CASE expr OF cases END              { CaseStmt ($2, $4, Skip) }
  | CASE expr OF cases ELSE stmts END   { CaseStmt ($2, $4, $6) }
  | WHILE expr DO stmts elsifs END      { MultipleWhileStmt (($2, $4) :: $5)}

elsifs:
    ELSIF expr DO stmts                 { [($2, $4)] }
  | ELSIF expr DO stmts elsifs          { ($2, $4) :: $5 }

cases :
    /* empty */                         { [] }
  | case                                { [$1] }
  | case VBAR cases                     { $1 :: $3 }

case :
    numbers COLON stmts                 { ($1, $3) }

numbers:
    NUMBER                              { [$1] }
  | NUMBER COMMA numbers                { $1 :: $3 }
 
expr :
    simple                              { $1 }
  | expr RELOP simple                   { Binop ($2, $1, $3) } ;
    
simple :
    term                                { $1 }
  | simple ADDOP term                   { Binop ($2, $1, $3) }
  | simple MINUS term                   { Binop (Minus, $1, $3) } ;
  | IF expr THEN expr ELSE expr         { IfExpr ($2, $4, $6) }

term :
    factor                              { $1 }
  | term MULOP factor                   { Binop ($2, $1, $3) } ;

factor :
    name                                { Variable $1 }
  | NUMBER                              { Constant $1 }
  | MONOP factor                        { Monop ($1, $2) }
  | MINUS factor                        { Monop (Uminus, $2) }
  | LPAR expr RPAR                      { $2 } ;

name :
    IDENT                               { make_name $1 !Lexer.lineno } ;
