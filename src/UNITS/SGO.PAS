unit SGO;

interface

uses Graph;

type TColor = record
     case Byte of
      0: (color: LongInt);
      1: (red, green, blue: Byte);
     end;

type TFillForm = array [0..7] of Byte;


function  InitGraph: Boolean;
procedure CloseGraph;
procedure LoadColorTable(fc, tc: Word; var table);
procedure SaveColorTable(fc, tc: Word; var table);
function  ChooseColor(r, g, b: Word): Word;
procedure RGB2IndexA(len: Word; var src, dst);
procedure Index2RGBA(len: Word; var src, dst);
procedure UnPackColor(bpp, sb: Byte; var dst);
procedure PackColor(bpp: Byte; var src; var rb: Byte);
procedure PutPixel(x, y: Integer; c: LongInt);
function  GetPixel(x, y: Integer): LongInt;
procedure Line(x, y, x1, y1: Integer; c: LongInt);
procedure Rectangle(x, y, width, height: Integer; c: LongInt);
procedure FillRectangle(x, y, width, height: Integer; c: LongInt);
procedure Ellipse(x, y, sa, ea, width, height: Integer; c: LongInt);
procedure FillEllipse(x, y, width, height: Integer; c: LongInt);
procedure SetLineStyle(f, t: Word);
procedure SetFillStyle(f: TFillForm);
function  ImgSize(x, y, width, height: Integer): LongInt;
procedure GetImage(x, y, width, height: Integer; var Img);
procedure PutImage(x, y: Integer; var Img);
function  RegisterCHRFile(S: String): Integer;
function  RegisterCHRFont(Font: Pointer): Integer;
procedure OutStringXYAM(xc, yc: Integer; B, U, I, St: Boolean; S: String; Font: Integer;
                  Angle: Integer; MX,MY: Real; col: LongInt);
procedure OutStringXYM(xc, yc: Integer; B, U, I, St: Boolean; S: String;
                       Font: Integer; MX,MY: Real; col: LongInt);
function  StringLength(S: String): Integer;
procedure SelectFont(n: Integer);
procedure SetBoldFont(b: Boolean);
procedure SetULineFont(b: Boolean);
procedure SetSLineFont(b: Boolean);
procedure SetItalicFont(b: Boolean);
procedure SetFontSize(i: Integer);
procedure OutString(x, y: Integer; s: String; col: LongInt);
function  GetMaxX: Integer;
function  GetMaxY: Integer;
procedure CalculateDPI(d: Real);
function  I2P(i: Integer): Integer;
function  P2I(p: Integer): Integer;
function  I2C(i: Integer): Real;
function  C2I(i: Real): Integer;

var Palette: array [0..255,0..2] of Byte;
    MaxColor: Word;

implementation

var tc: TColor;
    fs: TFillForm;
    lf: Word;
    lt: Word;
    bold, italic, uline, sline: Boolean;
    dpix, dpiy, font, angle, fonts: Integer;
    MX, MY: Real;

procedure EgaVgaDriverProc; external;
{$L EGAVGA.OBJ }

function  InitGraph: Boolean;
var gd, gm: Integer;
begin
 if RegisterBGIdriver(@EGAVGADriverProc) < 0 then
 begin
  InitGraph:=False;
  Exit;
 end;
 gd:=VGA;
 gm:=VGAHi;
 Graph.InitGraph(gd, gm, '');
 InitGraph:=True;
end;

procedure CloseGraph;
begin
 Graph.CloseGraph;
end;

procedure LoadColorTable(fc, tc: Word; var table);
var s, o: Word;
begin
 s:=Seg(Table);
 o:=Ofs(Table);
 asm
  mov  ax, s
  mov  es, ax
  mov  dx, o
  mov  ax, $1017
  mov  bx, fc
  mov  cx, tc
  int  $10
 end;
end;

