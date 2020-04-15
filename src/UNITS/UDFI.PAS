uses Dos;

type TUDF = record
     Version: Byte;
     ProcType,
     Vars,
     EProc,
     IProc,
     Segment,
     VarOfs,
     EProcOfs,
     IProcOfs,
     Size: Word;
     Name,
     FileName: String;
end;

const No_error            = 0;
      Not_enother_memory  = 1;
      Wrong_driver_format = 2;
      File_not_found      = 3;
      Driver_not_loaded   = 4;

var   f: File;
      str, str1: String;
      bstr: array [0..1] of Byte absolute str;
      bstr1: array [0..1] of Byte absolute str1;
      n: Word;
      b, b1: Byte;
      w, w1: Word;
      l, l1: LongInt;

function LoadDriver(fn: String; var di: TUDF): Byte;
var p: Pointer;
begin
 LoadDriver:=File_not_found;
 Assign(f, fn);
 {$I-}
 Reset(f,1);
 {$I+}
 if IOResult <> 0 then
  if IOResult <> 8 then Exit else begin
   LoadDriver:=Not_enother_memory;
   Exit;
  end;
 BlockRead(f, bstr[1], 25);
 bstr[0]:=23;
 LoadDriver:=Wrong_driver_format;
 if str <> 'Universal Driver Format' then begin
  Close(f);
  Exit;
 end;
 repeat
  BlockRead(f, b, 1);
 until EOF(f) or (b = $1A);
 if b <> $1A then begin
  Close(f);
  Exit;
 end;
 BlockRead(f, w, 2);
 if w <> 0 then begin
  Close(f);
  Exit;
 end;
 BlockRead(f, di.Version, 1);
 str:='';
 repeat
  BlockRead(f, b, 1);
  if b <> 0 then str:=str+Chr(b);
 until EOF(f) or (b = 0);
 if b <> 0 then begin
  Close(f);
  Exit;
 end;
 di.Name:=str;
 BlockRead(f, di.ProcType, 2);
 if di.ProcType = 0 then begin
  Close(f);
  Exit;
 end;
 BlockRead(f, w, 2);
 if w <> 0 then begin
  Close(f);
  Exit;
 end;
 BlockRead(f, di.Vars, 2);
 di.VarOfs:=FilePos(f);
 if di.Vars <> 0 then begin
  for n:=1 to di.Vars do begin
   repeat
    BlockRead(f, b, 1);
   until EOF(f) or (b = 0);
   if b <> 0 then begin
    Close(f);
    Exit;
   end;
   BlockRead(f, b, 1);
   if b > 6 then begin
    Close(f);
    Exit;
   end;
   case b of
    0: Seek(f, FilePos(f)+1);
    1: Seek(f, FilePos(f)+2);
    2: Seek(f, FilePos(f)+4);
    3: Seek(f, FilePos(f)+6);
    4: Seek(f, FilePos(f)+8);
    5: Seek(f, FilePos(f)+10);
    6: begin
        BlockRead(f, w, 2);
        Seek(f, FilePos(f)+w);
       end;
   end;
  end;
 end;
 BlockRead(f, di.EProc, 2);
 di.EProcOfs:=FilePos(f);
 if di.EProc <> 0 then begin
  for n:=1 to di.EProc do begin
   repeat
    BlockRead(f, b, 1);
   until EOF(f) or (b = 0);
   if b <> 0 then begin
    Close(f);
    Exit;
   end;
   BlockRead(f, w, 2);
  end;
 end else begin
  Close(f);
  Exit;
 end;
 BlockRead(f, di.IProc, 2);
 di.IProcOfs:=FilePos(f);
 if di.IProc <> 0 then begin
  for n:=1 to di.IProc do begin
   repeat
    BlockRead(f, b, 1);
   until EOF(f) or (b = 0);
   if b <> 0 then begin
    Close(f);
    Exit;
   end;
   BlockRead(f, w, 2);
  end;
 end;
 di.Size:=FileSize(f);
 close(f);
 LoadDriver:=Not_enother_memory;
 if MaxAvail < di.Size+16 then Exit;
 GetMem(p, di.Size);
 di.Segment:=Seg(p^);
 if Ofs(p^) <> 0 then begin
  FreeMem(p, di.Size);
  Exit;
 end;
 reset(f,1);
 BlockRead(f, p^, di.Size);
 close(f);
 di.FileName:=fn;
 LoadDriver:=No_error;
