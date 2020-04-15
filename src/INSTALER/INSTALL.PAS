{$A+,B+,D-,E+,F+,G-,I+,L-,N-,O+,P+,Q-,R-,S+,T+,V+,X+}
{$M 32768,0,100000}

uses Crt, Dos, SSI, SIFI;

{$L cpuid.obj}
function  GetCPUType: Byte; EXTERNAL;

const commandfilename: String[12] = 'install.cmd';
      maxcomparam = 10;
      maxvariable = 10;
      totalstr = 5;
      helptext: array [0..4] of String[35] =
      ('ShAG Installer',' ','Verison 1.0',' ','Copyright (c) 2000 ShAG Studio');
var  originalscreen, tempscr, prgscr: TScreen;
     commandfile: Text;
     textimage: array [0..22] of String[78];
     tstr, comname,maindisk,mainpath: String;
     paramtype: array [0..maxcomparam-1] of Byte;
     paramstr: array [0..maxcomparam-1] of String;
     paramval: array [0..maxcomparam-1] of LongInt;
     varname: array [0..maxvariable-1] of String[32];
     varstr: array [0..maxvariable-1] of String;
     totalcomparam, totalvar, n, k, imagelines, cf: Word;
     l,l1,l2: LongInt;
     i: Integer;
     if_t: Byte;
     t_l, f_l, et_l, ef_l, iff, tru, fals: Boolean;
     totalfiles, makefiles: LongInt;


procedure ExitProc(s: String);
begin
 {$I-}
 close(commandfile);
 {$I+}
 RestoreScreen(originalscreen);
 TextColor(LightGray);
 TextBackGround(Black);
 if s <> '' then WriteLn(s);
 Halt(0);
end;

function DeleteLRS(str: String): String;
var n: Byte;
begin
 n:=1;
 while (str[n] = ' ') and (n < length(str)) do inc(n);
 dec(n);
 Delete(str,1,n);
 n:=length(str);
 while (str[n] = ' ') and (n > 1) do dec(n);
 inc(n);
 Delete(str,n,length(str)-n+1);
 if str = ' ' then str:='';
 DeleteLRS:=str;
end;

function IsVar(str: String): Boolean;
var n: Byte;
begin
 IsVar:=True;
 for n:=0 to totalvar-1 do
  if str = varname[n] then Exit;
 IsVar:=False;
end;

function VarNo(str: String): Word;
var n: Byte;
begin
 for n:=0 to totalvar-1 do begin
  VarNo:=n;
  if str = varname[n] then Exit;
 end;
 VarNo:=65535;
end;

procedure Correct;
var n: Byte;
begin
 if cf <> 0 then Exit;
 for n:=0 to totalcomparam-1 do
  if IsVar(paramstr[n]) then paramstr[n]:=varstr[VarNo(paramstr[n])];
 cf:=255;
end;

 procedure ShowHelp;
 var x,y,l,n: Integer;
     key: Byte;
 begin
  SaveScreen(SSITempScreen);
  l:=TotalStr;
  x:=20;
  y:=(25-l) div 2;
  ShowWindow(x,y,x+43,y+l+3,DoubleB, 'About', Wincolor);
  l:=0;
  for n:=0 to TotalStr-1 do
   WriteString(x+((43-length(HelpText[n])) div 2),y+2+n,HelpText[n],WinColor);
  repeat
   key:=Ord(ReadKey);
  until key in [13,32,27];
  RestoreScreen(SSITempScreen);
 end;

function CopyFile(inf, outf: String): Boolean;
var
  FromF, ToF: file;
  NumRead, NumWritten: Word;
  Buf: array[1..16384] of Char;
begin
 Assign(FromF, inf);
 {$I-}
 Reset(FromF, 1);
 {$I+}
 if IOResult <> 0 then begin
  CopyFile:=False;
  Exit;
 end;
 Assign(ToF, outf);
 {$I-}
 Rewrite(ToF, 1);
 {$I+}
 if IOResult <> 0 then begin
  CopyFile:=False;
  Exit;
 end;
 repeat
   BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
   BlockWrite(ToF, Buf, NumRead, NumWritten);
 until (NumRead = 0) or (NumWritten <> NumRead);
 Close(FromF);
 Close(ToF);
 CopyFile:=True;
end;

{Функция удаляет коментарий из строки (все что после знака ComentSign)}
FUNCTION DeleteComent(str: String): String;
VAR n, n2: byte;
    sln: byte ABSOLUTE str;
    op1,op2: Boolean;
    s: String;
