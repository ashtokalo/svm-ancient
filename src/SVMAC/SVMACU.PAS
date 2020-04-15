{$A+,B+,D-,E-,F+,G+,I-,L-,N+,O+,P+,Q-,R-,S-,T+,V+,X+}
{$M 16384,0,655360}
{============================================================================}
{====--------------------------------------------------------------------====}
{====                      SVM Assembler Compiller                       ====}
{====                            Version  1.2                            ====}
{====                   for IBM AT or 100% compitable                    ====}
{====                 Copyright (C) 1998,99 ShAG Studio                  ====}
{====--------------------------------------------------------------------====}
{====    Этот модуль позволяет компилировать программы написанные на SVM ====}
{==== ассемблере версии 1.1 и 1.2 в исполняемый байт-код виртуальной ма- ====}
{==== шины(SVM).                                                         ====}
{====    Модуль является блоком компилятора и может свободно использова- ====}
{==== ться для написания оболочек, компиляторов с различными интерфейса- ====}
{==== ми. Модуль поставляется в виде файла TPU для каждой из существующ- ====}
{==== их  DOS-версий Turbo Pascal (TM) фирмы  Borland International  для ====}
{==== компьютеров семейства IBM на основе процессора Intel2X86 или выше. ====}
{====    Модуль будет работать только на компьютерах этого семейства или ====}
{==== компьтерах  на 100% совместимых с ними,  как в аппаратном, так и в ====}
{==== програмном смысле  этого слова. Для работы модуля  необходимо, как ====}
{==== минимум:  1 мегабайт оперативной  памяти, жесткий диск с 2-я мега- ====}
{==== байтами свободного  пространства (чем  больше ваши  программы, тем ====}
{==== больше  надо места, если у вас объем памяти больше 1  мегабайт и у ====}
{==== вас стоит драйвер EMS памяти на 100% совместимый с драйвером HIMEM ====}
{==== версии 4.0 и старше, то компилятор будет использовать эту память.  ====}
{====    Вместе  с модулем поставляется  часть исходного кода. Имея этот ====}
{==== файл, вы сможете посмотреть какие процедуры вам доступны, их вход- ====}
{==== ные и выходные параметры с полным коментарием. В файле содержаться ====}
{==== интерфейсная часть файла, заголовок и некоторые процедуры.         ====}
{====--------------------------------------------------------------------====}
{====    Название SVM является зарегистрированным торговым знаком  фирмы ====}
{==== ShAG Studio и расшифровуется как ShAG Virtual Machina, запрещается ====}
{==== использвать это название как имена каких-либо програмных продуктов ====}
{==== или чего нибуть друго.                                             ====}
{====--------------------------------------------------------------------====}
{====    Более  новую информацию  о этом и  других  продуктах фирмы ShAG ====}
{==== Studio вы сможете  получит на сайте  фирмы  www.ShAG.itgo.com  или ====}
{==== прислать запрос на почтовый ящик shag@qnx.com.                     ====}
{====--------------------------------------------------------------------====}
{====    Всю информацию о ошибках найденных в работе модуле,а также ваши ====}
{==== различные предложения,  просьба прысылать на один из известных вам ====}
{==== електронных адресов фирмы.                                         ====}
{====--------------------------------------------------------------------====}
{==== ВНИМАНИЕ!  Модуль не будет работать в защищенном режиме процессора ====}
{==== из-за  некоторых способов  работы с  памятью, которые  использовал ====}
{==== автор при написание модуля виртуальной памяти, который использова- ====}
{==== лся при написании данного модуля.                                  ====}
{====--------------------------------------------------------------------====}
{============================================================================}
                                 UNIT SVMACU;
{============================================================================}
                                  INTERFACE
{============================================================================}

 USES Crt, Dos, SVM_N, Str_Math;
 {Список модулей используемых программой:
   Dos - модуль для работы с дисковыми файлами
   SVM - модуль для работы с памятью
   Str_Math - модуль для работы с большими числами }

 {В результате компиляции можно получить переменную этого типа и узнать
  некоторую информацию о том, как прошел процесс компиляции, эта информация
  возвращается в переменную этого типа}
 TYPE TCRInfo = RECORD
  SourceFileName: String; {Имя исходного файла}
  CodeSize,               {Размер кода}
  DataSize,               {Размер данных}
  StackSize,              {Размер стека}
  TotalMessages,          {Общее количество сообщений}
  TotalStrings,           {Общее количество откомпилированных строк}
  TotalMainStrings,       {Общее количство строк в главном файле}
  InPoint,                {Точка входа в программу}
  OutPoint,               {Точка выхода из программы}
  ErrorString: Comp;      {Номер строки, которая содержит ошибки}
  ErrorChar,              {Номер символа в строке где обнаружена ошибка}
  ErrorNumber: Byte;      {Номер ошибки, 0 - если нет ошибок}
 END;

 {Тип процедуры, которая вызывается каждый раз перед компиляцией очередной
  строки исходного файл.}
 TYPE TInfoProc = PROCEDURE(Sf, Cf: String; TSn, CSn, Pn: LongInt);
  {Sf - Имя исходного файла
   Cf - Имя компилируемого в данный момент файла
   TSn - Общее колличество строк откомпилированных на данный момент
   CSn - Номер строки которая компилируется в данный момент
   Pn - Номер прохода компиляции}

 {Тип процедуры, которая вызывается если при работе модуля или во время
  процесса компиляции возникли какие то фатальные ошибки.}
 TYPE TErrorProc = PROCEDURE(ErrorCode, ErrorChar: Byte; ErrorString: LongInt; ErrorFileName: String);
  {ErrorCode - Код возникшей ошибки
   ErrorChar - Номер символа строки в котором возникла ошибка
   ErrorString - Номер строки файла в которой возникла ошибка
   ErrorFileName - Имя файла в котором возникла ошибка}

 {Тип процедуры, которая вызывается если возникла какая-то ситуация,
  при которой компилятор принимает сам какое-либо решение при этом
  хочет придупредить об этом пользователя}
 TYPE TMessageProc = PROCEDURE(MessageCode: Byte; MessageString: LongInt; MessageFileName: String);
  {MessageCode - Код сообщения
   MessageString - Номер строки файла в которой возникло сообщение
   MessageFileName - Имя файла в котором возникло сообщение}

 {Порядок использования процедур модуля:
   1. Перед каждым процессом компиляции необходимо использовать
      процедуру InitCompiller, она организовует память для работы
      компилятора и инициализирует некоторые переменные, а также
      производит некоторые тестовые проверки.
   2. Для того, чтобы произвести компиляцию файла, необходимо
      запустить процедуру Compiller и в качестве параметра передать
      полное имя компилиреумого файла. Если в процессе компиляции
      возникнет какая-либо ошибка, будет автоматически вызванна
      процедура ErrorCompiller, которая в качестве параметров
      получит полные координаты и описание возникше ошибки. Точно
      так же, если возникнит какая-то плохая ситуация (не ошибка)
      будет вызвана процедура MessageCompiller, которая в качестве
      параметров получит аналогичные данные.
   3. После компиляции, если не возникло никаких ощибок, вы можете
      сохранить результат компиляции в файл или в виртуальлную память.
      Для того чтобы сохранить результат в файл, необходимо выполнить
      процедуру SaveResultToFile, которой в качестве параметра надо
      передать имя файла, под которым вы хотите его сохранить. Если
      на диске нехватит места или возникнет еще какая-то дисковая
      ошибка, процедура вернет ошибку через команду ErrorCompiller и
      вернется в вызвавшую программу. Если вы хотите получит результат
      компиляции в виртуальную память, то вы должны вызвать процедуру
      SaveResultToSVM, которой в качестве параметров необходимо передать
      переменню для работы с виртуальной памяти, типа OVector, в которой
      будет сохранен результат компиляции в виде одномерного массива.
      В обоих случаях результат будет возвращен в виде собранного кода
      готового для сохранения, согласно версии SVM 1.1.
   4. После каждого процесса компиляции, необходимо выполнять
      процедуру DoneCompiller, которая освободит всю занятую
      компилятором память, сбросит некоторые настройки. После
      того как вы выполните этот шаг, вы потеряете результат
      компиляции, т.е. уже не сможете его сохранить в какомбы-то
      небыло виде}

 PROCEDURE InitCompiller;               {Потготовка компилятора и памяти к работе}
 PROCEDURE Compiller(FileName: String); {Компилировать файл}
 PROCEDURE SaveMapFile(map_type: byte); {Сохранить карту памяти}
 PROCEDURE SaveResultToFile(FileName: String); {Сохранить результат компиляции в файл}
 PROCEDURE SaveResultToSVM(VAR Discriptor: OVector); {Сохранить результат компиляции в виртуальной памяти}
 PROCEDURE GetResultInfo(VAR CRInfo: TCRInfo); {Получит информацию о компиляции}
 PROCEDURE DoneCompiller;               {Освободит всю виртуальнюю память, которая использовалась компилятором}

 VAR SourceDirectories,          {Каталог в котором находится исходный файл}
     IncludeDirectories,         {Каталог в котором находятся подключаемые файлы}
     ResultDirectories,          {Каталог в который будет сохранен результат компиляции}
     MapDirectories,             {Каталог в который будет сохранена карта памяти}
     MainFileName: String;       {Имя исходного файла без расширения}
     ShowCompillInfo: TInfoProc; {Процедура вызывается перед компиляцией
                                  каждой строки}
     ErrorCompiller: TErrorProc; {Процедура вызывается при возникновении
                                  ошибок, после исполнения этой процедуры,
                                  управление должно вернуться назад, т.к.
                                  программа должна кое-что доделать}
     MessageCompiller: TMessageProc; {Процедура вызывается каждый раз, когда
                                      возникает какая-то ~двоякая~ ситуация
                                      и компилятор хочет сообщит о ней}
 CONST CompillerStatus: Byte = 2; {Результат компиляции файл:
                                    0 - Ошибок нет, компиляция прошла успешно
                                    1 - Ошибка компиляции
                                    2 - Компилятор не инициализирован
                                        (не потготовлен к работе), надо
                                        использовать команду InitCompiller
                                    3 - Компилятор не деинициализирован
                                        (не закрыт после работы), надо
                                        использовать команду DoneCompiller
                                    4 - Компилятор готов к работе
                                    5 - Ошибок нет, но отсутствует точка
                                        входа и точка выхода из программы,
                                        поэтому эта программа неможет быть
                                        сохраненной в исполняемый файл}
       Compiller_NoError = 0;  {Ошибок нет, компиляция прошла успешно}
       Compiller_Error = 1;    {Ошибка компиляции}
       Compiller_NoInit = 2;   {Компилятор не инициализирован}
       Compiller_NoDone = 3;   {Компилятор не деинициализирован}
       Compiller_Wait = 4;     {Компилятор готов к работе}
       Compiller_NoSF = 5;     {Нет точки входа и точки выхода}
       No_map = 255;           {Не генерировать карту памяти}
       Detailed_map = 0;       {Детальная карта памяти}
       Procedures_and_labels_map = 1; {Только процедуры и метки}
       Variables_map = 2;      {Только переменные}
       MapMessages: ARRAY [0..18] OF String[50] = (
        'Procedures:    ',
        'Labels:        ',
        'Variables:     ',
        'Entry point:   ',
        'Finish point:  ',
        'Code size:     ',
        'Data size:     ',
        'Include files: ',
        'Stack size:    ',
        'Address:       ',
        'This program has not procedures.',
        'This program has not labels.',
        'This program has not variables.',
        'This program has not stack.',
        'This program has not entry point.',
        'This program has not finish point.',
        'This program has not include files.',
        'bytes',
        'Total lines:   ');
       SVMErrors: ARRAY [0..41] OF String[50] = (
{Number  Error text}
{0}     'No errors.',{Нет ошибок}
{1}     'File not found.',{Файл не найден}
{2}     'Not enother room to creat byte-code file.',{Нет места для создания файла байт кода}
{3}     'Not enother room to creat swap file.',{Нет места для создания файла подкачки}
{4}     'Virtual Memory Manager mast be initializat.',{Виртуальная память должна быть инициализированна}
{5}     'This program need coprocessor.',{Этой программе нужен сопроцессор}
{6}     'This processor not support.',{Этот процессор не потдерживается}
{7}     'Disk full.',{Диск полный}
{8}     'This program need hard drive.',{Этой программе нужен жесткий диск}
{9}     'Not enother memory to Virtual Memory Manager.',{Нехватает памяти для работы виртуальной памяти}
{10}    'Syntax error.',{Синтаксическая ошибка}
{11}    'Constant out of range.',{Число вышло за пределы допустимых значений}
{12}    'Unknown identifier.',{Неизвестный определитель}
{13}    'Number mast be bigger than 0 or equally 0.',{Число должно быть больше или равно нулю}
{14}    'In this place you mast use registers only.',{Здесь можно использовать только регистр}
{15}    'In this place you mast use number only.',{Здесь можно использовать только число}
{16}    'In this place you mast use adres.',{Здесь можно использовать только адрес}
{17}    'In this place you mast use registers or number.',{Здесь можно использовать регистр или число}
{18}    'After "+" you mast use registers only.',{После "+" должен быть регистр}
{19}    'This command have not operands.',{Эта команда не имеет параметров}
{20}    'This command have one operands.',{Эта команда имеет один параметр}
{21}    'This command have two operands.',{Эта команда имеет два параметра}
{22}    'This word reserved for SVM commands.',{Это слово зарезервированно для команд SVM}
{23}    'This word reserved for SVM registers.',{Это слово зарезервированно для регистров SVM}
{24}    'This word reserved for control words.',{Это слово зарезервированно для управляющих процессом компиляции слов}
{25}    'Wrong sign in name.',{Неправельный символ в имени}
{26}    'Variable already defined.',{Переменная уже определена}
{27}    'Procedure already defined.',{Процедура уже определена}
{28}    'Local label already defined.',{Локальная метка уже определена}
{29}    'Global label already defined',{Глобальная метка уже определена}
{30}    'EQUs already defined.',{Константа уже определена}
{31}    'Stack size already defined',{Зармер стека уже определен}
{32}    '"[" expected.',{"[" отсутствует}
{33}    '"]" expected.',{"]" отсутствует}
{34}    'End of string not found.',{Конец строки не найден}
{35}    'Unexpected end of file (file mast be finished END).',{Конец файла не найден}
{36}    'START: not found.',{START не найде}
{37}    'FINISH: not found.',{FINISH не найден}
{38}    'This file can not compil into SVM bytecode.',{Этот файл не может быть откомпилированн в SVM байткод}
{39}    'Default stack size equally 16384 bytes.', {Размер стека по умолчанию равен 16384 байт}
{40}    'Type pointer expected. Default type pointer - BYTE.',{Указатель типа отсутствует. По умолчанию - BYTE}
{41}    'Can not creat file.');{Невозможно создать новый файл}
{============================================================================}
                                IMPLEMENTATION
{============================================================================}
 {Все что следует после этого не является полной копией модуля и
  предназначено для лучшего понимания работы модуля, это замечание
  относится к этому тексту только в том случае, если вы читаете свободно
  распространяемую версию файла SVMACU.PAS которая идет в комплекте с
  модулями BINPASU.TPU для различных DOS-версий Turbo Pascal (TM) фирмы
  Borland International}

 TYPE TAddrLabel = RECORD
      Name: String;   {Имя метки}
      Addr: Comp;     {Адрес метки}
 END;

 TYPE TVarName = RECORD
      Name: String;   {Имя переменной}
      Addr: Comp;     {Адрес переменной}
      Mode: Byte;     {Тип переменной: 0 - DB, 1 - DW, 2 - DDW, 3 - DQW, 4 - переменная пользователя}
 END;

 TYPE TResultFile = RECORD
  CASE Byte OF
  1: (
  SVM: String[3];
  Version: Byte;
  CodeSize,
  DataSize,
  StackSize,
  StartCode,
  StartData,
  CodefSize,
  DatafSize,
  EntryPoint,
  FinishPoint: Comp; );
  2: (Item: ARRAY [0..76] OF Byte );
 END;


 VAR CStatus: Byte ABSOLUTE CompillerStatus;
     CompilInfo: TCRInfo;
     StackPresent: Boolean;
     ev, Path, adr: Byte;
     N, N1, TotalPS, CC: Word;
     ErrorVal, Key: Integer;
     TCLine, FirstL, LastL, LCount, MessageCounter: LongInt;
     InPoint, OutPoint, CodeCounter, DataCounter, StackSize, DataSize: Comp;
     SourceFileName, CreatFileName, tempstr, CString: String;
     ParamStrS: ARRAY [1..20] OF String;
     SourceFile: Text;
     CreatFile: FILE OF Byte;
     CodePRG, DataPRG, ProcAddrLabel, VarAddr, VarMode, LocalAddrLabel,
     GlobalAddrLabel, FirstLabel, LastLabel: OVector;
     EQUs, EQUd, ProcNameLabel, VarName, LocalNameLabel,
     GlobalNameLabel,Includes: OStrings;
     TempV: TVarName;
     Result: File OF Byte;
     FileTitle: TResultFile;

 VAR SStr, strr, tstr, tstr2, ts: String;
     dt, FirstWord, isize, t, CodeByte, fr1, fr2, sr1, sr2, fw, fp1, fp2,
     sp1, sp2, fm, sm, WorkStatus: Byte;
     n4,n5:LongInt;
     n3,n2: Comp;
     b: ARRAY [0..15] OF Byte ABSOLUTE n3;
     n3i: Integer ABSOLUTE n3;
     n3l: LongInt ABSOLUTE n3;
     fv: ARRAY [0..1] OF Comp;
     sv: ARRAY [0..1] OF Comp;
     fvb: ARRAY [0..15] OF Byte ABSOLUTE fv;
     svb: ARRAY [0..15] OF Byte ABSOLUTE sv;
     svi: Integer ABSOLUTE sv;
     svl: LongInt ABSOLUTE sv;
     fvi: Integer ABSOLUTE fv;
     fvl: LongInt ABSOLUTE fv;
     Info: TCRInfo;

 CONST SVMComType: ARRAY [0..60] OF Byte = (1,2,4,5,4,3,4,4,4,1,1,1,1,1,6,6,6,
       10,6,6,6,6,6,7,7,0,5,10,8,8,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0,
       0,0,0,0,0,0,0,0,0); {Код согласования команда - параметры}
       SVMRegistersName: ARRAY [0..40] OF String[3] = (
       'AL','AH','BL','BH','CL','CH','DL','DH','AX','BX','CX','DX','SS','FS',
       'SP','IP','EP','FP','GP','EAX','EBX','ECX','EDX','ESS','EFS','ESP','EIP',
       'EEP','EFP','EGP','LAX','LBX','LCX','LDX','LSS','LFS','LSP','LIP','LEP',
       'LFP','LGP'); {Имена всех регистров SVM}
       SVMCommandName: ARRAY [0..60] OF String[5] = (
       'MOV','MOVS','PUSH','PUSH','POP','XCHG','INC','DEC','NEG','ADD','SUB',
       'MUL','DIV','CMP','AND','OR','XOR','NOT','RCL','RCR','SHL','SHR','TEST',
       'CALL','JMP','RET','CSP','CSP','JRNZ','JRZ','JO','JZ','JS',
       'JC','JP','JA','JE','JG','JL','JNO','JNZ','JNS','JNC','JNP','JNA','JNE',
       'JNG','JNL','CLO','CLS','CLZ','CLC','CLP','CLA','STO','STS','STZ','STC',
        'STP','STA','NOP'); {Имена всех команд SVM}
       ASMWord: ARRAY [0..18] OF String [8] = ({Имена управляющих команд}
       'DB','DW','DD','DQ','BYTE','WORD','DWORD','QWORD','PROGRAM','LIBRARY',
       'DLIBRARY','STACK','INCLUDE','DATA','CODE','END','PROC','EQU','DUP');
       ComentSign = ';'; {Знак начала коментария}
       OpenSign = '[';   {Знак открывающий указатель памяти}
       CloseSign = ']';  {Знак закрывающий указатель памяти}
       LocalSign = '@';  {Знак указывающий, что эта метка локальная}
       LabelSign = ':';  {Знак указывающий, что это метка}
       StartSign = 'START';  {Точка входа в программу}
       FinishSign = 'FINISH';{Точка выхода}
       StdNo = #0#1#2#3#4#5#6#7#8#9#10#11#12#13#14#15#16#17#18#19#20#21#22#23#24#25#26#27#28#29#30#31;
       StrByte = 0;      {Число является типом Byte}
       StrWord = 50;      {Число является типом Word}
       StrInteger = 1;   {Число является типом Integer}
       StrLongInt = 2;   {Число является типом LongInt}
       StrComp = 3;      {Число является типом Copm}

 {Пустая процедура предназначенна для использования процедур
  индикации процесса компиляции по умолчанию.}
 PROCEDURE FreeProcedure;
 BEGIN
 END;

 PROCEDURE InitCompiller;  {Подготовка компилятора и памяти к работе}
 BEGIN
  IF CStatus <> Compiller_NoInit THEN CStatus:=Compiller_NoDone;;
  IF WorkStatus = 0 THEN Exit;
  InPoint:=-1;
  OutPoint:=-1;
  MessageCounter:=0;
  StackSize:=16384;
  StackPresent:=FALSE;
  EQUs.Init(1,255);                    {Инициализируем масcив определений}
  EQUd.Init(1,255);
  ProcNameLabel.Init(1,255);           {Инициализируем маcсив процедур}
  ProcAddrLabel.Init(5000,SizeOf(Comp));
  VarName.Init(1,255);                 {Инициализируем маcсив переменных}
  VarAddr.Init(5000,SizeOf(Comp));
  VarMode.Init(5000,1);
  LocalNameLabel.Init(1,255);          {Инициализируем маcсив локальных меток}
  LocalAddrLabel.Init(5000,SizeOf(Comp));
  GlobalNameLabel.Init(1,255);         {Инициализируем маcсив глобальных меток}
  GlobalAddrLabel.Init(5000,SizeOf(Comp));
  FirstLabel.Init(5000,SizeOf(LongInt));
  LastLabel.Init(5000,SizeOf(LongInt));
  CodePRG.Init(65536,1);               {Инициализация памяти для хранения кода}
  DataPRG.Init(65536,1);               {Инициализация памяти для хранения данных}
  Includes.Init(1,255);                 {Инициализируется массив имен подключаемых файлов}
  CodeCounter:=0;
  DataSize:=0;
  DataCounter:=0;
  FirstL:=0;
  LastL:=1;
  LCount:=0;
  FirstL:=0;
  LastL:=1;
  LCount:=0;
  CodeCounter:=0;
  WorkStatus:=0;
  Info.SourceFileName:='No file name';
  Info.CodeSize:=0;
  Info.DataSize:=0;
  Info.StackSize:=0;
  Info.TotalMessages:=0;
  Info.TotalStrings:=0;
  Info.TotalMainStrings:=0;
  Info.InPoint:=-1;
  Info.OutPoint:=-1;
  Info.ErrorString:=0;
  Info.ErrorChar:=0;
  Info.ErrorNumber:=1;
  WorkStatus:=0;
  CStatus:=Compiller_Wait;
 END;

{============================================================================}
{==== Набор процедур по работе со строками                               ====}
{============================================================================}
 FUNCTION StrGetType(a: String): Byte;
 VAR t,r: Byte;
 BEGIN
  r:=StrUnknown;
  IF StrCMP(a,'9223372036854775808') = BG THEN
  IF StrCMP(a,'-9223372036854775809') = AG THEN BEGIN
   r:=StrComp;
   IF StrCMP(a,'2147483648') = BG THEN
   IF StrCMP(a,'-2147483649') = AG THEN BEGIN
    r:=StrLongInt;
    IF StrCMP(a,'32768') = BG THEN
    IF StrCMP(a,'-32769') = AG THEN BEGIN
     r:=StrInteger;
     IF StrCMP(a,'256') = BG THEN
     IF StrCMP(a,'-1') = AG THEN r:=StrByte;
    END;
   END
  END ELSE r:=StrUnknown;
  StrGetType:=r;
 END;

 PROCEDURE StrToValue(a: String; VAR value; VAR t: Byte);
 VAR Sign: Boolean;
     tc: Comp ABSOLUTE value;
     tcc: Comp;
     b: Byte ABSOLUTE tcc;
     ttc,ttcc, lv: Comp;
     n,n1,ss: Integer;
     tt: Byte;
 BEGIN
  Sign:=False; {+}
  t:=StrGetType(a);
  tc:=0;
  IF t = StrUnknown THEN Exit;
  IF a[1]='-' THEN BEGIN Sign:=True; Delete(a,1,1); END; {-}
  ss:=Length(a);
  ttcc:=1;
  FOR n1:=1 TO ss DO ttcc:=ttcc*10;
  FOR n:=1 TO ss DO BEGIN
   ttcc:=ttcc/10;
   tcc:=ttcc*(Ord(a[n])-48);
   tt:=t;
   t:=StrError;
  IF (a[n] < '0') OR (a[n] > '9') THEN Exit;
   t:=tt;
   tc:=tc+tcc;
  END;
  IF Sign THEN tc:=-tc;
 END;

 PROCEDURE StrValueTo(VAR value; t: Byte; VAR a: String);
 VAR tc: Comp ABSOLUTE value;
     tl: LongInt ABSOLUTE value;
     tw: Word ABSOLUTE value;
     ti: Integer ABSOLUTE value;
     tb: Byte ABSOLUTE value;
     ts: String;
     tcc: Comp;
     b: Byte ABSOLUTE tcc;
     ttc,ttcc, lv: Comp;
     n,n1: Integer;
 BEGIN
  lv:=tc;
  a:='';
  IF (tc < 0) AND (t = StrComp) THEN a:=a+'-';
  IF t < StrComp THEN BEGIN
   CASE t OF
    StrByte: Str(tb, ts);
    StrWord: Str(tw, ts);
    StrInteger: Str(ti, ts);
    StrLongInt: Str(tl, ts);
   END;
   a:=ts;
  END ELSE BEGIN
   {Тип Comp}
   tc:=ABS(tc);
   n:=18;
   ts:='';
   ttcc:=10*10*10*10*10*10*10*10*10;
   ttcc:=ttcc*10*10*10*10*10*10*10*10*10;
   REPEAT
    tcc:=ttcc;
    ttc:=tcc;
    tcc:=Trunc(tc/tcc);
    ts:=ts+Chr(b+48);
    tc:=tc-(b)*ttc;
    Dec(n);
    ttcc:=ttcc/10;
   UNTIL n = -1;
   n:=0;
   REPEAT
    Inc(n);
   UNTIL ts[n] <> '0';
   Delete(ts,1,n-1);
   a:=a+ts;
  END;
  tc:=lv;
 END;

 {Функция возвращает строку с большими буквами}
 FUNCTION UpString(s:String):String;
 VAR n,n1,n2:Word;
     ls: Byte ABSOLUTE s;
 BEGIN
  UpString:='';
  IF {Length(s)} ls = 0 THEN Exit;
  n:=0;
  REPEAT
   Inc(n);
   S[n]:=UpCase(S[n]);
  UNTIL (n = {Length(S)}ls) OR (S[n] = #39) OR (S[n] = '"');
  n2:={Length(S)}ls+1;
  REPEAT
   Dec(n2);
   S[n2]:=UpCase(S[n2]);
  UNTIL (n2 = n) OR (S[n2] = S[n]);
  UpString:=s;
 END;

 {Функция возвращает TRUE если один из символов str2 встречается в str}
 FUNCTION TestStr(str, str2: String): Boolean;
 VAR t: Byte;
 BEGIN
  TestStr:=False;
  FOR t:=1 TO Length(str2) DO
   IF Pos(str2[t],str) <> 0 THEN BEGIN
    TestStr:=True;
    Exit;
   END;
 END;

 {Функция возвращает количество слов в строке, слова разделяются символами из переменной str2}
 FUNCTION TotalWords(str, str2: String): Byte;
 VAR t,c:byte;
     w:Byte;
 BEGIN
  c:=0;
  w:=1;
  FOR t:=1 TO Length(str) DO BEGIN
   IF Pos(str[t],str2) <> 0 THEN str[t]:=#0;
   IF str[t] <> #0 THEN BEGIN
    c:=c+w;
    w:=0;
   END ELSE w:=1;
  END;
  TotalWords:=c;
 END;

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

 {Функция возвращает True если в строке имется указаное слово}
 FUNCTION TestWord(str,str2: String; SubStr: String): Boolean;
 VAR t,tw: Byte;
     ls: Byte ABSOLUTE SubStr;
     ts: String;
 BEGIN
  TestWord:=False;
  tw:=Pos(SubStr,str);
  IF tw = 0 THEN Exit;
{  ls:=Length(SubStr);}
  IF ((Pos(str[tw-1],str2) <> 0) OR (tw-1 < 1)) AND
     ((Pos(str[tw+ls+1],str2) <> 0) OR (tw+ls+1 > Length(str))) THEN TestWord:=True;
{  tw:=TotalWords(Str,str2);
  IF tw > 0 THEN BEGIN
   t:=0;
   REPEAT
    Inc(t);
    ts:=GetWord(str,str2,t);
   UNTIL (ts = SubStr) OR (t = tw);
   IF ts = SubStr THEN TestWord:=True;
  END;}
{   FOR t:=1 to tw DO
    IF GetWord(str,str2,t) = SubStr THEN TestWord:=True;}
 END;

 {Функция удаляет коментарий из строки (все что после знака ComentSign)}
 FUNCTION DeleteComent(str: String): String;
 VAR n, n2: byte;
     sln: byte ABSOLUTE str;
     op1,op2: Boolean;
     s: String;
 BEGIN
  op1:=FALSE;
  op2:=FALSE;
  s:='';
  DeleteComent:='';
  FOR n:=1 TO sln DO BEGIN
   IF (str[n] = '"') AND NOT op2 THEN op1:=NOT op1;
   IF (str[n] = #39) AND NOT op1 THEN op2:=NOT op2;
   IF (str[n] = ComentSign) AND NOT op1 AND NOT op2 THEN Exit;
   s:=s+str[n];
   DeleteComent:=s;
  END;
 END;

 {Функция проверяет слово на присутствие в нем запрещенных сиволов,
  если такие имеются, то возвращается номер символа}
 FUNCTION  TestName(str:String): Byte;
 VAR n: Byte;
 BEGIN
  TestName:=0;
  FOR n:=1 TO Length(str) DO
   IF NOT ((Ord(Str[n]) IN [65..91]) OR (Ord(Str[n]) IN [97..123]) OR
      ((n <> 1) AND (Ord(Str[n]) IN [48..57])) OR (Str[n] = '_'))
   THEN {TestName:=0 ELSE}
   BEGIN
    TestName:=n;
    Exit;
   END;
 END;

 {Функция возвращает строку содержащююся в кавычках одинарного или двойного типа}
 FUNCTION  GetStrNoBorder(Str: String): String;
 VAR n,t,t2: byte;
     s: String;
 BEGIN
  {Получаем начало строки}
  IF Pos(#39,Str) < Pos('"',Str) THEN t:=Pos(#39,Str) ELSE t:=Pos('"',Str);
  IF Pos(#39,Str) = 0 THEN t:=Pos('"',Str);
  IF Pos('"',Str) = 0 THEN t:=Pos(#39,Str);
  n:=Length(Str)+1;
  REPEAT
   Dec(n);
  UNTIL (n=1) OR (Str[n]=Str[t]);
  ErrorVal:=1;
  Inc(t);
  Dec(n);
  IF n < t+1 THEN Exit;
  t2:=n;
  ErrorVal:=0;
  s:='';
  FOR n:=t TO t2 DO s:=s+str[n];
  GetStrNoBorder:=s;
 END;
{============================================================================}
{==== Набор процедур по работе со строками                               ====}
{============================================================================}

{============================================================================}
{==== Набор процедур для работы с массивами в виртуальной памяти - EQUs, ====}
{==== LocalAddrLabel, AddrLabel, ProcLabel, VarLabel                     ====}
{============================================================================}
 {Получить количество записей}
 FUNCTION  GetEQUIndex: LongInt;
 BEGIN
  GetEQUIndex:=EQUs.TotalStrings-1;
 END;
 {Получит определение из списка по его номеру}
 FUNCTION  GetEQU(i: LongInt): String;
 VAR  T: TAddrLabel;
 BEGIN
  GetEQU:=EQUs.Get(i);
 END;
 FUNCTION  GetEQUd(i: LongInt): String;
 VAR  T: TAddrLabel;
 BEGIN
  GetEQUd:=EQUd.Get(i);
 END;
 {Добавить определение в список определений}
 PROCEDURE AddEQU(str: String);
 BEGIN
  EQUs.Add(str);
 END;
 PROCEDURE AddEQUd(str: String);
 BEGIN
  EQUd.Add(str);
 END;
 {Очистить список определений}
 PROCEDURE FreeEQU;
 BEGIN
  EQUs.ReSize(1,255);
  EQUd.ReSize(1,255);
 END;
 {Получить количество записей}
 FUNCTION  GetLLIndex: LongInt;
 BEGIN
  GetLLIndex:=LocalNameLabel.TotalStrings-1;
 END;
 {Очистить список локальных адресов}
 PROCEDURE FreeLL;
 BEGIN
  WITH LocalNameLabel DO BEGIN
   TotalStrings:=1;
  END;
 END;
 {Получить количество записей}
 FUNCTION  GetGLIndex: LongInt;
 BEGIN
  GetGLIndex:=GlobalNameLabel.TotalStrings-1;
 END;
 {Очистить список глобальных адресов}
 PROCEDURE FreeGL;
 BEGIN
  WITH GlobalNameLabel DO BEGIN
   ReSize(1,ElementSize);
  END;
 END;
 {Получить количество записей}
 FUNCTION  GetPLIndex: LongInt;
 BEGIN
  GetPLIndex:=ProcNameLabel.TotalStrings-1;
 END;
 {Очистить список процедур}
 PROCEDURE FreePL;
 BEGIN
  ProcNameLabel.ReSize(1,255);
 END;
 {Получить количество записей}
 FUNCTION  GetVIndex: LongInt;
 BEGIN
  GetVIndex:=VarName.TotalStrings-1;
 END;
 {Добавить переменную в список переменных}
 PROCEDURE AddV(pl: TVarName);
 BEGIN
  VarName.Add(pl.Name);
  VarAddr.PutC(GetVIndex,pl.Addr);
  VarMode.PutB(GetVIndex,pl.Mode);
 END;
 {Очистить список переменных}
 PROCEDURE FreeV;
 BEGIN
  WITH VarName DO BEGIN
   ReSize(1,ElementSize);
  END;
 END;
 PROCEDURE AddCodeByte(b: Byte);
 BEGIN
  CodePRG.PutB(CodeCounter,b);
  CodeCounter:=CodeCounter+1;
 END;
 PROCEDURE AddCodeWord(b: Word);
 VAR w: ARRAY [0..1] OF Byte ABSOLUTE b;
 BEGIN
  CodePRG.PutB(CodeCounter,w[0]);
  CodePRG.PutB(CodeCounter+1,w[1]);
  CodeCounter:=CodeCounter+2;
 END;
 PROCEDURE AddCodeLongInt(b: LongInt);
 VAR w: ARRAY [0..3] OF Byte ABSOLUTE b;
 BEGIN
  CodePRG.PutB(CodeCounter,w[0]);
  CodePRG.PutB(CodeCounter+1,w[1]);
  CodePRG.PutB(CodeCounter+2,w[2]);
  CodePRG.PutB(CodeCounter+3,w[3]);
  CodeCounter:=CodeCounter+4;
 END;
 PROCEDURE AddCodeComp(b: Comp);
 VAR w: ARRAY [0..7] OF Byte ABSOLUTE b;
 BEGIN
  CodePRG.PutB(CodeCounter,w[0]);
  CodePRG.PutB(CodeCounter+1,w[1]);
  CodePRG.PutB(CodeCounter+2,w[2]);
  CodePRG.PutB(CodeCounter+3,w[3]);
  CodePRG.PutB(CodeCounter+4,w[4]);
  CodePRG.PutB(CodeCounter+5,w[5]);
  CodePRG.PutB(CodeCounter+6,w[6]);
  CodePRG.PutB(CodeCounter+7,w[7]);
  CodeCounter:=CodeCounter+8;
 END;
 PROCEDURE AddDataByte(b: Byte);
 BEGIN
  DataPRG.PutB(DataCounter,b);
  DataCounter:=DataCounter+1;
 END;
 PROCEDURE AddDataWord(b: Word);
 VAR w: ARRAY [0..1] OF Byte ABSOLUTE b;
 BEGIN
  DataPRG.PutB(DataCounter,w[0]);
  DataPRG.PutB(DataCounter+1,w[1]);
  DataCounter:=DataCounter+2;
 END;
 PROCEDURE AddDataLongInt(b: LongInt);
 VAR w: ARRAY [0..3] OF Byte ABSOLUTE b;
 BEGIN
  DataPRG.PutB(DataCounter,w[0]);
  DataPRG.PutB(DataCounter+1,w[1]);
  DataPRG.PutB(DataCounter+2,w[2]);
  DataPRG.PutB(DataCounter+3,w[3]);
  DataCounter:=DataCounter+4;
 END;
 PROCEDURE AddDataComp(b: Comp);
 VAR w: ARRAY [0..7] OF Byte ABSOLUTE b;
 BEGIN
  DataPRG.PutB(DataCounter,w[0]);
  DataPRG.PutB(DataCounter+1,w[1]);
  DataPRG.PutB(DataCounter+2,w[2]);
  DataPRG.PutB(DataCounter+3,w[3]);
  DataPRG.PutB(DataCounter+4,w[4]);
  DataPRG.PutB(DataCounter+5,w[5]);
  DataPRG.PutB(DataCounter+6,w[6]);
  DataPRG.PutB(DataCounter+7,w[7]);
  DataCounter:=DataCounter+8;
 END;

{============================================================================}
{==== Набор процедур для работы с массивами в виртуальной памяти - EQUs, ====}
{==== LocalAddrLabel, AddrLabel, ProcLabel, VarLabel                     ====}
{============================================================================}

 {Функция проверяет является ли слово командой SVM}
 FUNCTION TestCommandWord(Str: String): Byte;
 VAR n: Byte;
 BEGIN
  TestCommandWord:=255;
  FOR n:=0 TO 60 DO IF Str = SVMCommandName[n] THEN
   BEGIN TestCommandWord:=n; Exit; END;
 END;

 {Функция проверяет является ли слово регистром SVM}
 FUNCTION TestRegistersWord(Str: String): Byte;
 VAR n: Byte;
 BEGIN
  TestRegistersWord:=255;
  FOR n:=0 TO 40 DO IF Str = SVMRegistersName[n] THEN
   BEGIN TestRegistersWord:=n; Exit; END;
 END;


 {Функция проверяет является ли слово зарезервированным}
 FUNCTION TestSystemWord(str: String): Boolean;
 VAR n: Word;
 LABEL ex;
 BEGIN
  TestSystemWord:=True;
  FOR n:=0 TO 40 DO IF str = SVMRegistersName[n] THEN GOTO ex;
  FOR n:=0 TO 60 DO IF str = SVMCommandName[n] THEN GOTO ex;
  FOR n:=0 TO 18 DO IF str = ASMWord[n] THEN GOTO ex;
  TestSystemWord:=False;
  ex:
 END;

 {Функция проверяет есть ли такое слово среди имен переменных}
 FUNCTION TestVarWord(str: String): LongInt;
 VAR n, i: LongInt;
 BEGIN
  i:=GetVIndex;
  TestVarWord:=0;
  IF i > 0 THEN FOR n:=1 TO i DO
   IF Str = VarName.Get(n) THEN BEGIN TestVarWord:=n; Exit; END;
 END;

 {Функция проверяет есть ли такое слово среди имен определений}
 FUNCTION TestEQUWord(str: String): LongInt;
 VAR n, i: LongInt;
 BEGIN
  i:=GetEQUIndex;
  TestEQUWord:=0;
  IF i > 0 THEN FOR n:=1 TO i DO
   IF Str = GetEQU(n) THEN BEGIN TestEQUWord:=n; Exit; END;
 END;

 {Функция проверяет есть ли такое слово среди имен процедур}
 FUNCTION TestProcWord(str: String): LongInt;
 VAR n, i: LongInt;
 BEGIN
  TestProcWord:=0;
  i:=GetPLIndex;
  IF i > 0 THEN FOR n:=1 TO i DO
   IF Str = ProcNameLabel.Get(n) THEN BEGIN TestProcWord:=n; Exit; END;
 END;

 {Функция проверяет есть ли такое слово среди имен меток}
 FUNCTION TestGLabelWord(str: String): LongInt;
 VAR n, i: LongInt;
 BEGIN
  TestGLabelWord:=0;
  i:=GetGLIndex;
  IF i > 0 THEN FOR n:=1 TO i DO
  IF Str = GlobalNameLabel.Get(n) THEN BEGIN TestGLabelWord:=n; Exit; END;
 END;

 {Функция проверяет есть ли такое слово среди имен меток}
 FUNCTION TestLLabelWord(str: String): LongInt;
 VAR n, i: LongInt;
 BEGIN
  TestLLabelWord:=0;
  i:=FirstL+LastL;
  IF i > 0 THEN FOR n:=FirstL TO i-1 DO
   IF Str = LocalNameLabel.Get(n) THEN BEGIN TestLLabelWord:=n; Exit; END;
 END;

 {Функция проверяет есть ли такое слово среди имен подключенных файлов}
 FUNCTION TestIncludesWord(str: String): LongInt;
 VAR n, i: LongInt;
 BEGIN
  TestIncludesWord:=0;
  i:=Includes.TotalStrings-1;
  IF i > 0 THEN FOR n:=1 TO i DO
   IF Str = Includes.Get(n) THEN BEGIN TestIncludesWord:=n; Exit; END;
 END;

 {Функция возвращает в строке адрес переменной, процедуры или метки если такие есть}
 FUNCTION GetStrValFrom(ts: String): String;
 VAR n,addr: LongInt;
     s,s1: String;
     c: Comp;
     b: Byte;
 BEGIN
  s:=ts;
  s1:=s;
  n:=TestVarWord(ts);
  IF n > 0 THEN addr:=VarAddr.GetL(n);
  IF n = 0 THEN BEGIN n:=TestGLabelWord(ts);
   IF n > 0 THEN addr:=GlobalAddrLabel.GetL(n);
  END;
  IF n = 0 THEN BEGIN n:=TestLLabelWord(ts);
   IF n > 0 THEN addr:=LocalAddrLabel.GetL(n);
  END;
  IF n = 0 THEN BEGIN n:=TestProcWord(ts);
   IF n > 0 THEN addr:=ProcAddrLabel.GetL(n);
  END;

  IF n <> 0 THEN Str(addr,s);
  c:=2147483647;
  c:=c*4;
  IF (Path = 1) AND (StrGetType(s1) > StrComp) {Формируем максимальный}
     THEN StrValueTo(c,StrComp,s);         {адрес для первого прохода}
   GetStrValFrom:=s;
 END;

 {Процедура возвращает число из строки.
  Число  может быть записанно в десятичном  виде, шестнадцатеричном (при этом
  первым символом числа должен быть символ $ - доллара или последним символом
  числа должна быть буква h ), так же число может быть представленно в двоич-
  ном виде (при этом последним символом  числа должна быть буква b ), в любом
  формате  записи если первый  символ равен - минусу,  то знак числа делается
  отрицательным, если вместо числа передается определение то берется значение
  определения с учетом знака минуса перед определением}
 FUNCTION  GetValue(str: String): Comp;
 VAR   r: Comp;
       b: Byte;
       n,n3: LongInt;
       n1,n2: Comp;
       Min: Boolean;
       str2,lstr:String;
 CONST T: ARRAY [1..6] OF String[2] = ('10','11','12','13','14','15');
 BEGIN
  {Проверяем на присутствие знака точки}
  GetValue:=0;
  ErrorVal:=1;
  IF Pos('.',Str) <> 0 THEN Exit;
  {Проверяем на знак минуса}
  Min:=False;
  IF str[1] = '-' THEN Min:=NOT Min;
  IF Min THEN Delete(str,1,1);
  {Проверяем является ли это число определением}
  IF TestEQUWord(Str) > 0 THEN Str:=GetEQUd(TestEQUWord(Str));
  lstr:=str;
  Str:=GetStrValFrom(Str);
  IF lstr <> Str THEN adr:=1 ELSE adr:=0;
   {Проверяем на знак минуса}
  IF str[1] = '-' THEN BEGIN
   Min:=NOT Min;
   Delete(str,1,1);
  END;
  {Проверка формата записи}
  IF (str[Length(str)] = 'H') OR (str[1] = '$') THEN BEGIN
   {Шестнадцатеричное число}
   {Удаляем указатель на тип числа}
   IF str[Length(str)] = 'H' THEN Delete(str,Length(str),1) ELSE
   IF str[1] = '$' THEN Delete(str,1,1);
   GetValue:=0;
   ErrorVal:=1;
   IF Length(str) > 16 THEN Exit;
   IF (Length(str) = 16) AND (str[1] > '7') THEN Exit;
   n1:=0;
    FOR n:=1 TO Length(str)-1 DO BEGIN
    IF str[n] IN ['A'..'F'] THEN str2:=T[Ord(str[n])-64] ELSE str2:=str[n];
    Val(str2,b,ErrorVal);
    n1:=(n1+b)*16
   END;
   Inc(n);
   IF str[n] IN ['A'..'F'] THEN str2:=T[Ord(str[n])-64] ELSE str2:=str[n];
   Val(str2,b,ErrorVal);
   n1:=n1+b;
   IF Min THEN n1:=-n1;
   GetValue:=n1;
   ErrorVal:=0;
  END ELSE
  IF str[Length(str)] = 'B' THEN BEGIN
   {Двоичное число}
   {Удаляем указатель на тип числа}
   Delete(str,Length(str),1);
   GetValue:=0;
   ErrorVal:=1;
   IF Length(Str) > 64 THEN Exit;
   n1:=0;
   FOR n:=1 TO Length(Str) DO BEGIN
    IF Str[n] = '1' THEN BEGIN
     n2:=1;
     IF (n < Length(Str)) OR ((Length(Str) <> 8) AND (Length(Str) <> 16) AND
        (Length(Str) <> 32) AND (Length(Str) <> 64)) THEN BEGIN
      FOR n3:=1 TO n-1 DO n2:=n2*2;
      ValueOR(n1,n2,CompSize);
     END ELSE n1:=-n1;
    END ELSE
    IF Str[n] <> '0' THEN BEGIN
     GetValue:=0;
     ErrorVal:=n;
    END;
   END;
   IF Min THEN n1:=-n1;
   GetValue:=n1;
   ErrorVal:=0;
  END ELSE BEGIN
   {Обыкновенное десятичное число}
   StrToValue(str,r,EV);
   IF EV < StrError THEN ErrorVal:=0 ELSE ErrorVal:=1;
   IF Min THEN r:=-r;
   GetValue:=r;
  END;
 END;

 FUNCTION  CompToLongInt(c: Comp): LongInt;
 VAR r: Real;
     v: LongInt;
 BEGIN
  r:=c;
  v:=Trunc(r);
  CompTOLongInt:=v;
 END;

 FUNCTION  CompToInteger(c: Comp): Integer;
 VAR r: Real;
     code, v: Integer;
     ts: String;
 BEGIN
  Str(CompToLongInt(c),ts);
  Val(ts,v,code);
  CompTOInteger:=v;
 END;

 FUNCTION  WhatThis(s: String): Byte;
 VAR t: Comp;
     s1: String;
     lp: Byte;
 BEGIN
  WhatThis:=255;
  IF TestRegistersWord(s) <> 255 THEN WhatThis:=1 ELSE BEGIN
   t:=GetValue(s);
   IF TestEQUWord(s) <> 0 THEN s:=GetEQUd(TestEQUWord(s));
   lp:=Path;
   Path:=2;
   s1:=GetStrValFrom(s);
   Path:=lp;
    IF (s1 <> s) THEN s:=s1;
   IF ErrorVal = 0 THEN BEGIN IF adr = 0 THEN WhatThis:=StrGetType(s)+2 ELSE WhatThis:=5; END;
  END;
 END;

 {0 - нет параметра   0 - число         0 - BYTE
  1 - регистр         1 - адрес памяти  1 - WORD
  2 - число 8 бит                       2 - DWORD
  3 - число 16 бит                      3 - QWORD
  4 - число 32 бит
  5 - число 64 бит
  255 - неопределенно}

 PROCEDURE AnalisParam(VAR s: String);
 VAR ls,ms,fp,sp,t1,t2: String;
     tb1,tb2,tb3: Byte;
 BEGIN
  ms:=s;
  fp1:=0; fp2:=0; sp1:=0; sp2:=0; fr1:=255; fr2:=255; sr1:=255; sr2:=255; sm:=0; fm:=0;
  fv[0]:=0; sv[0]:=0;
  t1:=GetWord(s,' ',1);
  fw:=255;
  IF t1 = ASMWord[4] THEN fw:=0;
  IF t1 = ASMWord[5] THEN fw:=1;
  IF t1 = ASMWord[6] THEN fw:=2;
  IF t1 = ASMWord[7] THEN fw:=3;
  IF fw < 255 THEN Delete(s,1,Pos(ASMWord[4+fw],s)+Length(ASMWord[4+fw]));
  fp:=GetWord(s,',',1);
  tb1:=Pos('[',fp);
  tb2:=Pos(']',fp);
  IF (tb1 <> 0) AND (tb2 <> 0) AND (tb1 < tb2) THEN BEGIN
   fm:=1;
   fp:=GetWord(fp,'[]',1);
  END;
  fr1:=255; fr2:=255;
  t1:=GetWord(fp,' +',1);
  t1:=GetWord(t1,' ',1);
  IF t1 <> '' THEN BEGIN
   fp1:=WhatThis(t1);
   IF fp1 > 1 THEN fv[0]:=GetValue(t1) ELSE
   IF fp1 = 1 THEN fr1:=TestRegistersWord(t1);
  END ELSE fp1:=0;
   IF Pos('+',fp) <> 0 THEN BEGIN
   t2:=GetWord(fp,'+',2);
   t2:=GetWord(t2,' ',1);
   fp2:=WhatThis(t2);
   IF fp2 > 1 THEN fv[0]:=GetValue(t2) ELSE
   IF fp2 = 1 THEN fr2:=TestRegistersWord(t2);
  END;
  IF fp2 = 3 THEN fvi:=CompToInteger(fv[0]);
  IF fp2 = 4 THEN fvl:=CompToLongInt(fv[0]);
  IF Pos(',',ms) <> 0 THEN BEGIN
   sp:=GetWord(s,',',2);
   tb1:=Pos('[',sp);
   tb2:=Pos(']',sp);
   IF (tb1 <> 0) AND (tb2 <> 0) AND (tb1 < tb2) THEN BEGIN
    sm:=1;
    sp:=Copy(sp,tb1,Length(sp)-tb1);
    sp:=GetWord(sp,'[]',1);
   END;
   sr1:=255; sr2:=255;
   t1:=GetWord(sp,' +',1);
   t1:=GetWord(t1,' ',1);
   IF t1 <> '' THEN BEGIN
    sp1:=WhatThis(t1);
    IF sp1 > 1 THEN sv[0]:=GetValue(t1) ELSE
    IF sp1 = 1 THEN sr1:=TestRegistersWord(t1);
   END ELSE sp1:=0;
   IF Pos('+',sp) <> 0 THEN BEGIN
    t2:=GetWord(sp,'+',2);
    t2:=GetWord(t2,' ',1);
    sp2:=WhatThis(t2);
    IF sp2 > 1 THEN sv[0]:=GetValue(t2) ELSE
    IF sp2 = 1 THEN sr2:=TestRegistersWord(t2);
   END;
  END;
  IF sp2 = 3 THEN svi:=CompToInteger(sv[0]);
  IF sp2 = 4 THEN svl:=CompToLongInt(sv[0]);
 END;

 PROCEDURE Compiller(FileName: String); {Компилировать файл}
 VAR ExitKey: LongInt;
     ad: Comp;

 PROCEDURE ShowMessage1(code: Byte);
 BEGIN
  MessageCounter:=MessageCounter+1;
  MessageCompiller(code,1,FileName);
 END;

 PROCEDURE CompilFileMain(fn: String);
 VAR CompilFile: Text;
     CompilFileName, TStr: String;
     CLine,n: LongInt;

 PROCEDURE ShowError(code: Byte);
 BEGIN
  ErrorCompiller(code,1,CLine,CompilFileName);
  ExitKey:=1;
  Info.SourceFileName:=FileName;
  Info.CodeSize:=CodeCounter;
  Info.DataSize:=DataSize;
  Info.StackSize:=StackSize;
  Info.TotalMessages:=MessageCounter;
  Info.TotalStrings:=TCLine;
  Info.TotalMainStrings:=TCLine;
  Info.InPoint:=InPoint;
  Info.OutPoint:=OutPoint;
  Info.ErrorString:=CLine;
  Info.ErrorChar:=1;
  Info.ErrorNumber:=code;
 END;

 PROCEDURE ShowMessage(code: Byte);
 BEGIN
  IF Path = 1 THEN Exit;
  MessageCounter:=MessageCounter+1;
  MessageCompiller(code,CLine,CompilFileName);
 END;

 {Функция возвращает строку содержащююся в квадратных скобках и контролирует ошибки}
 FUNCTION GetFrom(ts: String): String;
 VAR tb1, tb2: Byte;
 BEGIN
  tb1:=Pos('[',ts);
  tb2:=Pos(']',ts);
  IF (tb1 = 0) OR (ts = '') OR (tb1 > tb2) THEN ShowError(32);
  IF tb2 = 0 THEN ShowError(33);
  {Получаем строку содержащююся в квадратных скобках}
  IF tb1 > 1 THEN Delete(ts,1,tb1);
  GetFrom:=GetWord(ts,'[]',1);
 END;

 PROCEDURE DetectCom1;
 BEGIN
 {    Тип #1     -    42
    ┌────────────────────┬────────────────┐
    │     Комбинация     │ Код комбинации │
    ├────────────────────┼────────────────┤
    │ BYTE  R, R         │       0        │
    │ BYTE  R, [R]       │       1        │
    │ BYTE  R, [R+R]     │       2        │
    │ BYTE  R, D8        │       3        │
    │ BYTE  R, D16       │       4        │
    │ BYTE  R, D32       │       5        │
    │ BYTE  R, D64       │       6        │
    │ BYTE  R, [ADR]     │       7        │
    │ BYTE  R, [ADR+R]   │       8        │
    │ BYTE  [R], R       │       9        │
    │ BYTE  [R], D8      │      10        │
    │ BYTE  [R], D16     │      11        │
    │ BYTE  [R], D32     │      12        │
    │ BYTE  [R], D64     │      13        │
    │ BYTE  [R+R], R     │      14        │
    │ BYTE  [R+R], D8    │      15        │
    │ BYTE  [R+R], D16   │      16        │
    │ BYTE  [R+R], D32   │      17        │
    │ BYTE  [R+R], D64   │      18        │
    │ BYTE  [ADR], R     │      19        │
    │ BYTE  [ADR], D8    │      20        │
    │ BYTE  [ADR], D16   │      21        │
    │ BYTE  [ADR], D32   │      22        │
    │ BYTE  [ADR], D64   │      23        │
    │ BYTE  [ADR+R], R   │      24        │
    │ BYTE  [ADR+R], D8  │      25        │
    │ BYTE  [ADR+R], D16 │      26        │
    │ BYTE  [ADR+R], D32 │      27        │
    │ BYTE  [ADR+R], D64 │      28        │
    │ WORD  R, R         │      29        │
    │ WORD  R, [R]       │      30        │
    │ WORD  R, [R+R]     │      31        │
    │ WORD  R, D8        │      32        │
    │ WORD  R, D16       │      33        │
    │ WORD  R, D32       │      34        │
    │ WORD  R, D64       │      35        │
    │ WORD  R, [ADR]     │      36        │
    │ WORD  R, [ADR+R]   │      37        │
    │ WORD  [R], R       │      38        │
    │ WORD  [R], D8      │      39        │
    │ WORD  [R], D16     │      40        │
    │ WORD  [R], D32     │      41        │
    │ WORD  [R], D64     │      42        │
    │ WORD  [R+R], R     │      43        │
    │ WORD  [R+R], D8    │      44        │
    │ WORD  [R+R], D16   │      45        │
    │ WORD  [R+R], D32   │      46        │
    │ WORD  [R+R], D64   │      47        │
    │ WORD  [ADR], R     │      48        │
    │ WORD  [ADR], D8    │      49        │
    │ WORD  [ADR], D16   │      50        │
    │ WORD  [ADR], D32   │      51        │
    │ WORD  [ADR], D64   │      52        │
    │ WORD  [ADR+R], R   │      53        │
    │ WORD  [ADR+R], D8  │      54        │
    │ WORD  [ADR+R], D16 │      55        │
    │ WORD  [ADR+R], D32 │      56        │
    │ WORD  [ADR+R], D64 │      57        │
    │ DWORD R, R         │      58        │
    │ DWORD R, [R]       │      59        │
    │ DWORD R, [R+R]     │      60        │
    │ DWORD R, D8        │      61        │
    │ DWORD R, D16       │      62        │
    │ DWORD R, D32       │      63        │
    │ DWORD R, D64       │      64        │
    │ DWORD R, [ADR]     │      65        │
    │ DWORD R, [ADR+R]   │      66        │
    │ DWORD [R], R       │      67        │
    │ DWORD [R], D8      │      68        │
    │ DWORD [R], D16     │      69        │
    │ DWORD [R], D32     │      70        │
    │ DWORD [R], D64     │      71        │
    │ DWORD [R+R], R     │      72        │
    │ DWORD [R+R], D8    │      73        │
    │ DWORD [R+R], D16   │      74        │
    │ DWORD [R+R], D32   │      75        │
    │ DWORD [R+R], D64   │      76        │
    │ DWORD [ADR], R     │      77        │
    │ DWORD [ADR], D8    │      78        │
    │ DWORD [ADR], D16   │      79        │
    │ DWORD [ADR], D32   │      80        │
    │ DWORD [ADR], D64   │      81        │
    │ DWORD [ADR+R], R   │      82        │
    │ DWORD [ADR+R], D8  │      83        │
    │ DWORD [ADR+R], D16 │      84        │
    │ DWORD [ADR+R], D32 │      85        │
    │ DWORD [ADR+R], D64 │      86        │
    │ QWORD R, R         │      87        │
    │ QWORD R, [R]       │      88        │
    │ QWORD R, [R+R]     │      89        │
    │ QWORD R, D8        │      90        │
    │ QWORD R, D16       │      91        │
    │ QWORD R, D32       │      92        │
    │ QWORD R, D64       │      93        │
    │ QWORD R, [ADR]     │      94        │
    │ QWORD R, [ADR+R]   │      95        │
    │ QWORD [R], R       │      96        │
    │ QWORD [R], D8      │      97        │
    │ QWORD [R], D16     │      98        │
    │ QWORD [R], D32     │      99        │
    │ QWORD [R], D64     │     100        │
    │ QWORD [R+R], R     │     101        │
    │ QWORD [R+R], D8    │     102        │
    │ QWORD [R+R], D16   │     103        │
    │ QWORD [R+R], D32   │     104        │
    │ QWORD [R+R], D64   │     105        │
    │ QWORD [ADR], R     │     106        │
    │ QWORD [ADR], D8    │     107        │
    │ QWORD [ADR], D16   │     108        │
    │ QWORD [ADR], D32   │     109        │
    │ QWORD [ADR], D64   │     110        │
    │ QWORD [ADR+R], R   │     111        │
    │ QWORD [ADR+R], D8  │     112        │
    │ QWORD [ADR+R], D16 │     113        │
    │ QWORD [ADR+R], D32 │     114        │
    │ QWORD [ADR+R], D64 │     115        │
    └────────────────────┴────────────────┘}
  {Удаляем команду из строки}
  AddCodeByte(CC); {Записываем код команды}
  ts:=Strr;
  Delete(ts,1,GetWordCount(ts,' ',2)-1);
  AnalisParam(ts);
  IF ((fm = 1) OR (sm = 1)) AND (fw = 255) THEN BEGIN
   ShowMessage(40);
   fw:=0;
  END ELSE IF fw=255 THEN fw:=0;
  {Получаем первый параметр}
  CodeByte:=0;
  IF fp1 = 0 THEN ShowError(16);
  IF sp1 = 0 THEN ShowError(17);
  IF fm = 1 THEN BEGIN
   IF sm = 1 THEN ShowError(17);
   IF fp1 = 255 THEN ShowError(16);
   IF fp1 = 1 THEN BEGIN
    IF fr1 <> 255 THEN CodeByte:=9 ELSE ShowError(16);
   END ELSE CodeByte:=19;
   IF fp2 = 1 THEN BEGIN
    IF fr2 <> 255 THEN CodeByte:=CodeByte+5 ELSE ShowError(18); END;
   IF sp1 > 1 THEN BEGIN
    CodeByte:=CodeByte+sp1-1;
   END;
  END ELSE BEGIN
   IF fr1 = 255 THEN ShowError(16);
   IF sm = 1 THEN BEGIN
    IF sp1 = 1 THEN CodeByte:=1 ELSE CodeByte:=7;
    IF sp2 = 1 THEN CodeByte:=CodeByte+1;
   END ELSE BEGIN
    IF sp1 > 1 THEN BEGIN
     CodeByte:=CodeByte+3+sp1-2;
    END;
   END;
  END;
  AddCodeByte(fw*29+CodeByte); {Записываем код параметров}
  IF fp1 = 1 THEN AddCodeByte(fr1) ELSE AddCodeComp(fv[0]);
  IF fp2 = 1 THEN AddCodeByte(fr2);
  IF sp1 = 1 THEN AddCodeByte(sr1) ELSE
   IF sm = 1 THEN AddCodeComp(sv[0]) ELSE BEGIN
    CASE sp1 OF
     2: AddCodeByte(svb[0]);
     3: BEGIN AddCodeByte(svb[0]); AddCodeByte(svb[1]); END;
     4: BEGIN AddCodeByte(svb[0]); AddCodeByte(svb[1]); AddCodeByte(svb[2]); AddCodeByte(svb[3]);END;
     5: AddCodeComp(sv[0]);
    END;
   END;
  IF sp2 = 1 THEN AddCodeByte(sr2);
 END;

 PROCEDURE DetectCom3;
 BEGIN
 {    Тип #3     -     7
    ┌─────────────┬────────────────┐
    │ Комбинация  │ Код комбинации │
    ├─────────────┼────────────────┤
    │ R, R        │       0        │
    │ R, [R]      │       1        │
    │ R, [R+R]    │       2        │
    │ R, [ADR]    │       3        │
    │ R, [ADR+R]  │       4        │
    └─────────────┴────────────────┘}
  AddCodeByte(CC); {Записываем код команды}
  {Удаляем команду из строки}
  ts:=Strr;
  Delete(ts,1,GetWordCount(ts,' ',2)-1);
  AnalisParam(ts);
  IF (fp1 <> 1) OR ((fp1 = 1) AND (fr1 = 255)) OR (fm = 1) THEN
   ShowError(14);
  IF sp1 = 0 THEN ShowError(16);
  IF sm = 1 THEN BEGIN
   IF sp1 = 1 THEN BEGIN
    CodeByte:=1;
    IF sr1 = 255 THEN ShowError(14)
   END ELSE CodeByte:=3;
   IF sp2 = 1 THEN BEGIN
    IF sr2 <> 255 THEN CodeByte:=CodeByte+1 ELSE ShowError(18); END;
  END ELSE IF sr1 <> 255 THEN CodeByte:=0 ELSE ShowError(16);
  AddCodeByte(CodeByte); {Записываем код комбинации}
  AddCodeByte(fr1);
  IF sp1 = 1 THEN AddCodeByte(sr1) ELSE AddCodeComp(sv[0]);
  IF sp2 = 1 THEN AddCodeByte(sr2);
 END;

 PROCEDURE DetectCom4;
 BEGIN
 {    Тип #4     -     25
    ┌────────────────┬────────────────┐
    │ Комбинация     │ Код комбинации │
    ├────────────────┼────────────────┤
    │ R              │        0       │
    │ BYTE [R]       │        1       │
    │ BYTE [R+R]     │        2       │
    │ BYTE [ADR]     │        3       │
    │ BYTE [ADR+R]   │        4       │
    │ WORD [R]       │        5       │
    │ WORD [R+R]     │        6       │
    │ WORD [ADR]     │        7       │
    │ WORD [ADR+R]   │        8       │
    │ DWORD [R]      │        9       │
    │ DWORD [R+R]    │       10       │
    │ DWORD [ADR]    │       11       │
    │ DWORD [ADR+R]  │       12       │
    │ QWORD [R]      │       13       │
    │ QWORD [R+R]    │       14       │
    │ QWORD [ADR]    │       15       │
    │ QWORD [ADR+R]  │       16       │
    └────────────────┴────────────────┘}
  {Удаляем команду из строки}
  AddCodeByte(CC); {Записываем код команды}
  ts:=Strr;
  Delete(ts,1,GetWordCount(ts,' ',2)-1);
  AnalisParam(ts);
  CodeByte:=0;
  IF (fm = 1) AND (fw = 255) THEN BEGIN
   ShowMessage(40);
   fw:=0;
  END;
  IF (sp1 <> 0) OR (sp2 <> 0) THEN ShowError(20);
  IF fp1 = 0 THEN ShowError(16);
  IF fw < 255 THEN BEGIN
   CodeByte:=1+fw*4;
   IF fm = 0 THEN ShowError(16);
   IF fp1 > 1 THEN CodeByte:=CodeByte+2;
   IF fp1 = 255 THEN ShowError(12);
   IF fp2 = 1 THEN CodeByte:=CodeByte+1;
   IF fp2 = 255 THEN ShowError(14);
  END ELSE
  IF fr1 = 255 THEN ShowError(16);
   AddCodeByte(CodeByte); {Сохраняем код комбинации}
  IF fp1 = 1 THEN AddCodeByte(fr1) ELSE AddCodeComp(fv[0]);
  IF fp2 = 1 THEN AddCodeByte(fr2);
 END;

 PROCEDURE DetectCom5;
 BEGIN
 {    Тип #5     -     4
    ┌────────────┬────────────────┐
    │ Комбинация │ Код комбинации │
    ├────────────┼────────────────┤
    │ D8         │       0        │
    │ D16        │       1        │
    │ D32        │       2        │
    │ D64        │       3        │
    └────────────┴────────────────┘}
  {Удаляем команду из строки}
  ts:=Strr;
  Delete(ts,1,GetWordCount(ts,' ',2)-1);
  AnalisParam(ts);
  Dec(CC);
  IF (CC = 2) AND ((fm = 1) OR (fp1 = 1)) THEN BEGIN DetectCom4; Exit; END;
  Inc(CC);
  AddCodeByte(CC); {Записываем код команды}
  CodeByte:=0;
  IF fp1 = 0 THEN ShowError(15);
  IF (sp1 <> 0) OR (sp2 <> 0) THEN ShowError(20);
  IF (fp1 > 1) THEN CodeByte:=fp1;
  IF ((fp1 = 255) OR (fp1 < 2)) AND (fm = 0) THEN ShowError(15);
  IF (fm = 1) OR (fp1 < 2) THEN ShowError(15);
  Dec(CodeByte,2);
  AddCodeByte(CodeByte);  {Сохраняем код комбинации}
  AddCodeByte(fvb[0]);
  IF CodeByte >= 1 THEN AddCodeByte(fvb[1]);
  IF CodeByte >= 2 THEN BEGIN AddCodeByte(fvb[2]); AddCodeByte(fvb[3]); END;
  IF CodeByte = 3 THEN BEGIN AddCodeByte(fvb[2]); AddCodeByte(fvb[3]);
                             AddCodeByte(fvb[4]); AddCodeByte(fvb[5]);
                             AddCodeByte(fvb[6]); AddCodeByte(fvb[7]); END;
 END;

 PROCEDURE DetectCom6;
 BEGIN
 {    Тип #6     -     5
    ┌────────────┬────────────────┐
    │ Комбинация │ Код комбинации │
    ├────────────┼────────────────┤
    │ R, R       │       0        │
    │ R, D8      │       1        │
    │ R, D16     │       2        │
    │ R, D32     │       3        │
    │ R, D64     │       4        │
    └────────────┴────────────────┘}
  AddCodeByte(CC); {Записываем код команды}
  {Удаляем команду из строки}
  ts:=Strr;
  Delete(ts,1,GetWordCount(ts,' ',2)-1);
  AnalisParam(ts);
  IF (fp1 <> 1) OR (fm = 1) OR (fp2 > 0) THEN ShowError(14);
  IF sp1 = 1 THEN CodeByte:=0 ELSE CodeByte:=sp1-1;
  IF (CodeByte = 255) OR (sm = 1) OR (sp2 > 0) OR (sp1 = 0) THEN ShowError(17);
  AddCodeByte(CodeByte);  {Сохраняем код комбинации}
  AddCodeByte(fr1);
  IF CodeByte = 0 THEN AddCodeByte(sr1);
  IF CodeByte = 1 THEN AddCodeByte(svb[0]);
  IF CodeByte = 2 THEN BEGIN AddCodeByte(svb[0]); AddCodeByte(svb[1]); END ELSE
  IF CodeByte = 3 THEN BEGIN AddCodeByte(svb[0]); AddCodeByte(svb[1]);
                             AddCodeByte(svb[2]); AddCodeByte(svb[3]); END ELSE
  IF CodeByte = 4 THEN BEGIN AddCodeByte(svb[0]); AddCodeByte(svb[1]);
                             AddCodeByte(svb[2]); AddCodeByte(svb[3]);
                             AddCodeByte(svb[4]); AddCodeByte(svb[5]);
                             AddCodeByte(svb[6]); AddCodeByte(svb[7]); END;
 END;

 PROCEDURE DetectCom7;
 BEGIN
 {   Тип #7     -     6
    ┌────────────┬────────────────┐
    │ Комбинация │ Код комбинации │
    ├────────────┼────────────────┤
    │ R          │       0        │
    │ R+R        │       1        │
    │ ADR        │       2        │
    │ ADR+R      │       3        │
    └────────────┴────────────────┘}
  {Удаляем команду из строки}
  AddCodeByte(CC); {Записываем код команды}
  ts:=Strr;
  Delete(ts,1,GetWordCount(ts,' ',2)-1);
  AnalisParam(ts);
  IF (sp1 <> 0) OR (sp2 <> 0) THEN ShowError(20);
  IF (fp1 = 0) OR (fm = 1) THEN ShowError(16);
  IF fp1 = 1 THEN CodeByte:=0 ELSE CodeByte:=2;
  IF fp2 = 1 THEN CodeByte:=CodeByte+1;
  IF (fp2 > 1) OR ((fr2 = 255) AND (fp2 = 1)) THEN ShowError(18);
  IF (fp1 = 255) OR (fp1 = 0) OR ((fr1 = 255) AND (fp1 = 1)) THEN ShowError(16);
  AddCodeByte(CodeByte); {Сохраняем код комбинации}
  CASE CodeByte OF
   0,1: AddCodeByte(fr1);
   2,3: AddCodeComp(fv[0]);
  END;
  IF fp2 = 1 THEN AddCodeByte(fr2);
 END;

 PROCEDURE DetectCom8;
 BEGIN
 {    Тип #8     -      6
    ┌─────────────┬────────────────┐
    │ Комбинация  │ Код комбинации │
    ├─────────────┼────────────────┤
    │ R, R        │       0        │
    │ R, R+R      │       1        │
    │ R, ADR      │       2        │
    │ R, ADR+R    │       3        │
    └─────────────┴────────────────┘}
  {Удаляем команду из строки}
  AddCodeByte(CC); {Записываем код команды}
  ts:=Strr;
  Delete(ts,1,GetWordCount(ts,' ',2)-1);
  AnalisParam(ts);
  IF (fp1 <> 1) OR (fr1 = 255) THEN ShowError(14);
  IF (sp1 = 0) OR (sm = 1) THEN ShowError(16);
  IF sp1 = 1 THEN CodeByte:=0 ELSE CodeByte:=2;
  If sp2 = 1 THEN CodeByte:=CodeByte+1;
  IF (sp2 = 1) AND (sr2 = 255) THEN ShowError(20);
  AddCodeByte(CodeByte); {Сохраняем код комбинации}
  AddCodeByte(fr1);
  IF CodeByte IN [0,1] THEN AddCodeByte(sr1) ELSE AddCodeComp(sv[0]);
  IF sp2 = 1 THEN AddCodeByte(sr2);
 END;

 PROCEDURE DetectCom10;
 BEGIN
  {R}
  {Удаляем команду из строки}
  ts:=Strr;
  Delete(ts,1,GetWordCount(ts,' ',2)-1);
  AnalisParam(ts);
  IF (fp1 <> 1) AND (CC = 27) THEN BEGIN
   Dec(CC);
   DetectCom5
  END ELSE BEGIN
   {Dec(CC);}
   AddCodeByte(CC); {Записываем код команды}
   IF (fp1 <> 1) OR (fr1 = 255) OR (fm = 1) THEN ShowError(14);
   IF (sp1 <> 0) THEN ShowError(20);
   AddCodeByte(fr1);
  END;
 END;

 PROCEDURE DetectVar;
 VAR n: LongInt;
 BEGIN
   {0 - массив неопределенных байт
    1 - массив неопределенных слов
    2 - массив неопределенных двойных слов
    3 - массив неопределенных четверных слов
    4 - массив определенных байт
    5 - массив определенных слов
    6 - массив определенных двойных слов
    7 - массив определенных четверных слов
    8 - байт
    9 - слово
   10 - двойное слово
   11 - учетверенное слово}
   {Это директива определения переменной без имени}
   IF TempStr = ASMWord[0] THEN n4:=0 ELSE
   IF TempStr = ASMWord[1] THEN n4:=1 ELSE
   IF TempStr = ASMWord[2] THEN n4:=2 ELSE
   IF TempStr = ASMWord[3] THEN n4:=3;
   dt:=n4;
   TempStr:=Strr;
   Delete(TempStr,1,Pos(GetWord(Strr,' ',1),Strr)+1);
   IF TotalWords(TempStr,',') > 0 THEN BEGIN
    FOR n:=1 TO TotalWords(TempStr,',') DO BEGIN
     TStr:=GetWord(TempStr,',',n);
     TStr2:='';
     TStr2:=GetWord(TStr,' ',2);
     IF TestEQUWord(GetWord(TStr,' ',1)) > 0 THEN TStr:=GetEQUd(TestEQUWord(GetWord(TStr,' ',1)));
     {Проверка на наличие кавычек при определении байта}
     IF (Pos(#39,TStr) <> 0) OR (Pos('"',TStr) <> 0) THEN BEGIN
      {Получаем строку в кавычках}
      TStr:=GetStrNoBorder(TStr);
      {Проверяем на ошибки}
      IF ErrorVal > 0 THEN ShowError(34);
      {Ошибок нет}
      AddDataByte(dt+4); {Определяем соответствующюю переменную}
      AddDataComp(Length(TStr)); {Определяем размер массива}
      DataSize:=DataSize+Length(TStr)*(1 SHL n4);
      FOR n1:=1 TO Length(TStr) DO BEGIN
       n3:=Ord(TStr[n1]);
       CASE n4 OF {Сохраняем переменную}
        0: AddDataByte(b[0]);
        1: BEGIN AddDataByte(b[0]); AddDataByte(b[1]); END;
        2: BEGIN AddDataByte(b[0]); AddDataByte(b[1]); AddDataByte(b[2]); AddDataByte(b[3]); END;
        3: AddDataComp(n3);
       END;
      END;
     END ELSE
     IF Tstr2 = ASMWord[18] THEN BEGIN
      {Задается неопределенный массив}
      TStr:=GetWord(TStr,' ',1);
      IF TestEQUWord(TStr) > 0 THEN TStr:=GetEQUd(TestEQUWord(TStr));
      Path:=2;
      n3:=GetValue(TStr);
      Path:=1;
      StrValueTo(n3,StrComp,TStr);
      IF ErrorVal <> 0 THEN ShowError(12);
      IF StrGetType(TStr) = StrUnknown THEN ShowError(11);
      IF StrGetType(TStr) > n4 THEN ShowError(11);
      IF n3 < 1 THEN ShowError(13);
      AddDataByte(n4); {Определяем массив}
      AddDataComp(n3); {Сохраняем размер массива}
      IF n4 > 0 THEN n3:=n3*2;
      IF n4 > 1 THEN n3:=n3*2;
      IF n4 > 2 THEN n3:=n3*2;
      DataSize:=DataSize+n3;
     END ELSE BEGIN
      {Записать число}
      TStr:=GetWord(TStr,' ',1);
      Path:=2;
      n3:=GetValue(TStr);
      Path:=1;
      StrValueTo(n3,StrComp,TStr);
      IF ErrorVal <> 0 THEN ShowError(12);
      IF StrGetType(TStr) > n4 THEN ShowError(11);
      AddDataByte(n4+8); {Определяем соответствующюю переменную}
      IF n4 = StrInteger THEN n3i:=CompToInteger(n3);
      IF n4 = StrLongInt THEN n3l:=CompToLongInt(n3);
      CASE n4 OF {Сохраняем переменную}
       0: AddDataByte(b[0]);
       1: BEGIN AddDataByte(b[0]); AddDataByte(b[1]); END;
       2: BEGIN AddDataByte(b[0]); AddDataByte(b[1]); AddDataByte(b[2]); AddDataByte(b[3]); END;
       3: AddDataComp(n3);
      END;
      DataSize:=DataSize+(1 SHL n4);
     END;
    END;
   END ELSE ShowError(10);
 END;

 PROCEDURE ShowCompilInfo;
 BEGIN
  ShowCompillInfo(FileName,CompilFileName,TCLine,CLine,Path);
 END;

 BEGIN
  CompilFileName:=fn;
  Assign(CompilFile,CompilFileName);
  {$I-}
  Reset(CompilFile);
  {$I+}
  IF IOREsult <> 0 THEN BEGIN
   CLine:=0;
   TCline:=0;
   ShowError(1);
   ExitKey:=3;
  END;
  CLine:=0;
  IF Key = 27 THEN ExitKey:=1;
  IF ExitKey <> 3 THEN
  REPEAT
   Inc(CLine);
   Inc(TCLine);
   ReadLn(CompilFile,SStr);
   CString:=SStr;
   SStr:=DeleteComent(SStr); {Удалаяем коментарий из строки}
   Strr:=UpString(SStr);      {Поднимаем все символы в строке}
   ShowCompilInfo;
   IF TotalWords(Strr,' ') <> 0 THEN BEGIN {Проверяем строку на пустоту}
    TempStr:=GetWord(Strr,' ',1);
    {Первый проход: составляем список меток,переменных, определений
     и формируем блок данных}

{=============== Проверяем строку на присутствие команды SVM ================}
    IF TestCommandWord(TempStr) < 255 THEN BEGIN
     {Первое слово является командой}
     {Получаем тип параметров}
     CC:=TestCommandWord(TempStr);
     dt:=SVMComType[CC];
     TStr:='';
     CASE dt OF
      0: AddCodeByte(CC); {Записываем код команды}
      1: DetectCom1;
      3: DetectCom3;
      4: DetectCom4;
      5: DetectCom5;
      6: DetectCom6;
      7: DetectCom7;
      8: DetectCom8;
      10: DetectCom10;
     END;
    END ELSE BEGIN
{============================================================================}

{=============== Проверяем строку на присутствие определения ================}
    IF (GetWord(Strr,' ',2) = ASMWord[17]) AND (Path = 1) THEN BEGIN
     {Проверяем имя на правельность записи}
     IF TestName(TempStr) > 0 THEN ShowError(25);
     {Проверка является ли первое слово зарезервированным словом}
     FirstWord:=0;
     IF TestSystemWord(TempStr) THEN FirstWord:=1 ELSE
     IF TestEQUWord(TempStr) <> 0 THEN FirstWord:=2 ELSE
     IF TestProcWord(TempStr) <> 0 THEN FirstWord:=3 ELSE
     IF TestVarWord(TempStr) <> 0 THEN FirstWord:=4 ELSE
     IF TestGLabelWord(TempStr) <> 0 THEN FirstWord:=5 ELSE
     IF TestLLabelWord(TempStr) <> 0 THEN FirstWord:=6;
     IF FirstWord = 1 THEN ShowError(22);
     {Проверяем есть ли первое слово в списках}
     IF FirstWord > 1 THEN ShowError(30);
     AddEQU(TempStr);
     {Удаляем из строки имя определения и команду определения}
      Delete(Strr,1,GetWordCount(Strr,' ',2)+3);
     n:=0;
     REPEAT
      Inc(n);
     UNTIL (n = Length(Strr)) OR (Strr[n] > #32);
     Strr:=Copy(Strr,n,Length(Strr)-n+1);
     n:=Length(Strr);
     REPEAT
      Dec(n);
     UNTIL (n = 1) OR (Strr[n] > #32);
     Strr:=Copy(Strr,1,n+1);
     TempStr:=Strr;
     IF TestEQUWord(TempStr) > 0 THEN TempStr:=GetEQUd(TestEQUWord(TempStr));
     IF TempStr = '' THEN ShowError(10);
     AddEQUd(TempStr);
    END ELSE BEGIN
{============================================================================}

{===== Проверяем строку на присутствие определения переменной без имени =====}
    TempStr:=GetWord(Strr,' ',1);
    IF ((TempStr=ASMWord[0]) OR (TempStr=ASMWord[1]) OR (TempStr=ASMWord[2])
       OR (TempStr=ASMWord[3])) AND (Path = 1) THEN DetectVar ELSE BEGIN
{============================================================================}

{====== Проверяем строку на присутствие определения переменной с имени ======}
    TempStr:=GetWord(Strr,' ',2);
    IF ((TempStr=ASMWord[0]) OR (TempStr=ASMWord[1]) OR
       (TempStr=ASMWord[2]) OR (TempStr=ASMWord[3])) AND (Path = 1) THEN
    BEGIN
     {Проверка является ли первое слово зарезервированным словом}
     FirstWord:=0;
     TempStr:=GetWord(Strr,' ',1);
     IF TestSystemWord(TempStr) THEN FirstWord:=1 ELSE
     IF TestEQUWord(TempStr) <> 0 THEN FirstWord:=2 ELSE
     IF TestProcWord(TempStr) <> 0 THEN FirstWord:=3 ELSE
     IF TestVarWord(TempStr) <> 0 THEN FirstWord:=4 ELSE
     IF TestGLabelWord(TempStr) <> 0 THEN FirstWord:=5 ELSE
     IF TestLLabelWord(TempStr) <> 0 THEN FirstWord:=6;
     TempStr:=GetWord(Strr,' ',2);
     IF FirstWord = 1 THEN ShowError(22);
     {Проверяем есть ли первое слово в списках}
     IF FirstWord > 1 THEN ShowError(26);
     TempStr:=GetWord(Strr,' ',1);
     {Проверяем имя на правельность записи}
     IF TestName(TempStr) > 0 THEN ShowError(25);
     {Запоминаем имя переменной и её положение в блоке данных}
     TempV.Name:=GetWord(Strr,' ',1);
     TempV.Addr:=DataSize;
     {Удаляем имя переменной из строки, что бы выполнить процедуру DetectVar}
     Delete(Strr,1,GetWordCount(Strr,' ',2)-1);
     {Помещаем в TempStr первое слово новой строки - команду определения переменной }
     TempStr:=GetWord(Strr,' ',1);
     DetectVar;
     {Запоминаем тип переменной}
     TempV.Mode:=dt;
     {Добовляем новую переменную в список переменных}
     AddV(TempV);
    END ELSE BEGIN
{============================================================================}

{=============== Проверяем строку на присутствие метки перехода =============}
    TempStr:=GetWord(Strr,' ',1);
    IF TempStr[Length(TempStr)] = LabelSign THEN BEGIN
      {Имя метки оканчивается символом LabelSign}
      {Удаляем признак метки}
      Delete(TempStr,Length(TempStr),1);
      {Проверяем является ли метка глобальной или локальной}
      IF TempStr[1] = LocalSign THEN BEGIN
       IF Path = 1 THEN BEGIN
        {Метка - локальная}
        {Проверяем есть ли локальная метка с таким именем уже в списке}
        IF TestLLabelWord(TempStr) <> 0 THEN ShowError(28);
        {Удаляем знак локальной метки}
        Delete(TempStr,1,1);
        {Проверяем имя на правельность записи}
        IF TestName(TempStr) > 0 THEN ShowError(25);
        {Возвращаем знак локальной метки на его место}
        TempStr:=LocalSign+TempStr;
        {Такой метки ещё нет в списке}
        {Добавляем в список имя и адрес метки}
        LocalNameLabel.Add(TempStr);
        LocalAddrLabel.PutC(GetLLIndex,CodeCounter);
        LastL:=LastL+1;
       END;
      END ELSE BEGIN
      LCount:=LCount+1;
      IF Path = 1 THEN BEGIN
       {Метка - глобальная}
       {Проверяем есть ли глобальная метка с таким именем уже в списке}
       IF TestGLabelWord(TempStr) <> 0 THEN ShowError(29);
       {Такой метки ещё нет в списке}
       {Проверяем имя на правельность записи}
        IF TestName(TempStr) > 0 THEN ShowError(25);
       {Добавляем в список имя и адрес глобальной метки и освобождаем список
       локальных меток}
       FirstLabel.PutL(LCount-1,FirstL);
       LastLabel.PutL(LCount-1,LastL);
       FirstL:=FirstL+LastL;
       LastL:=0;
       GlobalNameLabel.Add(TempStr);
       GlobalAddrLabel.PutC(GetGLIndex,CodeCounter);
       {Проверяем метку на принадлежность к точке входа или точке выхода}
       IF TempStr = StartSign THEN InPoint:=CodeCounter;
       IF TempStr = FinishSign THEN OutPoint:=CodeCounter;
      END ELSE BEGIN
       FirstL:=FirstLabel.GetL(LCount);
       LastL:=LastLabel.GetL(LCount)
      END;
     END;
    END ELSE BEGIN
{============================================================================}

{================= Проверяем строку на присутствие процедуры ================}
    IF (TempStr = ASMWord[16]) THEN BEGIN
     LCount:=LCount+1;
     IF Path = 1 THEN BEGIN
      {Получаем имя процедуры}
      TStr:=GetWord(Strr,' ',2);
      {Проверяем есть ли процедура с таким именем уже в списке}
      IF TestProcWord(TStr) <> 0 THEN ShowError(27);
      {Такой процедуры ещё нет в списке}
      {Проверяем имя на правельность записи}
      IF TestName(TStr) > 0 THEN ShowError(25);
      {Добавляем в список имя и адрес глобальной метки и освобождаем список
       локальных меток}
      FirstLabel.PutL(LCount-1,FirstL);
      LastLabel.PutL(LCount-1,LastL);
      FirstL:=FirstL+LastL;
      LastL:=0;
      ProcNameLabel.Add(TStr);
      ProcAddrLabel.PutC(GetPLIndex,CodeCounter);
     END ELSE BEGIN
      FirstL:=FirstLabel.GetL(LCount);
      LastL:=LastLabel.GetL(LCount)
     END;
   END ELSE BEGIN
{============================================================================}

{============ Проверяем строку на присутствие определителя стека ============}
    IF (TempStr = ASMWord[11]) AND (Path = 1) THEN BEGIN
     IF StackPresent THEN ShowMessage(31) ELSE BEGIN
      StackPresent:=True;
      IF TotalWords(Strr,' ') > 1 THEN TempStr:=GetWord(Strr,' ',2) ELSE
       ShowError(10);
      Path:=2;
      n2:=GetValue(TempStr);
      Path:=1;
      StrValueTo(n2,StrComp,TempStr);
      IF ErrorVal <> 0 THEN ShowError(12);
      IF n2 < 1 THEN ShowError(13);
      IF StrGetType(TempStr) >= StrUnknown THEN ShowError(11);
      StackSize:=n2;
     END;
    END ELSE BEGIN
{============================================================================}

{============== Проверяем на команду логического конца файла ================}
    IF TempStr = ASMWord[15] THEN BEGIN
     ExitKey:=2;
     LCount:=LCount+1;
     IF Path = 1 THEN BEGIN
      FirstLabel.PutL(LCount-1,FirstL);
      LastLabel.PutL(LCount-1,LastL);
      FirstL:=FirstL+LastL;
      LastL:=0;
     END;
    END ELSE BEGIN
{============================================================================}

{============ Проверяем на команду подключения вставочных файлов ============}
    IF TempStr = ASMWord[12] THEN BEGIN
     {Получаем строку содержащююся после ключевого слова}
     TStr:=Copy(Strr,Pos(ASMWord[12],Strr)+Length(ASMWord[12])+1,
                Length(Strr)-Pos(ASMWord[12],Strr)-Length(ASMWord[12]));
     IF TotalWords(TStr,',') = 0 THEN ShowError(10);
     FOR n:=1 TO TotalWords(TStr,',') DO BEGIN
      TempStr:=GetWord(TStr,',',n);
      TempStr:=GetWord(TempStr,' ',1);
      IF Pos('.',TempStr) = 0 THEN TempStr:=TempStr+'.ASM';
      IF TestIncludesWord(TempStr) = 0 THEN BEGIN
       Includes.Add(TempStr);
       CompilFileMain(IncludeDirectories+TempStr);
      END;
     END;
    END;
{============================================================================}
    END;
    END;
    END;
    END;
    END;
    END;
    END;
    END;
{============================================================================}
   END;
   IF KeyPressed THEN Key:=Ord(ReadKey);
  UNTIL EOF(CompilFile) OR (ExitKey > 0) OR (Key = 27);
  IF ExitKey <> 3 THEN Close(CompilFile) ELSE ExitKey:=1;
 END;

 BEGIN
  Key:=0;
  IF CStatus <> Compiller_Wait THEN CStatus:=Compiller_NoInit;
  IF (WorkStatus <> 0) OR (CStatus = Compiller_NoInit) THEN BEGIN WorkStatus:=1; Exit; END;
  MainFileName:=FileName;
  REPEAT
   IF Pos('/',MainFileName) <> 0 THEN Delete(MainFileName,1,Pos('/',MainFileName));
  UNTIL (Pos('/',MainFileName) = 0);
  IF Pos('.',MainFileName) <> 0 THEN MainFileName:=Copy(MainFileName,1,Pos('.',MainFileName)-1);
  ExitKey:=0;
  TCLine:=0;
  CodeCounter:=0;
  DataCounter:=0;
  DataSize:=0;
  FirstL:=0;
  LastL:=1;
  LCount:=0;
  path:=1; {Номер прохода}
  Includes.Add(FileName);
  CompilFileMain(SourceDirectories+FileName);
  TCLine:=0;
  FirstL:=0;
  LastL:=1;
  LCount:=0;
  path:=2;
  Includes.Done;
  Includes.Init(1,255);
  FOR n:=1 TO VarName.TotalStrings-1 DO BEGIN
   ad:=VarAddr.GetC(n);
   ad:=ad+CodeCounter;
   VarAddr.PutC(n,ad);
  END;
  CodeCounter:=0;
  IF ExitKey = 0 THEN CompilFileMain(SourceDirectories+FileName);
  CStatus:=Compiller_Error;
  IF ExitKey = 0 THEN BEGIN
   IF NOT StackPresent THEN ShowMessage1(39);
   IF InPoint = -1 THEN ShowMessage1(36);
   IF OutPoint = -1 THEN ShowMessage1(37);
   IF (InPoint = -1) OR (OutPoint = -1) THEN ShowMessage1(38);
   Info.SourceFileName:=FileName;
   Info.CodeSize:=CodeCounter;
   Info.DataSize:=DataSize;
   Info.StackSize:=StackSize;
   Info.TotalMessages:=MessageCounter;
   Info.TotalStrings:=TCLine;
   Info.TotalMainStrings:=TCLine;
   Info.InPoint:=InPoint;
   Info.OutPoint:=OutPoint;
   Info.ErrorString:=0;
   Info.ErrorChar:=0;
   IF (InPoint = -1) OR (OutPoint = -1) THEN Info.ErrorNumber:=1 ELSE Info.ErrorNumber:=0;
   IF (InPoint = -1) OR (OutPoint = -1) THEN CStatus:=Compiller_NoSF ELSE CStatus:=Compiller_NoError;
   WorkStatus:=255;
  END;
 END;

 PROCEDURE SaveMapFile(map_type: byte); {Сохранить карту памяти}
 VAR Map: Text;
     n,k: LongInt;
     ts,ts1: String;
     c: Comp;
 BEGIN
  IF map_type = No_map THEN Exit;
  ts:=MainFileName;
  REPEAT
   IF Pos('\',ts) <> 0 THEN Delete(ts,1,Pos('\',ts));
  UNTIL Pos('\',ts) = 0;
  Assign(Map,MapDirectories+ts+'.MAP');
  {$I-}
  ReWrite(Map);
  {$I+}
  IF IOResult <> 0 THEN BEGIN
   ErrorCompiller(44,1,1,MainFileName+'.MAP');
   Exit;
  END;
  WriteLn(Map,';----------------------------------------------------------------------------;');
  WriteLn(Map,';                         SVM Assembler Compiller                            ;');
  WriteLn(Map,';                               Version 1.2                                  ;');
  WriteLn(Map,';                     Copyright (c) 1999 ShAG Studio                         ;');
  WriteLn(Map,';----------------------------------------------------------------------------;');
  WriteLn(Map,'; WARNING! Main number system is decimal!                                    ;');
  WriteLn(Map,'; In this file you find: procedure list, global and local labels list,       ;');
  WriteLn(Map,'; variables list, entry and finish point, code, data and stack size and      ;');
  WriteLn(Map,'; include files list.                                                        ;');
  WriteLn(Map,';----------------------------------------------------------------------------;');
  WriteLn(Map,'');
  IF (Map_type = Detailed_map) OR (Map_type = Procedures_and_labels_map) THEN BEGIN
   IF ProcNameLabel.TotalStrings <= 1 THEN WriteLn(Map,' ',MapMessages[10]) ELSE BEGIN
    WriteLn(Map,' ',MapMessages[9],'    ',MapMessages[0]);
    FOR n:=1 TO ProcNameLabel.TotalStrings-1 DO BEGIN
     c:=ProcAddrLabel.GetC(n);
     StrValueTo(c,StrComp,ts);
     ts1:='00000000000000000000';
     FOR k:=Length(ts) DOWNTO 1 DO ts1[20-(Length(ts)-k)]:=ts[k];
     Writeln(Map,'  ',ts1,'    ',ProcNameLabel.Get(n));
    END;
   END;
  WriteLn(Map,'');
   IF (GlobalNameLabel.TotalStrings <= 1) AND (LocalNameLabel.TotalStrings <= 1) THEN
    WriteLn(Map,' ',MapMessages[11]) ELSE BEGIN
    WriteLn(Map,' ',MapMessages[9],'    ',MapMessages[1]);
    FOR n:=1 TO GlobalNameLabel.TotalStrings-1 DO BEGIN
     c:=GlobalAddrLabel.GetC(n);
     StrValueTo(c,StrComp,ts);
     ts1:='00000000000000000000';
     FOR k:=Length(ts) DOWNTO 1 DO ts1[20-(Length(ts)-k)]:=ts[k];
     Writeln(Map,'  ',ts1,'    ',GlobalNameLabel.Get(n));
    END;
    FOR n:=1 TO LocalNameLabel.TotalStrings-1 DO BEGIN
     c:=LocalAddrLabel.GetC(n);
     StrValueTo(c,StrComp,ts);
     ts1:='00000000000000000000';
     FOR k:=Length(ts) DOWNTO 1 DO ts1[20-(Length(ts)-k)]:=ts[k];
     Writeln(Map,'  ',ts1,'    ',LocalNameLabel.Get(n));
    END;
   END;
  END;
  WriteLn(Map,'');
  IF (Map_type = Detailed_map) OR (Map_type = Variables_map) THEN BEGIN
   IF VarName.TotalStrings <= 1 THEN WriteLn(Map,' ',MapMessages[12]) ELSE BEGIN
    WriteLn(Map,' ',MapMessages[9],'    ',MapMessages[2]);
    FOR n:=1 TO VarName.TotalStrings-1 DO BEGIN
     c:=VarAddr.GetC(n);
     StrValueTo(c,StrComp,ts);
     ts1:='00000000000000000000';
     FOR k:=Length(ts) DOWNTO 1 DO ts1[20-(Length(ts)-k)]:=ts[k];
     Writeln(Map,'  ',ts1,'    ',VarName.Get(n));
    END;
   END;
  END;
  WriteLn(Map,'');
  IF InPoint > -1 THEN BEGIN
   StrValueTo(InPoint,StrComp,ts);
   WriteLn(Map,' ',MapMessages[3],'     ',ts);
  END ELSE WriteLn(Map,' ',MapMessages[14]);
  IF OutPoint > -1 THEN BEGIN
   StrValueTo(OutPoint,StrComp,ts);
   WriteLn(Map,' ',MapMessages[4],'     ',ts);
  END ELSE WriteLn(Map,' ',MapMessages[15]);
  StrValueTo(CodeCounter,StrComp,ts);
  IF CodeCounter = 0 THEN ts:='0';
  WriteLn(Map,' ',MapMessages[5],'     ',ts,' ',MapMessages[17]);
  StrValueTo(DataSize,StrComp,ts);
  IF DataSize = 0 THEN ts:='0';
  WriteLn(Map,' ',MapMessages[6],'     ',ts,' ',MapMessages[17]);
  StrValueTo(StackSize,StrComp,ts);
  IF StackSize = 0 THEN ts:='0';
  WriteLn(Map,' ',MapMessages[8],'     ',ts,' ',MapMessages[17]);
  Str(TCLine,ts);
  WriteLn(Map,' ',MapMessages[18],'     ',ts);
  IF Includes.TotalStrings > 1 THEN BEGIN
   WriteLn(Map,' ',MapMessages[7]);
   FOR n:=1 TO Includes.TotalStrings-1 DO WriteLn(Map,'  ',Includes.Get(n));
  END ELSE WriteLn(Map,' ',MapMessages[16]);
  WriteLn(Map,'');
  WriteLn(Map,';----------------------------------------------------------------------------;');
  WriteLn(Map,';                              End of map file                               ;');
  WriteLn(Map,';----------------------------------------------------------------------------;');
  Close(Map);
 END;

 PROCEDURE SaveResultToFile(FileName: String); {Сохранить результат компиляции в файл}
 VAR count: LongInt;
     tr: Real;
     l: LongInt;
     b: Byte;
 BEGIN
{  IF (WorkStatus <> 0) OR (WorkStatus <> 255) THEN Exit;}
  {Формат файла:
   Имя поля        Размер    Смещение  Описание
                   в байтах  в файле

   SVM                3         0       Поле всегда равно 'SVM'
   Version            1         3       Код версии
   Code size          8         4       Размер кода
   Data size          8        12       Размер данных
   Stack size         8        20       Размер стека
   Start code         8        28       Начало кода в файле
   Start data         8        36       Начало данных в файле
   Code file size     8        44       Размер кода в файле
   Data file size     8        52       Размер данных в файле
   Entry point        8        60       Точка входа в программу
   Finish point       8        68       Точка выхода из программы    }
   FileTitle.SVM:='SVM';
   FileTitle.Version:=$11;
   FileTitle.CodeSize:=CodeCounter;
   FileTitle.DataSize:=DataSize;
   FileTitle.StackSize:=StackSize;
   FileTitle.EntryPoint:=InPoint;
   FileTitle.FinishPoint:=OutPoint;
   FileTitle.StartCode:=SizeOf(FileTitle);
   FileTitle.CodefSize:=CodeCounter;
   FileTitle.DatafSize:=DataCounter;
   FileTitle.StartData:=FileTitle.StartCode+CodeCounter;
   Assign(Result,FileName);
   ReWrite(Result);
   FOR Count:=1 TO 76 DO Write(Result,FileTitle.Item[Count]);
   tr:=CodeCounter;
   l:=Trunc(tr);
   FOR Count:=0 TO l-1 DO BEGIN
    b:=CodePRG.GetB(Count);
    Write(Result,b);
   END;
   tr:=DataCounter;
   l:=Trunc(tr);
   FOR Count:=0 TO l-1 DO BEGIN
    b:=DataPRG.GetB(Count);
    Write(Result,b);
   END;
   Close(Result);
 END;

 PROCEDURE SaveResultToSVM(VAR Discriptor: OVector); {Сохранить результат компиляции в виртуальной памяти}
 BEGIN
  IF (WorkStatus <> 0) OR (WorkStatus <> 255) THEN Exit;
 END;

 PROCEDURE GetResultInfo(VAR CRInfo: TCRInfo); {Получит информацию о компиляции}
 BEGIN
  CRInfo:=Info;
 END;

 PROCEDURE DoneCompiller; {Освободит всю виртуальнюю память, которая использовалась компилятором}
 BEGIN
  IF (WorkStatus <> 0) OR (CStatus = Compiller_NoInit) THEN Exit;
  InPoint:=-1;
  OutPoint:=-1;
  MessageCounter:=0;
  StackSize:=0;
  StackPresent:=FALSE;
  EQUs.Done;            {Деинициализируем масcив определений}
  EQUd.Done;
  ProcNameLabel.Done;   {Деинициализируем маcсив процедур}
  ProcAddrLabel.Done;
  VarName.Done;         {Деинициализируем маcсив переменных}
  VarAddr.Done;
  VarMode.Done;
  LocalNameLabel.Done;  {Деинициализируем маcсив локальных меток}
  LocalAddrLabel.Done;
  GlobalNameLabel.Done; {Деинициализируем маcсив глобальных меток}
  GlobalAddrLabel.Done;
  FirstLabel.Done;
  LastLabel.Done;
  CodePRG.Done;         {Деинициализация памяти для хранения кода}
  DataPRG.Done;         {Деинициализация памяти для хранения данных}
  Includes.Done;        {Деинициализируется массив имен подключаемых файлов}
  CodeCounter:=0;
  DataSize:=0;
  DataCounter:=0;
  FirstL:=0;
  LastL:=0;
  LCount:=0;
  FirstL:=0;
  LastL:=0;
  LCount:=0;
  CodeCounter:=0;
  Info.SourceFileName:='No file name';
  Info.CodeSize:=0;
  Info.DataSize:=0;
  Info.StackSize:=0;
  Info.TotalMessages:=0;
  Info.TotalStrings:=0;
  Info.TotalMainStrings:=0;
  Info.InPoint:=-1;
  Info.OutPoint:=-1;
  Info.ErrorString:=0;
  Info.ErrorChar:=0;
  Info.ErrorNumber:=1;
  WorkStatus:=1;
  CStatus:=Compiller_NoInit;
 END;

{============================================================================}
BEGIN
 {Первоначально все процедуры индикации процесса компиляции
  устанавливаются как пустые процедуры}
 @ShowCompillInfo:=@FreeProcedure;
 @ErrorCompiller:=@FreeProcedure;
 @MessageCompiller:=@FreeProcedure;
 Info.SourceFileName:='No file name';
 Info.CodeSize:=0;
 Info.DataSize:=0;
 Info.StackSize:=0;
 Info.TotalMessages:=0;
 Info.TotalStrings:=0;
 Info.TotalMainStrings:=0;
 Info.InPoint:=-1;
 Info.OutPoint:=-1;
 Info.ErrorString:=0;
 Info.ErrorChar:=0;
 Info.ErrorNumber:=1;
 WorkStatus:=1;
 CStatus:=Compiller_NoInit;
 IncludeDirectories:='';
 ResultDirectories:='';
 SourceDirectories:='';
END.
{============================================================================}