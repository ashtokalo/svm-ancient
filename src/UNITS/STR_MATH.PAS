{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
{============================================================================}
{====--------------------------------------------------------------------====}
{====                         String mathematics                         ====}
{====                            Version 1.0                             ====}
{====                   Copyright (c) 1999 ShAG Studio                   ====}
{====--------------------------------------------------------------------====}
{====   ��� ����� �������� ࠡ���� � �᫠��, �࠭�騬��� � ��ப��, ====}
{==== ��� � ����묨 �᫠�� ⨯�  Byte, Word, Integer, LongInt,  �� �� ====}
{==== �⮬  �� ����砥� �����������  ࠡ���� � �᫠��  ᮤ�ঠ騬� �� ====}
{==== 255 ���, �� �ॢ�蠥� 512 ��⭮� �᫮ ���� �����.              ====}
{====   ����� �������� �ந������� �⠭����� ����樨 � �᫠��:     ====}
{====  +, -, *, /, MOD, ABS, NEG, CMP, Str, Val, Inc, Dec, AND, OR, XOR, ====}
{==== NOT, SHL, SHR, TEST                                                ====}
{====   �������  ����樨 ����� ��������  ᮮ⢥������� ��ᥬ������ ====}
{==== ����権.                                                          ====}
{====--------------------------------------------------------------------====}
{==== P.S.                                                               ====}
{====   ������ ����� ��⤥ন���� ࠡ��� ⮫쪮 � 楫묨 �᫠��.       ====}
{====   ����� ������ ��室����� �����।�⢥���  ��। �᫮� � �� �⮬ ====}
{==== ��⮢���� � ��� ���� 楫�� ᫮�� (�.�. �� ࠧ�������� ������-���� ====}
{==== ᨬ������)                                                         ====}
{==== �ᯮ�짮����� ᨬ����� �� ������ �᫮� ��� ������ ����� ����� ====}
{==== �ਢ��� � �訡��� � ���᫥����, �.�. ����஫� �訡�� �� �ந���- ====}
{==== ����� ��� �᪮७�� ���᫥���.                                    ====}
{====--------------------------------------------------------------------====}
{============================================================================}
                                UNIT STR_Math;
{============================================================================}
                                  INTERFACE
{============================================================================}

CONST    {����⠭�� ��।����騥 १���� �ࠢ����� ��楤�ன StrCMP}
         EQU = 0; {��᫠ ࠢ��}
         AG  = 1; {��ࢮ� �᫮ ����� ��ண�}
         BG  = 2; {��஥ �᫮ ����� ��ࢮ��}
         {����⠭�� ��।����騥 �ਭ���������� � �����⭮�� ⨯�}
         StrByte = 0;      {��᫮ ���� ⨯�� Byte}
         StrWord = 1;      {��᫮ ���� ⨯�� Word}
         StrInteger = 2;   {��᫮ ���� ⨯�� Integer}
         StrLongInt = 3;   {��᫮ ���� ⨯�� LongInt}
         StrComp = 4;      {��᫮ ���� ⨯�� Copm}
         StrUnknown = 254; {��᫮ �� ���� ������� �।� ⨯�� ��᪠��}
         StrError = 255;   {�訡�� �� ��ॢ��� ��ப� � �᫮}
         {���ᨬ���� � ��������� ���祭�� �⠭������ ⨯��}
         StrMaxByte     =  '255';
         StrMinByte     =  '0';
         StrMaxWord     =  '65535';
         StrMinWord     =  '0';
         StrMaxInteger  =  '32767';
         StrMinInteger  =  '-32767';
         StrMaxLongInt  =  '2147483647';
         StrMinLongInt  =  '-2147483647';
         StrMaxComp     =  '9223372036854775807';
         StrMinComp     =  '-9223372036854775807';
         {������ �⠭������ ⨯�� � ����}
         ByteSize    = 8;
         WordSize    = 16;
         IntegerSize = 16;
         LongIntSize = 32;
         CompSize    = 64;

FUNCTION  StrCMP(a, b: String): Byte;   {StrCMP = [EQU, AG, BG] - �ࠢ�����}
FUNCTION  StrSub(a,b: String): String;  {StrSub = a - b}
FUNCTION  StrAdd(a,b: String): String;  {StrAdd = a + b}
FUNCTION  StrMul(a, b: String): String; {StrMul = a * b}
FUNCTION  StrDiv(a, b: String): String; {StrDiv = a div b}
FUNCTION  StrMod(a, b: String): String; {StrMod = a mod b}
FUNCTION  StrABS(a: String): String;    {StrABS = ABS(a)}
FUNCTION  StrNeg(a: String): String;    {StrNeg = -a}
FUNCTION  StrInc(a: String): String;    {StrInc = a + 1}
FUNCTION  StrDec(a: String): String;    {StrDec = a - 1}
FUNCTION  StrSIB(a: String): Word;      {StrSIB = SizeOf(a) in bits}
FUNCTION  StrGetType(a: String): Byte;  {StrGetType = [StrByte, StrWord, StrInteger, StrLongInt, StrComp]}
FUNCTION  StrBINToValue(VAR value; s: Byte; SignType: Boolean): String; {StrBinToValue = value, s = SizeOf(value) in bits}
FUNCTION  ValueTest(VAR value; bit: Word): Boolean;      {ValueTest = TRUE if value[bit] = 1}
PROCEDURE StrToValue(a: String; VAR value; VAR t: Byte); {a --> Byte, Word, Integer, LongInt, Comp}
PROCEDURE StrValueTo(VAR value; t: Byte; VAR a: String); {Byte, Word, Integer, LongInt, Comp  --> a}
PROCEDURE StrValueToBIN(VAR value; VAR s:Word; a: String); {a --> value as bits Intelx86, s =SizeOf(value) in bits}
PROCEDURE ValueAND(VAR value1,value2; vt: Word); {value1 = value1 AND value2}
PROCEDURE ValueOR(VAR value1,value2; vt: Word);  {value1 = value1 OR value2}
PROCEDURE ValueXOR(VAR value1,value2; vt: Word); {value1 = value1 XOR value2}
PROCEDURE ValueNOT(VAR value; vt: Word);         {value = NOT value}
PROCEDURE ValueSHR(Var value; count, vt: Word);  {value = value shr count}
PROCEDURE ValueSHL(Var value; count, vt: Word);  {value = value shl count}

{============================================================================}
                               IMPLEMENTATION
{============================================================================}

FUNCTION StrCMP(a, b: String): Byte;
VAR n, la, lb: Byte;
    am,bm: Boolean;
    c: String;
BEGIN
 la:=Length(a); lb:=Length(b); am:=False; bm:=False;
 IF a[1] = '-' THEN BEGIN am:=true; a[1]:='0'; END;
 IF b[1] = '-' THEN BEGIN bm:=true; b[1]:='0'; END;
 IF am <> bm THEN BEGIN IF am THEN StrCMP:=2 ELSE StrCMP:=1; Exit; END;
 IF la > lb THEN FOR n:=1 TO (la-lb) DO b:='0'+b ELSE
 IF lb > la THEN FOR n:=1 TO (lb-la) DO a:='0'+a;
 IF (am=bm) AND (am=True) THEN BEGIN
  c:=a; a:=b; b:=c;
 END;
 StrCMP:=0;
 FOR n:=1 TO Length(a) DO
  IF NOT (a[n] IN [#48..#57]) OR NOT (b[n] IN [#48..#57]) THEN BEGIN
   StrCMP:=255;
   Exit;
  END;
 FOR n:=1 TO Length(a) DO BEGIN
  IF a[n] > b[n] THEN BEGIN
   StrCMP:=1;
   Exit;
  END;
  IF a[n] < b[n] THEN BEGIN
   StrCMP:=2;
   Exit;
  END;
 END;
END;

{�㭪�� �����頥� ࠧ���� ����� ���� 楫묨 �᫠�� � ��⮬ ����� �ᥫ}
FUNCTION StrSub(a,b: String): String;
VAR n, xa, xb, xc, xx, la, lb, t: Integer;
    c: String;
    am, bm, m: Boolean;
BEGIN
 am:=False; bm:=False; m:=False;
 t:=StrCMP(a,b); IF t = 2 THEN BEGIN c:=a; m:=True; a:=b; b:=c; END;
 IF a[1] = '-' THEN BEGIN am:=true; a[1]:='0'; END;
 IF b[1] = '-' THEN BEGIN bm:=true; b[1]:='0'; END;
 la:=Length(a); lb:=Length(b);
 IF la > lb THEN FOR n:=1 TO (la-lb) DO b:='0'+b ELSE
 IF lb > la THEN FOR n:=1 TO (lb-la) DO a:='0'+a;
 a:='0'+a; b:='0'+b; c:=''; la:=Length(a); xx:=0;
 FOR n:=1 to la DO c:=c+' ';
 FOR n:=la DOWNTO 1 DO BEGIN
  IF NOT bm OR am THEN xc:=(Ord(a[n])-48)-(Ord(b[n])-48)-xx ELSE
                       xc:=(Ord(a[n])-48)+(Ord(b[n])-48)+xx;
  IF xc < 0 THEN BEGIN xc:=xc+10; xx:=1; END ELSE xx:=xc DIV 10;
  c[n]:=Chr((xc MOD 10)+48);
 END;
 Dec(n);
 REPEAT
  inc(n);
 UNTIL (c[n] <> '0') OR (n = la);
 Delete(c,1,n-1);
 IF m THEN c:='-'+c;
 StrSub:=c;
END;

{�㭪�� �����頥� �㬬� ���� 楫�� �ᥫ ���뢠� ����� �ᥫ}
FUNCTION StrAdd(a,b: String): String;
VAR c: String;
BEGIN
 IF (a[1] <> '-') AND (b[1] <> '-') THEN b:='-'+b ELSE
 IF (a[1] = '-') AND (b[1] <> '-') THEN BEGIN
  c:=a;
  a:=b;
  b:=c; Delete(b,1,1);
 END ELSE
 IF (a[1] <> '-') AND (b[1] = '-') THEN Delete(b,1,1) ELSE
 IF (a[1] = '-') AND (b[1] = '-') THEN Delete(b,1,1);
 StrAdd:=StrSub(a,b);
END;

{�㭪�� �����頥� �ந�������� ���� 楫�� �ᥫ ���뢠� ����� �ᥫ}
FUNCTION StrMul(a, b: String): String;
VAR n1, n, xc, xx, la, lb: Integer;
    c, r: String;
    am, bm, m: Boolean;
BEGIN
 am:=False; bm:=False;
 IF a[1] = '-' THEN BEGIN am:=true; Delete(a,1,1); END;
 IF b[1] = '-' THEN BEGIN bm:=true; Delete(b,1,1); END;
 m:=am XOR bm; a:='0'+a; xx:=0; r:='0'; la:=Length(a); lb:=Length(b);
 FOR n1:=lb DOWNTO 1 DO BEGIN
  c:='';
  FOR n:=la DOWNTO 1 DO BEGIN
   xc:=(Ord(a[n])-48)*(Ord(b[n1])-48)+xx;
   xx:=xc DIV 10;
   c:=Chr((xc MOD 10)+48)+c;
  END;
  IF (lb-n1) > 0 THEN FOR n:=1 to (lb-n1) DO c:=c+'0';
  r:=StrAdd(r,c);
 END;
 n:=0;
 REPEAT
  inc(n);
 UNTIL (r[n] <> '0') OR (n=Length(r));
 Delete(r,1,n-1);
 IF m THEN r:='-'+r;
 StrMul:=r;
END;

{�㭪�� �����頥� ��⭮� ����� ���� 楫묨 �᫠�� ���뢠� ����� �ᥫ}
FUNCTION StrDiv(a, b: String): String;
VAR n2, n1, n, la: Integer;
    lla, tc1, tc2, tc3, c: String;
    am, bm, m: Boolean;
BEGIN
 StrDiv:='0';
 am:=False; bm:=False;
 IF a[1] = '-' THEN BEGIN am:=true; Delete(a,1,1); END;
 IF b[1] = '-' THEN BEGIN bm:=true; Delete(b,1,1); END;
 IF (a = '0') OR (b = '0') OR (StrCMP(a,b) = 2) THEN Exit;
 m:=am XOR bm; la:=Length(a); c:=''; StrDiv:='0'; n:=0; tc2:='1'; lla:=a;
 REPEAT
  Inc(n);
  lla:=a; la:=Length(a); n1:=1;
  IF StrCMP(a,'0') = 0 THEN c:=c+a ELSE BEGIN
   REPEAT
    IF (n1 > 1) AND (tc2='0') THEN BEGIN c:=c+'0';
     IF Length(tc2) = 1 THEN tc2:='0' ELSE Delete(tc2,Length(tc2),1);
    END;
    tc1:=Copy(a,1,n1);
    inc(n1);
   UNTIL (StrCMP(tc1,b) < 2) OR (n1-1 = la);
   tc3:=tc1;
   Delete(a,1,Length(tc1));
   tc2:=tc1;
   n2:=0;
   REPEAT
    Inc(n2);
    tc1:=tc2;
    tc2:=StrSub(tc2,b);
   UNTIL (StrCMP(tc2,b) = 2) OR (n2 > 9);
   IF (tc2[1] <> '-') THEN c:=c+Chr(n2+48) ELSE
    IF (tc3 = Copy(tc2,2,Length(tc2)-1)) THEN c:=c+'0';
   IF a <> '' THEN a:=tc2+a;
   IF a[1] = '0' THEN Delete(a,1,1);
  END;
 UNTIL (StrCMP(lla,b) = 2) OR (a='');
 IF m THEN c:='-'+c;
 StrDiv:=c;
END;

{�㭪�� �����頥� ���⮪ �� �������}
FUNCTION StrMod(a, b: String): String;
BEGIN
 StrMod:=StrSub(a,StrMul(b,StrDiv(a,b)));
END;

{�㭪�� �����頥� �᫮ �� �����}
FUNCTION StrABS(a: String): String;
BEGIN
 IF a[1]='-' THEN Delete(a,1,1);
 StrABS:=a;
END;

{����� ����� ���� �� ��⨢��������}
FUNCTION  StrNeg(a: String): String;
BEGIN
 IF a[1]='-' THEN Delete(a,1,1) ELSE a:='-'+a;
 StrNeg:=a;
END;

{�㭪�� �����頥� ���६��� �᫠ �࠭�饣��� � ��ப�}
FUNCTION  StrInc(a: String): String;    {StrInc = a + 1}
BEGIN
 StrInc:=StrAdd(a,'1');
END;

{�㭪�� �����頥� ���ਬ��� �᫠ �࠭�饣��� � ��ப�}
FUNCTION  StrDec(a: String): String;    {StrDec = a - 1}
BEGIN
 StrDec:=StrSub(a,'1');
END;

{�㭪�� �����頥� ࠧ��� �᫠ � ����}
FUNCTION  StrSIB(a: String): Word;
VAR w: Word;
BEGIN
 w:=0;
 REPEAT
  a:=StrDiv(a,'2');
  Inc(w);
 UNTIL a = '0';
 StrSIB:=w;
END;

{�㭪�� �����頥� ⨯ �᫠ ����� �࠭���� � ��ப�}
FUNCTION StrGetType(a: String): Byte;
VAR t,r: Byte;
BEGIN
 r:=StrUnknown;
 IF StrCMP(a,'9223372036854775808') = BG THEN
  IF StrCMP(a,'-9223372036854775808') = AG THEN BEGIN
   r:=StrComp;
   IF StrCMP(a,'2147483648') = BG THEN
    IF StrCMP(a,'-2147483648') = AG THEN BEGIN
     r:=StrLongInt;
     IF StrCMP(a,'65536') = BG THEN BEGIN
       r:=StrWord;
       IF StrCMP(a,'32768') = BG THEN
        IF StrCMP(a,'-32768') = AG THEN BEGIN
         r:=StrInteger;
         IF StrCMP(a,'256') = BG THEN
          IF StrCMP(a,'-1') = AG THEN r:=StrByte;
        END ELSE r:=StrLongInt;
      END;
    END;
  END ELSE r:=StrUnknown;
 StrGetType:=r;
END;

{�㭪�� ��ॢ���� �� �᫮ �࠭���� � value � ��ப�}
FUNCTION StrBINToValue(VAR value; s: Byte; SignType: Boolean): String;
VAR b: ARRAY [0..1] OF Byte ABSOLUTE value;
    a,n1,n,n2: LongInt;
    ts,r,m,m1: String;
BEGIN
 r:='0';
 m1:='1';
 FOR n1:=1 TO s DO m1:=StrMul(m1,'2');
 FOR n:=s-1 DOWNTO 0 DO BEGIN
  IF n > 30 THEN BEGIN
   ts:='1';
   FOR n1:=1 TO n-1 DO ts:=StrMul(ts,'2');
   ts:=StrMul(ts,'2');
  END ELSE BEGIN
   a:=1 SHL n;
   StrValueTo(a,StrLongInt,ts);
  END;
  IF n = (s-1) THEN m:=ts;
  IF (b[n div 8] AND (1 SHL (n MOD 8))) = (1 SHL (n MOD 8)) THEN r:=StrAdd(r,ts);
 END;
 IF (StrCMP(r,m) = AG) AND  SignType THEN
   r:=StrSub(r,m1);
 StrBINToValue:=r;
END;

{�㭪�� �����頥� TRUE �᫨ ��� � ����஬  bit ࠢ�� 1}
FUNCTION  ValueTest(VAR value; bit: Word): Boolean;
VAR a: ARRAY [0..1] OF Byte ABSOLUTE value;
BEGIN
 ValueTest:=False;
 IF (a[bit DIV 8] AND (1 SHL (bit MOD 8))) = (1 SHL (bit MOD 8)) THEN
  ValueTest:=True;
END;

PROCEDURE StrToValue(a: String; VAR value; VAR t: Byte);
VAR Sign: Boolean;
    tc: Comp ABSOLUTE value;
    tcc: Comp;
    b: Byte ABSOLUTE tcc;
    ttc, lv: Comp;
    n,n1,ss: Integer;
    tt: Byte;
BEGIN
 Sign:=False; {+}
 t:=StrGetType(a);
 tc:=0;
 IF t = StrUnknown THEN Exit;
 IF a[1]='-' THEN BEGIN Sign:=True; Delete(a,1,1); END; {-}
 ss:=Length(a);
 FOR n:=1 TO ss DO BEGIN
  tcc:=1;
  FOR n1:=1 TO ss-n DO tcc:=tcc*10;
  tcc:=tcc*(Ord(a[n])-48);
  tt:=t;
  t:=StrError;
  IF (a[n] < '0') OR (a[n] > '9') THEN Exit;
  t:=tt;
  tc:=tc+tcc;
 END;
 IF Sign THEN tc:=-tc;
END;

PROCEDURE StrValueTo(VAR value; t: Byte; VAR a: String);
VAR tc: Comp ABSOLUTE value;
    tl: LongInt ABSOLUTE value;
    tw: Word ABSOLUTE value;
    ti: Integer ABSOLUTE value;
    tb: Byte ABSOLUTE value;
    ts: String;
    tcc: Comp;
    b: Byte ABSOLUTE tcc;
    ttc, lv: Comp;
    n,n1: Integer;
BEGIN
 lv:=tc;
 a:='';
 IF (tc < 0) AND (t = StrComp) THEN a:=a+'-';
 IF t < StrComp THEN BEGIN
  CASE t OF
   StrByte: Str(tb, ts);
   StrWord: Str(tw, ts);
   StrInteger: Str(ti, ts);
   StrLongInt: Str(tl, ts);
  END;
  a:=ts;
 END ELSE BEGIN
  {��� Comp}
  tc:=ABS(tc);
  n:=18;
  ts:='';
  REPEAT
   tcc:=1;
   for n1:=1 to n do tcc:=tcc*10;
   ttc:=tcc;
   tcc:=Trunc(tc/tcc);
   ts:=ts+Chr(b+48);
   tc:=tc-(b)*ttc;
   Dec(n)
  UNTIL n = -1;
  n:=0;
  REPEAT
   Inc(n);
  UNTIL ts[n] <> '0';
  Delete(ts,1,n-1);
  a:=a+ts;
 END;
 tc:=lv;
END;

{��楤�� ��ॢ���� ��ப� a � ��⮢� ��� �⠭���� Intelx86}
PROCEDURE StrValueToBIN(VAR value; VAR s:Word; a: String);
VAR tc: Comp ABSOLUTE value;
    tl: LongInt ABSOLUTE value;
    ti: Integer ABSOLUTE value;
    tw: Word ABSOLUTE value;
    tb: Byte ABSOLUTE value;
    tba: ARRAY [0..65] OF Byte ABSOLUTE value;
    t,n: Byte;
    ta,ts,la: String;
    bt: Char;
    sign: Boolean;
BEGIN
 t:=StrGetType(a);
 tc:=0;
 IF t <> StrUnknown THEN BEGIN
  StrToValue(a,tc,t);
  CASE t OF
   StrByte: n:=ByteSize;
   StrWord: n:=WordSize;
   StrInteger: n:=IntegerSize;
   StrLongInt: n:=LongIntSize;
   StrComp: n:=CompSize;
  END;
 END ELSE BEGIN
  {���⠭����� ⨯}
  IF a[1]='-' THEN BEGIN
   sign:=True;
   Delete(a,1,1);
   a:=StrAdd(a,'2');
  END;
  la:=a;
  ta:=a;
  ts:=ta;
  FillChar(tba,65,0);
  n:=0;
  REPEAT
   ts:=StrDiv(ts,'2'); {����� ���� �� �������}
   ta:=StrSub(ta,StrMul(ts,'2')); {���⮪ �� �������}
   IF ta[1] = #49 THEN tba[n DIV 8]:=tba[n DIV 8] OR (1 SHL (n MOD 8)); {��⠭���� ���}
   ta:=ts;
   Inc(n);
  UNTIL ts = '0';
 END;
 s:=(n DIV 8); {������ ᮧ������ ��६����� � ����}
 IF n MOD 8 <> 0 THEN Inc(s);
 s:=s*8;
 a:=la; {���⠭�������� ��ப�}
END;

{��楤�� �ந������ �������� ������ AND � ��� �᫮� ࠧ��஬ vt ���}
PROCEDURE ValueAND(VAR value1,value2; vt: Word);
VAR n: Byte;
    a: ARRAY [0..1] OF Byte ABSOLUTE value1;
    b: ARRAY [0..1] OF Byte ABSOLUTE value2;
BEGIN
 FOR n:=0 to (vt DIV 8)-1 DO a[n]:=a[n] AND b[n];
END;

{��楤�� �ந������ �������� ������ OR � ��� �᫮� ࠧ��஬ vt ���}
PROCEDURE ValueOR(VAR value1,value2; vt: Word);
VAR n: Byte;
    a: ARRAY [0..1] OF Byte ABSOLUTE value1;
    b: ARRAY [0..1] OF Byte ABSOLUTE value2;
BEGIN
 FOR n:=0 to (vt DIV 8)-1 DO a[n]:=a[n] OR b[n];
END;

{��楤�� �ந������ �������� ������ XOR � ��� �᫮� ࠧ��஬ vt ���}
PROCEDURE ValueXOR(VAR value1,value2; vt: Word);
VAR n: Byte;
    a: ARRAY [0..1] OF Byte ABSOLUTE value1;
    b: ARRAY [0..1] OF Byte ABSOLUTE value2;
BEGIN
 FOR n:=0 to (vt DIV 8)-1 DO a[n]:=a[n] XOR b[n];
END;

{��楤�� �ந������ �������� ������ NOT � ��� �᫮� ࠧ��஬ vt ���}
PROCEDURE ValueNOT(VAR value; vt: Word);
VAR n: Byte;
    a: ARRAY [0..1] OF Byte ABSOLUTE value;
BEGIN
 FOR n:=0 to (vt DIV 8)-1 DO a[n]:=NOT a[n];
END;

{�������� ᮤ�ন��� value �� count ��⮢ ��ࠢ�}
PROCEDURE ValueSHR(Var value; count, vt: Word);
VAR n, n2: Byte;
    a: ARRAY [0..1] OF Byte ABSOLUTE value;
BEGIN
 FOR n:=1 TO count DO FOR n2:=0 TO (vt DIV 8)-1 DO a[n2]:=a[n2] SHR 1;
END;

{�������� ᮤ�ন��� value �� count ��⮢ �����}
PROCEDURE ValueSHL(Var value; count, vt: Word);
VAR n,n2: Byte;
    a: ARRAY [0..1] OF Byte ABSOLUTE value;
BEGIN
 FOR n:=1 TO count DO FOR n2:=0 TO (vt DIV 8)-1 DO a[n2]:=a[n2] SHL 1;
END;

{============================================================================}
BEGIN
END.
{============================================================================}