procedure SaveColorTable(fc, tc: Word; var table);
var s, o: Word;
begin
 s:=Seg(Table);
 o:=Ofs(Table);
 asm
  mov  ax, s
  mov  es, ax
  mov  dx, o
  mov  ax, $1012
  mov  bx, fc
  mov  cx, tc
  int  $10
 end;
end;

function  ChooseColor(r, g, b: Word): Word; assembler;
asm
  push 1000
  mov  di, offset Palette
  xor  si, si
  xor  dh, dh
@repeat:
  mov  ax, r
  mov  dl, [di]
  sub  ax, dx
  inc  di
  test ah, 128
  jz   @p_ax
  neg  ax
@p_ax:
  mov  bx, g
  mov  dl, [di]
  sub  bx, dx
  inc  di
  test bh, 128
  jz   @p_bx
  neg  bx
@p_bx:
  mov  cx, b
  mov  dl, [di]
  sub  cx, dx
  inc  di
  test ch, 128
  jz   @p_cx
  neg  cx
@p_cx:
  cmp  ax, bx
  jl   @no_ax
  mov  bx, ax
@no_ax:
  cmp  bx, cx
  jg   @no_cx
  mov  bx, cx
@no_cx:
  cmp  bx, 0
  jne  @no_color
  mov  ax, si
  jmp  @exit
@no_color:
  pop  ax
  cmp  bx, ax
  jnl  @no_dx
  mov  es, si
  mov  ax, bx
@no_dx:
  push ax
  inc  si
  cmp  si, MaxColor
  jng  @repeat
  mov  ax, es
@exit:
end;

procedure RGB2IndexA(len: Word; var src, dst);
var n: Word;
    csrc: array [0..1] of TColor absolute src;
    cdst: array [0..1] of Byte absolute dst;
begin
 for n:=0 to len do
  cdst[n]:=ChooseColor(csrc[n].red, csrc[n].green, csrc[n].blue);
end;

procedure Index2RGBA(len: Word; var src, dst);
var n: Word;
    csrc: array [0..1] of Byte absolute dst;
    cdst: array [0..1] of TColor absolute src;
begin
 for n:=0 to len do begin
  cdst[n].red:=Palette[csrc[n],0];
  cdst[n].green:=Palette[csrc[n],1];
  cdst[n].blue:=Palette[csrc[n],2];
 end;
end;

function  RGBRecSize(width, height: Word): LongInt;
begin
 RGBRecSize:=(width*height) shl 2;
end;

procedure UnPackColor(bpp, sb: Byte; var dst);
var cdst: array [0..7] of Byte absolute dst;
    n: Byte;
begin
 case bpp of
  1: for n:=0 to 7 do
      if sb and (1 shl n) = (1 shl n) then cdst[n]:=1 else cdst[n]:=0;
  2: for n:=0 to 3 do
      cdst[n]:=(sb shr ((3-n) shl 1)) and 3;
  4: for n:=0 to 1 do
      cdst[n]:=(sb shr ((1-n) shl 2)) and 15;
  else cdst[0]:=sb;
 end;
end;

procedure PackColor(bpp: Byte; var src; var rb: Byte);
var csrc: array [0..7] of Byte absolute src;
    n: Byte;
begin
 rb:=0;
 case bpp of
  1: for n:=0 to 7 do
      rb:=rb or (((csrc[n] and 1) shl (7-n)));
  2: for n:=0 to 3 do
      rb:=rb or (((csrc[n]) and 3) shl ((3-n) shl 1));
  4: for n:=0 to 1 do
      rb:=rb or (((csrc[n]) and 15) shl ((1-n) shl 2));
  else rb:=csrc[0];
 end;
end;

procedure PutPixel(x, y: Integer; c: LongInt);
begin
 tc.color:=c;
 Graph.PutPixel(x,y, ChooseColor(tc.red, tc.green, tc.blue));
end;

