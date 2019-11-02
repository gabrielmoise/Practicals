(* lab1/multipleWhile.p *)

begin
  x := 7 * 37;
  y := 7 * 121;
  
  while x > y do
    x := x - y
  elsif x < y do
    y := y - x
  end;

  print x; print y;
  newline;
end.

(*<<
 7 7
>>*)
