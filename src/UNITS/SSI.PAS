{$A+,B+,D-,E-,F+,G+,I+,L-,N+,O+,P+,Q-,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
unit SSI;

interface
uses Crt;

type  TColor = record
 Text,
 Fon,
 SText,
 SFon  : Byte;
end;

type  TScreen = record
      Screen: array [0..3999] of Byte;
      X, Y: Byte;
end;

const NoneB = 0;
      SingleB = 1;
      DoubleB = 2;
      DeskTopColor: TColor = (Text : 1; Fon : 0; SText : 0; SFon : 7);
      EditColor: TColor = (Text : 7; Fon : 1; SText : 0; SFon : 7);
      WinColor: TColor = (Text : 0; Fon : 7; SText : 4; SFon : 7);
      WarningColor: TColor = (Text : 14; Fon : 4; SText : 4; SFon : 7);
      InfoColor: TColor = (Text : 0; Fon : 7; SText : 4; SFon : 7);
      ShadowColor: TColor = (Text : 7; Fon : 0; SText : 15; SFon : 0);

      NormalButton:   TColor = (Text : 0;  Fon : 2;  SText : 15; SFon : 2);
      SelectButton:   TColor = (Text : 15; Fon : 2;  SText : 12; SFon : 2);
      DefaultButton:  TColor = (Text : 7;  Fon : 2;  SText : 15; SFon : 2);
      DisabledButton: TColor = (Text : 8;  Fon : 2;  SText : 8;  SFon : 2);
      ShadowButton:   TColor = (Text : 0;  Fon : 7;  SText : 0;  SFon : 7);

      NormalInput:   TColor = (Text : 15; Fon : 1;  SText : 7;  SFon : 1);
      DisabledInput: TColor = (Text : 7;  Fon : 1;  SText : 7;  SFon : 1);
      ArrowInput:    TColor = (Text : 10; Fon : 1;  SText : 10; SFon : 1);

      LeftText = 0;
      RightText = 1;
      CenterText = 2;

      BorderChar: array [0..2,1..6] of Char =
       ((#32,  #32,  #32,  #32,  #32,  #32),
        (#218, #196, #191, #179, #192, #217),
        (#201, #205, #187, #186, #200, #188));

function  HexB(b: Byte): String;
function  HexW(w: Word): String;
function  HexI(i: Integer): String;
function  HexL(l: LongInt): String;
function  HexC(c: Comp): String;
function  UpString(s: String): String;
function  AddS(Str: String; s: Byte): String;
function  GetWord(str,str2: String; b: byte): String;
function  TotalWords(str, str2: String): Byte;
function  TotalS(str: String): Byte;
function  CountLine(lim: Byte; message: String): Byte;
function  ShowQDialog(size, loc, def: Byte; Handle, message, Key1, Key2: String; col: TColor): Boolean;
procedure ShowMDialog(size, loc: Byte; Handle, message, Key1: String; col: TColor);
procedure ShowTextWindow(x,y,lim, loc: Byte; message: String; col: TColor);
procedure ShowMessageWindow(size, loc: Byte; Handle, message: String; col: TColor);
procedure ShowMessageWindowXY(x, y, size, loc: Byte; Handle, message: String; col: TColor);
procedure CursorOff;
procedure CursorOn;
procedure SaveScreen(var ps: TScreen);
procedure RestoreScreen(var ps: TScreen);
procedure PutChar(x,y:Byte; c: Char; col: TColor);
procedure writestr(x,y: Byte; s: String; col: TColor);
procedure writestring(x,y: Byte; s: String; col: TColor);
procedure fillwindow(x,y,x2,y2: Byte; c: char; col: TColor);
procedure showwindow(x,y,x2,y2, border: Byte; handle: String; col: TColor);
procedure InputText(x,y,len,maxc: Byte; var str: String; col: TColor);
procedure ClearSL;
procedure WriteSL(str: String);
procedure ChangFon(x,y,x2,y2: Integer; Fon: Byte);
procedure ChangText(x,y,x2,y2: Integer; Text: Byte);
procedure ChangColor(x,y,x1,y1: Integer; col: TColor);
procedure ChangSColor(x,y,x2,y2: Integer; col: TColor);
procedure ShowButton(x,y,len: Integer; Text: String; col: TColor);

var TempColor: TColor;
    SSITempScreen: TScreen;

implementation

function  HexB(b: Byte): String;
const HD: array [0..15] of Char = ('0','1','2','3','4','5','6','7','8','9',
                                   'A','B','C','D','E','F');
begin
 HexB:=HD[b shr 4]+HD[b and $F];
end;

function  HexW(w: Word): String;
begin
 HexW:=HexB(Hi(w))+HexB(Lo(w));
end;

function  HexI(i: Integer): String;
var i1: Integer;
    w: Word absolute i1;
begin
 i1:=i;
 HexI:=HexW(w);
end;

function  HexL(l: LongInt): String;
var l1: LongInt;
    w:array [0..1] of Word absolute l1;
begin
 l1:=l;
 HexL:=HexW(w[1])+HexW(w[0]);
end;

function  HexC(c: Comp): String;
var c1: Comp;
    l: array [0..1] of LongInt absolute c1;
begin
 c1:=c;
 HexC:=HexL(l[1])+HexL(l[0]);
end;


function UpString(s: String): String;
var n: Byte;
begin
 for n:=1 to Length(s) do s[n]:=UpCase(s[n]);
 UpString:=s;
end;

function AddS(Str: String; s: Byte): String;
var n: Byte;
     ts: String;
begin
  ts:='';
  for n:=1 to s do ts:=ts+' ';
  if Length(str) < s then s:=Length(Str);
  for n:=1 to s do ts[n]:=str[n];
  AddS:=ts;
end;

 {Функция возвращает слово из строки по его номеру в строке}
 FUNCTION GetWord(str,str2: String; b: byte): String;
 VAR t,t1,c,f,l:byte;
     w: Byte;
 BEGIN
  str:=str+str2[1];
  c:=0;
  w:=1;
  f:=1;
  l:=1;
  FOR t:=1 TO Length(str) DO BEGIN
   IF Pos(str[t],str2) <> 0 THEN str[t]:=#1;
   IF str[t] <> #1 THEN BEGIN
    c:=c+w;
    IF w = 1 THEN f:=t;
    w:=0;
   END ELSE BEGIN
    w:=1;
    IF c=b THEN BEGIN
     GetWord:=copy(str,f,t-f);
     Exit;
    END;
   END;
  END;
  END;

 {Функция возвращает количество слов в строке, слова разделяются символами из переменной str2}
 FUNCTION TotalWords(str, str2: String): Byte;
 VAR t,c:byte;
     w:Byte;
 BEGIN
  c:=0;
  w:=1;
  FOR t:=1 TO Length(str) DO BEGIN
   IF Pos(str[t],str2) <> 0 THEN str[t]:=#1;
   IF str[t] <> #1 THEN BEGIN
    c:=c+w;
    w:=0;
   END ELSE w:=1;
  END;
  TotalWords:=c;
 END;

procedure CursorOff; assembler;
asm
 mov ah, 1
 mov ch, $20
 int $10
end;

procedure CursorON; assembler;
asm
 mov ah, 1
 mov ch, 1
 mov cl, 8
 int $10;
end;

procedure SaveScreen(var ps: TScreen);
var n: Word;
begin
 asm
  cli
  mov dx,$3da
  @2:
  in al, dx
  test al,1
  je @2
  sti
 end;
 for n:=0 to 3999 do ps.Screen[n]:=Mem[$B800:n];
 ps.x:=WhereX;
 ps.y:=WhereY;
end;

procedure RestoreScreen(var ps: TScreen);
var n: Word;
begin
 asm
  cli
  mov dx,$3da
  @2:
  in al, dx
  test al,1
  je @2
  sti
 end;
 for n:=0 to 3999 do
   Mem[$B800:n]:=ps.screen[n];
 GotoXY(ps.x,ps.y);
end;

procedure PutChar(x,y:Byte; c: Char; col: TColor);
var w: Word;
    b: Byte absolute w;
begin
 TextColor(col.Text);
 TextBackGround(col.Fon);
 w:=TextAttr SHL 8;
 b:=ord(c);
 asm
  cli
  mov dx,$3da
  @2:
  in al, dx
  test al,1
  je @2
  sti
 end;
 memw[$B800:(x-1)*2+(y-1)*160]:=w;
end;

procedure writestr(x,y: Byte; s: String; col: TColor);
var w, n: Word;
    b: Byte absolute w;
    lns: Byte absolute s;
begin
 TextColor(col.Text);
 TextBackGround(col.Fon);
 w:=TextAttr SHL 8;
 Dec(lns);
 asm
  cli
  mov dx,$3da
  @2:
  in al, dx
  test al,1
  je @2
  sti
 end;
 for n:=x to x+lns do begin
  b:=Ord(s[n-x+1]);
  MemW[$B800:(n-1)*2+(y-1)*160]:=w;
 end;
end;

procedure writestring(x,y: Byte; s: String; col: TColor);
var n,m: Byte;
    ts: String;
    ck, lc, lf: Byte;
begin
 if Pos('~',s) = 0 then WriteStr(x,y,s,col) else begin
  ts:=s;
  lc:=Col.Text;
  lf:=Col.Fon;
  while Pos('~',s) <> 0 do begin
   if Pos('~',s) <> 1 then WriteStr(x,y,Copy(s,1,Pos('~',s)-1),col);
   if Col.Text = Col.SText then begin
    Col.Text:=lc;
    Col.Fon:=lf;
   end else begin
    Col.Text:=Col.SText;
    Col.Fon:=Col.SFon;
   end;
   x:=x+Pos('~',s)-1;
   Delete(s,1,Pos('~',s));
  end;
  if s <> '' then WriteStr(x,y,s,col);
 end;
end;

procedure fillwindow(x,y,x2,y2: Byte; c: char; col: TColor);
var w, n, m: Word;
    b: Byte absolute w;
begin
 TextColor(col.Text);
 TextBackGround(col.Fon);
 w:=TextAttr SHL 8;
 b:=Ord(c);
 asm
  cli
  mov dx,$3da
  @2:
  in al, dx
  test al,1
  je @2
  sti
 end;
 for n:=x to x2 do
  for m:=y to y2 do MemW[$B800:(n-1)*2+(m-1)*160]:=w;
end;

procedure showwindow(x,y,x2,y2, border: Byte; handle: String; col: TColor);
var n: Byte;
begin
 FillWindow(x,y,x2,y2,' ',col);
 for n:=x to x2 do begin
  PutChar(n,y,BorderChar[border,2],col);
  PutChar(n,y2,BorderChar[border,2],col);
 end;
 for n:=y to y2 do begin
  PutChar(x,n,BorderChar[border,4],col);
  PutChar(x2,n,BorderChar[border,4],col);
 end;
 PutChar(x,y,BorderChar[border,1],col);
 PutChar(x2,y,BorderChar[border,3],col);
 PutChar(x,y2,BorderChar[border,5],col);
 PutChar(x2,y2,BorderChar[border,6],col);
 if handle = '' then exit;
 handle:=' '+handle+' ';
 if Length(Handle)-TotalS(Handle) > (x2-x-4) then Handle:=Copy(handle, 1, x2-x-5)+' ';
 WriteString(x + Round((x2 - x - (Length(handle)-TotalS(Handle)))/2), y, handle, col);
 if (x2+2 < 81) and (y2+1 < 26) then ChangSColor(x2+1,y+1,x2+2,y2+1,ShadowColor);
 if (x2 < 81) and (y2+1 < 26) then ChangSColor(x+2,y2+1,x2,y2+1,ShadowColor);
end;

procedure InputText(x,y,len,maxc: Byte; var str: String; col: TColor);
var n: Integer;
    tp,k,spos,lpos: Integer;
    s1,s: String;
begin
 if len > 80 then len:=80-x;
 s:=str;
 s1:=s;
 fillwindow(x,y,x+len-1,y,' ',col);
 x:=x+1;
 len:=len-2;
 writestring(x,y,AddS(s1,len),col);
 CursorOn;
 GotoXY(x+Length(s1),y);
 SPos:=Length(s)-len;
 if SPos < 1 then SPos:=1;
 LPos:=Length(s)-SPos+1;
 repeat
  k:=Ord(readkey);
  if (length(s) < maxc) and (k IN [32..255]) then begin
   s1:=chr(k);
   Insert(s1,s,SPos+LPos);
   LPos:=LPos+1;
   if LPos = len then begin
    SPos:=SPos+1;
    LPos:=len-1;
   end;
   if LPos = len then LPos:=Len-1;
  end;
  if k = 0 then begin
   k:=Ord(ReadKey);
   if (k = 75) then LPos:=LPos-1;
   if (k = 77) then LPos:=LPos+1;
   if k = 71 then begin
    Lpos:=0;
    SPos:=1;
   end;
   if k = 79 then begin
    SPos:=Length(s)-len;
    if SPos < 1 then SPos:=1;
    LPos:=Length(s)-SPos+1;
   end;
   if LPos < 0 then begin
    SPos:=SPos-1;
    if SPos < 1 then SPos:=1;
    LPos:=0;
   end;
   if LPos >= len then begin
    SPos:=SPos+1;
    LPos:=len-1;
    if SPos+LPos > Length(s) then Spos:=Spos-1;
   end;
   if LPos+SPos-1 > Length(s) then begin
    if LPos > 1 then LPos:=LPos-1 else begin
     LPos:=0;
     SPos:=SPos-1;
     if SPos < 1 then SPos:=1;
    end;
   end;
   if k = 83 then Delete(s,SPos+LPos,1);
  end;
  if (k = 8) and (SPos+LPos > 1) then begin
   LPos:=LPos-1;
   if LPos < 0 then begin
    SPos:=SPos-1;
    LPos:=0;
    if SPos < 1 then Spos:=1;
   end;
   Delete(s,LPos+SPos,1);
  end;
  s1:=s;
  s1:=Copy(s1,SPos,len);
  GotoXY(x+LPos,y);
  writestr(x,y,AddS(s1,len),col);
  if (Length(s) > len) and (SPos+len <= Length(s)) then
           WriteString(x+len,y,Chr(16),ArrowInput) else
           WriteString(x+len,y,' ',ArrowInput);
  if SPos > 1 then WriteString(x-1,y,Chr(17),ArrowInput)
              else WriteString(x-1,y,' ',ArrowInput);
 until (k = 27) or (k = 13);
 CursorOff;
 if k = 13 then str:=s;
 writestr(x,y,AddS(str,len),col);
 s:=str;
 SPos:=1;
 if (Length(s) > len) and (SPos+len <= Length(s)) then
          WriteString(x+len,y,Chr(16),ArrowInput) else
          WriteString(x+len,y,' ',ArrowInput);
 if SPos > 1 then WriteString(x-1,y,Chr(17),ArrowInput)
             else WriteString(x-1,y,' ',ArrowInput);
end;

procedure ClearSL;
begin
 FillWindow(1,25,80,25,' ',WinColor);
end;

function  TotalS(str: String): Byte;
var n,k: Byte;
begin
 k:=0;
 for n:=1 to Length(str) do
  if str[n] = '~' then k:=k+1;
 TotalS:=k;
end;

procedure WriteSL(str: String);
begin
 str:=' '+str;
 WriteString(1,25,AddS(str,80+TotalS(str)),WinColor);
end;

function CountChar(str: String; c: Char): Byte;
var n,k: Byte;
begin
 k:=0;
 for n:=1 to length(str) do if str[n] = c then k:=k+1;
 CountChar:=k;
end;

function CountLine(lim: Byte; message: String): Byte;
var awc, n, limit, wc, k: Integer;
    s,s1,rs: String;
begin
 awc:=CountChar(message,#0);
 if Length(message) < 255 then message:=message+' ';
 if (message[length(message)] <> ' ') and (message[length(message)] <> '.') and
    (message[length(message)] <> ',') and (message[length(message)] <> ':') and
    (message[length(message)] <> ';') and (message[length(message)] <> '-') and
    (message[length(message)] <> '%') and (message[length(message)] <> '$') and
    (message[length(message)] <> '!') and (message[length(message)] <> '?') and
    (message[length(message)] <> '(') and (message[length(message)] <> ')') and
    (message[length(message)] <> '{') and (message[length(message)] <> '}') and
    (message[length(message)] <> '[') and (message[length(message)] <> ']') and
    (message[length(message)] <> '{') and (message[length(message)] <> '}') and
    (message[length(message)] <> '>') and (message[length(message)] <> '<') and
    (message[length(message)] <> '"') and (message[length(message)] <> #39) and
    (message[length(message)] <> '~') and (message[length(message)] <> '`') and
    (message[length(message)] <> '^') and (message[length(message)] <> '&') and
    (message[length(message)] <> '#') and (message[length(message)] <> '_') and
    (message[length(message)] <> '+') and (message[length(message)] <> '-') and
    (message[length(message)] <> '*') and (message[length(message)] <> '/') and
    (TotalWords(message,' ') > 1) then k:=1 else k:=0;
 limit:=lim;
 rs:='';
 s:='';
 for n:=1 to TotalWords(message,' ')-k do s:=s+GetWord(message,' ',n)+' ';
 Delete(s,length(s),1);
 message:=s;
 wc:=0;
 message:=message+' ';
 while (message <> '') and (length(rs) <> 255) do begin
  lim:=limit;
  if length(message)-TotalS(message) <= lim then lim:=Length(message)+TotalS(message);
  s:=Copy(message,1,lim+TotalS(message));
  if length(s)+TotalS(s) > lim then s:=Copy(message,1,lim+TotalS(s));
  if length(s)-TotalS(s) > lim then s:=Copy(message,1,lim);
  if s[1] = ' ' then Delete(s,1,1);
  if (s[length(s)] <> ' ') and ((message[length(s)+1] <> ' ') or (length(s)+1 > length(message))) then begin
   s1:='';
   for n:=1 to TotalWords(s,' ')-1 do s1:=s1+GetWord(s,' ',n)+' ';
   if TotalWords(s,' ') = 1 then s1:=s;
  end else s1:=s;
  Delete(message,1,length(s1));
  if s1[length(s1)] = ' ' then Delete(s1,length(s1),1);
  if message[1] = ' ' then Delete(message,1,1);
  if s1[1] = ' ' then Delete(s1,1,1);
  rs:=rs+s1+#0;
  wc:=wc+1;
 end;
 CountLine:=wc+awc;
end;

procedure ShowTextWindow(x,y,lim,loc: Byte; message: String; col: TColor);
var awc, n, limit, wc, k: Integer;
    s,s1,rs: String;
begin
 awc:=CountChar(message,#0);
 if Length(message) < 255 then message:=message+' ';
 if (message[length(message)] <> ' ') and (message[length(message)] <> '.') and
    (message[length(message)] <> ',') and (message[length(message)] <> ':') and
    (message[length(message)] <> ';') and (message[length(message)] <> '-') and
    (message[length(message)] <> '%') and (message[length(message)] <> '$') and
    (message[length(message)] <> '!') and (message[length(message)] <> '?') and
    (message[length(message)] <> '(') and (message[length(message)] <> ')') and
    (message[length(message)] <> '{') and (message[length(message)] <> '}') and
    (message[length(message)] <> '[') and (message[length(message)] <> ']') and
    (message[length(message)] <> '{') and (message[length(message)] <> '}') and
    (message[length(message)] <> '>') and (message[length(message)] <> '<') and
    (message[length(message)] <> '"') and (message[length(message)] <> #39) and
    (message[length(message)] <> '~') and (message[length(message)] <> '`') and
    (message[length(message)] <> '^') and (message[length(message)] <> '&') and
    (message[length(message)] <> '#') and (message[length(message)] <> '_') and
    (message[length(message)] <> '+') and (message[length(message)] <> '-') and
    (message[length(message)] <> '*') and (message[length(message)] <> '/') and
    (TotalWords(message,' ') > 1) then k:=1 else k:=0;
 limit:=lim;
 rs:='';
 s:='';
 for n:=1 to TotalWords(message,' ')-k do s:=s+GetWord(message,' ',n)+' ';
 Delete(s,length(s),1);
 message:=s;
 wc:=0;
 message:=message+' ';
 while (message <> '') and (length(rs) <> 255) do begin
  lim:=limit;
  if length(message)-TotalS(message) <= lim then lim:=Length(message)+TotalS(message);
  s:=Copy(message,1,lim+TotalS(message));
  if length(s)+TotalS(s) > lim then s:=Copy(message,1,lim+TotalS(s));
  if length(s)-TotalS(s) > lim then s:=Copy(message,1,lim);
  if s[1] = ' ' then Delete(s,1,1);
  if (s[length(s)] <> ' ') and ((message[length(s)+1] <> ' ') or (length(s)+1 > length(message))) then begin
   s1:='';
   for n:=1 to TotalWords(s,' ')-1 do s1:=s1+GetWord(s,' ',n)+' ';
   if TotalWords(s,' ') = 1 then s1:=s;
  end else s1:=s;
  Delete(message,1,length(s1));
  if s1[length(s1)] = ' ' then Delete(s1,length(s1),1);
  if message[1] = ' ' then Delete(message,1,1);
  if s1[1] = ' ' then Delete(s1,1,1);
  rs:=rs+s1+#0;
  wc:=wc+1;
 end;
 lim:=limit;
 for n:=1 to wc+awc do begin
  s:=Copy(rs,1,Pos(#0,rs)-1);
  Delete(rs,1,Pos(#0,rs));
  case loc of
   0: WriteString(x, y+n-1,s,Col);
   1: WriteString(x+lim-Length(s), y+n-1,s,Col);
   2: WriteString(x+1+(lim-Length(s)) div 2, y+n-1,s,Col);
  end;
  if Pos(#0,rs) = 0 then break;
 end;
end;

procedure ShowMessageWindow(size, loc: Byte; Handle, message: String; col: TColor);
var x,y,l: Integer;
begin
 l:=CountLine(size,message);
 x:=((80-size) div 2);
 y:=(25-l) div 2;
 ShowWindow(x,y,x+size+3,y+l+3,DoubleB, Handle, Col);
 ShowTextWindow(x+2,y+2,size,loc,message,Col);
end;

procedure ShowMessageWindowXY(x, y, size, loc: Byte; Handle, message: String; col: TColor);
var l: Integer;
begin
 l:=CountLine(size,message);
 ShowWindow(x,y,x+size+3,y+l+3,DoubleB, Handle, Col);
 ShowTextWindow(x+2,y+2,size,loc,message,Col);
end;

procedure ChangFon(x,y,x2,y2: Integer; Fon: Byte);
var w, n, m: Word;
    b: array [0..1] of Byte absolute w;
begin
 Fon:=Fon shl 4;
 asm
  cli
  mov dx,$3da
  @2:
  in al, dx
  test al,1
  je @2
  sti
 end;
 for n:=x to x2 do
  for m:=y to y2 do begin
   w:=MemW[$B800:(n-1)*2+(m-1)*160];
   b[1]:=(b[1] and 15) or Fon;
   MemW[$B800:(n-1)*2+(m-1)*160]:=w;
  end;
end;

procedure ChangText(x,y,x2,y2: Integer; Text: Byte);
var w, n, m: Word;
    b: array [0..1] of Byte absolute w;
begin
 Text:=Text;
 asm
  cli
  mov dx,$3da
  @2:
  in al, dx
  test al,1
  je @2
  sti
 end;
 for n:=x to x2 do
  for m:=y to y2 do begin
   w:=MemW[$B800:(n-1)*2+(m-1)*160];
   b[1]:=(b[1] and 240) or Text;
   MemW[$B800:(n-1)*2+(m-1)*160]:=w;
  end;
end;

procedure ChangColor(x,y,x1,y1: Integer; col: TColor);
begin
 ChangFon(x,y,x1,y1,col.Fon);
 ChangText(x,y,x1,y1,col.Text);
end;

procedure ChangSColor(x,y,x2,y2: Integer; col: TColor);
var w, n, m: Word;
    b: array [0..1] of Byte absolute w;
begin
 col.Fon:=col.Fon shl 4;
 asm
  cli
  mov dx,$3da
  @2:
  in al, dx
  test al,1
  je @2
  sti
 end;
 for n:=x to x2 do
  for m:=y to y2 do begin
   w:=MemW[$B800:(n-1)*2+(m-1)*160];
   b[1]:=b[1] and 240;
   b[1]:=b[1] shr 4;
   b[1]:=b[1]{(b[1] and 15) } or Col.Fon;
   MemW[$B800:(n-1)*2+(m-1)*160]:=w;
  end;
end;

procedure ShowButton(x,y,len: Integer; Text: String; col: TColor);
var s: String;
    n: Byte;
begin
 s:=' ';
 for n:=1 to len do s:=s+#223;
 FillWindow(x,y,x+len-1,y,' ',col);
 WriteString(x+Round((len-(length(text)-TotalS(text)))/2),y,text,col);
 WriteString(x,y+1,s,ShadowButton);
 WriteString(x+len,y,#220,ShadowButton);
end;

function ShowQDialog(size, loc, def: Byte; Handle, message, Key1, Key2: String; col: TColor): Boolean;
var x,y,l,a,k, k1, k2: Integer;
begin
 SaveScreen(SSITempScreen);
 k1:=Ord(UpCase((Key1[Pos('~',Key1)+1])));
 k2:=Ord(UpCase((Key2[Pos('~',Key2)+1])));
 if Length(key1) mod 2 = 1 then key1:=key1+' ';
 if Length(key2) mod 2 = 1 then key2:=key2+' ';
 if k1=9 then k1:=255;
 if k2=9 then k2:=255;
 l:=CountLine(size,message)+2;
 x:=((80-size) div 2);
 y:=(25-l) div 2;
 ShowWindow(x,y,x+size+3,y+l+3,DoubleB, Handle, Col);
 ShowTextWindow(x+2,y+2,size,loc,message,Col);
 a:=(def mod 2)+1;
 if a = 1 then ShowButton(x+1+(size-22) div 2,y+1+l,10,Key1,SelectButton)
          else ShowButton(x+1+(size-22) div 2,y+1+l,10,Key1,NormalButton);
 if a = 2 then ShowButton(x+13+(size-22) div 2,y+1+l,10,Key2,SelectButton)
          else ShowButton(x+13+(size-22) div 2,y+1+l,10,Key2,NormalButton);
 repeat
  k:=Ord(UpCase(ReadKey));
  if k = 9 then a:=a+1;
  if a > 2 then a:=1;
  if a = 1 then ShowButton(x+1+(size-22) div 2,y+1+l,10,Key1,SelectButton)
           else ShowButton(x+1+(size-22) div 2,y+1+l,10,Key1,NormalButton);
  if a = 2 then ShowButton(x+13+(size-22) div 2,y+1+l,10,Key2,SelectButton)
           else ShowButton(x+13+(size-22) div 2,y+1+l,10,Key2,NormalButton);
 until k in [13,32,k1,k2];
 if k = k1 then ShowQDialog:=True;
 if k = k2 then ShowQDialog:=False;
 if k in [13,32] then
  case a of
   1: ShowQDialog:=True;
   2: ShowQDialog:=False;
  end;
 RestoreScreen(SSITempScreen);
end;

procedure ShowMDialog(size, loc: Byte; Handle, message, Key1: String; col: TColor);
var x,y,l,k,k1,bs: Integer;
begin
 bs:=10;
 if Length(Key1) > bs-2 then begin
  bs:=length(Key1);
  if bs > size - 4 then bs:=size-4;
  Key1:=Copy(key1,1, bs);
 end;
 SaveScreen(SSITempScreen);
 k1:=Ord(UpCase((Key1[Pos('~',Key1)+1])));
 if Length(key1) mod 2 = 1 then key1:=key1+' ';
 if k1=9 then k1:=255;
 l:=CountLine(size,message)+2;
 x:=((80-size) div 2);
 y:=(25-l) div 2;
 ShowWindow(x,y,x+size+3,y+l+3,DoubleB, Handle, Col);
 ShowTextWindow(x+2,y+2,size,loc,message,Col);
 ShowButton(x+1+(size-10) div 2,y+1+l,bs,Key1,SelectButton);
 repeat
  k:=Ord(UpCase(ReadKey));
 until k in [13,32,k1];
 RestoreScreen(SSITempScreen);
end;

begin
end.