 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                           Pascal Graphics Language
                                 Version 1.0
                       Copyright (c) 2000 ShAG Studio
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   ��� ����� ᮤ�ন� ������� ����室��� ��� ࠡ��� � ����᪮� ०���.
  �� ������� ���⠭� ��� ࠡ��� � ०��� 24 ��� �� ���, �� �� ����䥩�
  c����� ⠪, �⮡� ᤥ���� ��� ����ᨬ���� �஧�筮�.
   ������ ����� ॠ�������� ��� ०���� EGA ��� VGA,  �� �� �⮬ ����䥩�
  ����� �� ���������. �� ������� 梥� ᯥ樠�쭠� ��楤�� ��⥬ ������
  �� ������� ����ࠥ� ��⨬���� 梥� ��� ��� ��������� (����, ������,
  �����) � ���� �⨬ 梥⮬, ��� �㦭�.
   �ᯮ���� ����� ����� �� ����� ����� � �⫠������ �ணࠬ�� � VGA ���
  EGA ०���, � ��⥬ ������� � ���㫥 ᮮ⢥�����騥 ������� ��।����� ��
  �ॡ㥬� ०��. �� �⮬ �� ��� �ணࠬ�� ���� ࠡ���� ⠪�� ��� � ��
  ����䨪�樨 �����, �� � ��㣮� ०���.
  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

 unit PGL;

 interface

 uses Graph;

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                               ���� ⨯� ������
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 type
     {----------------------------------
      ���          ����
      ----------------------------------}
     PColor = ^TColor;
     TColor = LongInt;

     {----------------------------------
      ���          ��窠
      ----------------------------------}
     PPoint = ^TPoint;
     TPoint = record
       X, Y       : Integer;
     end;

     {----------------------------------
      ���          ��אַ㣮�쭨�
      ----------------------------------}
     PRect = ^TRect;
     TRect = record
       A, B       : TPoint;
     end;

     {----------------------------------
      ���          ����᪠
      ----------------------------------}
     PFillPattern = ^TFillPattern;
     TFillPattern = array [0..7] of Byte;

     {----------------------------------
      ���          �⨫� �����
      ----------------------------------}
     PLineStyle = ^TLineStyle;
     TLineStyle = record
       Size,
       Pattern    : Word;
     end;

     {----------------------------------
      ���          �⨫� ����᪨
      ----------------------------------}
     PFillStyle = ^TFillStyle;
     TFillStyle = record
       BGColor    : TColor;
       Pattern    : TFillPattern;
     end;

     {----------------------------------
      ���          �⨫� ⥪��
      ----------------------------------}
     PTextStyle = ^TTextStyle;
     TTExtStyle = record
       VAlign,
       HAlign     : Byte;
     end;

     {----------------------------------
      ���          �� ��ࠬ����
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
      ���          ����� ����ࠦ����
      ----------------------------------}
     PImageBlock = ^TImageBlock;
     TImageBlock = record
       Next       : PImageBlock;
       Size       : Word;
       Block      : Pointer;
     end;

     {----------------------------------
      ���          ����ࠦ����
      ----------------------------------}
     PImage = ^TImage;
     TImage = record
      Width,
      Height      : Word;
      Blocks      : PImageBlock;
     end;



 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  ����⠭��
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 const
     {----------------------------------
                    ����
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
                ���� ����᪨
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
                  ���� �����
      ----------------------------------}
     lpSolid      = $FFFF;
     lpDotted     = $CCCC;
     lpCenter     = $FC78;
     lpDashed     = $F8F8;

     {----------------------------------
                ���騭� �����
      ----------------------------------}
     lwNormal     = $01;
     lwThick      = $03;

     {----------------------------------
          ���ᮡ� ��ࠢ������� ⥪��
      ----------------------------------}
     alLeft       = $00;
     alCenter     = $01;
     alRight      = $02;
     alTop        = $00;
     alBottom     = $02;

     {----------------------------------
           VGA ������ ��� 16 梥⮢
      ----------------------------------}
     Palette      : array [0..47] of Byte = (
                    $00, $00, $00,   $00, $00, $80,   $00, $80, $00,
                    $00, $80, $80,   $80, $00, $00,   $80, $00, $80,
                    $80, $80, $00,   $AC, $AC, $AC,   $80, $80, $80,
                    $00, $00, $FF,   $00, $FF, $00,   $00, $FF, $FF,
                    $FF, $00, $00,   $FF, $00, $FF,   $FF, $FF, $00,
                    $FF, $FF, $FF);

     {----------------------------------
        ���ᨬ��쭮� ������⢮ 梥⮢
      ----------------------------------}
     MaxColor     = $0F;



 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                ��६����
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 var
     Color        : TColor;            { ����騩 梥� ��� �ᮢ����        }
     HColor       : LongInt;           { �����᪨� 梥� - ��� �����⭮�� }
                                       { ����᪮�� ०���               }
     Window       : TRect;             { �࠭��� ���� ��� �ᮢ����        }
     LineStyle    : TLineStyle;        { �⨫� �����                       }
     FillStyle    : TFillStyle;        { �⨫� ����᪨                    }
     TextStyle    : TTextStyle;        { �⨫� ⥪��                      }
     Styles       : PStyles;           { �⥪ ��ࠬ��஢                   }



 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  �㭪樨
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
                                  ��楤���
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
   ����砥� ������ 䠩�� �ࠩ��� BGI
   ----------------------------------}
  procedure EgaVgaDriverProc; external;
  {$L EGAVGA.OBJ }

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  �㭪樨
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    ���뢠�� � ��६����� ⨯�
    ��אַ㣮�쭨� �������
    ���न����
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
    �।� 梥⮢ ������� �롨ࠥ�
    梥�, ��⨬���� ��� ��������
    ��ࠬ��஢ ��⥭ᨢ���⥩ �
    �����頥� ��� �����
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
    �����蠥� �� ���न����
    ��אַ㣮�쭨�� �� P �祪
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
    �����頥� ࠧ��� �����,
    ����室���� ��� ��࠭����
    ����ࠦ����, ��࠭�祭����
    ��אַ㣮�쭨��� R
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
    �����頥� ���ᨬ�����
    ���न���� � ��ਧ��⠫쭮�
    ���᪮��
   ----------------------------------}
  function   GetMaxX: Integer;
  begin
    GetMaxX:=Graph.GetMaxX;
  end;

  {----------------------------------
    �����頥� ���ᨬ�����
    ���न���� � ���⨪��쭮�
    ���᪮��
   ----------------------------------}
  function   GetMaxY: Integer;
  begin
    GetMaxY:=Graph.GetMaxY;
  end;

  {----------------------------------
    �����稢��� �� ���न����
    ��אַ㣮�쭨�� �� P �祪
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
    ����砥� ����᪨� ०��
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
    �����頥� True �᫨
    ��אַ㣮�쭨� �����᪨ ����
   ----------------------------------}
  function   IsRect(R: PRect): Boolean;
  begin
    IsRect:=False;
    if R = nil then exit;
    if (R^.A.X > R^.B.X) or (R^.A.Y > R^.B.Y) then Exit;
    IsRect:=True;
  end;

  {----------------------------------
    �����頥� ���ᨬ��쭮� �� ����
    楫�� �ᥫ
   ----------------------------------}
  function   MaxInt(a, b: Integer): Integer;
  begin
    if a > b then MaxInt:=a
             else MaxInt:=b;
  end;

  {----------------------------------
    �����頥� �������쭮� �� ����
    楫�� �ᥫ
   ----------------------------------}
  function   MinInt(a, b: Integer): Integer;
  begin
    if a < b then MinInt:=a
             else MinInt:=b;
  end;

  {----------------------------------
    ��६�頥� ��אַ㣮�쭨� �
    ��� P
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
    �����頥� १���� ����祭��
    ���� ��אַ㣮�쭨���
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
    �����頥� 梥� �ᯮ���� ��
    ��⥭ᨢ���� �� �室�� �����.
   ----------------------------------}
  function   RGB2Color(R, G, B: Byte): TColor;
  begin
    RGB2Color:=LongInt(R) or (LongInt(G) shl 8) or (LongInt(B) shl 16);
  end;

  {----------------------------------
    �����頥� १���� ��ꥤ������
    ���� ��אַ㣮�쭨���
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
    �����頥� ����� ��ப� text ��
    �������� �⨫� �뢮�� ⥪��
   ----------------------------------}
  function   TextHeight(text: String): Integer;
  begin
   TextHeight:=8;
  end;

  {----------------------------------
    �����頥� ����� ��ப� text ��
    �������� �⨫� �뢮�� ⥪��
   ----------------------------------}
  function   TextLength(text: String): Integer;
  begin
   TextLength:=Length(text)*8;
  end;



 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  ��楤���
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    �몫�砥� ����᪨� ०��
   ----------------------------------}
  procedure  ClosePGL;
  begin
    CloseGraph;
  end;

  {----------------------------------
    �᢮������� ������ �� ����ࠦ����
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
    ����� ������� ���
   ----------------------------------}
  procedure  DrawArc(x1, y1, x2, y2, a, b: Integer);
  begin
    Ellipse(x1 + abs(x1 - x2) div 2, y1 + abs(y1 - y2) div 2,
            a, b,
            abs(x1 - x2) div 2, abs(y1 - y2) div 2);
  end;

  {----------------------------------
    ����� ������� ������
   ----------------------------------}
  procedure  DrawEllipse(x1, y1, x2, y2: Integer);
  begin
    Ellipse(x1 + abs(x1 - x2) div 2, y1 + abs(y1 - y2) div 2,
            0, 360,
            abs(x1 - x2) div 2, abs(y1 - y2) div 2);
  end;

  {----------------------------------
    ����� �����
   ----------------------------------}
  procedure  DrawLine(x1, y1, x2, y2: Integer);
  begin
    Line(x1, y1, x2, y2);
  end;

  {----------------------------------
    ����� ������� ��אַ㣮�쭨�
   ----------------------------------}
  procedure  DrawRect(x1, y1, x2, y2: Integer);
  begin
    Rectangle(x1, y1, x2, y2);
  end;

  {----------------------------------
    ����� ⥪��
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
    ����� ����襭� ������
   ----------------------------------}
  procedure  FillEllipse(x1, y1, x2, y2: Integer);
  begin
   Graph.FillEllipse(x1 + abs(x1 - x2) div 2, y1 + abs(y1 - y2) div 2,
                     abs(x1 - x2) div 2, abs(y1 - y2) div 2);
  end;

  {----------------------------------
    ����訢��� 楫��� ������� �
    梥⮬ ࠢ�� 梥�� � �窥 (X,Y)
    � ����騩 � ��������� +/- step
   ----------------------------------}
  procedure  FillPolygon(x, y, step: Integer);
  begin
  end;

  {----------------------------------
    ����� ����襭� ��אַ㣮�쭨�
   ----------------------------------}
  procedure  FillRect(x1, y1, x2, y2: Integer);
  begin
    Bar(x1, y1, x2, y2);
  end;

  {----------------------------------
    ���࠭�� ���� ����ࠦ����
    ��࠭�祭��� ��אַ㣮�쭨��� R
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
    �����頥� 梥� �窨
   ----------------------------------}
  procedure  GetPixel(x, y: Integer);
  begin
    HColor:=Graph.GetPixel(x, y);
  end;

  {----------------------------------
    ����⠭�������� �� ����ன��
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
    ���࠭�� �� ����ன��
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
    ����� ࠭�� ��࠭�����
    ����ࠦ����
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
    ����� ���
   ----------------------------------}
  procedure  PutPixel(x, y: Integer);
  begin
    Graph.PutPixel(x, y, HColor);
  end;

  {----------------------------------
    ��⠭�������� 梥� ��� �ᮢ����
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
    ��⠭�������� 梥� 䮭� ���
    ����᪨
   ----------------------------------}
  procedure  SetFillBGColor(BGColor: TColor);
  begin
    FillStyle.BGColor:=BGColor;
    Graph.SetFillPattern(FillPatternType(FillStyle.Pattern), HColor);
  end;

  {----------------------------------
    ��⠭�������� ⨯ 䮭� ���
    ����᪨
   ----------------------------------}
  procedure  SetFillPattern(Pattern: TFillPattern);
  begin
    FillStyle.Pattern:=Pattern;
    Graph.SetFillPattern(FillPatternType(Pattern), HColor);
  end;

  {----------------------------------
    ��⠭�������� ⨯ � 梥� 䮭�
    ��� ����᪨
   ----------------------------------}
  procedure  SetFillStyle(Pattern: TFillPattern; BGColor: TColor);
  begin
    SetFillPattern(Pattern);
    SetFillBGColor(BGColor);
  end;

  {----------------------------------
    ��⠭�������� ⨯ �����
   ----------------------------------}
  procedure  SetLinePattern(Pattern: Word);
  begin
    Graph.SetLineStyle(UserBitLn, Pattern, LineStyle.Size);
    LineStyle.Pattern:=Pattern;
  end;

  {----------------------------------
    ��⠭�������� ⮫騭� �����
   ----------------------------------}
  procedure  SetLineSize(Size: Integer);
  begin
    Graph.SetLineStyle(UserBitLn, LineStyle.Pattern, Size);
    LineStyle.Size:=Size;
  end;

  {----------------------------------
    ��⠭�������� ⮫騭� � ⨯ �����
   ----------------------------------}
  procedure  SetLineStyle(Pattern: Word; size: Integer);
  begin
    SetLineSize(Size);
    SetLinePattern(Pattern);
  end;

  {----------------------------------
    ��⠭�������� ��ਧ��⠫쭮�
    ��ࠢ������� ⥪��
   ----------------------------------}
  procedure  SetTextHAlign(HAlign: Byte);
  begin
    TextStyle.HAlign:=HAlign;
  end;

  {----------------------------------
    ��⠭�������� ���⨪��쭮�
    ��ࠢ������� ⥪��
   ----------------------------------}
  procedure  SetTextVAlign(VAlign: Byte);
  begin
    TextStyle.VAlign:=VAlign;
  end;

  {----------------------------------
    ��⠭�������� ���⨪��쭮� �
    ��ਧ��⠫쭮� ��ࠢ������� ⥪��
   ----------------------------------}
  procedure  SetTextStyle(HAlign, VAlign: Byte);
  begin
    SetTextHAlign(HAlign);
    SetTextVAlign(VAlign);
  end;

  {----------------------------------
    ��⠭�������� �࠭��� ��࠭� �
    �।���� ������ ����� �ᮢ���
   ----------------------------------}
  procedure  SetViewWindow(R: PRect);
  begin
    if not IsRect(R) then Exit;
    Window:=R^;
    SetViewPort(R^.A.X, R^.A.Y, R^.B.X, R^.B.Y, True);
  end;

end.