function  GetPixel(x, y: Integer): LongInt;
var b: Byte;
begin
 b:=Graph.GetPixel(x,y);
 tc.red:=Palette[b,0];
 tc.green:=Palette[b,1];
 tc.blue:=Palette[b,2];
end;

procedure Line(x, y, x1, y1: Integer; c: LongInt);
begin
 tc.color:=c;
 Graph.SetColor(ChooseColor(tc.red, tc.green, tc.blue));
 Graph.Line(x, y, x1, y1);
end;

procedure Rectangle(x, y, width, height: Integer; c: LongInt);
begin
 tc.color:=c;
 Graph.SetColor(ChooseColor(tc.red, tc.green, tc.blue));
 Graph.Rectangle(x, y, x+width, y+height);
end;

procedure FillRectangle(x, y, width, height: Integer; c: LongInt);
begin
 tc.color:=c;
 Graph.SetFillPattern(FillPatternType(fs), ChooseColor(tc.red, tc.green, tc.blue));
 Graph.Bar(x, y, x+width, y+height);
end;

procedure Ellipse(x, y, sa, ea, width, height: Integer; c: LongInt);
begin
 tc.color:=c;
 Graph.SetColor(ChooseColor(tc.red, tc.green, tc.blue));
 Graph.Ellipse(x, y, sa, ea, width shr 1, height shr 1);
end;

procedure FillEllipse(x, y, width, height: Integer; c: LongInt);
begin
 tc.color:=c;
 Graph.SetFillPattern(FillPatternType(fs), ChooseColor(tc.red, tc.green, tc.blue));
 Graph.FillEllipse(x, y, width shr 1, height shr 1);
end;

procedure SetLineStyle(f, t: Word);
begin
 lf:=f; lt:=t;
 if t <> 1 then t:=3;
 Graph.SetLineStyle(UserBitLn, f, t);
end;

procedure SetFillStyle(f: TFillForm);
begin
 fs:=f;
end;

function  ImgSize(x, y, width, height: Integer): LongInt;
begin
 ImgSize:=Graph.ImageSize(x, y, x+width, y+height);
end;

procedure GetImage(x, y, width, height: Integer; var Img);
begin
 Graph.GetImage(x, y, x+width, y+height, Img);
end;

procedure PutImage(x, y: Integer; var Img);
begin
 Graph.PutImage(x, y, Img, NormalPut);
end;

type PFontDesc =^TFontDesc;
     TFontDesc = record      	{Описатель шрифта}
      NextFont: PFontDesc;  	{Ссылка на следующий}
      NFont   : Integer;    	{Номер шрифта}
      Name: record
       case Byte of
        0:(FName: String);    	{Имя файла}
        1:(Flag : Byte;       	{Флаг формата}
           Addrs: record      	{Адрес}
            sa,oa: Word
           end)
       end;
      FirstChr : Byte;      	{Первый символ}
      LastChar : Byte;      	{Последний символ}
      Height: ShortInt;     	{Высота от базы}
      Bottom: ShortInt;     	{Высота до низа}
      Offs: array [0..255] of Word; {Смещения}
      Leng: array [0..255] of Word; {Длины}
     end;
     TFontPara = record  		{Блок параметров шрифта}
      ParPrefix : Char; 		{Символ "+"}
      CharsCount: Word;  		{Количество символов в шрифте}
      Reserv1   : Byte;  		{Не используется}
      FirstChar : Byte;  		{Код первого символа}
      DataOffset: Word;  		{Смещение до векторных
          				команд первого символа}
      FillFlag   : Byte; 		{Флаг заливки}
      UpperMargin: Byte; 		{Высота символов}
      Reserv2    : Byte; 		{Не используется}
      LowerMargin: ShortInt; 	{Нижняя кромка}
      Reserv3 : array [1..5] of Byte
     end;
     THead = array [1..4] of Char;

