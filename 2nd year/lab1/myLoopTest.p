(* lab1/myLoopTest.p *)

begin
  i := 11 * 2;
  j := 17 * 2;

  loop
    print i; print j;
    newline;

    if i = j then exit end;
    
    if i <= j then
        j := j - i;
    else
        i := i - j;
    end

  end
end.

(*<<
 22 34
 22 12
 10 12
 10 2
 8 2
 6 2
 4 2
 2 2
>>*)
