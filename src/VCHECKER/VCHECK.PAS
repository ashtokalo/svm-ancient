Uses BinPasU, DOS, Crt, VCheck_f, VCheck_t;
type
  HeadType = record case Byte of
  1:(
    Sign   : Word; {Сигнатура 'MZ' = $5A4D}
    PartPag: Word; {Часть неполного сектора}
    PageCnt: Word; {Количество секторов}
    ReloCnt: Word; {Количество элементов в таблице перемещения}
    HdrSize: Word; {Длина заголовка в параграфах}
    MinMem : Word; {Минимальный размер кучи}
    MaxMem : Word; {Максимальный размер кучи}
    ReloSS : Word; {Начальное значение сегмента стека SS}
    ExeSP  : Word; {Начальное значение указателя стека SP}
    ChkSum : Word; {Контрольная сумма всех слов файла}
    ExeIP  : Word; {Смещениеточки запуска программы}
    ReloCS : Word; {Начальное значение сегмента кода CS});
  2:(W: array [1..12] of Word)
  end;
  TKey = record
    Head24: HeadType; {24 байта эталонного заголовка}
    StartS: Word;     {Относительный сегмент}
    StartO: Word;     {и смещение точки запуска программы}
    Leng24: LongInt;  {Длина незараженной программы минус 24 байта}
    Key   : Word;     {Ключ шифровки}
  end;
  ByteArr = array [1..MaxInt] of Byte;
var
  H,HFag: HeadType;
  HH    : TKey;
  fe,                		{EXE-файл}
  ff: file;          		{Файл с кодом фага}
  LFag: LongInt;     		{Длина кода фага}
  CFag: ^ByteArr;    		{Указатель на код фага}
  NE: String;        		{Имя исходного EXE-файла}
  NF: String;        		{Имя файла с кодом фага}
  S: SearchRec;
  d: DirStr;
  n: NameStr;
  e: ExtStr;
  LS: LongInt;       		{Смещение для фага}
const
  FagName = 'vcheck.mp';
  BakFile : Boolean = True;

procedure CreatFagFile;
var n: LongInt;
    f: file of VCheckF_FileType;
begin
 Assign(f,NF);
 {$I-}
 ReWrite(f);
 {$I+}
 if IOResult <> 0 then begin
  WriteLn('Can`t extract mini-program. Virus checker not installed.');
  Halt(0);
 end;
 Write(f,VCheckF_File);
 Close(f);
end;

procedure EraseFagFile;
var f: File;
begin
 Assign(f,NF);
 {$I-}
 Erase(f);
 {$I+}
end;

procedure HaltP;
begin
 EraseFagFile;
 Halt;
end;


PROCEDURE Help;
BEGIN
  WriteLn('Usage: vcheck  filename [options]');
  WriteLn('   filename - is name of EXE-file or mask to group EXE-files');
  WriteLn('   /NB      - no backup file');
  WriteLn('   /BPH     - show BINPASU help');
  WriteLn('');
  WriteLn('Note:');
  WriteLn('   This program add to current EXE-file special mini-program.');
  WriteLn('  It check EXE-file before runing, and, if virus changed EXE-');
  WriteLn('  file, show message and restore original EXE-file.');
  WriteLn('   If virus  save himself  to top of file,  mini-program show');
  WriteLn('  message only (without restoring EXE-file).');
  WriteLn('   If you want recive more information please run VCheck with');
  WriteLn('  next parametrs:  /E *.TXT');
  HaltP;
  Halt;
END;

function UpString(s: String): string;
var k: Integer;
begin
  for k:=1 to Length(s) do s[k]:=UpCase(s[k]);
  UpString:=s
end;

PROCEDURE CheckParam;
var  k: Integer;
     s: String;
BEGIN
 NE:='';
 NF:=FagName;
 for k:=1 to ParamCount do begin
  s:=UpString(ParamStr(k));
  if s='/NB' then BakFile:=False else
  if NE='' then NE:=s else Help
 end;
 if NE = '' then Help;
END;

PROCEDURE NotAccess(s: String);
BEGIN
 WriteLn('File access denied ',s);
 HaltP;
END;

FUNCTION CheckRead(s: String; k,n: Word):Boolean;
BEGIN
 if k<>n then begin
  WriteLn('Reading error in file ',s);
  CheckRead:=False
 end else CheckRead:=True
END;

FUNCTION CheckWrite(s: String; k,n: Word): Boolean;
BEGIN
 if k<>n then begin
  WriteLn('Writing error in file ',s);
  CheckWrite:=False
 end else CheckWrite:=True
END;

PROCEDURE OpenFag;
var k: Word;
BEGIN
 CreatFagFile;
 Assign(ff,NF);
 {$I-}
 Reset(ff,1);
 {$I+}
 if IOResult <> 0 then NotAccess(NF);
 BlockRead(ff,HFag,SizeOf(HFag),k);
 if not CheckRead(NF,SizeOf(HFag),k) then HaltP;
 LFag:=FileSize(ff)-HFag.HdrSize*16-SizeOf(TKey);
 GetMem(CFag,LFag);
 Seek(ff,FileSize(ff)-LFag);
 BlockRead(ff,CFag^,LFag,k);
 if not CheckRead(NF,LFag,k) then HaltP;
 Close(ff)
END;

FUNCTION CheckFile: Boolean;
var r: registers;
    s: String[1];
    k: Word;
    p: ^ByteArr;
