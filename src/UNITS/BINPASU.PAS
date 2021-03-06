{=======================BIN to PAS Converter Utility=========================}
{====  ��⤥প� ���㫥�  ᮧ������ � ������� �ணࠬ�� BINPAS           ====}
{====                           ����� 1.1                               ====}
{====--------------------------------------------------------------------====}
{====  ����� ࠧ�蠥��� �ᯮ�짮���� ⮫쪮 � ��������᪨� 楫��, �� ====}
{==== �᫮���, �� ��室�� ⥪�� ��� �ணࠬ� ����ᠭ��� � �ᯮ�짮��- ====}
{==== ���� �⮣� ����� ������� �⮪��� ����ᥩ �����������, �� ⠪��   ====}
{==== �� �ࠢ��, ��� � ��� �����, �஬� ����祭�� ����� �ணࠬ�.      ====}
{====--------------------------------------------------------------------====}
{====  ����� ᮧ��� � Turbo Pascal 7.0                                  ====}
{====--------------------------------------------------------------------====}
{====  �����  �������� ��ᬮ����  ᯨ᮪ 䠩���  ������祭��� � ���� ====}
{==== ���㫥� ᮧ������  �ணࠬ��� BINPAS, �஬�  ⮣� ����� �������� ====}
{==== ������� 䠩��, � �� �ਣ�����, �� �ᯮ��塞��� 䠩��.              ====}
{====  ������� ���ਭ������ ���㫥� �� ��������� ��ப�:               ====}
{====  /S    -  �������� ᯨ᮪ ��� ������祭��� 䠩���                 ====}
{====  /E    -  ������ 䠩� �� �ᯮ��塞��� 䠩��                        ====}
{====--------------------------------------------------------------------====}
{====  P.S.   ��  �����祭��  䠩���  �  �������  ����  /E   ᫥���騬 ====}
{==== ��易⥫�� ��ࠬ��஬  ���� ��� ������������ 䠩��  ᮣ��᭮ ====}
{==== ���� 䠩��� (�.�. 䠩� ������  ��室����� � ᯨ᪥  ������祭��� ====}
{==== 䠩���), �஬� ⮣� ����� ������� �� 䠩�� ��� � ����⢥ ��ண� ====}
{==== ��ࠬ��� *.*, ⠪ �� ����� ������� 䠩�� �� ���७�� ��� ���� ====}
{==== ��ࠬ��஬ ��ப� *.ext (����� ext ����⠢��� �㦭�� ���७��). ====}
{============================================================================}
                                  UNIT BinPasU;
{============================================================================}
                                   INTERFACE
{============================================================================}
 USES Dos,Crt;

 CONST NoDiscriptions = '';
 PROCEDURE InitBPU;
 PROCEDURE RegisterFile(Start: Pointer; FileName, Description: String; FileSize: LongInt);

