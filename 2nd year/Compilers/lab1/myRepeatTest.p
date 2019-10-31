(* lab1/repeat.p *)

begin
  i := 0;
  j := 27;
  repeat
    i := i + 3; 
    j := j - 4;
    print i; 
    print j;
    newline
  until i > j
end.

(*<<
 3 23
 6 19
 9 15
 12 11
>>*)
