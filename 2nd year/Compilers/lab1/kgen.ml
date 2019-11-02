(* lab1/kgen.ml *)
(* Copyright (c) 2017 J. M. Spivey *)

open Tree
open Keiko
open List

let optflag = ref false

(* |cost| -- compute maximal depth of stack needed to compute an expression *)
let rec cost = function
    Constant x -> 1
  | Variable x -> 1
  | Monop (op, x) -> cost x
  | Binop (op, x, y) -> 
    let cx = cost x and cy = cost y in
    min (max (cx + 1) cy) (max cx (cy + 1))
  | IfExpr (test, x, y) -> 
    let ct = cost test and cx = cost x and cy = cost y in
    max ct (max cx cy)

(* |gen_expr| -- generate code for an expression *)
let rec gen_expr =
  function
      Constant x ->
        CONST x
    | Variable x ->
        SEQ [LINE x.x_line; LDGW x.x_lab]
    | Monop (w, e1) ->
        SEQ [gen_expr e1; MONOP w]
    | Binop (w, e1, e2) ->
        SEQ [gen_expr e1; gen_expr e2; BINOP w]
    | IfExpr (test, e1, e2) ->
        let lab1 = label () and lab2 = label () and lab3 = label () in
        SEQ [gen_cond test lab1 lab2; 
          LABEL lab1; gen_expr e1; JUMP lab3;
          LABEL lab2; gen_expr e2; LABEL lab3]

(* |gen_expr_minimal_stack| - generate code for expression depending on cost *)
(* not working because SWAP does not have the required behaviour *)
and gen_expr_minimal_stack = 
    function
        Constant x -> CONST x
      | Variable x -> SEQ [LINE x.x_line; LDGW x.x_lab]
      | Monop (w, e1) -> SEQ [gen_expr_minimal_stack e1; MONOP w]
      | Binop (w, e1, e2) ->
        let cx = cost e1 and cy = cost e2 in
        if cx < cy then 
            SEQ [gen_expr_minimal_stack e1; gen_expr_minimal_stack e2; BINOP w]
        else
            SEQ [gen_expr_minimal_stack e2; gen_expr_minimal_stack e1; SWAP; BINOP w]
      | IfExpr (test, e1, e2) -> gen_expr (IfExpr (test, e1, e2)) 
            

(* |gen_cond| -- generate code for short-circuit condition *)
and  gen_cond e tlab flab =
  (* Jump to |tlab| if |e| is true and |flab| if it is false *)
  match e with
      Constant x ->
        if x <> 0 then JUMP tlab else JUMP flab
    | Binop ((Eq|Neq|Lt|Gt|Leq|Geq) as w, e1, e2) ->
        SEQ [gen_expr e1; gen_expr e2; JUMPC (w, tlab); JUMP flab]
    | Monop (Not, e1) ->
        gen_cond e1 flab tlab
    
    | Binop (And, e1, e2) ->
        let auxiliary_expr = IfExpr (e1, e2, Constant 0) in
        gen_cond auxiliary_expr tlab flab
    

    (*| Binop (And, e1, e2) ->
        let lab1 = label () in
        SEQ [gen_cond e1 lab1 flab; LABEL lab1; gen_cond e2 tlab flab]
    *)
    | Binop (Or, e1, e2) ->
        let lab1 = label () in
        SEQ [gen_cond e1 tlab lab1; LABEL lab1; gen_cond e2 tlab flab]
    | _ ->
        SEQ [gen_expr e; CONST 0; JUMPC (Neq, tlab); JUMP flab]

(* |gen_stmt| -- generate code for a statement *)
let rec gen_stmt exit_lab s =
  match s with
      Skip -> NOP
    | Seq stmts -> SEQ (List.map (gen_stmt exit_lab) stmts)
    | Assign (v, e) ->
        SEQ [LINE v.x_line; gen_expr e; STGW v.x_lab]
    | Print e ->
        SEQ [gen_expr e; CONST 0; GLOBAL "lib.print"; PCALL 1]
    | Newline ->
        SEQ [CONST 0; GLOBAL "lib.newline"; PCALL 0]
    | IfStmt (test, thenpt, elsept) ->
        let lab1 = label () and lab2 = label () and lab3 = label () in
        SEQ [gen_cond test lab1 lab2; 
          LABEL lab1; gen_stmt exit_lab thenpt; JUMP lab3;
          LABEL lab2; gen_stmt exit_lab elsept; LABEL lab3]
    | WhileStmt (test, body) ->
        let lab1 = label () and lab2 = label () and lab3 = label () in
        SEQ [JUMP lab2; LABEL lab1; gen_stmt exit_lab body; 
             LABEL lab2; gen_cond test lab1 lab3; LABEL lab3]
    | RepeatStmt (body, test) ->
        let lab1 = label () and lab2 = label () in
        SEQ [LABEL lab1; gen_stmt exit_lab body; 
             gen_cond test lab2 lab1; LABEL lab2]
    | LoopStmt body ->
        let lab1 = label () and lab2 = label() in
        SEQ [LABEL lab1; gen_stmt lab2 body; JUMP lab1; LABEL lab2]
    | Exit -> 
        JUMP exit_lab
    | CaseStmt (switch, cases, default) ->
        let def_lab = label () and exit_lab = label () in (* default & exit labels *)

        let new_label _ = label () in (* returns a new label *)
        let branch_labels = map new_label cases in (* all branch labels *) 
        let cases_label_list = combine cases branch_labels in (* cases with their label *)
        let reverse_pair_up b a = (a, b) in (* reversed pair up *)
        let append_label ((numbers, _), label) = map (reverse_pair_up label) numbers in (* append label *)
        let case_label_list = concat (map append_label cases_label_list) in (* each case with its label*)
        
        let branch_code ((_, stmts), label) = SEQ [LABEL label; gen_stmt exit_lab stmts; JUMP exit_lab] in 
        let branches_code = SEQ (map branch_code cases_label_list) in (* code for each branch *)

        let control_code = gen_expr switch in (* code for control expression *)

        let add_casearm (number, label) = (CASEARM (number, label)) in        
        let casearms = map add_casearm case_label_list in (* all casearms *)
        let casearms_count = length casearms in
        let case_code = SEQ [CASEJUMP casearms_count; SEQ casearms; JUMP def_lab] in

        let default_code = SEQ [LABEL def_lab; gen_stmt exit_lab default; LABEL exit_lab] in

        SEQ [control_code; case_code; branches_code; default_code]
    | MultipleWhileStmt branches -> 
       let ini_lab = label()  in
       let build_if_stmt (test, body) = 
            let if_lab = label () and else_lab = label() in
            SEQ [gen_cond test if_lab else_lab; LABEL if_lab; 
                 gen_stmt exit_lab body; JUMP ini_lab; LABEL else_lab] in
       let if_stmts = map build_if_stmt branches in
       SEQ [LABEL ini_lab; SEQ if_stmts]
            

(* |translate| -- generate code for the whole program *)
let translate (Program ss) =
  let exit_lab = label () in
  let code = SEQ [gen_stmt exit_lab ss; LABEL exit_lab] in
  Keiko.output (if !optflag then Peepopt.optimise code else code)
