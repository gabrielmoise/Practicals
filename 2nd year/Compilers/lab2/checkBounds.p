(* lab2/gcd.p *)

var x: array 10 of integer;
var i, y: integer;
begin
    i := -1;
    (*x[i] := 19;*)
    (*y := x[i];*)

    i := 0;
    x[i] := 19;
    y := x[i];

    i := 9;
    x[i] := 19;
    y := x[i];

    i := 10;
    (*x[i] := 19;*)
    (*y := x[i];*)

    print i;
    newline
end.

(*<<
 10
>>*)
