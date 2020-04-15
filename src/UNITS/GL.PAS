uses Graph, Crt;

const
     alLeft = 0;
     alCenter = 1;
     alRight = 2;
     alTop = 0;
     alBottom = 2;


type PColor = ^TColor;
     TColor = LongInt;

type PFillPattern = ^TFillPattern;
     TFillPattern = array [0..7] of Byte;

const
     clWhite      = $00FFFFFF;
     clBlack      = $00000000;
     clLightGray  = $00ACACAC;
     clDarkGray   = $00808080;
     clLightBlue  = $00FF0000;
     clLightGreen = $0000FF00;
     clLightRed   = $000000FF;
     clBlue       = $00800000;
     clGreen      = $00008000;
     clRed        = $00000080;
     fpSolid: TFillPattern       = ($FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);
     fpGray50: TFillPattern      = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);

type PPoint = ^TPoint;
     TPoint = record
     X, Y: Integer;
     end;

type PRect = ^TRect;
     TRect = record
     X1, Y1, X2, Y2: Integer;
     end;

type PLineStyle = ^TLineStyle;
     TLineStyle = record
      Size,
      Pattern: Word;
     end;

type PFillStyle = ^TFillStyle;
     TFillStyle = record
      BGColor: TColor;
      Pattern: TFillPattern;
     end;

type PTextStyle = ^TTextStyle;
     TTExtStyle = record
      VAlign,
      HAlign: Byte;
     end;

type PStyles = ^TStyles;
     TStyles = record
      Color: TColor;
      LineStyle: TLineStyle;
      FillStyle: TFillStyle;
      TextStyle: TTextStyle;
      Window: TRect;
      Prev: PStyles;
     end;

type PImageBlock = ^TImageBlock;
     TImageBlock = record
      Next: PImageBlock;
      Size: Word;
      Block: Pointer;
     end;

type PImage = ^TImage;
     TImage = record
      Width,
      Height: Word;
      Blocks: PImageBlock;
     end;


var  Color: TColor;
     HColor: LongInt;
     MinX, MaxX, MinY, MaxY: Integer;
     Window: TRect;
     LineStyle: TLineStyle;
     FillStyle: TFillStyle;
     TextStyle: TTextStyle;
     Styles: PStyles;

const
     Palette: array [0..47] of Byte =
              (0,   0,   0,
               0,   0,   128,
               0,   128, 0,
               0,   128, 128,
               128, 0,   0,
               128, 0,   128,
               128, 128, 0,
               172, 172, 172,
               128, 128, 128,
               0,   0,   255,
               0,   255, 0,
               0,   255, 255,
               255, 0,   0,
               255, 0,   255,
               255, 255, 0,
               255, 255, 255);
     MaxColor = 15;

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

{Инициализация режимов}
procedure  InitGL;
var gd, gm: Integer;
begin
 gd:=0; gm:=0;
 InitGraph(gd, gm, '');
end;

procedure  CloseGL;
begin
 CloseGraph;
end;

function   TextLength(text: String): Integer;
begin
 TextLength:=Length(text)*8;
end;

function   TextHeight(text: String): Integer;
begin
 TextHeight:=8;
end;

{Простейшие контурные фигуры}
procedure  PutPixel(x, y: Integer);
begin
 Graph.PutPixel(x, y, HColor);
end;

procedure  GetPixel(x, y: Integer);
begin
 HColor:=Graph.GetPixel(x, y);
end;

procedure  DrawLine(x1, y1, x2, y2: Integer);
begin
 Line(x1, y1, x2, y2);
end;

procedure  DrawRect(x1, y1, x2, y2: Integer);
begin
 Rectangle(x1, y1, x2, y2);
end;

procedure  DrawEllipse(x1, y1, x2, y2: Integer);
begin
 Ellipse(x1 + abs(x1-x2) div 2, y1 + abs(y1-y2) div 2,
         0, 360,
         abs(x1-x2) div 2, abs(y1-y2) div 2);
