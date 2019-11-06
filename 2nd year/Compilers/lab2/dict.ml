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

(* Not an array exception *)
exception Not_an_array of ptype

(* Type not defined, probably void *)
exception Type_not_defined of ptype

(* |def| -- definitions in environment *)
type def = 
  { d_tag: ident;               (* Name *)
    d_type: ptype;              (* Type *)
    d_lab: string }             (* Global label *)

module IdMap = Map.Make(struct type t = ident  let compare = compare end)

type environment = Env of def IdMap.t

let can f x = try f x; true with Not_found -> false

(* |define| -- add a definition *)
let define d (Env e) = 
  if can (IdMap.find d.d_tag) e then raise Exit;
  Env (IdMap.add d.d_tag d e)

(* |lookup| -- find definition of an identifier *)
let lookup x (Env e) = IdMap.find x e

(* |init_env| -- empty environment *)
let init_env = Env IdMap.empty

(* |type_size| -- return size of this type *)
let rec type_size = function 
  | Integer -> 4
  | Boolean -> 1
  | Array (count, sub_type) -> count * (type_size sub_type)
  | x -> raise (Type_not_defined x)

(* |is_array| -- check if the given type is an array *)
let is_array = function
  | Array _ -> true
  | _ -> false

(* |base_type| -- return the base type of an array *)
let base_type = function 
  | Array (_, sub_type) -> sub_type
  | x -> raise (Not_an_array x)

(* |length_of| -- get length of an array *)
let length_of = function
  | Array (x, _) -> x
  | x -> raise (Not_an_array x)

