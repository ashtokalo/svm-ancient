{$A+,B+,D+,E-,F+,G+,I+,L+,N+,O+,P+,Q-,R-,S+,T+,V+,X+}
{============================================================================}
{====                 Universal Graphics Driver Interface                ====}
{====                            Version  1.0                            ====}
{====                   Copyright (c)  2000 ShAG Studio                  ====}
{============================================================================}
                                  unit UGDI;
{============================================================================}
                                  interface
{============================================================================}
{====                             User types                             ====}
{============================================================================}

 type TColor = record
      case byte of
       0: (Red, Green, Blue, Index: Byte);
       1: (color: LongInt);
      end;

 type PColor = ^TColor;

 type TLineStyle = record
      Style: Word;
      Size:  Byte;
 end;

 type PLineStyle = ^TLineStyle;

 type TTextStyle = record
      TextStyle          : Byte;
      Bold, Fon, Text    : Boolean;
      TextColor, FonColor: TColor;
 end;

 type PTextStyle = ^TTextStyle;

{============================================================================}
{====                             Constants                              ====}
{============================================================================}

 const Font1         = 0;
       Font2         = 1;
       Font3         = 2;
       FontHeight    : array [0..2] of Byte = (8, 14, 16);

       Black:         TColor = ( Red:0;   Green:0;   Blue:0   );
       Blue:          TColor = ( Red:0;   Green:0;   Blue:127 );
       Green:         TColor = ( Red:0;   Green:127; Blue:0   );
       Cyan:          TColor = ( Red:0;   Green:127; Blue:127 );
       Red:           TColor = ( Red:127; Green:0;   Blue:0   );
       Magenta:       TColor = ( Red:127; Green:0;   Blue:127 );
       Yellow:        TColor = ( Red:127; Green:127; Blue:0   );
       LightGray:     TColor = ( Red:191; Green:191; Blue:191 );
       DarkGray:      TColor = ( Red:63;  Green:63;  Blue:63  );
       LightBlue:     TColor = ( Red:0;   Green:0;   Blue:255 );
       LightGreen:    TColor = ( Red:0;   Green:255; Blue:0   );
       LightCyan:     TColor = ( Red:0;   Green:255; Blue:255 );
       LightRed:      TColor = ( Red:255; Green:0;   Blue:0   );
       LightMagenta:  TColor = ( Red:255; Green:0;   Blue:255 );
       LightYellow:   TColor = ( Red:255; Green:255; Blue:0   );
       White:         TColor = ( Red:255; Green:255; Blue:255 );

       IBlack         = 0;
       IBlue          = 1;
       IGreen         = 2;
       ICyan          = 3;
       IRed           = 4;
       IMagenta       = 5;
       IYellow        = 6;
       ILightGray     = 7;
       IDarkGray      = 8;
       ILightBlue     = 9;
       ILightGreen    = 10;
       ILightCyan     = 11;
       ILightRed      = 12;
       ILightMagenta  = 13;
       ILightYellow   = 14;
       IWhite         = 15;

       NormalLine:    TLineStyle = ( Style: $FFFF; Size:1 );
       ThickLine:     TLineStyle = ( Style: $FFFF; Size:2 );
       VeryThickLine: TLineStyle = ( Style: $FFFF; Size:3 );
       SolideLine:    TLineStyle = ( Style: $F0F0; Size:1 );
       DottedLine:    TLineStyle = ( Style: $5555; Size:1 );

       NormalText:    TTextStyle = ( TextStyle: Font1; Bold: False;
                                     Fon: False;       Text: True;
                                     TextColor: ( Red:255; Green:255; Blue:255 );
                                     FonColor:  ( Red:0;   Green:0;   Blue:0   ));

       TextStyle:     TTextStyle = ( TextStyle: Font1; Bold: False;
                                     Fon: False;       Text: True;
                                     TextColor: ( Red:255; Green:255; Blue:255 );
                                     FonColor:  ( Red:0;   Green:0;   Blue:0   ));

       LineStyle:     TLineStyle = ( Style: $FFFF; Size:1 );

       SelectColor:   TColor = ( Red:255; Green:255; Blue:255 );

       DriverVersion: Integer = 0;
       DMaxX: Integer         = 0;
       DMaxY: Integer         = 0;
       MaxX: Integer          = 0;
       MaxY: Integer          = 0;
       DMinX: Integer         = 0;
       DMinY: Integer         = 0;

       DriverName: String = '';
       DriverCopyright: String = '';

