{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
UNIT SVML_U1;
INTERFACE
 USES Crt, SVM_n, SVML_U2, SEMME_e;
 PROCEDURE LoadFile;
 PROCEDURE ClearAllFlags;
 PROCEDURE CorectRegFlag;
 PROCEDURE CorectComp(c: Comp);
 PROCEDURE CompToInt(c: Comp);
 PROCEDURE CompToLongInt(c: Comp);
 PROCEDURE FlagsByteTest(c2: Comp);
 PROCEDURE FlagsRegTest(r: Byte; cc: Comp);
 FUNCTION  CompAND(cc1,cc2: Comp): Comp;
 FUNCTION  CompOR(cc1,cc2: Comp): Comp;
 FUNCTION  CompXOR(cc1,cc2: Comp): Comp;
 FUNCTION  CompNOT(cc: Comp): Comp;
 FUNCTION  DivComp(c1, c2: Comp): Comp;
 FUNCTION  GetRB(n: Byte): Byte;
 FUNCTION  GetRW(n: Byte): Integer;
 FUNCTION  GetRL(n: Byte): LongInt;
 FUNCTION  GetRC(n: Byte): Comp;
 PROCEDURE SetRB(n, b: Byte);
 PROCEDURE SetRW(n: Byte; i: Integer);
 PROCEDURE SetRL(n: Byte; l: LongInt);
 PROCEDURE SetRC(n: Byte; c1: Comp);
 FUNCTION  GetTypeC(c: Comp): Byte;
 PROCEDURE GetR(n, s: Byte; VAR reg);
 PROCEDURE SetR(n, s, s1: Byte; VAR reg);
IMPLEMENTATION
{============================================================================}

 PROCEDURE ClearAllFlags;
 BEGIN
  o_f:=0; s_f:=0; z_f:=0; p_f:=0; a_f:=0; c_f:=0; g_f:=0; e_f:=0; l_f:=0;
 END;

 PROCEDURE CorectRegFlag;
 BEGIN
  RegArea.LFS:=0;
  RegArea.LFS:=o_f+2*s_f+4*z_f+8*c_f+16*p_f+32*a_f;
 END;

 PROCEDURE CorectComp(c: Comp);
 VAR wcc: Integer ABSOLUTE c;
     lcc: LongInt ABSOLUTE c;
     cc: Comp ABSOLUTE c;
 BEGIN
   b1:=GetTypeC(c1);
  IF c1 < 0 THEN BEGIN
   cc:=-cc;
   CASE b1 OF
    1: cc:=-cc;
    2: wcc:=-wcc;
    4: lcc:=-lcc;
    8: cc:=-cc;
   END;
  END;
 END;

 PROCEDURE CompToInt(c: Comp);
 VAR wcc: Integer ABSOLUTE c;
     cc: Comp ABSOLUTE c;
 BEGIN
  IF c1 < 0 THEN BEGIN
   b1:=GetTypeC(c1);
   cc:=-cc;
   CASE b1 OF
    2: wcc:=-wcc;
    ELSE cc:=-cc;
   END;
  END;
 END;

 PROCEDURE CompToLongInt(c: Comp);
 VAR lcc: LongInt ABSOLUTE c;
     cc: Comp ABSOLUTE c;
 BEGIN
  IF c1 < 0 THEN BEGIN
   b1:=GetTypeC(c1);
   cc:=-cc;
   CASE b1 OF
    4: lcc:=-lcc;
    ELSE cc:=-cc;
   END;
  END;
 END;

 PROCEDURE FlagsByteTest(c2: Comp);
 BEGIN
  ClearAllFlags;
  CorectRegFlag;
  IF GetTypeC(c2) > 1 THEN o_f:=1;
  IF Abs(c2) - Abs(DivComp(c2,2)*2) = 1 THEN p_f:=1;
  IF c2 < 0 THEN s_f:=1 ELSE
  IF c2 = 0 THEN z_f:=1;
 END;

 PROCEDURE FlagsRegTest(r: Byte; cc: Comp);
 BEGIN
  ClearAllFlags;
  IF GetTypeC(cc) > RegSize[r] THEN o_f:=1;
  IF cc - DivComp(cc,2)*2 = 1 THEN p_f:=1;
  IF cc < 0 THEN s_f:=1 ELSE
  IF cc = 0 THEN z_f:=1;
  CorectRegFlag;
 END;

 {Функции выполняют логические операции над типом Comp}
 FUNCTION CompAND(cc1,cc2: Comp): Comp;
 VAR lcc1: ARRAY [0..7] OF Byte ABSOLUTE cc1;
     lcc2: ARRAY [0..7] OF Byte ABSOLUTE cc2;
 BEGIN
  lcc1[0]:=lcc1[0] AND lcc2[0];
  lcc1[1]:=lcc1[1] AND lcc2[1];
  lcc1[2]:=lcc1[2] AND lcc2[2];
  lcc1[3]:=lcc1[3] AND lcc2[3];
  lcc1[4]:=lcc1[4] AND lcc2[4];
  lcc1[5]:=lcc1[5] AND lcc2[5];
  lcc1[6]:=lcc1[6] AND lcc2[6];
  lcc1[7]:=lcc1[7] AND lcc2[7];
  CompAND:=cc1;
 END;

 FUNCTION CompOR(cc1,cc2: Comp): Comp;
 VAR lcc1: ARRAY [0..7] OF Byte ABSOLUTE cc1;
     lcc2: ARRAY [0..7] OF Byte ABSOLUTE cc2;
 BEGIN
  lcc1[0]:=lcc1[0] OR lcc2[0];
  lcc1[1]:=lcc1[1] OR lcc2[1];
  lcc1[2]:=lcc1[2] OR lcc2[2];
  lcc1[3]:=lcc1[3] OR lcc2[3];
  lcc1[4]:=lcc1[4] OR lcc2[4];
  lcc1[5]:=lcc1[5] OR lcc2[5];
  lcc1[6]:=lcc1[6] OR lcc2[6];
  lcc1[7]:=lcc1[7] OR lcc2[7];
  CompOR:=cc1;
 END;

 FUNCTION CompXOR(cc1,cc2: Comp): Comp;
 VAR lcc1: ARRAY [0..7] OF Byte ABSOLUTE cc1;
     lcc2: ARRAY [0..7] OF Byte ABSOLUTE cc2;
 BEGIN
  lcc1[0]:=lcc1[0] XOR lcc2[0];
  lcc1[1]:=lcc1[1] XOR lcc2[1];
  lcc1[2]:=lcc1[2] XOR lcc2[2];
  lcc1[3]:=lcc1[3] XOR lcc2[3];
  lcc1[4]:=lcc1[4] XOR lcc2[4];
  lcc1[5]:=lcc1[5] XOR lcc2[5];
  lcc1[6]:=lcc1[6] XOR lcc2[6];
  lcc1[7]:=lcc1[7] XOR lcc2[7];
  CompXOR:=cc1;
 END;

 FUNCTION CompNOT(cc: Comp): Comp;
 VAR lcc: ARRAY [0..7] OF Byte ABSOLUTE cc;
 BEGIN
  lcc[0]:=NOT lcc[0];
  lcc[1]:=NOT lcc[1];
  lcc[2]:=NOT lcc[2];
  lcc[3]:=NOT lcc[3];
  lcc[4]:=NOT lcc[4];
  lcc[5]:=NOT lcc[5];
  lcc[6]:=NOT lcc[6];
  lcc[7]:=NOT lcc[7];
  CompNOT:=cc;
 END;

 {Функция выполняет деление типа Comp без округления}
 FUNCTION DivComp(c1, c2: Comp): Comp;
 VAR c: Comp;
 BEGIN
  c:=c1;
  c1:=c1/c2;
  IF (Abs(c) - Abs(c1*c2)) < 0 THEN BEGIN
   IF c1 < 0 THEN c1:=c1+1 ELSE c1:=c1-1;
  END;
  DivComp:=c1;
 END;

 {Процедуры и функции для работы с регистрами}

 FUNCTION GetRB(n: Byte): Byte;
 BEGIN
  GetRB:=Mem[AddrSeg:RegTable[n]+AddrOfs];
 END;

 FUNCTION GetRW(n: Byte): Integer;
 VAR w: Integer;
     b: ARRAY [0..1] OF Byte ABSOLUTE w;
 BEGIN
  b[0]:=Mem[AddrSeg:RegTable[n]+AddrOfs];
  b[1]:=Mem[AddrSeg:RegTable[n]+AddrOfs+1];
  GetRW:=w;
 END;

 FUNCTION GetRL(n: Byte): LongInt;
 BEGIN
  GetRL:=MemL[AddrSeg:RegTable[n]+AddrOfs];
 END;

 FUNCTION GetRC(n: Byte): Comp;
 VAR c: Comp;
     l: ARRAY [0..1] OF LongInt ABSOLUTE c;
 BEGIN
  l[0]:=MemL[AddrSeg:RegTable[n]+AddrOfs];
  l[1]:=MemL[AddrSeg:RegTable[n]+AddrOfs+4];
  GetRC:=c;
 END;

 PROCEDURE SetRB(n, b: Byte);
 BEGIN
  Mem[AddrSeg:RegTable[n]+AddrOfs]:=b;
 END;

 PROCEDURE SetRW(n: Byte; i: Integer);
 VAR w: Integer;
    b: ARRAY [0..1] OF Byte ABSOLUTE w;
 BEGIN
  w:=i;
  Mem[AddrSeg:RegTable[n]+AddrOfs]:=b[0];
  Mem[AddrSeg:RegTable[n]+AddrOfs+1]:=b[1];
 END;

 PROCEDURE SetRL(n: Byte; l: LongInt);
 BEGIN
  MemL[AddrSeg:RegTable[n]+AddrOfs]:=l;
 END;

 PROCEDURE SetRC(n: Byte; c1: Comp);
 VAR c: Comp;
     l: ARRAY [0..1] OF LongInt ABSOLUTE c;
 BEGIN
  c:=c1;
  MemL[AddrSeg:RegTable[n]+AddrOfs]:=l[0];
  MemL[AddrSeg:RegTable[n]+AddrOfs+4]:=l[1];
 END;

 FUNCTION  GetTypeC(c: Comp): Byte;
 BEGIN
  IF (c >= 0) AND (c <= 255) THEN GetTypeC:=1 ELSE
  IF (c >= -32768) AND (c <= 32768) THEN GetTypeC:=2 ELSE
  IF (c >= (-2147483647-1)) AND (c <= 2147483647) THEN GetTypeC:=4 ELSE
     GetTypeC:=8;
 END;

 PROCEDURE GetR(n, s: Byte; VAR reg);
 VAR b: Byte ABSOLUTE reg;
     w: Integer ABSOLUTE reg;
     l: LongInt ABSOLUTE reg;
     c: Comp ABSOLUTE reg;
 BEGIN
  CASE s OF
   1: b:=GetRB(n);
   2: w:=GetRW(n);
   4: l:=GetRL(n);
   8: c:=GetRC(n);
  END;
 END;

 PROCEDURE SetR(n, s, s1: Byte; VAR reg);
 VAR b: Byte ABSOLUTE reg;
     w: Integer ABSOLUTE reg;
     l: LongInt ABSOLUTE reg;
     c: Comp ABSOLUTE reg;
     b1: Byte;
     w1: Integer;
     l1: LongInt;
     c1: Comp;
     w2: Integer ABSOLUTE l1;
     w3: Integer ABSOLUTE c1;
     l2: LongInt ABSOLUTE c1;
 BEGIN
  c1:=0;
  CASE s1 OF
   1: BEGIN b1:=b; w1:=b; l1:=b; c1:=b; END;
   2: BEGIN b1:=b; w1:=w; l1:=w; c1:=w; END;
   4: BEGIN b1:=b; w1:=w; l1:=l; c1:=l; END;
   8: BEGIN b1:=b; w1:=w; l1:=l; c1:=c; END;
  END;
  CASE s OF
   1: SetRB(n,b1);
   2: SetRW(n,w1);
   4: SetRL(n,l1);
   8: SetRC(n,c1);
  END;
 END;


 {Процедура, которая загружает файл в память и формирует адресное пространство
  непосредственно для исполнения}
 PROCEDURE LoadFile;
  {Функции чтения из файла}
  FUNCTION GetC: Comp;
  VAR c: Comp;
      b: ARRAY [0..7] OF Byte ABSOLUTE c;
  BEGIN
   Read(SourceFile,b[0]);
   Read(SourceFile,b[1]);
   Read(SourceFile,b[2]);
   Read(SourceFile,b[3]);
   Read(SourceFile,b[4]);
   Read(SourceFile,b[5]);
   Read(SourceFile,b[6]);
   Read(SourceFile,b[7]);
   GetC:=c;
  END;
  FUNCTION GetCL: LongInt;
  VAR c: Comp;
      b: ARRAY [0..7] OF Byte ABSOLUTE c;
      l: LongInt ABSOLUTE c;
  BEGIN
   Read(SourceFile,b[0]);
   Read(SourceFile,b[1]);
   Read(SourceFile,b[2]);
   Read(SourceFile,b[3]);
   Read(SourceFile,b[4]);
   Read(SourceFile,b[5]);
   Read(SourceFile,b[6]);
   Read(SourceFile,b[7]);
   GetCL:=l;
  END;
  FUNCTION GetB: Byte;
  VAR b: Byte;
  BEGIN
   Read(SourceFile,b);
   GetB:=b;
  END;
  FUNCTION GetW: Integer;
  VAR w: Integer;
      b: ARRAY [0..1] OF Byte ABSOLUTE w;
  BEGIN
   Read(SourceFile,b[0]);
   Read(SourceFile,b[1]);
   GetW:=w;
  END;
  FUNCTION GetL: LongInt;
  VAR l: LongInt;
      b: ARRAY [0..3] OF Byte ABSOLUTE l;
  BEGIN
   Read(SourceFile,b[0]);
   Read(SourceFile,b[1]);
   Read(SourceFile,b[2]);
   Read(SourceFile,b[3]);
   GetL:=l;
  END;
  {Основной текст процедуры}
  BEGIN
   Assign(SourceFile,SourceName);
   Reset(SourceFile);
   Info.Item[0]:=3;
   {Загрузка описателя файла}
   FOR n:=1 TO 76 DO BEGIN
    Read(SourceFile,b);
    Info.Item[n]:=b;
   END;
   {Проверка на номер версии}
   IF Info.Version <> $11 THEN BEGIN
    Close(SourceFile);
    Halt(0);
   END;
   if Loc <> 1 then Write(' SVM v1.0 initilising. Please wait...');
   {Инициализация виртуальной памяти}
   InitSVM(0,2048*PageSize,1,VMDISK[1],VMFile);
   if Loc <> 1 then begin
    GotoXY(1,WhereY);
    WriteLn(' SVM v1.0 initilising. Please wait - Ok');
    Write(' Loading bytecode SVM file...');
   end;
   {Выделяем память для текста программы, кода и стека}
   PRG.Init(Info.CodeSize+Info.DataSize+Info.StackSize,1);
   r:=Info.CodefSize;
   l:=Trunc(r);
   {Загружаем код программы}
   FOR n:=0 TO l-1 DO BEGIN
    Read(SourceFile,b);
    PRG.PutB(n,b);
   END;
   r:=Info.DataSize;
   l:=l+Trunc(r)-1;

   {Загружаем и распаковываем данные программы}
   REPEAT
    Read(SourceFile,b);
    IF b = 0 THEN BEGIN n:=n+GetCL; END ELSE
    IF b = 1 THEN BEGIN n:=n+GetCL*2; END ELSE
    IF b = 2 THEN BEGIN n:=n+GetCL*4; END ELSE
    IF b = 3 THEN BEGIN n:=n+GetCL*8; END ELSE
    IF b = 4 THEN BEGIN FOR n1:=1 TO GetCL DO PRG.PutB(n1+n,GetB); n:=n+n1; END ELSE
    IF b = 5 THEN BEGIN FOR n1:=1 TO GetCL DO PRG.PutI(n1+n,GetW); n:=n+n1*2; END ELSE
    IF b = 6 THEN BEGIN FOR n1:=1 TO GetCL DO PRG.PutL(n1+n,GetL); n:=n+n1*4; END ELSE
    IF b = 7 THEN BEGIN FOR n1:=1 TO GetCL DO PRG.PutC(n1+n,GetC); n:=n+n1*8; END ELSE
    IF b = 8 THEN BEGIN PRG.PutB(n+1,GetB); n:=n+1; END ELSE
    IF b = 9 THEN BEGIN PRG.PutI(n+1,GetW); n:=n+2; END ELSE
    IF b = 10 THEN BEGIN PRG.PutL(n+1,GetL); n:=n+4; END ELSE
    IF b = 11 THEN BEGIN PRG.PutC(n+1,GetC); n:=n+8; END;
   UNTIL n >= l;
   {Так как всю информацию мы загрузили, можно закрывать файл}
   Close(SourceFile);
   if Loc <> 1 then begin
    GotoXY(1,WhereY);
    WriteLn(' Loading bytecode SVM file - Ok');
   end;
 END;

END.