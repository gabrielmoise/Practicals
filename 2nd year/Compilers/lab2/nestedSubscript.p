var d: array 32 of array 100 of integer;
var d2: array 131 of integer;
var v: integer;
begin
    d2[13] := 23;
    d2[93] := 94;
    d2[14] := 93;
    d2[12] := 13;
    d[23][93] := 111;
    d[31][99] := 14;
    d[0][0] := 12;

    print d[0][0];
    print d2[d[0][0]];
    print d2[d2[d[0][0]]];
    print d[31][99];
    print d2[d[31][99]];
    print d2[d2[d[31][99]]];
    print d[d2[13]][d2[14]];
    print d[d2[d2[d[0][0]]]][d2[d[31][99]]];
    print d[23][93];
    newline
end.

(*<<
 12 13 23 14 93 94 111 111 111
>>*)
