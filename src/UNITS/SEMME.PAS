{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
{=============================ShAG EMM Emulator==============================}
{====         ������ EMM �ࠩ��� �⮪��� ������ �����������         ====}
{====                           ����� 1.0                               ====}
{====--------------------------------------------------------------------====}
{====  ����� ࠧ�蠥��� �ᯮ�짮���� ⮫쪮 � ��������᪨� 楫��, �� ====}
{==== �᫮���, �� ��室�� ⥪�� ��� �ணࠬ� ����ᠭ��� � �ᯮ�짮��- ====}
{==== ���� �⮣� ����� ������� �⮪��� ����ᥩ �����������, �� ⠪��   ====}
{==== �� �ࠢ��, ��� � ��� �����, �஬� ����祭�� ����� �ணࠬ�.      ====}
{====--------------------------------------------------------------------====}
{====  ����� ᮧ��� � Turbo Pascal 5.1                                  ====}
{====--------------------------------------------------------------------====}
{====  ����� ����� ⠪�� �� ������� ��� �ࠩ��� EMM, ���⮬� �ᯮ����  ====}
{==== �� �������, ����� ������ EMM, ����� ⠪ �� ࠡ���� � �������,   ====}
{==== ���� �᫨ �� ���� ��� ���� ���, ����� ᮤ��� �� ��᪥ ᢮� 䠩�  ====}
{==== �㦭��� ࠧ���, � ������� �ᯮ����� ��� ��� ������.              ====}
{====  ����筮 ᪮���� �� ࠡ�� � ⠪�� ������� �㤥� ����, �� �� �� ====}
{==== ���� N �������� � �ମ��,祬 1 �������� � ����� �⮯.           ====}
{====--------------------------------------------------------------------====}
{====  �ਬ�砭��. ���� �� �ந�����⥫쭮��� �� 80x286 12 �������� ���� ====}
{==== ᮯ����� �� 6 ��������, ���� 1 �������� ����⨢�� � ���� �� 80 ====}
{==== ��������, ������� �� ࠡ�� � ����㠫��� �������, ��:            ====}
{==== � ������  ��ᨢ�  �� 112000 ����  �ந�室�� � 3 ࠧ� ��������� ====}
{==== 祬 � ����;                                                        ====}
{==== � ������ ��ᨢ� �� 56000 ᫮� �ந�室�� � 4 ࠧ� ��������� 祬 ====}
{==== � ����;                                                            ====}
{==== � ������ ��ᨢ� �� 28000 ������� ᫮� �ந�室�� � 7.5 ࠧ ���- ====}
{==== ������ 祬 � ����;                                                 ====}
{==== � ������  ��ᨢ� �� 18600 ��⨡��⮢�� ᫮� �ந�室�� � 9 ࠧ ====}
{==== ��������� 祬 � ����;                                              ====}
{============================================================================}
                                 UNIT SEMME;
{============================================================================}
                                  INTERFACE
{============================================================================}
 USES Dos,Crt;

 CONST PageSize = 16384; {������ ��࠭��� � �����}
       MaxPages = 4096;  {���ᨬ��쭮� ������⢮ ��࠭�� ����� ����� �ᯮ�짮����}
       MaxHandle = 5000; {���ᨬ��쭮� ������⢮ 㪠��⥫��}
       PageSH   = 14;
 TYPE TPage = ARRAY [1..PageSize] OF Byte; {��� ��࠭���}

 TYPE TPages = ARRAY [0..MaxPages] OF Word; {��� �࠭�騩 ���ଠ�� � �裡 ��࠭��}

 TYPE THandle = RECORD {��� �࠭�騩 ���ଠ�� � �����⭮� 㪠��⥫�}
  FirstPage: Word;      {�����᪨� ����� ��ࢮ� ��࠭�� � 䠩��}
  LastUsedPage: Word;   {�����᪨� ����� ��࠭��, ����� �ᯮ�짮������ ���ᥤ���}
  SizeInPages: Word;    {������⢮ ��࠭�� �뤥����� ��� �⮣� 㪠��⥫�}
 END;

 TYPE PHandle = ^THandle;

 TYPE THandles = ARRAY [1..MaxHandle] OF PHandle; {���᮪ ���ଠ樨 ��� ��� 㪠��⥫��}

 TYPE PHandles = ^THandles;

 TYPE PPage = ^TPage;

 TYPE PPages = ^TPages;

 VAR  SEMMEStatus, SEMMEError: Boolean;    {�ਧ��� �訡��}
      SEMMECodeError: Byte;   {��� �訡��}
      Pages: PPages;          {���ଠ�� � �������裡 ��࠭��}
      SEMMEWindow: PPage;     {����}
      WindowUsing: Boolean;
      LastHandle, TotalHandle, LastPPage, LastPPPage: Word; {��᫥���� �ᯮ��㥬� 㪠��⥫�,
       ��饥 ������⢮ 㪠��⥫��, ��᫥���� �ᯮ��㥬�� 䨧��᪠� ��࠭��}
      Handles: PHandles;      {���᮪ 㪠��⥫��}
      TotalPages: Word;       {��饥 ������⢮ ��࠭��}
      WindowSeg, WindowOfs: Word;  {������� � ᬥ饭�� ����}
      FreePages: Word;        {��������� ������⢮ ��࠭��}
      SWPFile: File Of TPage; {���� ᢮�}
      SWPName: String;       {��� �⮣� 䠩��}
      SWPDisk: Char;          {��� �� ���஬ �㤥 ᮧ��� ᢮�}

 PROCEDURE InitSEMME(Size: Word; Disk:Char);  {���樠������� �����, ��⠭����������
                 ࠧ��� ����� ������ ���� ��㫨஢���,� ��� ��� ᢮� 䠩��}

 PROCEDURE DoneSEMME;                   {�����樠������� �����, � 㤠��� ᢮� 䠩�}

 FUNCTION  NewHandle(Size: Word): Word; {������� ���� 㪠��⥫� � �뤥��� ���
                            ���� �ॡ㥬� ��ꥬ �����, �᫨ ⠪���� �������}

 PROCEDURE DisposeHandle(Index: Word);  {����⮦��� 㪠����� � �ᮡ������ �易���� � ��� ������}

 PROCEDURE MapSEMMEPage(Handle, Phisical: Word); {������� 䨧����� ��࠭���
     㪠��⥫� � ����, �� �⮬ ��࠭�� ��࠭��� �०�� ��室������� � ����}

 PROCEDURE ChangeHandleSize(Handle, NewSize: Word); {����� ������⢮ ��࠭��
                                       �易���� � ����� 㪠��⥫��}
 PROCEDURE Load(name: String);          {������� ���� 㪠��⥫� � ����㦠�� �
                                         ���� ���ଠ�� �� 䠩��}
 PROCEDURE Save(Handle: Word; name: String); {���࠭�� ���ଠ�� �࠭������
                                         � 㪠��⥫� � 䠩� �� ���}
{============================================================================}
                                IMPLEMENTATION
{============================================================================}

 FUNCTION GetDirNum(c: Char):Byte;
 VAR t:Byte;
 BEGIN
  t:=Ord(UpCase(c))-64;
  IF (t < 3) OR (t > 10) THEN t:=3;
  GetDirNum:=t;
 END;

{=================================}

 PROCEDURE InitSEMME(Size: Word; Disk:Char);
 VAR t:Word;
 BEGIN
  IF (DiskFree(GetDirNum(Disk)) DIV PageSize + 1) > Size THEN BEGIN
   SEMMEStatus:=True;
   SWPDisk:=Disk;
   Assign(SWPFile,SWPDisk+':\'+SWPName);
   {$I-}
   Rewrite(SWPFile);
   {$I+}
   IF IOResult <> 0 THEN BEGIN
    {�訡��, ���������� ᮧ���� 䠩�}
    SEMMEStatus:=False;
    SEMMEError:=True;
    SEMMECodeError:=1;
    Exit;
   END;
   New(SEMMEWindow);
   New(Pages);
   New(Handles);
   TotalHandle:=0;
   WindowSeg:=Seg(SEMMEWindow);
   WindowOfs:=Ofs(SEMMEWindow);
   TotalPages:=Size;
   FreePages:=Size;
   FOR t:=1 TO MaxHandle DO Handles^[t]:=NIL;
   FOR t:=1 TO PageSize DO SEMMEWindow^[t]:=0;
   FOR t:=0 TO MaxPages DO Pages^[t]:=0;
   FOR t:=0 TO Size-1 DO Write(SWPFile,SEMMEWindow^);
   Delay(1000);
   {��� �訡��}
   SEMMEError:=False;
   SEMMECodeError:=0;
  END ELSE BEGIN
   {�訡��, �� ��᪥ �������筮 ����}
   SEMMEError:=True;
   SEMMECodeError:=1;
  END;
 END;

{=================================}

 PROCEDURE DoneSEMME;
 BEGIN
  IF SEMMEStatus THEN Close(SWPFile);
  SEMMEStatus:=False;
 END;
{=================================}
 FUNCTION  NewHandle(Size: Word): Word;
 VAR t,t1,lp:Integer;
     th:Word;
 BEGIN
  IF Size < FreePages THEN BEGIN
   FreePages:=FreePages-Size;
   {�饬 ᢮����� 㪠��⥫�}
   t:=0;
   REPEAT
    Inc(t);
   UNTIL (Handles^[t]=NIL) OR (t=MaxHandle);
   IF t < MaxHandle THEN BEGIN
    th:=t;
    Inc(TotalHandle);
    New(Handles^[TH]);
    {���⠢�塞 ����� ����㯭�� ��࠭�� ��� ������ 㪠��⥫�}
    t:=0;
    {���� ��ࢮ� ᢮������ ��࠭���}
    REPEAT
     Inc(t);
    UNTIL (Pages^[t-1]=0) OR (t-1 = MaxPages);
    Handles^[TH]^.FirstPage:=t-1; {��ࢠ� ��࠭�� ������ 㪠��⥫�}
    Handles^[TH]^.SizeInPages:=Size; {����ᨬ � 㪠��⥫� �� ��� ࠧ���}
    Handles^[TH]^.LastUsedPage:=$FFFF; {����砥� ��᫥���� �⠭���, ��� �����}
    t1:=1;   {���稪 ��������� ��࠭��}
    t:=0;    {���稪 ��� ��࠭��}
    lp:=Handles^[TH]^.FirstPage;
    {���� ᢮������ ��࠭�� ��� ������ 㠧�⥫�}
    REPEAT
     Inc(t);
     IF (Pages^[t-1]=0) AND (t-1 <> lp) THEN BEGIN
      Inc(t1);
      Pages^[lp]:=t-1;
      lp:=t-1;
      END;
    UNTIL t1=Size;
    Pages^[lp]:=$FFFF; {��᫥���� ��࠭��� ����砥� ��� $FFFF}
    NewHandle:=TH;
   END ELSE BEGIN
   {�訡��, ��� ᢮������ 㪠��⥫��}
   SEMMEError:=True;
   SEMMECodeError:=2;
   NewHandle:=0;
   END;
  END ELSE BEGIN
   {�訡��, ��� ����}
   SEMMEError:=True;
   SEMMECodeError:=3;
   NewHandle:=0;
  END;
 END;

{=================================}

 PROCEDURE DisposeHandle(Index: Word);
 VAR t,t1,np:Word;
 BEGIN
  IF Handles^[Index] <> NIL THEN BEGIN
  {�����蠥� ��饥 �᫮ 㪠��⥫�� �� 1}
  Dec(TotalHandle);
  {��ࠥ� ����� ������� ��࠭��� �⮣� 㠧�⥫�, ��稭�� � ��� ��ࢮ�}
  t1:=0; {���稪 ������ ��࠭��}
  t:=Handles^[Index]^.FirstPage;
  REPEAT
   Inc(t1);
   np:=Pages^[t]; {����砥� ����� ᫥���饩 ��࠭���}
   Pages^[t]:=0; {����塞 ��࠭���}
   t:=np;
  UNTIL t1=Handles^[Index]^.SizeInPages;
  {�����稢��� ������⢮ ᢮��������࠭�� �� �� ��࠭�� ��襣� 㪠��⥫�}
   FreePages:=FreePages+Handles^[Index]^.SizeInPages;
  {�᢮������� ������ �� ���ଠ樨 � 㪠��⥫�}
   Dispose(Handles^[Index]);
  {����砥� ��� ��� ���⮩ 㪠��⥫�}
   Handles^[Index]:=NIL;
  END ELSE BEGIN
   {�訡��, ⠪�� 㪠��⥫� �� ���c���}
   SEMMEError:=True;
   SEMMECodeError:=4;
  END;
 END;

{=================================}

 PROCEDURE MapSEMMEPage(Handle, Phisical: Word);
 VAR t,t1,np,t2:Word;
     Size: Word;
 LABEL exitt,rept;
 BEGIN                 {��� ���ᨬ��쭮�� �᪮७�� ��楤�� ��ᠫ��� �
                        �᭮���� �� ��ᥬ����}
 IF Handles^[Handle] <> NIL THEN BEGIN
    Size:=Handles^[Handle]^.SizeInPages;
  IF Phisical < Handles^[Handle]^.SizeInPages THEN BEGIN
   ASM
    MOV ax, Phisical   {�஢�ઠ �� �������� 㪠��⥫�, ��᫥���� ��࠭���}
    MOV bx, LastPPage  {� �ࠢ��쭮��� ������� ����� ��࠭���}
    CMP bx,ax
    JNE @do
    MOV bx, Size
    CMP ax,bx
    JG  exitt
    MOV ax, Handle
    MOV bx, LastHandle
    CMP ax,bx
    JNE @do
    JMP exitt
    @do:
   END;
   IF WindowUsing THEN BEGIN {���࠭塞 ���� ��ண� ���ਯ��}
    Seek(SWPFile,LastPPPage); {�᫨ ��� �����﫮��}
    Write(SWPFile,SEMMEWindow^);
   END;
   {�饬 ���浪��� ����� 䨧��᪮� ��࠭��� � 䠩��}
   t:=Handles^[Handle]^.FirstPage; {���浪��� ����� ��࠭���}
   ASM
    MOV ax,Handle
    MOV LastHandle,ax
    XOR ax,ax
    MOV t1,ax  {����� ��࠭��� 㪠��⥫� = 0}
    MOV ax,t
    MOV np,ax
    rept:     {�࣠�����뢠�� �몫 ���� t1<>Phisical}
    MOV ax,np
    MOV t,ax
   END;
    np:=Pages^[t];   {����� ᫥���饩 �����᪮� ��࠭��� � 䠩��}
   ASM
    MOV ax,t1
    INC ax
    MOV t1,ax
    DEC ax
    MOV bx,Phisical
    CMP ax,bx
    JNE rept
    MOV ax,Phisical
    MOV LastPPage,ax
    MOV ax, t
    MOV LastPPPage, ax
   END;
   WindowUsing:=True;
   Seek(SWPFile,t);   {��⠥� �� 䠩�� �㦭�� ��࠭��� � ����頥� �� � ����}
   Read(SWPFile,SEMMEWindow^);
  Exitt:
  END ELSE BEGIN
   {�訡��, ���饭�� �� �।��� �뤥����� ��� �⮣� 㪠��⥫�}
   SEMMEError:=True;
   SEMMECodeError:=6;
  END;
  END ELSE BEGIN
   {�訡��, ⠪�� 㪠��⥫� �� ���c���}
   SEMMEError:=True;
   SEMMECodeError:=4;
  END;
 END;

{=================================}

 PROCEDURE ChangeHandleSize(Handle, NewSize: Word);
 VAR t,t1,lp,np:Word;
 BEGIN
 IF Handles^[Handle] <> NIL THEN BEGIN
  IF (NewSize <= (FreePages+Handles^[Handle]^.SizeInPages)) AND (Handles^[Handle] <> NIL)
   THEN BEGIN IF (NewSize <> Handles^[Handle]^.SizeInPages) THEN BEGIN
   {�����稢��� ��� 㬥��蠥� ����� ����� ����㯭�� ��࠭�� 㪠��⥫�}
   FreePages:=FreePages+Handles^[Handle]^.SizeInPages;
   FreePages:=FreePages-NewSize;
   Handles^[Handle]^.LastUsedPage:=$FFFF; {����砥� ��᫥���� �⠭���, ��� �����}
   IF Handles^[Handle]^.SizeInPages < NewSize THEN BEGIN
   {�饬 ��᫥���� ��࠭���}
   t1:=0; {���稪 ��࠭��}
   t:=Handles^[Handle]^.FirstPage;
   REPEAT
    Inc(t1);
    lp:=t;
    np:=Pages^[t]; {����砥� ����� ᫥���饩 ��࠭���}
    t:=np;
   UNTIL t1>=Handles^[Handle]^.SizeInPages-1;
   {�饬 ���� ᢮����� ��࠭���}
   {lp:=t;   {�த������ � �⮩ ��࠭���}
   t:=0;    {���稪 ��� ��࠭��}
   {���� ᢮������ ��࠭�� ��� ������ 㠧�⥫�}
   REPEAT
    Inc(t);
    IF (Pages^[t]=0) AND (t <> lp) THEN BEGIN
     Inc(t1);
     Pages^[lp]:=t;
     lp:=t;
    END;
   UNTIL t1 = NewSize;
   Pages^[lp]:=$FFFF;
  END ELSE BEGIN
   {�饬 ��᫥���� ��࠭���}
   t1:=0; {���稪 ��࠭��}
   t:=Handles^[Handle]^.FirstPage;
   REPEAT
    Inc(t1);
    np:=Pages^[t]; {����砥� ����� ᫥���饩 ��࠭���}
    IF t1 = NewSize THEN Pages^[t]:=$FFFF; {��᫥���� ��࠭��� ����砥� ��� $FFFF}
    IF t1 > NewSize THEN Pages^[t]:=0;
    t:=np;
   UNTIL t1=Handles^[Handle]^.SizeInPages;
  END;
   Handles^[Handle]^.SizeInPages:=NewSize; {����ᨬ � 㪠��⥫� ���� ��� ࠧ���}
   MapSEMMEPage(Handle,1);
  END; END ELSE BEGIN
   {��墠⠥� ���� � ����� ��� ⠪�� 㪠��⥫� �� �������}
   SEMMEError:=True;
   SEMMECodeError:=4;
  END;
 END ELSE BEGIN
  {�訡��, ⠪�� 㪠��⥫� �� ���c���}
  SEMMEError:=True;
  SEMMECodeError:=4;
 END;
 END;

{=================================}

 PROCEDURE Load(name: String);
 BEGIN
 END;

{=================================}

 PROCEDURE Save(Handle: Word; name: String);
 VAR d:Byte;
     f:File of TPage;
     n: Word;
     pp: PPage;
 BEGIN
  IF (Handles^[Handle] <> NIL) THEN BEGIN
   {��।��塞 ����� ��᪠}
   IF name <> '' THEN BEGIN
    IF name[2] = ':' THEN d:=Ord(UpCase(name[1]))-64 ELSE d:=0;
    IF (DiskFree(d) DIV PageSize + 1) > Handles^[Handle]^.SizeInPages THEN BEGIN
     Assign(f,name); {���뢠�� ��� 䠩�� � �멫���� ��६�����}
     ReWrite(f);     {������� 䠩�}
     FOR n:=1 TO Handles^[Handle]^.SizeInPages DO BEGIN
      MapSEMMEPage(Handle,n); {�����㥬 �㦭�� ��࠭���}
      WindowUsing:=True;      {�⪫�砥� ०�� ��࠭���� �।��饩 ��࠭���}
      Write(f,SEMMEWindow^);  {���࠭塞 �㦭�� ��࠭���}
     END;
    END ELSE BEGIN
     {�訡��, ��墠⠥� ���� �� ��᪥ ��� ᮧ����� 䠩��}
     SEMMEError:=True;
     SEMMECodeError:=1;
    END;
   END ELSE BEGIN
    {�訡��, ���ࠢ��쭮� ��� 䠩��}
    SEMMEError:=True;
    SEMMECodeError:=5;
   END;
  END ELSE BEGIN
   {�訡��, ⠪�� 㪠��⥫� �� �������}
   SEMMEError:=True;
   SEMMECodeError:=4;
  END;
 END;

{============================================================================}
BEGIN
 WindowUsing:=True;
 SWPName:=SWPName+'.swp';
 SEMMEStatus:=False;
 SEMMEError:=False;
 SEMMECodeError:=0;
END.
{============================================================================}