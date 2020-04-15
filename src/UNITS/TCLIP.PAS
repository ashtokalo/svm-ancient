unit TClip;

interface

const
     ClipEmpty  = 0;
     ClipString = 1;
     ClipImage  = 2;
     ClipText   = 3;
     ClipList   = 4;
     ClipDigits = 5;
     ClipData   = 6;

     Clip_was_broken = -1;
     Clip_already_empty = -2;
     Error_type_or_size = -3;

var  ClipFile: String;

function  GetClipType: Integer;
function  GetClipCreator: String;
function  GetClipSize: LongInt;
function  FreeClip: Integer;
function  PutToClip(dt: Integer; s: LongInt; c: String; var buf): Integer;
function  AddToClip(s: LongInt; var buf): Integer;
function  GetFromClip(from, s: LongInt; var buf): Integer;
function  PutString(s, s1: String): Integer;
function  GetString: String;

implementation

type TClipHead = record
      Head:     String[30];
      Creator:  String[220];
      DataType: Integer;
      Size:     LongInt;
     end;

var f: File;
    ClipHead: TClipHead;

function  GetClipType: Integer;
begin
 GetClipType:=Clip_was_broken;
 Assign(f, ClipFile);
 {$I-}
 Reset(f,1);
 {$I+}
 if IOResult <> 0 then Exit;
 {$I-}
 BlockRead(f, ClipHead, SizeOf(ClipHead));
 {$I+}
 Close(f);
 if (IOResult <> 0) or (ClipHead.Head <> 'ShAG Clipboard temporary file.')
   then Exit;
 GetClipType:=ClipHead.DataType;
end;

function  GetClipCreator: String;
begin
 GetClipCreator:='';
 Assign(f, ClipFile);
 {$I-}
 Reset(f,1);
 {$I+}
 if IOResult <> 0 then Exit;
 {$I-}
 BlockRead(f, ClipHead, SizeOf(ClipHead));
 {$I+}
 Close(f);
 if (IOResult <> 0) or (ClipHead.Head <> 'ShAG Clipboard temporary file.') or
    (ClipHead.DataType = 0) then Exit;
 GetClipCreator:=ClipHead.Creator;
end;

function  GetClipSize: LongInt;
begin
 GetClipSize:=Clip_was_broken;
 Assign(f, ClipFile);
 {$I-}
 Reset(f,1);
 {$I+}
 if IOResult <> 0 then Exit;
 {$I-}
 BlockRead(f, ClipHead, SizeOf(ClipHead));
 {$I+}
 Close(f);
 if (IOResult <> 0) or (ClipHead.Head <> 'ShAG Clipboard temporary file.')
   then Exit;
 GetClipSize:=0;
 if ClipHead.DataType = 0 then Exit;
 GetClipSize:=ClipHead.Size;
end;

function  FreeClip: Integer;
begin
 FreeClip:=Clip_already_empty;
 if ClipHead.DataType = 0 then Exit;
 FreeClip:=Clip_was_broken;
 Assign(f, ClipFile);
 {$I-}
 ReWrite(f,1);
 {$I+}
 if IOResult <> 0 then Exit;
 ClipHead.Head:='ShAG Clipboard temporary file.';
 ClipHead.Creator:='';
 ClipHead.DataType:=0;
 ClipHead.Size:=0;
 {$I-}
 BlockWrite(f, ClipHead, SizeOf(ClipHead));
 {$I+}
 Close(f);
 if IOResult <> 0 then Exit;
 FreeClip:=0;
end;

function  PutToClip(dt: Integer; s: LongInt; c: String; var buf): Integer;
begin
 PutToClip:=Error_type_or_size;
 if (dt <= 0) or (s <= 0) then Exit;
 PutToClip:=Clip_was_broken;
 Assign(f, ClipFile);
 {$I-}
 ReWrite(f,1);
 {$I+}
 if IOResult <> 0 then Exit;
 ClipHead.Head:='ShAG Clipboard temporary file.';
 ClipHead.Creator:=c;
 ClipHead.DataType:=dt;
 ClipHead.Size:=s;
 {$I-}
 BlockWrite(f, ClipHead, SizeOf(ClipHead));
 BlockWrite(f, buf, s);
 {$I+}
 Close(f);
 if IOResult <> 0 then Exit;
 PutToClip:=0;
end;

function  AddToClip(s: LongInt; var buf): Integer;
begin
 AddToClip:=Error_type_or_size;
 if s <= 0 then Exit;
 AddToClip:=Clip_was_broken;
 Assign(f, ClipFile);
 {$I-}
 Reset(f,1);
 {$I+}
 if IOResult <> 0 then Exit;
 {$I-}
 BlockRead(f, ClipHead, SizeOf(ClipHead));
 {$I+}
 if IOResult <> 0 then Exit;
 if (IOResult <> 0) or (ClipHead.Head <> 'ShAG Clipboard temporary file.') or
    (ClipHead.DataType = 0) then begin
     Close(f);
     Exit;
    end;
 ClipHead.Size:=ClipHead.Size+s;
 {$I-}
 Seek(f, FileSize(f));
 BlockWrite(f, buf, s);
 Seek(f, 0);
 BlockWrite(f, ClipHead, SizeOf(ClipHead));
 {$I+}
 Close(f);
 if IOResult <> 0 then Exit;
 AddToClip:=0;
end;

function GetFromClip(from, s: LongInt; var buf): Integer;
begin
 GetFromClip:=Error_type_or_size;
 if s <= 0 then Exit;
 GetFromClip:=Clip_was_broken;
 Assign(f, ClipFile);
 {$I-}
 Reset(f,1);
 {$I+}
 if IOResult <> 0 then Exit;
 {$I-}
 BlockRead(f, ClipHead, SizeOf(ClipHead));
 {$I+}
 if (IOResult <> 0) or (ClipHead.Head <> 'ShAG Clipboard temporary file.')
   then begin
    Close(f);
    Exit;
   end;
 if ClipHead.Size < (s+from) then s:=ClipHead.Size-from;
 if s <= 0 then begin
  Close(f);
  Exit;
 end;
 {$I-}
 Seek(f, FilePos(f)+from);
 BlockRead(f, buf, s);
 {$I+}
 Close(f);
 if IOResult <> 0 then Exit;
 GetFromClip:=0;
end;

function  PutString(s, s1: String): Integer;
begin
 PutString:=PutToClip(ClipText, Length(s)+1, s1, s);
end;

function  GetString: String;
var s: String;
begin
 if GetFromClip(0, GetClipSize, s) < 0 then s:='';
 GetString:=s;
end;

begin
 ClipFile:='CLIPFILE.TMP';
end.