{============================================================================}
                                  IMPLEMENTATION
{============================================================================}
 TYPE Str12 = String[12];
 TYPE DscrStr = String[40];
 TYPE TDiscription = ^DscrStr;
 TYPE GB = FUNCTION (n: LongInt): Byte;
 VAR  ListDiscription: ARRAY [0..255] OF TDiscription;
      ListName: ARRAY  [0..255] OF Str12;
      ListSize: ARRAY  [0..255] OF LongInt;
      ListStart: ARRAY [0..255] OF GB;
      Counter, N: Word;
      GetB:GB;

 PROCEDURE FreeProc;
 BEGIN
 END;

 FUNCTION  TestCS(s: String): Boolean;
 VAR  ts: String;
      N1: Byte;
 BEGIN
  FOR N1:=1 TO Length(s) DO s[N1]:=UpCase(s[N1]);
  FOR N:=1 TO ParamCount DO BEGIN
   ts:=ParamStr(N);
   FOR N1:=1 TO Length(ts) DO ts[N1]:=UpCase(ts[N1]);
   IF s = ts THEN BEGIN
    TestCS:=True;
    Exit;
   END;
  END;
  TestCS:=False;
 END;

 PROCEDURE ShawFiles;
 VAR TS,N,k: LongInt;
     s: String;
 BEGIN
  WriteLn('BIN to PAS Converter Utility Version 1.1  Copyright (c) 1999 ShAG Studio');
  IF Counter = 0 THEN BEGIN WriteLn('Files not found.'); Halt(0); END;
  WriteLn('�������������������������������������������������������������������������������');
  WriteLn('  File Name     File Size         Discription');
  WriteLn('�������������������������������������������������������������������������������');
  TS:=0;
  FOR N:=0 TO Counter-1 DO BEGIN
   Write('  ',ListName[n]);
   GotoXY(17,WhereY);
   s:='';
   Str(ListSize[N],s);
   k:=Length(s);
   Write((ListSize[N]*1.0):k:0,' bytes');
   ts:=ListSize[N]+ts;
   IF ListDiscription[N] <> NIL THEN BEGIN
    GotoXY(35,WhereY);
    WriteLn(ListDiscription[N]^);
   END ELSE BEGIN
    GotoXY(35,WhereY);
    WriteLn('No discriptions');
   END;
  END;
  WriteLn('�������������������������������������������������������������������������������');
  Str(ts,s);
  k:=Length(s);
  WriteLn('  Total ',(ts*1.0):k:0,' bytes in ',Counter,' file(s).');
  Halt(0);
 END;

 PROCEDURE ExtractFile(e: String);
 VAR  N1: Word;
      N2: LongInt;
      b,lp,p,fl: Byte;
      f: File Of Byte;
 BEGIN
  WriteLn('BIN to PAS Converter Utility Version 1.1  Copyright (c) 1999 ShAG Studio');
  fl:=0;
  FOR N:=1 TO Length(e) DO e[N]:=UpCase(e[N]);
  FOR N:=0 TO Counter-1 DO BEGIN
   FOR N1:=1 TO Length(ListName[N]) DO ListName[N][N1]:=UpCase(ListName[N][N1]);
   IF (ListName[N] = e) OR (e = '*.*') OR
      ((Copy(ListName[N],Pos('.',ListName[N])+1,Length(ListName[N])-Pos('.',ListName[N])-1) =
       Copy(e,Pos('.',e)+1,Length(e)-Pos('.',e)-1)) AND (Copy(e,1,2) = '*.')) THEN BEGIN
    fl:=1;
    Write('Extracting  ',ListName[N]);
    @GetB:=@ListStart[N];
    Assign(f,ListName[N]);
    {$I-}
    ReWrite(f);
    {$I+}
    IF IOResult <> 0 THEN BEGIN
     WriteLn('Can`t creat ',ListName[N],' file');
     Exit;
    END;
    lp:=255;
    FOR N2:=0 TO ListSize[N]-1 DO BEGIN
     GotoXY(40,WhereY);
     p:=Trunc(100/(ListSize[N]-1)*N2);
     IF lp <> p THEN Write(p,' % compleat');
     lp:=p;
     b:=GetB(N2);
     {$I-}
     Write(F,b);
     {$I+}
     IF IOResult <> 0 THEN BEGIN
      WriteLn('Can`t creat ',ListName[N],' file');
      Exit;
     END;
    END;
    Close(f);
    GotoXY(40,WhereY);
    WriteLn('OK                  ');
   END;
  END;
  IF fl = 1 THEN BEGIN
   WriteLn('Done.');
  END;
  IF fl=0 THEN WriteLn('File not found.');
  Halt(0);
 END;

 PROCEDURE ShawHelp;
 VAR s,s1: String;
     N,k: Word;
 BEGIN
  s:=ParamStr(0);
  FOR n:=1 TO Length(s) DO s[n]:=UpCase(s[n]);
  s1:=s;
  k:=1;
  REPEAT
   IF Pos('\',s1) <> 0 THEN Delete(s1,1,Pos('\',s1)) ELSE k:=0;
  UNTIL k=0;
  s:=s1;
  IF Pos('.',s) <> 0 THEN s:=Copy(s,1,Pos('.',s)-1);
  WriteLn('BIN to PAS Converter Utility Version 1.1  Copyright (c) 1999 ShAG Studio');
  WriteLn('Usage:    ',s,'  [options[filename]]');
  WriteLn('Options         Discription');
  WriteLn(' /S             Shaw dir, that containing in ',s1);
  WriteLn(' /E <filename>  Extract <filename> file from ',s1);
  WriteLn('                use /E *.* to extract all files from ',s1);
  WriteLn('                use /E *.<extansion> to extract select files from ',s1);
  WriteLn(' /BPH           Shaw this help');
  WriteLn(' /NBP           Use this option if you don`t want to use');
  WriteLn('                BIN to PAS Converter Utility in comand line.');
  Halt(0);
 END;

 PROCEDURE InitBPU;
 BEGIN
  IF TestCS('/NBP') THEN Exit;
  IF TestCS('/S') THEN ShawFiles;
  IF TestCS('/E') THEN ExtractFile(ParamStr(N+1));
  IF TestCS('/BPH') THEN ShawHelp;
 END;

 PROCEDURE RegisterFile(Start: Pointer; FileName, Description: String; FileSize: LongInt);
 BEGIN
  IF Counter = 256 THEN Exit;
  IF (MaxAvail > SizeOf(DscrStr)) AND (Description <> '') THEN BEGIN
   New(ListDiscription[Counter]);
   ListDiscription[Counter]^:=Description;
  END;
  ListName[Counter]:=FileName;
  ListSize[Counter]:=FileSize;
  @ListStart[Counter]:=Start;
  Inc(Counter);
 END;

{============================================================================}
BEGIN
 Counter:=0;
 FOR N:=0 TO 255 DO BEGIN
  ListDiscription[n]:=NIL;
  ListStart[n]:=NIL;
 END;
END.
{============================================================================}