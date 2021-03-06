{$A+,B-,D+,E-,F+,G+,I+,L+,N+,O+,P-,Q+,R+,S+,T-,V-,X+}
{$M 16384,0,655360}
{========================ShAG Virtual Memory Manager=========================}
{====  �������� ����㠫쭮� ����� �⮪��� ������ �����������          ====}
{====                           ����� 1.0                               ====}
{====--------------------------------------------------------------------====}
{====  ����� ࠧ�蠥��� �ᯮ�짮���� ⮫쪮 � ��������᪨� 楫��, �� ====}
{==== �᫮���, �� ��室�� ⥪�� ��� �ணࠬ� ����ᠭ��� � �ᯮ�짮��- ====}
{==== ���� �⮣� ����� ������� �⮪��� ����ᥩ �����������, �� ⠪��   ====}
{==== �� �ࠢ��, ��� � ��� �����, �஬� ����祭�� ����� �ணࠬ�.      ====}
{====--------------------------------------------------------------------====}
{====  ����� ᮧ��� � Turbo Pascal 7.0                                  ====}
{====--------------------------------------------------------------------====}
{====  ����� ����� ������� ��� �࣠����樨 ࠧ����� ���ᨢ�� � �����- ====}
{==== �쭮� �����, ������� ��� ࠡ��� � ����, ���� ����������� �������  ====}
{==== ࠧ��� ������� ���ᨢ�, ��������� �࠭�� ���ᨢ�, � ���ᨢ ����� ====}
{==== ������� ��६���� ᫥����� ⨯��: byte, word, integer, longint, ====}
{==== real, double, char, string.                                        ====}
{====  ������ �ᥩ ����㠫쭮� ����� �� ������ �ॢ���� 4096 ��࠭��,  ====}
{==== �. �. 64 �������� (��࠭�業�� ������ ���ᨨ), ��饥 ������⢮    ====}
{==== ���ᨢ�� �� ������ �ॢ���� 5000 (��࠭�業�� ������ ���ᨨ).     ====}
{====  ������ ���ᨢ� �� ������ �ॢ���� ࠧ��� ����㠫쭮� �����.    ====}
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
{==== � ������  ��ᨢ� �� 18600 �ன��� ᫮� �ந�室�� � 9 ࠧ       ====}
{==== ��������� 祬 � ����;                                              ====}
{====  ���� ᠬ� ������⥫� �⠭������� � 2-3 ࠧ� �����, �. �. 1.5 ,  ====}
{==== 2, 3.5 � 4 ᮮ⢥��⢥��� �� �믮������ ��� �� 80x486 100 ��� � ====}
{==== ���⮬ �� 1.1 �������� � 1 �������⮬ ����⨢��(��⮢�� ��設�). ====}
{============================================================================}
                                   UNIT SVM;
{============================================================================}
                                   INTERFACE
{=========================== ������砥�� ���㫨 ============================}

 USES SEMME, Dos, Crt;

