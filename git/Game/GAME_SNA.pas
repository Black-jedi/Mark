program snake;
Uses CRT;
type
   line=10..13;
{------------------------------------------}
procedure cursoroff;
begin
end;
procedure Ramka;
const
     width = 80;
     height = 25;
     col = 4;
var
    i,k: integer;
begin

     for i:=1 to width do
         for k:=col downto 1  do
             begin
                  Gotoxy(i,k);
                  Write(#176);

                  Gotoxy(i,height-k);
                  Write(#176);
             end;

      for i:=col+1 to height-(col+1) do
          for k:=col+3 downto 1 do
              begin
                   Gotoxy(k,i);
                   Write(#176);

                   Gotoxy(width-k+1,i);
                   Write(#176);
              end;
end;

{------------------------------------------}

procedure StartGame(var flag: boolean; var linecursor: line);

     procedure downcursor(var cursorx, cursory : byte);
     const
          cursor=#17;
     begin
          Gotoxy(cursorx,cursory);
          write(' ');
          INC(cursory);

          if cursory = 14 then
             cursory:=10;

          Gotoxy(cursorx,cursory);
          write(cursor);
     end;

     procedure upcursor(var cursorx,cursory: byte);
     const
          cursor=#17;
     begin
          Gotoxy(cursorx,cursory);
          write(' ');
          DEC(cursory);

          if cursory = 9 then
             cursory:=13;

          Gotoxy(cursorx,cursory);
          write(cursor);
     end;

const
     messeg1 = ' Play ';
     messeg2 = ' Options ';
     messeg3 = ' Records ';
     messeg4 = ' Exit ';
var
     key : char;
     cursorx,cursory : byte;
     EnterPressed: boolean;
begin
     Ramka;
     cursorx:=46;
     cursory:=10;
     EnterPressed:=true;

     Gotoxy((80-Length(messeg1))div 2,10);
     Write(messeg1);
     Gotoxy(cursorx,cursory);
     write(#17);
     Gotoxy((80-Length(messeg2))div 2,11);
     Write(messeg2);
     Gotoxy((80-Length(messeg3))div 2,12);
     Write(messeg3);
     Gotoxy((80-Length(messeg4))div 2,13);
     Write(messeg4);
     Gotoxy(47,10);
     while EnterPressed do
          if keypressed then
             begin
                 key := Readkey;

                 if key = #13 then
                    begin
                         EnterPressed:=false;
                         linecursor:=wherey;
                    end;
                 case key of
                      'w','W': upcursor(cursorx,cursory);
                      's','S': downcursor(cursorx,cursory);
                 end;
              end;

end;

{------------------------------------------}

Function play( time : word; element: char) : boolean;
Const
     N=8;
     messeg='Score: ';
type
    horizontal = 4..76;
    vertikal= 4..22;
   snakearray =  array [1..N] of byte;
    textfile = text;
{-------------------------------}

Function screenofdeath (score: longint ) : boolean;
type
    st6=string;
{-------------------------------}

procedure login (var log: st6);
const
     enterlogin='Enter you login: ______';
begin
     repeat
     Gotoxy((80-Length(enterlogin)) div 2,6);
     write(enterlogin);
     Gotoxy(45,6);
     readln(log);
     until length(log) = 6;

end;
{-------------------------------}
const
     Text=' Do you want play again? ';
     yes = '  yes  ';
     no = '  no  ';
     y= 10;
     cursor=#30;
     srcname='d:\name.txt';
     srcscore='d:\score.txt';
     n=10;
var
   name,s: st6;
   fname,fscore : textfile;
   arrayname: array [1..n] of string;
   arrayscore: array[1..n] of integer;
   x,i,k: byte;
   c: integer;
   direct: char;
   Enterpressed: boolean;
begin

     x:=36;
     Enterpressed:=false;
     clrscr;
     ramka;
     login(name);

     assign(fname,srcname);
     assign(fscore,srcscore);
     reset(fname);
     reset(fscore);

     for i:=1 to n do
       begin
            Readln(fname,arrayname[i]);
            readln(fscore,arrayscore[i]);
       end;

     for i:=1 to n-1 do
         for k:=i+1 to n do
             begin
                  if arrayscore[i] > arrayscore[k] then
                     begin
                          c:=arrayscore[i];
                          arrayscore[i]:=arrayscore[k];
                          arrayscore[k]:=c;

                          s:=arrayname[i];
                          arrayname[i]:=arrayname[k];
                          arrayname[k]:=s;
                     end;
             end;

     for i:=10 downto 1 do
         if score>= arrayscore[i] then
            begin
                 arrayscore[i]:=score;
                 arrayname[i]:=name;
                 break;
            end;

     rewrite(fscore);
     rewrite(fname);

     for i:=1 to n do
         begin
              Writeln(fscore,arrayscore[i]);
              Writeln(fname,arrayname[i]);
         end;
     close(fscore);
     close(fname);
     Gotoxy ((80 - Length(text)) div 2,8);
     write(text);
     Gotoxy((80 - (Length(yes)+Length(no))) div 2,9);
     write(yes,no);
     Gotoxy(x,y);
     write(cursor);
     gotoxy(35,12);
     write(name,' - ',score);

     repeat
           if keypressed then
              begin
                   direct:=readkey;
                   if direct=#13 then
                      if x=42 then
                         begin
                         EnterPressed := true;
                         screenofdeath:=true
                         end
                    else
                        begin
                          EnterPressed:=true;
                          screenofdeath:=false;

                        end;
                   case direct of
                        'A','a' :
                                begin
                                     gotoxy(x,y);
                                     write(' ');
                                     x:=x-6;
                                     if x=30 then
                                        x:=42;
                                     Gotoxy(x,y);
                                     Write(cursor);
                                end;
                        'D','d' :
                                begin
                                     gotoxy(x,y);
                                     write(' ');
                                     x:=x+6;
                                     if x= 48 then
                                        x:=36;
                                     Gotoxy(x,y);
                                     Write(cursor);
                                 end;
                   end;
              end;
     until Enterpressed;

end;

{-------------------------------}

Function upsnake(x : horizontal; var y : vertikal; element: char; time: word; score: longint) : boolean;
begin

     delay(time);
     Dec(y);

     if (y=4) and screenofdeath(score) then
        upsnake:=true
     else
        upsnake:=false;

     Gotoxy(x,y);
     Write(element);
     Gotoxy(x,y+1);
     Write(' ');

end;

{-------------------------------}

Function leftsnake(var x : horizontal; y : vertikal; element: char; time: word; score: longint) : boolean;
begin

     Delay(time);
     Dec(x);

     if (x=7) and screenofdeath(score) then
        leftsnake:= true
     else
        leftsnake:=false;

     Gotoxy(x,y);
     Write(element);
     Gotoxy(x+1,y);
     Write(' ');

end;

{-------------------------------}

Function Downsnake (x : horizontal ; var y : vertikal; element : char; time: word; score: longint) : boolean;
begin

     delay(time);
     Inc(y);

     if (y=21) and screenofdeath(score) then
        downsnake:=true
     else
         downsnake:=false;

     Gotoxy(x,y);
     Write(element);
     Gotoxy(x,y-1);
     Write(' ');

end;

{-------------------------------}

Function Rightsnake (var x: horizontal ; y : vertikal; element: char; time: word; score: longint) : boolean;
begin

     Delay(time);
     Inc(x);

     if (x=73) and screenofdeath(score) then
        rightsnake:=true
     else
        rightsnake:=false;



     Gotoxy(x,y);
     Write(element);
     Gotoxy(x-1,y);
     Write(' ');
end;

{----------------------------------}

Procedure RandomSquare (var xsquare,ysquare: byte; var xarray,yarray : snakearray; x: horizontal;y:vertikal);
var
   i: integer;
Const
 ymin=6;
 ymax=19;
 xmin=9;
 xmax=71;
 N=8;
begin
randomize;
xsquare:=random(xmax-xmin)+xmin;
ysquare:=random(ymax-ymin)+ymin;
Gotoxy(xsquare,ysquare);
Write(#219);
delay(65000);
gotoxy(xsquare,ysquare);
Write(' ');

xarray[1]:= xsquare-1;
xarray[2]:= xarray[1];
xarray[3]:= xsquare;
xarray[4]:= xsquare+1;
xarray[5]:= xarray[4];
xarray[6]:= xarray[4];
xarray[7]:= xarray[3];
xarray[8]:= xarray[2];

yarray[1]:= ysquare;
yarray[2]:= ysquare-1;
yarray[3]:= yarray[2];
yarray[4]:= yarray[2];
yarray[5]:= ysquare;
yarray[6]:= ysquare+1;
yarray[7]:= yarray[6];
yarray[8]:= yarray[6];

for i:=1 to N do
    begin
         Gotoxy(xarray[i],yarray[i]);
         Write(#219);
    end;
end;

{-------------------------------}

var
   xsquare,ysquare,clock,i: byte;

   score: longint;
   x : horizontal;
   y : vertikal;
   gameend,s,boo : boolean;
   wasd,k: char;
   mnog: set of char;

   xarray,yarray: snakearray;
begin
     score:=0;
     s:=true;
     while s do
     begin
     clock:=0;


     x := 40;
     y := 13;
     GameEnd := true;
     wasd := 'a';
     mnog := ['w','W','a','A','s','S','d','D'];
     clrscr;
     Ramka;
     RandomSquare(xsquare,ysquare,xarray,yarray,x,y);


     Gotoxy(x,y);
     Write(element);

     repeat
          Gotoxy(5,23);
          write(messeg,score);
          if clock=8 then
              begin
                   RandomSquare(xsquare,ysquare,xarray,yarray,x,y);
                   clock:=0;
                   score:=score+100;
              end;

           if xarray[1] > 8 then
              begin
                   gotoxy(xarray[1],yarray[1]);   {1}
                   write(' ');
                   xarray[1]:=xarray[1]-1;
                   gotoxy(xarray[1],yarray[1]);
                   write(#219);
               end
           else
               begin

                    if xarray[1] = 8 then
                       begin
                            gotoxy(xarray[1],yarray[1]);
                            write(' ');
                            inc(clock);
                            xarray[1]:=1;
                            yarray[1]:=1;
                       end;
               end;

           if (xarray[2] > 8) and (yarray[2] > 5)then
              begin
                   gotoxy(xarray[2],yarray[2]);
                   write(' ');
                   xarray[2]:=xarray[2]-1;
                   yarray[2]:=yarray[2]-1;
                   gotoxy(xarray[2],yarray[2]);
                   write(#219);
              end
           else
               begin
                    if (xarray[2] = 8) or (yarray[2] = 5) then
                       begin
                            gotoxy(xarray[2],yarray[2]);
                            write(' ');
                            inc(clock);
                            xarray[2]:=1;
                            yarray[2]:=1;
                       end;
               end;

           if yarray[3] > 5 then
              begin
                   gotoxy(xarray[3],yarray[3]);
                   write(' ');
                   yarray[3]:=yarray[3]-1;
                   gotoxy(xarray[3],yarray[3]);
                   write(#219);
              end
           else
              begin
                   if yarray[3] = 5 then
                      begin
                            gotoxy(xarray[3],yarray[3]);
                            write(' ');
                            inc(clock);
                            xarray[3]:=1;
                            yarray[3]:=1;
                       end;
              end;

           if (xarray[4] < 71) and (yarray[4] > 5) then
              begin
                   gotoxy(xarray[4],yarray[4]);
                   write(' ');
                   xarray[4]:=xarray[4]+1;
                   yarray[4]:=yarray[4]-1;
                   gotoxy(xarray[4],yarray[4]);
                   write(#219);
               end
            else
                begin
                     if (xarray[4] = 71) or (yarray[4] = 5) then
                        begin
                            gotoxy(xarray[4],yarray[4]);
                            write(' ');
                            inc(clock);
                            xarray[4]:=1;
                            yarray[4]:=1;
                        end;
                end;

           if xarray[5] < 71 then
              begin
                   gotoxy(xarray[5],yarray[5]);
                   write(' ');
                   xarray[5]:=xarray[5]+1;
                   gotoxy(xarray[5],yarray[5]);
                   write(#219);
              end
           else
              begin

                   if xarray[5] = 71 then
                      begin
                            gotoxy(xarray[5],yarray[5]);
                            Write(' ');
                            inc(clock);
                            xarray[5]:=72;
                            yarray[5]:=72;
                       end;
              end;

           if (xarray[6] < 71) and (yarray[6] < 20) then
              begin
                   gotoxy(xarray[6],yarray[6]);
                   write(' ');
                   xarray[6]:=xarray[6]+1;
                   yarray[6]:=yarray[6]+1;
                   gotoxy(xarray[6],yarray[6]);
                   write(#219);
              end
           else
              begin
                   if (xarray[6] = 71) or (yarray[6] = 20) then
                      begin
                            gotoxy(xarray[6],yarray[6]);
                            write(' ');
                            inc(clock);
                            xarray[6]:=72;
                            yarray[6]:=72;
                       end;
              end;

           if yarray[7] < 20 then
              begin
                   gotoxy(xarray[7],yarray[7]);
                   write(' ');
                   yarray[7]:=yarray[7]+1;
                   gotoxy(xarray[7],yarray[7]);
                   write(#219);
              end
           else
              begin
                   if yarray[7] = 20 then
                      begin
                            gotoxy(xarray[7],yarray[7]);
                            write(' ');
                            inc(clock);
                            xarray[7]:=21;
                            yarray[7]:=21;
                       end;
              end;
           if (xarray[8] > 8) and (yarray[8] < 20) then
              begin
                   gotoxy(xarray[8],yarray[8]);
                   write(' ');
                   xarray[8]:=xarray[8]-1;
                   yarray[8]:=yarray[8]+1;
                   gotoxy(xarray[8],yarray[8]);
                   write(#219);
              end
           else
              begin
                   if (xarray[8] = 8) or (yarray[8] = 20) then
                      begin
                            gotoxy(xarray[8],yarray[8]);
                            write(' ');
                            inc(clock);
                            xarray[8]:=1;
                            yarray[8]:=1;
                       end;
              end;

           if keypressed then
              k := readkey;

           if k in mnog then
              wasd := k;

           case wasd of
                'w','W' : if upsnake(x,y,element,time,score) then
                             begin
                                  s:=false;
                                  GameEnd:=false;
                             end
                          else
                             begin
                                  if y=4 then
                                     GameEnd:=false;
                                  s:=true;
                             end;

                'a','A' : if leftsnake(x,y,element,time,score) then
                             begin
                                  s:=false;
                                  GameEnd:=false;
                             end
                          else
                             begin
                                  if x=7 then
                                     GameEnd:=false;
                                  s:=true;
                             end;
                's','S' : if downsnake(x,y,element,time,score) then
                             begin
                                  s:=false;
                                  GameEnd:=false;
                             end
                          else
                              begin
                                   if y=21 then
                                      GameEnd:=false;
                                   s:=true;
                              end;
                'd','D' : if rightsnake(x,y,element,time,score) then
                             begin
                                  s:=false;
                                  GameEnd:=false;
                             end
                          else
                              begin
                                   if x= 73 then
                                      GameEnd:=false;
                                   s:=true;
                              end;
           end;

            for i:=1 to N do
              begin
                 if (x = xarray[i]) and (y=yarray[i])  then
                    if Screenofdeath(score) then
                       begin
                            s:=false;
                            GameEnd:=false;
                       end
                    else
                       begin
                            s:=true;
                            GameEnd:=false;
                       end;

              end;
     until not GameEnd ;

     end;

     play := true;
end;

{------------------------------------------}

Function Options(var tb,tc : byte; var time: word; var element: char): boolean;
const
     info0 = ' OPTIONS ';
     info1 = ' Esc - menu ';
     info2 = ' Enter background color and text color: ';
     info3 = ' Teal    Lime    Peach ';
     info4 = ' Choose a speed game: ';
     info5 = 'Slow    Fast';
     info6 = ' Choose view a cursor: ';
     info7 = #220#0#0#4#0#0#9#0#0#219#0#0#2;
var
   ch:char;
   flag: boolean;
   x,y: byte;
   cursor: char;
begin
     flag:=false;
     ch:= ' ';
     x:=31;
     y:=9;
     cursor:=#30;
     clrscr;
     ramka;
     gotoxy((80-Length(info0)) div 2,3);
     write(#25,info0,#25);
     gotoxy(9,22);
     write(info1);
     gotoxy((80-Length(info2)) div 2,6);
     write(info2);
     gotoxy((80-Length(info3)) div 2,8);
     write(info3);
     gotoxy(x,y);
     write(cursor);
     gotoxy((80-Length(info4)) div 2,10);
     write(info4);
     gotoxy((80-Length(info5)) div 2,12);
     write(info5);
     gotoxy((80-Length(info6)) div 2,14);
     write(info6);
     gotoxy((80-Length(info7)) div 2,16);
     write(info7);
     repeat
           if keypressed then;
              ch:=readkey;
           if ch = #27 then
              begin
                   flag:=true;
                   options:=false;
              end;

              case ch of
                   'D','d': begin
                           if y=9 then begin
                                 gotoxy(x,y);
                                 write(' ');
                                 if x=47 then
                                    begin
                                         x:=23;
                                    end;
                                 x:=x+8;
                                 gotoxy(x,y);
                                 write(cursor);
                            end;

                            if y=13 then
                            begin
                                  gotoxy(x,y);
                                  write(' ');
                                  if x=43 then
                                    begin
                                         x:=27;
                                    end;
                                 x:=x+8;
                                 gotoxy(x,y);
                                 write(cursor);
                            end;
                            if y=17 then
                               begin
                                     gotoxy(x,y);
                                    write(' ');
                                    x:=x+3;
                                    if x=48 then
                                       x:=33;

                                    gotoxy(x,y);
                                    write(cursor);
                               end;

                        end;
                        'A','a': begin
                            if y=9 then
                            begin
                                 gotoxy(x,y);
                                 write(' ');
                                 if x=31 then
                                    begin
                                         x:=55;
                                    end;
                                 x:=x-8;
                                 gotoxy(x,y);
                                 write(cursor);
                            end;
                             if y=13 then
                            begin
                                  gotoxy(x,y);
                                  write(' ');
                                  if x=35 then
                                    begin
                                         x:=51;
                                    end;
                                 x:=x-8;
                                 gotoxy(x,y);
                                 write(cursor);
                            end;
                            if y=17 then
                               begin
                                    gotoxy(x,y);
                                    write(' ');
                                    x:=x-3;
                                    if x=30 then
                                       x:=45;
                                    gotoxy(x,y);
                                    write(cursor);
                               end;
                            end;
                     #13 :
                            begin
                                 case x of
                                 31: begin
                                         tb:=1;
                                         tc:=11;
                                    end;
                                 39:  begin
                                         tb:=2;
                                         tc:=7;
                                         if y=17 then
                                            element:=#9;
                                    end;
                                 47:  begin
                                         tb:=7;
                                         tc:=1;
                                      end;
                                 35: time:=55000;
                                 43: time:=15000;
                                 33: element:=#220;
                                 36: element:=#4;
                                 42: element:=#219;
                                 45: element:=#2;

                                 end;
                            end;

                   'S','s': begin
                                gotoxy(x,y);
                                write(' ');
                                y:=y+4;
                                if y=13 then
                                   x:=35;
                                if y=17 then
                                   x:=33;
                                if y=21 then
                                   begin
                                        y:=9;
                                        x:=31;
                                   end;
                                gotoxy(x,y);
                                write(cursor);

                            end;
                      'W','w': begin
                                gotoxy(x,y);
                                write(' ');
                                y:=y-4;
                                if y=9 then
                                   x:=31;
                                if y=13 then
                                   x:=35;
                                if y=5 then
                                   begin
                                        y:=17;
                                        x:=33;
                                   end;
                                gotoxy(x,y);
                                write(cursor);
                               end;
              end;
     until flag;
end;

{------------------------------------------}

Function Records : boolean;
const
     srcscore='d:\score.txt';
     srcname='d:\name.txt';
     n=1;
     info0=' RECORDS ';
     info1='Enter - menu';
     info2='Esc - exit';
var
   i:integer;
   fscore,fname: text;
   name: string;
   score: integer;
   flag: boolean;
   ch: char;
begin
     ch:=' ';
     clrscr;
     ramka;
     flag:=false;
     assign(fscore,srcscore);
     assign(fname,srcname);
     reset(fname);
     reset(fscore);
     for i:=10 downto n do
         begin
              readln(fname,name);
              readln(fscore,score);
              Gotoxy(34, 7+i);
              write(name,' - ', score);
         end;
      gotoxy((80-Length(info0)) div 2,3);
      write(#25,info0,#25);
      gotoxy(9,22);
      write(info1);
      gotoxy(63,22);
      write(info2);

     repeat
           if keypressed then
              ch:=readkey;
           case ch of
                #13 : begin
                           flag:=true;
                           records:=false;
                      end;
                #27 : begin
                           flag:=true;
                           records:=true;
                      end;
           end;

     until flag;
end;

{------------------------------------------}
var
   flag,gameover: boolean;
   linecursor: line;
   tb,tc: byte;
   time: word;
   element: char;
begin
   cursoroff;
   tb:=1;
   tc:=11;
   time:=55000;
   element:=#220;
   repeat

         textbackground(tb);
         textcolor(tc);
         clrscr;
         StartGame(flag,linecursor);

         case linecursor of
              10 : gameover := play(time, element) ;
              11 : gameover := options(tb,tc,time,element) ;
              12 : gameover := records;
              13 : gameover := true;
         end;
    until gameover ;

end.