end;

function  FreeDriver(di: TUDF): Byte;
begin
 FreeDriver:=Driver_not_loaded;
 if (di.Size = 0) or (di.Segment = 0) or (di.EProc = 0) or (di.VarOfs < 30) or
    (di.EProcOfs <= di.VarOfs) or (di.IProcOfs <= di.EProcOfs) or
    (di.ProcType = 0) or (di.FileName = '') or (di.Name = '') then Exit;
 FreeMem(Ptr(di.Segment,0), di.Size);
 FillChar(di, SizeOf(di), 0);
 FreeDriver:=No_error;
end;

function  ImportProc(di: TUDF; pn: String): Pointer;
var ofs: Word;
begin
  ImportProc:=NIL;
  ofs:=di.EProcOfs;
  for n:=1 to di.EProc do begin
   str:='';
   repeat
    b:=Mem[di.Segment:ofs];
    ofs:=ofs+1;
    if b <> 0 then str:=str+Chr(b);
   until (ofs >= di.IProcOfs) or (b = 0);
   if b <> 0 then Exit;
   if str = pn then begin
    ImportProc:=Ptr(di.Segment,MemW[di.Segment:ofs]);
    Exit;
   end else
   ofs:=ofs+2;
  end;
end;

procedure VariableInfo(di: TUDF; vn: String;
                       var vt: Byte; var vs: Word; var v: Pointer);
var ofs: Word;
begin
  v:=NIL;
  vt:=255;
  vs:=0;
  ofs:=di.VarOfs;
  for n:=1 to di.Vars do begin
   str:='';
   repeat
    b:=Mem[di.Segment:ofs];
    ofs:=ofs+1;
    if b <> 0 then str:=str+Chr(b);
   until (ofs >= di.EProcOfs) or (b = 0);
   if b <> 0 then Exit;
   vt:=Mem[di.Segment:ofs];
   ofs:=ofs+1;
   case vt of
    0: vs:=1;
    1: vs:=2;
    2: vs:=4;
    3: vs:=6;
    4: vs:=8;
    5: vs:=10;
    6: begin
        vs:=MemW[di.Segment:Ofs];
        Ofs:=Ofs+2;
       end;
   end;
   if str = vn then begin
    v:=Ptr(di.Segment,ofs);
    Exit;
   end;
   Ofs:=Ofs+vs;
  end;
end;

function FindVariable(di: TUDF; vn: String): Pointer;
var ofs, vs: Word;
    vt: Byte;
begin
  FindVariable:=NIL;
  vt:=255;
  vs:=0;
  ofs:=di.VarOfs;
  for n:=1 to di.Vars do begin
   str:='';
   repeat
    b:=Mem[di.Segment:ofs];
    ofs:=ofs+1;
    if b <> 0 then str:=str+Chr(b);
   until (ofs >= di.EProcOfs) or (b = 0);
   if b <> 0 then Exit;
   vt:=Mem[di.Segment:ofs];
   ofs:=ofs+1;
   case vt of
    0: vs:=1;
    1: vs:=2;
    2: vs:=4;
    3: vs:=6;
    4: vs:=8;
    5: vs:=10;
    6: begin
        vs:=MemW[di.Segment:Ofs];
        Ofs:=Ofs+2;
       end;
   end;
   if str = vn then begin
    FindVariable:=Ptr(di.Segment,ofs);
    Exit;
   end;
   Ofs:=Ofs+vs;
  end;
end;

var td: TUDF;
    InitGraph, CloseGraph, FillScreen: Procedure;
    varp: ^LongInt;
begin
 WriteLn(LoadDriver('udf.udf',td));
 @InitGraph:=ImportProc(td, 'Init graphics mode');
 @CloseGraph:=ImportProc(td, 'Close graphics mode');
 @FillScreen:=ImportProc(td, 'Fill screen');
 varp:=FindVariable(td, 'Draw color');
 InitGraph;
 for n:=0 to 255 do begin
  varp^:=n;
  FillScreen;
 end;
 CloseGraph;
 WriteLn(FreeDriver(td));
end.