{==================== ��१�ࢨ஢���� ⨯� � ��楤��� =====================}

 PROCEDURE    InitSVM(Size: LongInt; Disk: Char; Name: String);
  {��楤�� ���樠����樨 ����㠫쭮� �����}
  {Size - ࠧ��� ����㠫쭮� ����� � ��࠭��� �� 16 ��������}
  {Disk - �㪢� ��᪠ � ��୥��� ��⠫��� ���ண� �㤥� ᮧ��� ᢮� 䠩�}
  {Name - ��� ᢮� 䠩�� (��� ���७��)}

 CONST {����⮢�� �।�⠢����� �訡��, ����� ����� ��������� � ����� ࠡ���}
       VMErrorMessage: ARRAY [0..7] OF String[75] = (
       '��� �衮�.',
       '�� ��᪥ �������筮 ���� ��� ᮧ����� 䠩�� �����窨 ����㠫쭮� �����.',
       '���誮� ����� 㪠��⥫��.',
       '����㠫쭮� ������ ���ᯮ������ �ॡ㥬� ���ꬮ� �����.',
       '��� ������� ��ꥪ� ������ �� �뤥�﫠��.',
       '�訡�� � ����� 䠩��.',
       '���饭�� �� �।��� ����� �뤥������ ��� ������� ��ꥪ�.',
       '����� �� ���樠����஢��.');

 TYPE OArea = OBJECT  {��ꥪ�, த�⥫� ��� ��⠫��� ��ꥪ⮢}
  Handle: Word;
  Size: LongInt;
  CONSTRUCTOR Init(Sz: LongInt);
  CONSTRUCTOR Load(name: String);
  DESTRUCTOR  Done;
  PROCEDURE   ReSize(Sz: LongInt);
  PROCEDURE   Save(name: String);
  PROCEDURE   WriteVMb(i: Comp; b: Byte);
  FUNCTION    ReadVMb(i: Comp): Byte;
 END;

 TYPE OVector = OBJECT(OArea) {�������� ���ᨢ}
  ElementSize: LongInt;
  CONSTRUCTOR Init(Sz: Comp; ES: LongInt);
  CONSTRUCTOR ReSize(Sz: Comp; ES: LongInt);
  PROCEDURE   PutB(i: Comp; b: Byte);
  PROCEDURE   PutW(i: Comp; w: Word);
  PROCEDURE   PutI(i: Comp; it: Integer);
  PROCEDURE   PutL(i: Comp; l: LongInt);
  PROCEDURE   PutC(i: Comp; c: Comp);
  PROCEDURE   PutR(i: Comp; r: Real);
  PROCEDURE   PutS(i: Comp; s: String);
  FUNCTION    GetB(i: Comp): Byte;
  FUNCTION    GetW(i: Comp): Word;
  FUNCTION    GetI(i: Comp): Integer;
  FUNCTION    GetL(i: Comp): LongInt;
  FUNCTION    GetC(i: Comp): Comp;
  FUNCTION    GetR(i: Comp): Real;
  FUNCTION    GetS(i: Comp): String;
 END;

 TYPE OUserVector = OBJECT(OArea) {�������� ���ᨢ}
  ElementSize: LongInt;
  TotalItem: LongInt;
  CONSTRUCTOR Init(Sz: LongInt; ES: LongInt);
  CONSTRUCTOR ReSize(Sz: LongInt; ES: LongInt);
  PROCEDURE   Put(var element; i: LongInt);
  PROCEDURE   Get(var element; i: LongInt);
 END;

 TYPE OMatrix = OBJECT(OVector) {��㬥�� ���ᨢ}
  SizeX, SizeY: LongInt;
  CONSTRUCTOR Init(SzX, SzY: LongInt; ES: LongInt);
  PROCEDURE   PutB(x, y: LongInt; b: Byte);
  PROCEDURE   PutW(x, y: LongInt; w: Word);
  PROCEDURE   PutI(x, y: LongInt; i: Integer);
  PROCEDURE   PutL(x, y: LongInt; l: LongInt);
  PROCEDURE   PutR(x, y: LongInt; r: Real);
  PROCEDURE   PutS(x, y: LongInt; s: String);
  FUNCTION    GetB(x, y: LongInt): Byte;
  FUNCTION    GetW(x, y: LongInt): Word;
  FUNCTION    GetI(x, y: LongInt): Integer;
  FUNCTION    GetL(x, y: LongInt): LongInt;
  FUNCTION    GetR(x, y: LongInt): Real;
  FUNCTION    GetS(x, y: LongInt): String;
 END;

 {��ꥪ� ��� ࠡ��� � �������� ���ᨢ�� ��ப,
  ������⢮ ��ப � ���ᨢ� �� ��࠭�祭��}
 TYPE OStrings = OBJECT(OVector)
  TotalStrings: LongInt;
  StringSize: Byte;
  CONSTRUCTOR Init(TS: LongInt; SS: Byte);
  PROCEDURE   Add(s: String);
  PROCEDURE   Delete(i: LongInt);
  PROCEDURE   Insert(i: LongInt; s: String);
  PROCEDURE   Put(i: LongInt; s: String);
  FUNCTION    Get(i: LongInt): String;
 END;

 VAR VMErrorProc: PROCEDURE;
     VMInit: Boolean;   {����� ����㠫쭮� �����}
     VMError: Boolean ABSOLUTE SEMMEError;      {����� �訡��}
     VMErrorCode: Byte ABSOLUTE SEMMECodeError; {��� �訡��}
     VMSize,            {��騩 ��ꥬ �����}
     VMFree: LongInt;   {�������� ��ꥬ �����}