{============================================================================}
{====                      Procedures and functions                      ====}
{============================================================================}

 procedure InitGraph;
 procedure ClearDevice;

 procedure PutPixel(x,y: Integer);
 procedure PutIndexPixel(x,y,c: Integer);
 procedure PutColorPixel(x,y: Integer; col: TColor);
 function  GetPixel(x,y: Integer): PColor;

 procedure Line(x1,y1,x2,y2: Integer);
 procedure Rectangle(x,y,x1,y1: Integer);
 procedure Bar(x,y,x1,y1: Integer);
 procedure FLine(x1,y1,x2,y2: Integer);
 procedure FRectangle(x,y,x1,y1: Integer);
 procedure SLine(x1,y1,x2,y2: Integer);
 procedure SRectangle(x,y,x1,y1: Integer);
 procedure PrintText(x,y: Integer; str: String);

 procedure ILine(x1,y1,x2,y2,c: Integer);
 procedure IRectangle(x,y,x1,y1,c: Integer);
 procedure IBar(x,y,x1,y1,c: Integer);
 procedure IFLine(x1,y1,x2,y2,c: Integer);
 procedure IFRectangle(x,y,x1,y1,c: Integer);
 procedure ISLine(x1,y1,x2,y2,c: Integer);
 procedure ISRectangle(x,y,x1,y1,c: Integer);
 procedure IPrintText(x,y: Integer; str: String);

 procedure SetColor(col: TColor);
 procedure SetRGBColor(r, g, b: Byte);
 procedure SetLineStyle(mask: Word; size: Byte);
 procedure SetTextStyle(ts: Byte; front, fon, Bold: Boolean; TextColor, FonColor: TColor);
 procedure SetWindow(x,y,x1,y1: Integer);

{============================================================================}
                                implementation
{============================================================================}

var di_y_in, di_x_in, sh_di, st_x_in, st_y_in, st_co, di_co: Word;
    TextStyleV: TTextStyle absolute TextStyle;


{Возвращает TRUE если в памяти нет других UGD драйверов}
function  RegisterUGD: Boolean;
var n,s,o: Word;
    str: ^String;
    tstr,ts: String;
    i: Integer;
    l: LongInt absolute str;
