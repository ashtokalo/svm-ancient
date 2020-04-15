{$A+,B-,D-,E-,F+,G+,I-,L-,N+,O-,P-,Q-,R-,S-,T-,V-,X+}
{$M 12384,0,85000}

program SVMIDE;

uses
  Crt, Objects, Drivers, Memory, Views, Menus, Dialogs, StdDlg, HistList,
  MsgBox, App, SVMCmds, Gadgets, Calc, SIFI, HelpFile, SVMHelp, Editors, Dos;

const
  HeapSize = 46 * (1024 div 16);  { Save 48k heap for main program }

  { Desktop file signature information }
  SignatureLen = 27;
  DSKSignature : string[SignatureLen] = 'SVM Assembler desktop file'#26;

type
  TDateTime = record
    Year, Month, Day, Hour, Min, Sec: Word;
  end;

var
  ClipWindow: PEditWindow;
  PrimaryFile: FNameStr;
  DefPath: String;
  IDir, RDir, MDir, CDir, LDir, DDir, SWAP_DISK, lmf, MainDir: String;
  UserScreen, PRGScreen: array [0..4095] OF Byte;
  UserX, UserY, PRGX, PRGY, MesCount: Integer;
  Reg: Registers;
  CodeSize, FDataSize, StackSize, pc, lc, vc, ic, tl, fm, i_sub,
  LFS, LFT: LongInt;
  DosM, ExtM, FreeM, CPUType: LongInt;
  tt: TDateTime;
  HelpContextList: array [0..255] of Word;
  HelpLastCounter: Byte;

type
  PSVMIDE = ^TSVMIDE;
  TSVMIDE = object(TApplication)
    Clock: PClockView;
    Heap: PHeapView;
    constructor Init;
    procedure FileOpen(WildCard: PathStr);
    function  OpenEditor(FileName: FNameStr; Visible: Boolean): PEditWindow;
    procedure GetEvent(var Event: TEvent); virtual;
    function  GetPalette: PPalette; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure Idle; virtual;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure LoadDesktop(var S: TStream);
    procedure OutOfMemory; virtual;
    procedure StoreDesktop(var S: TStream);
    procedure RetrieveDesktop;
    procedure FocusedFile(str: String);
    procedure LoadSVMDsk;
    procedure SaveSVMDsk;
  end;

procedure CursorOff;
begin
  Reg.AH := 1;   {Управление курсором}
  Reg.CH := $20; {Убрать курсор}
  Intr($10,Reg);
end;

procedure CursorON;
begin
  Reg.AH := 1;   {Управление курсором}
  Reg.CH := 1;   {Верхняя строка развертки}
  Reg.CL := 8;   {Нижняя строка}
  Intr($10,Reg);
end;

procedure WriteToStatusLine(s: String);
var n: byte;
begin
 CursorOff;
 GotoXY(2,25);
 TextColor(Black);
 TextBackground(LightGray);
 if Length(s) >= 79 then begin s:=Copy(s,1,75); s:=s+'...'; end;
 for n:=Length(s) to 77 do s:=s+' ';
 Write(s);
end;

function UpString(s: String): String;
var n: Byte;
begin
 for n:=1 to Length(s) do s[n]:=UpCase(s[n]);
 UpString:=s;
end;

