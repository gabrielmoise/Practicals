var d: array 32 of boolean;
var v: integer;
begin
  d[5] := true;
  d[4] := true;
  d[6] := true;

  v := 0;
  if d[5] then v := v + 1 end;
  if d[4] then v := v + 2 end;
  if d[6] then v := v + 4 end;
  print v;
  newline
end.

(*<<
 7
>>*)
