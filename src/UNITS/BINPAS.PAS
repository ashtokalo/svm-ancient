uses Dos,Crt;
var f2: Text;
    f1: File Of Byte;
    s1,s2,s3,s4,s5,s6, discr: string;
    n: LongInt;
    fs: LongInt;
    m: Byte;
    p:Byte;
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

begin
 discr:='NoDiscriptions';
 WriteLn('BIN to PAS Converter Version 1.1  Copyright (c) 1999 ShAG Studio');
 s1:=ParamStr(1);
 IF s1 = '' THEN BEGIN
  WriteLn('Usage:    BINPAS  <filename> [options[options]] ');
  WriteLn('Options                Discription');
  WriteLn(' /D                    Add discription file to PAS file');
  WriteLn(' /BPH                  Shaw BIN to PAS Converter Utility help');
  WriteLn(' /PAS <filename[.PAS]> Set PAS file name');
  Halt;
 END;
 IF TestCS('/D') THEN BEGIN
  Write('Input discription for ',s1,' file: ');
  ReadLn(Discr);
  Discr:=#39+Discr+#39;
 END;
 s2:=s1;
 IF Pos('.',s2) <> 0 THEN Delete(s2,Pos('.',s2),Length(s2)-Pos('.',s2)+1);
 s4:=s2;
 s2:=s2+'.pas';
 IF TestCS('/PAS') AND (ParamStr(N+1) <> '') THEN BEGIN
  s2:=ParamStr(N+1);
  IF Pos('.',s2) <> 0 THEN Delete(s2,Pos('.',s2),Length(s2)-Pos('.',s2)+1);
  s4:=s2;
  IF Pos('.',s2) = 0 THEN s2:=s2+'.pas';
 END;
 Assign(f1,s1);
 Assign(f2,s2);
 {$I-}
 Reset(f1);
 ReWrite(f2);
 {$I+}
 IF IOResult <> 0 THEN BEGIN
  WriteLn('Error: Can`t open sourse file or can`t creat PAS file.');
  Halt;
 END;
 s6:='{==== ��� 䠩�� �ਣ�����:                                               ====}';
 Delete(s6,28,Length(s1));
 Insert(s1,s6,28);
 WriteLn(f2,'{============================================================================}');
 WriteLn(f2,'{====  BIN to PAS Converter Version 1.1  Copyright (c) 1999 ShAG Studio  ====}');
 WriteLn(f2,'{====------------------------------------------------------�����������Ŀ-====}');
 WriteLn(f2,'{==== ������ ���� ᮧ��� � ������� �ணࠬ�� BINPAS ������ �Version 1.1� ====}');
 WriteLn(f2,'{====------------------------------------------------------�������������-====}');
 WriteLn(f2,'{====  ����� �ᯮ����  ᯥ樠��� ����� ᮣ��ᮢ���� BINPASU �᫨ � ====}');
 WriteLn(f2,'{==== ��� ��� ��� �� ����� ������� ��� �� 䠩�� BINPAS  ��� � ����⢥ ====}');
 WriteLn(f2,'{==== ��ࠬ��� ��ப�  /E binpasu[n].tpu ��� ����� �㪢� [n] �� ������ ====}');
 WriteLn(f2,'{==== ���⠢��� ����� ����  ���ᨨ ��᪠�� ���  ���ண� �㦥� �����, ====}');
 WriteLn(f2,'{==== ���ਬ��: BINPAS /E binpasu7.tpu ᮧ����  �����  binpasu7.tpu ��� ====}');
 WriteLn(f2,'{==== Turbo Pascal 7.0, ��᫥ �⮣� �� ������ ���� ���� ���ᨨ �� ��� ====}');
 WriteLn(f2,'{==== �����, �.�. binpasu7.tpu --> binpasu.tpu  ��᫥ �⮣� ����� ����� ====}');
 WriteLn(f2,'{==== �ᯮ�짮����. �஬�  ⮣� �� �����  ���� �������  BINPAS /S �⮡� ====}');
 WriteLn(f2,'{==== ��ᬮ���� ᯨ᮪ ���㫥� � ��㣨� 䠩��� �࠭����� � BINPAS.    ====}');
 WriteLn(f2,'{====  �᫨ �� ��� �⮡� �  ������祭�� 䠩��� ��  ⠪�� �� 㤮��� ====}');
 WriteLn(f2,'{==== �����, ��� � 䠩��� �࠭�騬��  � BINPAS, ���� ᤥ���� ᫥���饥: ====}');
 WriteLn(f2,'{====  � � �ணࠬ��  ����� �ᯮ����  ��� � ��㣨� ⠪�� 䠩�� ���� ====}');
 WriteLn(f2,'{==== �������� �����  BINPASU ��।  �ᥬ� ��㣨�� ����ﬨ, ��� ⮣�, ====}');
 WriteLn(f2,'{==== �⮡� ����� ᬮ� ��ॣ����஢��� �� ���㫨 ᮧ����� �ணࠬ��� ====}');
 WriteLn(f2,'{==== BINPAS (�᫨ ��� ����� ��������� ��। BINPASU, � �� ࠡ�� � ====}');
 WriteLn(f2,'{==== BINPASU � ��� �� �㤥� ����㯠 � �⮬�  ����� - ����� �� �㤥� � ====}');
 WriteLn(f2,'{==== ᯨ᪥ 䠩���);                                                    ====}');
 WriteLn(f2,'{====  � ᫥���騩 頣 - � �᭮���� �ணࠬ�� �ࠧ� ��᫥  ������� BEGIN ====}');
 WriteLn(f2,'{==== ���� �맢���  ��楤��� ���樠����樨 �����  BINPASU - InitBPU  � ====}');
 WriteLn(f2,'{==== �⮩ ��楤�� �����  �஢���� ���������  ��ப� ��  ᢮� ��樨, ====}');
 WriteLn(f2,'{==== �᫨ �� ��室�� ᢮� ����  �� �믮����  ᮮ⢥��������  ������� ====}');
 WriteLn(f2,'{==== � �����蠥� ࠡ��� �ணࠬ�� �������� Halt(0);                     ====}');
 WriteLn(f2,'{====  ����� ���஡��� �������� �� ����� ������� �� 䠩�� README.TXT ====}');
 WriteLn(f2,'{==== �����  �࠭���� � �ணࠬ��  BINPAS, ���  ����� ������  �������� ====}');
 WriteLn(f2,'{==== BINPAS /E readme.txt.                                              ====}');
 WriteLn(f2,'{====--------------------------------------------------------------------====}');
 WriteLn(f2,s6);
 WriteLn(f2,'{============================================================================}');
 s4[1]:=UpCase(s4[1]);
 WriteLn(f2,'                               UNIT ',s4,';');
 WriteLn(f2,'{============================================================================}');
 WriteLn(f2,'                                INTERFACE');
 WriteLn(f2,'{============================================================================}');
 WriteLn(f2,' USES Dos, Crt, BINPASU;');
 WriteLn(f2,'');
 fs:=FileSize(f1);
 IF fs < 32000 THEN WriteLn(f2,' TYPE  ',s4,'_FileType = ARRAY [0..',FileSize(f1)-1,'] OF Byte;');
 Write(f2,' CONST ');
 IF fs < 32000 THEN WriteLn(f2,s4,'_File: ',s4,'_FileType = (') ELSE
  WriteLn(f2,s4,'_File: ARRAY [0..',FileSize(f1)-1,'] OF Byte = (');
 s5:='        ';
 p:=0;
 For n:=1 TO fs DO BEGIN
  IF p <> Trunc(n * (100/fs)) THEN BEGIN
   p:=Trunc(n * (100/fs));
   GotoXY(1,WhereY);
   Write('Compleat ',Trunc(n * (100/fs)), ' %');
  END;
  Read(f1,m);
  Str(m,s3);
  IF Length(s3) = 1 THEN s3:='  '+s3;
  IF Length(s3) = 2 THEN s3:=' '+s3;
  s5:=s5+s3;
  IF n <> FileSize(f1) THEN s5:=s5+', ';
  IF Length(s5) > 73 THEN BEGIN
   WriteLn(f2,s5);
   s5:='        ';
  END;
 END;
 IF Length(s5) > 6 THEN Write(f2,s5);
 Write(f2,');');
 WriteLn(f2,'');
 WriteLn(f2,'      ',s4,'_FileName: String = ',#39,s1,#39,';');
 WriteLn(f2,'      ',s4,'_FileSize: LongInt = ',fs,';');
 WriteLn(f2,' {�㭪�� �����頥� ���� �� 䠩�� �� ��� ������}');
 WriteLn(f2,' FUNCTION ',s4,'_GetB(N: LongInt): Byte;');
 WriteLn(f2,'{============================================================================}');
 WriteLn(f2,'                                IMPLEMENTATION');
 WriteLn(f2,'{============================================================================}');
 WriteLn(f2,'');
 WriteLn(f2,' {�㭪�� �����頥� ���� �� 䠩�� �� ��� ������}');
 WriteLn(f2,' FUNCTION ',s4,'_GetB(N: LongInt): Byte;');
 WriteLn(f2,' BEGIN');
 WriteLn(f2,'  ',s4,'_GetB:=',s4,'_File[N];');
 WriteLn(f2,' END;');
 WriteLn(f2,'');
 WriteLn(f2,'{===== BIN to PAS Converter Version 1.1  Copyright (c) 1999 ShAG Studio =====}');
 WriteLn(f2,' BEGIN');
 WriteLn(f2,'  {��������㥬 䠩� � ���㫥 BINPASU}');
 WriteLn(f2,'  RegisterFile(@',s4,'_GetB,',s4,'_FileName,',discr,',',s4,'_FileSize);');
 WriteLn(f2,' END.');
 Write(f2,'{===== BIN to PAS Converter Version 1.1  Copyright (c) 1999 ShAG Studio =====}');
 Close(f2);
 Close(f1);
 GotoXY(1,WhereY);
 WriteLn('Compleat 100 %  -  Ok');
 WriteLn('Creat PAS file: ',s2);
end.