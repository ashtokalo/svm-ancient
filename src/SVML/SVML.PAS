{$A+,B+,D-,E-,F+,G+,I-,L-,N+,O-,P+,Q-,R-,S-,T+,V+,X+}
{$M 16384,0,655360}

USES Crt, SVM_n, SGI, SEMME_e, SVML_U2, SVML_U1, SVML0_13, SVML2_8, SVML_CSP, SFI, SIFI;

VAR diagonal: Real;
    mouset: Byte;
    MouseCall: PROCEDURE;
{============================================================================}
 {Процедуры отвечающие за реализацию каждой команды}
 {$I SVML.INC}

 PROCEDURE FreeCall;
 BEGIN
 END;

 PROCEDURE RunFile;
 BEGIN
  ComN:=PRG.GetB(RegArea.LIP);
  ComD:=PRG.GetB(RegArea.LIP+1);
  REPEAT
   MouseCall;
   c1:=0; c2:=0;
   @SVMComand:=ComArray[ComN];
   SVMComand;
   ComN:=PRG.GetB(RegArea.LIP);
   ComD:=PRG.GetB(RegArea.LIP+1);
  UNTIL (RegArea.LIP = Info.FinishPoint) OR (ComN > 60) OR (Port[$60] = 88);
 END;

PROCEDURE LoadIniFile;
VAR tstr: String;
    c,t: Integer;
BEGIN
 Write(' Read configuration file...');
 tstr:=GetItem('svml.ini','OPTIONS','GRAPHICS_MODE');
 Val(tstr,GrMode,c);
 IF c <> 0 THEN GrMode:=1;
 MaxX:=640; MaxY:=480;
 CASE GrMode OF
  0: BEGIN GrMode:=4; MaxX:=320; MaxY:=200; END;
  1: BEGIN GrMode:=2; MaxX:=640; MaxY:=480; END;
  2: BEGIN GrMode:=5; MaxX:=640; MaxY:=480; END;
  3: BEGIN GrMode:=6; MaxX:=800; MaxY:=600; END;
  4: BEGIN GrMode:=7; MaxX:=1024; MaxY:=768; END;
  5: BEGIN GrMode:=8; MaxX:=1152; MaxY:=864; END;
  6: BEGIN GrMode:=9; MaxX:=1280; MaxY:=1024; END;
 END;

 tstr:=GetItem('svml.ini','OPTIONS','DIAGONAL');
 Val(tstr,t,c);
 diagonal:=t;
 IF c <> 0 THEN diagonal:=14;

 tstr:=GetItem('svml.ini','OPTIONS','TOTAL_FONTS');
 Val(tstr,t,c);
 TotalFonts:=t;
 IF c <> 0 THEN TotalFonts:=2;

 tstr:=GetItem('svml.ini','OPTIONS','SWAP_DISK');
 IF (tstr = 'DEFAULT') or (tstr = INIFileNotFound) or
    (tstr = FolderNotFound) or (tstr = ItemNotFound) THEN
    VMDISK:='C' ELSE VMDISK:=tstr[1];

 @MouseCall:=@MouseRun;

 GotoXY(1,WhereY);
 WriteLn(' Read configuration file - Ok');
END;

PROCEDURE LoadFonts;
VAR n, tf: Integer;
    tstr: String;
BEGIN
 tf:=TotalItem('svml.ini','FONTS');
 IF tf = 0 THEN BEGIN
  WriteLn('Fonts absent in system.');
  TotalFonts:=0;
  Exit;
 END;
 WriteLn(' Loading system fonts...');
 FOR n:=0 TO tf-1 DO BEGIN
  tstr:=NumberToItem('svml.ini','FONTS',n+1);
  Write('  Loading '+tstr+' ...');
  tstr:=GetItem('svml.ini','FONTS',tstr);
  RegisterFontFile(tstr,Fonts[n]);
  GotoXY(1,WhereY);
  tstr:=NumberToItem('svml.ini','FONTS',n+1);
  WriteLn('  Loading '+tstr+' - Ok');
 END;
 TotalFonts:=tf;
END;

FUNCTION UpString(str: String): String;
VAR n: Byte;
BEGIN
 FOR n:=1 TO Length(str) DO Str[n]:=UpCase(Str[n]);
 UpString:=Str;
END;

{========================= Основная программа ===============================}
BEGIN
 VMFile:='svml.swp';
 Loc:=0;
 WriteLn('SVM Loader  Version 1.0  Copyright (c) 1999 ShAG Studio');
 @MouseCall:=@FreeCall;
 SourceName:=ParamStr(1);
 IF SourceName = '' THEN Halt(0);
 LoadINIFile;
 LoadFile;
 InitCom;
 InitFI(diagonal);
 IF (UpString(ParamStr(2)) <> '/NF') THEN LoadFonts;
 AddrSeg:=Seg(RegArea);
 AddrOfs:=Ofs(RegArea);
 SelectFonts:=0;
 WriteLn(' Programm started...');
 Randomize;
 RunFile;
 DestroyGI;
 WriteLn(' Programm finished...');
{ Close(SWPFile);
 Erase(SWPFile); }DoneVM;
END.
{============================================================================}
