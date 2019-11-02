(* lab1/loopGcd.p *)

begin
  x := 7 * 37;
  y := 7 * 121;
  loop
    if x > y then
        x := x - y 
    else 
        if x < y then
            y := y - x 
        else
            exit
        end;
    end;
  end;

  print x; print y;
  newline;
end.

(*<<
 7 7
>>*)
