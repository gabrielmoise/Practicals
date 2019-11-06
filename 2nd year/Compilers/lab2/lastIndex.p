(* lab2/gcd.p *)

var x, y: integer;
var z: array 10 of array 10 of array 10 of integer;
begin
    x := 9;
    z[5][0][x] := 19;
    print z[5][0][x];
    newline
end.

(*<<
 19
>>*)
