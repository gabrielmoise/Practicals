(* lab2/localVars.p *)

var x, y: integer;
begin
    y := 4;
    local 
        var y: integer;
    in 
        y := 3 + 4; x := y * y;
    end;
    print x + y;
    newline;
end.

(*<<
 53
>>*)