const
     FontList: PFontDesc = NIL; 	{Список шрифтов}
     FontNumb: Integer = 0;     	{Количество шрифтов}
     Head0: THead = ('P','K',#8,#8);

var  FDesc: TFontDesc;
     F: File;
     Buf: array [1..128] of Byte; 	{Заголовок}
     Head: THead absolute Buf;
     FPar: TFontPara;             	{Параметры шрифта}


function RegisterCHRFile(S: String): Integer;
var k: Integer;
    Err: Boolean;
    P, PD: PFontDesc;
    ParOffs: Word;

 function ReadFile(var Dest; Size: Word): Boolean;
 begin
  BlockRead(F,Dest,Size,k);
  ReadFile:=k=Size;
 end;
begin
 if pos('.',S)=0 then S := S+'.chr';
 if FontNumb <> 0 then begin
  FDesc:=FontList^;
  with FDesc do
   while (NextFont <> NIL) and (S <> Name.FName) do FDesc:=NextFont^;
   if S=FDesc.Name.FName then begin
    RegisterChrFile := FDesc.NFont;
    Exit;
   end;
  end;
  RegisterChrFile:=-1;
  Assign(F,S);
  {$I-}
  Reset(F,1);
  {$I+}
  if IOResult<>0 then Exit;
  if not ReadFile(Buf,128) then Exit;
  RegisterChrFile:=-2;
  if Head <> Head0 then Exit;
  repeat
   k:=1;
   while (k <= 128) and (Buf[k] <> $1A) do inc(k);
   if k=129 then
    if not ReadFile(Buf,128) then Exit;
  until Buf[k] = $1A;
  ParOffs:=Buf[k+1]+Buf[k+2] shl 8;
  Seek(F,ParOffs);
  if not ReadFile(FPar,16) or (FPar.ParPrefix<>'+') then Exit;
  RegisterChrFile := -3;
  if MaxAvail<SizeOf(TFontDesc) then Exit;
  New(PD);
  with PD^,FPar do begin
   NextFont:=NIL;
   NFont:=FontNumb+1;
   Name.FName:=S;
   FirstChr:=FirstChar;
   LastChar:=FirstChar+CharsCount-1;
   Height:=UpperMargin;
   Bottom:=LowerMargin;
   RegisterChrFile:=-1;
   Seek(F, ParOffs+DataOffset-3*CharsCount);
   if not ReadFile(Offs[FirstChar],2*CharsCount) then begin
    Dispose(PD);
    Exit;
   end;
   for k:=FirstChar to LastChar do Offs[k]:=Offs[k]+ParOffs+DataOffset;
   for k:=FirstChar to LastChar-1 do Leng[k]:=Offs[k+1]-Offs[k];
   Leng[LastChar] := FileSize(F)-Offs[LastChar-1]-ParOffs;
  end;
  if FontNumb=0 then FontList:=PD
  else begin
   P:=FontList;
   while P^.NextFont <> NIL do P:=P^.NextFont;
   P^.NextFont:=PD;
  end;
  inc(FontNumb);
  RegisterChrFile:=FontNumb;
end;

Function RegisterCHRFont(Font: Pointer): Integer;
type TByte = array [0..65534] of Byte;
var PH: ^THead;
    PP: ^TFontPara;
    PB: ^TByte absolute PH;
    P, PD: PFontDesc;
    k: integer;
    ParOffset: Word;
    FileSize: Word;
begin
  PH:=Font;
  RegisterChrFont:=-2;
  if PH^ <> Head0 then Exit;
  k:=4;
  while (PB^[k]<>$1A) and (k<256) do inc(k);
  if PB^[k]<>$1A then Exit;
  ParOffset:=PB^[k+1]+PB^[k+2] shl 8;
  FileSize:=PB^[k+7]+PB^[k+8] shl 8;
  PP:=Addr(PB^[ParOffset]);
  if PP^.ParPrefix <> '+' then Exit;
  RegisterChrFont:=-3;
  if MaxAvail<SizeOf(TFontDesc) then Exit;
  New(PD);
  with PD^,PP^ do begin
   NextFont:=NIL;
   NFont:=FontNumb+1;
   Name.Flag:=0;     		{Шрифт - в памяти}
   k:=ParOffset+DataOffset;
   Name.Addrs.sa:=seg(PB^[k]);  	{Адрес}
   Name.Addrs.oa:=ofs(PB^[k]);  	{шрифта}
   FirstChr:=FirstChar;
   LastChar:=FirstChar+CharsCount-1;
   Height:=UpperMargin;
   Bottom:=LowerMargin;
   k:=ParOffset+DataOffset-3*CharsCount;
   Move(PB^[k], Offs[FirstChar], 2*CharsCount);
   for k:=FirstChar to LastChar-1 do Leng[k]:=Offs[k+1]-Offs[k];
   Leng[LastChar]:=FileSize-Offs[LastChar-1]
  end;
  if FontNumb = 0 then FontList:=PD
  else begin
   P:=FontList;
   while P^.NextFont <> NIL do P:=P^.NextFont;
   P^.NextFont:=PD;
  end;
  inc(FontNumb);
  RegisterChrFont:=FontNumb
end;

procedure OutStringXYAM(xc, yc: Integer; B, U, I, St: Boolean; S: String; Font: Integer;
                  Angle: Integer; MX,MY: Real; col: LongInt);
var x0, y0: Integer;
    tlf, tlt: Word;
    Ang: Real;
 procedure OutChar(var V);
 var Vec: array [1..MaxInt] of Word absolute V;
     k, op: Word;
  procedure Coo(X,Y: Integer; var xx,yy: Integer);
  var r, a: Single;
  begin
   r:=sqrt(1.0*x*x+1.0*y*y);
   if x = 0 then
    if y<0 then a:=-pi/2
           else a:=pi/2
   else a:=arctan(y/x);
   a:=a+Ang;
   yy:=Round(r*sin(a));
   xx:=Round(r*cos(a))
  end;
 var x,y,x1,y1,xx,yy: Integer;
 begin
  k:=1;
  x:=x0;
  y:=y0;
  repeat
   op:=Vec[k] and $8080;
   xx:=Vec[k] and $7F;
   yy:=(Vec[k] shr 8) and $7F;
   if yy > 63 then yy:=yy-128;
   xx:=Round(xx*MX);
   yy:=Round(yy*MY);
   Coo(xx, yy, x1, y1);
   x1:=x0+x1;
   y1:=y0-y1;
   if op = $8080 then Line(x,y,x1,y1,col);
   if op <> 0 then begin
    x:=x1;
    y:=y1
   end;
   if op = 0 then begin
    x0:=x;
    y0:=y
   end else inc(k)
  until Op = 0;
 end;
 var F: File;
     k, j: Word;
     c: Byte;
     Buf: array [1..1000] of Word;
     P: PFontDesc;
     PB: Pointer;
 begin
  if (FontNumb=0) or (Font>FontNumb) or (S='') then Exit;
  P:=FontList;
  Ang:=Angle*pi/180;
  for k:=1 to Font-1 do P:=P^.NextFont;
  with P^ do begin
   if Name.FName<>'' then begin
    Assign(F,Name.FName);
    {$I-}
    Reset(F,1);
    {$I+}
    if IOResult<>0 then Exit;
   end;
   x0:=xc;
   y0:=yc+Round(Height*MY);
   tlf:=lf; tlt:=lt;
   if B or (Round(MX*MY) >= 3) then SetLineStyle(Word(not 0),3) else SetLineStyle(Word(not 0),1);
   for k:=1 to Length(S) do begin
    c:=ord(S[k]);
    if c in [FirstChr..LastChar] then
     if Name.FName<>'' then begin
      {$I-}
      Seek(F,Offs[c]);
      BlockRead(F,Buf,Leng[c],j);
      {$I+}
      if (IOResult=0) and (Leng[c]=j) then OutChar(Buf)
     end else
     with Name.Addrs do begin
      PB:=ptr(sa,oa+Offs[c]);
      OutChar(PB^);
     end;
   end;
   if U then Line(xc, yc+Round(4*MY+Height*MY), x0, y0+Round(4*MY), col);
   if St then Line(xc, yc+Round(Height*MY*0.5), x0, y0-Round(Height*0.5*MY), col);
   SetLineStyle(tlf,tlt);
   if Name.FName <> '' then Close(F)
  end;
end;

procedure OutStringXYM(xc, yc: Integer; B, U, I, St: Boolean; S: String;
                       Font: Integer; MX,MY: Real; col: LongInt);
var x0, y0: Integer;
    tlf, tlt: Word;
 procedure OutChar(var V);
 var Vec: array [1..MaxInt] of Word absolute V;
     k, op: Word;
     x,y,x1,y1,xx,yy: Integer;
 begin
  k:=1;
  x:=x0;
  y:=y0;
  repeat
   op:=Vec[k] and $8080;
   xx:=Vec[k] and $7F;
   yy:=(Vec[k] shr 8) and $7F;
   if yy > 63 then yy:=yy-128;
   xx:=Round(xx*MX);
   yy:=Round(yy*MY);
   x1:=xx; y1:=yy;
   x1:=x0+x1;
   y1:=y0-y1;
   if op = $8080 then Line(x,y,x1,y1,col);
   if op <> 0 then begin
    x:=x1;
    y:=y1
   end;
   if op = 0 then begin
    x0:=x;
    y0:=y
   end else inc(k)
  until Op = 0;
 end;
 var F: File;
     k, j: Word;
     c: Byte;
     Buf: array [1..1000] of Word;
     P: PFontDesc;
     PB: Pointer;
 begin
  if (FontNumb=0) or (Font>FontNumb) or (S='') then Exit;
  P:=FontList;
  for k:=1 to Font-1 do P:=P^.NextFont;
  with P^ do begin
   if Name.FName<>'' then begin
    Assign(F,Name.FName);
    {$I-}
    Reset(F,1);
    {$I+}
    if IOResult<>0 then Exit;
   end;
   x0:=xc;
   y0:=yc+Round(Height*MY);
   tlf:=lf; tlt:=lt;
   if B or (Round(MX*MY) >= 3) then SetLineStyle(Word(not 0),3) else SetLineStyle(Word(not 0),1);
   for k:=1 to Length(S) do begin
    c:=ord(S[k]);
    if c in [FirstChr..LastChar] then
     if Name.FName<>'' then begin
      {$I-}
      Seek(F,Offs[c]);
      BlockRead(F,Buf,Leng[c],j);
      {$I+}
      if (IOResult=0) and (Leng[c]=j) then OutChar(Buf)
     end else
     with Name.Addrs do begin
      PB:=ptr(sa,oa+Offs[c]);
      OutChar(PB^);
     end;
   end;
   if U then Line(xc, yc+Round(4*MY+Height*MY), x0, y0+Round(4*MY), col);
   if St then Line(xc, yc+Round(Height*MY*0.5), x0, y0-Round(Height*0.5*MY), col);
   SetLineStyle(tlf,tlt);
   if Name.FName <> '' then Close(F)
  end;
end;

function StringLength(S: String): Integer;
var x0, y0: Integer;
 procedure OutChar(var V);
 var Vec: array [1..MaxInt] of Word absolute V;
     k, op: Word;
     x,y,x1,y1,xx,yy: Integer;
 begin
  k:=1;
  x:=x0;
  y:=y0;
  repeat
   op:=Vec[k] and $8080;
   xx:=Vec[k] and $7F;
   yy:=(Vec[k] shr 8) and $7F;
   if yy > 63 then yy:=yy-128;
   x1:=xx; y1:=yy;
   x1:=x0+x1;
   y1:=y0-y1;
   if op <> 0 then begin
    x:=x1;
    y:=y1
   end;
   if op = 0 then begin
    x0:=x;
    y0:=y
   end else inc(k)
  until Op = 0;
 end;
 var F: File;
     k, j: Word;
     c: Byte;
     Buf: array [1..1000] of Word;
     P: PFontDesc;
     PB: Pointer;
 begin
  StringLength:=0;
  if (FontNumb=0) or (Font>FontNumb) or (S='') then Exit;
  P:=FontList;
  for k:=1 to Font-1 do P:=P^.NextFont;
  with P^ do begin
   if Name.FName<>'' then begin
    Assign(F,Name.FName);
    {$I-}
    Reset(F,1);
    {$I+}
    if IOResult<>0 then Exit;
   end;
   x0:=100;
   y0:=100;
   for k:=1 to Length(S) do begin
    c:=ord(S[k]);
    if c in [FirstChr..LastChar] then
     if Name.FName<>'' then begin
      {$I-}
      Seek(F,Offs[c]);
      BlockRead(F,Buf,Leng[c],j);
      {$I+}
      if (IOResult=0) and (Leng[c]=j) then OutChar(Buf)
     end else
     with Name.Addrs do begin
      PB:=ptr(sa,oa+Offs[c]);
      OutChar(PB^);
     end;
   end;
   if Name.FName <> '' then Close(F);
   StringLength:=Round((x0-100)*MY);
  end;
end;

procedure SelectFont(n: Integer);
begin
 Font:=n;
 SetFontSize(14);
end;

procedure SetBoldFont(b: Boolean);
begin
 Bold:=b;
end;

procedure SetULineFont(b: Boolean);
begin
 ULine:=b;
end;

procedure SetSLineFont(b: Boolean);
begin
 SLine:=b;
end;

procedure SetItalicFont(b: Boolean);
begin
 Italic:=b;
end;

procedure SetFontSize(i: Integer);
var P: PFontDesc;
    k: Integer;
begin
 fonts:=i;
 P:=FontList;
 for k:=1 to Font-1 do P:=P^.NextFont;
 MY:=i*dpiy/72/P^.Height;
 MX:=MY*dpix/dpiy;
end;

procedure OutString(x, y: Integer; s: String; col: LongInt);
begin
 OutStringXYM(x, y, Bold, ULine, Italic, SLine, s, font, MX, MY, col);
end;

function  GetMaxX: Integer;
begin
 GetMaxX:=640;
end;

function  GetMaxY: Integer;
begin
 GetMaxY:=480;
end;

procedure CalculateDPI(d: Real);
var w, h: Real;
begin
 w:=4*d/5; h:=3*d/5;
 dpix:=Round(GetMaxX/w); dpiy:=Round(GetMaxY/h);
end;

function  GetFontSize: Integer;
begin
 GetFontSize:=Fonts;
end;

function  I2P(i: Integer): Integer;
begin
 I2P:=Round(i*(dpix+dpiy)/144);
end;

function  P2I(p: Integer): Integer;
begin
 P2I:=Round(p*144/(dpix+dpiy));
end;

function  I2C(i: Integer): Real;
begin
 I2C:=i*2.54/72;
end;

function  C2I(i: Real): Integer;
begin
 C2I:=Round(i*72/2.54);
end;

var n: Byte;

begin
 CalculateDPI(13);
 MaxColor:=15;
 LoadColorTable(0,MaxColor,Palette);
 FillChar(fs, 8, 255);
 for n:=0 to MaxColor do begin
  Palette[n,0]:=Palette[n,0] shl 2;
  Palette[n,1]:=Palette[n,1] shl 2;
  Palette[n,2]:=Palette[n,2] shl 2;
 end;
 Palette[15,0]:=255;
 Palette[15,1]:=255;
 Palette[15,2]:=255;
end.