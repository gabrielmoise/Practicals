(* lab2/kgen.ml *)
(* Copyright (c) 2017 J. M. Spivey *)

open Dict 
open Tree 
open Keiko 
open Print

let optflag = ref false

let err_line = ref (-1)

(* |line_number| -- find line number of variable reference *)
let rec line_number e =
  match e.e_guts with
      Variable x -> x.x_line
    | Sub (a, e) -> line_number a
    | _ -> 999

(* |gen_expr| -- generate code for an expression *)
let rec gen_expr e =
  match e.e_guts with
    | Variable _ | Sub _ ->
        let load_op = if e.e_type = Integer then LOADW else LOADC in
        SEQ [gen_addr e; load_op]
    | Constant (n, t) ->
        CONST n
    | Monop (w, e1) ->
        SEQ [gen_expr e1; MONOP w]
    | Binop (w, e1, e2) ->
        SEQ [gen_expr e1; gen_expr e2; BINOP w]

(* |constant_addr_of| -- get address of a vector with constant indices *)
and constant_addr_of expr = 
  match expr.e_guts with
    | Variable x -> 
        let d = get_def x in
        err_line := x.x_line;
        Some (x.x_line, d.d_lab, 0)
    | Sub (v, e) -> 
        begin match e.e_guts, (constant_addr_of v) with 
          | Constant (x, Integer), Some (ln, id, addr) ->
              let element_size = type_size (base_type v.e_type)
              and array_length = length_of v.e_type in
              if x < 0 || x >= array_length then
                  failwith ("index out of bounds at line " ^ string_of_int(!err_line))
              else
                  Some (ln, id, addr + x * element_size)
          | _, _ -> None
        end
    | _ -> failwith "error in constant_addr_of" 

(* |get_sub_addr| -- the standard(ish) way of getting the address of an array element *)
and get_sub_addr v e = 
  let get_base_addr = gen_addr v 
  and get_index = gen_expr e
  and element_size = type_size (base_type v.e_type) 
  and array_length = length_of v.e_type in
  let times_seq = 
      if element_size = 1 then NOP else SEQ [CONST element_size; BINOP Times] in 
  begin match get_index with
    | CONST x -> 
        if x < 0 || x >= array_length then
            failwith ("index out of bounds at line " ^ string_of_int(!err_line))
        else
            SEQ [get_base_addr; CONST (x * element_size); OFFSET] 
    | _ -> SEQ [get_base_addr; get_index; CONST array_length; BOUND !err_line; 
                times_seq; OFFSET]
  end

(* |gen_addr| -- generate code to push address of a variable *)
and gen_addr expr =
  match expr.e_guts with
      Variable x ->
        let d = get_def x in
        err_line := x.x_line;
        SEQ [LINE x.x_line; GLOBAL d.d_lab]
    | Sub (v, e) ->
        begin match constant_addr_of expr with
          | Some (ln, id, addr) -> 
              let offset_code = if addr > 0 then SEQ [CONST addr; OFFSET] else NOP in
              SEQ [LINE ln; GLOBAL id; offset_code]
          | None -> 
              get_sub_addr v e
        end
    | _ ->
        failwith "gen_addr"


(* |gen_cond| -- generate code for short-circuit condition *)
let rec gen_cond e tlab flab =
  (* Jump to |tlab| if |e| is true and |flab| if it is false *)
  match e.e_guts with
      Constant (x, t) ->
        if x <> 0 then JUMP tlab else JUMP flab
    | Binop ((Eq|Neq|Lt|Gt|Leq|Geq) as w, e1, e2) ->
        SEQ [gen_expr e1; gen_expr e2;
          JUMPC (w, tlab); JUMP flab]
    | Monop (Not, e1) ->
        gen_cond e1 flab tlab
    | Binop (And, e1, e2) ->
        let lab1 = label () in
        SEQ [gen_cond e1 lab1 flab; LABEL lab1; gen_cond e2 tlab flab]
    | Binop (Or, e1, e2) ->
        let lab1 = label () in
        SEQ [gen_cond e1 tlab lab1; LABEL lab1; gen_cond e2 tlab flab]
    | _ ->
        SEQ [gen_expr e; CONST 0; JUMPC (Neq, tlab); JUMP flab]

(* |gen_stmt| -- generate code for a statement *)
let rec gen_stmt =
  function
      Skip -> NOP
    | Seq stmts -> SEQ (List.map gen_stmt stmts)
    | Assign (v, e) ->
        let store_op = if v.e_type = Integer then STOREW else STOREC in
        SEQ [LINE (line_number v); gen_expr e; gen_addr v; store_op]
    | Print e ->
        SEQ [gen_expr e; CONST 0; GLOBAL "lib.print"; PCALL 1]
    | Newline ->
        SEQ [CONST 0; GLOBAL "lib.newline"; PCALL 0]
    | IfStmt (test, thenpt, elsept) ->
        let lab1 = label () and lab2 = label () and lab3 = label () in
        SEQ [gen_cond test lab1 lab2; 
          LABEL lab1; gen_stmt thenpt; JUMP lab3;
          LABEL lab2; gen_stmt elsept; LABEL lab3]
    | WhileStmt (test, body) ->
        let lab1 = label () and lab2 = label () and lab3 = label () in
        SEQ [JUMP lab2; LABEL lab1; gen_stmt body; 
          LABEL lab2; gen_cond test lab1 lab3; LABEL lab3]

let gen_decl (Decl (xs, t)) =
  let s = type_size t in
  List.iter (fun x ->
      let d = get_def x in
      printf "GLOVAR $ $\n" [fStr d.d_lab; fNum s]) xs

(* |translate| -- generate code for the whole program *)
let translate (Program (ds, ss)) = 
  let code = gen_stmt ss in
  printf "PROC MAIN 0 0 0\n" [];
  Keiko.output (if !optflag then Peepopt.optimise code else code);
  printf "RETURN\n" [];
  printf "END\n\n" [];
  List.iter gen_decl ds
