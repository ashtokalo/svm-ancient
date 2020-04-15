{$A+,B+,D-,E-,F+,G+,I-,L-,N+,O+,P+,Q-,R-,S-,T+,V+,X+}
{$M 16384,0,655360}
{========================ShAG Virtual Memory Manager=========================}
{====  Менеджер виртуальной памяти Штокало Алексея Геннадиевича          ====}
{====                           Версия 1.0                               ====}
{====--------------------------------------------------------------------====}
{====  Модуль разрешается использовать только в некомерческих целях, при ====}
{==== условии, что исходный текст всех программ написанных с использова- ====}
{==== нием этого модуля получить Штокало Алексей Геннадиевич, на таких   ====}
{==== же правах, как и этот модуль, кроме получения копий программ.      ====}
{====--------------------------------------------------------------------====}
{====  Модуль создан в Turbo Pascal 7.0                                  ====}
{====--------------------------------------------------------------------====}
{====  Модуль имеет команды для организации различных массивов в виртуа- ====}
{==== льной памяти, команды для работы с ними, есть возможность задания  ====}
{==== размера элемента массива, изменения границ массива, в массив можно ====}
{==== заносить переменные следующих типов: byte, word, integer, longint, ====}
{==== real, double, char, string.                                        ====}
{====  Размер всей виртуальной памяти не должен превышать 4096 страниц,  ====}
{==== т. е. 64 мегабайт (ограницение данной версии), общее количество    ====}
{==== массивов не должно превышать 5000 (ограницение данной версии).     ====}
{====  Размер массива не должен превышать размера виртуальной памяти.    ====}
{====--------------------------------------------------------------------====}
{====  Примечание. Тест на производительность на 80x286 12 мегагерц плюс ====}
{==== сопроцессор на 6 мегагерц, плюс 1 мегабайт оперативки и винт на 80 ====}
{==== мегабайт, показал при работе с виртуалной памятью, что:            ====}
{==== ■ адресация  масива  из 112000 байт  происходит в 3 раза медленней ====}
{==== чем в кучу;                                                        ====}
{==== ■ адресация масива из 56000 слов происходит в 4 раза медленнее чем ====}
{==== в кучу;                                                            ====}
{==== ■ адресация масива из 28000 двойных слов происходит в 7.5 раз мед- ====}
{==== ленней чем в кучу;                                                 ====}
{==== ■ адресация  масива из 18600 тройных слов происходит в 9 раз       ====}
{==== медленней чем в кучу;                                              ====}
{====  Теже самые показатели становяться в 2-3 раза меньше, т. е. 1.5 ,  ====}
{==== 2, 3.5 и 4 соответственно при выполнении теста на 80x486 100 мГц с ====}
{==== винтом на 1.1 гигабайт и 1 мегабайтом оперативки(тестовая машина). ====}
{============================================================================}
                                   UNIT SVM_n;
{============================================================================}
                                   INTERFACE
{=========================== Подключаемые модули ============================}

 USES SEMME_e, Dos, Crt;

{==================== Зарезервированные типы и прцедуры =====================}

 PROCEDURE    InitSVM(DM, UpM, Mw: LongInt; Disk: Char; Name: String);
  {Процедура инициализации виртуальной памяти}
  {Disk - буква диска в корневом каталоге которого будет создан своп файл}
  {Name - имя своп файла (без расширения)}

 CONST {Текстовое представление ошибок, которые могут возникнут в процессе работы}
       VMErrorMessage: ARRAY [0..7] OF String[75] = (
       'Нет ошбок.',
       'На диске недостаточно места для создания файла подкачки виртуальной памяти.',
       'Слишком много указателей.',
       'Виртуальной память нераспологает требуемым обеъмом памяти.',
       'Для данного объекта память не выделялась.',
       'Ошибка в имени файла.',
       'Обращение за пределы памяти выделенной для данного объекта.',
       'Модуль не инициализирован.');

 TYPE OArea = OBJECT  {Объект, родитель всех остальных объектов}
  Handle: Word;
  CurWin: Word;
  Size: Comp;
  CONSTRUCTOR Init(Sz: Comp);
  CONSTRUCTOR Load(name: String);
  DESTRUCTOR  Done;
  PROCEDURE   ReSize(Sz: Comp);
  PROCEDURE   Save(name: String);
  PROCEDURE   WriteVMb(i: Comp; b: Byte);
  FUNCTION    ReadVMb(i: Comp): Byte;
 END;

 TYPE OVector = OBJECT(OArea) {Одномерный массив}
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

 TYPE OUserVector = OBJECT(OArea) {Одномерный массив}
  ElementSize: LongInt;
  TotalItem: LongInt;
  CONSTRUCTOR Init(Sz: LongInt; ES: LongInt);
  CONSTRUCTOR ReSize(Sz: LongInt; ES: LongInt);
  PROCEDURE   Put(var element; i: LongInt);
  PROCEDURE   Get(var element; i: LongInt);
 END;

 TYPE OMatrix = OBJECT(OVector) {Двумерный массив}
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

 {Объект для работы с одномерным массивом строк,
  количество строк в массиве не ограниченно}
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
     VMInit: Boolean;   {Статус виртуальной памяти}
     VMError: Boolean ABSOLUTE SEMMEError;      {Статус ошибки}
     VMErrorCode: Byte ABSOLUTE SEMMECodeError; {Код ошибки}
     VMSize,            {Общий объем памяти}
     VMFree: LongInt;   {Свободный объем памяти}

