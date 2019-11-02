(* lab1/ifExpr.p *)

begin
  x := 17;
  x := if x mod 2 = 1 then 91 else 94;
  print x; newline;
  x := if x mod 2 = 0 then 99 else 92;
  print x; newline;
end.

(*<<
 91
 92
>>*)
