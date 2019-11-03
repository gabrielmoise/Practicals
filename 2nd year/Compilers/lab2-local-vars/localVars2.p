(* lab2/localVars2.p *)

var x, y: integer;
begin
    y := 4;
    local 
        var y: integer;
    in
        local 
            var z: integer;
        in
            z := 100;
            local var z: integer; in
                z := 3;
                y := 3 + 4 + z; x := y * y;
            end;
        end;
    end;
    print x + y;
    newline;


end.

(*<<
 104
>>*)
