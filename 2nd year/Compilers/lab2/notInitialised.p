(* lab2/notInitialised.p *)

var x, y, z, i: integer;

begin
    if 5 = 4 then
        y := 3; 
    else 
        z := 4;
    end;

    i := 10;
    while i < 20 do 
        z := i + 9;
        i := i + 1
    end;

    x := y + z;

    y := 13;
    print y; newline;
end.

(*<<
 13
>>*)
