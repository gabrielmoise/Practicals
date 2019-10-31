(* lab1/exitInWhile.p *)

begin
    i := 1;
    while i <= 10 do
        if i = 7 then exit end;
        print(i); newline;
        i := i + 2;
    end;
    print 19
end.

(*<<
 1
 3
 5
>>*)
