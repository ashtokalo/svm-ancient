{$A+,B+,D-,E-,F+,G+,I-,L-,N+,O+,P+,Q-,R-,S-,T+,V+,X+}
{$M 16384,0,655360}
unit semme_e;

interface
 uses Dos;
 const PageSize = 8192;
       MaxPages = 512;
       MaxHandles = 25;
       MaxWindows = 17;
       PageSH = 13;

 type TPage = array [0..PageSize-1] of Byte;
 type PPage = ^TPage;
 type THandle = record
      firstp: Word;
      tpage:  Word;
 end;
 type PHandle = ^THandle;
 type TWinInfo = record
      selected: Word;
      handle: Word;
      freq: Word;
 end;

 procedure InitVM;
 procedure DoneVM;
 function  NewHandle(Size: Word): Word;
 procedure ReSizeHandle(Handle, Size: Word);
 procedure DisposeHandle(Handle: Word);
 procedure LoadPage(Handle, Logical, Phisical: Word);
 function  MinFreq: Word;
 procedure NulFreq;

 var SEMMEError: Boolean;
     SEMMECodeError: Byte;
     SWP_File: File Of TPage;
     SWP_FileName: String;
     SWP_Disk: Char;
     Total_pages, Up_margin, Down_margin, Max_Windows,
     Free_pages: Word;
     Pages:   array [0..MaxPages-1] of Word;
     Windows: array [0..MaxWindows-1] of PPage;
     WinInfo: array [0..MaxWindows-1] of TWinInfo;
     Handles: array [0..MaxHandles-1] of THandle;

