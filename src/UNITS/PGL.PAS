 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                           Pascal Graphics Language
                                 Version 1.0
                       Copyright (c) 2000 ShAG Studio
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   Этот модуль содержит команды необходимые для работы в графическом режиме.
  Все команды расчитаны для работы в режиме 24 бит на точку, но их интерфейс
  cделан так, чтобы сделать эту зависимость прозрачной.
   Данная версия реализована для режимов EGA или VGA,  но при этом интерфейс
  модуля не изменился. При задании цвета специальная процедура путем подбора
  из палитры вибирает оптимальный цвет для трех компонент (Красный, Зеленый,
  Синий) и рисует этим цветом, как нужным.
   Используя данный модуль Вы можете писать и отлаживать программу в VGA или
  EGA режиме, а затем изменив в модуле соответствующие команды переделать на
  требуемый режим. При этом все ваши программы будут работать также как и до
  модификации модуля, но в другом режиме.
  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

 unit PGL;

 interface

 uses Graph;

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                               Новые типы данных
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 type
     {----------------------------------
      Тип          Цвет
      ----------------------------------}
     PColor = ^TColor;
     TColor = LongInt;

     {----------------------------------
      Тип          Точка
      ----------------------------------}
     PPoint = ^TPoint;
     TPoint = record
       X, Y       : Integer;
     end;

     {----------------------------------
      Тип          Прямоугольник
      ----------------------------------}
     PRect = ^TRect;
     TRect = record
       A, B       : TPoint;
     end;

     {----------------------------------
      Тип          Закраска
      ----------------------------------}
     PFillPattern = ^TFillPattern;
     TFillPattern = array [0..7] of Byte;

     {----------------------------------
      Тип          Стиль линии
      ----------------------------------}
     PLineStyle = ^TLineStyle;
     TLineStyle = record
       Size,
       Pattern    : Word;
     end;

     {----------------------------------
      Тип          Стиль закраски
      ----------------------------------}
     PFillStyle = ^TFillStyle;
     TFillStyle = record
       BGColor    : TColor;
       Pattern    : TFillPattern;
     end;

     {----------------------------------
      Тип          Стиль текста
      ----------------------------------}
     PTextStyle = ^TTextStyle;
     TTExtStyle = record
       VAlign,
       HAlign     : Byte;
     end;

     {----------------------------------
      Тип          Все параметры
      ----------------------------------}
     PStyles = ^TStyles;
     TStyles = record
       Prev       : PStyles;
       Color      : TColor;
       Window     : TRect;
       LineStyle  : TLineStyle;
       FillStyle  : TFillStyle;
       TextStyle  : TTextStyle;
     end;

     {----------------------------------
      Тип          Часть изображения
      ----------------------------------}
     PImageBlock = ^TImageBlock;
     TImageBlock = record
       Next       : PImageBlock;
       Size       : Word;
       Block      : Pointer;
     end;

     {----------------------------------
      Тип          Изображение
      ----------------------------------}
     PImage = ^TImage;
     TImage = record
      Width,
      Height      : Word;
      Blocks      : PImageBlock;
     end;



 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  Константы
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 const
     {----------------------------------
                    Цвета
      ----------------------------------}
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

     {----------------------------------
                Типы закраски
      ----------------------------------}
     fpNo         : TFillPattern = ($00, $00, $00, $00, $00, $00, $00, $00);
     fpSolid      : TFillPattern = ($FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);
     fpLine       : TFillPattern = ($FF, $FF, $00, $00, $FF, $FF, $00, $00);
     fpLtSlash    : TFillPattern = ($01, $02, $04, $08, $10, $20, $40, $80);
     fpSlash      : TFillPattern = ($E0, $C1, $83, $07, $0E, $1C, $38, $70);
     fpBkSlash    : TFillPattern = ($F0, $78, $3C, $1E, $0F, $87, $C3, $E1);
     fpLtBkSlash  : TFillPattern = ($A5, $D2, $69, $B4, $5A, $2D, $96, $4B);
     fpHatch      : TFillPattern = ($FF, $88, $88, $88, $FF, $88, $88, $88);
     fpXHatch     : TFillPattern = ($81, $42, $24, $18, $18, $24, $42, $81);
     fpInterleave : TFillPattern = ($CC, $33, $CC, $33, $CC, $33, $CC, $33);
     fpWideDot    : TFillPattern = ($80, $00, $08, $00, $80, $00, $08, $00);
     fpCloseDot   : TFillPattern = ($88, $00, $22, $00, $88, $00, $22, $00);
     fpGray50     : TFillPattern = ($AA, $55, $AA, $55, $AA, $55, $AA, $55);
     fpDots       : TFillPattern = ($AA, $00, $AA, $00, $AA, $00, $AA, $00);

     {----------------------------------
                  Типы линий
      ----------------------------------}
     lpSolid      = $FFFF;
     lpDotted     = $CCCC;
     lpCenter     = $FC78;
     lpDashed     = $F8F8;

     {----------------------------------
                Толщина линий
      ----------------------------------}
     lwNormal     = $01;
     lwThick      = $03;

     {----------------------------------
          Способы выравнивания текста
      ----------------------------------}
     alLeft       = $00;
     alCenter     = $01;
     alRight      = $02;
     alTop        = $00;
     alBottom     = $02;

     {----------------------------------
           VGA палитра для 16 цветов
      ----------------------------------}
     Palette      : array [0..47] of Byte = (
                    $00, $00, $00,   $00, $00, $80,   $00, $80, $00,
                    $00, $80, $80,   $80, $00, $00,   $80, $00, $80,
                    $80, $80, $00,   $AC, $AC, $AC,   $80, $80, $80,
                    $00, $00, $FF,   $00, $FF, $00,   $00, $FF, $FF,
                    $FF, $00, $00,   $FF, $00, $FF,   $FF, $FF, $00,
                    $FF, $FF, $FF);

     {----------------------------------
        Максимальное количество цветов
      ----------------------------------}
     MaxColor     = $0F;



 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                Переменные
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 var
     Color        : TColor;            { Текущий цвет для рисования        }
     HColor       : LongInt;           { Физичиский цвет - для конкретного }
                                       { графического режима               }
     Window       : TRect;             { Границы окна для рисования        }
     LineStyle    : TLineStyle;        { Стиль линии                       }
     FillStyle    : TFillStyle;        { Стиль закраски                    }
     TextStyle    : TTextStyle;        { Стиль текста                      }
     Styles       : PStyles;           { Стек параметров                   }



 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  Функции
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  function   AssignRect(x1, y1, x2, y2: Integer): PRect;
  function   ChooseColor(r, g, b: Word): Word;
  function   DecRect(R: PRect; P: PPoint): PRect;
  function   GetImageSize(R: PRect): LongInt;
  function   GetMaxX: Integer;
  function   GetMaxY: Integer;
  function   IncRect(R: PRect; P: PPoint): PRect;
  function   InitPGL: Boolean;
  function   IsRect(R: PRect): Boolean;
  function   MaxInt(a, b: Integer): Integer;
  function   MinInt(a, b: Integer): Integer;
  function   MoveRect(R: PRect; P: PPoint): PRect;
  function   RAndR(A, B: PRect): PRect;
  function   RGB2Color(R, G, B: Byte): TColor;
  function   ROrR(A, B: PRect): PRect;
  function   TextHeight(text: String): Integer;
  function   TextLength(text: String): Integer;


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  Процедуры
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  procedure  ClosePGL;
  procedure  DisposeImage(var Image: PImage);
  procedure  DrawArc(x1, y1, x2, y2, a, b: Integer);
  procedure  DrawEllipse(x1, y1, x2, y2: Integer);
  procedure  DrawLine(x1, y1, x2, y2: Integer);
  procedure  DrawRect(x1, y1, x2, y2: Integer);
  procedure  DrawText(R: PRect; text: String);
  procedure  FillEllipse(x1, y1, x2, y2: Integer);
  procedure  FillPolygon(x, y, step: Integer);
  procedure  FillRect(x1, y1, x2, y2: Integer);
  procedure  GetImage(R: PRect; var Image: PImage);
  procedure  GetPixel(x, y: Integer);
  procedure  PopStyles;
  procedure  PushStyles;
  procedure  PutImage(x1, y1: Integer; var Image: PImage);
  procedure  PutPixel(x, y: Integer);
  procedure  SetColor(c: TColor);
  procedure  SetFillBGColor(BGColor: TColor);
  procedure  SetFillPattern(Pattern: TFillPattern);
  procedure  SetFillStyle(Pattern: TFillPattern; BGColor: TColor);
  procedure  SetLinePattern(Pattern: Word);
  procedure  SetLineSize(Size: Integer);
  procedure  SetLineStyle(Pattern: Word; size: Integer);
  procedure  SetTextHAlign(HAlign: Byte);
  procedure  SetTextVAlign(VAlign: Byte);
  procedure  SetTextStyle(HAlign, VAlign: Byte);
  procedure  SetViewWindow(R: PRect);

 implementation

  {----------------------------------
   Включаем внутрь файла драйвер BGI
   ----------------------------------}
  procedure EgaVgaDriverProc; external;
  {$L EGAVGA.OBJ }

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  Функции
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    Связывает с переменной типа
    прямоугольник конкретные
    координаты
   ----------------------------------}
  function   AssignRect(x1, y1, x2, y2: Integer): PRect;
  var  R: PRect;
  begin
   New(R);
   R^.A.X:=x1;
   R^.A.Y:=y1;
   R^.B.X:=x2;
   R^.B.Y:=y2;
   if not IsRect(R) then begin
     Dispose(R);
     R:=nil;
   end;
   AssignRect:=R;
  end;

  {----------------------------------
    Среди цветов палитры выбирает
    цвет, оптимальный для заданных
    параметров интенсивностей и
    возвращает его номер
   ----------------------------------}
  function   ChooseColor(r, g, b: Word): Word; assembler;
  asm
      push  $3E8
      mov   di, offset Palette
      xor   si, si
      xor   dh, dh
    @repeat:
      mov   ax, r
      mov   dl, [di]
      sub   ax, dx
      inc   di
      test  ah, $80
      jz    @p_ax
      neg   ax
    @p_ax:
      mov   bx, g
      mov   dl, [di]
      sub   bx, dx
      inc   di
      test  bh, $80
      jz    @p_bx
      neg   bx
    @p_bx:
      mov   cx, b
      mov   dl, [di]
      sub   cx, dx
      inc   di
      test  ch, $80
      jz    @p_cx
      neg   cx
    @p_cx:
      cmp   ax, bx
      jl    @no_ax
      mov   bx, ax
    @no_ax:
      cmp   bx, cx
      jg    @no_cx
      mov   bx, cx
    @no_cx:
      cmp   bx, 0
      jne   @no_color
      mov   ax, si
      jmp   @exit
    @no_color:
      pop   ax
      cmp   bx, ax
      jnl   @no_dx
      mov   es, si
      mov   ax, bx
    @no_dx:
      push  ax
      inc   si
      cmp   si, MaxColor
      jng   @repeat
      mov   ax, es
    @exit:
  end;

  {----------------------------------
    Уменьшает все координаты
    прямоугольника на P точек
   ----------------------------------}
  function   DecRect(R: PRect; P: PPoint): PRect;
  begin
    DecRect:=nil;
    if not IsRect(R) or (P = nil) then Exit;
    Dec(R^.A.X, P^.X);
    Dec(R^.B.X, P^.X);
    Dec(R^.A.Y, P^.Y);
    Dec(R^.B.Y, P^.Y);
    DecRect:=R;
  end;

  {----------------------------------
    Возвращает размер памяти,
    необходимой для сохранения
    изображения, ограниченного
    прямоугольником R
   ----------------------------------}
  function   GetImageSize(R: PRect): LongInt;
  begin
    GetImageSize:=0;
    if not IsRect(R) then Exit;
    with R^ do
    GetImageSize:=(abs(A.X - B.X) * abs(A.Y - B.Y) * ImageSize(1, 1, 10, 10))
                  div 106;
  end;

  {----------------------------------
    Возвращает максимальную
    координату в горизонтальной
    плоскости
   ----------------------------------}
  function   GetMaxX: Integer;
  begin
    GetMaxX:=Graph.GetMaxX;
  end;

  {----------------------------------
    Возвращает максимальную
    координату в вертикальной
    плоскости
   ----------------------------------}
  function   GetMaxY: Integer;
  begin
    GetMaxY:=Graph.GetMaxY;
  end;

  {----------------------------------
    Увеличивает все координаты
    прямоугольника на P точек
   ----------------------------------}
  function   IncRect(R: PRect; P: PPoint): PRect;
  begin
    IncRect:=nil;
    if not IsRect(R) or (P = nil) then Exit;
    Inc(R^.A.X, P^.X);
    Inc(R^.B.X, P^.X);
    Inc(R^.A.Y, P^.Y);
    Inc(R^.B.Y, P^.Y);
    IncRect:=R;
  end;

  {----------------------------------
    Включает графический режим
   ----------------------------------}
  function   InitPGL: Boolean;
  var  gd, gm: Integer;
  begin
    InitPGL:=False;
    if RegisterBGIdriver(@EGAVGADriverProc) < 0 then Exit;
    gd:=detect;
    gm:=VGAHi;
    InitGraph(gd, gm, '');
    SetColor(clWhite);
    SetLineStyle(lpSolid, lwNormal);
    SetFillStyle(fpSolid, clBlack);
    SetTextStyle(alLeft, alTop);
    SetViewWindow(AssignRect(0, 0, GetMaxX, GetMaxY));
    SetRGBPalette(15, 63, 63, 63);
    InitPGL:=True;
  end;

  {----------------------------------
    Возвращает True если
    прямоугольник логически верный
   ----------------------------------}
  function   IsRect(R: PRect): Boolean;
  begin
    IsRect:=False;
    if R = nil then exit;
    if (R^.A.X > R^.B.X) or (R^.A.Y > R^.B.Y) then Exit;
    IsRect:=True;
  end;

  {----------------------------------
    Возвращает максимальное из двух
    целых чисел
   ----------------------------------}
  function   MaxInt(a, b: Integer): Integer;
  begin
    if a > b then MaxInt:=a
             else MaxInt:=b;
  end;

  {----------------------------------
    Возвращает минимальное из двух
    целых чисел
   ----------------------------------}
  function   MinInt(a, b: Integer): Integer;
  begin
    if a < b then MinInt:=a
             else MinInt:=b;
  end;

  {----------------------------------
    Перемещает прямоугольник в
    точку P
   ----------------------------------}
  function   MoveRect(R: PRect; P: PPoint): PRect;
  begin
    MoveRect:=nil;
    if not IsRect(R) or (P = nil) then Exit;
    Dec(P^.X, R^.A.X);
    Dec(P^.Y, R^.A.Y);
    Inc(R^.A.X, P^.X);
    Inc(R^.B.X, P^.X);
    Inc(R^.A.Y, P^.Y);
    Inc(R^.B.Y, P^.Y);
    MoveRect:=R;
  end;

  {----------------------------------
    Возвращает результат пересечения
    двух прямоугольников
   ----------------------------------}
  function   RAndR(A, B: PRect): PRect;
  var  R: PRect;
  begin
    R:=nil;
    RAndR:=R;
    if not IsRect(A) or not IsRect(B) then Exit;
    New(R);
    R^.A.X:=MaxInt(A^.A.X, B^.A.X);
    R^.A.Y:=MaxInt(A^.A.Y, B^.A.Y);
    R^.B.X:=MinInt(A^.B.X, B^.B.X);
    R^.B.Y:=MinInt(A^.B.Y, B^.B.Y);
    if not IsRect(R) then begin
      if R <> nil then Dispose(R);
      R:=nil;
    end;
    RAndR:=R;
  end;

  {----------------------------------
    Возвращает цвет используя три
    интенсивности за входные данные.
   ----------------------------------}
  function   RGB2Color(R, G, B: Byte): TColor;
  begin
    RGB2Color:=LongInt(R) or (LongInt(G) shl 8) or (LongInt(B) shl 16);
  end;

  {----------------------------------
    Возвращает результат объеденения
    двух прямоугольников
   ----------------------------------}
  function   ROrR(A, B: PRect): PRect;
  var  R: PRect;
  begin
    R:=nil;
    ROrR:=R;
    if not IsRect(A) or not IsRect(B) then Exit;
    New(R);
    R^.A.X:=MinInt(A^.A.X, B^.A.X);
    R^.A.Y:=MinInt(A^.A.Y, B^.A.Y);
    R^.B.X:=MaxInt(A^.B.X, B^.B.X);
    R^.B.Y:=MaxInt(A^.B.Y, B^.B.Y);
    if not IsRect(R) then begin
      if R <> nil then Dispose(R);
      R:=nil;
    end;
    ROrR:=R;
  end;

  {----------------------------------
    Возвращает высоту строки text при
    заданном стиле вывода текста
   ----------------------------------}
  function   TextHeight(text: String): Integer;
  begin
   TextHeight:=8;
  end;

  {----------------------------------
    Возвращает высоту строки text при
    заданном стиле вывода текста
   ----------------------------------}
  function   TextLength(text: String): Integer;
  begin
   TextLength:=Length(text)*8;
  end;



 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  Процедуры
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    Выключает графический режим
   ----------------------------------}
  procedure  ClosePGL;
  begin
    CloseGraph;
  end;

  {----------------------------------
    Освобождает память от изображения
   ----------------------------------}
  procedure  DisposeImage(var Image: PImage);
  var  Block, tb: PImageBlock;
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

  {----------------------------------
    Рисует контурный дугу
   ----------------------------------}
  procedure  DrawArc(x1, y1, x2, y2, a, b: Integer);
  begin
    Ellipse(x1 + abs(x1 - x2) div 2, y1 + abs(y1 - y2) div 2,
            a, b,
            abs(x1 - x2) div 2, abs(y1 - y2) div 2);
  end;

  {----------------------------------
    Рисует контурный эллипс
   ----------------------------------}
  procedure  DrawEllipse(x1, y1, x2, y2: Integer);
  begin
    Ellipse(x1 + abs(x1 - x2) div 2, y1 + abs(y1 - y2) div 2,
            0, 360,
            abs(x1 - x2) div 2, abs(y1 - y2) div 2);
  end;

  {----------------------------------
    Рисует линию
   ----------------------------------}
  procedure  DrawLine(x1, y1, x2, y2: Integer);
  begin
    Line(x1, y1, x2, y2);
  end;

  {----------------------------------
    Рисует контурный прямоугольник
   ----------------------------------}
  procedure  DrawRect(x1, y1, x2, y2: Integer);
  begin
    Rectangle(x1, y1, x2, y2);
  end;

  {----------------------------------
    Рисует текст
   ----------------------------------}
  procedure  DrawText(R: PRect; text: String);
  var  x, y: Integer;
  begin
    if not IsRect(R) then Exit;
    with R^ do begin
      case TextStyle.HAlign of
       alCenter    : x:=A.X + (abs(A.X - B.X) - TextLength(text)) div 2;
       alRight     : x:=B.X - TextLength(text);
       else          x:=A.X;
      end;
      case TextStyle.VAlign of
       alCenter    : y:=A.Y + (abs(A.Y - B.Y) - TextHeight(text)) div 2;
       alBottom    : y:=B.Y - TextHeight(text);
       else          y:=A.Y;
      end;
    end;
    OutTextXY(x, y, text);
  end;

  {----------------------------------
    Рисует закрашеный эллипс
   ----------------------------------}
  procedure  FillEllipse(x1, y1, x2, y2: Integer);
  begin
   Graph.FillEllipse(x1 + abs(x1 - x2) div 2, y1 + abs(y1 - y2) div 2,
                     abs(x1 - x2) div 2, abs(y1 - y2) div 2);
  end;

  {----------------------------------
    Закрашивает цельную область с
    цветом равным цвету в точке (X,Y)
    и лежащий в диапазоне +/- step
   ----------------------------------}
  procedure  FillPolygon(x, y, step: Integer);
  begin
  end;

  {----------------------------------
    Рисует закрашеный прямоугольник
   ----------------------------------}
  procedure  FillRect(x1, y1, x2, y2: Integer);
  begin
    Bar(x1, y1, x2, y2);
  end;

  {----------------------------------
    Сохраняет часть изображения
    ограниченную прямоугольником R
   ----------------------------------}
  procedure  GetImage(R: PRect; var Image: PImage);
  var Width, x: Integer;
      Block,
      CurBlock: PImageBlock;
  begin
    Image:=nil;
    if not IsRect(R) then Exit;
    New(Image);
    Image^.Width:=abs(R^.A.X-R^.B.X);
    Image^.Height:=abs(R^.A.Y-R^.B.Y);
    Image^.Blocks:=nil;
    Width:=R^.B.X-R^.A.X;
    if Width > 50 then Width:=50;
    CurBlock:=nil;
    x:=R^.A.X;
    repeat
      if MaxAvail >= ImageSize(x, R^.A.Y, x+Width, R^.B.Y)+1024 then begin
        New(Block);
        Block^.Size:=ImageSize(x, R^.A.Y, x+Width, R^.B.Y);
        GetMem(Block^.Block, Block^.Size);
        Block^.Next:=nil;
        Graph.GetImage(x, R^.A.Y, x+Width, R^.B.Y, Block^.Block^);
        if CurBlock <> nil then CurBlock^.Next:=Block
                           else Image^.Blocks:=Block;
        CurBlock:=Block;
        x:=x+Width;
        Width:=R^.B.X-x;
        if Width > 50 then Width:=50;
      end else begin
        if CurBlock <> nil then CurBlock^.Next:=nil
                           else Image^.Blocks:=nil;
        DisposeImage(Image);
      end;
    until (Width <= 0) or (CurBlock = nil);
  end;

  {----------------------------------
    Возвращает цвет точки
   ----------------------------------}
  procedure  GetPixel(x, y: Integer);
  begin
    HColor:=Graph.GetPixel(x, y);
  end;

  {----------------------------------
    Восстанавливает все настройки
   ----------------------------------}
  procedure  PopStyles;
  var  ts: PStyles;
  begin
    if Styles = nil then Exit;
    LineStyle:=Styles^.LineStyle;
    FillStyle:=Styles^.FillStyle;
    TextStyle:=Styles^.TextStyle;
    SetViewWindow(@Styles^.Window);
    SetColor(Styles^.Color);
    ts:=Styles;
    Styles:=Styles^.Prev;
    Dispose(ts);
  end;

  {----------------------------------
    Сохраняет все настройки
   ----------------------------------}
  procedure  PushStyles;
  var  PS: PStyles;
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

  {----------------------------------
    Рисует ранее сохраненное
    изображение
   ----------------------------------}
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

  {----------------------------------
    Рисует точку
   ----------------------------------}
  procedure  PutPixel(x, y: Integer);
  begin
    Graph.PutPixel(x, y, HColor);
  end;

  {----------------------------------
    Устанавливает цвет для рисования
   ----------------------------------}
  procedure  SetColor(c: TColor);
  begin
    HColor:=ChooseColor(C and 255,
                       (C shr 8) and 255,
                       (C shr 16) and 255);
    Color:=C;
    Graph.SetColor(HColor);
    Graph.SetFillPattern(FillPatternType(FillStyle.Pattern), HColor);
  end;

  {----------------------------------
    Устанавливает цвет фона для
    закраски
   ----------------------------------}
  procedure  SetFillBGColor(BGColor: TColor);
  begin
    FillStyle.BGColor:=BGColor;
    Graph.SetFillPattern(FillPatternType(FillStyle.Pattern), HColor);
  end;

  {----------------------------------
    Устанавливает тип фона для
    закраски
   ----------------------------------}
  procedure  SetFillPattern(Pattern: TFillPattern);
  begin
    FillStyle.Pattern:=Pattern;
    Graph.SetFillPattern(FillPatternType(Pattern), HColor);
  end;

  {----------------------------------
    Устанавливает тип и цвет фона
    для закраски
   ----------------------------------}
  procedure  SetFillStyle(Pattern: TFillPattern; BGColor: TColor);
  begin
    SetFillPattern(Pattern);
    SetFillBGColor(BGColor);
  end;

  {----------------------------------
    Устанавливает тип линии
   ----------------------------------}
  procedure  SetLinePattern(Pattern: Word);
  begin
    Graph.SetLineStyle(UserBitLn, Pattern, LineStyle.Size);
    LineStyle.Pattern:=Pattern;
  end;

  {----------------------------------
    Устанавливает толщину линии
   ----------------------------------}
  procedure  SetLineSize(Size: Integer);
  begin
    Graph.SetLineStyle(UserBitLn, LineStyle.Pattern, Size);
    LineStyle.Size:=Size;
  end;

  {----------------------------------
    Устанавливает толщину и тип линии
   ----------------------------------}
  procedure  SetLineStyle(Pattern: Word; size: Integer);
  begin
    SetLineSize(Size);
    SetLinePattern(Pattern);
  end;

  {----------------------------------
    Устанавливает горизонтальное
    выравнивание текста
   ----------------------------------}
  procedure  SetTextHAlign(HAlign: Byte);
  begin
    TextStyle.HAlign:=HAlign;
  end;

  {----------------------------------
    Устанавливает вертикальное
    выравнивание текста
   ----------------------------------}
  procedure  SetTextVAlign(VAlign: Byte);
  begin
    TextStyle.VAlign:=VAlign;
  end;

  {----------------------------------
    Устанавливает вертикальное и
    горизонтальное выравнивание текста
   ----------------------------------}
  procedure  SetTextStyle(HAlign, VAlign: Byte);
  begin
    SetTextHAlign(HAlign);
    SetTextVAlign(VAlign);
  end;

  {----------------------------------
    Устанавливает границы экрана в
    пределах которых можно рисовать
   ----------------------------------}
  procedure  SetViewWindow(R: PRect);
  begin
    if not IsRect(R) then Exit;
    Window:=R^;
    SetViewPort(R^.A.X, R^.A.Y, R^.B.X, R^.B.Y, True);
  end;

end.