function IsFile(fn: String): Boolean;
var f: File;
begin
 IsFile:=False;
 if ((UpCase(fn[1]) IN ['A'..'Z']) and (fn[2] = ':') and (fn[3] = '\')) or
    (Length(fn) < 15) then else Exit;
 assign(f,fn);
 {$I-}
 reset(f);
 {$I+}
 if IOResult <> 0 then IsFile:=False else begin IsFile:=True; close(f); end;
end;

function EraseFile(fn: String): Boolean;
var f: File;
begin
 EraseFile:=False;
 if not IsFile(fn) then exit;
 assign(f,fn);
 {$I-}
 Erase(f);
 {$I+}
 if IOResult <> 0 then EraseFile:=False else EraseFile:=True;
end;

function RenameFile(fn,nfn: String): Boolean;
var f: File;
begin
 RenameFile:=False;
 if not IsFile(fn) then Exit;
 assign(f,fn);
 {$I-}
 Rename(f,nfn);
 {$I+}
 if IOResult <> 0 then RenameFile:=False else RenameFile:=True;
end;

function CopyFile(fn, nfn: String): Boolean;
var FromF, ToF: file;
    NumRead, NumWritten: Word;
    Buf: array[1..2048] of Char;
begin
  CopyFile:=False;
  if not IsFile(fn) then Exit;
  Assign(FromF, fn);
  Reset(FromF, 1);
  Assign(ToF, nfn);
  {$I-}
  Rewrite(ToF, 1);
  {$I+}
  if IOResult <> 0 then Exit;
  repeat
    {$I-}
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    {$I+}
    if IOResult <> 0 then Exit;
    {$I-}
    BlockWrite(ToF, Buf, NumRead, NumWritten);
    {$I+}
    if IOResult <> 0 then Exit;
  until (NumRead = 0) or (NumWritten <> NumRead);
  Close(FromF);
  Close(ToF);
  CopyFile:=True;
end;

function GetMaxMem: LongInt;
begin
 GetMaxMem:=MemAvail+i_sub;
end;

procedure RestoreStatusLine;
begin
 StatusLine^.Draw;
 CursorOn;
end;

procedure TSVMIDE.LoadSVMDsk;
var ts,ts2: String;
    ev: TEvent;
    n, i: Integer;
begin
 WriteToStatusLine('Loading configuration file...');
 if IsFile('svmasm.ini') then begin
  GetDir(0,MainDir);
  ts:=GetItem('svmasm.ini','DESKTOP_FILES','TOTAL_FILES');
  Val(ts,i,n);
  if n > 16 then n:=16;
  if n = 0 then
   for n:=0 to i-1 do begin
    ts:=UpString(GetItem('svmasm.ini','DESKTOP_FILES','EDIT_FILE_'+chr(n+65)));
    if IsFile(ts) then FocusedFile(ts);
   end;
  IDir:=UpString(GetItem('svmasm.ini','DIRECTORIES','INCLUDE_DIR'));
  RDir:=UpString(GetItem('svmasm.ini','DIRECTORIES','RESULT_DIR'));
  MDir:=UpString(GetItem('svmasm.ini','DIRECTORIES','MAP_DIR'));
  CDir:=UpString(GetItem('svmasm.ini','DIRECTORIES','SVMAC_DIR'));
  LDir:=UpString(GetItem('svmasm.ini','DIRECTORIES','SVML_DIR'));
  DDir:=UpString(GetItem('svmasm.ini','DIRECTORIES','SVMD_DIR'));
  PrimaryFile:=UpString(GetItem('svmasm.ini','COMPILE','PRIMARY_FILE'));
  if IsFile(PrimaryFile) then FocusedFile(PrimaryFile) else PrimaryFile:='';
  IF PrimaryFile = '' THEN PrimaryFile:='*.ASM';
  SWAP_DISK:=UpString(GetItem('svmasm.ini','DIRECTORIES','SWAP_DISK'));
  ts:=UpString(GetItem('svmasm.ini','DESKTOP_FILES','FOCUSED_FILE'));
  if IsFile(ts) and (ts <> '') then FocusedFile(ts);
 end else begin
  MessageBox('Could not find SVMASM.INI.', nil, mfOkButton + mfError);
  IDir:='';
  RDir:='';
  MDir:='';
  CDir:='';
  LDir:='';
  PrimaryFile:='*.ASM';
  SWAP_DISK:='C';
  OpenEditor('', True);
 end;
 RestoreStatusLine;
end;

procedure TSVMIDE.SaveSVMDsk;
var ts,ts2: String;
    ev: TEvent;
    n,i: Integer;
    pe: PEditWindow;
begin
 {$I-}
 ChDir(MainDir);
 WriteToStatusLine('Saving configuration file...');
 n:=0;
 pe:=PEditWindow(DeskTop^.Current);
 if pe <> nil then begin
  pe:=PEditWindow(pe^.nextview);
  while (pe <> nil) and isFile(pe^.Editor^.FileName) do begin
   if (pe^.Editor^.FileName <> '') then begin
    PutItem('svmasm.ini','DESKTOP_FILES','EDIT_FILE_'+chr(n+65),pe^.Editor^.FileName);
    inc(n);
   end;
   pe:=PEditWindow(pe^.nextview);
  end;
  pe:=PEditWindow(DeskTop^.Current^.prevview);
  while (pe <> nil) and isFile(pe^.Editor^.FileName) do begin
   if (pe^.Editor^.FileName <> '') then begin
    PutItem('svmasm.ini','DESKTOP_FILES','EDIT_FILE_'+chr(n+65),pe^.Editor^.FileName);
    inc(n);
   end;
   pe:=PEditWindow(pe^.prevview);
  end;
  for i:=n to 16 do
   PutItem('svmasm.ini','DESKTOP_FILES','EDIT_FILE_'+chr(i+65),'');
  Str(n,ts);
  PutItem('svmasm.ini','DESKTOP_FILES','TOTAL_FILES',ts);
  pe:=PEditWindow(DeskTop^.Current);
  if (pe <> nil) and (pe^.Editor^.FileName <> '') and isFile(pe^.Editor^.FileName) then
    PutItem('svmasm.ini','DESKTOP_FILES','FOCUSED_FILE',
               PEditWindow(DeskTop^.Current)^.Editor^.FileName) else
    PutItem('svmasm.ini','DESKTOP_FILES','FOCUSED_FILE','');
  RestoreStatusLine;
  PutItem('svmasm.ini','DIRECTORIES','INCLUDE_DIR',IDir);
  PutItem('svmasm.ini','DIRECTORIES','RESULT_DIR',RDir);
  PutItem('svmasm.ini','DIRECTORIES','MAP_DIR',MDir);
  PutItem('svmasm.ini','DIRECTORIES','SVMAC_DIR',CDir);
  PutItem('svmasm.ini','DIRECTORIES','SVML_DIR',LDir);
  PutItem('svmasm.ini','DIRECTORIES','SVMD_DIR',DDir);
  PutItem('svmasm.ini','DIRECTORIES','SWAP_DISK',SWAP_DISK);
  PutItem('svmasm.ini','COMPILE','PRIMARY_FILE',PrimaryFile);
 end else begin
  PutItem('svmasm.ini','DESKTOP_FILES','FOCUSED_FILE','');
  PutItem('svmasm.ini','DESKTOP_FILES','TOTAL_FILES','0');
 end;
 RestoreStatusLine;
end;

procedure SaveScreen(var ps);
var n,m: Word;
    parantscreen: array [0..4000] of Byte absolute ps;
begin
 asm
  cli
  mov dx,$3da
  @2:
  in al, dx
  test al,1
  je @2
  sti
 end;
 for n:=0 to 3999 do
  parantscreen[n]:=Mem[$B800:n];
end;

procedure RestoreScreen(var ps);
var n,m: Word;
    parantscreen: array [0..4000] of Byte absolute ps;
begin
 asm
  cli
  mov dx,$3da
  @2:
  in al, dx
  test al,1
  je @2
  sti
 end;
 for n:=0 to 3999 do
   Mem[$B800:n]:=parantscreen[n];
end;

procedure SetUserScreen;
begin
 SaveScreen(PRGScreen);
 PRGX:=WhereX;
 PRGY:=WhereY;
 RestoreScreen(UserScreen);
 GotoXY(UserX,UserY);
end;

procedure SetPRGScreen;
begin
 SaveScreen(UserScreen);
 UserX:=WhereX;
 UserY:=WhereY;
 RestoreScreen(PRGScreen);
 GotoXY(PRGX,PRGY);
end;

procedure TSVMIDE.RetrieveDesktop;
var
  S: PStream;
  Signature: string[SignatureLen];
begin
  S := New(PBufStream, Init('SVMASM.DSK', stOpenRead, 1024));
  if LowMemory then OutOfMemory
  else begin
    Signature[0] := Char(SignatureLen);
    S^.Read(Signature[1], SignatureLen);
    if Signature = DSKSignature then
    begin
      LoadDesktop(S^);
      LoadHistory(S^);
    end
  end;
  Dispose(S, Done);
end;


{ CalcHelpName }

function CalcHelpName: PathStr;
var
  EXEName: PathStr;
  Dir: DirStr;
  Name: NameStr;
  Ext: ExtStr;
begin
  if Lo(DosVersion) >= 3 then EXEName := ParamStr(0)
  else EXEName := FSearch('SVMASM.EXE', GetEnv('PATH'));
  FSplit(EXEName, Dir, Name, Ext);
  if Dir[Length(Dir)] = '\' then Dec(Dir[0]);
  CalcHelpName := FSearch('SVMASM.HLP', Dir);
end;

function CreateFindDialog: PDialog;
var
  D: PDialog;
  Control: PView;
  R: TRect;
begin
  R.Assign(0, 0, 38, 12);
  D := New(PDialog, Init(R, 'Find'));
  with D^ do
  begin
    Options := Options or ofCentered;

    R.Assign(3, 3, 32, 4);
    Control := New(PInputLine, Init(R, 80));
    Insert(Control);
    R.Assign(2, 2, 15, 3);
    Insert(New(PLabel, Init(R, '~T~ext to find', Control)));
    R.Assign(32, 3, 35, 4);
    Insert(New(PHistory, Init(R, PInputLine(Control), 10)));

    R.Assign(3, 5, 35, 7);
    Insert(New(PCheckBoxes, Init(R,
      NewSItem('~C~ase sensitive',
      NewSItem('~W~hole words only', nil)))));

    R.Assign(14, 9, 24, 11);
    Insert(New(PButton, Init(R, 'O~K~', cmOk, bfDefault)));
    Inc(R.A.X, 12); Inc(R.B.X, 12);
    Insert(New(PButton, Init(R, 'Cancel', cmCancel, bfNormal)));

    SelectNext(False);
  end;
  CreateFindDialog := D;
end;

function CreateReplaceDialog: PDialog;
var
  D: PDialog;
  Control: PView;
  R: TRect;
begin
  R.Assign(0, 0, 40, 16);
  D := New(PDialog, Init(R, 'Replace'));
  with D^ do
  begin
    Options := Options or ofCentered;

    R.Assign(3, 3, 34, 4);
    Control := New(PInputLine, Init(R, 80));
    Insert(Control);
    R.Assign(2, 2, 15, 3);
    Insert(New(PLabel, Init(R, '~T~ext to find', Control)));
    R.Assign(34, 3, 37, 4);
    Insert(New(PHistory, Init(R, PInputLine(Control), 10)));

    R.Assign(3, 6, 34, 7);
    Control := New(PInputLine, Init(R, 80));
    Insert(Control);
    R.Assign(2, 5, 12, 6);
    Insert(New(PLabel, Init(R, '~N~ew text', Control)));
    R.Assign(34, 6, 37, 7);
    Insert(New(PHistory, Init(R, PInputLine(Control), 11)));

    R.Assign(3, 8, 37, 12);
    Insert(New(PCheckBoxes, Init(R,
      NewSItem('~C~ase sensitive',
      NewSItem('~W~hole words only',
      NewSItem('~P~rompt on replace',
      NewSItem('~R~eplace all', nil)))))));

    R.Assign(17, 13, 27, 15);
    Insert(New(PButton, Init(R, 'O~K~', cmOk, bfDefault)));
    R.Assign(28, 13, 38, 15);
    Insert(New(PButton, Init(R, 'Cancel', cmCancel, bfNormal)));

    SelectNext(False);
  end;
  CreateReplaceDialog := D;
end;

function DoEditDialog(Dialog: Integer; Info: Pointer): Word; far;
var
  R: TRect;
  T: TPoint;
begin
  case Dialog of
    edOutOfMemory:
      DoEditDialog := MessageBox('Not enough memory for this operation.',
        nil, mfError + mfOkButton);
    edReadError:
      DoEditDialog := MessageBox('Error reading file %s.',
        @Info, mfError + mfOkButton);
    edWriteError:
      DoEditDialog := MessageBox('Error writing file %s.',
        @Info, mfError + mfOkButton);
    edCreateError:
      DoEditDialog := MessageBox('Error creating file %s.',
        @Info, mfError + mfOkButton);
    edSaveModify:
      DoEditDialog := MessageBox('%s has been modified. Save?',
        @Info, mfInformation + mfYesNoCancel);
    edSaveUntitled:
      DoEditDialog := MessageBox('Save untitled file?',
        nil, mfInformation + mfYesNoCancel);
    edSaveAs:
      DoEditDialog := Application^.ExecuteDialog(New(PFileDialog, Init('*.ASM',
        'Save file as', '~N~ame', fdOkButton, 101)), Info);
    edFind:
      DoEditDialog := Application^.ExecuteDialog(CreateFindDialog, Info);
    edSearchFailed:
      DoEditDialog := MessageBox('Search string not found.',
        nil, mfError + mfOkButton);
    edReplace:
      DoEditDialog := Application^.ExecuteDialog(CreateReplaceDialog, Info);
    edReplacePrompt:
      begin
        { Avoid placing the dialog on the same line as the cursor }
        R.Assign(0, 1, 40, 8);
        R.Move((Desktop^.Size.X - R.B.X) div 2, 0);
        Desktop^.MakeGlobal(R.B, T);
        Inc(T.Y);
        if TPoint(Info).Y <= T.Y then
          R.Move(0, Desktop^.Size.Y - R.B.Y - 2);
        DoEditDialog := MessageBoxRect(R, 'Replace this occurence?',
          nil, mfYesNoCancel + mfInformation);
      end;
  end;
end;

{ TSVMIDE }
constructor TSVMIDE.Init;
var
  R: TRect;
  I: Integer;
  FileName: PathStr;
begin
  MaxHeapSize := HeapSize;
  inherited Init;
  RegisterObjects;
  RegisterViews;
  RegisterMenus;
  RegisterDialogs;
  RegisterApp;
  RegisterHelpFile;
  RegisterCalc;
  RegisterEditors;

  { Initialize demo gadgets }

  GetExtent(R);
  R.A.X := R.B.X - 9; R.B.Y := R.A.Y + 1;
  Clock := New(PClockView, Init(R));
  Insert(Clock);

  DisableCommands([cmSave, cmSaveAs, cmCut, cmCopy, cmPaste, cmClear,
    cmUndo, cmFind, cmReplace, cmSearchAgain]);
  EditorDialog := DoEditDialog;
  ClipWindow := OpenEditor('', False);
  if ClipWindow <> nil then
  begin
    Clipboard := ClipWindow^.Editor;
    Clipboard^.CanUndo := False;
  end;
  for I := 1 to ParamCount do
  begin
    FileName := ParamStr(I);
    if IsFile(FileName) then FocusedFile(FileName);
  end;
  RetrieveDesktop;
  LoadSVMDsk;
end;

procedure TSVMIDE.FocusedFile(str: String);
var pe:PEditWindow;
begin
 pe:=PEditWindow(DeskTop^.Current);
 while (pe^.Editor^.FileName <> str) and (pe <> nil) do
  pe:=PEditWindow(pe^.nextview);

 if pe <> nil then begin
  if pe^.Editor^.FileName = str then pe^.MakeFirst;
 end else begin

  pe:=PEditWindow(DeskTop^.Current);
  while (pe^.Editor^.FileName <> str) and (pe <> nil) do
   pe:=PEditWindow(pe^.prevview);

  if pe <> nil then begin
   if pe^.Editor^.FileName = str then pe^.MakeFirst else
    OpenEditor(str,True);
  end else OpenEditor(str,True);
 end;
end;


function TSVMIDE.OpenEditor(FileName: FNameStr; Visible: Boolean): PEditWindow;
var
  P: PView;
  R: TRect;
  OEditor: PEditWindow;
begin
  WriteToStatusLine('Loading '+FileName+'...');
  DeskTop^.GetExtent(R);
  P := Application^.ValidView(New(PEditWindow,
    Init(R, FileName, wnNoNumber)));
  if not Visible then P^.Hide;
  DeskTop^.Insert(P);
  OEditor := PEditWindow(P);
  OEditor^.Editor^.Modified:=True;
  OEditor^.Editor^.AutoIndent:=True;
  OEditor^.Editor^.OverWrite:=False;
  OpenEditor:=OEditor;
  RestoreStatusLine;
end;

procedure TSVMIDE.FileOpen(WildCard: PathStr);
var
  FileName: FNameStr;
begin
  FileName := '*.ASM';
  if ExecuteDialog(New(PFileDialog, Init(WildCard, 'Open a file',
    '~N~ame', fdOpenButton + fdHelpButton, 100)), @FileName) <> cmCancel then
    OpenEditor(FileName, True);
end;

procedure TSVMIDE.GetEvent(var Event: TEvent);
var
  W: PWindow;
  HFile: PHelpFile;
  HelpStrm: PDosStream;
const
  HelpInUse: Boolean = False;
begin
  TApplication.GetEvent(Event);
  case Event.What of
    evCommand:
      if (Event.Command = cmHelp) and not HelpInUse then
      begin
        HelpInUse := True;
        HelpStrm := New(PDosStream, Init(CalcHelpName, stOpenRead));
        HFile := New(PHelpFile, Init(HelpStrm));
        if HelpStrm^.Status <> stOk then
        begin
          MessageBox('Could not open help file.', nil, mfError + mfOkButton);
          Dispose(HFile, Done);
        end
        else
        begin
          W := New(PHelpWindow,Init(HFile, GetHelpCtx));
          if HelpLastCounter < 255 then begin
           Inc(HelpLastCounter);
           HelpContextList[HelpLastCounter]:=GetHelpCtx;
          end else begin
           HelpContextList[HelpLastCounter]:=GetHelpCtx;
          end;
          if ValidView(W) <> nil then
          begin
            ExecView(W);
            Dispose(W, Done);
          end;
          ClearEvent(Event);
        end;
        HelpInUse := False;
      end;
    evMouseDown:
      if Event.Buttons <> 1 then Event.What := evNothing;
  end;
end;

function TSVMIDE.GetPalette: PPalette;
const
  CNewColor = CAppColor + CHelpColor;
  CNewBlackWhite = CAppBlackWhite + CHelpBlackWhite;
  CNewMonochrome = CAppMonochrome + CHelpMonochrome;
  P: array[apColor..apMonochrome] of string[Length(CNewColor)] =
    (CNewColor, CNewBlackWhite, CNewMonochrome);
begin
  GetPalette := @P[AppPalette];
end;

procedure TSVMIDE.HandleEvent(var Event: TEvent);

procedure ChangeDir;
var
  D: PChDirDialog;
begin
  D := New(PChDirDialog, Init(cdNormal + cdHelpButton, 101));
  D^.HelpCtx := hcNoContext;
  ExecuteDialog(D, nil);
end;

procedure About;
var
  D: PDialog;
  Control: PView;
  R: TRect;
begin
  R.Assign(0, 0, 40, 11);
  D := New(PDialog, Init(R, 'About'));
  with D^ do
  begin
    Options := Options or ofCentered;

    R.Grow(-1, -1);
    Dec(R.B.Y, 3);
    Insert(New(PStaticText, Init(R,
      #13 +
      ^C'SVM Assembler'#13 +
      #13 +
      ^C'Version 1.2'#13 +
      #13 +
      ^C'Copyright (C) 1999 ShAG Studio')));

    R.Assign(15, 8, 25, 10);
    Insert(New(PButton, Init(R, 'O~K', cmOk, bfDefault)));
  end;
  if ValidView(D) <> nil then
  begin
    Desktop^.ExecView(D);
    Dispose(D, Done);
  end;
end;

procedure ShowError(Error: Integer);
var
  D: PDialog;
  Control: PView;
  R: TRect;
  text: String;
const errortext: array [0..7] of String =
     ('Primary file not select!',
      'Can not run SVMAC.EXE for compiling file.',
      'Can not run SVML.EXE for executing file.',
      'Primary file not be compiled to executeble file.',
      'No messages.',
      'Can not load file with messages.',
      'File whil be chang.',
      'Can not run SVMD.EXE for debugging file.');
begin
  text:=errortext[error];
  R.Assign(0, 0, Length(text)+10, 7);
  D := New(PDialog, Init(R, 'Error'));
  with D^ do
  begin
    Options := Options or ofCentered;
    R.Grow(-1, -1);
    Dec(R.B.Y, 3);
    Insert(New(PStaticText, Init(R,
      #13 +^C+text)));
    R.Assign((Length(text)+10) DIV 2 - 5, 4, (Length(text)+10) DIV 2 + 5, 6);
    Insert(New(PButton, Init(R, 'O~K', cmOk, bfDefault)));
  end;
  if ValidView(D) <> nil then
  begin
    Desktop^.ExecView(D);
    Dispose(D, Done);
  end;
end;

procedure Calculator;
var
  P: PCalculator;
begin
  P := New(PCalculator, Init);
  P^.HelpCtx := hcNoContext;
  InsertWindow(P);
end;

procedure SaveDesktop;
var
  S: PStream;
  F: File;
begin
  S := New(PBufStream, Init('SVMASM.DSK', stCreate, 1024));
  {$I-}
  Dispose(S, Done);
  Assign(F, 'SVMASM.DSK');
  Erase(F);
end;

procedure FileNew;
begin
  OpenEditor('', True);
end;

procedure ShowClip;
begin
  ClipWindow^.Select;
  ClipWindow^.Show;
end;

function Compile: Boolean;
var pe: PEditWindow;
    ts,ts2,ts3: String;
    f: File of Byte;
    l: LongInt;
    t: TDateTime;
    m: Boolean;
begin
 Compile:=False;
 MesCount:=1;
 pe:=PEditWindow(DeskTop^.Current);
 if PrimaryFile = '*.ASM' then begin
  if DeskTop^.Current <> nil then ts:=pe^.Editor^.FileName else begin ShowError(0); Exit; end;
 end else ts:=PrimaryFile;
 if pe <> nil then
  if ts = '' then begin
   if not pe^.Editor^.SaveAs then begin  RestoreStatusLine; exit; end;
   ts:=pe^.Editor^.FileName;
  end else begin
   WriteToStatusLine('Saving '+ts);
   FocusedFile(ts);
   pe:=PEditWindow(DeskTop^.Current);
   m:=pe^.Editor^.Modified;
   if m then
     if not pe^.Editor^.SaveFile then begin RestoreStatusLine; exit; end;
 end;
 if not m then begin
  Compile:=True;
  exit;
 end;
 ts2:=ts;
 if Pos('.',ts2) <> 0 then ts2:=Copy(ts2,1,Pos('.',ts2)-1);
 ts2:=ts2+'.map';
 IF MDir[Length(MDir)] <> '\' THEN MDir:=MDir+'\';
 repeat
  if Pos('\',ts2) <> 0 then
   ts2:=Copy(ts2,Pos('\',ts2)+1,Length(ts2)-Pos('\',ts2));
 until Pos('\',ts2) = 0;
 ts2:=MDir+ts2;
 RestoreStatusLine;
 SWAP_DISK:=SWAP_DISK[1];
 IF CDir[Length(CDir)] <> '\' THEN CDir:=CDir+'\';
 IF LDir[Length(LDir)] <> '\' THEN LDir:=LDir+'\';
 IF MDir[Length(MDir)] <> '\' THEN MDir:=MDir+'\';
 EraseFile(ts2);
 DoneSysError;
 DoneEvents;
 DoneDosMem;
 SwapVectors;
 Exec(CDir+'svmac.exe',
  ts+' /PR /I:'+IDir+' /R:'+RDir+' /M:'+MDir+' /D:'+SWAP_DISK+' /GD');
 SwapVectors;
 InitDosMem;
 InitEvents;
 InitSysError;
 IF DosError <> 0 THEN begin ShowError(1); Exit end;
 if not IsFile(ts2) then exit;
 Compile:=True;
end;

procedure ExitFromProgram;
begin
{ SaveDesktop;}
 SaveSVMDsk;
{ TSVMIDE.Done;}
 SetUserScreen;
 Halt(0);
end;

procedure SetPrimaryFile;
var but: word;
begin
  DefPath:='';
  if PrimaryFile <> '*.ASM' then WriteToStatusLine('Primary file: '+PrimaryFile) else
  WriteToStatusLine('Primary file not select!');
  but:= ExecuteDialog(New(PFileDialog, Init(DefPath, 'Primary File',
       '~P~rimary program file', fdOkButton + fdHelpButton, 100)), @PrimaryFile);
  PutItem('svmasm.ini','COMPILE','PRIMARY_FILE',PrimaryFile);
  RestoreStatusLine;
  if IsFile(PrimaryFile) then FocusedFile(PrimaryFile);
end;

procedure Directories;
var
  D: PDialog;
  Debugger, Include, Result, Map, Compiler, Loader, Swp: PInputLine;
  R: TRect;
begin
  R.Assign(0, 0, 60, 19);
  D := New(PDialog, Init(R, 'Directories'));
  with D^ do
  begin
    Options := Options or ofCentered;

    R.Assign(22, 2, 55, 3);
    Include := New(PInputLine, Init(R, 80));
    Insert(Include);
    Include^.Data^:=IDir;
    R.Assign(1, 2, 21, 3);
    Insert(New(PLabel, Init(R, '~I~nclude directories', Include)));
    R.Assign(55, 2, 58, 3);
    Insert(New(PHistory, Init(R, PInputLine(Include), 5)));

    R.Assign(22, 4, 55, 5);
    Result := New(PInputLine, Init(R, 80));
    Insert(Result);
    Result^.Data^:=RDir;
    R.Assign(1, 4, 20, 5);
    Insert(New(PLabel, Init(R, '~R~esult directories', Result)));
    R.Assign(55, 4, 58, 5);
    Insert(New(PHistory, Init(R, PInputLine(Result), 5)));

    R.Assign(22, 6, 55, 7);
    Map := New(PInputLine, Init(R, 80));
    Insert(Map);
    Map^.Data^:=MDir;
    R.Assign(1, 6, 17, 7);
    Insert(New(PLabel, Init(R, '~M~ap directories', Map)));
    R.Assign(55, 6, 58, 7);
    Insert(New(PHistory, Init(R, PInputLine(Map), 5)));

    R.Assign(22, 8, 55, 9);
    Compiler := New(PInputLine, Init(R, 80));
    Insert(Compiler);
    Compiler^.Data^:=CDir;
    R.Assign(1, 8, 19, 9);
    Insert(New(PLabel, Init(R, '~P~ath to svmac.exe', Compiler)));
    R.Assign(55, 8, 58, 9);
    Insert(New(PHistory, Init(R, PInputLine(Compiler), 5)));

    R.Assign(22, 10, 55, 11);
    Loader := New(PInputLine, Init(R, 80));
    Insert(Loader);
    Loader^.Data^:=LDir;
    R.Assign(1, 10, 18, 11);
    Insert(New(PLabel, Init(R, 'P~a~th to svml.exe', Loader)));
    R.Assign(55, 10, 58, 11);
    Insert(New(PHistory, Init(R, PInputLine(Loader), 5)));

    R.Assign(22, 12, 55, 13);
    Debugger := New(PInputLine, Init(R, 80));
    Insert(Debugger);
    Debugger^.Data^:=DDir;
    R.Assign(1, 12, 18, 13);
    Insert(New(PLabel, Init(R, 'Pa~t~h to svmd.exe', Debugger)));
    R.Assign(55, 12, 58, 13);
    Insert(New(PHistory, Init(R, PInputLine(Debugger), 5)));

    R.Assign(22, 14, 55, 15);
    Swp := New(PInputLine, Init(R, 1));
    Insert(Swp);
    Swp^.Data^:=SWAP_DISK;
    R.Assign(1, 14, 11, 15);
    Insert(New(PLabel, Init(R, 'S~w~ap disk', Swp)));
    R.Assign(55, 14, 58, 15);
    Insert(New(PHistory, Init(R, PInputLine(Swp), 5)));

    R.Assign(18, 16, 28, 18);
    Insert(New(PButton, Init(R, 'O~K~', cmOk, bfDefault)));
    Inc(R.A.X, 16); Inc(R.B.X, 16);
    Insert(New(PButton, Init(R, 'Cancel', cmCancel, bfNormal)));

    SelectNext(False);
  end;
  if ValidView(D) <> nil then
  begin
   if Desktop^.ExecView(D) = cmCancel then exit;
   IDir:=Include^.Data^;
   RDir:=Result^.Data^;
   MDir:=Map^.Data^;
   CDir:=Compiler^.Data^;
   LDir:=Loader^.Data^;
   DDir:=Debugger^.Data^;
   SWAP_DISK:=Swp^.Data^;
   SWAP_DISK:=UpCase(SWAP_DISK[1]);
   PutItem('svmasm.ini','DIRECTORIES','INCLUDE_DIR',IDir);
   PutItem('svmasm.ini','DIRECTORIES','RESULT_DIR',RDir);
   PutItem('svmasm.ini','DIRECTORIES','MAP_DIR',MDir);
   PutItem('svmasm.ini','DIRECTORIES','SVMAC_DIR',CDir);
   PutItem('svmasm.ini','DIRECTORIES','SVML_DIR',LDir);
   PutItem('svmasm.ini','DIRECTORIES','SVMD_DIR',DDir);
   PutItem('svmasm.ini','DIRECTORIES','SWAP_DISK',SWAP_DISK);
   Dispose(D, Done);
  end;
end;

procedure ClearPF;
begin
 PrimaryFile:='*.ASM';
 PutItem('svmasm.ini','COMPILE','PRIMARY_FILE',PrimaryFile);
end;

procedure RunFile;
var svmfile,ts,ts2: String;
    pe: PEditWindow;
begin
 if not Compile then begin ShowError(3); Exit; end;
 pe:=PEditWindow(DeskTop^.Current);
 if pe = nil then exit;
 if PrimaryFile = '*.ASM' then begin
  if DeskTop^.Current <> nil then ts:=pe^.Editor^.FileName else begin ShowError(0); Exit; end;
 end else ts:=PrimaryFile;
 svmfile:=ts;
 IF LDir[Length(LDir)] <> '\' THEN LDir:=LDir+'\';
 IF RDir[Length(RDir)] <> '\' THEN RDir:=RDir+'\';
 if Pos('.',svmfile) <> 0 THEN svmfile:=Copy(svmfile,1,Pos('.',svmfile)-1);
 svmfile:=svmfile+'.svm';
 repeat
  if Pos('\',svmfile) <> 0 then
   svmfile:=Copy(svmfile,Pos('\',svmfile)+1,Length(svmfile)-Pos('\',svmfile));
 until Pos('\',svmfile) = 0;
 svmfile:=RDir+svmfile;
 if not IsFile(svmfile) then begin ShowError(3); Exit; end;
 SetUserScreen;
 DoneSysError;
 DoneEvents;
 DoneDosMem;
 SwapVectors;
 Exec(LDir+'svml.exe',SVMFile);
 SwapVectors;
 InitDosMem;
 InitEvents;
 InitSysError;
 SetPRGScreen;
 IF DosError <> 0 THEN ShowError(2);
end;

procedure ChangeScreen;
var tkey: Integer;
begin
 SetUserScreen;
 repeat
 until KeyPressed;
 tkey:=Ord(ReadKey);
 if tkey = 0 then tkey:=Ord(ReadKey);
 SetPRGScreen;
end;

procedure CompileAndRun;
begin
 if not Compile then exit;
 RestoreStatusLine;
 RunFile;
end;

 {Функция возвращает слово из строки по его номеру в строке}
 FUNCTION GetWord(str,str2: String; b: byte): String;
 VAR t,t1,c,f,l:byte;
     w: Byte;
 BEGIN
  str:=str+str2[1];
  c:=0;
  w:=1;
  f:=1;
  l:=1;
  FOR t:=1 TO Length(str) DO BEGIN
   IF Pos(str[t],str2) <> 0 THEN str[t]:=#0;
   IF str[t] <> #0 THEN BEGIN
    c:=c+w;
    IF w = 1 THEN f:=t;
    w:=0;
   END ELSE BEGIN
    w:=1;
    IF c=b THEN BEGIN
     GetWord:=copy(str,f,t-f);
     Exit;
    END;
   END;
  END;
  END;

 {Функция возвращает номер символа с которого начинается указанное слово}
 FUNCTION GetWordCount(str,str2: String; b: byte): Byte;
 VAR t,c,f,l:byte;
     w: Byte;
 BEGIN
  str:=str+str2[1];
  c:=0;
  w:=1;
  f:=1;
  l:=1;
  FOR t:=1 TO Length(str) DO BEGIN
    IF Pos(str[t],str2) <> 0 THEN str[t]:=#0;
    IF str[t] <> #0 THEN BEGIN
    c:=c+w;
    IF w = 1 THEN f:=t;
    w:=0;
   END ELSE BEGIN
    w:=1;
    IF (c=b) OR (t = Length(str)) THEN GetWordCount:=f ELSE GetWordCount:=1;
    IF c=b THEN Exit;
   END;
  END;
 END;

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

procedure ShowNextMessages;
var svmfile,ts,ts2,mestext,mesfile,mesno: String;
    pe: PEditWindow;
    ped: PEditor;
    tf: Text;
    n,k: Word;
    mesp,i: Integer;
    a,b: TPoint;
begin
 pe:=PEditWindow(DeskTop^.Current);
 if pe = nil then exit;
 if pe^.Editor^.Modified then begin
  ShowError(6);
  MesCount:=1;
  Exit;
 end;
 if PrimaryFile = '*.ASM' then begin
  if DeskTop^.Current <> nil then ts:=pe^.Editor^.FileName else begin ShowError(0); Exit; end;
 end else ts:=PrimaryFile;
 IF RDir[Length(RDir)] <> '\' THEN RDir:=RDir+'\';
 if Pos('.',ts) <> 0 THEN ts:=Copy(ts,1,Pos('.',ts)-1);
 ts:=ts+'.msg';
 repeat
  if Pos('\',ts) <> 0 then
   ts:=Copy(ts,Pos('\',ts)+1,Length(ts)-Pos('\',ts));
 until Pos('\',ts) = 0;
 ts:=RDir+ts;
 assign(tf,ts);
 {$I-}
 Reset(tf);
 {$I+}
 if IOResult <> 0 then begin
  ShowError(4);
  Exit;
 end;
 if lmf <> ts then begin
  MesCount:=1;
  lmf:=ts;
 end;
 n:=0;
 repeat
  inc(n);
  ReadLn(tf,ts);
 until (n >= 6) or (EOF(tf));
 ReadLn(tf,ts);
 if ts <> ' Messages:' then begin
  ShowError(4);
  Close(tf);
  Exit;
 end;
 n:=0;
 repeat
  Inc(n);
  ReadLn(tf,ts);
 until (ts = ';----------------------------------------------------------------------------;') or
       (ts = '') or
       (EOF(tf)) or (n = MesCount);
 if (ts = ';----------------------------------------------------------------------------;') or
    (ts = '') or
    (EOF(tf)) then begin
     if MesCount = 1 then ShowError(4);
     MesCount:=1; Close(tf); Exit;
    end else Inc(MesCount);
 ts2:=GetWord(ts,' ',2);
 mestext:=Copy(ts,GetWordCount(ts,' ',3),Length(ts)-GetWordCount(ts,' ',3)+1);
 mesfile:=Copy(GetWord(ts,' ',2),1,Pos('(',GetWord(ts,' ',2))-1);
 mesno:=Copy(ts,Pos('(',ts)+1,Pos(')',ts)-Pos('(',ts)-1);
 Val(mesno,mesp,i);
 if i <> 0 then mesp:=0;
 mesp:=mesp-2;
 FocusedFile(mesfile);
 pe:=PEditWindow(DeskTop^.Current);
 if DeskTop^.Current = nil then begin ShowError(5); Close(tf); Exit; end;
 Close(tf);
 pe^.Editor^.ScrollTo(0,mesp);
 pe^.Draw;
 pe^.WriteStr(1,1,AddS('Messages('+mesno+'): '+MesText,78),5);
 repeat
 until Keypressed;
 mesp:=ord(readkey);
 if mesp = 0 then mesp:=ord(readkey);
end;

procedure GetInfo(ts: String);
var t: Text;
    i: Integer;
begin
 IF MDir[Length(MDir)] <> '\' THEN MDir:=MDir+'\';
 if Pos('.',ts) <> 0 THEN ts:=Copy(ts,1,Pos('.',ts)-1);
 ts:=ts+'.map';
 repeat
  if Pos('\',ts) <> 0 then
   ts:=Copy(ts,Pos('\',ts)+1,Length(ts)-Pos('\',ts));
 until Pos('\',ts) = 0;
 ts:=MDir+ts;
 pc:=0; lc:=0; vc:=0; ic:=0; tl:=0;
 assign(t,ts);
 {$I-}
 reset(t);
 {$I+}
 if IOResult <> 0 then begin
  CodeSize:=0;
  FDataSize:=0;
  StackSize:=0;
  Exit;
 end;
 pc:=1; lc:=1; vc:=1; ic:=1; tl:=0;
 repeat
  readLn(t,ts);
  if Pos('Labels:',ts) <> 0 then begin
   lc:=0;
   repeat
    readln(t,ts);
    if ts <> '' then inc(lc);
   until (ts = '') or eof(t);
  end else
  if Pos('Variables:',ts) <> 0 then begin
   vc:=0;
   repeat
    readln(t,ts);
    if ts <> '' then inc(vc);
   until (ts = '') or eof(t);
  end else
  if Pos('Procedures:',ts) <> 0 then begin
   pc:=0;
   repeat
    readln(t,ts);
    if ts <> '' then inc(pc);
   until (ts = '') or eof(t);
  end else
  if Pos('Include files:',ts) <> 0 then begin
   ic:=0;
   repeat
    readln(t,ts);
    if ts <> '' then inc(ic);
   until (ts = '') or eof(t);
  end else
  if Pos('Code size:',ts) <> 0 then begin
   ts:=GetWord(ts,' ',3);
   val(ts,CodeSize,i);
   if i <> 0 then CodeSize:=0;
  end else
  if Pos('Data size:',ts) <> 0 then begin
   ts:=GetWord(ts,' ',3);
   val(ts,FDataSize,i);
   if i <> 0 then FDataSize:=0;
  end else
  if Pos('Stack size:',ts) <> 0 then begin
   ts:=GetWord(ts,' ',3);
   val(ts,StackSize,i);
   if i <> 0 then StackSize:=0;
  end else
  if Pos('Total lines:',ts) <> 0 then begin
   ts:=GetWord(ts,' ',3);
   val(ts,tl,i);
   if i <> 0 then tl:=0;
  end else
  if Pos('This program has not procedures.',ts) <> 0 then pc:=0;
  if Pos('This program has not labels.',ts) <> 0 then lc:=0;
  if Pos('This program has not variables.',ts) <> 0 then vc:=0;
  if Pos('This program has not include files.',ts) <> 0 then ic:=0;
 until eof(t);
 close(t);
end;

procedure ShowInfo;
var D: PDialog;
    R: TRect;
    ts,ts2: String;
    pe: PEditWindow;
begin
  pe:=PEditWindow(DeskTop^.Current);
  if PrimaryFile = '*.ASM' then begin
   if DeskTop^.Current <> nil then ts:=pe^.Editor^.FileName else begin ShowError(0); Exit; end;
  end else ts:=PrimaryFile;
  R.Assign(0, 0, 55, 18);
  D := New(PDialog, Init(R, 'Information'));
  GetInfo(ts);
  with D^ do
  begin
    Options := Options or ofCentered;
    R.Assign(2, 2, 13+Length(ts), 3);
    Insert(New(PStaticText, Init(R, 'File name: '+ts)));
    ts:='─────────── Program ────────────   ──── Memory ────';
    R.Assign(2, 4, Length(ts)+3, 5);
    Insert(New(PStaticText, Init(R,ts)));
    Str(tl,ts2); if ts2='0' then ts2:='no'; ts2:=ts2+' lines';
    R.Assign(2, 5, 35, 6);
    Insert(New(PStaticText, Init(R, AddS('Source compiled: ',32-Length(ts2))+ts2)));
    Str(CodeSize,ts2); ts2:=ts2+' bytes';
    R.Assign(2, 6, 35, 7);
    Insert(New(PStaticText, Init(R, AddS('Code size: ',32-Length(ts2))+ts2)));
    Str(FDataSize,ts2); ts2:=ts2+' bytes';
    R.Assign(2, 7, 35, 8);
    Insert(New(PStaticText, Init(R, AddS('Data size: ',32-Length(ts2))+ts2)));
    Str(StackSize,ts2); ts2:=ts2+' bytes';
    R.Assign(2, 8, 35, 9);
    Insert(New(PStaticText, Init(R, AddS('Stack size: ',32-Length(ts2))+ts2)));
    Str(pc,ts2); if ts2='0' then ts2:='none';
    R.Assign(2, 9, 35, 10);
    Insert(New(PStaticText, Init(R, AddS('Total procedures: ',32-Length(ts2))+ts2)));
    Str(lc,ts2); if ts2='0' then ts2:='none';
    R.Assign(2, 10, 35, 11);
    Insert(New(PStaticText, Init(R, AddS('Total labels: ',32-Length(ts2))+ts2)));
    Str(vc,ts2); if ts2='0' then ts2:='none';
    R.Assign(2, 11, 35, 12);
    Insert(New(PStaticText, Init(R, AddS('Total variables: ',32-Length(ts2))+ts2)));
    Str(ic,ts2); if ts2='0' then ts2:='none';
    R.Assign(2, 12, 35, 13);
    Insert(New(PStaticText, Init(R, AddS('Total include files: ',32-Length(ts2))+ts2)));

    Str(DosM,ts2);
    R.Assign(37,5,54,6);
    Insert(New(PStaticText, Init(R, AddS('DOS: ',16-Length(ts2+'K'))+ts2+'K')));
    Str(ExtM,ts2);
    R.Assign(37,6,54,7);
    Insert(New(PStaticText, Init(R, AddS('Extended: ',16-Length(ts2+'K'))+ts2+'K')));
    ts2:='230';
    R.Assign(37,7,54,8);
    Insert(New(PStaticText, Init(R, AddS('IDE: ',16-Length(ts2+'K'))+ts2+'K')));
    Str(GetMaxMem DIV 1024,ts2);
    R.Assign(37,8,54,9);
    Insert(New(PStaticText, Init(R, AddS('Free: ',16-Length(ts2+'K'))+ts2+'K')));

    R.Assign(37,10,54,11);
    Insert(New(PStaticText, Init(R, '── Processors ──')));
    case CPUType of
      0: ts:='80x86';
      2: ts:='80x286';
      3: ts:='80x386';
      4: ts:='80x486';
      else ts:='Pentium';
    end;
    R.Assign(37,11,54,12);
    Insert(New(PStaticText, Init(R, AddS('CPU: ',16-Length(ts))+ts)));
    case CPUType of
      0: ts:='87';
      2: ts:='287';
      3: ts:='387';
      4: ts:='int';
      else ts:='int';
    end;
    if Test8087 <> 0 then ts:='none';
    R.Assign(37,12,54,13);
    Insert(New(PStaticText, Init(R, AddS('Co-proc: ',16-Length(ts))+ts)));

    if tl < 1 then ts2:=' not compiled' else ts2:='compiled';
    R.Assign(2, 13, 35, 14);
    Insert(New(PStaticText, Init(R, AddS('Status of file: ',32-Length(ts2))+ts2)));

    R.Assign(21, 15, 31, 17);
    Insert(New(PButton, Init(R, 'O~K~', cmOk, bfDefault)));
    SelectNext(False);
  end;
  if ValidView(D) <> nil then begin
   Desktop^.ExecView(D);
   Dispose(D, Done);
  end;
end;

procedure WindowList;
var D: PDialog;
    R,R1: TRect;
    ts,ts2: String;
    pe: PEditWindow;
    pc: PCollection;
    ps: PScrollBar;
    tstr: PString;
    pl: PListBox;
    n: Integer;
    now: Boolean;
begin
 pc:=nil;
 if MemAvail > 16*1024 then pc:=New(PCollection,Init(10,25)) else begin
  OutOfMemory;
  Exit;
 end;
 pe:=PEditWindow(DeskTop^.Current);
 now:=True;
 if pe = nil then begin
  New(tstr);
  tstr^:='None windows';
  pc^.AtInsert(0,tstr);
 end else begin
 now:=False;
  while (pe <> nil) and (tstr <> nil) and isFile(pe^.Editor^.FileName) do begin
   tstr:=nil;
   if MemAvail > 512 then New(tstr);
   if (tstr <> nil) and isFile(pe^.Editor^.FileName) then begin
    tstr^:=pe^.Editor^.FileName;
    if (pe^.Editor^.FileName <> '') then pc^.AtInsert(0,tstr) else Dispose(tstr);
    pe:=PEditWindow(pe^.nextview);
   end else begin
    if not isFile(pe^.Editor^.FileName) and (tstr <> nil) then Dispose(tstr);
   end;
  end;
  pe:=PEditWindow(DeskTop^.Current^.prevview);
  while (pe <> nil) and (tstr <> nil) and isFile(pe^.Editor^.FileName) do begin
   tstr:=nil;
   if MemAvail > 512 then New(tstr);
   if (tstr <> nil) and isFile(pe^.Editor^.FileName)  then begin
    tstr^:=pe^.Editor^.FileName;
    if (pe^.Editor^.FileName <> '') then pc^.AtInsert(0,tstr) else Dispose(tstr);
    pe:=PEditWindow(pe^.prevview);
   end else
    if not isFile(pe^.Editor^.FileName) and (tstr <> nil) then Dispose(tstr);
  end;
 end;
  R.Assign(0, 0, 60, 18);
  D := New(PDialog, Init(R, 'Window List'));
  with D^ do
  begin
    Options := Options or ofCentered;
    R.Assign(3,3,44,16);
    R1.Assign(44,3,45,16);
    ps:=nil;
    if MemAvail > 2*1024 then begin
     ps:=New(PScrollBar,Init(R1));
     Insert(ps);
    end;
    pl:=New(PListBox,Init(R,1,ps));
    pl^.NewList(pc);
    R.Assign(2,2,44,3);
    Insert(New(PLabel, Init(R, '~W~indows', pl)));
    Insert(pl);
    R.Assign(46, 3, 58, 5);
    Insert(New(PButton, Init(R, 'O~K~', cmOk, bfDefault)));
    R.Assign(46, 6, 58, 8);
    Insert(New(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));
    SelectNext(False);
  end;
  if ValidView(D) <> nil then begin
   if (Desktop^.ExecView(D) = cmOk) and not now then begin
    tstr:=pc^.at(pl^.Focused);
    if tstr^ = 'Untitled' then FocusedFile('') else
     if IsFile(tstr^) and (tstr^ <> '') then FocusedFile(tstr^) else ShowClip;
   end;
   for n:=0 to pc^.Count-1 do FreeMem(pc^.At(n),256);
   pc^.DeleteAll;
   if pl <> nil then Dispose(pl, Done);
   if pc <> nil then Dispose(pc, Done);
   if ps <> nil then Dispose(ps, Done);
   Dispose(D, Done);
  end;
end;

procedure RunDebugger;
var svmfile,ts,ts2: String;
    pe: PEditWindow;
begin
 if not Compile then begin ShowError(3); Exit; end;
 pe:=PEditWindow(DeskTop^.Current);
 if pe = nil then exit;
 if PrimaryFile = '*.ASM' then begin
  if DeskTop^.Current <> nil then ts:=pe^.Editor^.FileName else begin ShowError(0); Exit; end;
 end else ts:=PrimaryFile;
 svmfile:=ts;
 IF DDir[Length(DDir)] <> '\' THEN DDir:=DDir+'\';
 IF RDir[Length(RDir)] <> '\' THEN RDir:=RDir+'\';
 if Pos('.',svmfile) <> 0 THEN svmfile:=Copy(svmfile,1,Pos('.',svmfile)-1);
 svmfile:=svmfile+'.svm';
 repeat
  if Pos('\',svmfile) <> 0 then
   svmfile:=Copy(svmfile,Pos('\',svmfile)+1,Length(svmfile)-Pos('\',svmfile));
 until Pos('\',svmfile) = 0;
 svmfile:=RDir+svmfile;
 if not IsFile(svmfile) then begin ShowError(3); Exit; end;
 SetUserScreen;
 DoneSysError;
 DoneEvents;
 DoneDosMem;
 SwapVectors;
 Exec(DDir+'svmd.exe',SVMFile);
 SwapVectors;
 InitDosMem;
 InitEvents;
 InitSysError;
 SetPRGScreen;
 IF DosError <> 0 THEN ShowError(7);
end;

procedure ShowInfoSystem;
var  W: PWindow;
     HFile: PHelpFile;
     HelpStrm: PDosStream;
const  HelpInUse: Boolean = False;
begin
 HelpInUse := True;
 HelpStrm := New(PDosStream, Init(CalcHelpName, stOpenRead));
 HFile := New(PHelpFile, Init(HelpStrm));
 if HelpStrm^.Status <> stOk then begin
  MessageBox('Could not open help file.', nil, mfError + mfOkButton);
  Dispose(HFile, Done);
 end else begin
  W:=New(PHelpWindow,Init(HFile, hcInfoSystem));
  if ValidView(W) <> nil then
  begin
   ExecView(W);
   Dispose(W, Done);
  end;
 end;
 HelpInUse := False;
end;

procedure ShowMainList;
var  W: PWindow;
     HFile: PHelpFile;
     HelpStrm: PDosStream;
const  HelpInUse: Boolean = False;
begin
 HelpInUse := True;
 HelpStrm := New(PDosStream, Init(CalcHelpName, stOpenRead));
 HFile := New(PHelpFile, Init(HelpStrm));
 if HelpStrm^.Status <> stOk then begin
  MessageBox('Could not open help file.', nil, mfError + mfOkButton);
  Dispose(HFile, Done);
 end else begin
  W:=New(PHelpWindow,Init(HFile, hcMainList));
  if ValidView(W) <> nil then
  begin
   ExecView(W);
   Dispose(W, Done);
  end;
 end;
 HelpInUse := False;
end;

procedure ShowLastHelp;
var  W: PWindow;
     HFile: PHelpFile;
     HelpStrm: PDosStream;
const  HelpInUse: Boolean = False;
begin
 if HelpLastCounter = 0 then Exit;
 HelpInUse := True;
 HelpStrm := New(PDosStream, Init(CalcHelpName, stOpenRead));
 HFile := New(PHelpFile, Init(HelpStrm));
 if HelpStrm^.Status <> stOk then begin
  MessageBox('Could not open help file.', nil, mfError + mfOkButton);
  Dispose(HFile, Done);
 end else begin
  W:=New(PHelpWindow,Init(HFile, HelpContextList[HelpLastCounter]));
  if HelpLastCounter > 0 then Dec(HelpLastCounter);
  if ValidView(W) <> nil then
  begin
   ExecView(W);
   Dispose(W, Done);
  end;
 end;
 HelpInUse := False;
end;

begin
  inherited HandleEvent(Event);
  case Event.What of
    evCommand:
      begin
        case Event.Command of
          cmOpen: FileOpen('*.ASM');
          cmNew: FileNew;
          cmShowClip: ShowClip;
          cmChangeDir: ChangeDir;
          cmAbout: About;
          cmExitPRG: ExitFromProgram;
          cmCompile: Compile;
          cmPrimary: SetPrimaryFile;
          cmClearPrimary: ClearPF;
          cmCalculator: Calculator;
          cmDirectories: Directories;
          cmSaveDesktop: SaveDesktop;
          cmRetrieveDesktop: RetrieveDesktop;
          cmRun: RunFile;
          cmC_R: CompileAndRun;
          cmMess: ShowNextMessages;
          cmUserS: ChangeScreen;
          cmFInfo: ShowInfo;
          cmWList: WindowList;
          cmDebugging: RunDebugger;
          cmInfoSys: ShowInfoSystem;
          cmMainList: ShowMainList;
          cmPHelp: ShowLastHelp;
        else
          Exit;
        end;
        ClearEvent(Event);
      end;
  end;
 RestoreStatusLine;
end;

procedure TSVMIDE.Idle;

function IsTileable(P: PView): Boolean; far;
begin
  IsTileable := P^.Options and ofTileable <> 0;
end;

begin
  TApplication.Idle;
  Clock^.Update;
  Heap^.Update;
  if Desktop^.FirstThat(@IsTileable) <> nil then
    EnableCommands([cmTile, cmCascade])
  else
    DisableCommands([cmTile, cmCascade]);
end;

procedure TSVMIDE.InitMenuBar;
var
  R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y+1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~F~ile', hcMFile, NewMenu(
     NewItem('~N~ew', 'Alt+N', kbAltN, cmNew, hcNew,
     NewItem('~O~pen...', 'F3', kbF3, cmOpen, hcOpen,
     NewItem('~S~ave', 'F2', kbF2, cmSave, hcSave,
     NewItem('S~a~ve as...', '', kbNoKey, cmSaveAs, hcSaveAs,
     NewItem('Save a~l~l...', 'Alt+F2', kbAltF2, cmSaveAll, hcSaveAll,
     NewLine(
     NewItem('~C~hange dir...', '', kbNoKey, cmChangeDir, hcChangeDir,
     NewItem('~D~OS shell', '', kbNoKey, cmDosShell, hcDosShell,
     NewItem('E~x~it', 'Alt+X', kbAltX, cmQuit, hcExit,
     nil)))))))))),
    NewSubMenu('~E~dit', hcMEdit, NewMenu(
      NewItem('~U~ndo', '', kbAltBack, cmUndo, hcUndo,
      NewLine(
      NewItem('Cu~t~', 'Shift+Del', kbShiftDel, cmCut, hcCut,
      NewItem('~C~opy', 'Ctrl+Ins', kbCtrlIns, cmCopy, hcCopy,
      NewItem('~P~aste', 'Shift+Ins', kbShiftIns, cmPaste, hcPaste,
      NewItem('C~l~ear', 'Ctrl+Del', kbCtrlDel, cmClear, hcClear,
      NewLine(
      NewItem('~S~how clipboard', '', kbNoKey, cmShowClip, hcShowClipboard,
      nil))))))))),
    NewSubMenu('~S~earch', hcMSearch, NewMenu(
      NewItem('~F~ind...', 'F7', kbF7, cmFind, hcFind,
      NewItem('~R~eplace...', '', kbNoKey, cmReplace, hcReplace,
      NewItem('~S~earch again', 'Shift+F7', kbShiftF7, cmSearchAgain, hcSearchAgain,
      nil)))),
    NewSubMenu('~R~un',hcMRun, NewMenu(
      NewItem('~R~un', 'Ctrl+F9', kbCtrlF9, cmRun, hcRun,
      NewItem('~D~ebugger', 'F8', kbF8, cmDebugging, hcDebugger,
      nil))),
    NewSubMenu('~C~ompile', hcMCompile, NewMenu(
      NewItem('~C~ompile', 'Alt+F9', kbAltF9, cmCompile, hcCompile,
      NewItem('~P~rimary file...','Alt+P',KbAltP, cmPrimary, hcSetPF,
      NewItem('C~l~ear primary file','Alt+L',KbAltL, cmClearPrimary, hcClearPF,
      nil)))),
    NewSubMenu('~T~ools', hcMTools, NewMenu(
      NewItem('~C~alculator', 'Ctrl+F4', kbCtrlF4, cmCalculator, hcCalculator,
      NewItem('~U~ser screen','Alt+F5',kbAltF5, cmUserS, hcUserScreen,
      NewItem('~M~essages...','', kbNoKey, cmMess, hcMessage,
      NewItem('~I~nformation...','', kbAltI, cmFInfo, hcInformation,
      nil))))),
    NewSubMenu('~O~ptions', hcMOptions, NewMenu(
      NewItem('~D~irectories...', '', kbNoKey, cmDirectories, hcDirectories,
      NewLine(
      NewItem('~S~ave desktop', '', kbNoKey, cmSaveDesktop, hcNoContext,
      NewItem('~R~etrieve desktop', '', kbNoKey, cmRetrieveDesktop, hcNoContext,
      nil))))),
    NewSubMenu('~W~indows', hcWindows, NewMenu(
      NewItem('~T~ile', '', kbNoKey, cmTile, hcTile,
      NewItem('C~a~scade', '', kbNoKey, cmCascade, hcCascade,
      NewItem('Cl~o~se all', '', kbNoKey, cmCloseAll, hcCloseAll,
      NewLine(
      NewItem('Re~S~ize','Ctrl+F5', kbCtrlF5, cmResize, hcResize,
      NewItem('~Z~oom', 'F5', kbF5, cmZoom, hcZoom,
      NewItem('~N~ext', 'F6', kbF6, cmNext, hcNext,
      NewItem('~P~revious', 'Shift+F6', kbShiftF6, cmPrev, hcPrevious,
      NewItem('~C~lose', 'Alt+F3', kbAltF3, cmClose, hcClose,
      NewLine(
      NewItem('~L~ist...', 'Alt+0', kbAlt0, cmWList, hcWindowList,
      nil)))))))))))),
    NewSubMenu('~H~elp', hcMHelp, NewMenu(
      NewItem('~I~ndex','Shift+F1',kbShiftF1, cmMainList, hcMainListH,
      NewItem('~C~ontents', '', KbNoKey, cmInfoSys, hcInfoSystemH,
      NewLine(
      NewItem('~A~bout...', '', KbNoKey, cmAbout, hcAbout,
      nil))))),
      nil))))))))))));
end;

procedure TSVMIDE.InitStatusLine;
var
  R: TRect;
begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine := New(PStatusLine, Init(R,
    NewStatusDef(0, $FFFF,
      NewStatusKey('', kbAltX, cmExitPRG,
      NewStatusKey('~F1~ Help', kbF1, cmHelp,
      NewStatusKey('~F2~ Save', kbF2, cmSave,
      NewStatusKey('~F3~ Open', kbF3, cmOpen,
      NewStatusKey('~Alt-F9~ Compile', kbAltF9, cmCompile,
      NewStatusKey('', kbF10, cmMenu,
      NewStatusKey('', kbCtrlF5, cmResize,
      NewStatusKey('~F9~ Compile and run', kbF9, cmC_R,
      NewStatusKey('',kbAltM, cmMess,
      nil)))))))))
     ,nil)));
end;

procedure TSVMIDE.OutOfMemory;
begin
  MessageBox('Not enough memory available to complete operation.',
    nil, mfError + mfOkButton);
end;

{ Since the safety pool is only large enough to guarantee that allocating
  a window will not run out of memory, loading the entire desktop without
  checking LowMemory could cause a heap error.  This means that each
  window should be read individually, instead of using Desktop's Load.
}

procedure TSVMIDE.LoadDesktop(var S: TStream);
var
  P: PView;
  Pal: PString;

procedure CloseView(P: PView); far;
begin
  Message(P, evCommand, cmClose, nil);
end;

begin
    Desktop^.ForEach(@CloseView); { Clear the desktop }
    repeat
      P := PView(S.Get);
      Desktop^.InsertBefore(ValidView(P), Desktop^.Last);
    until P = nil;
    Pal := S.ReadStr;
    if Pal <> nil then
    begin
      Application^.GetPalette^ := Pal^;
      DoneMemory;
      Application^.ReDraw;
      DisposeStr(Pal);
    end;
end;

procedure TSVMIDE.StoreDesktop(var S: TStream);
var
  Pal: PString;

begin
end;

var
  IDE: TSVMIDE;
  d,m: Word;
begin
  WriteLn('SVM Assembler  Version 1.2  Copyright (c) 1999 ShAG Studio');
  LFS:=0;
  if not RenameFile('svmasm.mem','cinfo.exe') then begin
   WriteLn('Error: svmasm.mem not found.');
   Halt(0);
  end;
  HelpLastCounter:=0;
  SwapVectors;
  Exec('cinfo.exe','/NI');
  SwapVectors;
  if (DosError <> 0) or not RenameFile('cinfo.exe','svmasm.mem') or
     (MemL[0:$4f0] <> 1195468883 ) then begin
   WriteLn('Error: svmasm.mem not found.');
   Halt(0);
  end;
  DosM:=MemW[0:$4f0+4];
  ExtM:=MemW[0:$4f0+6];
  FreeM:=MemW[0:$4f0+8];
  CPUType:=MemW[0:$4f0+10];
  i_sub:=LongInt(FreeM*1024);
  SaveScreen(UserScreen);
  UserX:=WhereX;
  UserY:=WhereY;
  MesCount:=1;
  IDE.Init;
  IDE.Run;
  IDE.Done;
  SetUserScreen;
end.
