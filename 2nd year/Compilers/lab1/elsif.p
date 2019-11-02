(* lab1/elsif.p *)

begin   
    x := 1;
    if x <= 2 then
        if x = 1 then
            y := 10
        else
            y := 11
        end;
    else
        y := 12
    end;

    print y; newline;

    if (y > 11) then
        z := 101
    else
        if y = 9 then
            z := 102;
        else
            z := 103;
        end;
    end;

    print z;
    newline;
end.

(*<<
 10
 103
>>*)
