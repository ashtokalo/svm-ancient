{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
UNIT SVML_U2;
INTERFACE
 USES SVM_n, SFI, Crt;

 TYPE TPROCEDURE = PROCEDURE;

 TYPE TStream = RECORD
  FileName: String;                 {имя файла или потока}
  DFile: File Of Byte;              {дисковый файл}
  MarkPos: LongInt;                 {сохраненная позиция}
  Status: Byte;                     {режим работы потока}
  Init, Done,                       {инициализация и деинициализация}
  ReadByte, ReadArray, ReadAndStay, {чтение}
  WriteByte, WriteArray,            {запись}
  Skeep,                            {пропуск}
  GetTotal,                         {всего}
  Mark, BackToMark, ReInit,         {положение}
  GetType: TPROCEDURE;              {тип потока}
 END;

 TYPE  PStream = ^TStream;

 TYPE TSourceFile = RECORD
  CASE Byte OF
  1: (
  SVM: String[3];
  Version: Byte;
  CodeSize,
  DataSize,
  StackSize,
  StartCode,
  StartData,
  CodefSize,
  DatafSize,
  EntryPoint,
  FinishPoint: Comp; );
  2: (Item: ARRAY [0..76] OF Byte );
 END;

CONST {Карта расположения регистров в памяти}
      RegTable: ARRAY [0..40] OF Word =
      (0, 1,     {AL, AH}
       8, 9,     {BL, BH}
       16, 17,   {CL, CH}
       24, 25,   {DL, DH}
       0, 8,     {AX, BX}
       16, 24,   {CX, DX}
       32, 40,   {SS, FS}
       48, 56,   {SP, IP}
       64, 72,   {EP, FP}
       80,       {GP}
       0, 8,     {EAX, EBX}
       16, 24,   {ECX, EDX}
       32, 40,   {ESS, EFS}
       48, 56,   {ESP, EIP}
       64, 72,   {EEP, EFP}
       80,       {EGP}
       0, 8,     {LAX, LBX}
       16, 24,   {LCX, LDX}
       32, 40,   {LSS, LFS}
       48, 56,   {LSP, LIP}
       64, 72,   {LEP, LFP}
       80);      {LGP}
      RegSize: ARRAY [0..40] OF Byte =
      (1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4,4,4,4,4,8,8,8,8,8,8,8,8,8,8,8);
      VarSize1: ARRAY [0..28] OF Byte =
       (3,3,4,3,4,6,10,10,11,3,3,4,6,10,4,4,5,7,11,10,10,11,13,17,11,11,12,14,18);
      VarSize3: ARRAY [0..4] OF Byte =
       (3,3,4,10,11);
      VarSize4: ARRAY [0..16] OF Byte =
       (2,2,3,9,10,2,3,9,10,2,3,9,10,2,3,9,10);
      VarSize5: ARRAY [0..3] OF Byte =
       (2,3,5,9);
      VarSize6: ARRAY [0..4] OF Byte =
       (3,3,4,6,10);
      VarSize7: ARRAY [0..3] OF Byte =
       (2,3,9,10);
      VarSize8: ARRAY [0..3] OF Byte =
       (3,4,10,11);

 TYPE SVMRegisters = RECORD
  CASE Byte OF
  1: (LAX,     LBX,     LCX,     LDX,     LSS,     LFS,     LSP,     LIP,     LEP,     LFP,     LGP: Comp);
  2: (EAX,EAXN,EBX,EBXN,ECX,ECXN,EDX,EDXN,ESS,ESSN,EFS,EFSN,ESP,ESPN,EIP,EIPN,EEP,EEPN,EFP,EFPN,EGP,EGPN: LongInt);
  3: (AX,AXN,AXN1,AXN2,
      BX,BXN,BXN1,BXN2,
      CX,CXN,CXN1,CXN2,
      DX,DXN,DXN1,DXN2,
      SS,SSN,SSN1,SSN2,
      FS,FSN,FSN1,FSN2,
      SP,SPN,SPN1,SPN2,
      IP,IPN,IPN1,IPN2,
      EP,EPN,EPN1,EPN2,
      FP,FPN,FPN1,FPN2,
      GP,GPN,GPN1,GPN2: Integer);
  4:( AL,AH,AL1,AH1,AL2,AH2,AL3,AH3,
      BL,BH,BL1,BH1,BL2,BH2,BL3,BH3,
      CL,CH,CL1,CH1,CL2,CH2,CL3,CH3,
      DL,DH,DL1,DH1,DL2,DH2,DL3,DH3: Byte);
  5: (Item: ARRAY [0..87] OF Byte);
 END;

 TYPE TCom1A = ARRAY [0..28] OF Pointer;
 TYPE TCom3A = ARRAY [0..4] OF Pointer;
 TYPE TCom4A = ARRAY [0..16] OF Pointer;
 TYPE TCom5A = ARRAY [0..3] OF Pointer;
 TYPE TCom6A = ARRAY [0..4] OF Pointer;
 TYPE TCom7A = ARRAY [0..3] OF Pointer;
 TYPE TCom8A = ARRAY [0..3] OF Pointer;

 VAR SourceFile: File Of Byte;  {Файл из которого загружается программа}
     SourceName: String;        {Имя файла программы}
     Info: TSourceFile;         {Информация о загруженном файле}
     N, N1, L, l1, l2: LongInt;
     b, b1, b2, r1, r2, ComN, ComD, GrMode,
     o_f, s_f, z_f, c_f, p_f, a_f, {Флаги процессора}
     g_f, e_f, l_f: Byte;       {Флаги перехода, в программу не возвращаются}
     WES: Byte;                 {Размер элемента - тип}
     PRG: OVector;              {Адресное пространство программы}
     r: Real;
     AddrSeg,       {Сегмент регистрового блока}
     AddrOfs: Word; {Смещение регистрового блока}
     w1, w2: Integer;
     c1, c2: Comp;
     bc1: Byte ABSOLUTE c1;
     bc2: Byte ABSOLUTE c2;
     wc1: Integer ABSOLUTE c1;
     wc2: Integer ABSOLUTE c2;
     lc1: LongInt ABSOLUTE c1;
     lc2: LongInt ABSOLUTE c2;
     FirstBuf, LIP: Comp;
     RegArea: SVMRegisters; {Место памяти, где будут находиться регистры}
     ComArray: ARRAY [0..62] OF Pointer; {Массив адресов процедур, которые отвечают за команды SVM}
     Buffer: ARRAY [0..1023] OF Byte; {Буффер, в него загружается килобайт, после чего исполнение команд идет из него}
     ComPrs: ARRAY [0..60,0..28] OF Pointer;
     SVMComand: PROCEDURE;
     Fonts: ARRAY [0..5] OF TFont;
     TotalFonts,
     SelectFonts: Byte;
     StreamName: String;
     StreamN: Word;
     StreamT: Byte;
     FirstC, CountC: Comp;
     TDFile: File OF Byte;
     StreamArray: ARRAY [0..100] OF PStream;
     TempProc: TProcedure;
     VMDISK, VMFile: String;
     Loc: Byte;

     PROCEDURE InitStream;

IMPLEMENTATION

  PROCEDURE   Init_F;
  BEGIN
   Assign(StreamArray[StreamN]^.DFile,StreamName);
   {$I-}
   IF StreamT = 3 THEN ReWrite(StreamArray[StreamN]^.DFile) ELSE
    Reset(StreamArray[StreamN]^.DFile);
   {$I+}
   IF IOResult <> 0 THEN BEGIN StreamT:= 0; Exit; END;
   StreamArray[StreamN]^.FileName:=StreamName;
   StreamArray[StreamN]^.MarkPos:=0;
   StreamArray[StreamN]^.Status:=StreamT;
  END;

  PROCEDURE   ReadByte_F;
  BEGIN
   IF StreamArray[StreamN]^.Status = 0 THEN Exit;
   Read(StreamArray[StreamN]^.DFile,RegArea.BL);
  END;

  PROCEDURE   ReadArray_F;
  VAR countl: LongInt ABSOLUTE CountC;
      firstl: LongInt ABSOLUTE FirstC;
      n: LongInt;
      b: Byte;
  BEGIN
   n:=FirstL;
   REPEAT
    Inc(n);
    {$I-}
    Read(StreamArray[StreamN]^.DFile,b);
    {$I+}
    IF IOResult = 0 THEN PRG.PutB(n-1,b);
   UNTIL (n = FirstL+CountL) OR (IOResult <> 0);
   CountC:=n-FirstL;
  END;

  PROCEDURE   ReadAndStay_F;
  VAR Pos: LongInt;
  BEGIN
   IF StreamArray[StreamN]^.Status = 0 THEN Exit;
   Pos:=FilePos(StreamArray[StreamN]^.DFile);
   ReadByte_F;
   Seek(StreamArray[StreamN]^.DFile,Pos);
  END;

  PROCEDURE   WriteByte_F;
  BEGIN
   IF StreamArray[StreamN]^.Status > 1 THEN
    Write(StreamArray[StreamN]^.DFile,RegArea.BL);
  END;

  PROCEDURE   WriteArray_F;
  VAR countl: LongInt ABSOLUTE CountC;
      firstl: LongInt ABSOLUTE FirstC;
      n: LongInt;
      b: Byte;
  BEGIN
   IF StreamArray[StreamN]^.Status = 0 THEN Exit;
   IF StreamArray[StreamN]^.Status < 2 THEN BEGIN
    CountC:=0;
    Exit;
   END;
   n:=FirstL;
   REPEAT
    Inc(n);
    {$I-}
    b:=PRG.GetB(n);
    Write(StreamArray[StreamN]^.DFile,b);
    {$I+}
   UNTIL (n = FirstL+CountL) OR (IOResult <> 0);
   CountC:=n-FirstL;
  END;

  PROCEDURE   Skeep_F;
  VAR Pos: LongInt;
      countl: LongInt ABSOLUTE CountC;
  BEGIN
   IF StreamArray[StreamN]^.Status = 0 THEN Exit;
   Pos:=FilePos(StreamArray[StreamN]^.DFile);
   {$I-}
   Seek(StreamArray[StreamN]^.DFile,Pos+CountL);
   {$I+}
   CountC:=FilePos(StreamArray[StreamN]^.DFile)-CountC;
  END;

  PROCEDURE   GetTotal_F;
  BEGIN
   IF StreamArray[StreamN]^.Status = 0 THEN Exit;
   RegArea.LCX:=FileSize(StreamArray[StreamN]^.DFile)-
                             FilePos(StreamArray[StreamN]^.DFile);
  END;

  PROCEDURE   Mark_F;
  BEGIN
   IF StreamArray[StreamN]^.Status = 0 THEN Exit;
   StreamArray[StreamN]^.MarkPos:=FilePos(StreamArray[StreamN]^.DFile);
  END;

  PROCEDURE   BackToMark_F;
  BEGIN
   IF StreamArray[StreamN]^.Status = 0 THEN Exit;
   {$I-}
   Seek(StreamArray[StreamN]^.DFile,StreamArray[StreamN]^.MarkPos);
   {$I+}
  END;

  PROCEDURE   GetType_F;
  BEGIN
   RegArea.BL:=StreamArray[StreamN]^.Status;
  END;

  PROCEDURE   ReInit_F;
  BEGIN
   IF StreamArray[StreamN]^.Status = 0 THEN Exit;
   {$I-}
   Seek(StreamArray[StreamN]^.DFile,0);
   {$I+}
  END;

  PROCEDURE   Done_F;
  BEGIN
   IF StreamArray[StreamN]^.Status = 0 THEN Exit;
   Close(StreamArray[StreamN]^.DFile);
   StreamArray[StreamN]^.Status:=0;
  END;

  PROCEDURE   Init_K;
  BEGIN
   StreamArray[StreamN]^.Status:=1;
  END;

  PROCEDURE   ReadByte_K;
  BEGIN
   RegArea.BL:=Ord(ReadKey);
  END;

  PROCEDURE   ReadArray_K;
  VAR countl: LongInt ABSOLUTE CountC;
      firstl: LongInt ABSOLUTE FirstC;
      n: LongInt;
      b: Byte;
  BEGIN
   n:=FirstL;
   REPEAT
    Inc(n);
    b:=Ord(ReadKey);
    PRG.PutB(n-1,b);
   UNTIL n = FirstL+CountL;
   CountC:=n-FirstL;
  END;

  PROCEDURE   ReadAndStay_K;
  BEGIN
   ReadByte_K;
  END;

  PROCEDURE   WriteByte_K;
  BEGIN
  END;

  PROCEDURE   WriteArray_K;
  BEGIN
  END;

  PROCEDURE   Skeep_K;
  VAR countl: LongInt ABSOLUTE CountC;
      n: LongInt;
  BEGIN
   FOR n:=1 TO CountL DO ReadKey;
  END;

  PROCEDURE   GetTotal_K;
  BEGIN
   IF KeyPressed THEN RegArea.LCX:=1 ELSE RegArea.LCX:=0;
  END;

  PROCEDURE   Mark_K;
  BEGIN
  END;

  PROCEDURE   BackToMark_K;
  BEGIN
  END;

  PROCEDURE   GetType_K;
  BEGIN
   RegArea.BL:=3;
  END;

  PROCEDURE   ReInit_K;
  BEGIN
  END;

  PROCEDURE   Done_K;
  BEGIN
  END;

  PROCEDURE   Init_T;
  BEGIN
   StreamArray[StreamN]^.Status:=1;
  END;

  PROCEDURE   ReadByte_T;
  BEGIN
  END;

  PROCEDURE   ReadArray_T;
  BEGIN
  END;

  PROCEDURE   ReadAndStay_T;
  BEGIN
  END;

  PROCEDURE   WriteByte_T;
  BEGIN
   Write(Chr(RegArea.BL));
  END;

  PROCEDURE   WriteArray_T;
  VAR countl: LongInt ABSOLUTE CountC;
      firstl: LongInt ABSOLUTE FirstC;
      n: LongInt;
      b: Byte;
  BEGIN
   n:=FirstL;
   REPEAT
    Inc(n);
    b:=PRG.GetB(n-1);
    Write(Chr(b));
   UNTIL n = FirstL+CountL;
   CountC:=n-FirstL;
  END;

  PROCEDURE   Skeep_T;
  BEGIN
  END;

  PROCEDURE   GetTotal_T;
  BEGIN
   RegArea.LCX:=0;
  END;

  PROCEDURE   Mark_T;
  BEGIN
  END;

  PROCEDURE   BackToMark_T;
  BEGIN
  END;

  PROCEDURE   GetType_T;
  BEGIN
   RegArea.BL:=1;
  END;

  PROCEDURE   ReInit_T;
  BEGIN
  END;

  PROCEDURE   Done_T;
  BEGIN
  END;

  PROCEDURE   InitStream;
  BEGIN
   IF StreamName = 'KEYBOARD STREAM' THEN BEGIN
    StreamArray[StreamN]^.ReadByte:=ReadByte_K;
    StreamArray[StreamN]^.ReadArray:=ReadArray_K;
    StreamArray[StreamN]^.ReadAndStay:=ReadAndStay_K;
    StreamArray[StreamN]^.WriteByte:=WriteByte_K;
    StreamArray[StreamN]^.WriteArray:=WriteArray_K;
    StreamArray[StreamN]^.Skeep:=Skeep_K;
    StreamArray[StreamN]^.Mark:=Mark_K;
    StreamArray[StreamN]^.BackToMark:=BackToMark_K;
    StreamArray[StreamN]^.GetTotal:=GetTotal_K;
    StreamArray[StreamN]^.GetType:=GetType_K;
    StreamArray[StreamN]^.ReInit:=ReInit_K;
    StreamArray[StreamN]^.Init:=Init_K;
    StreamArray[StreamN]^.Done:=Done_K;
   END ELSE
   IF StreamName = 'TERMINAL STREAM' THEN BEGIN
    StreamArray[StreamN]^.ReadByte:=ReadByte_T;
    StreamArray[StreamN]^.ReadArray:=ReadArray_T;
    StreamArray[StreamN]^.ReadAndStay:=ReadAndStay_T;
    StreamArray[StreamN]^.WriteByte:=WriteByte_T;
    StreamArray[StreamN]^.WriteArray:=WriteArray_T;
    StreamArray[StreamN]^.Skeep:=Skeep_T;
    StreamArray[StreamN]^.Mark:=Mark_T;
    StreamArray[StreamN]^.BackToMark:=BackToMark_T;
    StreamArray[StreamN]^.GetTotal:=GetTotal_T;
    StreamArray[StreamN]^.GetType:=GetType_T;
    StreamArray[StreamN]^.ReInit:=ReInit_T;
    StreamArray[StreamN]^.Init:=Init_T;
    StreamArray[StreamN]^.Done:=Done_T;
   END ELSE BEGIN
    StreamArray[StreamN]^.ReadByte:=ReadByte_F;
    StreamArray[StreamN]^.ReadArray:=ReadArray_F;
    StreamArray[StreamN]^.ReadAndStay:=ReadAndStay_F;
    StreamArray[StreamN]^.WriteByte:=WriteByte_F;
    StreamArray[StreamN]^.WriteArray:=WriteArray_F;
    StreamArray[StreamN]^.Skeep:=Skeep_F;
    StreamArray[StreamN]^.Mark:=Mark_F;
    StreamArray[StreamN]^.BackToMark:=BackToMark_F;
    StreamArray[StreamN]^.GetTotal:=GetTotal_F;
    StreamArray[StreamN]^.GetType:=GetType_F;
    StreamArray[StreamN]^.ReInit:=ReInit_F;
    StreamArray[StreamN]^.Init:=Init_F;
    StreamArray[StreamN]^.Done:=Done_F;
   END;
  END;

END.