{$A+,B+,D+,E-,F+,G+,I-,L-,N+,O+,P+,Q-,R-,S-,T+,V+,X+}
{$M 16384,0,655360}
{============================================================================}
{====--------------------------------------------------------------------====}
{====                      SVM Assembler Compiller                       ====}
{====                            Version  1.2                            ====}
{====                   for IBM AT or 100% compitable                    ====}
{====                   Copyright (C) 1999 ShAG Studio                   ====}
{====--------------------------------------------------------------------====}
{====   Эта программа  является примером  использования модуля SVMACU, и ====}
{==== представляет  собой  полноценный компилятор  SVM ассемблера в  SVM ====}
{==== байт-код.                                                          ====}
{====   В программе показаны  методы работы с модулем SVMACU версии 1.2, ====}
{==== который бесплатно распространяется в виде файла TPU для DOS-версий ====}
{==== Turbo Pascal (TM) фирмы Borland International.                     ====}
{====   Программа является полностью бесплатной. Разрешается перераспро- ====}
{==== нять программу, как в виде исполняемого файла, так и в виде исход- ====}
{==== ного кода на языке Pascal. Также разрешается видоизменять исходный ====}
{==== текст программы для улучшения её работы.                           ====}
{====   Запрещается  брать хоть какую-то плату  за распространнене копий ====}
{==== продукта в любом виде, в том числе и в модифицированном, кроме как ====}
{==== с писменного согласия самого автора!                               ====}
{====--------------------------------------------------------------------====}
{============================================================================}
                                PROGRAM SVMAC;
{============================================================================}
 USES  SEMME_E,SVMACU,SVM_N,Crt,Dos,SIFI,SSI;

       {Модули:
        SVMACU - Компилятор
        SVM - Менеджер виртуальной памяти
        Crt - Стандартный модуль для работы с текстом
        Dos - Стандартный модуль для работы с дисковыми файлами и DOS }
 VAR   TotalParams,          {Общее количество параметров командной строки}
       n, h, m, s, nso, nh, nm, ns, nnso: Word; {Время}
       WorkMode,
       MapType,              {Тип сохраняемой карты памяти}
       MessagesDialogType: Byte; {Способ вывода сообщений об ошибках}
       Info: TCRInfo;        {Информация о результате компиляции}
       YLine, LY: Integer;   {Координаты Y текстового режима}
       MessagesFile: Text;   {Файл в который будут выводиться сообщения}
       TempStr, TempStr2,    {Временные переменные для работы со строками}
       VMDisk,               {Буква диска где будет работать виртуальная память}
       SourceFileName,       {Имя файла оригинала}
       ResultFileName,       {Имя результата}
       MessagesFileName: String; {Имя файла в который будут выводиться сообщения}
       LastX, LastY: Integer;
       WinCountVM,
       l: LongInt;
       Reg: Registers;
       TempScreen: TScreen;
 CONST Texts: ARRAY [1..14] OF String[80] = ({Текст помощи}
        'Synax: SVMAC filename [options]',
        '  /?,/H = Display this help screen',
        '  /GD = Detailed map file',
        '  /GL = Procedures and labels in map file only',
        '  /GV = Variables in map file only',
        '  /GM = All messages and errors in special file',
        '  /L:filename = Load language file (filename.LNG)',
        '  /C:filename = Load configuration file (filename.INI)',
        '  /I:path = Include directories',
        '  /R:path = Result directories',
        '  /M:path = Map directories',
        '  /D:disk = Disk for virtual memory (default C drive)',
        ' Load configuration file',
        ' SVM v1.0 initilising. Please wait...');
       Errors: ARRAY [1..4] OF String[80] = ({Текст ошибок этой программы!}
        'Wrong disk type.',
        'File not found.',
        'Disk full.',
        'Not enother memory.');
       ErrorCompillerMessage: ARRAY [1..3] OF String[80] = (
        '**Error** ',      {Текст, который используется для вывода ошибок}
        '*Warning* ',      {и сообщений}
        ' Messages:');
       Messages: ARRAY [1..11] OF String[40] = (
        'Main file:   ', {Текст который используется для вывода}
        'Compiling:   ', {результата компиляции и отображения}
        'Total lines: ', {состояния компиляции}
        'Line number: ',
        'Passes:      ',
        'Code size:   ',
        'Data size:   ',
        'Warning messages: ',
        'Time:        ',
        'bytes',
        'sec');
       ScreenDialog = 0;     {Тип вывода сообщение - экран}
       DiskDialog = 1;       {Тип вывода сообщений - диск}
       BrColor: TColor = (Text : 15; Fon : 7; SText : 0; SFon : 7);

 {Функция возвращает n параметр строки большими буквами}
 FUNCTION PStr(n: Word): String;
 BEGIN
  PStr:='';
  IF n > TotalParams THEN Exit;
  PStr:=UpString(ParamStr(n));
 END;

 {Функция возвращает номер параметра по строке}
 FUNCTION TestKey(s: String): Word;
 VAR n: Word;
 BEGIN
  TestKey:=65535;
  FOR n:=0 TO TotalParams DO
   IF PStr(n) = s THEN BEGIN
    TestKey:=n;
    Exit;
   END;
 END;

 {Процедура вывода авторского права}
 PROCEDURE ShowCopyright;
 BEGIN
  GotoXY(1,WhereY-1);
  WriteLn('SVM Assembler Compiller  Version 1.2  Copyright (c) 1999 ShAG Studio');
 END;

 {Процедура отображения справки}
 PROCEDURE ShowHelp;
 BEGIN
  WriteLn(Texts[1]);  WriteLn(Texts[2]);  WriteLn(Texts[3]);  WriteLn(Texts[4]);
  WriteLn(Texts[5]);  WriteLn(Texts[6]);  WriteLn(Texts[7]);  WriteLn(Texts[8]);
  WriteLn(Texts[9]);  WriteLn(Texts[10]); WriteLn(Texts[11]); WriteLn(Texts[12]);
  Halt(0);
 END;

 {Процедура отображет ошибки этой программы!}
 PROCEDURE ShowErrorParams(code: Byte);
 VAR Key: Byte;
 BEGIN
  IF WorkMode <> 1 THEN BEGIN
   WriteLn(ErrorCompillerMessage[1],Errors[code]);
  END ELSE BEGIN
   ShowMDialog(60,CenterText,'Error','~'+Errors[code]+'~','~O~k',BrColor);
   RestoreScreen(TempScreen);
  END;
  DoneVM;
  LY:=WhereY;
  CursorOn;
  Halt(0);
 END;

 {Процедура отображает ошибки, которые могут возникнуть в процессе компиляции}
 PROCEDURE ShowError(ErrorCode, ErrorChar: Byte; ErrorString: LongInt; ErrorFileName: String);
 VAR TStr: String;
     ts: ARRAY [0..4095] OF Byte;
     Key: Byte;
 BEGIN
  IF WorkMode <> 1 THEN BEGIN
   WriteLn(ErrorCompillerMessage[1],ErrorFileName,'(',ErrorString,') ',SVMErrors[ErrorCode]);
   LY:=WhereY;
  END ELSE BEGIN
   Str(ErrorString,TStr);
   ShowMDialog(60,CenterText,'Error in '+ErrorFileName+'('+TStr+')',
    '~'+SVMErrors[ErrorCode]+'~','~O~k',BrColor);
  END;
  IF MessagesDialogType <> ScreenDialog THEN BEGIN
   {Если возникла ошибка и надо было создать файл - карту памяти, то
    завершаем его по всем правилам}
   WriteLn(MessagesFile,'');
   WriteLn(MessagesFile,';----------------------------------------------------------------------------;');
   WriteLn(MessagesFile,';                           End of messages file                             ;');
     Write(MessagesFile,';----------------------------------------------------------------------------;');
   Close(MessagesFile);
   MessagesDialogType:=No_map;
  END;
 END;

 {Процедура отображает сообщения, которые могут возникнуть в процессе компиляции}
 PROCEDURE ShowMessages(MessageCode: Byte; MessageString: LongInt; MessageFileName: String);
 BEGIN
  {Данная процедура отображает сообщания на экране}
  WriteLn(ErrorCompillerMessage[2],MessageFileName,'(',MessageString,') ',SVMErrors[MessageCode]);
  LY:=WhereY;
 END;

 {Процедура отображает сообщения, которые могут возникнуть в процессе компиляции}
 PROCEDURE ShowMessagesFile(MessageCode: Byte; MessageString: LongInt; MessageFileName: String);
 BEGIN
  {а эта процедура выводит сообщения об ошибках в файл, если в командной
   строке дать ключ /GM}
  WriteLn(MessagesFile,' ',ErrorCompillerMessage[2],MessageFileName,'(',MessageString,') ',SVMErrors[MessageCode]);
 END;

 {Процедура вызывается каждый раз перед компиляцией очередной строки исходного
  текста и получает параметры и информацию о том как идет процесс компиляции}
 PROCEDURE IndicateProcess(Sf, Cf: String; TSn, CSn, Pn: LongInt);
 VAR tstr,tstr2: String;
 FUNCTION AddS(Str: String; s: Byte): String;
 VAR n: Byte;
     ts: String;
 BEGIN
  ts:='';
  FOR n:=1 TO s DO ts:=ts+' ';
  IF Length(str) < s THEN s:=Length(Str);
  FOR n:=1 TO s DO ts[n]:=str[n];
  AddS:=ts;
 END;

 BEGIN
  IF WorkMode <> 1 THEN BEGIN
   Window(1,YLine,80,YLine+5);
   ClrEOl;  WriteLn(Messages[1],Sf);
   ClrEOl;  WriteLn(Messages[2],Cf);
   ClrEOl;  WriteLn(Messages[3],TSn);
   ClrEOl;  WriteLn(Messages[4],Csn);
   ClrEOl;  WriteLn(Messages[5],Pn);
   Window(1,YLine+5,80,25);
   GotoXY(1,LY);
  END ELSE BEGIN
   WriteString(19,10,Messages[1]+AddS(Sf,30),WinColor);
   WriteString(19,11,Messages[2]+AddS(Cf,30),WinColor);
   Str(Tsn,TStr);
   Str(Csn,TStr2);
   WriteString(19,13,Messages[3]+AddS(TStr,6)+'   '+Messages[4]+AddS(TStr2,6),WinColor);
   Str(Pn,TStr);
   WriteString(19,14,Messages[5]+AddS(Tstr,6),WinColor);
  END;
 END;

 {По окончанию компиляии, если не возникло ошибок, вызывается эта процедура
  и выводит информацию о результате компиляции}
 PROCEDURE ShowFinishInfo;
 VAR TStr: String;
     Key: Byte;
 BEGIN
  IF WorkMode <> 1 THEN BEGIN
   Window(1,YLine,80,25);
   ClrEOl;  WriteLn(Messages[1],Info.SourceFileName,'                 ');
   ClrEOl;  WriteLn(Messages[3],Trunc(Info.TotalStrings),'                 ');
   ClrEOl;  WriteLn(Messages[8],Trunc(Info.TotalMessages),'                 ');
   ClrEOl;  WriteLn(Messages[6],Trunc(Info.CodeSize),' ',Messages[10],'       ');
   ClrEOl;  WriteLn(Messages[7],Trunc(Info.DataSize),' ',Messages[10],'       ');
   DelLine; DelLine;  DelLine;  DelLine;  DelLine;  DelLine;
   ClrEOl;  WriteLn(Messages[9],Trunc((nh-h)*3600+(nm-m)*60+(ns-s)),' ',Messages[11],'                         ');
   Window(1,1,80,25);
   GotoXY(1,25);
  END ELSE BEGIN
   FillWindow(18,9,62,17,' ',WinColor);
   WriteString(19,10,Messages[1]+Info.SourceFileName,WinColor);
   WriteString(19,11,Messages[2]+'Done.',WinColor);
   Str(Trunc(Info.TotalStrings),TStr);
   WriteString(19,13,Messages[3]+TStr,WinColor);
   Str(Trunc(Info.TotalMessages),TStr);
   WriteString(40,13,Messages[8]+TStr,WinColor);
   Str(Trunc(Info.CodeSize),TStr);
   WriteString(19,14,Messages[6]+TStr+' '+Messages[10],WinColor);
   Str(Trunc(Info.DataSize),TStr);
   WriteString(19,15,Messages[7]+TStr+' '+Messages[10],WinColor);
   WriteString(18,17,'      Compile successful: Press any Key      ',EditColor);
   REPEAT
   UNTIL KeyPressed;
   Key:=Ord(ReadKey);
   RestoreScreen(TempScreen);
   GotoXY(LastX,LastY);
  END;
 END;

 PROCEDURE LoadINI(fname: String);
 VAR ts: String;
 BEGIN
  ts:=UpString(GetItem(fname,'OPTIONS','MAP_FILE'));
  IF ts = 'DATAIL' THEN MapType:=Detailed_Map ELSE
  IF ts = 'NO_VARIABLES' THEN MapType:=Procedures_and_labels_Map ELSE
  IF ts = 'NO_LABELS' THEN MapType:=Variables_map ELSE
  IF ts = 'NO_MAP' THEN MapType:=No_Map;
  ts:=UpString(GetItem(fname,'OPTIONS','MESSAGES'));
  IF ts = 'IN_FILE' THEN MessagesDialogType:=DiskDialog ELSE
  IF ts = 'ON_SCREEN' THEN MessagesDialogType:=ScreenDialog;
  ts:=UpString(GetItem(fname,'OPTIONS','INCLUDES_DIR'));
  IF (ts <> 'DEFAULT') AND (ts <> INIFileNotFound) AND (ts <> FolderNotFound)
   THEN IncludeDirectories:=ts+'\';
  ts:=UpString(GetItem(fname,'OPTIONS','RESULT_DIR'));
  IF (ts <> 'DEFAULT') AND (ts <> INIFileNotFound) AND (ts <> FolderNotFound)
   THEN ResultDirectories:=ts+'\';
  ts:=UpString(GetItem(fname,'OPTIONS','MAP_DIR'));
  IF (ts <> 'DEFAULT') AND (ts <> INIFileNotFound) AND (ts <> FolderNotFound)
   THEN MapDirectories:=ts+'\';
  ts:=UpString(GetItem(fname,'OPTIONS','SWAP_DISK'));
  IF (ts <> 'DEFAULT') AND (ts <> INIFileNotFound) AND (ts <> FolderNotFound)
   THEN VMDisk:=ts[1];
 END;

 {Далее расположен текст основной программы компилятора}
 BEGIN
  WinCountVM:=16;
  CursorOff;
  {Выводим сообщение с названием программы и авторские права}
  SaveScreen(TempScreen);
  LastX:=WhereX;
  LastY:=WhereY;
  l:=MemAvail;
  if l < WinCountVM*PageSize+1024 then begin
   WinCountVM:=(l-1024) div PageSize;
   if WinCountVM < 2 then begin
    ShowMDialog(60,CenterText,'Error','~'+Errors[4]+'~','~O~k',BrColor);
    Halt(0);
   end;
  end;
  WorkMode:=0;
  TotalParams:=ParamCount; {Получаем общее количество параметров командной строки}
  VMDisk:='C'; {Устанавливаем по умолчанию диск виртуальной памяти - C}
  SourceFileName:=''; {Первоначальное имя исходного текста равно пустой строке}
  MapType:=No_map; {По умолчанию карта памяти не должна создаваться}
  MessagesDialogType:=ScreenDialog; {По умолчанию все сообщения выводятся на экран}
  {Анализируем параметры командной строки}
  LoadINI('SVMAC.INI');
  FOR n:=1 to TotalParams DO BEGIN
   {Получаем n-ый параметр командной строки, предварительно подняв все буквы до больших}
   TempStr:=PStr(n);
   {Получаем первые три буквы параметра}
   TempStr2:=Copy(TempStr,1,3);
   IF TempStr2 = '/I:' THEN IncludeDirectories:=Copy(TempStr,4,Length(TempStr)-3)+'\' ELSE
   IF TempStr2 = '/R:' THEN ResultDirectories:=Copy(TempStr,4,Length(TempStr)-3)+'\' ELSE
   IF TempStr2 = '/M:' THEN MapDirectories:=Copy(TempStr,4,Length(TempStr)-3)+'\' ELSE
   IF TempStr2 = '/D:' THEN VMDisk:=TempStr[4] ELSE
   IF TempStr2 = '/GD' THEN MapType:=Detailed_Map ELSE
   IF TempStr2 = '/GL' THEN MapType:=Procedures_and_labels_Map ELSE
   IF TempStr2 = '/GV' THEN MapType:=Variables_map ELSE
   IF TempStr2 = '/GM' THEN MessagesDialogType:=DiskDialog ELSE
   IF SourceFileName = '' THEN SourceFileName:=TempStr ELSE
   IF TempStr2 = '/C:' THEN LoadINI(Copy(TempStr,4,Length(TempStr)-3)) ELSE
   If TempStr2 = '/PR' THEN BEGIN WorkMode:=1; MessagesDialogType:=DiskDialog; END;
  END;
  IF WorkMode <> 1 THEN ShowCopyright;
  {Проверяем на надобность вывода справки}
  IF (TestKey('/H') <> 65535) OR (TestKey('/?') <> 65535) OR (TotalParams = 0)
      OR (SourceFileName = '') THEN ShowHelp;

  {Проверяем, есть ли среди установленных путей в конце строки удвоеное \\,
   если есть, то удаляем один знак \}
  IF IncludeDirectories[Length(IncludeDirectories)] = IncludeDirectories[Length(IncludeDirectories) - 1]
     THEN Delete(IncludeDirectories,Length(IncludeDirectories),1);
  IF ResultDirectories[Length(ResultDirectories)] = ResultDirectories[Length(ResultDirectories) - 1]
     THEN Delete(ResultDirectories,Length(ResultDirectories),1);
  IF MapDirectories[Length(MapDirectories)] = MapDirectories[Length(MapDirectories) - 1]
     THEN Delete(MapDirectories,Length(MapDirectories),1);

  {Проверяем правельность задания диска для виртуальной памяти}
  IF NOT (VMDisk[1] IN ['C'..'Z']) THEN ShowErrorParams(1);

  IF Pos('.',SourceFileName) = 0 THEN SourceFileName:=SourceFileName+'.ASM';

  {Проверка заданного для виртуальной памяти диска на существование}
  {$I-} {Отключаем авто контроль ошибок ввода-вывода}
  GetDir(0,TempStr); {Запоминаем каталог}
  ChDir(VMDisk[1]+':\'); {Пытаемся установить корневой каталог заданного диска}
  {$I+} {Включаем авто контроль ошибок ввода-вывода}
  IF IOResult <> 0 THEN ShowErrorParams(1); {если возникла ошибка, оповещаем пользователя}
  ChDir(TempStr); {в противном случае устанавливаем назад первоначальный каталог}
  Assign(MessagesFile,SourceFileName); {Проверяем исходный файл на существование}
  {$I-} {Отключаем авто контроль ошибок ввода-вывода}
  Reset(MessagesFile); {Открываем файл для чтения}
  {$I+} {Включаем авто контроль ошибок ввода-вывода}
  IF IOResult <> 0 THEN ShowErrorParams(2); {если возникла какая-то ошибка, сообщаем пользователю}
  Close(MessagesFile); {иначе закрываем файл}
  IF DiskFree(Ord(UpCase(VMDisk[1]))-64) <= 64*PageSize THEN ShowErrorParams(3);
  {Инициализируем первоначальный размер виртуальной памяти на 1 мегабайт}
  GotoXY(1,WhereY);
  IF WorkMode <> 1 THEN Write(Texts[14]);
  InitSVM(0,2048*PageSize,WinCountVM,VMDisk[1],'svmac.swp');
  GotoXY(1,WhereY);
  IF WorkMode <> 1 THEN Write('                                                                       ');
  GotoXY(1,WhereY);
  YLine:=WhereY; {Получаем координату Y для вывода процесса компиляции}
  GotoXY(1,YLine); {Переводим курсор в начало строки}
  {Если строка ниже 15, то поднимаем экран до нужного уровня}
  IF (YLine > 15) AND (WorkMode <> 1) THEN BEGIN FOR n:=1 TO 10-(25-YLine) DO
  IF WorkMode <> 1 THEN
   WriteLn('                                                                               ');
   YLine:=15;
  END;
  LY:=1;
  IF WorkMode <> 1 THEN Window(1,YLine+5,80,25);
  {Устанавливаем процедуры пользователя компиоятора}
  @ShowCompillInfo:=@IndicateProcess; {Для вывода процесса компиляции}
  @ErrorCompiller:=@ShowError; {Для вывода ошибок компиляции}
  {Для вывода сообщений компиляций}
  IF MessagesDialogType = ScreenDialog THEN @MessageCompiller:=@ShowMessages ELSE
     @MessageCompiller:=@ShowMessagesFile;
  IF MessagesDialogType <> ScreenDialog THEN BEGIN
   {Создаем имя файла в котором будет сохранена карта памяти}
   MessagesFileName:=SourceFileName;
   REPEAT
    IF Pos('\',MessagesFileName) <> 0 THEN
       Delete(MessagesFileName,1,Pos('\',MessagesFileName));
   UNTIL Pos('\',MessagesFileName) = 0;
   IF Pos('.',MessagesFileName) <> 0 THEN
      MessagesFileName:=Copy(MessagesFileName,1,Pos('.',MessagesFileName)-1);
   Assign(MessagesFile,ResultDirectories+MessagesFileName+'.MSG');
   {$I-}
   ReWrite(MessagesFile);
   {$I+}
   IF IOResult <> 0 THEN ShowErrorParams(2);
   {Выводим стандартный заголовок в файл карты памяти}
   WriteLn(MessagesFile,';----------------------------------------------------------------------------;');
   WriteLn(MessagesFile,';                         SVM Assembler Compiller                            ;');
   WriteLn(MessagesFile,';                               Version 1.2                                  ;');
   WriteLn(MessagesFile,';                     Copyright (c) 1999 ShAG Studio                         ;');
   WriteLn(MessagesFile,';----------------------------------------------------------------------------;');
   WriteLn(MessagesFile,'');
   WriteLn(MessagesFile,ErrorCompillerMessage[3]);
  END;
  IF WorkMode <> 0 THEN BEGIN
   ShowWindow(17,8,63,18,DoubleB,'Compiling',BrColor);
   WriteString(18,17,'           Press Escape to cancel            ',EditColor);
  END;
  InitCompiller; {Инициализируем компилятор перед процессом компиляции}
  GetTime(h,m,s,nso); {Запоминаем время начала компиляции}
  Compiller(SourceFileName); {Компилируем файл SourceFileName}
  GetTime(nh,nm,ns,nnso); {Запоминаем время конца компиляции}
  {Создаем имя файла в котором будет сохранена откомпилированная программа}
  ResultFileName:=SourceFileName;
  REPEAT
   IF Pos('\',ResultFileName) <> 0 THEN
      Delete(ResultFileName,1,Pos('\',ResultFileName));
  UNTIL Pos('\',ResultFileName) = 0;
   IF Pos('.',ResultFileName) <> 0 THEN
      ResultFileName:=Copy(ResultFileName,1,Pos('.',ResultFileName)-1);
  ResultFileName:=ResultDirectories+ResultFileName+'.SVM';
  {Сохраняем результат компиляции в файл}
  GetResultInfo(Info);
  IF Info.ErrorNumber = 0 THEN SaveResultToFile(ResultFileName);
  IF MessagesDialogType = DiskDialog THEN BEGIN
   {Стандартное завершение файла карты памяти}
   WriteLn(MessagesFile,'');
   WriteLn(MessagesFile,';----------------------------------------------------------------------------;');
   WriteLn(MessagesFile,';                           End of messages file                             ;');
     Write(MessagesFile,';----------------------------------------------------------------------------;');
   Close(MessagesFile);
  END;
  {Передаем процедуре, генирирующей карту памяти, тип генирируемой карты}
  IF Info.ErrorNumber = 0 THEN BEGIN
   SaveMapFile(MapType);
  END;
  DoneVM;
  {Если в результате компиляции ошибок нет, то выводим информациию о окончании}
  IF Info.ErrorNumber = 0 THEN ShowFinishInfo;
  {Устанавливаем курсор в нижний левый угол}
  Window(1,1,80,25); GotoXY(1,25);
  TextColor(7);
  TextBackGround(0);
  IF WorkMode <> 0 THEN BEGIN
   RestoreScreen(TempScreen);
  END;
  CursorOn;
 END.