BEGIN
 op1:=FALSE;
 op2:=FALSE;
 s:='';
 DeleteComent:='';
 FOR n:=1 TO sln DO BEGIN
  IF (str[n] = '"') AND NOT op2 THEN op1:=NOT op1;
  IF (str[n] = #39) AND NOT op1 THEN op2:=NOT op2;
  IF (str[n] = ';') AND NOT op1 AND NOT op2 THEN Exit;
  s:=s+str[n];
  DeleteComent:=s;
 END;
END;

function CorrectString(str: String):String;
var t: Byte;
begin
 repeat
  IF Pos('MAINDISK',UpString(str)) <> 0 then begin
   t:=Pos('MAINDISK',UpString(str));
   Delete(Str,t,8);
   Insert(maindisk[1],Str,t);
  end;
 until Pos('MAINDISK',UpString(str)) = 0;
 repeat
  IF Pos('SOURCEPATH',UpString(str)) <> 0 then begin
   t:=Pos('SOURCEPATH',UpString(str));
   Delete(Str,t,10);
   Insert(mainpath,Str,t);
  end;
 until Pos('SOURCEPATH',UpString(str)) = 0;
 CorrectString:=str;
end;

begin
 {$I-}
 GetDir(0,mainpath);
 maindisk:=mainpath[1];
 CheckBreak:=False;
 WriteLn('ShAG Installer  Version 1.0  Copyright (c) 1999 ShAG Studio');
 SaveScreen(originalscreen);
 SaveScreen(prgscr);
 CursorOff;
 FillWindow(1,1,80,25,Chr(176),DeskTopColor);
 WriteSL('');
 imagelines:=0;
 totalvar:=0;  iff:=False; t_l:=False; et_l:=False; f_l:=False; ef_l:=False;
 if_t:=0;
 totalfiles:=1; makefiles:=0;

 assign(commandfile,commandfilename);
 {$I-}
 reset(commandfile);
 {$I+}
 if IOResult <> 0 then begin
  ShowMDialog(60,CenterText,'Error','For this program need file with name ~'+
                                    commandfilename+'~ and it mast content '+
                                    'command by ShAG Installer Script. ','~E~xit',WinColor);
  RestoreScreen(originalscreen);
  TextColor(LightGray);
  TextBackGround(Black);
  WriteLn('For this program need file with name ~'+
           commandfilename+'~ and it mast content  '+
           'command by ShAG Installer Script.');
  Halt(0);
 end;

 repeat
  cf:=0;
  readln(commandfile,tstr);
  tstr:=DeleteComent(tstr);
  if TotalWords(tstr,' ,()') <> 0 then begin
  tstr:=CorrectString(tstr);
  if Pos('(',tstr) = 0 then tstr:=tstr+'(';
  comname:=Copy(tstr,1,Pos('(',tstr)-1);
  comname:=UpString(DeleteLRS(comname));

  if (comname = 'THEN') and t_l then begin
   repeat
    readln(commandfile,tstr);
    if Pos('(',tstr) = 0 then tstr:=tstr+'(';
    comname:=Copy(tstr,1,Pos('(',tstr)-1);
    comname:=UpString(DeleteLRS(comname));
   until EOF(commandfile) or (comname = 'ENDTHEN');
   readln(commandfile,tstr);
   if Pos('(',tstr) = 0 then tstr:=tstr+'(';
   comname:=Copy(tstr,1,Pos('(',tstr)-1);
   comname:=UpString(DeleteLRS(comname));
   t_l:=False;
   et_l:=False;
  end;

  if (comname = 'ELSE') and f_l then begin
   repeat
    readln(commandfile,tstr);
    if Pos('(',tstr) = 0 then tstr:=tstr+'(';
    comname:=Copy(tstr,1,Pos('(',tstr)-1);
    comname:=UpString(DeleteLRS(comname));
   until EOF(commandfile) or (comname = 'ENDELSE');
   readln(commandfile,tstr);
   if Pos('(',tstr) = 0 then tstr:=tstr+'(';
   comname:=Copy(tstr,1,Pos('(',tstr)-1);
   comname:=UpString(DeleteLRS(comname));
   f_l:=False;
   ef_l:=False;
  end;

  Delete(tstr,1,Pos('(',tstr));
  Delete(tstr,Length(tstr),1);
  totalcomparam:=TotalWords(tstr,',');
  if totalcomparam > maxcomparam then totalcomparam:=maxcomparam;
  if totalcomparam > 0 then
   for n:=0 to totalcomparam-1 do begin
    paramstr[n]:=DeleteLRS(GetWord(tstr,',',n+1));
    Val(paramstr[n],l,i);
    if i = 0 then begin
     paramval[n]:=l;
     paramtype[n]:=1;
    end else begin
     paramtype[n]:=0;
     paramval[n]:=0;
    end;
   end;

  if comname = 'SHOWIMAGE' then begin
   if paramval[0] < 0 then paramval[0]:=0;
   if paramval[1] < 0 then paramval[1]:=0;
   if paramval[0] > 79 then paramval[0]:=79;
   if paramval[1] > 23 then paramval[1]:=23;
   if paramval[2] < 0 then paramval[2]:=0;
   if paramval[3] < 0 then paramval[3]:=0;
   if paramval[2] > 79 then paramval[2]:=79;
   if paramval[3] > 23 then paramval[3]:=23;
   FillWindow(paramval[0]+1,paramval[1]+1,paramval[2]+1,paramval[3]+1,' ',WinColor);
   for n:=0 to imagelines-1 do if paramval[1]+n < 24 then
     writestring(paramval[0]+1,paramval[1]+n+1,
                 AddS(textimage[n],paramval[2]-paramval[0]+1),WinColor);
  end;

  if (comname = 'NEWVAR') and not IsVar(paramstr[0]) then begin
   if totalvar < maxvariable then varname[totalvar]:=paramstr[0];
   inc(totalvar);
  end;

  if (comname = 'FREEVAR') and (totalvar > 0) and IsVar(paramstr[0]) then begin
   n:=VarNo(paramstr[0]);
   for k:=n to totalvar-1 do varname[k]:=varname[k+1];
   dec(totalvar);
  end;

  if (comname = 'GETPERSENT') and IsVar(paramstr[0]) then begin
   l:=trunc(makefiles/(totalfiles/100));
   str(l,varstr[VarNo(paramstr[0])]);
  end;

  if (comname = 'LET') and IsVar(paramstr[0]) then begin
   n:=0;
   n:=VarNo(paramstr[0]);
   Correct;
   if n <> 65535 then varstr[n]:=paramstr[1];
  end;

  if (comname = 'GETSTRING') and IsVar(ParamStr[5]) then begin
   SaveScreen(TempScr);
   ShowWindow(ParamVal[0],ParamVal[1],ParamVal[0]+64,ParamVal[1]+6,DoubleB,ParamStr[3],WinColor);
   WriteString(ParamVal[0]+2,ParamVal[1]+2,AddS(ParamStr[4],60),WinColor);
   InputText(ParamVal[0]+2,ParamVal[1]+3,60,ParamVal[2],varstr[VarNo(ParamStr[5])],NormalInput);
   RestoreScreen(TempScr);
  end;

  if (comname = 'UPSTRING') and IsVar(ParamStr[0]) then begin
   n:=VarNo(ParamStr[0]);
   varstr[n]:=UpString(varstr[n]);
  end;

  if (comname = 'GETCOMPUTERTYPE') and IsVar(ParamStr[0]) then begin
   l:=GetCPUType;
   if l > 1 then l:=l-1;
   str(l,varstr[VarNo(paramstr[0])]);
  end;


  if (comname = 'GETDISKSIZE') and IsVar(ParamStr[1]) then begin
   n:=VarNo(ParamStr[1]);
   Correct;
   {$I-}
   Str(DiskFree(Ord(UpCase(ParamStr[0][1]))-64),varstr[n]);
   {$I+}
   if IOResult <> 0 then varstr[n]:='0';
  end;

  if (comname = 'CONCAT') and IsVar(ParamStr[0]) then begin
   n:=VarNo(ParamStr[0]);
   k:=VarNo(ParamStr[1]);
   Correct;
   if k < 65535 then varstr[n]:=varstr[n]+varstr[k] else
                     if UpString(paramstr[1]) <> 'SPACE' then
                     varstr[n]:=varstr[n]+paramstr[1] else
                     varstr[n]:=varstr[n]+' ';

  end;

  Correct;

  if comname = 'CLEARIMAGE' then begin
   imagelines:=0;
  end;

  if comname = 'ADDSTRINGTOIMAGE' then begin
   tstr:='';
   for n:=0 to totalcomparam-1 do tstr:=tstr+paramstr[n]+', ';
   Delete(tstr,length(tstr)-1,2);
   if imagelines < 24 then textimage[imagelines]:=tstr;
   inc(imagelines);
  end;

  if comname = 'WRITETOSTATUSLINE' then begin
   tstr:='';
   for n:=0 to totalcomparam-1 do tstr:=tstr+paramstr[n]+', ';
   Delete(tstr,length(tstr)-1,2);
   WriteSL(tstr);
  end;

  if comname = 'SHOWMESSAGE' then begin
   tstr:='';
   for n:=2 to totalcomparam-2 do tstr:=tstr+paramstr[n]+', ';
   Delete(tstr,length(tstr)-1,2);
   ShowMDialog(paramval[0],CenterText,paramstr[1],tstr,paramstr[totalcomparam-1],WinColor);
  end;

  if comname = 'IF'then begin
   Val(paramstr[0],l1,i);
   if i <> 0 then l1:=Length(paramstr[0]);
   Val(paramstr[2],l2,i);
   if i <> 0 then l2:=Length(paramstr[2]);
   tstr:=paramstr[1];
   if tstr = '>' then if_t:=1 else
   if tstr = '<' then if_t:=2 else
   if tstr = '=' then if_t:=3 else
   if tstr = '>=' then if_t:=4 else
   if tstr = '<=' then if_t:=5;
   iff:=True;
   case if_t of
    1: if l1 > l2 then begin Tru:=True; Fals:=False; end else begin Tru:=False; Fals:=True; end;
    2: if l1 < l2 then begin Tru:=True; Fals:=False; end else begin Tru:=False; Fals:=True; end;
    3: if l1 = l2 then begin Tru:=True; Fals:=False; end else begin Tru:=False; Fals:=True; end;
    4: if l1 >= l2 then begin Tru:=True; Fals:=False; end else begin Tru:=False; Fals:=True; end;
    5: if l1 <= l2 then begin Tru:=True; Fals:=False; end else begin Tru:=False; Fals:=True; end;
   end;
   if Tru then begin
    f_l:=True;
    ef_l:=True;
    t_l:=False;
    et_l:=False;
   end else begin
    t_l:=True;
    et_l:=True;
    f_l:=False;
    ef_l:=False;
   end;
  end else iff:=False;

  if comname = 'IF STRING'then begin
   if paramstr[1] = '>' then if_t:=1 else
   if paramstr[1] = '<' then if_t:=2 else
   if paramstr[1] = '=' then if_t:=3 else
   if paramstr[1] = '>=' then if_t:=4 else
   if paramstr[1] = '<=' then if_t:=5;
   iff:=True;
   case if_t of
    1: if paramstr[0] > paramstr[2] then begin Tru:=True; Fals:=False; end else begin Tru:=False; Fals:=True; end;
    2: if paramstr[0] < paramstr[2] then begin Tru:=True; Fals:=False; end else begin Tru:=False; Fals:=True; end;
    3: if paramstr[0] = paramstr[2] then begin Tru:=True; Fals:=False; end else begin Tru:=False; Fals:=True; end;
    4: if paramstr[0] >= paramstr[2] then begin Tru:=True; Fals:=False; end else begin Tru:=False; Fals:=True; end;
    5: if paramstr[0] <= paramstr[2] then begin Tru:=True; Fals:=False; end else begin Tru:=False; Fals:=True; end;
   end;
   if Tru then begin
    f_l:=True;
    ef_l:=True;
    t_l:=False;
    et_l:=False;
   end else begin
    t_l:=True;
    et_l:=True;
    f_l:=False;
    ef_l:=False;
   end;
  end else iff:=False;

  if comname = 'SOUND' then begin
   Sound(paramval[0]);
   Delay(paramval[1]);
   NoSound;
  end;

  if (comname = 'SETPERSENT') then begin
   val(paramstr[0],l,i);
   if i = 0 then totalfiles:=l;
  end;

  if comname = 'EXIT' then begin
   tstr:='';
   if totalcomparam > 0 then
    for n:=0 to totalcomparam-1 do tstr:=tstr+paramstr[n]+', ';
   Delete(tstr,length(tstr)-1,2);
   ExitProc(tstr);
  end;

  if comname = 'EXEC' then begin
   tstr:='';
   for n:=1 to totalcomparam-1 do
    if UpString(paramstr[n]) <> 'SPACE' then tstr:=tstr+paramstr[n] else tstr:=tstr+' ';
   SwapVectors;
   Exec(UpString(paramstr[0]),UpString(tstr));
   SwapVectors;
   makefiles:=makefiles+1;
   if DosError <> 0 then begin
    ShowMDialog(60,CenterText,'Error',
    'Can'#39't execute ~'+UpString(paramstr[0])+'~ with ~'+UpString(tstr)+
    '~ parametrs.'#0+'Installation break!','~E~xit',WinColor);
    ExitProc('Can'#39't execute '+UpString(paramstr[0])+' with '+UpString(tstr)+
    ' parametrs.');
   end;
  end;

  if comname = 'QESTION' then begin
   if ShowQDialog(60,CenterText,0,ParamStr[0],ParamStr[1],ParamStr[2],ParamStr[3],WinColor) then
   begin
    f_l:=True;
    ef_l:=True;
    t_l:=False;
    et_l:=False;
   end else
   begin
    t_l:=True;
    et_l:=True;
    f_l:=False;
    ef_l:=False;
   end;
  end;

  if comname = 'SHOWTEXT' then begin
   tstr:='';
   for n:=5 to totalcomparam-1 do tstr:=tstr+paramstr[n]+', ';
   Delete(tstr,length(tstr)-1,2);
   n:=LeftText;
   if UpString(ParamStr[3]) = 'CENTER' then n:=CenterText;
   if UpString(ParamStr[3]) = 'LEFT' then n:=LeftText;
   if UpString(ParamStr[3]) = 'RIGHT' then n:=RightText;
   ShowMessageWindowXY(ParamVal[0],ParamVal[1],ParamVal[2],n,ParamStr[4], tstr,WinColor);
  end;

  if comname = 'DRAWFON' then FillWindow(1,1,80,24,Chr(176),DeskTopColor);

  if comname = 'MOVECURSOR' then begin
   CursorOff;
   GotoXY(Paramval[0],ParamVal[1]);
  end;

  if comname = 'WRITESTRING' then begin
   tstr:='';
   for n:=2 to totalcomparam-1 do tstr:=tstr+paramstr[n]+', ';
   Delete(tstr,length(tstr)-1,2);
   WriteString(Paramval[0],paramval[1],tstr,WinColor);
  end;

  if comname = 'PUTITEM' then begin
   makefiles:=makefiles+1;
   tstr:='';
   for n:=3 to totalcomparam-1 do tstr:=tstr+paramstr[n];
   PutItem(paramstr[0],paramstr[1],paramstr[2],tstr);
  end;

  if comname = 'SAVESCREEN' then SaveScreen(prgscr);

  if comname = 'RESTORESCREEN' then RestoreScreen(prgscr);

  if comname = 'MAKEDIR' then begin
   makefiles:=makefiles+1;
   tstr:='';
   for n:=0 to totalcomparam-1 do tstr:=tstr+paramstr[n];
   tstr:=UpString(tstr);
   {$I-}
   MkDir(tstr);
   {$I+}
   if IOResult <> 0 then begin
    ShowMDialog(60,CenterText,'Error','Can'#39't creat '+tstr+' directorie.'#0+
                                      'Installation break!','~E~xit',WinColor);
    ExitProc('Can'#39't creat '+tstr+' directorie.');
   end;
  end;

  if comname = 'COPYFILE' then begin
   makefiles:=makefiles+1;
   if not  CopyFile(ParamStr[0],ParamStr[1]) then begin
    ShowMDialog(60,CenterText,'Error','Can'#39't copy '+ParamStr[0]+' file to '+ParamStr[1]+'.'#0+
                                      'Installation break!','~E~xit',WinColor);
    ExitProc('Can'#39't copy '+ParamStr[0]+' file to '+ParamStr[1]);
   end;
  end;

  if comname = 'WAITKEY' then begin
   repeat
    n:=Ord(ReadKey);
    if n = 27 then
     if ShowQDialog(60,CenterText,1,'Exit','Do you want to break installation?','~Y~es','~N~o',WinColor) then
      ExitProc('Installation break by user!');
    if n = 0 then begin
     n:=Ord(ReadKey);
     if n = 59 then ShowHelp;
    end;
   until n=paramval[0];
  end;

  if KeyPressed then begin
   n:=Ord(ReadKey);
   if n = 27 then
    if ShowQDialog(60,CenterText,1,'Exit','Do you want to break installation?','~Y~es','~N~o',WinColor) then
     ExitProc('Installation break by user!');
   if n = 0 then begin
    n:=Ord(ReadKey);
    if n = 59 then ShowHelp;
   end;
  end;

  end;
 until EOF(commandfile);

 ExitProc('');
end.