begin
 RegisterUGD:=False;
 l:=Meml[$0000:$EF*4];
 tstr:=str^;
 DriverName:=Copy(tstr,1,Pos(#1,tstr)-1);
 Delete(tstr,1,Pos(#1,tstr));
 if DriverName <> 'UGD' then begin
  DriverName:='';
  Exit;
 end;
 DriverName:=Copy(tstr,1,Pos(#1,tstr)-1);
 Delete(tstr,1,Pos(#1,tstr));
 ts:=Copy(tstr,1,Pos(#1,tstr)-1);
 Delete(tstr,1,Pos(#1,tstr));
 val(ts,DriverVersion,i);
 if i <> 0 then begin
  DriverVersion:=0;
  Exit;
 end;
 DriverCopyright:=Copy(tstr,1,Pos(#0,tstr)-1);
 asm
  MOV  AL, 0
  INT  $EE
  MOV  N, AX
  MOV  S, BX
  MOV  O, CX
 end;
 if (n <> $FFFF) or (str <> Ptr(s,o)) then exit;
 RegisterUGD:=True;
end;



{Инициализирует графику}
procedure InitGraph; assembler;
asm
     MOV  AL, 1
     INT  $EE
     MOV  AL, 5
     INT  $EE
     MOV  MAXX, CX
     MOV  MAXY, DX
     XOR  AX, AX
     PUSH AX
     PUSH AX
     PUSH CX
     PUSH DX
     CALL SETWINDOW
end;

{Очищает экран}
procedure ClearDevice; assembler;
asm
 CALL INITGRAPH
end;




{Ставит точку по координатам x,y стандартным цветом}
procedure PutPixel(x,y: Integer); assembler;
asm
     MOV  AX, X
     CMP  AX, DMINX
     JL   @EXIT
     CMP  AX, DMAXX
     JG   @EXIT
     MOV  AX, Y
     CMP  AX, DMINY
     JL   @EXIT
     CMP  AX, DMAXY
     JG   @EXIT
     MOV  AL, 3
     MOV  CX, X
     MOV  DX, Y
     INT  $EE
 @EXIT:
end;

procedure PutIndexPixel(x,y,c: Integer); assembler;
asm
     MOV  AX, X
     CMP  AX, DMINX
     JL   @EXIT
     CMP  AX, DMAXX
     JG   @EXIT
     MOV  AX, Y
     CMP  AX, DMINY
     JL   @EXIT
     CMP  AX, DMAXY
     JG   @EXIT
     MOV  AX, c
     AND  AX, 15
     MOV  AH, AL
     MOV  AL, 7
     MOV  CX, X
     MOV  DX, Y
     INT  $EE
 @EXIT:
end;

{Ставит точку по координатам x,y цветом col}
procedure PutColorPixel(x,y: Integer; col: TColor); assembler;
asm
     MOV  AX, X
     CMP  AX, DMINX
     JL   @EXIT
     CMP  AX, DMAXX
     JG   @EXIT
     MOV  AX, Y
     CMP  AX, DMINY
     JL   @EXIT
     CMP  AX, DMAXY
     JG   @EXIT
     MOV  AL, 6
     MOV  CX, X
     MOV  DX, Y
     MOV  AH, BYTE PTR COL.RED
     MOV  BL, BYTE PTR COL.GREEN
     MOV  BH, BYTE PTR COL.BLUE
     MOV  BYTE PTR SELECTCOLOR.RED, AH
     MOV  BYTE PTR SELECTCOLOR.GREEN, BL
     MOV  BYTE PTR SELECTCOLOR.BLUE, BH
     INT  $EE
 @EXIT:
end;

{Возвращает цвет точки по координатам x,y}
function  GetPixel(x,y: Integer): PColor;
var col: TColor;
begin
 asm
     MOV  AL, 4
     MOV  CX, X
     MOV  DX, Y
     INT  $EE
     MOV  BYTE PTR COL.RED, AH
     MOV  BYTE PTR COL.GREEN, BL
     MOV  BYTE PTR COL.BLUE, BH
     XOR  AL, AL
     MOV  BYTE PTR COL.INDEX, AL
 end;
 GetPixel^:=col;
end;



{Рисует закрашеный прямоугольник по координатам x,y,x1,y1}
procedure Bar(x,y,x1,y1: Integer); assembler;
asm
     MOV  DI, Y
     CMP  DI, Y1
     JNG  @NOSWAP
     XCHG DI, Y1
 @NOSWAP:
     MOV  Y, DI
     MOV  SI, X
     CMP  SI, X1
     JNG  @1
     XCHG SI, X1
     JMP  @1
 @4: MOV  DI, Y
     JMP  @2
 @3: PUSH SI
     PUSH DI
     CALL PUTPIXEL
     INC  DI
 @2: CMP  DI, Y1
     JNG  @3
     INC  SI
 @1: CMP  SI, X1
     JNG  @4
end;

{Рисует прямоугольник по координатам x,y,x1,y1}
procedure Rectangle(x,y,x1,y1: Integer); assembler;
asm
     MOV  DI, Y
     CMP  DI, Y1
     JNG  @NOSWAP
     XCHG DI, Y1
 @NOSWAP:
     MOV  Y, DI
     MOV  SI, X
     CMP  SI, X1
     JNG  @1
     XCHG SI, X1
     JMP  @1
 @2: PUSH SI
     MOV  AX, Y
     PUSH AX
     CALL PUTPIXEL
     PUSH SI
     MOV  AX, Y1
     PUSH AX
     CALL PUTPIXEL
     INC  SI
 @1: CMP  SI, X1
     JNG  @2
     MOV  SI, Y
     JMP  @3
 @4: MOV  AX, X
     PUSH AX
     PUSH SI
     CALL PUTPIXEL
     MOV  AX, X1
     PUSH AX
     PUSH SI
     CALL PUTPIXEL
     INC  SI
 @3: CMP  SI, Y1
     JNG  @4
end;

{Рисует прямоугольник по координатам x,y,x1,y1 с учетом стиля линии}
procedure FRectangle(x,y,x1,y1: Integer);
begin
 FLine(x,y,x1,y);
 FLine(x1,y,x1,y1);
 FLine(x1,y1,x,y1);
 FLine(x,y1,x,y);
end;

{Рисует прямоугольник по координатам x,y,x1,y1 с учетом одной толщини}
procedure SRectangle(x,y,x1,y1: Integer);
begin
 SLine(x,y,x1,y);
 SLine(x1,y,x1,y1);
 SLine(x1,y1,x,y1);
 SLine(x,y1,x,y);
end;

{Рисует линию по координатам x,y,x1,y1}
procedure Line(x1,y1,x2,y2: Integer); assembler;
asm
     MOV  CX, 1
     MOV  DX, 1
     MOV  DI, Y2
     SUB  DI, Y1
     JGE  @KEEP_Y
     NEG  DX
     NEG  DI
 @KEEP_Y:
     MOV  DI_Y_IN, DX
     MOV  SI, X2
     SUB  SI, X1
     JGE  @KEEP_X
     NEG  CX
     NEG  SI
 @KEEP_X:
     MOV  DI_X_IN, CX
     CMP  SI, DI
     JGE  @HORS
     MOV  CX, 0
     XCHG SI, DI
     JMP  @SAVS
 @HORS:
     MOV  DX, 0
 @SAVS:
     MOV  SH_DI, DI
     MOV  ST_X_IN, CX
     MOV  ST_Y_IN, DX
     MOV  AX, SH_DI
     SHL  AX, 1
     MOV  ST_CO, AX
     SUB  AX, SI
     MOV  BX, AX
     SUB  AX, SI
     MOV  DI_CO, AX
     MOV  DX, Y1
     MOV  CX, X1
     INC  SI
 @MLOOP:
     DEC  SI
     JZ   @FINISH
     PUSH CX
     PUSH DX
     CALL PUTPIXEL
     CMP  BX, 0
     JGE  @DILIN
     ADD  CX, ST_X_IN
     ADD  DX, ST_Y_IN
     ADD  BX, ST_CO
     JMP  @MLOOP
 @DILIN:
     ADD  CX, DI_X_IN
     ADD  DX, DI_Y_IN
     ADD  BX, DI_CO
     JMP  @MLOOP
 @FINISH:
end;

procedure PutLinePixel(x,y: Integer); assembler;
asm
     MOV  AX, WORD PTR LINESTYLE.SIZE
     SHR  AX, 1
     MOV  DX, X
     SUB  DX, AX
     MOV  CX, DX
     ADD  CX, WORD PTR LINESTYLE.SIZE
     INC  DX
     PUSH DX
     MOV  DX, Y
     SUB  DX, AX
     INC  DX
     PUSH DX
     PUSH CX
     DEC  DX
     ADD  DX, WORD PTR LINESTYLE.SIZE
     PUSH DX
     CALL BAR
end;

function  IsLinePoint(x: Word): Boolean; assembler;
asm
     MOV  AX, X
     CWD
     MOV  CX, 16
     IDIV CX
     MOV  AX, WORD PTR LINESTYLE.STYLE
     MOV  CL, DL
     MOV  DL, 1
     SHL  DX, CL
     AND  AX, DX
     CMP  AX, DX
     JNE  @NO
     MOV  AL, 1
     JMP  @EXIT
 @NO:
     MOV  AL, 0
 @EXIT:
end;

{Рисует линию по координатам x,y,x1,y1 с учетом стиля линии}
procedure FLine(x1,y1,x2,y2: Integer); assembler;
asm
     MOV  CX, 1
     MOV  DX, 1
     MOV  DI, Y2
     SUB  DI, Y1
     JGE  @KEEP_Y
     NEG  DX
     NEG  DI
 @KEEP_Y:
     MOV  DI_Y_IN, DX
     MOV  SI, X2
     SUB  SI, X1
     JGE  @KEEP_X
     NEG  CX
     NEG  SI
 @KEEP_X:
     MOV  DI_X_IN, CX
     CMP  SI, DI
     JGE  @HORS
     MOV  CX, 0
     XCHG SI, DI
     JMP  @SAVS
 @HORS:
     MOV  DX, 0
 @SAVS:
     MOV  SH_DI, DI
     MOV  ST_X_IN, CX
     MOV  ST_Y_IN, DX
     MOV  AX, SH_DI
     SHL  AX, 1
     MOV  ST_CO, AX
     SUB  AX, SI
     MOV  BX, AX
     SUB  AX, SI
     MOV  DI_CO, AX
     MOV  DX, Y1
     MOV  CX, X1
     INC  SI
 @MLOOP:
     DEC  SI
     JZ   @FINISH
     PUSH DX
     PUSH CX
     PUSH SI
     CALL ISLINEPOINT
     POP  CX
     POP  DX
     CMP  AL, 0
     JE   @NOPOINT
     PUSH SI
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH CX
     PUSH DX
     CALL PUTLINEPIXEL
     POP  DX
     POP  CX
     POP  BX
     POP  SI
 @NOPOINT:
     CMP  BX, 0
     JGE  @DILIN
     ADD  CX, ST_X_IN
     ADD  DX, ST_Y_IN
     ADD  BX, ST_CO
     JMP  @MLOOP
 @DILIN:
     ADD  CX, DI_X_IN
     ADD  DX, DI_Y_IN
     ADD  BX, DI_CO
     JMP  @MLOOP
 @FINISH:
end;

{Рисует линию по координатам x,y,x1,y1 с учетом одной толщины}
procedure SLine(x1,y1,x2,y2: Integer); assembler;
asm
     MOV  CX, 1
     MOV  DX, 1
     MOV  DI, Y2
     SUB  DI, Y1
     JGE  @KEEP_Y
     NEG  DX
     NEG  DI
 @KEEP_Y:
     MOV  DI_Y_IN, DX
     MOV  SI, X2
     SUB  SI, X1
     JGE  @KEEP_X
     NEG  CX
     NEG  SI
 @KEEP_X:
     MOV  DI_X_IN, CX
     CMP  SI, DI
     JGE  @HORS
     MOV  CX, 0
     XCHG SI, DI
     JMP  @SAVS
 @HORS:
     MOV  DX, 0
 @SAVS:
     MOV  SH_DI, DI
     MOV  ST_X_IN, CX
     MOV  ST_Y_IN, DX
     MOV  AX, SH_DI
     SHL  AX, 1
     MOV  ST_CO, AX
     SUB  AX, SI
     MOV  BX, AX
     SUB  AX, SI
     MOV  DI_CO, AX
     MOV  DX, Y1
     MOV  CX, X1
     INC  SI
 @MLOOP:
     DEC  SI
     JZ   @FINISH
     PUSH SI
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH CX
     PUSH DX
     CALL PUTLINEPIXEL
     POP  DX
     POP  CX
     POP  BX
     POP  SI
     CMP  BX, 0
     JGE  @DILIN
     ADD  CX, ST_X_IN
     ADD  DX, ST_Y_IN
     ADD  BX, ST_CO
     JMP  @MLOOP
 @DILIN:
     ADD  CX, DI_X_IN
     ADD  DX, DI_Y_IN
     ADD  BX, DI_CO
     JMP  @MLOOP
 @FINISH:
end;

{Выводит текст по координатам x,y; t - тип шрифта:
 0 - 8x8
 1 - 8x14
 2 - 8x16 точек}
procedure PrintText(x,y: Integer; str: String);
var n,m,o,p: Integer;
    bt, t:byte;
    s,sm,wrd,sy:word;
    b: array [0..1] of byte absolute str;
    col: TColor;
begin
   case TextStyle.TextStyle of
    0: begin sy:=8;  t:=3; end;
    1: begin sy:=14; t:=2; end;
    2: begin sy:=16; t:=6; end;
    else begin sy:=14; t:=2; end;
   end;
   asm
    MOV  AH, $11
    MOV  AL, $30
    MOV  BH, T
    PUSH BP
    INT  $10
    MOV  BX, BP
    POP  BP
    MOV  AX, ES
    MOV  S, AX
    MOV  SM, BX
   end;
   if TextStyle.Text then begin
    col:=SelectColor;
    SetColor(TextStyle.TextColor);
    for n:=1 to length(str) do begin
     wrd:=b[n]*sy;
      for m:=1 to sy do begin
       bt:=mem[s:sm+wrd+m-1];
       if TextStyle.Bold then bt:=bt or (bt shr 1);
       for p:=1 to 8 do
        if bt and (1 shl p) = (1 shl p) then PutPixel(x+8+((n-1)*8)-(p-1),y+(m-1));
      end;
    end;
    SetColor(col);
   end;
  if TextStyle.Fon then begin
    col:=SelectColor;
    SetColor(TextStyle.FonColor);
    for n:=1 to length(str) do begin
     wrd:=ord(str[n])*sy;
      for m:=1 to sy do begin
       bt:=mem[s:sm+wrd+m-1];
       if TextStyle.Bold then bt:=bt or (bt shr 1);
       for p:=1 to 8 do
        if bt and (1 shl p) <> (1 shl p) then PutPixel(x+8+((n-1)*8)-(p-1),y+(m-1));
      end;
    end;
    SetColor(col);
  end;
end;




{Рисует закрашеный прямоугольник по координатам x,y,x1,y1}
procedure IBar(x,y,x1,y1,c: Integer); assembler;
asm
     MOV  DI, Y
     CMP  DI, Y1
     JNG  @NOSWAP
     XCHG DI, Y1
 @NOSWAP:
     MOV  Y, DI
     MOV  SI, X
     CMP  SI, X1
     JNG  @1
     XCHG SI, X1
     JMP  @1
 @4: MOV  DI, Y
     JMP  @2
 @3: PUSH SI
     PUSH DI
     MOV  AX, c
     PUSH AX
     CALL PUTINDEXPIXEL
     INC  DI
 @2: CMP  DI, Y1
     JNG  @3
     INC  SI
 @1: CMP  SI, X1
     JNG  @4
end;

{Рисует прямоугольник по координатам x,y,x1,y1}
procedure IRectangle(x,y,x1,y1,c: Integer); assembler;
asm
     MOV  DI, Y
     CMP  DI, Y1
     JNG  @NOSWAP
     XCHG DI, Y1
 @NOSWAP:
     MOV  Y, DI
     MOV  SI, X
     CMP  SI, X1
     JNG  @1
     XCHG SI, X1
     JMP  @1
 @2: PUSH SI
     MOV  AX, Y
     PUSH AX
     MOV  AX, c
     PUSH AX
     CALL PUTINDEXPIXEL
     PUSH SI
     MOV  AX, Y1
     PUSH AX
     MOV  AX, c
     PUSH AX
     CALL PUTINDEXPIXEL
     INC  SI
 @1: CMP  SI, X1
     JNG  @2
     MOV  SI, Y
     JMP  @3
 @4: MOV  AX, X
     PUSH AX
     PUSH SI
     MOV  AX, c
     PUSH AX
     CALL PUTINDEXPIXEL
     MOV  AX, X1
     PUSH AX
     PUSH SI
     MOV  AX, c
     PUSH AX
     CALL PUTINDEXPIXEL
     INC  SI
 @3: CMP  SI, Y1
     JNG  @4
end;

{Рисует прямоугольник по координатам x,y,x1,y1 с учетом стиля линии}
procedure IFRectangle(x,y,x1,y1,c: Integer);
begin
 IFLine(x,y,x1,y,c);
 IFLine(x1,y,x1,y1,c);
 IFLine(x1,y1,x,y1,c);
 IFLine(x,y1,x,y,c);
end;

{Рисует прямоугольник по координатам x,y,x1,y1 с учетом одной толщини}
procedure ISRectangle(x,y,x1,y1,c: Integer);
begin
 ISLine(x,y,x1,y,c);
 ISLine(x1,y,x1,y1,c);
 ISLine(x1,y1,x,y1,c);
 ISLine(x,y1,x,y,c);
end;

{Рисует линию по координатам x,y,x1,y1}
procedure ILine(x1,y1,x2,y2,c: Integer); assembler;
asm
     MOV  CX, 1
     MOV  DX, 1
     MOV  DI, Y2
     SUB  DI, Y1
     JGE  @KEEP_Y
     NEG  DX
     NEG  DI
 @KEEP_Y:
     MOV  DI_Y_IN, DX
     MOV  SI, X2
     SUB  SI, X1
     JGE  @KEEP_X
     NEG  CX
     NEG  SI
 @KEEP_X:
     MOV  DI_X_IN, CX
     CMP  SI, DI
     JGE  @HORS
     MOV  CX, 0
     XCHG SI, DI
     JMP  @SAVS
 @HORS:
     MOV  DX, 0
 @SAVS:
     MOV  SH_DI, DI
     MOV  ST_X_IN, CX
     MOV  ST_Y_IN, DX
     MOV  AX, SH_DI
     SHL  AX, 1
     MOV  ST_CO, AX
     SUB  AX, SI
     MOV  BX, AX
     SUB  AX, SI
     MOV  DI_CO, AX
     MOV  DX, Y1
     MOV  CX, X1
     INC  SI
 @MLOOP:
     DEC  SI
     JZ   @FINISH
     PUSH CX
     PUSH DX
     MOV  AX, c
     PUSH AX
     CALL PUTINDEXPIXEL
     CMP  BX, 0
     JGE  @DILIN
     ADD  CX, ST_X_IN
     ADD  DX, ST_Y_IN
     ADD  BX, ST_CO
     JMP  @MLOOP
 @DILIN:
     ADD  CX, DI_X_IN
     ADD  DX, DI_Y_IN
     ADD  BX, DI_CO
     JMP  @MLOOP
 @FINISH:
end;

procedure IPutLinePixel(x,y,c: Integer); assembler;
asm
     MOV  AX, WORD PTR LINESTYLE.SIZE
     SHR  AX, 1
     MOV  DX, X
     SUB  DX, AX
     MOV  CX, DX
     ADD  CX, WORD PTR LINESTYLE.SIZE
     INC  DX
     PUSH DX
     MOV  DX, Y
     SUB  DX, AX
     INC  DX
     PUSH DX
     PUSH CX
     DEC  DX
     ADD  DX, WORD PTR LINESTYLE.SIZE
     PUSH DX
     MOV  AX, c
     PUSH AX
     CALL IBAR
end;

{Рисует линию по координатам x,y,x1,y1 с учетом стиля линии}
procedure IFLine(x1,y1,x2,y2,c: Integer); assembler;
asm
     MOV  CX, 1
     MOV  DX, 1
     MOV  DI, Y2
     SUB  DI, Y1
     JGE  @KEEP_Y
     NEG  DX
     NEG  DI
 @KEEP_Y:
     MOV  DI_Y_IN, DX
     MOV  SI, X2
     SUB  SI, X1
     JGE  @KEEP_X
     NEG  CX
     NEG  SI
 @KEEP_X:
     MOV  DI_X_IN, CX
     CMP  SI, DI
     JGE  @HORS
     MOV  CX, 0
     XCHG SI, DI
     JMP  @SAVS
 @HORS:
     MOV  DX, 0
 @SAVS:
     MOV  SH_DI, DI
     MOV  ST_X_IN, CX
     MOV  ST_Y_IN, DX
     MOV  AX, SH_DI
     SHL  AX, 1
     MOV  ST_CO, AX
     SUB  AX, SI
     MOV  BX, AX
     SUB  AX, SI
     MOV  DI_CO, AX
     MOV  DX, Y1
     MOV  CX, X1
     INC  SI
 @MLOOP:
     DEC  SI
     JZ   @FINISH
     PUSH DX
     PUSH CX
     PUSH SI
     CALL ISLINEPOINT
     POP  CX
     POP  DX
     CMP  AL, 0
     JE   @NOPOINT
     PUSH SI
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH CX
     PUSH DX
     MOV  AX, c
     PUSH AX
     CALL IPUTLINEPIXEL
     POP  DX
     POP  CX
     POP  BX
     POP  SI
 @NOPOINT:
     CMP  BX, 0
     JGE  @DILIN
     ADD  CX, ST_X_IN
     ADD  DX, ST_Y_IN
     ADD  BX, ST_CO
     JMP  @MLOOP
 @DILIN:
     ADD  CX, DI_X_IN
     ADD  DX, DI_Y_IN
     ADD  BX, DI_CO
     JMP  @MLOOP
 @FINISH:
end;

{Рисует линию по координатам x,y,x1,y1 с учетом одной толщины}
procedure ISLine(x1,y1,x2,y2,c: Integer); assembler;
asm
     MOV  CX, 1
     MOV  DX, 1
     MOV  DI, Y2
     SUB  DI, Y1
     JGE  @KEEP_Y
     NEG  DX
     NEG  DI
 @KEEP_Y:
     MOV  DI_Y_IN, DX
     MOV  SI, X2
     SUB  SI, X1
     JGE  @KEEP_X
     NEG  CX
     NEG  SI
 @KEEP_X:
     MOV  DI_X_IN, CX
     CMP  SI, DI
     JGE  @HORS
     MOV  CX, 0
     XCHG SI, DI
     JMP  @SAVS
 @HORS:
     MOV  DX, 0
 @SAVS:
     MOV  SH_DI, DI
     MOV  ST_X_IN, CX
     MOV  ST_Y_IN, DX
     MOV  AX, SH_DI
     SHL  AX, 1
     MOV  ST_CO, AX
     SUB  AX, SI
     MOV  BX, AX
     SUB  AX, SI
     MOV  DI_CO, AX
     MOV  DX, Y1
     MOV  CX, X1
     INC  SI
 @MLOOP:
     DEC  SI
     JZ   @FINISH
     PUSH SI
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH CX
     PUSH DX
     MOV  AX, c
     PUSH AX
     CALL IPUTLINEPIXEL
     POP  DX
     POP  CX
     POP  BX
     POP  SI
     CMP  BX, 0
     JGE  @DILIN
     ADD  CX, ST_X_IN
     ADD  DX, ST_Y_IN
     ADD  BX, ST_CO
     JMP  @MLOOP
 @DILIN:
     ADD  CX, DI_X_IN
     ADD  DX, DI_Y_IN
     ADD  BX, DI_CO
     JMP  @MLOOP
 @FINISH:
end;

{Выводит текст по координатам x,y; t - тип шрифта:
 0 - 8x8
 1 - 8x14
 2 - 8x16 точек}
procedure IPrintText(x,y: Integer; str: String);
var n,m,o,p: Integer;
    bt, t:byte;
    s,sm,wrd,sy:word;
    b: array [0..1] of byte absolute str;
begin
   case TextStyle.TextStyle of
    0: begin sy:=8;  t:=3; end;
    1: begin sy:=14; t:=2; end;
    2: begin sy:=16; t:=6; end;
    else begin sy:=14; t:=2; end;
   end;
   asm
    MOV  AH, $11
    MOV  AL, $30
    MOV  BH, T
    PUSH BP
    INT  $10
    MOV  BX, BP
    POP  BP
    MOV  AX, ES
    MOV  S, AX
    MOV  SM, BX
   end;
   if TextStyle.Text then
    for n:=1 to Length(str) do begin
     wrd:=b[n]*sy;
      for m:=1 to sy do begin
       bt:=mem[s:sm+wrd+m-1];
       if TextStyle.Bold then bt:=bt or (bt shr 1);
       for p:=1 to 8 do
        if bt and (1 shl p) = (1 shl p) then
          PutIndexPixel(x+8+((n-1)*8)-(p-1),y+(m-1),TextStyle.TextColor.Red)
         else
          if TextStyle.Fon then
           PutIndexPixel(x+8+((n-1)*8)-(p-1),y+(m-1),TextStyle.FonColor.Red);
      end;
    end;
end;



{Устанавливает цвет, которым все должно выводиться}
procedure SetColor(col: TColor); assembler;
asm
     MOV  AL, 2
     MOV  AH, BYTE PTR COL.RED
     MOV  BL, BYTE PTR COL.GREEN
     MOV  BH, BYTE PTR COL.BLUE
     MOV  BYTE PTR SELECTCOLOR.RED, AH
     MOV  BYTE PTR SELECTCOLOR.GREEN, BL
     MOV  BYTE PTR SELECTCOLOR.BLUE, BH
     INT  $EE
end;

procedure SetRGBColor(r, g, b: Byte); assembler;
asm
     MOV  AL, 2
     MOV  AH, R
     MOV  BL, G
     MOV  BH, B
     MOV  BYTE PTR SELECTCOLOR.RED, AH
     MOV  BYTE PTR SELECTCOLOR.GREEN, BL
     MOV  BYTE PTR SELECTCOLOR.BLUE, BH
     INT  $EE
end;

{Устанавливает тип линии}
procedure SetLineStyle(mask: Word; size: Byte); assembler;
asm
     MOV  AX, MASK
     MOV  WORD PTR LINESTYLE.STYLE, AX
     MOV  AL, SIZE
     MOV  BYTE PTR LINESTYLE.SIZE, AL
end;

{Устанавливает стиль текста}
procedure SetTextStyle(ts: Byte; front, fon, Bold: Boolean; TextColor, FonColor: TColor);
begin
 TextStyleV.TextStyle:=ts and 3;
 TextStyleV.Text:=front;       {Выводить или нет текст}
 TextStyleV.Fon:=fon;           {Выводить или нет фон текста}
 TextStyleV.FonColor:=FonColor; {Если да, то цвет фона}
 TextStyleV.TextColor:=TextColor;
 TextStyleV.Bold:=Bold;         {Жирный или обычный текст}
end;

{Устанавливает окно в котором можно рисовать}
procedure SetWindow(x,y,x1,y1: Integer); assembler;
asm
     MOV  DI, X
     CMP  DI, X1
     JNG  @NOSWAP
     XCHG DI, X1
     MOV  X,  DI
 @NOSWAP:
     MOV  DI, Y
     CMP  DI, Y1
     JNG  @NOSWAP1
     XCHG DI, Y1
     MOV  Y,  DI
 @NOSWAP1:
     MOV  AX, X
     CMP  AX, 0
     JL   @EXIT
     CMP  AX, MAXX
     JG   @EXIT
     MOV  DMINX, AX
     MOV  AX, Y
     CMP  AX, 0
     JL   @EXIT
     CMP  AX, MAXY
     JG   @EXIT
     MOV  DMINY, AX
     MOV  AX, X1
     CMP  AX, 0
     JL   @EXIT
     CMP  AX, MAXX
     JG   @EXIT
     MOV  DMAXX, AX
     MOV  AX, Y1
     CMP  AX, 0
     JL   @EXIT
     CMP  AX, MAXY
     JG   @EXIT
     MOV  DMAXY, AX
 @EXIT:
end;

{============================================================================}
begin
 if not RegisterUGD then begin
  WriteLn('Error: UGD driver not installed.');
  Halt(0);
 end;
 SetTextStyle(Font1,True,False,False,White,Black);
 SetColor(White);
end.
{============================================================================}
{====                 Universal Graphics Driver Interface                ====}
{====                            Version  1.0                            ====}
{====                   Copyright (c)  2000 ShAG Studio                  ====}
{============================================================================}
