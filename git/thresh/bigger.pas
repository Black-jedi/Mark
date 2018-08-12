program bigger;

var
a,b,c,res: integer;

begin
write('write your number:');
readln(a,b,c);
        if (a>b) and (a>c) then
                begin
                res:=a;
                end
        else
                begin
                        if(b>c) then
                                begin
                                res:=b;
                                end
                        else
                                begin
                                res:=c;
                                end
                end;
writeln('the bigger: ', res);
readln;
end.