end;

procedure  DrawArc(x1, y1, x2, y2, a, b: Integer);
begin
 Ellipse(x1 + abs(x1-x2) div 2, y1 + abs(y1-y2) div 2,
         a, b,
         abs(x1-x2) div 2, abs(y1-y2) div 2);
end;

procedure  DrawText(x1, y1, x2, y2: Integer; text: String);
begin
 case TextStyle.HAlign of
  alCenter: x1:=x1+(abs(x1-x2)-TextLength(text)) div 2;
  alRight: x1:=x2-TextLength(text);
 end;
 case TextStyle.VAlign of
  alCenter: y1:=y1+(abs(x1-x2)-TextHeight(text)) div 2;
  alBottom: y1:=y2-TextHeight(text);
 end;
 OutTextXY(x1, y1, text);
end;

{Простейшие закрашенные фигуры}
procedure  FillRect(x1, y1, x2, y2: Integer);
begin
 Bar(x1, y1, x2, y2);
end;

procedure  FillEllipse(x1, y1, x2, y2: Integer);
begin
 Graph.FillEllipse(x1 + abs(x1-x2) div 2, y1 + abs(y1-y2) div 2,
                   abs(x1-x2) div 2, abs(y1-y2) div 2);
end;

procedure  FillPolygon(x, y, step: Integer);
begin
end;

{Конфигурация}

procedure  SetLinePattern(Pattern: Word);
begin
 SetLineStyle(UserBitLn, Pattern, LineStyle.Size);
 LineStyle.Pattern:=Pattern;
end;

procedure  SetLineSize(Size: Integer);
begin
 SetLineStyle(UserBitLn, LineStyle.Pattern, Size);
 LineStyle.Size:=Size;
end;

procedure  SetLineStyle(Pattern: Word; size: Integer);
begin
 SetLineSize(Size);
 SetLinePattern(Pattern);
end;

procedure  SetFillPattern(Pattern: TFillPattern);
begin
 FillStyle.Pattern:=Pattern;
 Graph.SetFillPattern(FillPatternType(Pattern), HColor);
end;

procedure  SetFillBGColor(BGColor: TColor);
begin
 FillStyle.BGColor:=BGColor;
 Graph.SetFillPattern(FillPatternType(FillStyle.Pattern), HColor);
end;

procedure  SetFillStyle(Pattern: TFillPattern; BGColor: TColor);
begin
 SetFillPattern(Pattern);
 SetFillBGColor(BGColor);
end;

procedure  SetTextHAlign(HAlign: Byte);
begin
 TextStyle.HAlign:=HAlign;
end;

procedure  SetTextVAlign(VAlign: Byte);
begin
 TextStyle.VAlign:=VAlign;
end;

procedure  SetTextStyle(HAlign, VAlign: Byte);
begin
 SetTextHAlign(HAlign);
 SetTextVAlign(VAlign);
end;

procedure  SetWorkWindow(x1, y1, x2, y2: Integer);
begin
 Window.X1:=x1;
 Window.X2:=x2;
 Window.Y1:=y1;
 Window.Y2:=y2;
 SetViewPort(x1, y1, x2, y2, True);
end;

function   GetMaxX: Integer;
begin
 GetMaxX:=Graph.GetMaxX;
end;

procedure  SetColor(c: TColor);
begin
 HColor:=ChooseColor(C and 255,
                    (C shr 8) and 255,
                    (C shr 16) and 255);
 Color:=C;
 Graph.SetColor(HColor);
 Graph.SetFillPattern(FillPatternType(FillStyle.Pattern), HColor);
end;

procedure  PushStyles;
var PS: PStyles;
begin
  if MaxAvail < (SizeOf(TStyles)*2) then Exit;
  New(PS);
  PS^.Color:=Color;
  PS^.LineStyle:=LineStyle;
  PS^.FillStyle:=FillStyle;
  PS^.TextStyle:=TextStyle;
  PS^.Window:=Window;
  PS^.Prev:=Styles;
  Styles:=PS;