{============================================================================}
                               IMPLEMENTATION
{============================================================================}

  PROCEDURE    TempErrorProc;
  BEGIN
  {Процедура вызывается каждый раз когда возникает ошибка, первоночально она
   ничего неделает, но при  желании её можно переопределить}
   GotoXY(1,WhereY);
   WriteLn('Ошибка при работе с виртуальной памятью.');
   repeat
   until keypressed;
   if ReadKey = Chr(0) then ReadKey;
  END;

 PROCEDURE    InitSVM(DM, UpM, Mw: LongInt; Disk: Char; Name: String);
  BEGIN
   IF @VMErrorProc = NIL THEN @VMErrorProc:=@TempErrorProc;
   SWP_Disk:=Disk;
   SWP_FileName:='';
   SWP_FileName:=Name;
   Up_Margin:=UpM div PageSize;
   Down_Margin:=DM div PageSize;
   Max_Windows:=Mw;
   InitVM;
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
  END;

  CONSTRUCTOR OArea.Init(Sz: Comp);
  BEGIN
   CurWin:=MinFreq;
   Size:=Sz;
   Handle:=NewHandle(Trunc((Sz+PageSize-1)/PageSize));
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
   WinInfo[CurWin].freq:=1;
  END;

  PROCEDURE   OArea.ReSize(sz: Comp);
  BEGIN
   Size:=Sz;
   ReSizeHandle(Handle,Trunc((Sz+PageSize-1)/PageSize));
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
  END;

  CONSTRUCTOR OArea.Load(name: String);
  BEGIN
  END;

  DESTRUCTOR  OArea.Done;
  BEGIN
   DisposeHandle(Handle);
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
   Handle:=0;
  END;

  PROCEDURE   OArea.Save(name: String);
  BEGIN
  END;

  PROCEDURE   OArea.WriteVMb(i: Comp; b: Byte);
  VAR p: Word;
      il: LongInt ABSOLUTE i;
  BEGIN
   p:=il shr PageSH;
   LoadPage(Handle, CurWin, p);
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
   Windows[CurWin]^[il - (p SHL PageSH) + 1]:=b;
  END;

  FUNCTION    OArea.ReadVMb(i: Comp): Byte;
  VAR p: Word;
      il: LongInt ABSOLUTE i;
  BEGIN
   p:=il SHR PageSH;
   LoadPage(Handle, CurWin, p);
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
   ReadVMb:=Windows[CurWin]^[il - (p SHL PageSH) + 1];
  END;

  CONSTRUCTOR OVector.Init(Sz: Comp; ES: LongInt);
  BEGIN
   ElementSize:=ES;
   Size:=Sz;
   CurWin:=MinFreq;
   Handle:=NewHandle(Trunc((Sz*ES+PageSize-1)/PageSize));
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
   WinInfo[CurWin].freq:=1;
  END;

  CONSTRUCTOR OVector.ReSize(Sz: Comp; ES: LongInt);
  BEGIN
   ElementSize:=ES;
   Size:=Sz;
   ReSizeHandle(Handle,Trunc((Sz*ES+PageSize-1)/PageSize));
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
   i:=i*ElementSize;
   WriteVMb(i,b[0]);
   WriteVMb(i+1,b[1]);
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
   i:=i*ElementSize;
   WriteVMb(i,b[0]);
   WriteVMb(i+1,b[1]);
   WriteVMb(i+2,b[2]);
   WriteVMb(i+3,b[3]);
  END;

  PROCEDURE   OVector.PutC(i: Comp; c: Comp);
  VAR l1: Comp;
      b: ARRAY [0..7] OF Byte ABSOLUTE l1;
  BEGIN
   l1:=c;
   i:=i*ElementSize;
   WriteVMb(i,b[0]);
   WriteVMb(i+1,b[1]);
   WriteVMb(i+2,b[2]);
   WriteVMb(i+3,b[3]);
   WriteVMb(i+4,b[4]);
   WriteVMb(i+5,b[5]);
   WriteVMb(i+6,b[6]);
   WriteVMb(i+7,b[7]);
  END;

  PROCEDURE   OVector.PutR(i: Comp; r: Real);
  VAR r1: Real;
      b: ARRAY [0..5] OF Byte ABSOLUTE r1;
  BEGIN
   r1:=r;
   i:=i*ElementSize;
   WriteVMb(i,b[0]);
   WriteVMb(i+1,b[1]);
   WriteVMb(i+2,b[2]);
   WriteVMb(i+3,b[3]);
   WriteVMb(i+4,b[4]);
   WriteVMb(i+5,b[5]);
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
   i:=i*ElementSize;
   b[0]:=ReadVMb(i);
   b[1]:=ReadVMb(i+1);
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
   i:=i*ElementSize;
   b[0]:=ReadVMb(i);
   b[1]:=ReadVMb(i+1);
   b[2]:=ReadVMb(i+2);
   b[3]:=ReadVMb(i+3);
   GetL:=l;
  END;

  FUNCTION    OVector.GetC(i: Comp): Comp;
  VAR l: Comp;
      b: ARRAY [0..7] OF Byte ABSOLUTE l;
  BEGIN
   i:=i*ElementSize;
   b[0]:=ReadVMb(i);
   b[1]:=ReadVMb(i+1);
   b[2]:=ReadVMb(i+2);
   b[3]:=ReadVMb(i+3);
   b[4]:=ReadVMb(i+4);
   b[5]:=ReadVMb(i+5);
   b[6]:=ReadVMb(i+6);
   b[7]:=ReadVMb(i+7);
   GetC:=l;
  END;

  FUNCTION    OVector.GetR(i: Comp): Real;
  VAR r: Real;
      b: ARRAY [0..5] OF Byte ABSOLUTE r;
  BEGIN
   i:=i*ElementSize;
   b[0]:=ReadVMb(i);
   b[1]:=ReadVMb(i+1);
   b[2]:=ReadVMb(i+2);
   b[3]:=ReadVMb(i+3);
   b[4]:=ReadVMb(i+4);
   b[5]:=ReadVMb(i+5);
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
   b:=ReadVMb(ii); {Получаем длинну строки}
   FOR n:=1 TO b DO a[n]:=ReadVMb(ii+n);
   GetS:=s;
  END;

  CONSTRUCTOR OUserVector.Init(Sz: LongInt; ES: LongInt);
  BEGIN
{   IF ((Sz*ElementSize+PageSize-1) SHR PageSH <= FreePages) THEN BEGIN
    ElementSize:=ES;
    Size:=Sz;
    TotalItem:=Size;
    Handle:=NewHandle((Sz*ElementSize+PageSize-1) SHR PageSH);
    IF VMError THEN BEGIN
     Handle:=0;
     VMErrorProc;
     Exit;
    END;
   END;}
  END;

  CONSTRUCTOR OUserVector.ReSize(Sz: LongInt; ES: LongInt);
  BEGIN
{   TotalItem:=Sz;
   IF Sz < (TotalPages-Handles^[Handle]^.SizeInPages*PageSize)*PageSize THEN BEGIN
    Size:=Sz;
    TotalItem:=Sz;
    ChangeHandleSize(Handle,(Sz+PageSize-1) SHR PageSH);
    IF VMError THEN BEGIN
     VMErrorProc;
     Exit;
    END;
   END; }
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
   OVector.Init(TS,{SS+1}256);
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
   OVector.ReSize(TotalStrings,{StringSize+1}256);
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
  VAR p: Word;
      il: LongInt ABSOLUTE i;
  BEGIN
   i:=i*256;
   p:=il shr PageSH;
   LoadPage(Handle, CurWin, p);
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
   Move(s,Windows[CurWin]^[il - (p SHL PageSH) + 1],256);
  END;

  FUNCTION    OStrings.Get(i: LongInt): String;
  VAR p: Word;
      il: LongInt ABSOLUTE i;
      s: String;
  BEGIN
   i:=i*256;
   p:=il shr PageSH;
   LoadPage(Handle, CurWin, p);
   IF VMError THEN BEGIN
    VMErrorProc;
    Exit;
   END;
   Move(Windows[CurWin]^[il - (p SHL PageSH) + 1],s,256);
   Get:=s;
  END;

{============================================================================}
BEGIN
 VMInit:=True;
 VMError:=False;
 VMErrorCode:=0;
 @VMErrorProc:=NIL;
END.
{============================================================================}