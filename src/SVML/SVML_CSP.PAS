{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
UNIT SVML_CSP;
INTERFACE
 USES SVML_U2, SVML_U1, DOS, Crt, SVM_n, SGI, SFI;
 PROCEDURE CSP_0;
 PROCEDURE CSP_1;
 PROCEDURE CSP_2;
 PROCEDURE CSP_3;
 PROCEDURE CSP_4;
 PROCEDURE CSP_5;
 PROCEDURE CSP_6;
 PROCEDURE CSP_7;
 PROCEDURE CSP_8;
 PROCEDURE CSP_9;
 PROCEDURE CSP_10;
IMPLEMENTATION

 FUNCTION CompToDouble(c: Comp): Double;
 VAR d: Double ABSOLUTE c;
 BEGIN
  CompToDouble:=d;
 END;

 FUNCTION DoubleToComp(d: Double): Comp;
 VAR c: Comp ABSOLUTE d;
 BEGIN
  DoubleToComp:=c;
 END;

 PROCEDURE CSP_0; {���⥬�}
 PROCEDURE CSP0_0; {0 - ������ ����}
 VAR y,m,d,dow: Word;
 BEGIN
  GetDate(y,m,d,dow);
  RegArea.BX:=y;
  RegArea.CL:=m;
  RegArea.CH:=d;
  RegArea.DL:=dow;
 END;
 PROCEDURE CSP0_1; {1 - ������� �६�}
 VAR h,m,s,ms: Word;
 BEGIN
  GetTime(h,m,s,ms);
  RegArea.BL:=h;
  RegArea.BH:=m;
  RegArea.CL:=s;
  RegArea.CH:=ms;
 END;
 PROCEDURE CSP0_2; {2 - ��⠭����� ����}
 VAR y,m,d,dow: Word;
 BEGIN
  y:=RegArea.BX;
  m:=RegArea.CL;
  d:=RegArea.CH;
  SetDate(y,m,d);
 END;
 PROCEDURE CSP0_3; {3 - ��⠭����� �६�}
 VAR h,m,s,ms: Word;
 BEGIN
  h:=RegArea.BL;
  m:=RegArea.BH;
  s:=RegArea.CL;
  ms:=RegArea.CH;
  SetTime(h,m,s,ms);
 END;

 PROCEDURE CSP0_8; {8 - �������� ������⢮ ����� �뤥������ ��� �ணࠬ��}
 BEGIN
  PRG.ReSize(RegArea.LBX,1);
 END;

 PROCEDURE CSP0_9; {9 - ������� ������⢮ �뤥������ �ணࠬ�� �����}
 BEGIN
  RegArea.LBX:=PRG.Size;
 END;

 PROCEDURE CSP0_10; {10 - �뤥���� �������⥫��� ������}
 BEGIN
 END;
 PROCEDURE CSP0_11;
 BEGIN
 END;
 PROCEDURE CSP0_12;
 BEGIN
 END;
 PROCEDURE CSP0_13;
 BEGIN
 END;
 PROCEDURE CSP0_14;
 BEGIN
 END;
 PROCEDURE CSP0_15;
 BEGIN
 END;
 PROCEDURE CSP0_16;
 BEGIN
 END;
 PROCEDURE CSP0_17;
 BEGIN
 END;
 PROCEDURE CSP0_18;
 BEGIN
 END;
 PROCEDURE CSP0_19;
 BEGIN
 END;
 PROCEDURE CSP0_20;
 BEGIN
 END;
 PROCEDURE CSP0_21;
 BEGIN
 END;
 PROCEDURE CSP0_22;
 BEGIN
 END;

 BEGIN
  {���⥬�� �㭪樨 � LAX:
    0 - ������ ����
    1 - ������� �६�
    2 - ��⠭����� ����
    3 - ��⠭����� �६�
    8 - �������� ������⢮ ����� �뤥������ ��� �ணࠬ��
    9 - ������� ������⢮ �뤥������ �ணࠬ�� �����
   10 - �뤥���� �������⥫��� ������
   11 - �������� ࠧ��� �����
   12 - �᢮������ �뤥����� ������
   13 - ������ ���� �� �����
   14 - ������ ��� ���� �� �����
   15 - ������ ���� ���� �� �����
   16 - ������ ��ᥬ� ���� �� �����
   17 - ������ �������� ������⢮ ���� �� �����
   18 - ������� ���� � ������
   19 - ������� ��� ���� � ������
   20 - ������� ���� ���� � ������
   21 - ������� ��ᥬ� ���� � ������
   22 - ������� �������� ������⢮ ���� � ������}
  CASE RegArea.EAX OF
   0: CSP0_0;
   1: CSP0_1;
   2: CSP0_2;
   3: CSP0_3;
   8: CSP0_8;
   9: CSP0_9;
  END;
 END;

 PROCEDURE CSP_1; {��⥬���᪨� ����䥩�}
 PROCEDURE CSP1_0;
 VAR d1, d2: Double;
 BEGIN
  d1:=CompToDouble(RegArea.LBX);
  d2:=CompToDouble(RegArea.LCX);
  d1:=d1+d2;
  RegArea.LBX:=DoubleToComp(d1);
 END;
 PROCEDURE CSP1_1;
 VAR d1, d2: Double;
 BEGIN
  d1:=CompToDouble(RegArea.LBX);
  d2:=CompToDouble(RegArea.LCX);
  d1:=d1-d2;
  RegArea.LBX:=DoubleToComp(d1);
 END;
 PROCEDURE CSP1_2;
 VAR d1, d2: Double;
 BEGIN
  d1:=CompToDouble(RegArea.LBX);
  d2:=CompToDouble(RegArea.LCX);
  d1:=d1*d2;
  RegArea.LBX:=DoubleToComp(d1);
 END;
 PROCEDURE CSP1_3;
 VAR d1, d2: Double;
 BEGIN
  d1:=CompToDouble(RegArea.LBX);
  d2:=CompToDouble(RegArea.LCX);
  IF d2 = 0 THEN BEGIN
   d1:=0;
   d2:=0;
   RegArea.LCX:=DoubleToComp(d2);
  END ELSE d1:=d1/d2;
  RegArea.LBX:=DoubleToComp(d1);
 END;
 PROCEDURE CSP1_4;
 VAR d: Double;
     c: Comp;
 BEGIN
  d:=CompToDouble(RegArea.LBX);
  IF Frac(d) >= 0.5 THEN d:=d+1.0;
  d:=Int(d);
  c:=d;
  RegArea.LBX:=c;
 END;
 PROCEDURE CSP1_5;
 VAR d: Double;
     c: Comp;
 BEGIN
  d:=CompToDouble(RegArea.LBX);
  d:=Int(d);
  c:=d;
  RegArea.LBX:=c;
 END;
 PROCEDURE CSP1_6;
 VAR d: Double;
 BEGIN
  d:=CompToDouble(RegArea.LBX);
  d:=pi;
  RegArea.LBX:=DoubleToComp(d);
 END;
 PROCEDURE CSP1_7;
 VAR d: Double;
 BEGIN
  d:=CompToDouble(RegArea.LBX);
  d:=Frac(d);
  RegArea.LBX:=DoubleToComp(d);
 END;
 PROCEDURE CSP1_8;
 VAR d: Double;
 BEGIN
  d:=CompToDouble(RegArea.LBX);
  d:=Int(d);
  RegArea.LBX:=DoubleToComp(d);
 END;
 PROCEDURE CSP1_9;
 VAR d: Double;
     c: Comp;
 BEGIN
  c:=RegArea.LBX;
  d:=c;
  RegArea.LBX:=DoubleToComp(d);
 END;

 PROCEDURE CSP1_10;
 VAR d: Double;
     c: Comp;
 BEGIN
  d:=CompToDouble(RegArea.LBX);
  d:=Sqrt(d);
  RegArea.LBX:=DoubleToComp(d);
 END;

 PROCEDURE CSP1_11;
 BEGIN
  RegArea.LBX:=DoubleToComp(Sin(CompToDouble(RegArea.LBX)));
 END;

 PROCEDURE CSP1_12;
 BEGIN
  RegArea.LBX:=DoubleToComp(Cos(CompToDouble(RegArea.LBX)));
 END;

 PROCEDURE CSP1_13;
 BEGIN
  RegArea.LBX:=DoubleToComp(Sin(CompToDouble(RegArea.LBX))/
                            Cos(CompToDouble(RegArea.LBX)));
 END;

 PROCEDURE CSP1_14;
 BEGIN
  RegArea.LBX:=DoubleToComp(Cos(CompToDouble(RegArea.LBX))/
                            Sin(CompToDouble(RegArea.LBX)));
 END;

 PROCEDURE CSP1_17;
 BEGIN
  RegArea.LBX:=DoubleToComp(ArcTan(CompToDouble(RegArea.LBX)));
 END;

 PROCEDURE CSP1_19;
 BEGIN
  RegArea.LBX:=DoubleToComp(Ln(CompToDouble(RegArea.LBX)));
 END;

 PROCEDURE CSP1_21;
 BEGIN
  RegArea.LBX:=DoubleToComp(Exp(CompToDouble(RegArea.LBX)));
 END;

 PROCEDURE CSP1_30;
 BEGIN
  RegArea.EBX:=Random(RegArea.EBX);
 END;

 PROCEDURE CSP1_31;
 VAR d: Double;
     c: Comp;
 BEGIN
  c:=Random(RegArea.EBX);
  d:=c+Random;
  RegArea.LBX:=DoubleToComp(d);
 END;

 BEGIN
  {��⥬���᪨� �㭪樨 � LAX:
   0 - ᫮����� ����⢥���� �ᥫ
   1 - ���⠭�� ����⢥���� �ᥫ
   2 - 㬭������ ����⢥���� �ᥫ
   3 - ������� ����⢥���� �ᥫ
   4 - �८�ࠧ����� ����⢥���� �᫮ � 楫��, ���㣫�� �஡��� ����
   5 - ������ 楫�� ���� ����⢥����� �᫠ � 楫�� �᫮
   6 - ������ �᫮ PI
   7 - ���㫨�� 楫�� ���� ����⢥����� �᫠
   8 - ���㫨�� �஡��� ���� ����⢥����� �᫠
   9 - �८�ࠧ����� 楫�� �᫮ � ����⢥����
  10 - ������ ��७� ������� �� ����⢥����� �᫠
  11 - ������ ᨭ�� �� ����⢥����� �᫠ � ࠤ�����
  12 - ������ ��ᨭ�� �� ����⢥����� �᫠ � ࠤ�����
  13 - ������ ⠭���� �� ����⢥����� �᫠ � ࠤ�����
  14 - ������ ��⠭���� �� ����⢥����� �᫠ � ࠤ�����
 **** 15 - ������ ��ᨭ�� �� ����⢥����� �᫠ � ࠤ�����
 **** 16 - ������ �પ�ᨭ�� �� ����⢥����� �᫠ � ࠤ�����
  17 - ������ ��⠭���� �� ����⢥����� �᫠ � ࠤ�����
 ****  18 - ������ �પ�⠭���� �� ����⢥����� �᫠ � ࠤ�����
  19 - ������ ����ࠫ�� ������ �� ����⢥��� �᫠
 ****  20 - ������ ������ �� ��������� �᭮����� �� ����⢥����� �᫠
  21 - ������ ��ᯮ����� �� ����⢥����� �᫠
  30 - ᣥ���஢��� ��砩��� 楫�� �᫮
  31 - ᣥ���஢��� ��砩��� ����⢥���� �᫮}
  CASE RegArea.EAX OF
    0: CSP1_0;
    1: CSP1_1;
    2: CSP1_2;
    3: CSP1_3;
    4: CSP1_4;
    5: CSP1_5;
    6: CSP1_6;
    7: CSP1_7;
    8: CSP1_8;
    9: CSP1_9;
   10: CSP1_10;
   11: CSP1_11;
   12: CSP1_12;
   13: CSP1_13;
   14: CSP1_14;
   17: CSP1_17;
   19: CSP1_19;
   21: CSP1_21;
   30: CSP1_30;
   31: CSP1_31;
  END;
 END;

 FUNCTION ReadString(a: Comp): String;
 VAR t: LongInt;
     s: String;
 BEGIN
   t:=0;
   s:='';
   REPEAT
    s:=s+Chr(PRG.GetB(a+t));
    Inc(t);
   UNTIL PRG.GetB(a+t) = 0;
   ReadString:=s;
 END;

 PROCEDURE CSP_2; {������� ����䥩� � ࠡ�� � ��⮪���}
 PROCEDURE CSP2_0;
 BEGIN
  {$I-}
  RegArea.LBX:=DiskSize(RegArea.BX+1);
  {$I+}
  IF IOResult <> 0 THEN RegArea.LAX:=1 ELSE RegArea.LAX:=0;
 END;
 PROCEDURE CSP2_1;
 BEGIN
  {$I-}
  RegArea.LBX:=DiskFree(RegArea.BX+1);
  {$I+}
  IF IOResult <> 0 THEN RegArea.LAX:=1 ELSE RegArea.LAX:=0;
 END;
 PROCEDURE CSP2_2;
 VAR n: LongInt;
 BEGIN
  n:=-1;
  z_f:=1;
  REPEAT
   Inc(n);
  UNTIL (StreamArray[n] = NIL) OR (n = 255);
  IF (StreamArray[n] = NIL) THEN BEGIN
   New(StreamArray[n]);
   StreamName:=ReadString(RegArea.LEP);
   StreamN:=n;
   StreamT:=1;
   InitStream;
   StreamArray[n]^.Init;
   RegArea.LDX:=n;
   z_f:=0;
  END;
  CorectRegFlag;
 END;
 PROCEDURE CSP2_3;
 VAR n: LongInt;
 BEGIN
  n:=-1;
  z_f:=1;
  REPEAT
   Inc(n);
  UNTIL (StreamArray[n] = NIL) OR (n = 255);
  IF (StreamArray[n] = NIL) THEN BEGIN
   New(StreamArray[n]);
   StreamName:=ReadString(RegArea.LEP);
   StreamN:=n;
   StreamT:=2;
   InitStream;
   StreamArray[n]^.Init;
   RegArea.LDX:=n;
   z_f:=0;
  END;
  CorectRegFlag;
 END;
 PROCEDURE CSP2_4;
 VAR n: LongInt;
 BEGIN
  n:=-1;
  z_f:=1;
  REPEAT
   Inc(n);
  UNTIL (StreamArray[n] = NIL) OR (n = 255);
  IF (StreamArray[n] = NIL) THEN BEGIN
   New(StreamArray[n]);
   StreamName:=ReadString(RegArea.LEP);
   StreamN:=n;
   StreamT:=3;
   InitStream;
   StreamArray[n]^.Init;
   RegArea.LDX:=n;
   z_f:=0;
  END;
  CorectRegFlag;
 END;
 PROCEDURE CSP2_5;
 VAR f: File;
 BEGIN
  Assign(f,ReadString(RegArea.LEP));
  Rename(f,ReadString(RegArea.LFP));
 END;
 PROCEDURE CSP2_6;
 VAR f: File;
 BEGIN
  Assign(f,ReadString(RegArea.LEP));
  Erase(f);
 END;
 PROCEDURE CSP2_14;
 VAR
  FromF, ToF: file;
  NumRead, NumWritten: Word;
  Buf: array[1..2048] of Char;
 BEGIN
  Assign(FromF, ReadString(RegArea.LEP));
  Reset(FromF, 1);
  Assign(ToF, ReadString(RegArea.LFP));
  Rewrite(ToF, 1);
  REPEAT
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  UNTIL (NumRead = 0) OR (NumWritten <> NumRead);
  Close(FromF);
  Close(ToF);
 END;
 PROCEDURE CSP2_20;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  StreamArray[RegArea.EDX]^.ReadByte;
 END;
 PROCEDURE CSP2_21;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  FirstC:=RegArea.LEP;
  CountC:=RegArea.LCX;
  StreamArray[RegArea.EDX]^.ReadArray;
 END;
 PROCEDURE CSP2_22;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  StreamArray[RegArea.EDX]^.ReadAndStay;
 END;
 PROCEDURE CSP2_23;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  StreamArray[RegArea.EDX]^.WriteByte;
 END;
 PROCEDURE CSP2_24;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  FirstC:=RegArea.LEP;
  CountC:=RegArea.LCX;
  StreamArray[RegArea.EDX]^.WriteArray;
 END;
 PROCEDURE CSP2_25;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  CountC:=RegArea.LCX;
  StreamArray[RegArea.EDX]^.Skeep;
 END;
 PROCEDURE CSP2_26;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  StreamArray[RegArea.EDX]^.GetTotal;
 END;
 PROCEDURE CSP2_27;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  StreamArray[RegArea.EDX]^.Mark;
 END;
 PROCEDURE CSP2_28;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  StreamArray[RegArea.EDX]^.BackToMark;
 END;
 PROCEDURE CSP2_29;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  StreamArray[RegArea.EDX]^.GetType;
 END;
 PROCEDURE CSP2_30;
 BEGIN
  IF StreamArray[RegArea.EDX] = NIL THEN Exit;
  StreamN:=RegArea.EDX;
  StreamArray[RegArea.EDX]^.Done;
  Dispose(StreamArray[RegArea.EDX]);
 END;

 BEGIN
 {������� � ��⮪��� �㭪樨 � LAX:
  0 - ������� ��ꥬ ��᪠ � �����
  1 - ������� ��ꥬ ᢮������� ����࠭�⢠ �� ��᪥ � �����
  2 - ������ 䠩���� ��⮪ ��� �⥭��
  3 - ������ 䠩���� ��⮪ ��� �����
  4 - ������ 䠩���� ��⮪ ��� �������
  5 - ��२�������� 䠩�
  6 - 㤠���� 䠩�
   7 - ������� ��ਡ��� 䠩��
   8 - ��⠭����� ��ਡ��� 䠩��
   9 - ᮧ���� ��⠫��
  10 - ��२�������� ��⠫��
  11 - 㤠���� ��⠫��
  12 - ������� ������⢮ 䠩��� � ��⠫���
  13 - ������� ᯨ᮪ 䠩��� � ��⠫���
 14 - ����஢��� 䠩�

 20 - ������ ���� ���� �� ��⮪�
 21 - ������ �������� ������⢮ ���� �� ��⮪�
 22 - ������ ���� ���� �� ��⮪�, �� �������� ��� �� ���㤠
 23 - ������� ���� ���� � ��⮪
 24 - ������� �������� ������⢮ ���� � ��⮪
 25 - �ய����� ��᪮�쪮 ���� � ��⮪�
 26 - ������ ������⢮ �����⠭��� ���� � ��⮪�
 27 - ��������� ��������� � ��⮪�, �᫨ �� �� ��������
 28 - �������� � ����������� ��������� � ��⮪�, �᫨ �� �� ��������
 29 - ������� ⨯ ��⮪�
 30 - ������� ��⮪}
  CASE RegArea.EAX OF
    0: CSP2_0;
    1: CSP2_1;
    2: CSP2_2;
    3: CSP2_3;
    4: CSP2_4;
    5: CSP2_5;
    6: CSP2_6;
   14: CSP2_14;
   20: CSP2_20;
   21: CSP2_21;
   22: CSP2_22;
   23: CSP2_23;
   24: CSP2_24;
   25: CSP2_25;
   26: CSP2_26;
   27: CSP2_27;
   28: CSP2_28;
   29: CSP2_29;
   30: CSP2_30;
  END;
 END;

 PROCEDURE CSP_3; {���������� � ��設�� ����䥩�}
 PROCEDURE CSP3_0;
 VAR n: LongInt;
 BEGIN
  n:=-1;
  z_f:=1;
  REPEAT
   Inc(n);
  UNTIL (StreamArray[n] = NIL) OR (n = 255);
  IF (StreamArray[n] = NIL) THEN BEGIN
   New(StreamArray[n]);
   StreamName:='KEYBOARD STREAM';
   StreamN:=n;
   StreamT:=1;
   InitStream;
   StreamArray[n]^.Init;
   RegArea.LDX:=n;
   z_f:=0;
  END;
  CorectRegFlag;
 END;
 PROCEDURE CSP3_1;
 VAR n: LongInt;
 BEGIN
  n:=-1;
  z_f:=1;
  REPEAT
   Inc(n);
  UNTIL (StreamArray[n] = NIL) OR (n = 255);
  IF (StreamArray[n] = NIL) THEN BEGIN
   New(StreamArray[n]);
   StreamName:='TERMINAL STREAM';
   StreamN:=n;
   StreamT:=3;
   InitStream;
   StreamArray[n]^.Init;
   RegArea.LDX:=n;
   z_f:=0;
  END;
  CorectRegFlag;
 END;

 PROCEDURE CSP3_2;
 BEGIN
  MouseRun;
  if MouseButton and 1 = 1 then RegArea.BL:=1 else RegArea.BL:=0;
  if MouseButton and 2 = 2 then RegArea.BH:=1 else RegArea.BH:=0;
  if MouseButton and 3 <> 0 then a_f:=1 else a_f:=0;
  MouseButton:=0;
  RegArea.LCX:=MouseX;
  RegArea.LDX:=MouseY;
  CorectRegFlag;
 END;

 BEGIN
 {���������� � ��設�� �㭪樨 � LAX:
  0 - ᮧ���� ��⮪ ����������
  1 - ᮧ���� ��⮪ �ନ����
  2 - ������� ���ﭨ� ���}
  CASE RegArea.EAX OF
   0: CSP3_0;
   1: CSP3_1;
   2: CSP3_2;
  END;
 END;

 PROCEDURE CSP_4; {����᪨� ����䥩�                        Graph}

 PROCEDURE CSP4_0; {����� ����᪮� ���ன�⢮              SelectGD}
 BEGIN
  if Loc <> 1 then InitGI(GrMode);
 END;

 PROCEDURE CSP4_1; {������� ��ࠬ���� ���ன�⢠               InfoGD}
 BEGIN
  RegArea.EBX:=MaxX;
  RegArea.ECX:=MaxY;
  RegArea.EDX:=0; {����� ����� � ���ன���}
 END;

 PROCEDURE CSP4_2;
 BEGIN
 END;

 PROCEDURE CSP4_3; {�뢥�� ��� �� ���न��⠬                PutPixel}
 BEGIN
  PutPixel(RegArea.EBX,RegArea.ECX);
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_4; {������ ��� �� ���न��⠬              GetPixel}
 VAR l: LongInt;
     col: TColor ABSOLUTE l;
 BEGIN
  col:=GetPixel(RegArea.EBX,RegArea.ECX)^;
  RegArea.EDX:=l;
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_5; {��⠭����� 梥� ��� �뢮�� �� ����᪮� ���ன�⢮}
 VAR l: LongInt;                                   {            SetColor}
     col: TColor ABSOLUTE l;
 BEGIN
  l:=RegArea.EDX;
  SetColor(Col);
  LineStyle.Size:=1;
  LineStyle.Color:=Col;
  FillStyle.Color:=Col;
  FillStyle.BGColor:=Col;
  FillStyle.Texture:=Full;
  FillStyle.TextureFill:=False;
  RegArea.LAX:=0;
  Fonts[0].Color:=Col;
 END;

{ PROCEDURE CSP4_6;
 VAR l: LongInt;
     col: TColor ABSOLUTE l;
 BEGIN
  l:=RegArea.EDX;
  LineStyle.Size:=RegArea.EBX;
  LineStyle.Color:=col;
 END;

 PROCEDURE CSP4_7;
 BEGIN
 END;}

 TYPE TPoint = RECORD
      X, Y: LongInt;
 END;

 PROCEDURE CSP4_8; {���ᮢ��� �����                            DrawLine}
 VAR c,c2: Comp;
     l1: TPoint ABSOLUTE c;
     l2: TPoint ABSOLUTE c2;
 BEGIN
  c:=RegArea.LBX;
  c2:=RegArea.LCX;
  IF (l1.x = l2.x) AND (l1.y = l2.y) THEN PutPixel(l1.x,l2.x) ELSE Line(l1.x,l1.y,l2.x,l2.y);
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_9; {���ᮢ��� ������襭� ��אַ㣮�쭨�       DrawRect}
 VAR c,c2: Comp;
     l1: TPoint ABSOLUTE c;
     l2: TPoint ABSOLUTE c2;
 BEGIN
  c:=RegArea.LBX;
  c2:=RegArea.LCX;
  IF (l1.x = l2.x) AND (l1.y = l2.y) THEN PutPixel(l1.x,l2.x) ELSE Rect(l1.x,l1.y,l2.x,l2.y);
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_10; {���ᮢ��� ������襭� ����               DrawOvel}
 VAR c,c2: Comp;
     l1: TPoint ABSOLUTE c;
     l2: TPoint ABSOLUTE c2;
 BEGIN
  c:=RegArea.LBX;
  c2:=RegArea.LCX;
  IF (l1.x = l2.x) AND (l1.y = l2.y) THEN PutPixel(l1.x,l2.x) ELSE Ellipse(l1.x,l1.y,l2.x,l2.y);
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_11; {���ᮢ��� ������襭� �����㣮�쭨�      DrawPolygon}
 VAR l1,l2: LongInt;
     l3,l4: LongInt;
     n,t: LongInt;
 BEGIN
  t:=PRG.GetL(RegArea.LEP);
  RegArea.LAX:=1;
  IF t < 2 THEN Exit;
  l1:=PRG.GetL(RegArea.LEP+4);
  l2:=PRG.GetL(RegArea.LEP+8);
  FOR n:=1 TO t-1 DO BEGIN
   l3:=PRG.GetL(RegArea.LEP+4+n*8);
   l4:=PRG.GetL(RegArea.LEP+8+n*8);
   Line(l1,l2,l3,l4);
   l1:=l3;
   l2:=l4;
  END;
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_12;
 BEGIN
 END;

 PROCEDURE CSP4_13; {���ᮢ��� ����襭� ��אַ㣮�쭨�        FillRect}
 VAR c,c2: Comp;
     l1: TPoint ABSOLUTE c;
     l2: TPoint ABSOLUTE c2;
 BEGIN
  c:=RegArea.LBX;
  c2:=RegArea.LCX;
  IF (l1.x = l2.x) AND (l1.y = l2.y) THEN PutPixel(l1.x,l2.x) ELSE FillRect(l1.x,l1.y,l2.x,l2.y);
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_14; {���ᮢ��� ����襭� ����                 FillOval}
 VAR c,c2: Comp;
     l1: TPoint ABSOLUTE c;
     l2: TPoint ABSOLUTE c2;
 BEGIN
  c:=RegArea.LBX;
  c2:=RegArea.LCX;
  IF (l1.x = l2.x) AND (l1.y = l2.y) THEN PutPixel(l1.x,l2.x) ELSE FillEllipse(l1.x,l1.y,l2.x,l2.y);
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_15;
 BEGIN
 END;

 PROCEDURE CSP4_20;                                     {TotalFonts}
 BEGIN
  RegArea.LDX:=TotalFonts;
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_21;                                     {GetFontName}
 VAR Name: String;
     n: Byte;
 BEGIN
  RegArea.LAX:=15;
  IF RegArea.EDX > (TotalFonts-1) THEN Exit;
  Name:=Fonts[RegArea.EDX].Name;        {����砥� ��� �ॡ㥬��� ����}
  FOR n:=1 TO Length(Name) DO
   PRG.PutB(RegArea.LEP+n-1,Ord(Name[n]));   {�����㥬 ᮤ�ন��� ��ப�, �}
  PRG.PutB(RegArea.LEP+n,0);            {��᫥���� ���� ��⠭�������� � 0}
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_22;                                     {SetFontParametrs}
 BEGIN
  RegArea.LAX:=15;
  IF RegArea.EDX > TotalFonts-1 THEN Exit;
  SetFontSize(RegArea.EBX,Fonts[RegArea.EDX]);
  IF RegArea.CL AND 1 = 1 THEN Fonts[RegArea.EDX].Bold:=Bold ELSE
     Fonts[RegArea.EDX].Bold:=NoBold;
  IF RegArea.CL AND 2 = 2 THEN Fonts[RegArea.EDX].Italic:=Italic ELSE
     Fonts[RegArea.EDX].Italic:=NoItalic;
  IF RegArea.CL AND 4 = 4 THEN Fonts[RegArea.EDX].UnderLine:=UnderLine ELSE
     Fonts[RegArea.EDX].UnderLine:=NoUnderLine;
  IF RegArea.CL AND 8 = 8 THEN Fonts[RegArea.EDX].StrikeLine:=StrikeLine ELSE
     Fonts[RegArea.EDX].StrikeLine:=NoStrikeLine;
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_23;
 BEGIN
 END;

 PROCEDURE CSP4_24;                                            {DrawString}
 VAR k: Word;
     vec: Word;
     x1, y1: Integer;
     b: ARRAY [0..1] OF Byte ABSOLUTE  vec;
     s: Char;
 BEGIN
  RegArea.LAX:=15;
  IF RegArea.EDX > TotalFonts-1 THEN Exit;
  IF Fonts[RegArea.EDX].Mode = 0 THEN Exit;
  y1:=RegArea.ECX{-Fonts[RegArea.EDX].BaseLine};
  x1:=RegArea.EBX;
  b[0]:=Fonts[RegArea.EDX].Data.GetB(0);
  b[1]:=Fonts[RegArea.EDX].Data.GetB(1);
  k:=0;
  REPEAT
   s:=Chr(PRG.GetB(RegArea.LEP+k));
   DrawChar(x1,y1,s,Fonts[RegArea.EDX]);
   Inc(x1, Round((Fonts[RegArea.EDX].Data.GetB(Ord(s)-vec+4)+
     Fonts[RegArea.EDX].Bold+1)*
       (Fonts[RegArea.EDX].Height+Fonts[RegArea.EDX].Width)/2));
   Inc(k);
  UNTIL PRG.GetB(RegArea.LEP+k) = 0;
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_25;                                            {StringWidth}
 VAR k:Word;
     w:Word;
     vec: Word;
     b: ARRAY [0..1] OF Byte ABSOLUTE  vec;
     s: Char;
 BEGIN
  RegArea.LAX:=15;
  RegArea.EBX:=w;
  IF RegArea.EDX > TotalFonts-1 THEN Exit;
  IF PRG.GetB(RegArea.LEP) = 0 THEN Exit;
  IF Fonts[RegArea.EDX].Mode = 0 THEN Exit;
   b[0]:=Fonts[RegArea.EDX].Data.GetB(0);
   b[1]:=Fonts[RegArea.EDX].Data.GetB(1);
   w:=0;
   k:=0;
  REPEAT
   s:=Chr(PRG.GetB(RegArea.LEP+k));
   Inc(w,Round((Fonts[RegArea.EDX].Data.GetB(Ord(s)-vec+4)+
     Fonts[RegArea.EDX].Bold+1)*
       (Fonts[RegArea.EDX].Height+Fonts[RegArea.EDX].Width)/2));
   Inc(k);
  UNTIL PRG.GetB(RegArea.LEP+k) = 0;
  RegArea.EBX:=w;
  RegArea.LAX:=0;
 END;

 PROCEDURE CSP4_26;                                          {PixelToItem}
 BEGIN
  RegArea.EBX:=PixelToPuncts(RegArea.EBX);
 END;

 PROCEDURE CSP4_27;                                          {ItemToPixel}
 BEGIN
  RegArea.EBX:=PunctsToPixel(RegArea.EBX);
 END;

 BEGIN
 {����᪨� �㭪樨 � LAX:
   0 - ����� ����᪮� ���ன�⢮
   1 - ������� ��ࠬ���� ����᪮�� ���ன�⢠
     2 - ��⠭����� 㣮� ������� �� �뢮�� �� ���ன�⢮
   3 - ��⠭����� ��� �� ���न��⠬
   4 - ������ ��� �� ���न��⠬
   5 - ��⠭����� 梥� ��� �뢮�� �� ����᪮� ���ன�⢮
     6 - ��⠭����� ⨯ �����
     7 - ��⠭����� ⨯ �������
   8 - ���ᮢ��� �����
   9 - ���ᮢ��� ���⮩ ��אַ㣮�쭨�
   10 - ���ᮢ��� ����
   11 - ���ᮢ��� �����㣮�쭨�
    12 - ���ᮢ��� ���
    13 - ���ᮢ��� ����襭� ��אַ㣮�쭨�
    14 - ���ᮢ��� ����襭� ����
    15 - ���ᮢ��� ����襭� �����㣮�쭨�
    16 - ���ᮢ��� ����襭�� ���
    17 - �ந����� �������

   20 - ������� ������⢮ ���⮢ ��⠭�������� � �ணࠬ��
   21 - ������� �������� ���� �� ��� ������
   22 - ��⠭����� ��ࠬ���� ���� ��� �뢮��
     23 - ������� ��ࠬ���� ����
   24 - �뢥�� ��ப� �� ���न��⠬
   25 - ������� ������ ��ப� � �窠� ���뢠� ����� ��ࠬ����
     26 - ������� ࠧ���� ����
   27 - ��ॢ��� �窨 � �㭪��
   28 - ��ॢ��� �㭪�� � �窨}
  CASE RegArea.EAX OF
    0: CSP4_0;
    1: CSP4_1;
    2: CSP4_2;
    3: CSP4_3;
    4: CSP4_4;
    5: CSP4_5;
{    6: CSP4_6;
    7: CSP4_7;}
    8: CSP4_8;
    9: CSP4_9;
   10: CSP4_10;
   11: CSP4_11;
   12: CSP4_12;
   13: CSP4_13;
   14: CSP4_14;
   15: CSP4_15;
   20: CSP4_20;
   21: CSP4_21;
   22: CSP4_22;
   23: CSP4_23;
   24: CSP4_24;
   25: CSP4_25;
   26: CSP4_26;
   27: CSP4_27;
  END;
 END;

 FUNCTION  SLength(adr: Comp): Comp;
 VAR n: Comp;
 BEGIN
  n:=-1;
  WHILE PRG.GetB(adr+n+1) <> 0 DO n:=n+1;
  SLength:=n+1;
 END;

 PROCEDURE SCopy(adrs, adrd, first, count: Comp);
 VAR n,l: Comp;
 BEGIN
  l:=SLength(adrs);
  IF l < first+count THEN count:=l-first;
  PRG.PutB(adrd,0);
  if count < 1 THEN Exit;
  n:=0;
  WHILE n < count DO BEGIN
   PRG.PutB(n+adrd,PRG.GetB(n+adrs+first));
   n:=n+1;
  END;
  PRG.PutB(n+adrd+1,0);
 END;

 FUNCTION  SPos(adrs, adrd: Comp): Comp;
 VAR ls, ld, n, k: Comp;
     fb: Byte;
 BEGIN
  ls:=SLength(adrs);
  ld:=SLength(adrd);
  SPos:=-1;
  IF (ls = 0) OR (ld = 0) THEN Exit;
  fb:=PRG.GetB(adrd);
  n:=0;
  WHILE (n <= ls) AND (fb <> 0) DO BEGIN
   IF PRG.GetB(adrs+n) = fb THEN BEGIN
    k:=0;
    WHILE (k < ld) AND (PRG.GetB(adrs+k+n) = PRG.GetB(adrd+k)) DO k:=k+1;
    IF k = ld THEN fb:= 0;
   END;
   n:=n+1;
  END;
  IF fb = 0 THEN SPos:=n-1 ELSE SPos:=-1;
 END;

 PROCEDURE SDelete(adrs, first, count: Comp);
 VAR ls, n: Comp;
 BEGIN
  ls:=SLength(adrs);
  IF ls < first+count THEN count:=ls-first;
  IF count < 1 THEN Exit;
  n:=0;
  WHILE n <= count DO BEGIN
   PRG.PutB(adrs+first+n,PRG.GetB(adrs+first+count+n));
   n:=n+1;
  END;
  PRG.PutB(adrs+first+n,0);
 END;

 PROCEDURE SInsert(adrs, adrd, first: Comp);
 VAR ls, ld, n: Comp;
 BEGIN
  ls:=SLength(adrs);
  ld:=SLength(adrd);
  IF first > ls THEN first:=ls;
  IF first <> ls THEN BEGIN
   n:=0;
   WHILE n <= (ld+1) DO BEGIN
    PRG.PutB(adrs+first+ld+n,PRG.GetB(adrs+first+n));
    n:=n+1;
   END;
  END;
  n:=0;
  WHILE n < ld DO BEGIN
   PRG.PutB(adrs+first+n,PRG.GetB(adrd+n));
   n:=n+1;
  END;
 END;

 PROCEDURE SFill(adrs, first, count: Comp; fillchar: Byte);
 VAR n, ls: Comp;
 BEGIN
  ls:=SLength(adrs);
  IF ls < first+count THEN count:=ls-first;
  IF count < 1 THEN Exit;
  n:=0;
  WHILE n < count DO BEGIN
   PRG.PutB(adrs+first+n,fillchar);
   n:=n+1;
  END;
 END;

 FUNCTION SCompair(adrs, adrd: Comp): Integer;
 VAR n: Comp;
 BEGIN
  n:=0;
  WHILE (PRG.GetB(n+adrs) <> 0) AND (PRG.GetB(n+adrd) <> 0) AND
   (PRG.GetB(n+adrs) = PRG.GetB(n+adrd)) DO n:=n+1;
  IF PRG.GetB(n+adrs) > PRG.GetB(n+adrd) THEN SCompair:=1 ELSE SCompair:=-1;
  IF PRG.GetB(n+adrs) = PRG.GetB(n+adrd) THEN SCompair:=0;
 END;

 PROCEDURE CSP_5; {��ப�}
 PROCEDURE CSP5_0;
 BEGIN
  RegArea.LCX:=SLength(RegArea.LEP);
 END;
 PROCEDURE CSP5_1;
 BEGIN
  SCopy(RegArea.LEP,RegArea.LFP,RegArea.LDX,RegArea.LCX);
 END;
 PROCEDURE CSP5_2;
 BEGIN
  RegArea.LDX:=SPos(RegArea.LEP,RegArea.LFP);
 END;
 PROCEDURE CSP5_3;
 BEGIN
  SDelete(RegArea.LEP, RegArea.LDX, RegArea.LCX);
 END;
 PROCEDURE CSP5_4;
 BEGIN
  SInsert(RegArea.LEP,RegArea.LFP,RegArea.LDX);
 END;
 PROCEDURE CSP5_5;
 BEGIN
  SFill(RegArea.LEP,RegArea.LDX,RegArea.LCX,RegArea.BL);
 END;
 PROCEDURE CSP5_6;
 VAR b: Integer;
 BEGIN
  b:=SCompair(RegArea.LEP,RegArea.LFP);
  IF b = 0 THEN e_f:=1 ELSE e_f:=0;
  IF b = 1 THEN g_f:=1 ELSE g_f:=0;
  IF b = -1 THEN l_f:=1 ELSE l_f:=0;
  CorectRegFlag;
 END;

 { 0 - ������ ������ ��ப�
   1 - ����஢��� �����ப�
   2 - ���� �����ப�
   3 - 㤠���� �����ப�
   4 - ��⠢��� �����ப�
   5 - ��������� �����ப�
   6 - �ࠢ���� ��ப� }
 BEGIN
  CASE RegArea.EAX OF
    0: CSP5_0;
    1: CSP5_1;
    2: CSP5_2;
    3: CSP5_3;
    4: CSP5_4;
    5: CSP5_5;
    6: CSP5_6;
  END;
 END;

 PROCEDURE CSP_6;
 BEGIN
 END;

 PROCEDURE CSP_7;
 BEGIN
 END;

 PROCEDURE CSP_8;
 BEGIN
 END;

 PROCEDURE CSP_9;
 BEGIN
 END;

 PROCEDURE CSP_10;
 BEGIN
 END;

END.