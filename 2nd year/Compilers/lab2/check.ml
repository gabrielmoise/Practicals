(* lab2/check.ml *)
(* Copyright (c) 2017 J. M. Spivey *)

open Print 
open Keiko
open Tree 
open Dict 

(* USED IN EXERCISE 3.4 *)

(* |warning| -- warn user *)
let warning str = Printf.eprintf "--- Warning: %s\n" str 

(* |in_list| -- check if element in list *)
let in_list lst x = List.exists (fun v -> v = x) lst

(* |intersect| -- get intersection of two sets *)
let rec intersect xss ys =
    match xss with
      [] -> []
    | (x :: xs) -> 
        let other = intersect xs ys in
        if (in_list ys x) then x :: other else other 

(* |check_expr_initialised| -- check if an expression has uninitialized variables *)
let rec check_expr_initialised before e = 
    match e.e_guts with 
    |  Variable x -> 
        if not (in_list before x.x_name) then
            warning ("usage of (possibly) undeclared variable " ^ x.x_name)
    | Sub (v, e) -> ()
    | Constant (n, t) -> () 
    | Monop (w, e1) -> 
        check_expr_initialised before e1
    | Binop (w, e1, e2) -> 
        check_expr_initialised before e1;
        check_expr_initialised before e2


(* |check_initialised| -- check if this statement does not have uninitialized variables *)
let rec check_initialised before stmt =
    match stmt with 
      Skip -> before
    | Seq ss -> 
        let mutable_before = ref before in
        let run_on stmt =
            mutable_before := check_initialised !mutable_before stmt in
        List.iter run_on ss; !mutable_before
    | Assign (lhs, rhs) -> 
        check_expr_initialised before rhs; 
        begin
        match lhs.e_guts with
          | Variable x ->
            (x.x_name :: before)    
          | _ -> 
            before
        end
    | Print e ->
        before
    | Newline ->
        before
    | IfStmt (cond, thenpt, elsept) ->
        check_expr_initialised before cond;
        let t1 = check_initialised before thenpt 
        and t2 = check_initialised before elsept in
        intersect t1 t2
    | WhileStmt (cond, body) ->
        check_expr_initialised before cond;
        let _ = check_initialised before body in
        before

(* END OF CODE FOR EXERCISE 3.4 *)


(* |err_line| -- line number for error messages *)
let err_line = ref 1

(* |Semantic_error| -- exception raised if error detected *)
exception Semantic_error of string * Print.arg list * int

(* |sem_error| -- issue error message by raising exception *)
let sem_error fmt args = 
  raise (Semantic_error (fmt, args, !err_line))

(* |accum| -- fold_left with arguments swapped *)
let rec accum f xs a =
  match xs with
      [] -> a
    | y::ys -> accum f ys (f y a)

(* |lookup_def| -- find definition of a name, give error is none *)
let lookup_def x env =
  err_line := x.x_line;
  try let d = lookup x.x_name env in x.x_def <- Some d; d.d_type with 
    Not_found -> sem_error "$ is not declared" [fStr x.x_name]

(* |add_def| -- add definition to env, give error if already declared *)
let add_def d env =
  try define d env with 
    Exit -> sem_error "$ is already declared" [fStr d.d_tag]

(* |type_error| -- report a type error.  The message could be better. *)
let type_error () = sem_error "type mismatch in expression" []

(* |check_monop| -- check a unary operator and return its type *)
let check_monop w t =
  match w with
      Uminus ->
        if t <> Integer then type_error ();
        Integer
    | Not ->
        if t <> Boolean then type_error ();
        Boolean
    | _ -> failwith "bad monop"

(* |check_binop| -- check a binary operator and return its type *)
let check_binop w ta tb =
  match w with
      Plus | Minus | Times | Div | Mod ->
        if ta <> Integer || tb <> Integer then type_error ();
        Integer
    | Eq | Lt | Gt | Leq | Geq | Neq ->
        if ta <> tb then type_error ();
        Boolean
    | And | Or ->
        if ta <> Boolean || tb <> Boolean then type_error ();
        Boolean
    | _ -> failwith "bad binop"

(* |check_expr| -- check and annotate an expression *)
let rec check_expr e env =
  let t = expr_type e env in
  (e.e_type <- t; t)

(* |expr_type| -- check an expression and return its type *)
and expr_type e env = 
  match e.e_guts with
      Variable x -> 
        lookup_def x env
    | Sub (v, e) ->
        let v_type = check_expr v env
        and e_type = check_expr e env in
        if (not (is_array v_type)) || (e_type <> Integer) then type_error ();
        base_type v_type
    | Constant (n, t) -> t
    | Monop (w, e1) -> 
        let t = check_expr e1 env in
        check_monop w t
    | Binop (w, e1, e2) -> 
        let ta = check_expr e1 env
        and tb = check_expr e2 env in
        check_binop w ta tb

(* |check_stmt| -- check and annotate a statement *)
let rec check_stmt s env =
  match s with
      Skip -> ()
    | Seq ss ->
        List.iter (fun s1 -> check_stmt s1 env) ss
    | Assign (lhs, rhs) ->
        let ta = check_expr lhs env
        and tb = check_expr rhs env in
        if is_array ta then sem_error "can not assign to an array" []; 
        if ta <> tb then sem_error "type mismatch in assignment" []
    | Print e ->
        let t = check_expr e env in
        if t <> Integer then sem_error "print needs an integer" []
    | Newline ->
        ()
    | IfStmt (cond, thenpt, elsept) ->
        let t = check_expr cond env in
        if t <> Boolean then
          sem_error "boolean needed in if statement" [];
        check_stmt thenpt env; 
        check_stmt elsept env
    | WhileStmt (cond, body) ->
        let t = check_expr cond env in
        if t <> Boolean then
          sem_error "need boolean after while" [];
        check_stmt body env

(* |make_def| -- construct definition of variable *)
let make_def x t a = { d_tag = x; d_type = t; d_lab = a }

(* |check_decl| -- check declaration and return extended environment *)
let check_decl (Decl (vs, t)) env0 =
  let declare x env = 
    let lab = sprintf "_$" [fStr x.x_name] in
    let d = make_def x.x_name t lab in
    x.x_def <- Some d; add_def d env in
  accum declare vs env0

(* |check_decls| -- check a sequence of declarations *)
let check_decls ds env0 =
  accum check_decl ds env0

(* |annotate| -- check and annotate a program *)
let annotate (Program (ds, ss)) =
  let env = check_decls ds init_env in
  let _ = check_initialised [] ss in
  check_stmt ss env