{============================================================================}
                               IMPLEMENTATION
{============================================================================}

  PROCEDURE    TempErrorProc;
  BEGIN
  {��楤�� ��뢠���� ����� ࠧ ����� ��������� �訡��, ��ࢮ��砫쭮 ���
   ��祣� ��������, �� ��  ������� �� ����� ��८�।�����}
  END;

  PROCEDURE    InitSVM(Size: LongInt; Disk: Char; Name: String);
  BEGIN
   IF @VMErrorProc = NIL THEN @VMErrorProc:=@TempErrorProc;
   SWPName:='';
   SWPName:=Name+'.swp';
   GotoXY(1,WhereY);
{   WriteLn('------ Virtual Memory Manager ------');
   WriteLn(' Copyright (c) 1999 ShAG Studio');
   Write(' Testing RAM configuration... ');
   WriteLn('EMS not found');
   Write(' Initilise, please wait... ');}
   InitSEMME(Size,Disk);
   IF VMErrorCode > 0 THEN BEGIN
{    WriteLn('ERROR');
    WriteLn(' Memory size: ',0,' Kb');}
    VMErrorProc;
    Exit;
   END;
{   WriteLn('OK');
   WriteLn(' Memory size: ',Size*16,' Kb');}
   VMSize:=Size*PageSize;
   VMFree:=VMSize;
   VMInit:=True;
   VMError:=False;
   VMErrorCode:=0;
  END;

  CONSTRUCTOR OArea.Init(Sz: LongInt);
  BEGIN
   IF ((Sz+PageSize-1) SHR PageSH <= FreePages) THEN BEGIN
    Handle:=NewHandle((Sz+PageSize-1) SHR 14);
    IF VMError THEN BEGIN
     Handle:=0;
     VMErrorProc;
    END;
    END;
  END;

  PROCEDURE   OArea.ReSize(sz: LongInt);
  BEGIN
   IF Sz < (TotalPages-Handles^[Handle]^.SizeInPages*PageSize)*PageSize THEN BEGIN
    Size:=Sz;
    ChangeHandleSize(Handle,(Sz+PageSize-1) SHR PageSH);
    IF VMError THEN BEGIN
     VMErrorProc;
     Exit;
    END;
   END;
  END;

  CONSTRUCTOR OArea.Load(name: String);
  BEGIN
  END;

  DESTRUCTOR  OArea.Done;
  BEGIN
   DisposeHandle(Handle);
   Handle:=0;
  END;

  PROCEDURE   OArea.Save(name: String);
  BEGIN
  END;

  PROCEDURE   OArea.WriteVMb(i: Comp; b: Byte);
  VAR p: Word;
      il: LongInt ABSOLUTE i;
  BEGIN
   IF Handle = 0 THEN Exit;
   p:=il SHR PageSH;
   MapSEMMEPage(Handle, p);
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
   SEMMEWindow^[il - (p SHL PageSH) + 1]:=b;
  END;

  FUNCTION    OArea.ReadVMb(i: Comp): Byte;
  VAR p: Word;
      il: LongInt ABSOLUTE i;
  BEGIN
   IF Handle = 0 THEN Exit;
   p:=il SHR PageSH;
   MapSEMMEPage(Handle, p);
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
   ReadVMb:=SEMMEWindow^[il - (p SHL PageSH) + 1];
  END;

  CONSTRUCTOR OVector.Init(Sz: Comp; ES: LongInt);
  VAR szl: LongInt ABSOLUTE sz;
  BEGIN
   ElementSize:=ES;
   IF ((Szl*ElementSize+PageSize-1) SHR PageSH <= FreePages) THEN BEGIN
    ElementSize:=ES;
    Size:=Szl;
    Handle:=NewHandle((Szl*ElementSize+PageSize-1) SHR PageSH);
    IF VMError THEN BEGIN
     Handle:=0;
     VMErrorProc;
     Exit;
    END;
   END;
  END;

  CONSTRUCTOR OVector.ReSize(Sz: Comp; ES: LongInt);
  VAR szl: LongInt ABSOLUTE Sz;
  BEGIN
   IF Handle = 0 THEN Exit;
   ChangeHandleSize(Handle,(Szl*ES DIV 16384) + 1);
   ElementSize:=ES;
   Size:=Szl;
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
  END;

  PROCEDURE   OVector.PutB(i: Comp; b: Byte);
  BEGIN
   WriteVMb(i*ElementSize,b);
  END;

  PROCEDURE   OVector.PutW(i: Comp; w: Word);
  VAR b: ARRAY [0..1] OF Byte ABSOLUTE w;
  BEGIN
   WriteVMb(i*ElementSize,b[0]);
   WriteVMb(i*ElementSize+1,b[1]);
  END;

  PROCEDURE   OVector.PutI(i: Comp; it: Integer);
  VAR w: Word ABSOLUTE it;
  BEGIN
   PutW(i,w);
  END;

  PROCEDURE   OVector.PutL(i: Comp; l: LongInt);
  VAR l1: LongInt;
      b: ARRAY [0..3] OF Byte ABSOLUTE l1;
  BEGIN
   l1:=l;
   WriteVMb(i*ElementSize,b[0]);
   WriteVMb(i*ElementSize+1,b[1]);
   WriteVMb(i*ElementSize+2,b[2]);
   WriteVMb(i*ElementSize+3,b[3]);
  END;

  PROCEDURE   OVector.PutC(i: Comp; c: Comp);
  VAR l1: Comp;
      b: ARRAY [0..7] OF Byte ABSOLUTE l1;
  BEGIN
   l1:=c;
   WriteVMb(i*ElementSize,b[0]);
   WriteVMb(i*ElementSize+1,b[1]);
   WriteVMb(i*ElementSize+2,b[2]);
   WriteVMb(i*ElementSize+3,b[3]);
   WriteVMb(i*ElementSize+4,b[4]);
   WriteVMb(i*ElementSize+5,b[5]);
   WriteVMb(i*ElementSize+6,b[6]);
   WriteVMb(i*ElementSize+7,b[7]);
  END;

  PROCEDURE   OVector.PutR(i: Comp; r: Real);
  VAR r1: Real;
      b: ARRAY [0..5] OF Byte ABSOLUTE r1;
  BEGIN
   r1:=r;
   WriteVMb(i*ElementSize,b[0]);
   WriteVMb(i*ElementSize+1,b[1]);
   WriteVMb(i*ElementSize+2,b[2]);
   WriteVMb(i*ElementSize+3,b[3]);
   WriteVMb(i*ElementSize+4,b[4]);
   WriteVMb(i*ElementSize+5,b[5]);
  END;

  PROCEDURE   OVector.PutS(i: Comp; s: String);
  VAR n: Byte;
      ii: Comp;
      a: ARRAY [0..1] OF Byte ABSOLUTE s;
  BEGIN
   ii:=i*ElementSize;
   FOR n:=0 TO Length(s) DO WriteVMb(ii+n,a[n]);
  END;

  FUNCTION    OVector.GetB(i: Comp): Byte;
  BEGIN
   GetB:=ReadVMb(i*ElementSize);
  END;

  FUNCTION    OVector.GetW(i: Comp): Word;
  VAR w: word;
      b: ARRAY [0..1] OF Byte ABSOLUTE w;
  BEGIN
   b[0]:=ReadVMb(i*ElementSize);
   b[1]:=ReadVMb(i*ElementSize+1);
   GetW:=w;
  END;

  FUNCTION    OVector.GetI(i: Comp): Integer;
  VAR w: Word;
      it: Integer ABSOLUTE w;
  BEGIN
   w:=GetW(i);
   GetI:=it;
  END;

  FUNCTION    OVector.GetL(i: Comp): LongInt;
  VAR l: LongInt;
      b: ARRAY [0..3] OF Byte ABSOLUTE l;
  BEGIN
   b[0]:=ReadVMb(i*ElementSize);
   b[1]:=ReadVMb(i*ElementSize+1);
   b[2]:=ReadVMb(i*ElementSize+2);
   b[3]:=ReadVMb(i*ElementSize+3);
   GetL:=l;
  END;

  FUNCTION    OVector.GetC(i: Comp): Comp;
  VAR l: Comp;
      b: ARRAY [0..7] OF Byte ABSOLUTE l;
  BEGIN
   b[0]:=ReadVMb(i*ElementSize);
   b[1]:=ReadVMb(i*ElementSize+1);
   b[2]:=ReadVMb(i*ElementSize+2);
   b[3]:=ReadVMb(i*ElementSize+3);
   b[4]:=ReadVMb(i*ElementSize+4);
   b[5]:=ReadVMb(i*ElementSize+5);
   b[6]:=ReadVMb(i*ElementSize+6);
   b[7]:=ReadVMb(i*ElementSize+7);
   GetC:=l;
  END;

  FUNCTION    OVector.GetR(i: Comp): Real;
  VAR r: Real;
      b: ARRAY [0..5] OF Byte ABSOLUTE r;
  BEGIN
   b[0]:=ReadVMb(i*ElementSize);
   b[1]:=ReadVMb(i*ElementSize+1);
   b[2]:=ReadVMb(i*ElementSize+2);
   b[3]:=ReadVMb(i*ElementSize+3);
   b[4]:=ReadVMb(i*ElementSize+4);
   b[5]:=ReadVMb(i*ElementSize+5);
   GetR:=r;
  END;

  FUNCTION    OVector.GetS(i: Comp): String;
  VAR n: Byte;
      s: String;
      ii: Comp;
      a: array [0..1] OF Byte ABSOLUTE s;
      b: Byte ABSOLUTE s;
  BEGIN
   ii:=i*ElementSize;
   b:=ReadVMb(ii); {����砥� ������ ��ப�}
   FOR n:=1 TO b DO a[n]:=ReadVMb(ii+n);
   GetS:=s;
  END;

  CONSTRUCTOR OUserVector.Init(Sz: LongInt; ES: LongInt);
  BEGIN
   IF ((Sz*ElementSize+PageSize-1) SHR PageSH <= FreePages) THEN BEGIN
    ElementSize:=ES;
    Size:=Sz;
    TotalItem:=Size;
    Handle:=NewHandle((Sz*ElementSize+PageSize-1) SHR PageSH);
    IF VMError THEN BEGIN
     Handle:=0;
     VMErrorProc;
     Exit;
    END;
   END;
  END;

  CONSTRUCTOR OUserVector.ReSize(Sz: LongInt; ES: LongInt);
  BEGIN
   TotalItem:=Sz;
   IF Sz < (TotalPages-Handles^[Handle]^.SizeInPages*PageSize)*PageSize THEN BEGIN
    Size:=Sz;
    TotalItem:=Sz;
    ChangeHandleSize(Handle,(Sz+PageSize-1) SHR PageSH);
    IF VMError THEN BEGIN
     VMErrorProc;
     Exit;
    END;
   END;
  END;

  PROCEDURE   OUserVector.Put(var element; i: LongInt);
  VAR  b: ARRAY [0..1] OF Byte ABSOLUTE element;
       n: LongInt;
  BEGIN
   FOR n:=1 TO ElementSize DO OArea.WriteVMb((i-1)*ElementSize+n-1,b[n-1]);
  END;

  PROCEDURE   OUserVector.Get(var element; i: LongInt);
  VAR  b: ARRAY [0..1] OF Byte ABSOLUTE element;
       n: LongInt;
  BEGIN
   FOR n:=1 TO ElementSize DO b[n-1]:=OArea.ReadVMb((i-1)*ElementSize+n-1);
  END;

  CONSTRUCTOR OMatrix.Init(SzX, SzY: LongInt; ES: LongInt);
  BEGIN
   SizeX:=SzX;
   SizeY:=SzY;
   OVector.Init(SzX*SzY,ES);
  END;

  PROCEDURE   OMatrix.PutB(x, y: LongInt; b: Byte);
  BEGIN
   OVector.PutB(y*SizeX+x,b);
  END;

  PROCEDURE   OMatrix.PutW(x, y: LongInt; w: Word);
  VAR t: LongInt;
  BEGIN
   OVector.PutW(y*SizeX+x,w);
  END;

  PROCEDURE   OMatrix.PutI(x, y: LongInt; i: Integer);
  BEGIN
   OVector.PutI(y*SizeX+x,i);
  END;

  PROCEDURE   OMatrix.PutL(x, y: LongInt; l: LongInt);
  BEGIN
   OVector.PutL(y*SizeX+x,l);
  END;

  PROCEDURE   OMatrix.PutR(x, y: LongInt; r: Real);
  BEGIN
   OVector.PutR(y*SizeX+x,r);
  END;

  PROCEDURE   OMatrix.PutS(x, y: LongInt; s: String);
  BEGIN
   OVector.PutS(y*SizeX+x,s);
  END;

  FUNCTION    OMatrix.GetB(x, y: LongInt): Byte;
  BEGIN
   GetB:=OVector.GetB(y*SizeX+x);
  END;

  FUNCTION    OMatrix.GetW(x, y: LongInt): Word;
  var t:LongInt;
  BEGIN
   GetW:=OVector.GetW(y*SizeX+x);
  END;

  FUNCTION    OMatrix.GetI(x, y: LongInt): Integer;
  BEGIN
   GetI:=OVector.GetI(y*SizeX+x);
  END;

  FUNCTION    OMatrix.GetL(x, y: LongInt): LongInt;
  BEGIN
   GetL:=OVector.GetL(y*SizeX+x);
  END;

  FUNCTION    OMatrix.GetR(x, y: LongInt): Real;
  BEGIN
   GetR:=OVector.GetR(y*SizeX+x);
  END;

  FUNCTION    OMatrix.GetS(x, y: LongInt): String;
  BEGIN
   GetS:=OVector.GetS(y*SizeX+x);
  END;

  CONSTRUCTOR OStrings.Init(TS: LongInt; SS: Byte);
  VAR n: LongInt;
  BEGIN
   TotalStrings:=TS;
   StringSize:=SS;
   OVector.Init(TS,SS+1);
   FOR n:=0 TO TotalStrings-1 DO Put(n,'');
  END;

  PROCEDURE   OStrings.Add(s: String);
  BEGIN
   OVector.ReSize(TotalStrings+1,StringSize+1);
   Put(TotalStrings,s);
   Inc(TotalStrings);
  END;

  PROCEDURE   OStrings.Delete(i: LongInt);
  VAR n: LongInt;
  BEGIN
   FOR n:=i TO TotalStrings-1 DO Put(n,Get(n+1));
   Dec(TotalStrings);
   OVector.ReSize(TotalStrings,StringSize+1);
  END;

  PROCEDURE   OStrings.Insert(i: LongInt; s: String);
  VAR n: LongInt;
      k: Byte;
  BEGIN
   k:=0;
   IF i = 0 THEN k:=1;
   FOR n:=TotalStrings DOWNTO i+k DO Put(n,get(n-1));
   Put(i,s);
   Inc(TotalStrings);
  END;

  PROCEDURE   OStrings.Put(i: LongInt; s: String);
  BEGIN
   OVector.PutS(i,s);
  END;

  FUNCTION    OStrings.Get(i: LongInt): String;
  BEGIN
   Get:=OVector.GetS(i);
  END;

{============================================================================}
BEGIN
 VMInit:=False;
 VMError:=True;
 VMErrorCode:=7;
 @VMErrorProc:=NIL;
END.
{============================================================================}