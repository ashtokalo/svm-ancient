{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
{============================ShAG Font Interface=============================}
{====      Потдержка векторных шрифтов Штокало Алексея Геннадиевича.     ====}
{====                           Версия 1.0                               ====}
{====--------------------------------------------------------------------====}
{====  Модуль разрешается использовать только в некомерческих целях, при ====}
{==== условии, что исходный текст всех программ написанных с использова- ====}
{==== нием этого модуля получить Штокало Алексей Геннадиевич, на таких   ====}
{==== же правах, как и этот модуль, кроме получения копий программ.      ====}
{====--------------------------------------------------------------------====}
{====  Модуль создан в Turbo Pascal 7.0                                  ====}
{====--------------------------------------------------------------------====}
{====  Настоящая  версия модуля, т. е. версия 1.0 потдерживает векторные ====}
{==== шрифты формата CHR, в  дальнейшем планируется  потдержка векторных ====}
{==== шрифтов формата TTF, SFF, при этом команды для работы с текстом не ====}
{==== изменятся и ранее написанные программы не надо будет переделывать. ====}
{====  Кроме того  данный модуль  является примером  использования моего ====}
{==== графического интерфейса(SGI) и интерфейса виртуальной памяти(SVM). ====}
{====--------------------------------------------------------------------====}
{==== Некоторые свединия для работы со шрифтами:                         ====}
{====  ■ для использования модуля его  надо проинициализировать командой ====}
{====    InitFI параметром которой является  диагональ монитора в дюймах ====}
{====    это надо для правильного определения размера одного пункта.     ====}
{====  ■ Размер шрифта  задается в  пунктах, где  пунктом  является 1/72 ====}
{====    дюйма,  такой подход  позволяет выводит  одинаковым шрифтом  на ====}
{====    мониторах с разной диагональю и в различных графических режимах ====}
{====    которые опредиляются автоматически.                             ====}
{============================================================================}
{$M 16384,0,655360}
                                  UNIT SFI;
{============================================================================}
                                  INTERFACE
{=========================== Подключаемые модули ============================}

 USES SVM_n, SGI, Dos;

{========================= Зарезервированные типы ===========================}

 {Тип хранящий информацию о шрифте}
 TYPE TFont = RECORD     {Размер типа TFont равен 128 байт}
      Data: OVector;     {Шрифт}
      Name: String[92];  {Имя шрифта}
      Height,            {Множитель высоты}
      Width: Real;       {и длинны шрифта}
      BaseLine,          {Базовая линия - Линия по которой выравнивается нижняя граница символов (не считая снижения)}
      Ascent,            {Подъем - растояние от базовой линии до верхней точки символа}
      Descent,           {Снижение - растояние от базовой линии до нижней точки символа}
      Mode,              {Тип шрифта}
      Bold,              {Режим жирноты}
      Italic,            {Режим курсива}
      StrikeLine,        {Режим зачеркивани}
      UnderLine:ShortInt;{Режим подчеркивания}
      Color: TColor;     {Цвет текста}
 END;

 {Указатель на тип шрифта}
 TYPE PFont = ^TFont;

 CONST {Текстовое представление ошибок, которые могут возникнут в процессе работы}
       FIErrorMessage: ARRAY [0..8] OF String[60] = (
       'Нет ошибок.',
       'Модуль не инициализирован.',
       'Невозможно открыть файл содержащий шрифт.',
       'Данный тип шрифта не потдерживается или файл не является шрифтом.',
       'Ошибка в заголовке шрифта.',
       'Шрифт не инициализирован.',
       'Нехватает памяти для загрузки шрифта.',
       'Виртуальная память не инициализированна.',
       'Ошибка при работе с памятью.');
       {Стандартные определения}
       Bold: Byte = 1;
       DBold: Byte = 2;
       Italic: ShortInt = 20;
       IItalic: ShortInt = -20;
       UnderLine: Byte = 1;
       UnderLine2: Byte = 2;
       UnderLine3: Byte = 3;
       UnderLine4: Byte = 4;
       UnderLine5: Byte = 5;
       StrikeLine: Byte = 1;
       NoBold: Byte = 0;
       NoItalic: ShortInt = 0;
       NoUnderLine: Byte = 0;
       NoStrikeLine: Byte = 0;
       i11: Real = 11;
       i14: Real = 14;
       i15: Real = 15;
       i17: Real = 17;
       i19: Real = 19;
       i20: Real = 20;
       i21: Real = 21;
{============================ Процедуры и функции ===========================}

 PROCEDURE  InitFI(d: Real);
  {Устанавливает размер экрана по диагонали в дюймах}

 PROCEDURE  RegisterFontFile(fn: String; VAR fff: TFont);
  {Загружает шрифт из файла fn в переменную типа TFont}

 PROCEDURE  RegisterFontRAM(VAR fn; size: LongInt; VAR fff: TFont);
  {Загружает шрифт из переменной fn в переменную типа TFont}

 PROCEDURE  CloseFont(VAR f: TFont);
  {Освобождает память занимаемую шрифтом}

 PROCEDURE  SetFontSize(Sz: Word; VAR f: TFont);
  {Устанавливает высоту шрифта в пунктах}

 PROCEDURE  DrawChar(x1, y1: Word; c: Char; f: TFont);
  {Выводит символ C шрифтом f, по координатам x1, y1}

 PROCEDURE  DrawString(x1, y1: Word; s: String; f: TFont);
  {Выводит строку s шрифтом f, по координатам x1, y1}

 FUNCTION   GetStringLength(s: String; f: TFont): Word;
  {Возвращает длинну строку в точках, если бы та была прорисованна шрифтом f}

 FUNCTION   PunctsToPixel(p: Word): Word; {Переводит пункты в точки}

 FUNCTION   PixelToPuncts(p: Word): Word; {Переводит точки в пункты}

{=========================== Глобальные переменные ==========================}

 VAR        FIErrorProc:  PROCEDURE;{Процедура выдачи ошибок}
            FIError, FIStatus: Boolean;
            FIErrorCode: Byte;
            Diagonal: Real; {Diagonal - диагональ экрана в дюймах}
            ResolutionX, ResolutionY: Integer;
             {ResolutionX - разрешение экрана, точек на дюйм по оси X
              ResolutionY - разрешение экрана, точек на дюйм по оси Y}
            ItemSizeX, ItemSizeY: Real; {точек на один пункт, 1 пункт = 1/72 дюйма}
{============================================================================}
                               IMPLEMENTATION
{============================================================================}

 {Процедура поворачивает координаты на угол ang}
 PROCEDURE  Coor(ang: Integer; x,y: Integer; VAR xx, yy: Integer);
 VAR r,a,an: Single;
 BEGIN
  an:=(270-ang)/180*pi;
  r:=Sqrt(1.0*x*x+1.0*y*y);
  IF x = 0 THEN IF y < 0 THEN a:=-pi/2 ELSE a:=pi/2 ELSE a:=arctan(y/x);
  a:=a+an;
  xx:=(Round(r*sin(a)));
  yy:=(Round(r*cos(a)));
 END;

 PROCEDURE  TempErrorProc;
 BEGIN
  {Процедура вызывается каждый раз когда возникает ошибка, первоночально она
   ничего неделает, но при  желании её можно переопределить}
 END;

 PROCEDURE  InitFI(d: Real);
 BEGIN
  IF VMInit THEN BEGIN
   FIStatus:=True;
   Diagonal:=d;
   IF @FIErrorProc = NIL THEN @FIErrorProc:=@TempErrorProc;
   d:=d-1.5; {Уменьшаем размер по диагонали на 1,
   т. к. размер мониторов дается не по трубке, а по корпусу}
   ResolutionX:=MaxX DIV trunc(sqrt((d*d)/25)*4);
   ResolutionY:=MaxY DIV trunc(sqrt((d*d)/25)*3);
   ItemSizeY:=ResolutionY/72;
   ItemSizeX:=ResolutionX/72;
  END ELSE BEGIN
   {Виртуальная память неинициализированна}
   FIError:=True;
   FIErrorCode:=7;
   FIErrorProc;
  END;
 END;

 PROCEDURE  RegisterFontFile(fn: String; var fff: TFont);
 VAR SegFont, fd, OfsFont, k, n, m, hs, tc, dof, ff, um, lm, off, tow, maxsize, tw, tw2: Word;
     offs, fs: LongInt;
     b, fc: Byte;
     b1: ARRAY [0..1] OF Byte ABSOLUTE hs;
     b2: ARRAY [0..1] OF Byte ABSOLUTE tc;
     b3: ARRAY [0..1] OF Byte ABSOLUTE dof;
     b4: ARRAY [0..1] OF Byte ABSOLUTE tw;
     b5: ARRAY [0..1] OF Byte ABSOLUTE tw2;
     b6: ARRAY [0..3] OF Byte ABSOLUTE offs;
     f: File Of Byte;
     chrname: string;
     chrextname: string;
     copyright: string;
 CONST CHRHead: String = 'PK'+#8+#8;
 FUNCTION   GetB(n: LongInt): Byte;
 VAR b: Byte;
 BEGIN
  Seek(f, n);
  Read(f, b);
  GetB:=b;
 END;
 BEGIN
  IF FIStatus THEN BEGIN
   Assign(f, fn);
   {$I-} Reset(f); {$I+}
   {Проверяем наличие шрифта}
   IF IOResult <> 0 THEN BEGIN
    {Невозможно открыть файл шрифта}
    FIError:=True;
    FIErrorCode:=2;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {Получаем размер файла}
   fs:=FileSize(f);
   {Проверяем заголовок на принадлежность к CHR шрифту}
   FOR N:=0 TO 3 DO IF Ord(CHRHead[n+1]) <> GetB(n) THEN BEGIN
    {Файл неявляется CHR шрифтом}
    FIError:=True;
    FIErrorCode:=3;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {Ищем конец поля Copyright}
   n:=3;
   Copyright:='';
   REPEAT
    Inc(n);
    Copyright:=Copyright+Chr(GetB(n));
   UNTIL GetB(n-1) = $1A;
   {Проверяем на расширенное имя}
   chrextname:='';
   IF Copyright[1] = 'S' THEN BEGIN
    chrextname:=Copy(copyright,Pos('The ',copyright)+4,Length(Copyright)-Pos('The ',copyright));
    chrextname:=Copy(chrextname,1,Pos(' font.',chrextname)-1);
   END;
   {Получаем общий размер заголовка CHR файла}
   b1[0]:=GetB(n); b1[1]:=GetB(n+1);
   Inc(n,2);
   {Получаем имя шрифта}
   chrname:='';
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   IF chrextname <> '' THEN chrname:=chrextname;
   {Пропускаем поле FontSize и поле FontVersion}
   Inc(n,5);
   {Проверяем конец заголовка}
   REPEAT
    Inc(n);
   UNTIL GetB(n-1) = Ord('+');
   {Проверяем конец заголовка, в нужном ли он месте, если нет то выходим}
   IF (n-1) <> hs THEN BEGIN
    {Неправельный заголовок}
    FIError:=True;
    FIErrorCode:=4;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {Получаем общее количество символов в шрифте}
   b2[0]:=GetB(n); Inc(n);
   b2[1]:=GetB(n); Inc(n);
   {Пропускаем зарезервированный байт}
   Inc(n);
   {Получаем код первого символа}
   fc:=GetB(n); Inc(n);
   {Получаем значение поля DataOffset}
   b3[0]:=GetB(n); Inc(n);
   b3[1]:=GetB(n); Inc(n);
   IF tc <> (Dof-16) DIV 3 THEN BEGIN
    {Неправельный заголовок}
    FIError:=True;
    FIErrorCode:=4;
    FIErrorProc;
    Exit;
   END;
   {Получаем флаг заполнения}
   ff:=GetB(n); Inc(n);
   {Получаем верхнюю границу символов}
   um:=GetB(n);
   {Пропускаем зарезервированный байт}
   Inc(n,2);
   {Получаем нижнюю границу}
   lm:=GetB(n);
   {Пропускаем зарезервированные 5 байт}
   Inc(n,6);
   {Запоминаем начало таблицы смещений}
   off:=n;
   {Пропускаем таблицу смещение}
   Inc(n,2*tc);
   {Запоминаем начало таблицы ширин}
   tow:=n;
   {Пропускаем таблицу ширин}
   Inc(n,tc);
   {Запоминаем начало комманд}
   fd:=n;
   {Выделяем память для нового шрифта}
   FFF.Data.Init(4+5*tc+fs-fd,1);
   IF (VMErrorCode = 3) OR (VMErrorCode = 2) THEN BEGIN
    {Нехватает памяти}
    FIError:=True;
    FIErrorCode:=6;
    FIErrorProc;
    FFF.Mode:=0;
    Exit;
   END ELSE IF VMErrorCode > 0 THEN BEGIN
    {Ошибка при работе с памятью}
    FIError:=True;
    FIErrorCode:=8;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {Записываем код первого символа и общее количество символов}
   hs:=fc;
   FFF.Data.PutB(0,b1[0]);
   FFF.Data.PutB(1,b1[1]);
   hs:=tc;
   FFF.Data.PutB(2,b1[0]);
   FFF.Data.PutB(3,b1[1]);
   {Создаем таблицу ширин и таблицу смещений}
   FOR n:=0 TO tc-1 DO BEGIN
    FFF.Data.PutB(4+n,GetB(tow+n));
    b5[0]:=GetB(off+n*2);
    b5[1]:=GetB(off+n*2+1);
    offs:=tw2+4+tc+tc*4;
    FFF.Data.PutB(n*4+4+tc,b6[0]);
    FFF.Data.PutB(n*4+5+tc,b6[1]);
    FFF.Data.PutB(n*4+6+tc,b6[2]);
    FFF.Data.PutB(n*4+7+tc,b6[3]);
   END;
   {Загружаем комманды}
   FOR n:=fd TO fs-1 DO FFF.Data.PutB(n-fd+4+tc+tc*4,GetB(n));
   Close(f);
   {Устанавливаем настройки шрифта}
   FFF.Name:=chrname;
   FFF.Height:=1;
   FFF.Width:=1;
   FFF.BaseLine:=7;
   FFF.Ascent:=um;
   FFF.Descent:=lm;
   FFF.Mode:=1;
   FFF.Color:=White;
   FFF.Bold:=0;
   FFF.Italic:=0;
   FFF.UnderLine:=0;
   FFF.StrikeLine:=0;
   SetFontSize(12,FFF);
  END ELSE BEGIN
   {Модуль небыл инициализирован}
   FFF.Mode:=0;
   FIError:=True;
   FIErrorCode:=1;
   FIErrorProc;
  END;
 END;

 PROCEDURE  RegisterFontRAM(VAR fn; size: LongInt; VAR fff: TFont);
 VAR SegFont, fd, OfsFont, k, n, m, hs, tc, dof, ff, um, lm, off, tow, maxsize, tw, tw2: Word;
     offs, fs: LongInt;
     b, fc: Byte;
     b1: ARRAY [0..1] OF Byte ABSOLUTE hs;
     b2: ARRAY [0..1] OF Byte ABSOLUTE tc;
     b3: ARRAY [0..1] OF Byte ABSOLUTE dof;
     b4: ARRAY [0..1] OF Byte ABSOLUTE tw;
     b5: ARRAY [0..1] OF Byte ABSOLUTE tw2;
     b6: ARRAY [0..3] OF Byte ABSOLUTE offs;
     data: ARRAY [0..10] OF Byte ABSOLUTE fn;
     chrname: string;
     chrextname: string;
     copyright: string;
 CONST CHRHead: String = 'PK'+#8+#8;
 FUNCTION   GetB(n: LongInt): Byte;
 BEGIN
  Getb:=data[n];
 END;
 BEGIN
  IF FIStatus THEN BEGIN
   {Получаем размер файла}
   fs:=size;
   {Проверяем заголовок на принадлежность к CHR шрифту}
   FOR N:=0 TO 3 DO IF Ord(CHRHead[n+1]) <> GetB(n) THEN BEGIN
    {Файл неявляется CHR шрифтом}
    FIError:=True;
    FIErrorCode:=3;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {Ищем конец поля Copyright}
   n:=3;
   Copyright:='';
   REPEAT
    Inc(n);
    Copyright:=Copyright+Chr(GetB(n));
   UNTIL GetB(n-1) = $1A;
   {Проверяем на расширенное имя}
   chrextname:='';
   IF Copyright[1] = 'S' THEN BEGIN
    chrextname:=Copy(copyright,Pos('The ',copyright)+4,Length(Copyright)-Pos('The ',copyright));
    chrextname:=Copy(chrextname,1,Pos(' font.',chrextname)-1);
   END;
   {Получаем общий размер заголовка CHR файла}
   b1[0]:=GetB(n); b1[1]:=GetB(n+1);
   Inc(n,2);
   {Получаем имя шрифта}
   chrname:='';
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   chrname:=chrname+Chr(GetB(n)); Inc(n);
   IF chrextname <> '' THEN chrname:=chrextname;
   {Пропускаем поле FontSize и поле FontVersion}
   Inc(n,5);
   {Проверяем конец заголовка}
   REPEAT
    Inc(n);
   UNTIL GetB(n-1) = Ord('+');
   {Проверяем конец заголовка, в нужном ли он месте, если нет то выходим}
   IF (n-1) <> hs THEN BEGIN
    {Неправельный заголовок}
    FIError:=True;
    FIErrorCode:=4;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {Получаем общее количество символов в шрифте}
   b2[0]:=GetB(n); Inc(n);
   b2[1]:=GetB(n); Inc(n);
   {Пропускаем зарезервированный байт}
   Inc(n);
   {Получаем код первого символа}
   fc:=GetB(n); Inc(n);
   {Получаем значение поля DataOffset}
   b3[0]:=GetB(n); Inc(n);
   b3[1]:=GetB(n); Inc(n);
   IF tc <> (Dof-16) DIV 3 THEN BEGIN
    {Неправельный заголовок}
    FIError:=True;
    FIErrorCode:=4;
    FIErrorProc;
    Exit;
   END;
   {Получаем флаг заполнения}
   ff:=GetB(n); Inc(n);
   {Получаем верхнюю границу символов}
   um:=GetB(n);
   {Пропускаем зарезервированный байт}
   Inc(n,2);
   {Получаем нижнюю границу}
   lm:=GetB(n);
   {Пропускаем зарезервированные 5 байт}
   Inc(n,6);
   {Запоминаем начало таблицы смещений}
   off:=n;
   {Пропускаем таблицу смещение}
   Inc(n,2*tc);
   {Запоминаем начало таблицы ширин}
   tow:=n;
   {Пропускаем таблицу ширин}
   Inc(n,tc);
   {Запоминаем начало комманд}
   fd:=n;
   {Выделяем память для нового шрифта}
   FFF.Data.Init(4+5*tc+fs-fd,1);
   IF (VMErrorCode = 3) OR (VMErrorCode = 2) THEN BEGIN
    {Нехватает памяти}
    FIError:=True;
    FIErrorCode:=6;
    FIErrorProc;
    FFF.Mode:=0;
    Exit;
   END ELSE IF VMErrorCode > 0 THEN BEGIN
    {Ошибка при работе с памятью}
    FIError:=True;
    FIErrorCode:=8;
    FFF.Mode:=0;
    FIErrorProc;
    Exit;
   END;
   {Записываем код первого символа и общее количество символов}
   hs:=fc;
   FFF.Data.PutB(0,b1[0]);
   FFF.Data.PutB(1,b1[1]);
   hs:=tc;
   FFF.Data.PutB(2,b1[0]);
   FFF.Data.PutB(3,b1[1]);
   {Создаем таблицу ширин и таблицу смещений}
   FOR n:=0 TO tc-1 DO BEGIN
    FFF.Data.PutB(4+n,GetB(tow+n));
    b5[0]:=GetB(off+n*2);
    b5[1]:=GetB(off+n*2+1);
    offs:=tw2+4+tc+tc*4;
    FFF.Data.PutB(n*4+4+tc,b6[0]);
    FFF.Data.PutB(n*4+5+tc,b6[1]);
    FFF.Data.PutB(n*4+6+tc,b6[2]);
    FFF.Data.PutB(n*4+7+tc,b6[3]);
   END;
   {Загружаем комманды}
   FOR n:=fd TO fs-1 DO FFF.Data.PutB(n-fd+4+tc+tc*4,GetB(n));
{   Close(f);}
   {Устанавливаем настройки шрифта}
   FFF.Name:=chrname;
   FFF.Height:=1;
   FFF.Width:=1;
   FFF.BaseLine:=7;
   FFF.Ascent:=um;
   FFF.Descent:=lm;
   FFF.Mode:=1;
   FFF.Color:=White;
   FFF.Bold:=0;
   FFF.Italic:=0;
   FFF.UnderLine:=0;
   FFF.StrikeLine:=0;
   SetFontSize(12,FFF);
  END ELSE BEGIN
   {Модуль небыл инициализирован}
   FFF.Mode:=0;
   FIError:=True;
   FIErrorCode:=1;
   FIErrorProc;
  END;
 END;

 PROCEDURE  CloseFont(VAR f: TFont);
 BEGIN
  IF F.Mode <> 0 THEN BEGIN
   F.Mode:=0; {Запрещаем дальнейшее использование этого шрифта}
   F.Data.Done; {Освобождаем память связанную с данным шрифтом}
  END ELSE BEGIN
   {Шрифт небыл инициализирован}
   FIError:=True;
   FIErrorCode:=5;
   FIErrorProc;
  END;
 END;

 PROCEDURE  SetFontSize(Sz: Word; VAR f: TFont);
 VAR h,w: Word;
 BEGIN
  IF f.Mode <> 0 THEN BEGIN
   {Переводим размер в точки}
   h:=Round(Sz*ItemSizeY);
   w:=Round(Sz*ItemSizeX);
   f.Height:=h/f.Ascent; {Устанавливаем высоту}
   f.Width:=w/f.Ascent;
  END ELSE BEGIN
   {Шрифт небыл инициализирован}
   FIError:=True;
   FIErrorCode:=5;
   FIErrorProc;
  END;
 END;

 PROCEDURE  DrawChar(x1, y1: Word; c: Char; f: TFont);
 VAR vec, op, cd, sz: Word;
     x,y,x0,y0,xx,yy,k,tc,offs,x2,y2: Integer;
     bv: ARRAY [0..1] OF Byte ABSOLUTE vec;
     tl: TLineStyle;
 BEGIN
  IF f.Mode <> 0 THEN BEGIN
   {Корректируем координату по оси X в связи с возможным режимом курсива}
   Coor(f.Italic,0,Round(f.Ascent*f.Height),x2,y2);
   x1:=x1+Abs(x2);
   {Сохраняем прежний тип линии}
   tl:=LineStyle;
   {Устанавливаем новый тип линии}
   LineStyle.Color:=f.Color;
   LineStyle.Size:=f.Bold+1;
   LineStyle.Mask:=0;
   LineStyle.MaskLine:=False;
   IF (f.Height > 1.0)  OR (f.Width > 1.0) THEN BEGIN
    LineStyle.Color:=f.Color;
    LineStyle.Size:=Round(((f.Height+f.Width)/2+0.1)*(f.Bold+1));
    LineStyle.Mask:=0;
    LineStyle.MaskLine:=False;
   END;
   {Получаем общее количество символов}
   bv[0]:=F.Data.GetB(2);
   bv[1]:=F.Data.GetB(3);
   tc:=vec;
   {Получаем код символа относительно кода первого символа}
   bv[0]:=F.Data.GetB(0);
   bv[1]:=F.Data.GetB(1);
   cd:=Ord(c);
   IF (cd < Vec) OR (cd > Vec+tc-1) THEN Exit;
   ASM
    MOV ax, cd
    SUB ax, vec
    MOV cd, ax
    MOV k,1
    MOV ax,x1
    MOV x,ax
    MOV ax,y1
    MOV y,ax
   END;
   {Получаем общее количество символов}
   bv[0]:=F.Data.GetB(2);
   bv[1]:=F.Data.GetB(3);
   tc:=vec;
   {Получаем смещение первой команды}
   bv[0]:=F.Data.GetB(tc+4+cd*4);
   bv[1]:=F.Data.GetB(tc+5+cd*4);
   offs:=vec;
   {Получаем размер символа по оси X}
   sz:=F.Data.GetB(4+cd)+1;
   {Проверяем подчеркивание}
   IF f.UnderLine > 0 THEN BEGIN
    {Учитываем наклон курсива}
    Coor(f.Italic,0,Round((f.Ascent+2)*f.Height),x2,y2);
    {Учитываем масштабные коэффициенты}
    sz:=Round((sz)*f.Width);
    Line(x1+x2,y1+Round((f.Ascent+2)*f.Height),x1+x2+sz,y1+Round((f.Ascent+2)*f.Height));
    IF f.UnderLine = 2 THEN BEGIN
     {Учитываем наклон курсива}
     Coor(f.Italic,0,Round((f.Ascent+3)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+3)*f.Height),x1+x2+sz,y1+Round((f.Ascent+3)*f.Height));
    END;
    IF f.UnderLine = 3 THEN BEGIN
     {Учитываем наклон курсива}
     Coor(f.Italic,0,Round((f.Ascent+4)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+4)*f.Height),x1+x2+sz,y1+Round((f.Ascent+4)*f.Height));
    END;
    IF f.UnderLine = 4 THEN BEGIN
     {Учитываем наклон курсива}
     Coor(f.Italic,0,Round((f.Ascent+3)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+3)*f.Height),x1+x2+sz,y1+Round((f.Ascent+3)*f.Height));
     {Учитываем наклон курсива}
     Coor(f.Italic,0,Round((f.Ascent+5)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+5)*f.Height),x1+x2+sz,y1+Round((f.Ascent+5)*f.Height));
    END;
    IF f.UnderLine = 5 THEN BEGIN
     {Учитываем наклон курсива}
     Coor(f.Italic,0,Round((f.Ascent+4)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+4)*f.Height),x1+x2+sz,y1+Round((f.Ascent+4)*f.Height));
     {Учитываем наклон курсива}
     Coor(f.Italic,0,Round((f.Ascent+5)*f.Height),x2,y2);
     Line(x1+x2,y1+Round((f.Ascent+5)*f.Height),x1+x2+sz,y1+Round((f.Ascent+5)*f.Height));
    END;
   END;
   {Получаем размер символа по оси X}
   sz:=F.Data.GetB(4+cd)+1;
   {Проверяем зачеркивание}
   IF f.StrikeLine > 0 THEN BEGIN
    {Учитываем наклон курсива}
    Coor(f.Italic,0,Round((f.Ascent/2)*f.Height),x2,y2);
    {Учитываем масштабные коэффициенты}
    sz:=Round((sz)*f.Width);
    Line(x1+x2,y1+Round((f.Ascent/2)*f.Height),x1+x2+sz,y1+Round((f.Ascent/2)*f.Height));
   END;
   {Прорисовываем символ}
   REPEAT
    {Получаем очередную команду}
    bv[0]:=F.Data.GetB(offs+(k-1)*2);
    bv[1]:=F.Data.GetB(offs+(k-1)*2+1);
    op:=Vec AND $8080;
    xx:=Vec AND $7F;
    yy:=(Vec SHR 8) AND $7F;
    ASM
     CMP yy, 63
     JNG @next
     SUB yy, 128
    @next:
    END;
    {Преобразуем координату по Y относительно нормальной координатной сетки}
    yy:=F.Ascent-yy;
    {Учитываем наклон курсива}
    x2:=0;
    IF f.Italic <> NoItalic THEN Coor(f.Italic,0,yy,x2,y2);
    {Учитываем масштабные коэффициенты}
    x0:=x1+Round(xx*f.Width)+x2;
    y0:=y1+Round(yy*f.Height);
    {Вычерчиваем вектор}
    IF k=1 THEN BEGIN x:=x0; y:=y0; END;
    IF op=$8080 THEN Line(x,y,x0,y0);
    {Переходим в новую точку и увеличиваем счетчик команд}
    ASM
     CMP op, 0
     JE @next
     MOV ax, x0
     MOV x, ax
     MOV ax, y0
     MOV y, ax
     @next:
     INC k
    END;
  UNTIL Op=0;
  {Востанавливаем прежний тип линии}
  SetLineStyle(tl);
  END ELSE BEGIN
   {Шрифт небыл инициализирован}
   FIError:=True;
   FIErrorCode:=5;
   FIErrorProc;
  END;
 END;

 PROCEDURE  DrawString(x1, y1: Word; s: String; f: TFont);
 VAR k: Byte;
     vec: Word;
     b: ARRAY [0..1] OF Byte ABSOLUTE  vec;
 BEGIN
  IF f.Mode <> 0 THEN BEGIN
   b[0]:=F.Data.GetB(0);
   b[1]:=F.Data.GetB(1);
   FOR k:=1 TO Length(s) DO BEGIN
    DrawChar(x1,y1,s[k],f);
    Inc(x1,Round((F.Data.GetB(Ord(s[k])-vec+4)+f.Bold+1)*(f.Height+f.Width)/2));
   END;
  END ELSE BEGIN
   {Шрифт небыл инициализирован}
   FIError:=True;
   FIErrorCode:=5;
   FIErrorProc;
  END;
 END;

 FUNCTION   GetStringLength(s: String; f: TFont): Word;
 VAR n:Byte;
     w:Word;
     vec: Word;
     b: ARRAY [0..1] OF Byte ABSOLUTE  vec;
 BEGIN
  IF f.Mode <> 0 THEN BEGIN
   b[0]:=F.Data.GetB(0);
   b[1]:=F.Data.GetB(1);
   w:=0;
   FOR n:=1 TO Length(s) DO
    Inc(w,Round((F.Data.GetB(Ord(s[n])-vec+4)+f.Bold+1)*(f.Height+f.Width)/2));
   GetStringLength:=w;
  END ELSE BEGIN
   {Шрифт небыл инициализирован}
   FIError:=True;
   FIErrorCode:=5;
   FIErrorProc;
   GetStringLength:=0;
  END;
 END;

 FUNCTION   PunctsToPixel(p: Word): Word;
 BEGIN
  IF FIStatus THEN PunctsToPixel:=Round(p*ItemSizeY) ELSE BEGIN
   {Модуль небыл инициализирован}
   FIError:=True;
   FIErrorCode:=1;
   FIErrorProc;
  END;
 END;

 FUNCTION   PixelToPuncts(p: Word): Word;
 BEGIN
  IF FIStatus THEN PixelToPuncts:=Round(p/ItemSizeY) ELSE BEGIN
   {Модуль небыл инициализирован}
   FIError:=True;
   FIErrorCode:=1;
   FIErrorProc;
  END;
 END;

{============================================================================}
 BEGIN
  FIStatus:=False;
  {Модуль ещё не инициализирован}
  FIError:=True;
  FIErrorCode:=1;
  @FIErrorProc:=NIL;
 END.
{============================================================================}