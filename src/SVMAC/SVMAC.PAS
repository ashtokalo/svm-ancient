{$A+,B+,D+,E-,F+,G+,I-,L-,N+,O+,P+,Q-,R-,S-,T+,V+,X+}
{$M 16384,0,655360}
{============================================================================}
{====--------------------------------------------------------------------====}
{====                      SVM Assembler Compiller                       ====}
{====                            Version  1.2                            ====}
{====                   for IBM AT or 100% compitable                    ====}
{====                   Copyright (C) 1999 ShAG Studio                   ====}
{====--------------------------------------------------------------------====}
{====   �� �ணࠬ��  ���� �ਬ�஬  �ᯮ�짮����� ����� SVMACU, � ====}
{==== �।�⠢���  ᮡ��  �����業�� ���������  SVM ��ᥬ���� �  SVM ====}
{==== ����-���.                                                          ====}
{====   � �ணࠬ�� ��������  ��⮤� ࠡ��� � ���㫥� SVMACU ���ᨨ 1.2, ====}
{==== ����� ��ᯫ�⭮ �����࠭���� � ���� 䠩�� TPU ��� DOS-���ᨩ ====}
{==== Turbo Pascal (TM) ��� Borland International.                     ====}
{====   �ணࠬ�� ���� ��������� ��ᯫ�⭮�. ����蠥��� ������- ====}
{==== ���� �ணࠬ��, ��� � ���� �ᯮ��塞��� 䠩��, ⠪ � � ���� ��室- ====}
{==== ���� ���� �� �몥 Pascal. ����� ࠧ�蠥��� ������������ ��室�� ====}
{==== ⥪�� �ணࠬ�� ��� ���襭�� �� ࠡ���.                           ====}
{====   ����頥���  ���� ��� �����-� �����  �� �����࠭���� ����� ====}
{==== �த�� � �� ����, � ⮬ �᫥ � � ������஢�����, �஬� ��� ====}
{==== � ��ᬥ����� ᮣ���� ᠬ��� ����!                               ====}
{====--------------------------------------------------------------------====}
{============================================================================}
                                PROGRAM SVMAC;
{============================================================================}
 USES  SEMME_E,SVMACU,SVM_N,Crt,Dos,SIFI,SSI;

       {���㫨:
        SVMACU - ���������
        SVM - �������� ����㠫쭮� �����
        Crt - �⠭����� ����� ��� ࠡ��� � ⥪�⮬
        Dos - �⠭����� ����� ��� ࠡ��� � ��᪮�묨 䠩���� � DOS }
 VAR   TotalParams,          {��饥 ������⢮ ��ࠬ��஢ ��������� ��ப�}
       n, h, m, s, nso, nh, nm, ns, nnso: Word; {�६�}
       WorkMode,
       MapType,              {��� ��࠭塞�� ����� �����}
       MessagesDialogType: Byte; {���ᮡ �뢮�� ᮮ�饭�� �� �訡���}
       Info: TCRInfo;        {���ଠ�� � १���� �������樨}
       YLine, LY: Integer;   {���न���� Y ⥪�⮢��� ०���}
       MessagesFile: Text;   {���� � ����� ���� �뢮������ ᮮ�饭��}
       TempStr, TempStr2,    {�६���� ��६���� ��� ࠡ��� � ��ப���}
       VMDisk,               {�㪢� ��᪠ ��� �㤥� ࠡ���� ����㠫쭠� ������}
       SourceFileName,       {��� 䠩�� �ਣ�����}
       ResultFileName,       {��� १����}
       MessagesFileName: String; {��� 䠩�� � ����� ���� �뢮������ ᮮ�饭��}
       LastX, LastY: Integer;
       WinCountVM,
       l: LongInt;
       Reg: Registers;
       TempScreen: TScreen;
 CONST Texts: ARRAY [1..14] OF String[80] = ({����� �����}
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
       Errors: ARRAY [1..4] OF String[80] = ({����� �訡�� �⮩ �ணࠬ��!}
        'Wrong disk type.',
        'File not found.',
        'Disk full.',
        'Not enother memory.');
       ErrorCompillerMessage: ARRAY [1..3] OF String[80] = (
        '**Error** ',      {�����, ����� �ᯮ������ ��� �뢮�� �訡��}
        '*Warning* ',      {� ᮮ�饭��}
        ' Messages:');
       Messages: ARRAY [1..11] OF String[40] = (
        'Main file:   ', {����� ����� �ᯮ������ ��� �뢮��}
        'Compiling:   ', {१���� �������樨 � �⮡ࠦ����}
        'Total lines: ', {���ﭨ� �������樨}
        'Line number: ',
        'Passes:      ',
        'Code size:   ',
        'Data size:   ',
        'Warning messages: ',
        'Time:        ',
        'bytes',
        'sec');
       ScreenDialog = 0;     {��� �뢮�� ᮮ�饭�� - ��࠭}
       DiskDialog = 1;       {��� �뢮�� ᮮ�饭�� - ���}
       BrColor: TColor = (Text : 15; Fon : 7; SText : 0; SFon : 7);

 {�㭪�� �����頥� n ��ࠬ��� ��ப� ����訬� �㪢���}
 FUNCTION PStr(n: Word): String;
 BEGIN
  PStr:='';
  IF n > TotalParams THEN Exit;
  PStr:=UpString(ParamStr(n));
 END;

 {�㭪�� �����頥� ����� ��ࠬ��� �� ��ப�}
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

 {��楤�� �뢮�� ����᪮�� �ࠢ�}
 PROCEDURE ShowCopyright;
 BEGIN
  GotoXY(1,WhereY-1);
  WriteLn('SVM Assembler Compiller  Version 1.2  Copyright (c) 1999 ShAG Studio');
 END;

 {��楤�� �⮡ࠦ���� �ࠢ��}
 PROCEDURE ShowHelp;
 BEGIN
  WriteLn(Texts[1]);  WriteLn(Texts[2]);  WriteLn(Texts[3]);  WriteLn(Texts[4]);
  WriteLn(Texts[5]);  WriteLn(Texts[6]);  WriteLn(Texts[7]);  WriteLn(Texts[8]);
  WriteLn(Texts[9]);  WriteLn(Texts[10]); WriteLn(Texts[11]); WriteLn(Texts[12]);
  Halt(0);
 END;

 {��楤�� �⮡ࠦ�� �訡�� �⮩ �ணࠬ��!}
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

 {��楤�� �⮡ࠦ��� �訡��, ����� ����� ���������� � ����� �������樨}
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
   {�᫨ �������� �訡�� � ���� �뫮 ᮧ���� 䠩� - ����� �����, �
    �����蠥� ��� �� �ᥬ �ࠢ����}
   WriteLn(MessagesFile,'');
   WriteLn(MessagesFile,';----------------------------------------------------------------------------;');
   WriteLn(MessagesFile,';                           End of messages file                             ;');
     Write(MessagesFile,';----------------------------------------------------------------------------;');
   Close(MessagesFile);
   MessagesDialogType:=No_map;
  END;
 END;

 {��楤�� �⮡ࠦ��� ᮮ�饭��, ����� ����� ���������� � ����� �������樨}
 PROCEDURE ShowMessages(MessageCode: Byte; MessageString: LongInt; MessageFileName: String);
 BEGIN
  {������ ��楤�� �⮡ࠦ��� ᮮ�頭�� �� ��࠭�}
  WriteLn(ErrorCompillerMessage[2],MessageFileName,'(',MessageString,') ',SVMErrors[MessageCode]);
  LY:=WhereY;
 END;

 {��楤�� �⮡ࠦ��� ᮮ�饭��, ����� ����� ���������� � ����� �������樨}
 PROCEDURE ShowMessagesFile(MessageCode: Byte; MessageString: LongInt; MessageFileName: String);
 BEGIN
  {� �� ��楤�� �뢮��� ᮮ�饭�� �� �訡��� � 䠩�, �᫨ � ���������
   ��ப� ���� ���� /GM}
  WriteLn(MessagesFile,' ',ErrorCompillerMessage[2],MessageFileName,'(',MessageString,') ',SVMErrors[MessageCode]);
 END;

 {��楤�� ��뢠���� ����� ࠧ ��। �������樥� ��।��� ��ப� ��室����
  ⥪�� � ����砥� ��ࠬ���� � ���ଠ�� � ⮬ ��� ���� ����� �������樨}
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

 {�� ����砭�� ������﨨, �᫨ �� �������� �訡��, ��뢠���� �� ��楤��
  � �뢮��� ���ଠ�� � १���� �������樨}
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

 {����� �ᯮ����� ⥪�� �᭮���� �ணࠬ�� ���������}
 BEGIN
  WinCountVM:=16;
  CursorOff;
  {�뢮��� ᮮ�饭�� � ��������� �ணࠬ�� � ����᪨� �ࠢ�}
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
  TotalParams:=ParamCount; {����砥� ��饥 ������⢮ ��ࠬ��஢ ��������� ��ப�}
  VMDisk:='C'; {��⠭�������� �� 㬮�砭�� ��� ����㠫쭮� ����� - C}
  SourceFileName:=''; {��ࢮ��砫쭮� ��� ��室���� ⥪�� ࠢ�� ���⮩ ��ப�}
  MapType:=No_map; {�� 㬮�砭�� ���� ����� �� ������ ᮧ��������}
  MessagesDialogType:=ScreenDialog; {�� 㬮�砭�� �� ᮮ�饭�� �뢮����� �� ��࠭}
  {��������㥬 ��ࠬ���� ��������� ��ப�}
  LoadINI('SVMAC.INI');
  FOR n:=1 to TotalParams DO BEGIN
   {����砥� n-� ��ࠬ��� ��������� ��ப�, �।���⥫쭮 ����� �� �㪢� �� ������}
   TempStr:=PStr(n);
   {����砥� ���� �� �㪢� ��ࠬ���}
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
  {�஢��塞 �� ���������� �뢮�� �ࠢ��}
  IF (TestKey('/H') <> 65535) OR (TestKey('/?') <> 65535) OR (TotalParams = 0)
      OR (SourceFileName = '') THEN ShowHelp;

  {�஢��塞, ���� �� �।� ��⠭�������� ��⥩ � ���� ��ப� 㤢����� \\,
   �᫨ ����, � 㤠�塞 ���� ���� \}
  IF IncludeDirectories[Length(IncludeDirectories)] = IncludeDirectories[Length(IncludeDirectories) - 1]
     THEN Delete(IncludeDirectories,Length(IncludeDirectories),1);
  IF ResultDirectories[Length(ResultDirectories)] = ResultDirectories[Length(ResultDirectories) - 1]
     THEN Delete(ResultDirectories,Length(ResultDirectories),1);
  IF MapDirectories[Length(MapDirectories)] = MapDirectories[Length(MapDirectories) - 1]
     THEN Delete(MapDirectories,Length(MapDirectories),1);

  {�஢��塞 �ࠢ��쭮��� ������� ��᪠ ��� ����㠫쭮� �����}
  IF NOT (VMDisk[1] IN ['C'..'Z']) THEN ShowErrorParams(1);

  IF Pos('.',SourceFileName) = 0 THEN SourceFileName:=SourceFileName+'.ASM';

  {�஢�ઠ ��������� ��� ����㠫쭮� ����� ��᪠ �� ����⢮�����}
  {$I-} {�⪫�砥� ��� ����஫� �訡�� �����-�뢮��}
  GetDir(0,TempStr); {���������� ��⠫��}
  ChDir(VMDisk[1]+':\'); {��⠥��� ��⠭����� ��୥��� ��⠫�� ��������� ��᪠}
  {$I+} {����砥� ��� ����஫� �訡�� �����-�뢮��}
  IF IOResult <> 0 THEN ShowErrorParams(1); {�᫨ �������� �訡��, �����頥� ���짮��⥫�}
  ChDir(TempStr); {� ��⨢��� ��砥 ��⠭�������� ����� ��ࢮ��砫�� ��⠫��}
  Assign(MessagesFile,SourceFileName); {�஢��塞 ��室�� 䠩� �� ����⢮�����}
  {$I-} {�⪫�砥� ��� ����஫� �訡�� �����-�뢮��}
  Reset(MessagesFile); {���뢠�� 䠩� ��� �⥭��}
  {$I+} {����砥� ��� ����஫� �訡�� �����-�뢮��}
  IF IOResult <> 0 THEN ShowErrorParams(2); {�᫨ �������� �����-� �訡��, ᮮ�頥� ���짮��⥫�}
  Close(MessagesFile); {���� ����뢠�� 䠩�}
  IF DiskFree(Ord(UpCase(VMDisk[1]))-64) <= 64*PageSize THEN ShowErrorParams(3);
  {���樠�����㥬 ��ࢮ��砫�� ࠧ��� ����㠫쭮� ����� �� 1 ��������}
  GotoXY(1,WhereY);
  IF WorkMode <> 1 THEN Write(Texts[14]);
  InitSVM(0,2048*PageSize,WinCountVM,VMDisk[1],'svmac.swp');
  GotoXY(1,WhereY);
  IF WorkMode <> 1 THEN Write('                                                                       ');
  GotoXY(1,WhereY);
  YLine:=WhereY; {����砥� ���न���� Y ��� �뢮�� ����� �������樨}
  GotoXY(1,YLine); {��ॢ���� ����� � ��砫� ��ப�}
  {�᫨ ��ப� ���� 15, � ��������� ��࠭ �� �㦭��� �஢��}
  IF (YLine > 15) AND (WorkMode <> 1) THEN BEGIN FOR n:=1 TO 10-(25-YLine) DO
  IF WorkMode <> 1 THEN
   WriteLn('                                                                               ');
   YLine:=15;
  END;
  LY:=1;
  IF WorkMode <> 1 THEN Window(1,YLine+5,80,25);
  {��⠭�������� ��楤��� ���짮��⥫� ���������}
  @ShowCompillInfo:=@IndicateProcess; {��� �뢮�� ����� �������樨}
  @ErrorCompiller:=@ShowError; {��� �뢮�� �訡�� �������樨}
  {��� �뢮�� ᮮ�饭�� �������権}
  IF MessagesDialogType = ScreenDialog THEN @MessageCompiller:=@ShowMessages ELSE
     @MessageCompiller:=@ShowMessagesFile;
  IF MessagesDialogType <> ScreenDialog THEN BEGIN
   {������� ��� 䠩�� � ���஬ �㤥� ��࠭��� ���� �����}
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
   {�뢮��� �⠭����� ��������� � 䠩� ����� �����}
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
  InitCompiller; {���樠�����㥬 ��������� ��। ����ᮬ �������樨}
  GetTime(h,m,s,nso); {���������� �६� ��砫� �������樨}
  Compiller(SourceFileName); {��������㥬 䠩� SourceFileName}
  GetTime(nh,nm,ns,nnso); {���������� �६� ���� �������樨}
  {������� ��� 䠩�� � ���஬ �㤥� ��࠭��� �⪮�����஢����� �ணࠬ��}
  ResultFileName:=SourceFileName;
  REPEAT
   IF Pos('\',ResultFileName) <> 0 THEN
      Delete(ResultFileName,1,Pos('\',ResultFileName));
  UNTIL Pos('\',ResultFileName) = 0;
   IF Pos('.',ResultFileName) <> 0 THEN
      ResultFileName:=Copy(ResultFileName,1,Pos('.',ResultFileName)-1);
  ResultFileName:=ResultDirectories+ResultFileName+'.SVM';
  {���࠭塞 १���� �������樨 � 䠩�}
  GetResultInfo(Info);
  IF Info.ErrorNumber = 0 THEN SaveResultToFile(ResultFileName);
  IF MessagesDialogType = DiskDialog THEN BEGIN
   {�⠭���⭮� �����襭�� 䠩�� ����� �����}
   WriteLn(MessagesFile,'');
   WriteLn(MessagesFile,';----------------------------------------------------------------------------;');
   WriteLn(MessagesFile,';                           End of messages file                             ;');
     Write(MessagesFile,';----------------------------------------------------------------------------;');
   Close(MessagesFile);
  END;
  {��।��� ��楤��, ��������饩 ����� �����, ⨯ ������㥬�� �����}
  IF Info.ErrorNumber = 0 THEN BEGIN
   SaveMapFile(MapType);
  END;
  DoneVM;
  {�᫨ � १���� �������樨 �訡�� ���, � �뢮��� ���ଠ樨� � ����砭��}
  IF Info.ErrorNumber = 0 THEN ShowFinishInfo;
  {��⠭�������� ����� � ������ ���� 㣮�}
  Window(1,1,80,25); GotoXY(1,25);
  TextColor(7);
  TextBackGround(0);
  IF WorkMode <> 0 THEN BEGIN
   RestoreScreen(TempScreen);
  END;
  CursorOn;
 END.