end;

procedure  PopStyles;
var ts: PStyles;
begin
 if Styles = nil then Exit;
 LineStyle:=Styles^.LineStyle;
 FillStyle:=Styles^.FillStyle;
 TextStyle:=Styles^.TextStyle;
 Window:=Styles^.Window;
 SetColor(Styles^.Color);
 ts:=Styles;
 Styles:=Styles^.Prev;
 Dispose(ts);
end;

function   GetMaxY: Integer;
begin
 GetMaxY:=Graph.GetMaxY;
end;

function   GetImageSize(x1, y1, x2, y2: Integer): LongInt;
begin
 GetImageSize:=(abs(x1-x2)*abs(y1-y2)*ImageSize(1, 1, 10, 10)) div 106;
end;

procedure  DisposeImage(var Image: PImage);
var Block, tb: PImageBlock;
begin
 if Image = nil then Exit;
 if (Image^.Blocks = nil) or (Image^.Width*Image^.Height = 0) then Exit;
 Block:=Image^.Blocks;
 Dispose(Image);
 repeat
  tb:=Block^.Next;
  FreeMem(Block^.Block, Block^.Size);
  Dispose(Block);
  Block:=tb;
 until Block = nil;
end;

procedure  GetImage(x1, y1, x2, y2: Integer; var Image: PImage);
var Width: Integer;
    Block,
    CurBlock: PImageBlock;
begin
 New(Image);
 Image^.Width:=abs(x1-x2);
 Image^.Height:=abs(y1-y2);
 Image^.Blocks:=nil;
 Width:=x2-x1;
 if Width > 50 then Width:=50;
 CurBlock:=nil;
 repeat
   if MaxAvail >= ImageSize(x1, y1, x1+Width, y2)+1024 then begin
     New(Block);
     Block^.Size:=ImageSize(x1, y1, x1+Width, y2);
     GetMem(Block^.Block, Block^.Size);
     Block^.Next:=nil;
     Graph.GetImage(x1, y1, x1+Width, y2, Block^.Block^);
     if CurBlock <> nil then CurBlock^.Next:=Block
                        else Image^.Blocks:=Block;
     CurBlock:=Block;
     x1:=x1+Width;
     Width:=x2-x1;
     if Width > 50 then Width:=50;
   end else begin
     if CurBlock <> nil then CurBlock^.Next:=nil
                        else Image^.Blocks:=nil;
     DisposeImage(Image);
   end;
 until (Width <= 0) or (CurBlock = nil);
end;

procedure  PutImage(x1, y1: Integer; var Image: PImage);
var Block: PImageBlock;
begin
 if Image = nil then Exit;
 if (Image^.Blocks = nil) or (Image^.Width*Image^.Height = 0) then Exit;
 Block:=Image^.Blocks;
 repeat
  Graph.PutImage(x1, y1, Block^.Block^, NormalPut);
  Block:=Block^.Next;
  x1:=x1+50;
 until Block = nil;
end;

var    i: PImage;
       n: LongInt;
begin
 InitGL;
 SetColor(clLightRed);
 SetFillPattern(fpSolid);
 randomize;
 SetWorkWindow(150,150,450,300);
{ FillEllipse(0,0,100,140);
 SetColor(clRed);
 FillEllipse(10,10,90,130);}
 DrawRect(0,0,257,150);
 PushStyles;
 SetFillPattern(fpGray50);
 for n:=0 to 255 do begin
  SetColor({n or (n shl 8) or }(n shl 16));
  DrawLine(n+1, 1, n+1, 149);
 end;
 PopStyles;
 GetImage(0, 0, 100, 140, i);
 FillRect(0, 0, GetMaxX, GetMaxX);
 PutImage(10, 10, i);
 PutImage(90, 10, i);
 PutImage(90, 90, i);
 PutImage(10, 90, i);
 PutImage(50, 50, i);
 DisposeImage(i);
 CloseGL;
end.