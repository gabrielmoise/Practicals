(* lab2/dict.mli *)
(* Copyright (c) 2017 J. M. Spivey *)

type ident = string

type ptype = 
    Integer 
  | Boolean 
  | Array of int * ptype
  | Void

(* |def| -- definitions in environment *)
type def = 
  { d_tag: ident;               (* Name *)
    d_type: ptype;              (* Type *)
    d_lab: string }             (* Global label *)

type environment

(* |define| -- add a definition, raise Exit if already declared *)
val define : def -> environment -> environment

(* |lookup| -- search an environment or raise Not_found *)
val lookup : ident -> environment -> def

(* |init_env| -- initial empty environment *)
val init_env : environment

(* |level| -- level of LOCAL ... IN ... END *)
val level: int ref

(* |variables| -- list of all variables declared locally of globally *)
val variables: (def list) ref

