 unit DLLI;

 interface

 type   PProc     = ^TProc;
        TProc     = record
          Proc    : Pointer;
          Next    : PProc;
        end;


 procedure PushDS;
 inline($1E);

 procedure PopDS;
 inline($1F);

 procedure SetDS;
 function  AddProc(proc: Pointer; next: PProc): PProc;
 function  Export(done: Pointer; procs: PProc): Word;
 procedure DoneDLL;

 procedure FreeLibrary(Handle: Word);
 function  GetProcAddress(Handle, ProcNumber: Word): Pointer;
 function  IsApp: Boolean;
 function  LoadLibrary(path: String): Word;

 implementation

 uses   Dos;

 type   PTable    = ^TTable;
        TTable    = record
          Total   : Word;
          DoneLib : Pointer;
          Procs   : array [0..1] of Pointer;
        end;

 type   TLibrary  = record
          Name    : String[12];
          Table   : PTable;
        end;

 var    Libs      : array [0..255] of TLibrary;
        Table     : PTable;
        Name      : String[12];


 function  UpString(s: String): String; { Возвращает строку в верхнем	    }
 var	   n	  : Byte;		{ регистре			    }
 begin
   for n:=1 to Length(s) do
     s[n]:=UpCase(s[n]);
   UpString:=s;
 end;


 function  GetName(path: String): String; { Вовзвращает только имя файла из }
 begin					{ из полного пути к этому файлу     }
   while Pos('\', path) <> 0 do
     Delete(path, 1, Pos('\', path));
   GetName:=UpString(path);
 end;


 procedure FreeLibrary(Handle: Word);
 var       p      : Pointer;
 begin
   if Libs[Handle].Name = '' then
     Exit;
   Libs[Handle].Name:='';
   p:=Libs[Handle].Table^.DoneLib;
   Libs[Handle].Table:=nil;
   asm
     call p
   end;
 end;


 function  GetProcAddress(Handle, ProcNumber: Word): Pointer;
 begin
   GetProcAddress:=nil;
   if Libs[Handle].Name = '' then
     Exit;
   if Libs[Handle].Table^.Total <= ProcNumber then
     Exit;
   GetProcAddress:=Libs[Handle].Table^.Procs[ProcNumber];
 end;


 function  LoadLibrary(path: String): Word;
 var       n      : Word;
           NewName: String[12];
 begin
   NewName:=GetName(path);
   for n:=0 to 255 do
     if (Libs[n].Name = NewName) or (Libs[n].Name = '') then
       Break;
   if (Libs[n].Name = '') and (Libs[n].Name <> NewName) then
   begin
     MemL[$0:$4F0]:=LongInt(123456789);
     Exec(path, '');
     if DosError <> 0 then
       LoadLibrary:=$FFFF
     else
       if MemL[$0:$4F0] = LongInt(987654321) then
       begin
         Libs[n].Name:=NewName;
         Libs[n].Table:=Pointer(MemL[$0:$4F4]);
         LoadLibrary:=n;
       end;
   end else
     if Libs[n].Name = NewName then
       LoadLibrary:=n
     else
       LoadLibrary:=$FFFF;
 end;


 function  Export(done: Pointer; procs: PProc): Word;
 var       np, cp : PProc;
           c      : Word;
 begin
   Export:=0;
   cp:=procs;
   np:=procs;
   c:=0;
   while cp <> nil do
   begin
     cp:=cp^.next;
     Inc(c);
   end;
   if (MemAvail > c*4+30) or (done = nil) then
     GetMem(Table, c*4+30)
   else
     Table:=nil;
   cp:=procs;
   c:=0;
   while cp <> nil do
   begin
     np:=cp^.next;
     if Table <> nil then
       Table^.Procs[c]:=cp^.proc;
     Dispose(cp);
     cp:=np;
     Inc(c);
   end;
   if Table <> nil then
   begin
     Name:=GetName(ParamStr(0));
     Table^.Total:=c;
     Table^.DoneLib:=done;
     MemL[$0:$4F0]:=LongInt(987654321);
     MemL[$0:$4F4]:=LongInt(Table);
   end else
     c:=0;
   Export:=c;
 end;


 function  AddProc(proc: Pointer; next: PProc): PProc;
 var       pp     : PProc;
 begin
   AddProc:=nil;
   if MemAvail < SizeOf(TProc) then
     Exit;
   New(pp);
   pp^.proc:=proc;
   pp^.next:=next;
   AddProc:=pp;
 end;


 function  IsApp: Boolean;
 begin
   IsAPP:= (MemL[$0:$4F0] = LongInt(123456789));
 end;


 procedure Kill(name: String);
 type      PMCB = ^TMCB;
           TMCB = record
             Mode : Char;
             Owner: Word;
             Size : Word;
             Reserved: array [0..10] of Char;
             Name : array [0..7] of Char;
           end;

 var       s, l   : Word;
           cmcb   : PMCB;
           st     : String[12];
           N      : Byte;
 begin
   if Pos('.', Name) <> 0 then
     Name:=Copy(Name, 1, Pos('.', Name)-1);
   asm
     mov ah, $52
     int 21h
     mov ax, es:[bx-2]
     mov es, ax
     mov s, ax
     xor ax, ax
   end;
   cmcb:=Ptr(s, 0);
   while cmcb^.Mode = 'M' do
   begin
     St:='';
     n:=3;
     if cmcb^.Owner > 8 then
     begin
       while (cmcb^.Reserved[n] <> #0) and (n < 11) do
       begin
         st:=st+UpCase(cmcb^.Reserved[n]);
         Inc(n);
       end;
       if Name = st then
       begin
         asm
           mov ax, l
           inc ax
           mov es, ax
           mov ah, $49
           int $21
           mov ax, s
           inc ax
           mov es, ax
           mov ah, $49
           int $21
         end;
         Break;
       end;
     end;
     l:=s;
     s:=s+cmcb^.Size+1;
     cmcb:=Ptr(s, 0);
   end;
 end;


 procedure DoneDLL;
 begin
   FreeMem(Table, Table^.Total*4+30);
   Kill(Name);
 end;


 procedure SetDS; assembler;
 asm
   mov  ax, seg Libs
   mov  ds, ax
 end;

begin
end.