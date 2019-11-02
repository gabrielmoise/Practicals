open Tree
open Printf
open Keiko

let rec cost = function
    Constant x -> 1
  | Variable x -> 1
  | Monop (op, x) -> cost x
  | Binop (op, x, y) -> 
    let cx = cost x and cy = cost y in
    min (max (cx + 1) cy) (max cx (cy + 1))

let expr = Binop (Plus, Binop(Plus, Binop(Plus, Constant 4, Constant 5), Monop(Not, Constant 3)), Binop(Plus, Constant 1, Constant 2))

let expr_cost = cost expr;;

printf "%d" expr_cost;;
