(* lab1/myCaseTest.p *)

begin
  i := 0;
  while i < 10 do
    case i mod 6 of
        0, 3: i := i + 4
      | 1, 4: i := i - 1
    else
      i := -300
    end;
    print i; newline
  end
end.

(*<<
 4
 3
 7
 6
 10
>>*)