implementation

 function FindFirstFree: Word;
 var n: Word;
 begin
  n:=0;
  while (Pages[n] <> $FFFF) and (n < Total_pages) do n:=n+1;
  if (Pages[n] = $FFFF) and (n < Total_pages) then FindFirstFree:=n else
  FindFirstFree:=$FFFF;
 end;

 procedure AddPage;
 begin
  if DiskFree(Ord(SWP_Disk)-Ord('A')+1) < PageSize*2 then Exit;
  Seek(SWP_File,FileSize(SWP_File)+1);
  Write(SWP_File, Windows[0]^);
  Total_pages:=Total_pages+1;
  Free_pages:=0;
 end;

 function GetPageN(Handle, Pn: Word): Word;
 var nx, n: Word;
 begin
  GetPageN:=$FFFF;
  if (Handles[Handle].tpage = 0) then exit;
  nx:=Handles[Handle].Firstp;
  n:=0;
  while (Pages[nx] <> $FFFE) and (n <> Pn) do begin
   n:=n+1;
   nx:=Pages[nx];
  end;
  if n <> Pn then Exit else GetPageN:=nx;
 end;

 procedure NulFreq;
 var n: Word;
 begin
  for n:=0 to Max_Windows do WinInfo[n].freq:=0;
 end;

 procedure InitVM;
 var n: Word;
 begin
  SEMMEError:=True;
  SEMMECodeError:=1;
  SWP_Disk:=UpCase(SWP_Disk);
  if DiskFree(Ord(SWP_Disk)-Ord('A')+1) < Down_Margin*PageSize then Exit;
  assign(SWP_File, SWP_Disk+':\'+SWP_FileName);
  {$I-}
  ReWrite(SWP_File);
  {$I+}
  if IOResult <> 0 then Exit;
  for Total_pages:=0 to MaxPages-1 do Pages[Total_pages]:=$FFFF;
  Total_pages:=1;
  while (MemAvail >= PageSize+1024) and (Total_pages <= Max_Windows) do begin
   New(Windows[Total_pages-1]);
   Total_pages:=Total_pages+1;
  end;
  Total_pages:=Total_pages-1;
  if Total_pages <> Max_Windows then Exit;
  Total_pages:=0;
  while Total_pages < Down_margin do AddPage;
  Free_pages:=Total_pages;
  for n:=0 to Max_Windows do WinInfo[n].Handle:=$FFFF;
  SEMMEError:=False;
  SEMMECodeError:=0;
 end;

 procedure DoneVM;
 var n: Word;
 begin
  SEMMEError:=True;
  SEMMECodeError:=1;
  {$I-}
  Close(SWP_File);
  {$I+}
  if IOResult <> 0 then Exit;
  {$I-}
  Erase(SWP_File);
  {$I+}
  if IOResult <> 0 then Exit;
  Total_pages:=0;
  Up_margin:=0;
  Down_margin:=0;
  SWP_FileName:='';
  SWP_Disk:=' ';
  n:=0;
  while Windows[n] <> nil do begin
   Dispose(Windows[n]);
   n:=n+1;
  end;
  for n:=0 to MaxHandles do DisposeHandle(n);
  SEMMEError:=False;
  SEMMECodeError:=1;
 end;

 function NewHandle(Size: Word): Word;
 var n: LongInt;
     sp,tm,ls: Word;
 begin
  SEMMEError:=True;
  SEMMECodeError:=1;
  NewHandle:=$FFFF;
  if Size = 0 then Exit;
  sp:=0;
  while (Handles[sp].tpage <> 0) and (sp < MaxHandles) do sp:=sp+1;
  if Handles[sp].tpage <> 0 then Exit;
  tm:=FindFirstFree;
  if tm = $FFFF then AddPage;
  tm:=FindFirstFree;
  if tm = $FFFF then Exit;
  Handles[sp].firstp:=tm;
  ls:=tm;
  Pages[ls]:=ls;
  n:=0;
  while (n < Size-1) and (ls <> $FFFF) do begin
   tm:=FindFirstFree;
   if tm = $FFFF then AddPage;
   tm:=FindFirstFree;
   if tm = $FFFF then Exit;
   Pages[ls]:=tm;
   ls:=Pages[ls];
   Pages[tm]:=tm;
   n:=n+1;
  end;
  Pages[ls]:=$FFFE;
  NewHandle:=sp;
  Handles[sp].tpage:=Size;
  SEMMEError:=False;
  SEMMECodeError:=0;
 end;

 procedure ReSizeHandle(Handle, Size: Word);
 var tm2, tm, nx, ls, n: Word;
 begin
  SEMMEError:=True;
  SEMMECodeError:=1;
  if (Handles[Handle].tpage = 0) then exit;
  nx:=Handles[Handle].Firstp;
  n:=0;
  while (Pages[nx] <> $FFFE) and (Pages[nx] <> $FFFF) and (n < Size-1) do begin
   nx:=Pages[nx];
   n:=n+1;
  end;
  ls:=nx;
  tm2:=Pages[ls];
  Pages[ls]:=ls;
  while (n < Size-1) and (ls <> $FFFF) do begin
   tm:=FindFirstFree;
   if tm = $FFFF then AddPage;
   tm:=FindFirstFree;
   if tm = $FFFF then Exit;
   Pages[ls]:=tm;
   ls:=Pages[ls];
   tm2:=Pages[tm];
   Pages[tm]:=tm;
   n:=n+1;
  end;
  Pages[ls]:=$FFFE;
  nx:=tm2;
  if (nx <> $FFFF) and (nx <> $FFFE) then begin
   while (Pages[nx] <> $FFFE) and (Pages[nx] <> $FFFF) do begin
    tm:=Pages[nx];
    Pages[nx]:=$FFFF;
    nx:=tm;
   end;
   Pages[nx]:=$FFFF;
  end;
  Handles[Handle].tpage:=Size;
  SEMMEError:=False;
  SEMMECodeError:=0;
 end;

 procedure DisposeHandle(Handle: Word);
 var tm, nx: Word;
 begin
  SEMMEError:=True;
  SEMMECodeError:=1;
  if (Handles[Handle].tpage = 0) then exit;
  nx:=Handles[Handle].Firstp;
  while (Pages[nx] <> $FFFE) and (Pages[nx] <> $FFFF) do begin
   tm:=Pages[nx];
   Pages[nx]:=$FFFF;
   nx:=tm;
  end;
  Pages[nx]:=$FFFF;
  Free_Pages:=Free_pages+Handles[Handle].tpage;
  Handles[Handle].tpage:=0;
  Handles[Handle].firstp:=0;
  SEMMEError:=False;
  SEMMECodeError:=0;
 end;

 function MinFreq: Word;
 var n, m, k: Word;
 begin
  k:=WinInfo[0].freq;
  m:=0;
  for n:=0 to Max_Windows-1 do
   if WinInfo[n].freq < k then begin
    k:=WinInfo[n].freq;
    m:=n;
   end;
  MinFreq:=m;
 end;

 function TestWindow(Handle, Page, Win: Word): Boolean;
 begin
  if (WinInfo[Win].Handle = Handle) and
     (WinInfo[Win].Selected = Page) then TestWindow:=True else TestWindow:=False;
 end;

 procedure LoadPage(Handle, Logical, Phisical: Word);
 var n,n1: Word;
 begin
  SEMMEError:=True;
  SEMMECodeError:=1;
  if (Logical > Max_Windows-1) or (Handles[Handle].tpage = 0) or
     (Phisical > Handles[Handle].tpage - 1) then Exit;
  SEMMEError:=False;
  SEMMECodeError:=0;
  if (WinInfo[Logical].Handle = Handle) and
     (WinInfo[Logical].Selected = Phisical) then Exit;
  SEMMEError:=True;
  SEMMECodeError:=1;
  n:=GetPageN(Handle,Phisical);
  if n = $FFFF then Exit;
  n1:=GetPageN(WinInfo[Logical].Handle,WinInfo[Logical].Selected);
  WinInfo[Logical].Handle:=Handle;
  WinInfo[Logical].Selected:=Phisical;
  if n1 <> $FFFF then begin
   {$I-}
   Seek(SWP_File,n1);
   {$I+}
   if IOResult <> 0 then Exit;
   {$I-}
   Write(SWP_File,Windows[Logical]^);
   {$I+}
   if IOResult <> 0 then Exit;
  end;
  {$I-}
  Seek(SWP_File,n);
  {$I+}
  if IOResult <> 0 then Exit;
  {$I-}
  Read(SWP_File,Windows[Logical]^);
  {$I+}
  if IOResult <> 0 then Exit;
  if WinInfo[Logical].freq = $FFFF then NulFreq;
  WinInfo[Logical].freq:=WinInfo[Logical].freq+1;
  SEMMEError:=False;
  SEMMECodeError:=0;
 end;

begin
end.