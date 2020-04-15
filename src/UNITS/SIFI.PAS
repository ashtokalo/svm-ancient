{$A-,B+,D-,E-,F-,G+,I-,L-,N-,O-,P+,Q-,R-,S-,T-,V-,X+}
{$M 32768,0,0}
{=========================ShAG INI File Interface============================}
{====                Интерфейс для работы с INI файлами.                 ====}
{====                           Версия 1.0                               ====}
{====           Права на этот модуль пренадлежат ShAG Studio             ====}
{====--------------------------------------------------------------------====}
{====  Модуль предназначен для работы с файлами настроек, но может испо- ====}
{==== льзоваться и для других целей.                                     ====}
{====  Вы должны усвоить некоторые основные понятия: папка(folder),пункт ====}
{==== (item), строка перед коментарием(PreComentLine), строка после ком- ====}
{==== ментария(PostComentLine), заголовок файла(FirstString), коментарий ====}
{==== к папке(FolderComent), коментарий к пункту(ItemComent).            ====}
{====  Папка - в файлах настроек вы можете хранить различную информацию, ====}
{==== при этом название информации может совподать, чтобы вам было легче ====}
{==== добраться до нужной вам информации, мною были введены папки, кото- ====}
{==== рые являются ограничителями информации, т.е. все пункты которые    ====}
{==== идут после названия папки относятся только к этой папке, а после   ====}
{==== того, как появится новое имя папки, все последующие пункты будут   ====}
{==== относиться только к нему. Таким образом, благодаря папкам у вас    ====}
{==== есть возможность хранить различные настройке в одном файле и при   ====}
{==== этом давать пунктам одинаковые имена. Все папки выделяются квадра- ====}
{==== тными скобками с обоих сторон без каких-либо других разделяющих    ====}
{==== символов.                                                          ====}
{====  Пункт - в каждой папке может лежать несолько пунктов, каждый из   ====}
{==== которых содержит информацию. Т.е. вы можете сохранить нужную вам   ====}
{==== информацию озаглавив её и передав это имя в качестве имени пункта. ====}
{==== Пунк должен находиться первым в строке, после него следует пробел, ====}
{==== знак равно и еще один пробел, после этого идет информация. Запом-  ====}
{==== ните, структура пробел равно пробел не относится ни к имени пункта ====}
{==== ни к информации.                                                   ====}
{====  Строка перед коментарием и строка после коментария - если ваша    ====}
{==== программа сохраняет какую-то информацию в настроечный файл, то вы  ====}
{==== можете вставить коментарий, при этом, вы можете выделять этот ком- ====}
{==== ментарий двумя строками до и после. Хочу заметить, что когда ком-  ====}
{==== ментарий предназначен для пункта, то он не выделяется.             ====}
{====  Заголовок файла - если ваша программа первый раз пишет в файл, то ====}
{==== вы можете добавить в начало файла заголовок, который будет окружен ====}
{==== строками до и после, если вы того захотите.                        ====}
{====  Коментарий к пункту, коментарий к папке - если вы создаете папку  ====}
{==== или пункт, то вы можете сделать так, чтобы перед ними писался ком- ====}
{==== ментарий. При этом, вы должны помнить, что коментарий к пункту не  ====}
{==== обрамляется до и после.                                            ====}
{====  Хочу заметить, что если соответствующие переменные коментария     ====}
{==== будут содеражать пустую строку, то они не будут выводиться.        ====}
{====  Пример информации, которая хранится в настроечном файле:          ====

      [program]                 ;Это мы объявляем папку с именем program
       name = SIFI                            ;а это пункт с именем name
       version = 1.0    ;пункт version содержит строку 1.0 , а следующий
       author = Штокало Алексей Геннадиевич      ;пункт содержит мое имя
      [date and time]    ; определяем новый пункт с именем date and time
       year = 1999
       month = november
       day = 24
       hour = 18
       minute = 35
       second = 10
      [coordinates]
       homepage = http://www.shag.itgo.com
       E-mail = shag@qnx.com

{====  Хочу заметить, что верхний и нижний индекс учитывается, в имени   ====}
{==== папки или пункта, вы можете использовать любые симвлоы, но при     ====}
{==== этом вы должны следить, чтобы имя пункта не начиналось с пробела,  ====}
{==== а во всех остальных случаях задания имен пунктов, не должны встре- ====}
{==== чаться символы в такой последовательности: пробел равно пробел так ====}
{==== как эти символы сигнализируют об окончании имени пункта. Для имен  ====}
{==== папок вы можете использовать любые символы, в любой последователь- ====}
{==== ности, за исключением квадратных скобок, которые являются ограни-  ====}
{==== чителями имени папки.                                              ====}
{====  Как вы уже заметили, коментарий начинается с символа точка с за-  ====}
{==== пятой. После этого символа строка не разбирается, т.е. она не от-  ====}
{==== носится к информации.                                              ====}
{====  Примечание: в именах пуктов и папок, вы можете использовать любые ====}
{==== символы, кроме: равно, квадратные скобки, пробел(все пробелы, ко-  ====}
{==== торые идут перед именем и после него, до знака равно или до квадр- ====}
{==== атной скобки, к имени не относятся. Аналогично и в информации, ко- ====}
{==== торая хранится в пунктах - все крайние пробелы отрезаются, как при ====}
{==== чтении, так и при записи.                                          ====}
{====--------------------------------------------------------------------====}
{============================================================================}
                                   UNIT SIFI;
{============================================================================}
                                   INTERFACE
{============================================================================}

 FUNCTION GetItem(fname, folder, item: String): String; {Прочитать занчение}
 FUNCTION PutItem(fname, folder, item, text: String): Boolean; {Записать значения}
 FUNCTION NumberToFolder(fname: String; nm: Integer): String; {}
 FUNCTION NumberToItem(fname, folder: String; nm: Integer): String; {}
 FUNCTION TotalFolder(fname: String): Integer; {}
 FUNCTION TotalItem(fname, folder: String): Integer; {}

 CONST FolderNotFound: String = ' In this file folder with this number - not found. ';
       ItemNotFound: String = ' In this file and folder item with this number - not found. ';
       INIFileNotFound: String = ' INI file with this name - not found. ';
       IFileNotFound: Integer = -1;
       IFolderNotFound: Integer = -2;


 VAR INIFile: Text;      {Файл, который используется для чтения}
     TempFile: Text;     {Файл, который используется для записи}
     FolderComent,       {Комментарий к папке}
     ItemComent,         {Комментарий к пункту}
     PreComentLine,      {Строка перед комментарием}
     PostComentLine,     {Строка после комментария}
     FirstString: String;{Заголовок файла}

{============================================================================}
                                 IMPLEMENTATION
{============================================================================}

 {Функция удаляет ведущие и завершающие пробелы из строки}
 FUNCTION DeleteSpace(str: String): String;
 VAR n: Byte;
 BEGIN
  n:=1;
  WHILE str[n] = ' ' DO Inc(n);
  Delete(str,1,n-1);
  n:=Length(str);
  WHILE str[n] = ' ' DO Dec(n);
  str:=Copy(str,1,n);
  DeleteSpace:=str;
 END;

 {Функция удаляет коментарий из строки (все что после знака точка с запятой)}
 FUNCTION DeleteComent(str: String): String;
 VAR n: byte;
     op1,op2: Boolean;
     s: String;
 BEGIN
  op1:=FALSE;
  op2:=FALSE;
  s:='';
  DeleteComent:=s;
  FOR n:=1 TO Length(str) DO BEGIN
   IF (str[n] = '"') AND NOT op2 THEN op1:=NOT op1;
   IF (str[n] = #39) AND NOT op1 THEN op2:=NOT op2;
   IF (str[n] = ';') AND NOT op1 AND NOT op2 THEN Exit;
   s:=s+str[n];
   DeleteComent:=s;
  END;
 END;

 {Функция возвращает folder если в fstr имеется поле следующего вида
  [folder]  , где вместо folder подставляется строка из переменной folder.
  Если такой строки нет, то возвращается пустая строка ''}
 FUNCTION GetFolderStr(fstr, folder: String): String;
 VAR tx, ty: Byte;
     ts: String;
 BEGIN
  GetFolderStr:='';
  tx:=Pos('[',fstr);
  ty:=Pos(']',fstr);
  {Проверяем на присутствие ограничителей в строке, а также на их положение}
  IF (tx = 0) OR (ty = 0) OR (ty < tx) THEN Exit;
  ts:=DeleteSpace(Copy(fstr,tx+1,ty-tx-1));
  IF ts = folder THEN GetFolderStr:=ts;
 END;

 {Процедура возвращает it = item если в fstr имеется поле следующего вида
  item =  , где вместо item подставляется строка из переменной item, если это
  условие выполняется, то param содержит строку сразу после знака равно через
  символ пробел. Если такой строки нет, то возвращается пустая строка ''}
 PROCEDURE GetItemStr(fstr, item: String; VAR it, param: String);
 VAR tx, ty: Byte;
     ts: String;
 BEGIN
  it:='';
  param:='';
  tx:=Pos('=',fstr);
  {Проверяем на присутствие ограничителей в строке, а также на их положение}
  IF tx = 0 THEN Exit;
  ts:=DeleteSpace(Copy(fstr,1,tx-1));
  IF ts = item THEN BEGIN
   it:=ts;
   param:=DeleteSpace(Copy(fstr, tx+2, Length(fstr)-tx));
  END;
 END;

 FUNCTION TestFolder(fstr: String): String;
 VAR tx, ty: Byte;
     ts: String;
 BEGIN
  TestFolder:='';
  tx:=Pos('[',fstr);
  ty:=Pos(']',fstr);
  {Проверяем на присутствие ограничителей в строке, а также на их положение}
  IF (tx = 0) OR (ty = 0) OR (ty < tx) THEN Exit;
  ts:=DeleteSpace(Copy(fstr,tx+1,ty-tx-1));
  TestFolder:=ts;
 END;

 FUNCTION TestItem(fstr: String): String;
 VAR tx, ty: Byte;
     ts: String;
 BEGIN
  TestItem:='';
  tx:=Pos('=',fstr);
  {Проверяем на присутствие ограничителей в строке, а также на их положение}
  IF tx = 0 THEN Exit;
  ts:=DeleteSpace(Copy(fstr,1,tx-1));
  TestItem:=ts;
 END;

{============================================================================}
{==== Функция GetItem возвращает информацию, которая записана в пункте с ====}
{==== именем item, которая находится в папке folder из файла fname. При  ====}
{==== этом, если файл не найден, или возникла еще какая либо ошибка ра-  ====}
{==== боты с файлами фунция возвращает пустую строку. Аналогично возвра- ====}
{==== щается пустая строка, если в файле fname не найдена папка folder   ====}
{==== или в папке folder не найден пункт item.                           ====}
{============================================================================}
 FUNCTION GetItem(fname, folder, item: String): String;
 VAR ts, ts1, ts2: String;
 BEGIN
  fname:=DeleteSpace(fname);
  GetItem:=INIFileNotFound;
  {Открываем INI файл}
  Assign(INIFile,fname);
  {$I-}
   Reset(INIFile);
  {$I+}
  IF IOResult <> 0 THEN Exit;
  GetItem:=FolderNotFound;
  {Ищем папку folder}
  REPEAT
   ReadLn(INIFile,ts);
   ts:=DeleteComent(ts);
  UNTIL (GetFolderStr(ts,folder) = folder) OR EOF(INIFile);
  {Если папка не найдена, то выходим}
  IF GetFolderStr(ts,folder) <> folder THEN BEGIN
   Close(INIFile);
   Exit;
  END;
  GetItem:=ItemNotFound;
  {Ищем метку item}
  REPEAT
   ReadLn(INIFile,ts);
   ts:=DeleteComent(ts);
   GetItemStr(ts, item, ts1, ts2);
  UNTIL (ts1 = item) OR EOF(INIFile) OR (TestFolder(ts) <> '');
  {Если метка не найдена, то выходим}
  IF ts1 <> item THEN BEGIN
   Close(INIFile);
   Exit;
  END;
  {иначе возвращаем строку после метки}
  GetItem:=ts2;
  {Закрываем INI файл}
  Close(INIFile);
 END;

{============================================================================}
{==== Функция PutItem записывает строку text как информацию в пункт      ====}
{==== item из папке folder в файле fname. При этом, если файл не сущест- ====}
{==== вует, функция возвращает FALSE аналогичное значение она возвращает ====}
{==== если возникла какая-то дисковая ошибка или на диске нет места. Для ====}
{==== проведения изменений. Вы должны учитывать, что для того, чтобы что ====}
{==== то записать в файл, на диске должно быть filesize+512 свободных    ====}
{==== байт, где filesize - размер первоначального файла. Так же, вы дол- ====}
{==== жны учитывать, что если пункт item не будет найден в папке folder, ====}
{==== или не будет найдена сама папка, то процедура создаст автоматичски ====}
{==== и пукт и папку. Если же они существуют, то информация которая в    ====}
{==== них хранится будет заменена на новую, при этом коментарий содержа- ====}
{==== щийся в старых строках будет утерян.                               ====}
{============================================================================}
 FUNCTION PutItem(fname, folder, item, text: String): Boolean;
 VAR ts, lts, ts1, ts2, s: String;
 BEGIN
  fname:=DeleteSpace(fname);
  folder:=DeleteSpace(folder);
  item:=DeleteSpace(item);
  text:=DeleteSpace(text);
  PutItem:=FALSE;
  {Открываем INI файл}
  Assign(INIFile,fname);
  s:='';
  if (fname[2] = ':') and (fname[3] = '\') then s:=fname[1]+':\';
  s:=s+'$_SIFI_$.tmp';
  Assign(tempfile,s);
  {$I-}
  Reset(INIFile);
  {$I+}
  IF IOResult <> 0 THEN Exit;
  {$I-}
  ReWrite(tempfile);
  {$I+}
  IF IOResult <> 0 THEN BEGIN
   Close(INIFile);
   Exit;
  END;
  IF FirstString <> '' THEN BEGIN
   IF PreComentLine <> '' THEN WriteLn(tempfile,';',PreComentLine);
   WriteLn(tempfile,'; ',FirstString);
   IF PostComentLine <> '' THEN WriteLn(tempfile,';',PostComentLine);
  END;
  {Ищем папку folder}
  REPEAT
   ReadLn(INIFile,ts);
   WriteLn(tempfile,ts);
   ts:=DeleteComent(ts);
  UNTIL (GetFolderStr(ts,folder) = folder) OR EOF(INIFile);
  {Если папка не найдена, значит конец файла}
  IF GetFolderStr(ts,folder) <> folder THEN BEGIN
   IF FolderComent <> '' THEN BEGIN
    IF PreComentLine <> '' THEN WriteLn(tempfile,';',PreComentLine);
    WriteLn(tempfile,'; ',FolderComent);
    IF PostComentLine <> '' THEN WriteLn(tempfile,';',PostComentLine);
   END;
   WriteLn(tempfile,'[',folder,']');
   IF ItemComent <> '' THEN WriteLn(tempfile,' ; ',ItemComent);
   WriteLn(tempfile,' ',item,' = ',text);
   Close(INIFile);
   Close(tempfile);
   Erase(INIFile);
   Rename(tempfile,fname);
   PutItem:=TRUE;
   Exit;
  END;
  {Ищем метку item}
  lts:='{{{{[[[[No]]]]}}}}';
  REPEAT
   ReadLn(INIFile,ts);
   IF lts <> '{{{{[[[[No]]]]}}}}' THEN WriteLn(tempfile,lts);
   lts:=ts;
   ts:=DeleteComent(ts);
   GetItemStr(ts, item, ts1, ts2);
  UNTIL (ts1 = item) OR EOF(INIFile) OR (TestFolder(ts) <> '');
  IF ItemComent <> '' THEN WriteLn(tempfile,' ; ',ItemComent);
  WriteLn(tempfile,' ',item,' = ',text);
  IF TestFolder(ts) <> '' THEN WriteLn(tempfile,ts);
  {Дописываем остаток файла}
  REPEAT
   ReadLn(INIFile,ts);
   WriteLn(tempfile,ts);
  UNTIL EOF(INIFile);
  {$I-}
  Close(INIFile);
  Close(tempfile);
  Erase(INIFile);
  Rename(tempfile,fname);
  PutItem:=TRUE;
  {$I+}
  Exit;
 END;

{============================================================================}
{==== Функция NumberToFolder возвращает имя папки по ее номеру nm из     ====}
{==== файла fname. Если папка с таким номером отсутствует, то возвращае- ====}
{==== тся константа FolderNotFound.                                      ====}
{============================================================================}
 FUNCTION NumberToFolder(fname: String; nm: Integer): String;
 VAR ts, ts1: String;
     fc: Integer;
 BEGIN
  fname:=DeleteSpace(fname);
  NumberToFolder:=FolderNotFound;
  IF nm <= 0 THEN Exit;
  NumberToFolder:=INIFileNotFound;
  {Открываем INI файл}
  Assign(INIFile,fname);
  {$I-}
   Reset(INIFile);
  {$I+}
  IF IOResult <> 0 THEN Exit;
  NumberToFolder:=FolderNotFound;
  {Ищем папку folder}
  fc:=0;
  REPEAT
   ReadLn(INIFile,ts);
   ts:=DeleteComent(ts);
   ts1:=TestFolder(ts);
   IF ts1 <> '' THEN Inc(fc);
  UNTIL (fc = nm) OR EOF(INIFile);
  {Если папка с таким номером не существует, то выходим}
  IF fc <> nm THEN BEGIN
   Close(INIFile);
   Exit;
  END;
  NumberToFolder:=ts1;
  Close(INIFile);
 END;

{============================================================================}
{==== Функция ItemToFolder возвращает имя пункта по его номеру nm из фай ====}
{==== ла fname из папки folder. Если такая папка не найдена возвращается ====}
{==== константа FolderNotFound, если не найден пункт с таким номером, то ====}
{==== возвращается константа ItemNotFound.                               ====}
{============================================================================}
 FUNCTION NumberToItem(fname, folder: String; nm: Integer): String;
 VAR ts, ts1, ts2: String;
     ic: Integer;
 BEGIN
  fname:=DeleteSpace(fname);
  NumberToItem:=FolderNotFound;
  IF (folder = FolderNotFound) OR (nm <= 0) THEN Exit;
  NumberToItem:=INIFileNotFound;
  {Открываем INI файл}
  Assign(INIFile,fname);
  {$I-}
   Reset(INIFile);
  {$I+}
  IF IOResult <> 0 THEN Exit;
  NumberToItem:=FolderNotFound;
  {Ищем папку folder}
  REPEAT
   ReadLn(INIFile,ts);
   ts:=DeleteComent(ts);
  UNTIL (GetFolderStr(ts,folder) = folder) OR EOF(INIFile);
  {Если папка не найдена, то выходим}
  IF GetFolderStr(ts,folder) <> folder THEN BEGIN
   Close(INIFile);
   Exit;
  END;
  NumberToItem:=ItemNotFound;
  {Ищем метку item}
  ic:=0;
  REPEAT
   ReadLn(INIFile,ts);
   ts:=DeleteComent(ts);
   ts1:=TestItem(ts);
   IF ts1 <> '' THEN Inc(ic);
  UNTIL (ic = nm) OR EOF(INIFile) OR (TestFolder(ts) <> '');
  {Если метка с таким номером не найдена, то выходим}
  IF ic <> nm THEN BEGIN
   Close(INIFile);
   Exit;
  END;
  NumberToItem:=ts1;
  {Закрываем INI файл}
  Close(INIFile);
 END;

{============================================================================}
{==== Функция TotalFolder возвращает количество папок в файле fname.     ====}
{============================================================================}
 FUNCTION TotalFolder(fname: String): Integer;
 VAR ts, ts1: String;
     fc: Integer;
 BEGIN
  fname:=DeleteSpace(fname);
  TotalFolder:=IFileNotFound;;
  {Открываем INI файл}
  Assign(INIFile,fname);
  {$I-}
   Reset(INIFile);
  {$I+}
  IF IOResult <> 0 THEN Exit;
  fc:=0;
  REPEAT
   ReadLn(INIFile,ts);
   ts:=DeleteComent(ts);
   ts1:=TestFolder(ts);
   IF ts1 <> '' THEN Inc(fc);
  UNTIL EOF(INIFile);
  TotalFolder:=fc;
  Close(INIFile);
 END;

{============================================================================}
{==== Функция TotalItem возвращает количество пунктов в папке folder из  ====}
{==== файла fname.                                                       ====}
{============================================================================}
 FUNCTION TotalItem(fname, folder: String): Integer;
 VAR ts, ts1, ts2: String;
     ic: Integer;
 BEGIN
  fname:=DeleteSpace(fname);
  folder:=DeleteSpace(folder);
  TotalItem:=IFolderNotFound;
  IF folder = FolderNotFound THEN Exit;
  TotalItem:=IFileNotFound;
  {Открываем INI файл}
  Assign(INIFile,fname);
  {$I-}
   Reset(INIFile);
  {$I+}
  IF IOResult <> 0 THEN Exit;
  TotalItem:=IFolderNotFound;
  {Ищем папку folder}
  REPEAT
   ReadLn(INIFile,ts);
   ts:=DeleteComent(ts);
  UNTIL (GetFolderStr(ts,folder) = folder) OR EOF(INIFile);
  {Если папка не найдена, то выходим}
  IF GetFolderStr(ts,folder) <> folder THEN BEGIN
   Close(INIFile);
   Exit;
  END;
  TotalItem:=0;
  {Ищем метку item}
  ic:=0;
  REPEAT
   ReadLn(INIFile,ts);
   ts:=DeleteComent(ts);
   ts1:=TestItem(ts);
   IF ts1 <> '' THEN Inc(ic);
  UNTIL EOF(INIFile) OR (TestFolder(ts) <> '');
  TotalItem:=ic;
  {Закрываем INI файл}
  Close(INIFile);
 END;

{============================================================================}
 BEGIN
  FolderComent:='';
  ItemComent:='';
  PreComentLine:='';
  PostComentLine:='';
  FirstString:='';
 END.
{============================================================================}