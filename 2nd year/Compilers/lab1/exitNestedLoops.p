(* lab1/exitNestedLoops.p *)

begin
    i := 0;
    loop
        if i >= 5 then exit end;

        j := i;
        loop 
            if j >= 5 then exit end;
            print i; print j;
            newline;
            j := j + 1;
        end;

        i := i + 1
    end
end.

(*<<
 0 0
 0 1
 0 2
 0 3
 0 4
 1 1
 1 2
 1 3
 1 4
 2 2
 2 3
 2 4
 3 3
 3 4
 4 4
>>*)
