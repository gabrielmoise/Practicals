(* lab1/sqrt.p *)

begin
    target := 200000000;
    l := 1; r := 20000;
    
    (* (l - 1)^2 <= target and target < r^2 *)
    while l < r do 
        middle := (l + r) div 2;
        if middle * middle <= target then
            l := middle + 1
        else
            r := middle 
        end;
    end;

    print (l - 1);
    newline;
end.

(*<<
 14142
>>*)
