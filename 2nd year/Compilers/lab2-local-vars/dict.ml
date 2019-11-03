(* lab2/dict.ml *)
(* Copyright (c) 2017 J. M. Spivey *)

(* Environments are implemented using a library module that 
   represents mappings by balanced binary trees. *)

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

module IdMap = Map.Make(struct type t = ident  let compare = compare end)

type environment = Env of def IdMap.t

let can f x = try f x; true with Not_found -> false

(* |lookup| -- find definition of an identifier *)
let lookup x (Env e) = IdMap.find x e

(* |variables| -- list of all variables defined locally of globally *)
let variables = ref []

(* |define| -- add a definition *)
let define d (Env e) = 
  if can (IdMap.find d.d_tag) e then 
  begin
    let current_value = lookup d.d_tag (Env e) in
    if current_value.d_lab = d.d_lab then
    begin
        raise Exit;
    end else begin
        variables := d :: (!variables);
        Env (IdMap.add d.d_tag d (IdMap.remove d.d_tag e))
    end
  end else begin
    variables := d :: (!variables);
    Env (IdMap.add d.d_tag d e)
  end

(* |init_env| -- empty environment *)
let init_env = Env IdMap.empty

(* |level| -- level of LOCAL ... IN ... END *)
let level = ref 0

