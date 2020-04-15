{============================================================================}
{====--------------------------------------------------------------------====}
{====                         SFX Files Package                          ====}
{====                            Version 1.0                             ====}
{====                   Copyright (c) 2000 ShAG Studio                   ====}
{====--------------------------------------------------------------------====}
{============================================================================}

{$A+,B+,D-,E-,F+,G+,I+,L-,N+,O+,P+,Q-,R-,S+,T+,V+,X+}
{$M 16384,1024,32768}

 uses  Dos;

{============================================================================}
{ Constants                                                                  }
{============================================================================}

 const
       IsFile = 0;                      { Constants for pointed to saved    }
       IsDir  = 1;                      { data type                         }
       IsText = 2;
       IsExt  = 5;

       evWriteLn         = 0;           { Constants for do Event            }
       evWrite           = 1;
       evWriteLnNum      = 2;
       evWriteNum        = 3;
       evWriteExit       = 4;
       evExit            = 5;

       { Next 6 constants saved to EXE file and need as program settings    }
       FirstElement : LongInt = 0;      { Offset of first element in file   }
       Made         : Boolean = False;  { True if SFX was create            }
       ShowProcess  : Boolean = True;   { True -> Show messages             }
       AutoExtract  : Boolean = True;   { True -> Auto extract after start  }
       NeedSpace    : LongInt = 0;      { Size of all elements with FAT     }
       AutoStartFile: String[14] = 'SFX_AS.BAT'; { Name of starting program }
                                        { after extract all files           }
       TPleaseWait  : String[80] = 'Please wait...';


       { Messages }
       TCreatDir:  String[11] = 'Creat dir  ';
       TCreatFile: String[11] = 'Creat file ';
       TAddDir:    String[9]  = 'Add dir  ';
       TAddFile:   String[9]  = 'Add file ';
       TError:     String[8]  = 'Error #:';
       TBytes:     String[5]  = 'bytes';

{============================================================================}
{ New variable types                                                         }
{============================================================================}

 { Type with information about file or directory that saved to SFX unit     }
 type PCommand = ^TCommand;
      TCommand = record
        Command: Byte;                  { Data type                         }
        Attr: Word;                     { File atributes                    }
        Size,                           { Data size                         }
        Time: LongInt;                  { File time                         }
        Name: String[244];              { File name                         }
      end;

 type PFile = ^TFile;
      TFile = record
        f: File;
        m: Boolean;
      end;

 { Buffer for copying operations                                            }
 type PBuffer = ^TBuffer;
      TBuffer = array [0..32767] of Byte;

{============================================================================}
{ All variables                                                              }
{============================================================================}

 var  Buffer  : PBuffer;                { Buffer                            }
      BufSize,                          { Size of Buffer                    }
      NumWrite,                         { Count bytes that was saved        }
      NumRead,                          { Count bytes that was read         }
      IORes   : Word;                   { Copy of IOResults                 }
      Need    : LongInt;                { Count bytes that need             }
      InputCom,                         { File information to save          }
      Results : TCommand;               { File information to read          }
      RootDir,                          { Root directory                    }
      TempStr,                          { Temporary string                  }
      OldSFX,                           { Name of the main SFX program      }
      SFXName : String;                 { Curently name of SFX program      }
      SFXFile : TFile;                  { SFX file variable                 }


