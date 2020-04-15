{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
{=============================ShAG EMM Emulator==============================}
{====         Эмулятор EMM драйвера Штокало Алексея Геннадиевича         ====}
{====                           Версия 1.0                               ====}
{====--------------------------------------------------------------------====}
{====  Модуль разрешается использовать только в некомерческих целях, при ====}
{==== условии, что исходный текст всех программ написанных с использова- ====}
{==== нием этого модуля получить Штокало Алексей Геннадиевич, на таких   ====}
{==== же правах, как и этот модуль, кроме получения копий программ.      ====}
{====--------------------------------------------------------------------====}
{====  Модуль создан в Turbo Pascal 5.1                                  ====}
{====--------------------------------------------------------------------====}
{====  Модуль имеет такие же команды как драйвер EMM, поэтому используя  ====}
{==== эти команды, вместо команд EMM, можно так же работать с памятью,   ====}
{==== даже если её мало или вовсе нет, модуль содает на диске своп файл  ====}
{==== нужного размера, а команды используют его как память.              ====}
{====  Конечно скорость при работе с такой памятью будет ниже, но все же ====}
{==== лучше N мегабайт и тормоза,чем 1 мегабайт и полный стоп.           ====}
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
{==== ■ адресация  масива из 18600 шестибайтовых слов происходит в 9 раз ====}
{==== медленней чем в кучу;                                              ====}
{============================================================================}
                                 UNIT SEMME;
{============================================================================}
                                  INTERFACE
{============================================================================}
 USES Dos,Crt;

 CONST PageSize = 16384; {Размер страницы в байтах}
       MaxPages = 4096;  {Максимальное количество страниц которые можно использовать}
       MaxHandle = 5000; {Максимальное количество указателей}
       PageSH   = 14;
 TYPE TPage = ARRAY [1..PageSize] OF Byte; {Тип страницы}

 TYPE TPages = ARRAY [0..MaxPages] OF Word; {Тип хранящий информацию о связи страниц}

 TYPE THandle = RECORD {Тип хранящий информацию о конкретном указателе}
  FirstPage: Word;      {Физический номер первой страници в файле}
  LastUsedPage: Word;   {Логический номер страници, которая использовалась полседней}
  SizeInPages: Word;    {Количество страниц выделиных для этого указателя}
 END;

 TYPE PHandle = ^THandle;

 TYPE THandles = ARRAY [1..MaxHandle] OF PHandle; {Список информации обо всех указателях}

 TYPE PHandles = ^THandles;

 TYPE PPage = ^TPage;

 TYPE PPages = ^TPages;

 VAR  SEMMEStatus, SEMMEError: Boolean;    {Признак ошибки}
      SEMMECodeError: Byte;   {Код ошибки}
      Pages: PPages;          {Информация о взаимосвязи страниц}
      SEMMEWindow: PPage;     {Окно}
      WindowUsing: Boolean;
      LastHandle, TotalHandle, LastPPage, LastPPPage: Word; {Последний используемый указатель,
       общее количество указателей, последняя используемая физическая страница}
      Handles: PHandles;      {Список указателей}
      TotalPages: Word;       {Общее количество страниц}
      WindowSeg, WindowOfs: Word;  {Сегмент и смещение окна}
      FreePages: Word;        {Свободное количество страниц}
      SWPFile: File Of TPage; {Файл своп}
      SWPName: String;       {Имя этого файла}
      SWPDisk: Char;          {Диск на котором буде создан своп}

 PROCEDURE InitSEMME(Size: Word; Disk:Char);  {Инициализирует модуль, устанавливается
                 размер памяти которую надо эмулировать,и диск для своп файла}

 PROCEDURE DoneSEMME;                   {Деинициализирует модуль, и удаляет своп файл}

 FUNCTION  NewHandle(Size: Word): Word; {Создает новый указатель и выделяет для
                            него требуемый объем памяти, если таковой имеется}

 PROCEDURE DisposeHandle(Index: Word);  {Уничтожает указаетль и особождает связанную с ним память}

 PROCEDURE MapSEMMEPage(Handle, Phisical: Word); {Картирует физическую страницу
     указателя в окно, при этом сохраняет страницу прежде находившуюся в окне}

 PROCEDURE ChangeHandleSize(Handle, NewSize: Word); {Меняет количество страниц
                                       связанных с данным указателем}
 PROCEDURE Load(name: String);          {Создает новый указатель и загружает в
                                         него информацию из файла}
 PROCEDURE Save(Handle: Word; name: String); {Сохраняет информацию хранящююся
                                         в указателе в файл на диск}
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
    {Ошибка, невозможно создать файл}
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
   {Нет ошибок}
   SEMMEError:=False;
   SEMMECodeError:=0;
  END ELSE BEGIN
   {Ошибка, на диске недостаточно места}
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
   {Ищем свободный указатель}
   t:=0;
   REPEAT
    Inc(t);
   UNTIL (Handles^[t]=NIL) OR (t=MaxHandle);
   IF t < MaxHandle THEN BEGIN
    th:=t;
    Inc(TotalHandle);
    New(Handles^[TH]);
    {Составляем карту доступных страниц для нового указателя}
    t:=0;
    {Поиск первой свободной страницы}
    REPEAT
     Inc(t);
    UNTIL (Pages^[t-1]=0) OR (t-1 = MaxPages);
    Handles^[TH]^.FirstPage:=t-1; {Первая страница нового указателя}
    Handles^[TH]^.SizeInPages:=Size; {Заносим в указатель на его размер}
    Handles^[TH]^.LastUsedPage:=$FFFF; {Помечаем последнюю станицу, как конец}
    t1:=1;   {Счетчик найденных страниц}
    t:=0;    {Счетчик всех страниц}
    lp:=Handles^[TH]^.FirstPage;
    {Поиск свободных страниц для нового уазателя}
    REPEAT
     Inc(t);
     IF (Pages^[t-1]=0) AND (t-1 <> lp) THEN BEGIN
      Inc(t1);
      Pages^[lp]:=t-1;
      lp:=t-1;
      END;
    UNTIL t1=Size;
    Pages^[lp]:=$FFFF; {Последнюю страницу помечаем как $FFFF}
    NewHandle:=TH;
   END ELSE BEGIN
   {Ошибка, нет свободных указателей}
   SEMMEError:=True;
   SEMMECodeError:=2;
   NewHandle:=0;
   END;
  END ELSE BEGIN
   {Ошибка, нет места}
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
  {Уменьшаем общее число указателей на 1}
  Dec(TotalHandle);
  {Стираем карту занятых страницы этого уазателя, начиная с его первой}
  t1:=0; {Счетчик стертых страниц}
  t:=Handles^[Index]^.FirstPage;
  REPEAT
   Inc(t1);
   np:=Pages^[t]; {Получаем номер следующей страницы}
   Pages^[t]:=0; {Обнуляем страницу}
   t:=np;
  UNTIL t1=Handles^[Index]^.SizeInPages;
  {Увиличиваем количество свободныхстраниц на все страници бывшего указателя}
   FreePages:=FreePages+Handles^[Index]^.SizeInPages;
  {Освобождаем память от информации о указателе}
   Dispose(Handles^[Index]);
  {Помечаем его как пустой указатель}
   Handles^[Index]:=NIL;
  END ELSE BEGIN
   {Ошибка, такой указатель не сущеcтвует}
   SEMMEError:=True;
   SEMMECodeError:=4;
  END;
 END;

{=================================}

 PROCEDURE MapSEMMEPage(Handle, Phisical: Word);
 VAR t,t1,np,t2:Word;
     Size: Word;
 LABEL exitt,rept;
 BEGIN                 {Для максимального ускорения процедура писалась в
                        основном на ассемблере}
 IF Handles^[Handle] <> NIL THEN BEGIN
    Size:=Handles^[Handle]^.SizeInPages;
  IF Phisical < Handles^[Handle]^.SizeInPages THEN BEGIN
   ASM
    MOV ax, Phisical   {Проверка на изменеие указателя, последней страницы}
    MOV bx, LastPPage  {и правельность задания номера страниуы}
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
   IF WindowUsing THEN BEGIN {Сохраняем окно старого дескриптора}
    Seek(SWPFile,LastPPPage); {если оно изменялось}
    Write(SWPFile,SEMMEWindow^);
   END;
   {Ищем порядковый номер физической страницы в файле}
   t:=Handles^[Handle]^.FirstPage; {Порядковый номер страницы}
   ASM
    MOV ax,Handle
    MOV LastHandle,ax
    XOR ax,ax
    MOV t1,ax  {Номер страницы указателя = 0}
    MOV ax,t
    MOV np,ax
    rept:     {Организовываем цыкл пока t1<>Phisical}
    MOV ax,np
    MOV t,ax
   END;
    np:=Pages^[t];   {Номер следующей логической страницы в файле}
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
   Seek(SWPFile,t);   {Читаем из файла нужную страницу и помещаем её в окно}
   Read(SWPFile,SEMMEWindow^);
  Exitt:
  END ELSE BEGIN
   {Ошибка, обращение за пределы выделенные для этого указателя}
   SEMMEError:=True;
   SEMMECodeError:=6;
  END;
  END ELSE BEGIN
   {Ошибка, такой указатель не сущеcтвует}
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
   {Увеличиваем или уменьшаем старую карту доступных страниц указателя}
   FreePages:=FreePages+Handles^[Handle]^.SizeInPages;
   FreePages:=FreePages-NewSize;
   Handles^[Handle]^.LastUsedPage:=$FFFF; {Помечаем последнюю станицу, как конец}
   IF Handles^[Handle]^.SizeInPages < NewSize THEN BEGIN
   {Ищем последнюю страницу}
   t1:=0; {Счетчик страниц}
   t:=Handles^[Handle]^.FirstPage;
   REPEAT
    Inc(t1);
    lp:=t;
    np:=Pages^[t]; {Получаем номер следующей страницы}
    t:=np;
   UNTIL t1>=Handles^[Handle]^.SizeInPages-1;
   {Ищем новые свободные страницы}
   {lp:=t;   {Продолжать с этой страницы}
   t:=0;    {Счетчик всех страниц}
   {Поиск свободных страниц для нового уазателя}
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
   {Ищем последнюю страницу}
   t1:=0; {Счетчик страниц}
   t:=Handles^[Handle]^.FirstPage;
   REPEAT
    Inc(t1);
    np:=Pages^[t]; {Получаем номер следующей страницы}
    IF t1 = NewSize THEN Pages^[t]:=$FFFF; {Последнюю страницу помечаем как $FFFF}
    IF t1 > NewSize THEN Pages^[t]:=0;
    t:=np;
   UNTIL t1=Handles^[Handle]^.SizeInPages;
  END;
   Handles^[Handle]^.SizeInPages:=NewSize; {Заносим в указатель новый его размер}
   MapSEMMEPage(Handle,1);
  END; END ELSE BEGIN
   {Нехватает места в памяти или такой указатель не существует}
   SEMMEError:=True;
   SEMMECodeError:=4;
  END;
 END ELSE BEGIN
  {Ошибка, такой указатель не сущеcтвует}
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
   {Определяем номер диска}
   IF name <> '' THEN BEGIN
    IF name[2] = ':' THEN d:=Ord(UpCase(name[1]))-64 ELSE d:=0;
    IF (DiskFree(d) DIV PageSize + 1) > Handles^[Handle]^.SizeInPages THEN BEGIN
     Assign(f,name); {Связываем имя файла с выйловой переменной}
     ReWrite(f);     {Создаем файл}
     FOR n:=1 TO Handles^[Handle]^.SizeInPages DO BEGIN
      MapSEMMEPage(Handle,n); {Картируем нужную страницу}
      WindowUsing:=True;      {Отключаем режим сохранения предыдущей страницы}
      Write(f,SEMMEWindow^);  {Сохраняем нужную страницу}
     END;
    END ELSE BEGIN
     {Ошибка, нехватает места на диске для создания файла}
     SEMMEError:=True;
     SEMMECodeError:=1;
    END;
   END ELSE BEGIN
    {Ошибка, неправельное имя файла}
    SEMMEError:=True;
    SEMMECodeError:=5;
   END;
  END ELSE BEGIN
   {Ошибка, такой указатель не существует}
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