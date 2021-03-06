{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
{============================ShAG Font Interface=============================}
{====      ��⤥প� ������� ���⮢ �⮪��� ������ �����������.     ====}
{====                           ����� 1.0                               ====}
{====--------------------------------------------------------------------====}
{====  ����� ࠧ�蠥��� �ᯮ�짮���� ⮫쪮 � ��������᪨� 楫��, �� ====}
{==== �᫮���, �� ��室�� ⥪�� ��� �ணࠬ� ����ᠭ��� � �ᯮ�짮��- ====}
{==== ���� �⮣� ����� ������� �⮪��� ����ᥩ �����������, �� ⠪��   ====}
{==== �� �ࠢ��, ��� � ��� �����, �஬� ����祭�� ����� �ணࠬ�.      ====}
{====--------------------------------------------------------------------====}
{====  ����� ᮧ��� � Turbo Pascal 7.0                                  ====}
{====--------------------------------------------------------------------====}
{====  �������  ����� �����, �. �. ����� 1.0 ��⤥ন���� ������ ====}
{==== ����� �ଠ� CHR, �  ���쭥�襬 ����������  ��⤥প� ������� ====}
{==== ���⮢ �ଠ� TTF, SFF, �� �⮬ ������� ��� ࠡ��� � ⥪�⮬ �� ====}
{==== ��������� � ࠭�� ����ᠭ�� �ணࠬ�� �� ���� �㤥� ��।��뢠��. ====}
{====  �஬� ⮣�  ����� �����  ���� �ਬ�஬  �ᯮ�짮����� ����� ====}
{==== ����᪮�� ����䥩�(SGI) � ����䥩� ����㠫쭮� �����(SVM). ====}
{====--------------------------------------------------------------------====}
{==== ������� ᢥ����� ��� ࠡ��� � ���⠬�:                         ====}
{====  � ��� �ᯮ�짮����� ����� ���  ���� �ந��樠����஢��� �������� ====}
{====    InitFI ��ࠬ��஬ ���ன ����  ��������� ������ � ��� ====}
{====    �� ���� ��� �ࠢ��쭮�� ��।������ ࠧ��� ������ �㭪�.     ====}
{====  � ������ ����  �������� �  �㭪��, ���  �㭪⮬  ���� 1/72 ====}
{====    ��,  ⠪�� ���室  �������� �뢮���  ��������� ���⮬  �� ====}
{====    ������� � ࠧ��� ���������� � � ࠧ����� ����᪨� ०���� ====}
{====    ����� ��।������� ��⮬���᪨.                             ====}
{============================================================================}
{$M 16384,0,655360}
                                  UNIT SFI;
{============================================================================}
                                  INTERFACE
{=========================== ������砥�� ���㫨 ============================}

 USES SVM_n, SGI, Dos;

{========================= ��१�ࢨ஢���� ⨯� ===========================}

 {��� �࠭�騩 ���ଠ�� � ����}
 TYPE TFont = RECORD     {������ ⨯� TFont ࠢ�� 128 ����}
      Data: OVector;     {����}
      Name: String[92];  {��� ����}
      Height,            {�����⥫� �����}
      Width: Real;       {� ������ ����}
      BaseLine,          {������� ����� - ����� �� ���ன ��ࠢ�������� ������ �࠭�� ᨬ����� (�� ���� ᭨�����)}
      Ascent,            {���ꥬ - ���ﭨ� �� ������� ����� �� ���孥� �窨 ᨬ����}
      Descent,           {�������� - ���ﭨ� �� ������� ����� �� ������ �窨 ᨬ����}
      Mode,              {��� ����}
      Bold,              {����� ��୮��}
      Italic,            {����� ���ᨢ�}
      StrikeLine,        {����� ���ન����}
      UnderLine:ShortInt;{����� ����ન�����}
      Color: TColor;     {���� ⥪��}
 END;

 {�����⥫� �� ⨯ ����}
 TYPE PFont = ^TFont;

 CONST {����⮢�� �।�⠢����� �訡��, ����� ����� ��������� � ����� ࠡ���}
       FIErrorMessage: ARRAY [0..8] OF String[60] = (
       '��� �訡��.',
       '����� �� ���樠����஢��.',
       '���������� ������ 䠩� ᮤ�ঠ騩 ����.',
       '����� ⨯ ���� �� ��⤥ন������ ��� 䠩� �� ���� ���⮬.',
       '�訡�� � ��������� ����.',
       '���� �� ���樠����஢��.',
       '��墠⠥� ����� ��� ����㧪� ����.',
       '����㠫쭠� ������ �� ���樠����஢����.',
       '�訡�� �� ࠡ�� � �������.');
       {�⠭����� ��।������}
       Bold: Byte = 1;
       DBold: Byte = 2;
       Italic: ShortInt = 20;
       IItalic: ShortInt = -20;
       UnderLine: Byte = 1;
       UnderLine2: Byte = 2;
       UnderLine3: Byte = 3;
       UnderLine4: Byte = 4;
       UnderLine5: Byte = 5;
       StrikeLine: Byte = 1;
       NoBold: Byte = 0;
       NoItalic: ShortInt = 0;
       NoUnderLine: Byte = 0;
       NoStrikeLine: Byte = 0;
       i11: Real = 11;
       i14: Real = 14;
       i15: Real = 15;
       i17: Real = 17;
       i19: Real = 19;
       i20: Real = 20;
       i21: Real = 21;
{============================ ��楤��� � �㭪樨 ===========================}

 PROCEDURE  InitFI(d: Real);
  {��⠭�������� ࠧ��� ��࠭� �� ��������� � ���}

 PROCEDURE  RegisterFontFile(fn: String; VAR fff: TFont);
  {����㦠�� ���� �� 䠩�� fn � ��६����� ⨯� TFont}

 PROCEDURE  RegisterFontRAM(VAR fn; size: LongInt; VAR fff: TFont);
  {����㦠�� ���� �� ��६����� fn � ��६����� ⨯� TFont}

 PROCEDURE  CloseFont(VAR f: TFont);
  {�᢮������� ������ ���������� ���⮬}

 PROCEDURE  SetFontSize(Sz: Word; VAR f: TFont);
  {��⠭�������� ����� ���� � �㭪��}

 PROCEDURE  DrawChar(x1, y1: Word; c: Char; f: TFont);
  {�뢮��� ᨬ��� C ���⮬ f, �� ���न��⠬ x1, y1}

 PROCEDURE  DrawString(x1, y1: Word; s: String; f: TFont);
  {�뢮��� ��ப� s ���⮬ f, �� ���न��⠬ x1, y1}

 FUNCTION   GetStringLength(s: String; f: TFont): Word;
  {�����頥� ������ ��ப� � �窠�, �᫨ �� � �뫠 ���ᮢ���� ���⮬ f}

 FUNCTION   PunctsToPixel(p: Word): Word; {��ॢ���� �㭪�� � �窨}

 FUNCTION   PixelToPuncts(p: Word): Word; {��ॢ���� �窨 � �㭪��}

{=========================== �������� ��६���� ==========================}

 VAR        FIErrorProc:  PROCEDURE;{��楤�� �뤠� �訡��}
            FIError, FIStatus: Boolean;
            FIErrorCode: Byte;
            Diagonal: Real; {Diagonal - ��������� ��࠭� � ���}
            ResolutionX, ResolutionY: Integer;
             {ResolutionX - ࠧ�襭�� ��࠭�, �祪 �� � �� �� X
              ResolutionY - ࠧ�襭�� ��࠭�, �祪 �� � �� �� Y}
            ItemSizeX, ItemSizeY: Real; {�祪 �� ���� �㭪�, 1 �㭪� = 1/72 ��}
{============================================================================}
                               IMPLEMENTATION
{============================================================================}

 {��楤�� �����稢��� ���न���� �� 㣮� ang}
 PROCEDURE  Coor(ang: Integer; x,y: Integer; VAR xx, yy: Integer);
 VAR r,a,an: Single;
 BEGIN
  an:=(270-ang)/180*pi;
  r:=Sqrt(1.0*x*x+1.0*y*y);
  IF x = 0 THEN IF y < 0 THEN a:=-pi/2 ELSE a:=pi/2 ELSE a:=arctan(y/x);
  a:=a+an;
  xx:=(Round(r*sin(a)));
  yy:=(Round(r*cos(a)));
 END;

 PROCEDURE  TempErrorProc;
 BEGIN
  {��楤�� ��뢠���� ����� ࠧ ����� ��������� �訡��, ��ࢮ��砫쭮 ���
   ��祣� ��������, �� ��  ������� �� ����� ��८�।�����}
 END;

 PROCEDURE  InitFI(d: Real);
 BEGIN
  IF VMInit THEN BEGIN
   FIStatus:=True;
   Diagonal:=d;
   IF @FIErrorProc = NIL THEN @FIErrorProc:=@TempErrorProc;
   d:=d-1.5; {�����蠥� ࠧ��� �� ��������� �� 1,
   �. �. ࠧ��� �����஢ ������ �� �� ��㡪�, � �� ������}
   ResolutionX:=MaxX DIV trunc(sqrt((d*d)/25)*4);
   ResolutionY:=MaxY DIV trunc(sqrt((d*d)/25)*3);
   ItemSizeY:=ResolutionY/72;
   ItemSizeX:=ResolutionX/72;
  END ELSE BEGIN
   {����㠫쭠� ������ �����樠����஢����}
   FIError:=True;
   FIErrorCode:=7;
   FIErrorProc;
  END;
 END;

 PROCEDURE  RegisterFontFile(fn: String; var fff: TFont);
 VAR SegFont, fd, OfsFont, k, n, m, hs, tc, dof, ff, um, lm, off, tow, maxsize, tw, tw2: Word;
     offs, fs: LongInt;
     b, fc: Byte;
     b1: ARRAY [0..1] OF Byte ABSOLUTE hs;
     b2: ARRAY [0..1] OF Byte ABSOLUTE tc;
     b3: ARRAY [0..1] OF Byte ABSOLUTE dof;
     b4: ARRAY [0..1] OF Byte ABSOLUTE tw;
     b5: ARRAY [0..1] OF Byte ABSOLUTE tw2;
     b6: ARRAY [0..3] OF Byte ABSOLUTE offs;
     f: File Of Byte;
     chrname: string;
     chrextname: string;
     copyright: string;
 CONST CHRHead: String = 'PK'+#8+#8;
 FUNCTION   GetB(n: LongInt): Byte;
 VAR b: Byte;
 BEGIN
  Seek(f, n);
  Read(f, b);
  GetB:=b;
 END;
 BEGIN
  IF FIStatus THEN BEGIN
   Assign(f, fn);
   {$I-} Reset(f); {$I+}
   {�஢��塞 ����稥 ����}
   IF IOResult <> 0 THEN BEGIN
    {���������� ������ 䠩� ����}
    FIError:=True;
    FIErrorCode:=2;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {����砥� ࠧ��� 䠩��}
   fs:=FileSize(f);
   {�஢��塞 ��������� �� �ਭ���������� � CHR �����}
   FOR N:=0 TO 3 DO IF Ord(CHRHead[n+1]) <> GetB(n) THEN BEGIN
    {���� ������ CHR ���⮬}
    FIError:=True;
    FIErrorCode:=3;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {�饬 ����� ���� Copyright}
   n:=3;
   Copyright:='';
   REPEAT
    Inc(n);
    Copyright:=Copyright+Chr(GetB(n));
   UNTIL GetB(n-1) = $1A;
   {�஢��塞 �� ���७��� ���}
   chrextname:='';
   IF Copyright[1] = 'S' THEN BEGIN
    chrextname:=Copy(copyright,Pos('The ',copyright)+4,Length(Copyright)-Pos('The ',copyright));
    chrextname:=Copy(chrextname,1,Pos(' font.',chrextname)-1);
   END;
   {����砥� ��騩 ࠧ��� ��������� CHR 䠩��}
   b1[0]:=GetB(n); b1[1]:=GetB(n+1);
   Inc(n,2);
   {����砥� ��� ����}
   chrname:='';
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   IF chrextname <> '' THEN chrname:=chrextname;
   {�ய�᪠�� ���� FontSize � ���� FontVersion}
   Inc(n,5);
   {�஢��塞 ����� ���������}
   REPEAT
    Inc(n);
   UNTIL GetB(n-1) = Ord('+');
   {�஢��塞 ����� ���������, � �㦭�� �� �� ����, �᫨ ��� � ��室��}
   IF (n-1) <> hs THEN BEGIN
    {���ࠢ���� ���������}
    FIError:=True;
    FIErrorCode:=4;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {����砥� ��饥 ������⢮ ᨬ����� � ����}
   b2[0]:=GetB(n); Inc(n);
   b2[1]:=GetB(n); Inc(n);
   {�ய�᪠�� ��१�ࢨ஢���� ����}
   Inc(n);
   {����砥� ��� ��ࢮ�� ᨬ����}
   fc:=GetB(n); Inc(n);
   {����砥� ���祭�� ���� DataOffset}
   b3[0]:=GetB(n); Inc(n);
   b3[1]:=GetB(n); Inc(n);
   IF tc <> (Dof-16) DIV 3 THEN BEGIN
    {���ࠢ���� ���������}
    FIError:=True;
    FIErrorCode:=4;
    FIErrorProc;
    Exit;
   END;
   {����砥� 䫠� ����������}
   ff:=GetB(n); Inc(n);
   {����砥� ������ �࠭��� ᨬ�����}
   um:=GetB(n);
   {�ய�᪠�� ��१�ࢨ஢���� ����}
   Inc(n,2);
   {����砥� ������ �࠭���}
   lm:=GetB(n);
   {�ய�᪠�� ��१�ࢨ஢���� 5 ����}
   Inc(n,6);
   {���������� ��砫� ⠡���� ᬥ饭��}
   off:=n;
   {�ய�᪠�� ⠡���� ᬥ饭��}
   Inc(n,2*tc);
   {���������� ��砫� ⠡���� �ਭ}
   tow:=n;
   {�ய�᪠�� ⠡���� �ਭ}
   Inc(n,tc);
   {���������� ��砫� �������}
   fd:=n;
   {�뤥�塞 ������ ��� ������ ����}
   FFF.Data.Init(4+5*tc+fs-fd,1);
   IF (VMErrorCode = 3) OR (VMErrorCode = 2) THEN BEGIN
    {��墠⠥� �����}
    FIError:=True;
    FIErrorCode:=6;
    FIErrorProc;
    FFF.Mode:=0;
    Exit;
   END ELSE IF VMErrorCode > 0 THEN BEGIN
    {�訡�� �� ࠡ�� � �������}
    FIError:=True;
    FIErrorCode:=8;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {�����뢠�� ��� ��ࢮ�� ᨬ���� � ��饥 ������⢮ ᨬ�����}
   hs:=fc;
   FFF.Data.PutB(0,b1[0]);
   FFF.Data.PutB(1,b1[1]);
   hs:=tc;
   FFF.Data.PutB(2,b1[0]);
   FFF.Data.PutB(3,b1[1]);
   {������� ⠡���� �ਭ � ⠡���� ᬥ饭��}
   FOR n:=0 TO tc-1 DO BEGIN
    FFF.Data.PutB(4+n,GetB(tow+n));
    b5[0]:=GetB(off+n*2);
    b5[1]:=GetB(off+n*2+1);
    offs:=tw2+4+tc+tc*4;
    FFF.Data.PutB(n*4+4+tc,b6[0]);
    FFF.Data.PutB(n*4+5+tc,b6[1]);
    FFF.Data.PutB(n*4+6+tc,b6[2]);
    FFF.Data.PutB(n*4+7+tc,b6[3]);
   END;
   {����㦠�� ��������}
   FOR n:=fd TO fs-1 DO FFF.Data.PutB(n-fd+4+tc+tc*4,GetB(n));
   Close(f);
   {��⠭�������� ����ன�� ����}
   FFF.Name:=chrname;
   FFF.Height:=1;
   FFF.Width:=1;
   FFF.BaseLine:=7;
   FFF.Ascent:=um;
   FFF.Descent:=lm;
   FFF.Mode:=1;
   FFF.Color:=White;
   FFF.Bold:=0;
   FFF.Italic:=0;
   FFF.UnderLine:=0;
   FFF.StrikeLine:=0;
   SetFontSize(12,FFF);
  END ELSE BEGIN
   {����� ���� ���樠����஢��}
   FFF.Mode:=0;
   FIError:=True;
   FIErrorCode:=1;
   FIErrorProc;
  END;
 END;

 PROCEDURE  RegisterFontRAM(VAR fn; size: LongInt; VAR fff: TFont);
 VAR SegFont, fd, OfsFont, k, n, m, hs, tc, dof, ff, um, lm, off, tow, maxsize, tw, tw2: Word;
     offs, fs: LongInt;
     b, fc: Byte;
     b1: ARRAY [0..1] OF Byte ABSOLUTE hs;
     b2: ARRAY [0..1] OF Byte ABSOLUTE tc;
     b3: ARRAY [0..1] OF Byte ABSOLUTE dof;
     b4: ARRAY [0..1] OF Byte ABSOLUTE tw;
     b5: ARRAY [0..1] OF Byte ABSOLUTE tw2;
     b6: ARRAY [0..3] OF Byte ABSOLUTE offs;
     data: ARRAY [0..10] OF Byte ABSOLUTE fn;
     chrname: string;
     chrextname: string;
     copyright: string;
 CONST CHRHead: String = 'PK'+#8+#8;
 FUNCTION   GetB(n: LongInt): Byte;
 BEGIN
  Getb:=data[n];
 END;
 BEGIN
  IF FIStatus THEN BEGIN
   {����砥� ࠧ��� 䠩��}
   fs:=size;
   {�஢��塞 ��������� �� �ਭ���������� � CHR �����}
   FOR N:=0 TO 3 DO IF Ord(CHRHead[n+1]) <> GetB(n) THEN BEGIN
    {���� ������ CHR ���⮬}
    FIError:=True;
    FIErrorCode:=3;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {�饬 ����� ���� Copyright}
   n:=3;
   Copyright:='';
   REPEAT
    Inc(n);
    Copyright:=Copyright+Chr(GetB(n));
   UNTIL GetB(n-1) = $1A;
   {�஢��塞 �� ���७��� ���}
   chrextname:='';
   IF Copyright[1] = 'S' THEN BEGIN
    chrextname:=Copy(copyright,Pos('The ',copyright)+4,Length(Copyright)-Pos('The ',copyright));
    chrextname:=Copy(chrextname,1,Pos(' font.',chrextname)-1);
   END;
   {����砥� ��騩 ࠧ��� ��������� CHR 䠩��}
   b1[0]:=GetB(n); b1[1]:=GetB(n+1);
   Inc(n,2);
   {����砥� ��� ����}
   chrname:='';
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   IF chrextname <> '' THEN chrname:=chrextname;
   {�ய�᪠�� ���� FontSize � ���� FontVersion}
   Inc(n,5);
   {�஢��塞 ����� ���������}
   REPEAT
    Inc(n);
   UNTIL GetB(n-1) = Ord('+');
   {�஢��塞 ����� ���������, � �㦭�� �� �� ����, �᫨ ��� � ��室��}
   IF (n-1) <> hs THEN BEGIN
    {���ࠢ���� ���������}
    FIError:=True;
    FIErrorCode:=4;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {����砥� ��饥 ������⢮ ᨬ����� � ����}
   b2[0]:=GetB(n); Inc(n);
   b2[1]:=GetB(n); Inc(n);
   {�ய�᪠�� ��१�ࢨ஢���� ����}
   Inc(n);
   {����砥� ��� ��ࢮ�� ᨬ����}
   fc:=GetB(n); Inc(n);
   {����砥� ���祭�� ���� DataOffset}
   b3[0]:=GetB(n); Inc(n);
   b3[1]:=GetB(n); Inc(n);
   IF tc <> (Dof-16) DIV 3 THEN BEGIN
    {���ࠢ���� ���������}
    FIError:=True;
    FIErrorCode:=4;
    FIErrorProc;
    Exit;
   END;
   {����砥� 䫠� ����������}
   ff:=GetB(n); Inc(n);
   {����砥� ������ �࠭��� ᨬ�����}
   um:=GetB(n);
   {�ய�᪠�� ��१�ࢨ஢���� ����}
   Inc(n,2);
   {����砥� ������ �࠭���}
   lm:=GetB(n);
   {�ய�᪠�� ��१�ࢨ஢���� 5 ����}
   Inc(n,6);
   {���������� ��砫� ⠡���� ᬥ饭��}
   off:=n;
   {�ய�᪠�� ⠡���� ᬥ饭��}
   Inc(n,2*tc);
   {���������� ��砫� ⠡���� �ਭ}
   tow:=n;
   {�ய�᪠�� ⠡���� �ਭ}
   Inc(n,tc);
   {���������� ��砫� �������}
   fd:=n;
   {�뤥�塞 ������ ��� ������ ����}
   FFF.Data.Init(4+5*tc+fs-fd,1);
   IF (VMErrorCode = 3) OR (VMErrorCode = 2) THEN BEGIN
    {��墠⠥� �����}
    FIError:=True;
    FIErrorCode:=6;
    FIErrorProc;
    FFF.Mode:=0;
    Exit;
   END ELSE IF VMErrorCode > 0 THEN BEGIN
    {�訡�� �� ࠡ�� � �������}
    FIError:=True;
    FIErrorCode:=8;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {�����뢠�� ��� ��ࢮ�� ᨬ���� � ��饥 ������⢮ ᨬ�����}
   hs:=fc;
   FFF.Data.PutB(0,b1[0]);
   FFF.Data.PutB(1,b1[1]);
   hs:=tc;
   FFF.Data.PutB(2,b1[0]);
   FFF.Data.PutB(3,b1[1]);
   {������� ⠡���� �ਭ � ⠡���� ᬥ饭��}
   FOR n:=0 TO tc-1 DO BEGIN
    FFF.Data.PutB(4+n,GetB(tow+n));
    b5[0]:=GetB(off+n*2);
    b5[1]:=GetB(off+n*2+1);
    offs:=tw2+4+tc+tc*4;
    FFF.Data.PutB(n*4+4+tc,b6[0]);
    FFF.Data.PutB(n*4+5+tc,b6[1]);
    FFF.Data.PutB(n*4+6+tc,b6[2]);
    FFF.Data.PutB(n*4+7+tc,b6[3]);
   END;
   {����㦠�� ��������}
   FOR n:=fd TO fs-1 DO FFF.Data.PutB(n-fd+4+tc+tc*4,GetB(n));
{   Close(f);}
   {��⠭�������� ����ன�� ����}
   FFF.Name:=chrname;
   FFF.Height:=1;
   FFF.Width:=1;
   FFF.BaseLine:=7;
   FFF.Ascent:=um;
   FFF.Descent:=lm;
   FFF.Mode:=1;
   FFF.Color:=White;
   FFF.Bold:=0;
   FFF.Italic:=0;
   FFF.UnderLine:=0;
   FFF.StrikeLine:=0;
   SetFontSize(12,FFF);
  END ELSE BEGIN
   {����� ���� ���樠����஢��}
   FFF.Mode:=0;
   FIError:=True;
   FIErrorCode:=1;
   FIErrorProc;
  END;
 END;

 PROCEDURE  CloseFont(VAR f: TFont);
 BEGIN
  IF F.Mode <> 0 THEN BEGIN
   F.Mode:=0; {����頥� ���쭥�襥 �ᯮ�짮����� �⮣� ����}
   F.Data.Done; {�᢮������� ������ �易���� � ����� ���⮬}
  END ELSE BEGIN
   {���� ���� ���樠����஢��}
   FIError:=True;
   FIErrorCode:=5;
   FIErrorProc;
  END;
 END;

 PROCEDURE  SetFontSize(Sz: Word; VAR f: TFont);
 VAR h,w: Word;
 BEGIN
  IF f.Mode <> 0 THEN BEGIN
   {��ॢ���� ࠧ��� � �窨}
   h:=Round(Sz*ItemSizeY);
   w:=Round(Sz*ItemSizeX);
   f.Height:=h/f.Ascent; {��⠭�������� �����}
   f.Width:=w/f.Ascent;
  END ELSE BEGIN
   {���� ���� ���樠����஢��}
   FIError:=True;
   FIErrorCode:=5;
   FIErrorProc;
  END;
 END;

 PROCEDURE  DrawChar(x1, y1: Word; c: Char; f: TFont);
 VAR vec, op, cd, sz: Word;
     x,y,x0,y0,xx,yy,k,tc,offs,x2,y2: Integer;
     bv: ARRAY [0..1] OF Byte ABSOLUTE vec;
     tl: TLineStyle;
 BEGIN
  IF f.Mode <> 0 THEN BEGIN
   {���४��㥬 ���न���� �� �� X � �裡 � �������� ०���� ���ᨢ�}
   Coor(f.Italic,0,Round(f.Ascent*f.Height),x2,y2);
   x1:=x1+Abs(x2);
   {���࠭塞 �०��� ⨯ �����}
   tl:=LineStyle;
   {��⠭�������� ���� ⨯ �����}
   LineStyle.Color:=f.Color;
   LineStyle.Size:=f.Bold+1;
   LineStyle.Mask:=0;
   LineStyle.MaskLine:=False;
   IF (f.Height > 1.0)  OR (f.Width > 1.0) THEN BEGIN
    LineStyle.Color:=f.Color;
    LineStyle.Size:=Round(((f.Height+f.Width)/2+0.1)*(f.Bold+1));
    LineStyle.Mask:=0;
    LineStyle.MaskLine:=False;
   END;
   {����砥� ��饥 ������⢮ ᨬ�����}
   bv[0]:=F.Data.GetB(2);
   bv[1]:=F.Data.GetB(3);
   tc:=vec;
   {����砥� ��� ᨬ���� �⭮�⥫쭮 ���� ��ࢮ�� ᨬ����}
   bv[0]:=F.Data.GetB(0);
   bv[1]:=F.Data.GetB(1);
   cd:=Ord(c);
   IF (cd < Vec) OR (cd > Vec+tc-1) THEN Exit;
   ASM
    MOV ax, cd
    SUB ax, vec
    MOV cd, ax
    MOV k,1
    MOV ax,x1
    MOV x,ax
    MOV ax,y1
    MOV y,ax
   END;
   {����砥� ��饥 ������⢮ ᨬ�����}
   bv[0]:=F.Data.GetB(2);
   bv[1]:=F.Data.GetB(3);
   tc:=vec;
   {����砥� ᬥ饭�� ��ࢮ� �������}
   bv[0]:=F.Data.GetB(tc+4+cd*4);
   bv[1]:=F.Data.GetB(tc+5+cd*4);
   offs:=vec;
   {����砥� ࠧ��� ᨬ���� �� �� X}
   sz:=F.Data.GetB(4+cd)+1;
   {�஢��塞 ����ન�����}
   IF f.UnderLine > 0 THEN BEGIN
    {���뢠�� ������ ���ᨢ�}
    Coor(f.Italic,0,Round((f.Ascent+2)*f.Height),x2,y2);
    {���뢠�� ����⠡�� �����樥���}
    sz:=Round((sz)*f.Width);
    Line(x1+x2,y1+Round((f.Ascent+2)*f.Height),x1+x2+sz,y1+Round((f.Ascent+2)*f.Height));
    IF f.UnderLine = 2 THEN BEGIN
     {���뢠�� ������ ���ᨢ�}
     Coor(f.Italic,0,Round((f.Ascent+3)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+3)*f.Height),x1+x2+sz,y1+Round((f.Ascent+3)*f.Height));
    END;
    IF f.UnderLine = 3 THEN BEGIN
     {���뢠�� ������ ���ᨢ�}
     Coor(f.Italic,0,Round((f.Ascent+4)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+4)*f.Height),x1+x2+sz,y1+Round((f.Ascent+4)*f.Height));
    END;
    IF f.UnderLine = 4 THEN BEGIN
     {���뢠�� ������ ���ᨢ�}
     Coor(f.Italic,0,Round((f.Ascent+3)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+3)*f.Height),x1+x2+sz,y1+Round((f.Ascent+3)*f.Height));
     {���뢠�� ������ ���ᨢ�}
     Coor(f.Italic,0,Round((f.Ascent+5)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+5)*f.Height),x1+x2+sz,y1+Round((f.Ascent+5)*f.Height));
    END;
    IF f.UnderLine = 5 THEN BEGIN
     {���뢠�� ������ ���ᨢ�}
     Coor(f.Italic,0,Round((f.Ascent+4)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+4)*f.Height),x1+x2+sz,y1+Round((f.Ascent+4)*f.Height));
     {���뢠�� ������ ���ᨢ�}
     Coor(f.Italic,0,Round((f.Ascent+5)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+5)*f.Height),x1+x2+sz,y1+Round((f.Ascent+5)*f.Height));
    END;
   END;
   {����砥� ࠧ��� ᨬ���� �� �� X}
   sz:=F.Data.GetB(4+cd)+1;
   {�஢��塞 ���ન�����}
   IF f.StrikeLine > 0 THEN BEGIN
    {���뢠�� ������ ���ᨢ�}
    Coor(f.Italic,0,Round((f.Ascent/2)*f.Height),x2,y2);
    {���뢠�� ����⠡�� �����樥���}
    sz:=Round((sz)*f.Width);
    Line(x1+x2,y1+Round((f.Ascent/2)*f.Height),x1+x2+sz,y1+Round((f.Ascent/2)*f.Height));
   END;
   {���ᮢ뢠�� ᨬ���}
   REPEAT
    {����砥� ��।��� �������}
    bv[0]:=F.Data.GetB(offs+(k-1)*2);
    bv[1]:=F.Data.GetB(offs+(k-1)*2+1);
    op:=Vec AND $8080;
    xx:=Vec AND $7F;
    yy:=(Vec SHR 8) AND $7F;
    ASM
     CMP yy, 63
     JNG @next
     SUB yy, 128
    @next:
    END;
    {�८�ࠧ㥬 ���न���� �� Y �⭮�⥫쭮 ��ଠ�쭮� ���न��⭮� �⪨}
    yy:=F.Ascent-yy;
    {���뢠�� ������ ���ᨢ�}
    x2:=0;
    IF f.Italic <> NoItalic THEN Coor(f.Italic,0,yy,x2,y2);
    {���뢠�� ����⠡�� �����樥���}
    x0:=x1+Round(xx*f.Width)+x2;
    y0:=y1+Round(yy*f.Height);
    {����稢��� �����}
    IF k=1 THEN BEGIN x:=x0; y:=y0; END;
    IF op=$8080 THEN Line(x,y,x0,y0);
    {���室�� � ����� ��� � 㢥��稢��� ���稪 ������}
    ASM
     CMP op, 0
     JE @next
     MOV ax, x0
     MOV x, ax
     MOV ax, y0
     MOV y, ax
     @next:
     INC k
    END;
  UNTIL Op=0;
  {���⠭�������� �०��� ⨯ �����}
  SetLineStyle(tl);
  END ELSE BEGIN
   {���� ���� ���樠����஢��}
   FIError:=True;
   FIErrorCode:=5;
   FIErrorProc;
  END;
 END;

 PROCEDURE  DrawString(x1, y1: Word; s: String; f: TFont);
 VAR k: Byte;
     vec: Word;
     b: ARRAY [0..1] OF Byte ABSOLUTE  vec;
 BEGIN
  IF f.Mode <> 0 THEN BEGIN
   b[0]:=F.Data.GetB(0);
   b[1]:=F.Data.GetB(1);
   FOR k:=1 TO Length(s) DO BEGIN
    DrawChar(x1,y1,s[k],f);
    Inc(x1,Round((F.Data.GetB(Ord(s[k])-vec+4)+f.Bold+1)*(f.Height+f.Width)/2));
   END;
  END ELSE BEGIN
   {���� ���� ���樠����஢��}
   FIError:=True;
   FIErrorCode:=5;
   FIErrorProc;
  END;
 END;

 FUNCTION   GetStringLength(s: String; f: TFont): Word;
 VAR n:Byte;
     w:Word;
     vec: Word;
     b: ARRAY [0..1] OF Byte ABSOLUTE  vec;
 BEGIN
  IF f.Mode <> 0 THEN BEGIN
   b[0]:=F.Data.GetB(0);
   b[1]:=F.Data.GetB(1);
   w:=0;
   FOR n:=1 TO Length(s) DO
    Inc(w,Round((F.Data.GetB(Ord(s[n])-vec+4)+f.Bold+1)*(f.Height+f.Width)/2));
   GetStringLength:=w;
  END ELSE BEGIN
   {���� ���� ���樠����஢��}
   FIError:=True;
   FIErrorCode:=5;
   FIErrorProc;
   GetStringLength:=0;
  END;
 END;

 FUNCTION   PunctsToPixel(p: Word): Word;
 BEGIN
  IF FIStatus THEN PunctsToPixel:=Round(p*ItemSizeY) ELSE BEGIN
   {����� ���� ���樠����஢��}
   FIError:=True;
   FIErrorCode:=1;
   FIErrorProc;
  END;
 END;

 FUNCTION   PixelToPuncts(p: Word): Word;
 BEGIN
  IF FIStatus THEN PixelToPuncts:=Round(p/ItemSizeY) ELSE BEGIN
   {����� ���� ���樠����஢��}
   FIError:=True;
   FIErrorCode:=1;
   FIErrorProc;
  END;
 END;

{============================================================================}
 BEGIN
  FIStatus:=False;
  {����� ��� �� ���樠����஢��}
  FIError:=True;
  FIErrorCode:=1;
  @FIErrorProc:=NIL;
 END.
{============================================================================}