{============================================================================}
{ Procedures and functions                                                   }
{============================================================================}

 {==============================-------------------------------------------=
  =                       Exec event with code Event                       =
  =-------------------------------------------==============================}
 procedure  DoEvent(event: Byte; n: LongInt; s: String);
 begin
  case event of
   evWriteLn     : WriteLn(s);
   evWrite       : Write(s);
   evWriteLnNum  : WriteLn(n);
   evWriteNum    : Write(n);
   evWriteExit   : begin WriteLn(TError,n); Halt(1) end;
   evExit        : Halt;
  end;
 end;


 {==============================-------------------------------------------=
  =                      Convert string to upper case                      =
  =-------------------------------------------==============================}
 function   UpString(s: String): String;
 var n: Byte;
 begin
   for n:=1 to Length(s) do s[n]:=UpCase(s[n]);
   UpString:=s;
 end;


 {==============================-------------------------------------------=
  =                       Open file to Read or Write                       =
  =-------------------------------------------==============================}
 function   OpenFile(var a: TFile; name: String): Boolean;
 begin
  if a.m then Exit;
  OpenFile:=False;
  a.m:=False;
  Assign(a.f, RootDir+name);
  {$I-}
  Reset(a.f, 1);
  {$I+}
  if IOResult <> 0 then Exit;
  a.m:=True;
  OpenFile:=True;
 end;


 {==============================-------------------------------------------=
  =                Creat and Open file to Read or Write                    =
  =-------------------------------------------==============================}
 function   CreatFile(var a: TFile; name: String): Boolean;
 begin
  if a.m then Exit;
  CreatFile:=False;
  a.m:=False;
  Assign(a.f, RootDir+name);
  {$I-}
  ReWrite(a.f, 1);
  {$I+}
  if IOResult <> 0 then Exit;
  a.m:=True;
  CreatFile:=True;
 end;


 {==============================-------------------------------------------=
  =                               Close file                               =
  =-------------------------------------------==============================}
 function   CloseFile(var a: TFile): Boolean;
 begin
  if a.m then begin
   Close(a.f);
   CloseFile:=True;
   a.m:=False;
  end else CloseFile:=True;
 end;


 {==============================-------------------------------------------=
  =                              Creat buffer                              =
  =-------------------------------------------==============================}
 procedure  CreatBuffer;
 begin
  if (BufSize <> 0) and (Buffer <> nil) then Exit;
  if MemAvail > 32767 then BufSize:=32767
                      else BufSize:=MemAvail;
  GetMem(Buffer, BufSize);
 end;


 {==============================-------------------------------------------=
  =                        Free memory from buffer                         =
  =-------------------------------------------==============================}
 procedure  DeleteBuffer;
 begin
  if (BufSize = 0) or (Buffer = nil) then Exit;
  FreeMem(Buffer, BufSize);
  BufSize:=0; Buffer:=nil;
 end;


 {==============================-------------------------------------------=
  =       Copyes count bytes from a1 to a2 with offset1 and offset2        =
  =-------------------------------------------==============================}
 function   CopyByte(var a1, a2: TFile; ofs1, ofs2, count: LongInt): Boolean;
 begin
  CreatBuffer;
  CopyByte:=False;
  Seek(a1.f, ofs1);
  Seek(a2.f, ofs2);
  repeat
   if count > 40000 then Need:=40000 else Need:=count;
   if Need > BufSize then Need:=BufSize;
   Count:=Count-Need;
   {$I-}
   BlockRead (a1.f, Buffer^, Need, NumRead);
   if Need <> NumRead then Break;
   BlockWrite(a2.f, Buffer^, NumRead, NumWrite);
   {$I+}
   IORes:=IOResult;
  until  (NumRead <> NumWrite) or (Need = 0) or
         (IORes <> 0) or (Need <> NumRead) or (count <= 0);
  if (NumRead <> NumWrite) or (IORes <> 0) or (Need <> NumRead) then Exit;
  CopyByte:=True;
  DeleteBuffer;
 end;


 {==============================-------------------------------------------=
  =               Return dir, name or ext from full file name              =
  =-------------------------------------------==============================}
 function   Construct(com: Byte; s: String): String;
 var dir, name, ext: String;
 begin
  name:=s;
  while Pos('\', name) <> 0 do Delete(name, 1, Pos('\', name));
  if Pos('.', name) <> 0 then begin
    ext:=name;
    Delete(ext, 1, Pos('.', ext));
    Delete(name, Pos('.', name), Length(ext)+1);
  end;
  dir:=s;
  Delete(dir, Length(dir)-Length(name)+1, Length(name));
  case com of
   IsExt: Construct:=ext;
   IsDir: Construct:=dir;
   else Construct:=name;
  end;
 end;


 {==============================-------------------------------------------=
  =                        Adding the command to a                         =
  =-------------------------------------------==============================}
 function   AddCom(var a: TFile): Boolean;
 var  NumWrite: Word;
 begin
  AddCom:=False;
  if not a.m then Exit;
  {$I-}
  BlockWrite(a.f, InputCom, SizeOf(InputCom), NumWrite);
  {$I+}
  if (IOResult <> 0) or (NumWrite <> SizeOf(InputCom)) then Exit;
  AddCom:=True;
 end;


 {==============================-------------------------------------------=
  =                       Return the command from a                        =
  =-------------------------------------------==============================}
 function   GetCom(var a: TFile): Boolean;
 var  NumRead: Word;
 begin
  GetCom:=False;
  if not a.m then Exit;
  {$I-}
  BlockRead(a.f, Results, SizeOf(Results), NumRead);
  {$I+}
  if (IOResult <> 0) or (NumRead <> SizeOf(Results)) then Exit;
  GetCom:=True;
 end;


 {==============================-------------------------------------------=
  =                        Add new element s to a                          =
  =-------------------------------------------==============================}
 function   AddNewElement(t: Byte; var a: TFile; s: String): Boolean;
 var a1: TFile;
 begin
  AddNewElement:=False;
  if not a.m then Exit;
  a1.m:=False;
  if t = IsFile then
    if not OpenFile(a1, s) then Exit;
  InputCom.Command:=t;
  InputCom.Name:=s;
  InputCom.Size:=0;
  InputCom.Attr:=0;
  InputCom.Time:=0;
  if t = IsFile then begin
    InputCom.Size:=FileSize(a1.f);
    GetFAttr(a1.f, InputCom.Attr);
    GetFTime(a1.f, InputCom.Time);
  end;
  NeedSpace:=NeedSpace+InputCom.Size+32;
  if not AddCom(a) then begin
    CloseFile(a1);
    Exit;
  end;
  if t = IsFile then begin
    if not CopyByte(a1, a, 0, FilePos(a.f), FileSize(a1.f)) then begin
      CloseFile(a1);
      Exit;
    end;
    CloseFile(a1);
  end;
  AddNewElement:=True;
 end;


 {==============================-------------------------------------------=
  =                      Seek pointer to next element                      =
  =-------------------------------------------==============================}
 function   Seek2Next(var a: TFile): Boolean;
 var  OldPos: LongInt;
 begin
  Seek2Next:=False;
  if not a.m then Exit;
  OldPos:=FilePos(a.f);
  if OldPos = FileSize(a.f) then Exit;
  if not GetCom(a) then begin
    Seek(a.f, OldPos);
    Exit;
  end;
  Seek2Next:=True;
 end;


 {==============================-------------------------------------------=
  =                          Extract all elements                          =
  =-------------------------------------------==============================}
 function   ExctractElements(t: Byte; var a: TFile): Boolean;
 var  a1: TFile;
 begin
  ExctractElements:=False;
  if not a.m then Exit;
  Seek(a.f, FirstElement);
  with Results do begin
    Size:=0;
    repeat
      if t <> IsFile then Seek(a.f, FilePos(a.f)+Size);
      if not Seek2Next(a) then Exit;
      if (Command = IsFile) and (t = IsFile) then begin
        if ShowProcess then WriteLn(TCreatFile+Name);
        a1.m:=False;
        if not CreatFile(a1, Name) then Exit;
        if not CopyByte(a, a1, FilePos(a.f), 0, Size) then begin
          CloseFile(a1);
          Exit;
        end else begin
         SetFAttr(a1.f, Attr);
         SetFTime(a1.f, Time);
        end;
        CloseFile(a1);
      end;
      if (Command = IsDir) and (t = IsDir) then begin
        if ShowProcess then WriteLn(TCreatDir+Name);
        {$I-}
        MkDir(RootDir+Name);
        {$I+}
        if IOResult <> 0 then DoEvent(evWriteExit, 1, '');
      end;
    until 1 = 2;
  end;
  ExctractElements:=True;
 end;


 {==============================-------------------------------------------=
  =                     Saved directory tree to file s                     =
  =-------------------------------------------==============================}
 procedure  SaveDir(var a: TFile; s: String);
 var  a1: Text;
 begin
  if not a.m then Exit;
  Seek(a.f, FirstElement);
  assign(a1, s);
  {$I-}
  ReWrite(a1);
  {$I+}
  if IOResult<> 0 then DoEvent(evWriteExit, 4, '');
  with Results do begin
    Size:=0;
    repeat
      Seek(a.f, FilePos(a.f)+Size);
      if not Seek2Next(a) then Break;
      if (Command = IsFile) then WriteLn(a1, ' '+Name, ' (',Size,' '+TBytes+')');
      if (Command = IsDir) then WriteLn(a1, Name);
    until 1 = 2;
  end;
  Close(a1);
 end;


 {==============================-------------------------------------------=
  =                         Add files to SFX unit                          =
  =-------------------------------------------==============================}
 procedure  AddFiles(var a: TFile; dir: String);
 var s: String;
     Search: SearchRec;
 begin
  FindFirst(RootDir+dir+'*.*', AnyFile, Search);
  repeat
   if (Search.Attr and Directory <> Directory) then begin
     if (Search.Name <> OldSFX) and
        (Search.Name <> SFXName) then begin
      s:=dir+Search.Name;
      WriteLn(TAddFile+s);
      AddNewElement(IsFile, a, s);
     end;
   end else begin
     if (Search.Name[1] <> '.') then begin
       s:=dir+Search.Name+'\';
       WriteLn(TAddDir+s);
       AddNewElement(IsDir, a, Search.Name);
       AddFiles(a, s);
     end;
   end;
   FindNext(Search);
  until  DosError <> 0;
 end;


 {==============================-------------------------------------------=
  =                          Copyed file s1 to s2                          =
  =-------------------------------------------==============================}
 function   CopyFile(s1, s2: String): Boolean;
 var a1, a2: TFile;
 begin
  CopyFile:=False;
  a1.m:=False;
  a2.m:=False;
  if not OpenFile(a1, s1) then Exit;
  if not CreatFile(a2, s2) then begin CloseFile(a1); Exit; end;
  if not CopyByte(a1, a2, 0, 0, FileSize(a1.f)) then begin
   CloseFile(a1);
   CloseFile(a2);
   Exit;
  end;
  CloseFile(a1);
  CloseFile(a2);
  CopyFile:=True;
 end;


 {==============================-------------------------------------------=
  =                   Saved settings variables to SFX unit                 =
  =-------------------------------------------==============================}
 procedure  SaveSettings;
 var  rax, hdr: Word;
 begin
   Seek(SFXFile.f,8);
   BlockRead(SFXFile.f, hdr, 2);
   asm
    mov  ah, $62
    int  $21
    mov  ax, ds
    sub  ax, bx
    sub  ax, 16
    add  ax, hdr
    mov  rax, ax
   end;
   Seek(SFXFile.f, rax shl 4 + Ofs(FirstElement));
   BlockWrite(SFXFile.f, FirstElement, 105);
 end;


{============================================================================}
{ Main program                                                               }
{============================================================================}
begin
  {-- Show Name, Version and Copyright information                          }
  WriteLn('SFX Files Package  Version 1.0  Copyright(c) 2000 ShAG Studio');

  {-- Detect SFX unit name and root directory                               }
  SFXName:=Construct(IsText, ParamStr(0))+'.'+Construct(IsExt, ParamStr(0));
  OldSFX:=SFXName;
  GetDir(0, RootDir);
  TempStr:=RootDir;
  if RootDir[Length(RootDir)] <> '\' then RootDir:=RootDir+'\';

  {-- if command line content /M key - make SFX unit                        }
  if (UpString(ParamStr(1)) = '/M') and not Made then begin
    if ParamStr(2) <> '' then TempStr:=ParamStr(2);
    if not CopyFile(SFXName,            { Make copy of main SFX unit        }
                     Construct(IsText, TempStr)+'.EXE') then
       DoEvent(evWriteExit, 3, '');
    CloseFile(SFXFile);                 { Close main SFX unit               }
    SFXName:=UpString(Construct(IsText, TempStr)+'.EXE');
    if not OpenFile(SFXFile, SFXName) then {Open copy of SFX unti as main   }
       DoEvent(evWriteExit, 2, '');     { or show error and stop program    }
    Made:=True;
    FirstElement:=FileSize(SFXFile.f);  { Set first element offset to end   }
    Seek(SFXFile.f, FirstElement);      { of SFX unit                       }
    AddFiles(SFXFile, '');              { Add all files and directories     }
    SaveSettings;                       { root directory and save settings  }
    CloseFile(SFXFile);                 { Close SFX unit and                }
    Halt(0);                            { Stop program                      }
  end;

  {-- if SFX unit not made - stop program                                   }
  if not Made then Halt(0);

  {-- Open SFX unit and show error if can't do this operation               }
  if not OpenFile(SFXFile, SFXName) then DoEvent(evWriteExit, 2, '');

  {-- Test command line to /SP key and change show process mode if true     }
  if UpString(ParamStr(1)) = '/SP' then begin
    ShowProcess:=not ShowProcess;
    SaveSettings;
    Halt(0);
  end;

  {-- Test command line to /SE key and change autoextract mode if true      }
  if UpString(ParamStr(1)) = '/SE' then begin
    AutoExtract:=not AutoExtract;
    SaveSettings;
    Halt(0);
  end;

  {-- Test command line to /SA key and set new name of autostarting program }
  {-- if true                                                               }
  if (UpString(ParamStr(1)) = '/SA') and (ParamStr(2) <> '') then begin
    AutoStartFile:=ParamStr(2);
    SaveSettings;
    Halt(0);
  end;

  {-- Test command line to /SM key and set new message to non showing mode  }
  {-- if true                                                               }
  if (UpString(ParamStr(1)) = '/SM') then begin
    ReadLn(TPleaseWait);
    SaveSettings;
    Halt(0);
  end;

  {-- Test command line to /L key and make list file with SFX files         }
  if UpString(ParamStr(1)) = '/L' then begin
    SaveDir(SFXFile, Construct(IsText, SFXName)+'.DIR');
    Halt(0);
  end;

  {-- if not auto extract - stop program                                    }
  if not AutoExtract then Halt(0);

  {-- Before extracting test available disk space                           }
  if NeedSpace > DiskFree(0) then DoEvent(evWriteExit, 5, '');

  {-- Extract all files and creat all directories                           }
  RootDir:=RootDir + Construct(IsText, SFXName);
  if ShowProcess then WriteLn(TCreatDir+RootDir);
  {$I-}
  MkDir(RootDir);                       { Creat and set as main root        }
  ChDir(RootDir);                       { directory                         }
  {$I+}
  if IOResult <> 0 then DoEvent(evWriteExit, 1, '');
  RootDir:=RootDir + '\';
  if not ShowProcess then WriteLn(TPleaseWait);
  ExctractElements(IsDir, SFXFile);     { Creat all directories             }
  ExctractElements(IsFile, SFXFile);    { Extract all files                 }

  CloseFile(SFXFile);                   { Close SFX unit                    }

  {-- Test root directory to present auto start file. If present - try to   }
  {-- execure them and erase them after execution if no DOS errors.         }
  Assign(SFXFile.f, RootDir+AutoStartFile);
  {$I-}
  Reset(SFXFile.f);
  {$I+}
  if (IOResult = 0) then begin
    SwapVectors;
    Exec(GetEnv('COMSPEC'), '/C '+RootDir+AutoStartFile);
    SwapVectors;
    if DosError = 0 then Erase(SFXFile.f);
    Close(SFXFile.f);
  end;
end.
{============================================================================}
{ End of file                                                                }
{============================================================================}