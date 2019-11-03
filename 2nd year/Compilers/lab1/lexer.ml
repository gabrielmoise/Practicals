# 4 "lexer.mll"
 
open Lexing
open Tree 
open Keiko
open Parser

(* |lineno| -- line number for use in error messages *)
let lineno = ref 1

(* |make_hash| -- create hash table from list of pairs *)
let make_hash n ps =
  let t = Hashtbl.create n in
  List.iter (fun (k, v) -> Hashtbl.add t k v) ps;
  t

(* |kwtable| -- a little table to recognize keywords *)
let kwtable = 
  make_hash 64
    [ ("begin", BEGIN); ("do", DO); ("if", IF ); ("else", ELSE); 
      ("end", END); ("then", THEN); ("while", WHILE); ("print", PRINT);
      ("newline", NEWLINE); ("and", MULOP And); ("div", MULOP Div); 
      ("or", ADDOP Or); ("not", MONOP Not); ("mod", MULOP Mod);
      ("true", NUMBER 1); ("false", NUMBER 0);
      ("repeat", REPEAT); ("until", UNTIL);
      ("loop", LOOP); ("exit", EXIT);
      ("case", CASE); ("of", OF);
      ("elsif", ELSIF)]

(* |idtable| -- table of all identifiers seen so far *)
let idtable = Hashtbl.create 64

(* |lookup| -- convert string to keyword or identifier *)
let lookup s = 
  try Hashtbl.find kwtable s with 
    Not_found -> 
      Hashtbl.replace idtable s ();
      IDENT s

(* |get_vars| -- get list of identifiers in the program *)
let get_vars () = 
  Hashtbl.fold (fun k () ks -> k::ks) idtable []

# 45 "lexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\231\255\232\255\233\255\234\255\002\000\002\000\030\000\
    \243\255\244\255\245\255\246\255\247\255\248\255\005\000\250\255\
    \003\000\252\255\253\255\077\000\087\000\237\255\235\255\239\255\
    \240\255\238\255\136\000\252\255\253\255\254\255\052\000\255\255\
    ";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\255\255\255\255\019\000\014\000\013\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\006\000\255\255\
    \004\000\255\255\255\255\001\000\000\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\002\000\255\255\
    ";
  Lexing.lex_default =
   "\002\000\000\000\000\000\000\000\000\000\255\255\255\255\255\255\
    \000\000\000\000\000\000\000\000\000\000\000\000\255\255\000\000\
    \255\255\000\000\000\000\255\255\255\255\000\000\000\000\000\000\
    \000\000\000\000\028\000\000\000\000\000\000\000\255\255\000\000\
    ";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\005\000\003\000\005\000\000\000\004\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \005\000\000\000\005\000\000\000\000\000\000\000\000\000\000\000\
    \014\000\013\000\008\000\010\000\012\000\009\000\017\000\022\000\
    \019\000\019\000\019\000\019\000\019\000\019\000\019\000\019\000\
    \019\000\019\000\016\000\018\000\007\000\011\000\006\000\025\000\
    \021\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\023\000\024\000\031\000\000\000\000\000\
    \000\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\000\000\015\000\019\000\019\000\019\000\
    \019\000\019\000\019\000\019\000\019\000\019\000\019\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\000\000\029\000\000\000\000\000\000\000\000\000\000\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\030\000\000\000\000\000\000\000\020\000\000\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \027\000";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\005\000\255\255\000\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\005\000\255\255\255\255\255\255\255\255\255\255\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\014\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\006\000\
    \016\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\007\000\007\000\030\000\255\255\255\255\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\255\255\000\000\019\000\019\000\019\000\
    \019\000\019\000\019\000\019\000\019\000\019\000\019\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\255\255\026\000\255\255\255\255\255\255\255\255\255\255\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\026\000\255\255\255\255\255\255\020\000\255\255\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
    \020\000\020\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \026\000";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec token lexbuf =
   __ocaml_lex_token_rec lexbuf 0
and __ocaml_lex_token_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
let
# 49 "lexer.mll"
                                                     s
# 189 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 50 "lexer.mll"
                        ( lookup s )
# 193 "lexer.ml"

  | 1 ->
let
# 51 "lexer.mll"
                    s
# 199 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 51 "lexer.mll"
                        ( NUMBER (int_of_string s) )
# 203 "lexer.ml"

  | 2 ->
# 52 "lexer.mll"
                        ( SEMI )
# 208 "lexer.ml"

  | 3 ->
# 53 "lexer.mll"
                        ( DOT )
# 213 "lexer.ml"

  | 4 ->
# 54 "lexer.mll"
                        ( COLON )
# 218 "lexer.ml"

  | 5 ->
# 55 "lexer.mll"
                        ( VBAR )
# 223 "lexer.ml"

  | 6 ->
# 56 "lexer.mll"
                        ( LPAR )
# 228 "lexer.ml"

  | 7 ->
# 57 "lexer.mll"
                        ( RPAR )
# 233 "lexer.ml"

  | 8 ->
# 58 "lexer.mll"
                        ( COMMA )
# 238 "lexer.ml"

  | 9 ->
# 59 "lexer.mll"
                        ( RELOP Eq )
# 243 "lexer.ml"

  | 10 ->
# 60 "lexer.mll"
                        ( ADDOP Plus )
# 248 "lexer.ml"

  | 11 ->
# 61 "lexer.mll"
                        ( MINUS )
# 253 "lexer.ml"

  | 12 ->
# 62 "lexer.mll"
                        ( MULOP Times )
# 258 "lexer.ml"

  | 13 ->
# 63 "lexer.mll"
                        ( RELOP Lt )
# 263 "lexer.ml"

  | 14 ->
# 64 "lexer.mll"
                        ( RELOP Gt )
# 268 "lexer.ml"

  | 15 ->
# 65 "lexer.mll"
                        ( RELOP Neq )
# 273 "lexer.ml"

  | 16 ->
# 66 "lexer.mll"
                        ( RELOP Leq )
# 278 "lexer.ml"

  | 17 ->
# 67 "lexer.mll"
                        ( RELOP Geq )
# 283 "lexer.ml"

  | 18 ->
# 68 "lexer.mll"
                        ( ASSIGN )
# 288 "lexer.ml"

  | 19 ->
# 69 "lexer.mll"
                        ( token lexbuf )
# 293 "lexer.ml"

  | 20 ->
# 70 "lexer.mll"
                        ( comment lexbuf; token lexbuf )
# 298 "lexer.ml"

  | 21 ->
# 71 "lexer.mll"
                        ( token lexbuf )
# 303 "lexer.ml"

  | 22 ->
# 72 "lexer.mll"
                        ( incr lineno; Source.note_line !lineno lexbuf;
                          token lexbuf )
# 309 "lexer.ml"

  | 23 ->
# 74 "lexer.mll"
                        ( BADTOK )
# 314 "lexer.ml"

  | 24 ->
# 75 "lexer.mll"
                        ( EOF )
# 319 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_token_rec lexbuf __ocaml_lex_state

and comment lexbuf =
   __ocaml_lex_comment_rec lexbuf 26
and __ocaml_lex_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 79 "lexer.mll"
                        ( () )
# 331 "lexer.ml"

  | 1 ->
# 80 "lexer.mll"
                        ( incr lineno; Source.note_line !lineno lexbuf;
                          comment lexbuf )
# 337 "lexer.ml"

  | 2 ->
# 82 "lexer.mll"
                        ( comment lexbuf )
# 342 "lexer.ml"

  | 3 ->
# 83 "lexer.mll"
                        ( () )
# 347 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_comment_rec lexbuf __ocaml_lex_state

;;
