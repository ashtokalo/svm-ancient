{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
{=========================ShAG Graphics Interface============================}
{====         ����᪨� ����䥩� �⮪��� ������ �����������.        ====}
{====                           ����� 1.0                               ====}
{====--------------------------------------------------------------------====}
{====  ����� ࠧ�蠥��� �ᯮ�짮���� ⮫쪮 � ��������᪨� 楫��, �� ====}
{==== �᫮���, �� ��室�� ⥪�� ��� �ணࠬ� ����ᠭ��� � �ᯮ�짮��- ====}
{==== ���� �⮣� ����� ������� �⮪��� ����ᥩ �����������, �� ⠪��   ====}
{==== �� �ࠢ��, ��� � ��� �����, �஬� ����祭�� ����� �ணࠬ�.      ====}
{====--------------------------------------------------------------------====}
{====  ����� ᮧ��� � Turbo Pascal 5.1                                  ====}
{====--------------------------------------------------------------------====}
{====  ����� �������� ���⠢��� �� �� ����㯭�� �� ��襩 ��������� ====}
{==== ����᪨�  ०����, ��  �⮬ � ��  ०��� �����  ࠡ�⠥� � ====}
{==== ����㠫�� ��࠭�� � ��������  ࠡ���� ��� � ०��� True Color, ====}
{==== �. �. �ᥣ�� ��������  ࠡ�� � �६�  ��⥭ᨢ����ﬨ ���  ������ ====}
{==== �窨 (����, ������, �����)                                    ====}
{====--------------------------------------------------------------------====}
{====  ����� ����᪨� ०����:                                       ====}
{====   0  - CGA ०�� 640 �� 200 �祪 � 2 䨧��᪨� 梥�             ====}
{====   1  - EGA ०�� 640 �� 350 �祪 � 16 䨧��᪨� 梥⮢           ====}
{====   2  - VGA ०�� 640 �� 480 �祪 � 16 䨧�祪�� 梥⮢           ====}
{====   3  - VGA ०�� 800 �� 600 �祪 � 16 䨧��᪨� 梥⮢           ====}
{====   4  - VGA ०�� 320 �� 200 �祪 � 256 䨧��᪨� 梥⮢          ====}
{====   5  - SVGA ०�� 640 �� 480 �祪 � 256 䨧��᪨� 梥⮢         ====}
{====   6  - SVGA ०�� 800 �� 600 �祪 � 256 䨧��᪨� 梥⮢         ====}
{====   7  - SVGA ०�� 1024 �� 768 �祪 � 256 䨧��᪨� 梥⮢        ====}
{====   8  - SVGA ०�� 1152 �� 864 �祪 � 256 䨧��᪨� 梥⮢        ====}
{====   9  - SVGA ०�� 1280 �� 1024 �祪 � 256 䨧��᪨� 梥⮢       ====}
{====   10 - ��१�ࢨ஢����                                           ====}
{====   11 - ��१�ࢨ஢����                                           ====}
{====   12 - SVGA ०�� 640 �� 480 �祪 � 16-� ���� 梥�             ====}
{====   13 - SVGA ०�� 800 �� 600 �祪 � 16-� ���� 梥�             ====}
{====   14 - SVGA ०�� 1024 �� 768 �窥� � 16-� ���� 梥�           ====}
{====   15 - SVGA ०�� 1280 �� 1024 �祪 � 16-� ���� 梥�           ====}
{====   16 - ��१�ࢨ஢����                                           ====}
{====   17 - ��१�ࢨ஢����                                           ====}
{====   18 - ��१�ࢨ஢����                                           ====}
{====   19 - SVGA ०�� 640 �� 480 �祪 � 32-� ���� 梥�              ====}
{====   20 - SVGA ०�� 800 �� 600 �祪 � 32-� ���� 梥�              ====}
{====   21 - SVGA ०�� 1024 �� 768 �窥� � 32-� ���� 梥�            ====}
{====   22 - SVGA ०�� 1280 �� 1024 �祪 � 32-� ���� 梥�            ====}
{====   23 - ��१�ࢨ஢����                                           ====}
{====   24 - ��१�ࢨ஢����                                           ====}
{====--------------------------------------------------------------------====}
{============================================================================}
{$M 16384,0,655360}
                                  UNIT SGI;
{============================================================================}
                                  INTERFACE
{=========================== ������砥�� ���㫨 ============================}

 USES Crt, Dos, AddGr, SVM_n, Colors, Diz;

{========================= ��१�ࢨ஢���� ⨯� ===========================}

 {��� ᮤ�ঠ騩 ��⮢�� ������ 16�16, ����� ������� ���ன ����� �ਭ�����
  ���祭�� 0 ��� 1}
 TYPE TTexture = ARRAY [0..7] OF Byte;

 {���  ᮤ�ঠ騩  ���ଠ��  �  梥�:   ��⥭ᨢ����  ��᭮��,  ��������,
  ᨭ���  � �����  �⮣� 梥�  ��� ०���� 2, 4, 16, 256  梥⮢, ��  ��㣨�
  ०���� ᮤ�ন� �ந������ �����}
 TYPE TColor = RECORD
  Red, Green, Blue: Byte;
 END;

 {��� ᮤ�ঠ騩 ���ଠ�� � ⨯� ���� ��� ���������� ����襭�� 䨣��}
 TYPE TFillStyle = RECORD
  Color: TColor;              {���� ���}
  BGColor: TColor;            {���� 䮭�}
  Texture: TTexture;          {��� ���� ᮤ�ন��� � ��⮢�� �����}
  TextureFill: Boolean;       {True - �ᯮ�짮���� ⥪�����, False - ���}
 END;

 {��� ᮤ�ঠ騩 ���ଠ�� � ⨯� �����}
 TYPE TLineStyle = RECORD
  Color: TColor;              {���� ���, ����� ���� �⠢����� �窨}
  Mask: Word;                 {��� ����� ᮤ�ঠ騩�� � ��⮢�� ����}
  MaskLine: Boolean;          {True - �ᯮ�짮���� ����, False - ���}
  Size: Word;                 {������ �窨, ���ன ������ �����, �窠
                              �।�⠢��� �� ᥡ� ������ � ��஭�� Size}
 END;

 {��� ᮤ�ঠ騩 ���ଠ�� � ⨯� ��誨, �ᯮ��㥬�� �� �뢮�� �����}
 TYPE TMouse = RECORD
  OffX,              {���饭�� ����ࠦ���� �����, �⭮�⥫� ���न��� ���}
  OffY,              {�� �� X � Y}
  SizeX,             {������ �뢮������ ����ࠦ����, �᫨ ��� ����� 32 �� 32}
  SizeY: ShortInt;   {�� ��� X � Y}
  Cursor: ARRAY [0..31,0..31] OF Byte; {����ࠦ���� ����� � 16 梥�� �� ��
                     ������, �᫨ ����� 梥� �窨 ����� 16, � ⠪�� �窠
                     �� �뢮����� �� ��࠭}
 END;

 TYPE PTexture = ^TTexture;
 TYPE PColor = ^TColor;
 TYPE PFillStyle = ^TFillStyle;
 TYPE PLineStyle = ^TLineStyle;
 TYPE PMouse = ^TMouse;

 {⨯ ��楤��� �뢮�� �窨}
 TYPE PPixType = PROCEDURE (x,y : Word);

 {⨯ �㭪権 �������饩 ���ଠ�� � 梥� � �������� �窥}
 TYPE GPixType = PROCEDURE (x,y : Word);

 TYPE TFon = ARRAY [0..31,0..31] OF Byte;

 TYPE TDizTable = ARRAY [0..65,0..7] OF Byte;

 TYPE TDMatrix = ARRAY [0..7,0..7] OF Byte;

{============================ ��楤��� � �㭪樨 ===========================}

 PROCEDURE  InitGI(Mode : Byte);        {��楤�� ���樠����樨 ��䨪�}

 PROCEDURE  DestroyGI;                  {��楤�� ��-���樠����樨 ��䨪�}

 PROCEDURE  PutPixel(x, y: Word);       {��楤�� �ᮢ���� �窨}

 FUNCTION   GetPixel(x, y: Word): PColor; {�㭪�� �����頥� 梥� �窨}

 PROCEDURE  SetColor(Col: TColor); {��楤�� ��⠭���� 梥� ��� �뢮�� �祪}

 PROCEDURE  SetLineStyle(LS: TLineStyle); {��楤�� ��⠭���� �⠭���⭮�� ⨯� �����}

 PROCEDURE  SetFillStyle(FS: TFillStyle); {��楤�� ��⠭��� �⠭���⭮� �������}

 PROCEDURE  SetWindow(x1, y1, x2, y2: Word); {��⠭�������� �࠭��� ��࠭�}

 PROCEDURE  Line(ax, ay, bx, by: Integer); {��楤�� �뢮�� �����}

 PROCEDURE  Rect(ax, ay, bx, by: Integer); {��楤�� �뢮�� ���⮣� ��אַ㣮�쭨��
                                         �⠭����� ��஬ � 梥⮬}

 PROCEDURE  FillRect(ax, ay, bx, by: Integer); {��楤�� �뢮�� ��אַ㣮�쭨��
                                   ����襭���� �⠭���⭮� ������ � 梥⮬}

 PROCEDURE  Ellipse(ax, ay, bx, by: Integer); {��楤�� �뢮�� ���⮣� ������
                                            �⠭����� ��஬ � 梥⮬}

 PROCEDURE  FillEllipse(ax, ay, bx, by: Integer); {��楤�� �뢮�� ������
                                   ����襭��� �⠭���⭮� ������ � 梥⮬}
 PROCEDURE  LoadColorTable;

 PROCEDURE  SaveColorTable;

 PROCEDURE  SetMouseWindow(ax, ay, bx, by: Word); {��楤�� ������ ������� ��६�饭�� ���}

 PROCEDURE  SetMouseTo(x,y: Word);                {��楤�� ��६�頥� ���� �� ���� ���न����}

 PROCEDURE  MouseRun;                             {��楤�� �ந������� ����஫� ࠡ��� ��� � �� �뢮� �� ��࠭}

 PROCEDURE  SetMouseStep(Hor, Ver: Word);         {��楤�� ��⠭�������� 蠣 ���}

 FUNCTION   MouseIn(x1,y1,x2,y2: Word): Boolean;  {�㭪�� �஢���� ���� �� ��宦����� � ��।������� ����}

 FUNCTION   MousePressed: Boolean;                {�㭪�� �஢���� �� ����⨥ �� ������ ���}

 PROCEDURE  ShowMouse;
  {��楤��� ⨯� PutPixM[n] � GetPixM[n] ����� ��楤�ࠬ� �뢮�� �窨 �
   ��楤�ࠬ�  ������ ���祭��  梥�  � �����⭮�  �窥  ���  ࠧ�����
   ����᪨�  ०����.  �����  [n] - �����  ०���,� [] - ������� ᪮���
   ���᪠���� �� ᮧ����� ����� ��楤���}

{============ �㭪樨 �뢮�� � ����� �祪 ��� ࠧ��� ०���� ===============}
 {����� 3}
 PROCEDURE  PutPixM1(x, y : Word);
 PROCEDURE  GetPixM1(x, y : Word);
 {����� 1 � 2}
 PROCEDURE  PutPixM2(x, y : Word);
 PROCEDURE  GetPixM2(x, y : Word);
 {����� 0}
 PROCEDURE  PutPixM3(x, y : Word);
 PROCEDURE  GetPixM3(x, y : Word);
 {����� 5..9}
 PROCEDURE  PutPixM5(x, y : Word);
 PROCEDURE  GetPixM5(x, y : Word);

{=========================== �������� ��६���� ==========================}
 VAR   GIErrorProc: PROCEDURE; {��楤�� �뤠� �訡��}
       GIError, GIStatus, GetMF: Boolean;
       GIErrorCode, DizR, DizG, DizB, Color_Index, GetColor_Index, GMode, Last: Byte;
       MaxX, MaxY, Lmx, Lmy, WinX1, WinX2, WinY1, WinY2, MouseX, MouseY, LastPage,
       MouseButton, MouseTotalButtons, MouseHorStep, MouseVerStep, DFonR,
       DColorR, DFonG, DColorG, DFonB, DColorB: Word; {ࠧ��� ��࠭� �� X-�� � Y-��}
       Reg : Registers;
       PutPix :Ppixtype;
       GetPix :Gpixtype;
       Color, LastColor, TempColor: TColor;     {�⠭����� 梥� ��� �ᮢ���� �祪}
       FillStyle: TFillStyle; {�⠭����� ⨯ ��� ����訢���� 䨣��}
       LineStyle: TLineStyle; {�⠭����� ⨯ ��� �ᮢ���� �����}
       MainMouse: PMouse; {�⠭���⭠� ����}
       TempPFillStyle: TFillStyle;
       TempPLineStyle: TLineStyle;
       MouseFon: TFon;
       DMatrix, LastDMatrix: TDMatrix;
       DizTable: TDizTable ABSOLUTE Diz_File; {������ ��᮪ ��� ����ਭ��}
       ColorTable: ARRAY [0..255,0..2] OF Byte ABSOLUTE Colors_File; {������ ���ᨢ���⥩}
       MemScreen: ARRAY [0..199,0..319] OF Byte ABSOLUTE $A000:0; {���� ����᪮� �����}
       BF: ARRAY [0..255] OF Byte; {���� ��� VESA 2.0}
 CONST {����⮢�� �।�⠢����� �訡��, ����� ����� ��������� � ����� ࠡ���}
       GIErrorMessage: ARRAY [0..7] OF String[80] = (
       '��� �訡��.',
       '����� �� ���樠����஢��.',
       '�訡�� �롮� �����०���.',
       '����� �����०�� �� ��⤥ন������ ��訬 ����������஬.',
       '����㠫쭠� ������ �� ���樠����஢����.',
       '��墠⠥� �����.',
       '��ꥪ� ���� ���樠����஢��.',
       '����������� �� ��⤥ন���� ����᪨� ��⮪�� SVGA VESA 2.0');

       TStep:ARRAY [0..15] OF Word = (32768,16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1);
       {�⠭����� ������ ���}
       LeftButton = 1;
       RightButton = 2;
       LeftRightButton = 3;
       {�⭠���⭠� ����}
       StdMouse: TMouse = (OffX:0; OffY:0; SizeX:12; SizeY:21; Cursor:
       ((00,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,15,15,00,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,00,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,00,00,99,00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,00,99,99,99,00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,00,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,00,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99)));

        {������ ᮮ⢥��⢨� 梥⮢}
       Diffuze: ARRAY [0..1,0..15,0..15] OF Byte = (
       (( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15),
        ( 1, 1, 3, 0, 5, 0, 8, 0, 0, 7,11, 0,13, 0,15, 0),
        ( 2, 3, 2, 0, 6, 0, 0, 0, 0,11, 0, 0,14, 0, 0, 0),
        ( 3, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 4, 5, 6, 0, 4, 0, 0, 0, 0,13,14, 0, 0, 0, 0, 0),
        ( 5, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 6, 8, 0, 0, 0, 0, 6, 0, 0, 7, 0, 0, 0, 0, 0, 0),
        ( 7, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 8, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0),
        ( 9, 0,11, 0,13, 0, 7, 0, 0, 9,11, 0,13, 0,15, 0),
        (10,11, 0, 0,14, 0, 0, 0, 0,11,10, 0,14, 0, 0, 0),
        (11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,11, 0, 0, 0, 0),
        (12,13,14, 0, 0, 0, 0, 0, 0,13,14, 0,12, 0, 0, 0),
        (13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,13, 0, 0),
        (14, 7, 0, 0, 0, 0, 0, 0, 0,15, 0, 0, 0, 0,14, 0),
        (15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,15)),
       (( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15),
        ( 1, 1, 3, 0, 5, 0, 8, 0, 0, 7, 3, 0, 5, 0,15, 0),
        ( 2, 3, 2, 0, 6, 0, 0, 0, 0, 3, 0, 0, 6, 0, 0, 0),
        ( 3, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 4, 5, 6, 0, 4, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0),
        ( 5, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 6, 8, 0, 0, 0, 0, 6, 0, 0, 7, 0, 0, 0, 0, 0, 0),
        ( 7, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 8, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0),
        ( 9, 0, 3, 0, 5, 0, 7, 0, 0, 9,11, 0,13, 0,15, 0),
        (10, 3, 0, 0, 6, 0, 0, 0, 0,11,10, 0,14, 0, 0, 0),
        (11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,11, 0, 0, 0, 0),
        (12, 5, 6, 0, 0, 0, 0, 0, 0,13,14, 0,12, 0, 0, 0),
        (13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,13, 0, 0),
        (14, 7, 0, 0, 0, 0, 0, 0, 0,15, 0, 0, 0, 0,14, 0),
        (15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,15)));

       {�⠭����� 梥�}
       Black:TColor = (Red:0; Green:0; Blue:0);
       Blue:TColor = (Red:0; Green:0; Blue:128);
       Green:TColor = (Red:0; Green:128; Blue:0);
       Cyan:TColor = (Red:0; Green:128; Blue:128);
       Red:TColor = (Red:128; Green:0; Blue:0);
       Magenta:TColor = (Red:128; Green:0; Blue:128);
       Yellow :TColor = (Red:128; Green:128; Blue:0);
       LightGray:TColor = (Red:192; Green:192; Blue:192);
       DarkGray:TColor = (Red:64; Green:64; Blue:64);
       LightBlue:TColor = (Red:0; Green:0; Blue:255);
       LightGreen:TColor = (Red:0; Green:255; Blue:0);
       LightCyan:TColor = (Red:0; Green:255; Blue:255);
       LightRed:TColor = (Red:255; Green:0; Blue:0);
       LightMagenta:TColor = (Red:255; Green:0; Blue:255);
       LightYellow:TColor = (Red:255; Green:255; Blue:0);
       White:TColor = (Red:255; Green:255; Blue:255);
       {�⠭����� ⥪�����}
       Full: TTexture = (255,255,255,255,255,255,255,255);{
       Ansi31: TTexture = (4369,8738,17476,34952,4369,8738,17476,34952,4369,8738,17476,34952,4369,8738,17476,34952);
       Ansi32: TTexture = (5140,10280,20560,41120,5140,10280,20560,41120,5140,10280,20560,41120,5140,10280,20560,41120);
       Ansi33: TTexture = (5397,10794,21588,43176,5397,10794,21588,43176,5397,10794,21588,43176,5397,10794,21588,43176);
{       Ansi34, Ansi35, Ansi36, Ansi37, Ansi38,
       Box, Brass, Brick, Clay, Cork, Cross, Dash, Dolmit, Dots, Earth,
       Escher, Flex, Grass, Grate, Hex, Honey, Hound, Insul, Lines, Mudst,       Net
       Net3, Plast, Plast1, Sacncr, Scuare, Stars, Stell, Swamp, Trans,}

{============================================================================}
                               IMPLEMENTATION
{============================================================================}

{=========== ��楤��� � �㭪樨 �ᯮ��㥬� �᭮��묨 ��楤�ࠬ� =========}

 PROCEDURE  GITempErrorProc;
 BEGIN
  {��楤�� ��뢠���� ����� ࠧ ����� ��������� �訡��, ��ࢮ��砫쭮 ���
   ��祣� ��������, �� ��  ������� �� ����� ��८�।�����}
 END;

 PROCEDURE  PixelErrorProc;
 BEGIN
  GIError:=True;
  GIErrorCode:=1;
  GIErrorProc;
 END;

 PROCEDURE  GetMouseFon;
 VAR x,y,x1,y1: Integer;
 BEGIN
  x1:=MouseX+MainMouse^.OffX;
  y1:=Mousey+MainMouse^.Offy;
  FOR y:=y1 TO y1+MainMouse^.SizeY DO
   FOR x:=x1 TO x1+MainMouse^.SizeX DO BEGIN
    GetPix(x,y);
    MouseFon[x-x1,y-y1]:=GetColor_Index;
   END;
 END;

 PROCEDURE  ShowMouse;
 VAR x,y,x1,y1,tx,ty,c: Integer;
 BEGIN
  x1:=MouseX+MainMouse^.OffX;
  y1:=Mousey+MainMouse^.Offy;
  TempColor:=Color;
  FOR y:=y1 TO y1+MainMouse^.SizeY DO
   FOR x:=x1 TO x1+MainMouse^.SizeX DO BEGIN
    ASM
     MOV ax,x
     MOV bx,x1
     SUB ax,bx
     MOV tx,ax
     MOV ax,y
     MOV bx,y1
     SUB ax,bx
     MOV ty,ax
    END;
    IF GetMF THEN BEGIN
     GetPix(x,y);
     MouseFon[tx,ty]:=GetColor_Index;
     END;
    c:=MainMouse^.Cursor[ty,tx];
    IF c < 16 THEN BEGIN
     Color_Index:=c;
     PutPix(x,y);
    END ELSE BEGIN
     Color_Index:=MouseFon[tx,ty];
     PutPix(x,y);
    END;
   END;
  GetMF:=False;
  Color:=TempColor;
 END;

 PROCEDURE  ShowMouseFon;
 VAR x,y,x1,y1: Integer;
 BEGIN
  x1:=LmX+MainMouse^.OffX;
  y1:=LmY+MainMouse^.Offy;
  TempColor:=Color;
  FOR y:=y1 TO y1+MainMouse^.SizeY DO
   FOR x:=x1 TO x1+MainMouse^.SizeX DO BEGIN
    Color_Index:=MouseFon[x-x1,y-y1];
    PutPix(x,y);
   END;
  Color:=TempColor;
 END;

{=========================== �᭮��� ��楤��� =============================}

 PROCEDURE  InitGI(Mode : Byte);
 VAR r1, r2, r3: Word;
 BEGIN
   {���樠������ ��誨}
   ASM
    MOV AX,0
    INT $33
    MOV MouseTotalButtons, BX
   END;
   CASE Mode OF
    0:BEGIN
       MaxX:=640;
       MaxY:=200;
       {����砥� ����᪨� ०�� CGA 640 �� 200 �� 2 梥�}
       Reg.ah:=0;
       Reg.al:=$6;
       Intr($10, Reg);
       @PutPix:=@PutPixM3;
       @GetPix:=@GetPixM3;
      END;
    1:BEGIN
       MaxX:=640;
       MaxY:=350;
       {����砥� ����᪨� ०�� EGA 640 �� 350 � �� 16 梥⮢}
       Init;
       Reg.ah:=0;
       Reg.al:=$10;
       Intr($10, Reg);
       @PutPix:=@PutPixM2;
       @GetPix:=@GetPixM2;
      END;
    2:BEGIN
       MaxX:=640;
       MaxY:=480;
       {����砥� ����᪨� ०�� VGA 640 �� 480 �� 16 梥⮢}
       Init;
       Reg.ah:=0;
       Reg.al:=$12;
       Intr($10, Reg);
       @PutPix:=@PutPixM2;
       @GetPix:=@GetPixM2;
      END;
    4:BEGIN
       MaxX:=320;
       MaxY:=200;
       {����砥� ����᪨� ०�� VGA 320 �� 200 � 256 梥⮢}
       Reg.ah:=0;
       Reg.al:=$13;
       Intr($10, Reg);
       @PutPix:=@PutPixM1;
       @GetPix:=@GetPixM1;
      END;
    5..9: BEGIN
       CASE Mode OF
        5: r1:=$101;
        6: r1:=$103;
        7: r1:=$105;
        8: r1:=$107;
        9: r1:=$109;
       END;
       LastPage:=0;
       r2:=Seg(BF);
       r3:=Ofs(BF[0]);
       ASM
        MOV AX, $4F02
        MOV BX, r1
        INT $10
        MOV AX, $4F01
        MOV CX, r1
        MOV ES, r2
        MOV DI, r3
        INT $10
       END;
       IF MemW[r2:r3+4]=0 THEN MemW[r2:r3+4]:=1;
       Last:=MemW[r2:r3+6] div MemW[r2:r3+4];
       MaxX:=MemW[r2:r3+$12];
       MaxY:=MemW[r2:r3+$14];
       IF (MaxX = 0) OR (MaxY = 0) THEN BEGIN
        WriteLn('�訡��: '+GIErrorMessage[7]);
        Halt(0);
       END;
       @PutPix:=@PutPixM5;
       @GetPix:=@GetPixM5;
      END;
    ELSE BEGIN
     {�訡��, ���ࠢ���� �����०��}
     GIStatus:=False;
     GIError:=True;
     GIErrorCode:=2;
     GIErrorProc;
    END;
   END;
   GIStatus:=True;
   SaveColorTable;
   SetMouseWindow(0,0,MaxX-1,MaxY-1);
   SetMouseTo(MaxX DIV 2 - 1, MaxY DIV 2 - 1);
   MouseButton:=0;
   GetMF:=True;
   WinX1:=0; WinX2:=MaxX - 1;
   WinY1:=0; WinY2:=MaxY - 1;
   ShowMouse;
   GIError:=False;
   GIErrorCode:=0;
 END;

{======================================}

 PROCEDURE  DestroyGI;
 BEGIN
  IF GIStatus THEN BEGIN
   {����砥� ⥪�⮢� ०��}
   Reg.ah:=0;
   Reg.al:=$3;
   Intr($10, Reg);
  END ELSE BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIerrorProc;
  END;
 END;

{======================================}

 PROCEDURE  PutPixM1(x, y : Word);
 VAR b:Byte;
 BEGIN
  b:=Color_Index;
   ASM
    MOV cx, x
    CMP cx, WinX1
    JL  @exit
    CMP cx, WinX2
    JG  @exit
    MOV cx, y
    CMP cx, WinY1
    JL  @exit
    CMP cx, WinY2
    JG  @exit

    mov  ax,$A000
    mov  es,ax          {es = $A000}
    mov  ax,y
    mov  bx,320         {ax=y*320}
    mul  bx
    mov  bx,x           {bx=ax+x}
    add  bx,ax
    mov  al,b
    mov  es:[bx],al
   @exit:
   END;
 END;
{======================================}

 PROCEDURE  GetPixM1(x,y : Word);
 VAR b:Byte;
 BEGIN
   ASM
    mov  b,0
    cmp  x, 0
    jl  @exit
    cmp  y, 0
    jl  @exit
    mov  ax, MaxX
    cmp  ax, x
    jng  @exit
    mov  ax, MaxY
    cmp  ax, y
    jng  @exit

    mov  ax,$A000
    mov  es,ax          {es = $A000}
    mov  ax,y
    mov  bx,320         {ax=y*320}
    mul  bx
    mov  bx,x           {bx=ax+x}
    add  bx,ax
    mov  al,es:[bx]
    mov  b,al
   @exit:
   END;
  GetColor_Index:=b;
 END;

{======================================}

 PROCEDURE  PutPixM2(x, y: Word);
 VAR b,bb:Byte;
     w:Word;
 BEGIN
   b:=Color_Index;
   bb:=128 SHR (x MOD 8);
   ASM
    MOV cx, x
    CMP cx, WinX1
    JL  @exit
    CMP cx, WinX2
    JG  @exit

    MOV cx, y
    CMP cx, WinY1
    JL  @exit
    CMP cx, WinY2
    JG  @exit

    {����塞 ���� ���� � ����������}
    MOV  ax, $A000
    MOV  es, ax          {es = $A000}
    MOV  ax, y
    MOV  bx, 80
    MUL  bx
    MOV  cx, ax
    MOV  ax, x
    MOV  bx, 8
    DIV  bx
    MOV  bx, cx
    ADD  bx, ax
    {��⠭�������� ०�� ����� 2}
    MOV  dx, $3CE
    MOV  al, 5
    OUT  dx, al
    INC  dx
    MOV  al, 2
    OUT  dx, al
    DEC  dx
    {����蠥� �������� ⮫쪮 ���� ᨬ����}
    MOV  al, 8
    OUT  dx, al
    INC  dx
    MOV  al, bb          {����襭� ���� ᨬ����}
    OUT  dx, al
    {�뢮��� ᨬ���}
    MOV  al, es:[bx]
    MOV  al, b
    MOV  es:[bx], al
    @exit:
   END;
 END;

{======================================}

 PROCEDURE  GetPixM2(x,y : Word);
 BEGIN
  GetColor_Index:=GPix(x,y);
 END;

{======================================}

 PROCEDURE  PutPixM3(x, y : Word);
 VAR b:Word;
     tb:Byte;
 BEGIN
  IF (x < MaxX) AND (y < MaxY) THEN
   IF Color_index=0 THEN BEGIN
    b:=(y DIV 2)*80+Ord(Odd(y))*$2000 + x DIV 8;
    tb:=Mem[$B800:b];
    Mem[$B800:b]:=tb XOR (tb AND TStep[7-x MOD 8]);
   END ELSE BEGIN
    b:=(y DIV 2)*80+Ord(Odd(y))*$2000 + x DIV 8;
    Mem[$B800:b]:=Mem[$B800:b] OR TStep[7-x MOD 8];
   END;
 END;

{======================================}

 PROCEDURE  GetPixM3(x,y : Word);
 BEGIN
  IF (X < MaxX) AND (Y < MaxY) THEN
   GetColor_Index:=Mem[$B800:(y DIV 2)*80+Ord(Odd(y))*$2000 + x DIV 8]
                       AND TStep[7-x MOD 8] ELSE GetColor_Index:=0;
 END;

{======================================}

 PROCEDURE  PutPixM5(x, y : Word);
 VAR o: LongInt;
     VPage: Word;
 BEGIN
  o:=y*MaxX+x;
  VPage:=o DIV 65536;
  VPage:=VPage*Last;
  IF LastPage <> VPage THEN BEGIN
   ASM
    MOV AH, $4F
    MOV AL, $05
    MOV BX, 0
    MOV DX, VPage
    INT $10
   END;
   LastPage:=Vpage;
  END;
  Mem[$A000:o MOD 65536]:=Color_Index;
 END;

{======================================}

 PROCEDURE  GetPixM5(x,y : Word);
 VAR o: LongInt;
     VPage: Word;
 BEGIN
  o:=y*MaxX+x;
  VPage:=o DIV 65536;
  VPage:=VPage*Last;
  IF LastPage <> VPage THEN BEGIN
   ASM
    MOV AH, $4F
    MOV AL, $05
    MOV BX, 0
    MOV DX, VPage
    INT $10
   END;
   LastPage:=Vpage;
  END;
  GetColor_Index:=Mem[$A000:o MOD 65536];
 END;

{======================================}

 PROCEDURE  PutPixel(x, y: Word);
 LABEL exitt,elsee,doo;
 VAR   t,t1,t2,t3,t4,t5,t6,x1,y1: Word;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� �� �� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  x1:=x MOD 8;
  y1:=y MOD 8;
  t:=1 SHL x1;
  DMatrix[x1,y1]:=0;
  t1:=(x1 MOD 2) XOR (y1 MOD 2);
  IF DizTable[DizR,y1] AND t <> t THEN DMatrix[x1,y1]:=DColorR
     ELSE DMatrix[x1,y1]:=DFonR;
  IF DizTable[DizG,y1] AND t <> t THEN DMatrix[x1,y1]:=Diffuze[t1,DMatrix[x1,y1],DColorG]
     ELSE DMatrix[x1,y1]:=Diffuze[t1,DFonG,DMatrix[x1,y1]];
  IF DizTable[DizB,y1] AND t <> t THEN DMatrix[x1,y1]:=Diffuze[t1,DColorB,DMatrix[x1,y1]]
     ELSE DMatrix[x1,y1]:=Diffuze[t1,DFonB,DMatrix[x1,y1]];
  Color_Index:=DMatrix[x1,y1];
  t1:=MainMouse^.Offx;
  t2:=MainMouse^.SizeX;
  t3:=MainMouse^.Offy;
  t4:=MainMouse^.SizeY;
  ASM           {�஢�ઠ �� ��宦����� � �।���� ���� � ��� �।���� ���}
   MOV bx, t2
   ADD bx, t1
   MOV t2, bx
   MOV bx, t4
   ADD bx, t3
   MOV t4, bx

   MOV bx, t1
   ADD bx, MouseX
   CMP x, bx
   JL  elsee
   MOV bx, t2
   ADD bx, MouseX
   CMP x, bx
   JG  elsee

   MOV bx, t3
   ADD bx, MouseY
   CMP y, bx
   JL  elsee
   MOV bx, t4
   ADD bx, MouseY
   CMP y, bx
   JG  elsee
   MOV ax, x
   SUB ax, MouseX
   SUB ax, t1
   MOV t5, ax
   MOV ax, y
   SUB ax, MouseY
   SUB ax, t3
   MOV t6, ax
  END;
   MouseFon[t5, t6]:=Color_Index;
   IF MainMouse^.Cursor[t6, t5] > 15 THEN PutPix(x,y);
  GOTO exitt;
  elsee:
   PutPix(x,y);
  exitt:
 END;

{======================================}

 FUNCTION   GetPixel(x, y: Word): PColor;
 LABEL exitt;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� �� �� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIerrorProc;
   Exit;
  END;
  ASM
   MOV cx, x
   CMP cx, WinX1
   JL  exitt
   CMP cx, WinX2
   JG  exitt

   MOV cx, y
   CMP cx, WinY1
   JL  exitt
   CMP cx, WinY2
   JG  exitt
  END;
  IF (x >= MouseX+MainMouse^.Offx) AND (x <= MouseX+MainMouse^.Offx+MainMouse^.SizeX) AND
   (y >= MouseY+MainMouse^.Offy) AND (y <= MouseY+MainMouse^.Offy+MainMouse^.SizeY) THEN BEGIN
    GetPixel^.Red:=ColorTable[MouseFon[x-MouseX-MainMouse^.Offx,y-MouseY-MainMouse^.Offy],0];
    GetPixel^.Green:=ColorTable[MouseFon[x-MouseX-MainMouse^.Offx,y-MouseY-MainMouse^.Offy],1];
    GetPixel^.Blue:=ColorTable[MouseFon[x-MouseX-MainMouse^.Offx,y-MouseY-MainMouse^.Offy],2];
  END ELSE BEGIN
   GetPix(x,y);
   GetPixel^.Red:=ColorTable[GetColor_Index,0];
   GetPixel^.Green:=ColorTable[GetColor_Index,1];
   GetPixel^.Blue:=ColorTable[GetColor_Index,2];
  END;
  exitt:
 END;

{======================================}

 PROCEDURE  SetColor(Col: TColor);
 VAR    x, y, t, t1: Byte;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  {�஢�ઠ �� ᮢ������� � �।��騬 梥⮬}
  IF (Col.Red = LastColor.Red) AND
     (Col.Green = LastColor.Green) AND
     (Col.Blue = LastColor.Blue) THEN BEGIN
     DMatrix:=LastDMatrix;
     Exit;
     END;
  Color:=Col;
  IF Col.Green+Col.Blue > 256 THEN BEGIN
   DizR:=(64*Col.Red) DIV 255;
   DFonR:=0;
   DColorR:=12;
  END ELSE BEGIN
   DizR:=(128*Col.Red) DIV 255;
   t:=Col.Red DIV 129;
   Dec(DizR,64*t);
   DFonR:=4*t;
   DColorR:=4+8*t;
  END;
  IF Col.Red+Col.Blue > 256 THEN BEGIN
   DizG:=(64*Col.Green) DIV 255;
   DFonG:=0;
   DColorG:=10;
  END ELSE BEGIN
   t:=Col.Green DIV 129;
   DizG:=(128*Col.Green) DIV 255;
   Dec(DizG,64*t);
   DFonG:=2*t;
   DColorG:=2+8*t;
  END;
  IF Col.Red+Col.Green > 256 THEN BEGIN
   DizB:=(64*Col.Blue) DIV 255;
   DFonB:=0;
   DColorB:=9;
  END ELSE BEGIN
   t:=Col.Blue DIV 129;
   DizB:=(128*Col.Blue) DIV 255;
   Dec(DizB,64*t);
   DFonB:=t;
   DColorB:=1+8*t;
  END;
  IF (Col.Red = Col.Green) AND (Col.Red = Col.Blue) THEN BEGIN
   CASE Col.Red OF
   0..64:
    BEGIN
     DizR:=Col.Red;
     DFonR:=0;
     DColorR:=8;
    END;
   65..192:
    BEGIN
     DizR:=(128*(Col.Red-64)) DIV 255;
     DFonR:=8;
     DColorR:=7;
    END;
   193..255:
    BEGIN
     DizR:=Col.Red-192;
     DFonR:=7;
     DColorR:=15;
    END;
   END;
   ASM
    MOV DColorG, 0
    MOV DFonG, 0
    MOV DizG, 0
    MOV DColorB, 0
    MOV DFonB, 0
    MOV DizB, 0
   END;
  END;
  ASM
   CMP Col.Red, 0
   JNE @Gr
   MOV DColorR, 0
   MOV DFonR, 0
   MOV DizR, 0
   @Gr:
   CMP Col.Green, 0
   JNE @Bl
   MOV DColorG, 0
   MOV DFonG, 0
   MOV DizG, 0
   @Bl:
   CMP Col.Blue, 0
   JNE @Next
   MOV DColorB, 0
   MOV DFonB, 0
   MOV DizB, 0
   @Next:
  END;
  LastColor:=Color;
  LastDMatrix:=DMatrix;
 END;

{======================================}

 PROCEDURE  SetLineStyle(LS: TLineStyle);
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  LineStyle:=LS;
 END;

{======================================}

 PROCEDURE  SetFillStyle(FS: TFillStyle);
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  FillStyle:=FS;
 END;
{======================================}

 PROCEDURE  Line(ax, ay, bx, by: Integer);
 VAR l, l1: Integer;
  PROCEDURE Pixels(x1,y1: Integer);
  VAR x,y: Integer;
  BEGIN
   FOR x:=x1-l TO x1+l1 DO
    FOR y:=y1-l TO y1+l1 DO PutPixel(x, y);
  END;
  PROCEDURE LLine(x1, y1, x2, y2: Integer);
  VAR tx, ty: Integer;
  BEGIN
   tx:=(x1+x2) DIV 2;
   ty:=(y1+y2) DIV 2;
   IF ((x2-x1) DIV 2 <> 0) OR ((y2-y1) DIV 2 <> 0) THEN BEGIN
    PixelS(tx,ty);
    LLine(x1,y1,tx,ty);
    LLine(tx,ty,x2,y2);
   END;
  END;
 BEGIN
  TempColor:=Color;
  SetColor(LineStyle.Color);
  l:=(LineStyle.Size-1) DIV 2;
  l1:=(LineStyle.Size-1) - l;
  PixelS(ax,ay);
  PixelS(bx,by);
  LLine(ax,ay,bx,by);
  SetColor(TempColor);
 END;

{======================================}

 PROCEDURE  Rect(ax, ay, bx, by: Integer);
 VAR x,y,l,l1,x1,y1:Word;
 BEGIN
{  l:=(LineStyle.Size-1) DIV 2;
  l1:=(LineStyle.Size-1) - l;}
  TempColor:=Color;
  SetColor(LineStyle.Color);
  FOR x:=ax TO bx DO BEGIN
   {FOR x1:=x-l TO x+l1 DO
    FOR y1:=ay-l TO ay+l1 DO PutPixel(x1, y1);
   FOR x1:=x-l TO x+l1 DO
    FOR y1:=by-l TO by+l1 DO PutPixel(x1, y1);}
   PutPixel(x, ay);
   PutPixel(x, by);
  END;
  FOR y:=ay TO by DO BEGIN
{   FOR x1:=ax-l TO ax+l1 DO
    FOR y1:=y-l TO y+l1 DO PutPixel(x1, y1);
   FOR x1:=bx-l TO bx+l1 DO
    FOR y1:=y-l TO y+l1 DO PutPixel(x1, y1);}
   PutPixel(ax, y);
   PutPixel(bx, y);
  END;
  SetColor(TempColor);
 END;

{======================================}

 PROCEDURE  FillRect(ax, ay,bx, by: Integer);
 VAR x,y:Word;
 BEGIN
  TempColor:=Color;
  SetColor(FillStyle.Color);
  FOR x:=ax TO bx DO
   FOR y:=ay TO by DO {IF (FillStyle.Texture[y MOD 8] AND TStep[x MOD 8] = TStep[x MOD 8]) OR NOT FillStyle.TextureFill
    THEN} PutPixel(x,y);
{  SetColor(FillStyle.BGColor);
  IF FillStyle.TextureFill THEN
  FOR x:=ax TO bx DO
   FOR y:=ay TO by DO IF (FillStyle.Texture[y MOD 8] AND TStep[x MOD 8] <> TStep[x MOD 8])
    THEN PutPixel(x,y);}
  SetColor(TempColor);
 END;

{======================================}

 PROCEDURE  Ellipse(ax, ay, bx, by: Integer);
 VAR rx,ry,centerx,centery,n,x1,y1,i,x,y,l,l1:Word;
 BEGIN
  TempColor:=Color;
  SetColor(LineStyle.Color);
  rx:=(bx-ax) DIV 2;
  ry:=(by-ay) DIV 2;
  centerx:=ax+rx;
  centery:=ay+ry;
  n:=(ry+rx)*4;
{  l:=(LineStyle.Size-1) DIV 2;
  l1:=(LineStyle.Size-1) - l;}
  FOR i:=0 TO n DO BEGIN
   x:=trunc(centerx+rx*sin(2*pi*i/(n+0.01)));
   y:=trunc(centery+ry*cos(2*pi*i/(n+0.01)));
{   FOR x1:=x-l TO x+l1 DO
    FOR y1:=y-l TO y+l1 DO PutPixel(x1,y1);}
   PutPixel(x,y);
  END;
  SetColor(TempColor);
 END;

{======================================}

 PROCEDURE  FillEllipse(ax, ay, bx, by: Integer);
 VAR rx,ry,centerx,centery,n,x,y,i,tx:Integer;
 BEGIN
  TempColor:=Color;
  rx:=(bx-ax) DIV 2;
  ry:=(by-ay) DIV 2;
  centerx:=ax+rx;
  centery:=ay+ry;
  n:=(ry+rx)*4;
  SetColor(FillStyle.Color);
  FOR i:=0 TO n DO BEGIN
   tx:=trunc(rx*sin(2*pi*i/(n+0.01)));
   y:=trunc(centery+ry*cos(2*pi*i/(n+0.01)));
   FOR x:=centerx-tx TO centerx+tx DO
{    IF (FillStyle.Texture[y MOD 8] AND TStep[x MOD 8] = TStep[x MOD 8]) OR NOT FillStyle.TextureFill
     THEN} PutPixel(x,y);
  END;
{  SetColor(FillStyle.BGColor);
  IF FillStyle.TextureFill THEN
  FOR i:=0 TO n DO BEGIN
   tx:=trunc(rx*sin(2*pi*i/n));
   y:=trunc(centery+ry*cos(2*pi*i/n));
   FOR x:=centerx-tx TO centerx+tx DO
    IF FillStyle.Texture[y MOD 8] AND TStep[x MOD 8] <> TStep[x MOD 8]
     THEN PutPixel(x,y);
  END;}
  SetColor(TempColor);
 END;

{======================================}

 PROCEDURE  SaveColorTable;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  Reg.ax:=Seg(ColorTable);
  Reg.es:=Reg.ax;
  Reg.ah:=$10;
  Reg.al:=$12;
  Reg.dx:=Ofs(ColorTable);
  Reg.bx:=0;
  Reg.cx:=256;
  Intr($10,Reg);
 END;

{======================================}

 PROCEDURE  LoadColorTable;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  Reg.ax:=Seg(ColorTable);
  Reg.es:=Reg.ax;
  Reg.dx:=Ofs(ColorTable);
  Reg.ah:=$10;
  Reg.al:=$17;
  Reg.bx:=0;
  Reg.cx:=256;
  Intr($10,Reg);
 END;

{======================================}

 PROCEDURE  SetWindow(x1, y1,x2, y2:Word);
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  WinX1:=x1; WinX2:=x2;
  WinY1:=y1; WinY2:=y2;
 END;

{======================================}

 PROCEDURE  SetMouseWindow(ax, ay, bx, by: Word);
 VAR tx,tx1:Word;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  tx:=ax;
  tx1:=bx;
   ASM  {������� ������ ��६�饭�� ���}
    MOV AX, 7
    MOV CX, tx
    MOV DX, tx1
    INT $33
    MOV AX, 8
    MOV CX, ay
    MOV DX, by
    INT $33
   END;
 END;

{======================================}

 PROCEDURE  SetMouseTo(x,y: Word);
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  ASM  {��⠭���� ��� � ��।������� ���� ��࠭�}
   MOV AX,4
   MOV CX,x
   MOV DX,y
   INT $33
  END;
  MouseX:=x;
  MouseY:=y;
 END;

{======================================}

 PROCEDURE   MouseRun;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
   GetMF:=True;
   ASM
    MOV ax,3
    INT $33
    CMP bx,0   {�஢�ઠ �� ��������� ������}
    JE  @next
    MOV MouseButton,bx
    @next:
    MOV ax, MouseX {�஢�ઠ �� ��������� ��������� ���}
    CMP ax,cx
    JNE @begin
    MOV ax, MouseY
    CMP ax,dx
    JE  @exit
    @begin:
    MOV ax,MouseX
    MOV Lmx,ax
    MOV ax,MouseY
    MOV Lmy,ax
    MOV MouseX,cx
    MOV MouseY,dx
    CALL [ShowMouseFon] {���⠭�������� ���� 䮭 ���}
    CALL [ShowMouse]    {���㥬 ����� ���}
    @exit:
   END;
   GetMF:=False;
 END;

{======================================}

 PROCEDURE  SetMouseStep(Hor, Ver: Word);
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  WITH Reg DO BEGIN
   ax := $0F;
   cx := Hor AND $7FFF;
   dx := Ver AND $7FFF;
   MouseHorStep := cx;
   MouseVerStep := dx;
   Intr($33,Reg)
  END;
 END;

{======================================}

 FUNCTION   MouseIn(x1,y1,x2,y2: Word): Boolean;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  WITH Reg DO BEGIN
   ax := $3;
   Intr($33,Reg);
   MouseIn:=(cx>=x1) AND (cx<=x2) AND (dx>=Y1) AND (dx<=Y2);
  END;
 END;

{======================================}

 FUNCTION   MousePressed: Boolean;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {�訡��, ����᪨� ०�� ���� ���樠����஢��}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  WITH Reg DO BEGIN
   ax := $3;
   Intr($33,Reg);
   MousePressed:=bx<>0;
  END;
 END;

{============================================================================}
BEGIN
 @GIErrorProc:=@GITempErrorProc;
 GetMF:=True;
 New(MainMouse);
 SetColor(White);
 SetMouseStep(8,8);
 LineStyle.Color:=White;
 LineStyle.Mask:=$FFFF;
 LineStyle.Size:=1;
 LineStyle.MaskLine:=False;
 FillStyle.Color:=White;
 FillStyle.BGColor:=White;
 FillStyle.Texture:=Full;
 FillStyle.TextureFill:=False;
 MainMouse^:=StdMouse;
 GIStatus:=False;
 @GIErrorProc:=@GITempErrorProc;
 GIError:=True;
 GIErrorCode:=1;
 @PutPix:=@PixelErrorProc;
 @GetPix:=@PixelErrorProc;
END.
{============================================================================}