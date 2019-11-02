(* lab1/modifiedAnd.p *)

begin
  a := 1;
  b := 2;
  c := 3; 
  d := 4;
  x := 10;
  
  if (x >= 9) and (x <= 11) then
    print a;
    newline;
  end;
  if (x >= 19) and (x <= 111) then
    print b;
    newline;
  end;
  if (x >= 1) and (x <= 5) then
    print c;
    newline;
  end;
  if (x >= 100) and (x <= 111) then
    print d;
    newline;
  end;

end.

(*<<
 1
>>*)
