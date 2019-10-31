(* lab1/caseNoElse.p *)

begin
  i := 0;
  while i < 10 do
    case i of
      1, 3, 5:
        i := i + 1;
        i := i + 2
    | 2, 6: 
        i := i - 1;
    | 8:
        i := i + 2;
    end;
    print i; newline;
    i := i + 1
  end
end.

(*<<
 0
 4
 8
 9
>>*)