label NotFag;
const txt1='File ';
      txt2=' have an overlay or debug info.';
BEGIN
  CheckFile:=False;
  BlockRead(fe,H,SizeOf(H),k);
  if not CheckRead(NE,SizeOf(H),k) then goto NotFag;
  if H.Sign <> $5A4D then begin
    WriteLn(NE,' not normal EXE-file!');
   NotFag:
    WriteLn('Virus checker not installed.');
    Exit
  end else begin
   if FileSize(fe)-H.HdrSize*16>LFag then begin
    GetMem(p,LFag);
    Seek(fe,FileSize(fe)-LFag);
    BlockRead(fe,p^,LFag,k);
    k:=LFag div 2;
    repeat
     inc(k)
    until (k>LFag) or (p^[k]<>CFag^[k]);
    FreeMem(p,LFag);
    if k > LFag then begin
     WriteLn('In file ',NE,' Virus checker allready installed!');
     Exit
    end
   end;
   Intr($12,r);
   LS:=FileSize(fe)+LFag+SizeOf(HH)+15;
   if r.AX*1024.0-LS-H.MinMem*16 <= 0 then begin
    WriteLn('File ',NE,' too big!');
    goto NotFag
   end;
   if (FileSize(fe)+15) div 16>H.PageCnt+H.HdrSize then begin
    WriteLn(txt1,NE,txt2);
    Write('Do you want install Virus checker to EXE-file (Y/N)? ');
    s:='';
    repeat
     ReadLn(s);
    until s[1] in ['N','n','Y','y'];
    if UpCase(s[1]) = 'N' then goto NotFag
   end;
   HH.Head24:=H;
   with HH,HH.Head24 do begin
    StartS:=ReloCS;
    StartO:=ExeIP;
    ExeIP :=HFag.ExeIP;
    LS:=(FileSize(fe)+15) div 16;
    ReloCS:=LS-HdrSize;
    Leng24:=LS*16+LFag+SizeOf(HH)-24;
    PageCnt:=(Leng24+24+511) div 512;
    PartPag:=(Leng24+24) mod 512;
    if MinMem < 256 then MinMem:=256;
    if ExeSP < 4096 then ExeSP:=4096;
    CheckFile:=True;
   end;
  end;
END;

FUNCTION CorrectName: Boolean;
const FirstName: Boolean = True;
BEGIN
 if FirstName then begin
  FirstName:=False;
  if pos('.',NE)=0 then NE:=NE+'.exe';
  FSplit(NE,d,n,e);
  FindFirst(NE,$2F,S);
  if DOSError<>0 then NotAccess(NE)
 end else FindNext(S);
 if DOSError=0 then begin
  NE:=d+S.Name;
  Assign(fe,NE);
  {$I-}
  Reset(fe,1);
  {$I+}
  if IOResult <> 0 then NotAccess(NE);
  CorrectName:=CheckFile;
 end else CorrectName:=False;
END;

PROCEDURE SetVirFag;
var  p: Pointer;
     s: Word;
     n: String;
     L, LOld: LongInt;
     k: Word;
     fb,
     fff: file;
label NotBack,NotFag;
BEGIN
 LOld:=FIleSize(fe);
 if BakFile then begin
  n:=copy(NE,1,pos('.',NE))+'BAK';
  Assign(fb,n);
  {$I-}
  ReWrite(fb,1);
  {I+}
  if IOResult <> 0 then
 NotBack:
   WriteLn('Can`t creat backup file ',n)
  else begin
   Seek(fe,0);
   L:=LOld;
   repeat
    s:=65520;
    if L < s then s:=L;
    if MaxAvail < s then s:=MaxAvail;
    GetMem(p,s);
    BlockRead(fe,p^,s,k);
    if not CheckRead(NE,s,k) then Exit;
    BlockWrite(fb,p^,s,k);
    if not CheckWrite(n,s,k) then goto NotBack;
    FreeMem(p,s);
    dec(L,s)
   until L=0;
   Close(fb)
  end
 end;
 Seek(fe,0);
 BlockWrite(fe,HH,SizeOf(H),k);
 if CheckWrite(ne,SizeOf(H),k) then begin
  Randomize;
  HH.Key:=Random($FFFF);
  for k:=1 to 12 do with HH,HH.Head24 do W[k]:=W[k] xor Key;
  Seek(fe,LS*16);
  BlockWrite(fe,HH,SizeOf(HH),k);
  if CheckWrite(ne,SizeOf(HH),k) then begin
   BlockWrite(fe,CFag^,LFag,k);
   if CheckWrite(ne,LFag,k) then WriteLn(NE,' Virus checker installed.') else
   goto NotFag
  end else
NotFag:
  begin
   Seek(fe,0);
   BlockWrite(fe,H,SizeOf(H));
   Seek(fe,LOld);
   Truncate(fe)
  end;
 end;
 Close(fe)
END;

BEGIN
 GotoXY(1, WhereY);
 TextColor(7);
 Write('Virus checker  Version 1.0  Copyright (c) 1999 ShAG Studio          ');
 TextBackGround(0);
 TextColor(15);
 WriteLn('FREEWEARE');
 TextColor(7);
 TextBackGround(0);
 InitBPU;
 CheckParam;
 OpenFag;
 while CorrectName do SetVirFag;
 EraseFagFile;
END.
