(* lab1/exitAsReturn.p *)

begin
    i := 0;
    while i < 5 do
        print i;
        newline;

        if i = 3 then 
            exit
        end;

        i := i + 1;
    end
end.

(*<<
 0
 1
 2
 3
>>*)
