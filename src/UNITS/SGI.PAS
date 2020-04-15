{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
{=========================ShAG Graphics Interface============================}
{====         Графический интерфейс Штокало Алексея Геннадиевича.        ====}
{====                           Версия 1.0                               ====}
{====--------------------------------------------------------------------====}
{====  Модуль разрешается использовать только в некомерческих целях, при ====}
{==== условии, что исходный текст всех программ написанных с использова- ====}
{==== нием этого модуля получить Штокало Алексей Геннадиевич, на таких   ====}
{==== же правах, как и этот модуль, кроме получения копий программ.      ====}
{====--------------------------------------------------------------------====}
{====  Модуль создан в Turbo Pascal 5.1                                  ====}
{====--------------------------------------------------------------------====}
{====  Модуль позваляет поставить любой из доступных на вашей видеокарте ====}
{==== графических  режимов, при  этом в любом  режиме модуль  работает с ====}
{==== виртуальным экраном и позволяет  работать как в режиме True Color, ====}
{==== т. е. всегда возможна  работа с тремя  интенсивностями для  каждой ====}
{==== точки (Красный, Зеленый, Синий)                                    ====}
{====--------------------------------------------------------------------====}
{====  Номера графических режимов:                                       ====}
{====   0  - CGA режим 640 на 200 точек и 2 физических цвета             ====}
{====   1  - EGA режим 640 на 350 точек и 16 физических цветов           ====}
{====   2  - VGA режим 640 на 480 точек и 16 физичексих цветов           ====}
{====   3  - VGA режим 800 на 600 точек и 16 физических цветов           ====}
{====   4  - VGA режим 320 на 200 точек и 256 физических цветов          ====}
{====   5  - SVGA режим 640 на 480 точек и 256 физических цветов         ====}
{====   6  - SVGA режим 800 на 600 точек и 256 физических цветов         ====}
{====   7  - SVGA режим 1024 на 768 точек и 256 физических цветов        ====}
{====   8  - SVGA режим 1152 на 864 точек и 256 физических цветов        ====}
{====   9  - SVGA режим 1280 на 1024 точек и 256 физических цветов       ====}
{====   10 - зарезервированный                                           ====}
{====   11 - зарезервированный                                           ====}
{====   12 - SVGA режим 640 на 480 точек и 16-ти битный цвет             ====}
{====   13 - SVGA режим 800 на 600 точек и 16-ти битный цвет             ====}
{====   14 - SVGA режим 1024 на 768 точкеу и 16-ти битный цвет           ====}
{====   15 - SVGA режим 1280 на 1024 точек и 16-ти битный цвет           ====}
{====   16 - зарезервированный                                           ====}
{====   17 - зарезервированный                                           ====}
{====   18 - зарезервированный                                           ====}
{====   19 - SVGA режим 640 на 480 точек и 32-х битный цвет              ====}
{====   20 - SVGA режим 800 на 600 точек и 32-х битный цвет              ====}
{====   21 - SVGA режим 1024 на 768 точкеу и 32-х битный цвет            ====}
{====   22 - SVGA режим 1280 на 1024 точек и 32-х битный цвет            ====}
{====   23 - зарезервированный                                           ====}
{====   24 - зарезервированный                                           ====}
{====--------------------------------------------------------------------====}
{============================================================================}
{$M 16384,0,655360}
                                  UNIT SGI;
{============================================================================}
                                  INTERFACE
{=========================== Подключаемые модули ============================}

 USES Crt, Dos, AddGr, SVM_n, Colors, Diz;

{========================= Зарезервированные типы ===========================}

 {Тип содержащий битовую матрицу 16х16, каждый элемент которой может принимать
  значения 0 или 1}
 TYPE TTexture = ARRAY [0..7] OF Byte;

 {Тип  содержащий  информацию  о  цвете:   интенсивности  красного,  зеленого,
  синего  и номер  этого цвета  для режимов 2, 4, 16, 256  цветов, при  других
  режимах содержит произвольные данные}
 TYPE TColor = RECORD
  Red, Green, Blue: Byte;
 END;

 {Тип содержащий информацию о типе кисти для заполнения закрашеных фигур}
 TYPE TFillStyle = RECORD
  Color: TColor;              {Цвет пера}
  BGColor: TColor;            {Цвет фона}
  Texture: TTexture;          {Вид кисти содержится в битовой матрице}
  TextureFill: Boolean;       {True - использовать текстуру, False - нет}
 END;

 {Тип содержащий информацию о типе линии}
 TYPE TLineStyle = RECORD
  Color: TColor;              {Цвет пера, которым будут ставиться точки}
  Mask: Word;                 {Вид линии содержащийся в битовом виде}
  MaskLine: Boolean;          {True - использовать маску, False - нет}
  Size: Word;                 {Размер точки, которой рисуется линия, точка
                              представляет из себя квадрат со стороной Size}
 END;

 {Тип содержащий информацию о типе мышки, используемой при выводе курсора}
 TYPE TMouse = RECORD
  OffX,              {Смещение изображения курсора, относитель координат мыши}
  OffY,              {по соям X и Y}
  SizeX,             {Размер выводимого изображения, если оно меньше 32 на 32}
  SizeY: ShortInt;   {по осям X и Y}
  Cursor: ARRAY [0..31,0..31] OF Byte; {Изображение курсора в 16 цветах по их
                     номеру, если номер цвета точки больше 16, то такая точка
                     не выводится на экран}
 END;

 TYPE PTexture = ^TTexture;
 TYPE PColor = ^TColor;
 TYPE PFillStyle = ^TFillStyle;
 TYPE PLineStyle = ^TLineStyle;
 TYPE PMouse = ^TMouse;

 {тип процедуры вывода точки}
 TYPE PPixType = PROCEDURE (x,y : Word);

 {тип функций возвращающей информацию о цвете в заданной точке}
 TYPE GPixType = PROCEDURE (x,y : Word);

 TYPE TFon = ARRAY [0..31,0..31] OF Byte;

 TYPE TDizTable = ARRAY [0..65,0..7] OF Byte;

 TYPE TDMatrix = ARRAY [0..7,0..7] OF Byte;

{============================ Процедуры и функции ===========================}

 PROCEDURE  InitGI(Mode : Byte);        {Процедура инициализации графики}

 PROCEDURE  DestroyGI;                  {Процедура де-инициализации графики}

 PROCEDURE  PutPixel(x, y: Word);       {Процедура рисования точки}

 FUNCTION   GetPixel(x, y: Word): PColor; {Функция возвращает цвет точки}

 PROCEDURE  SetColor(Col: TColor); {Процедура установки цвета для вывода точек}

 PROCEDURE  SetLineStyle(LS: TLineStyle); {Процедура установки стандартного типа линии}

 PROCEDURE  SetFillStyle(FS: TFillStyle); {Процедура устаноки стандартной заливки}

 PROCEDURE  SetWindow(x1, y1, x2, y2: Word); {Устанавливает границы экрана}

 PROCEDURE  Line(ax, ay, bx, by: Integer); {Процедура вывода линии}

 PROCEDURE  Rect(ax, ay, bx, by: Integer); {Процедура вывода пустого прямоугольника
                                         стандартный пером и цветом}

 PROCEDURE  FillRect(ax, ay, bx, by: Integer); {Процедура вывода прямоугольника
                                   закрашенного стандартной кистью и цветом}

 PROCEDURE  Ellipse(ax, ay, bx, by: Integer); {Процедура вывода пустого еллипса
                                            стандартным пером и цветом}

 PROCEDURE  FillEllipse(ax, ay, bx, by: Integer); {Процедура вывода эллипса
                                   закрашеного стандартной кистью и цветом}
 PROCEDURE  LoadColorTable;

 PROCEDURE  SaveColorTable;

 PROCEDURE  SetMouseWindow(ax, ay, bx, by: Word); {Процедура задает область перемещения мыши}

 PROCEDURE  SetMouseTo(x,y: Word);                {Процедура перемещает мышь на новые координаты}

 PROCEDURE  MouseRun;                             {Процедура производить контроль работы мыши и её вывод на экран}

 PROCEDURE  SetMouseStep(Hor, Ver: Word);         {Процедура устанавливает шаг миши}

 FUNCTION   MouseIn(x1,y1,x2,y2: Word): Boolean;  {Функция проверяет мышь на нахождение в определенном месте}

 FUNCTION   MousePressed: Boolean;                {Функция проверяет на нажатие любой кнопки мыши}

 PROCEDURE  ShowMouse;
  {Процедуры типа PutPixM[n] и GetPixM[n] являются процедурами вывода точки и
   процедурами  возврата значения  цвета  в конкретной  точке  для  различных
   графических  режимов.  Здесь  [n] - номер  режима,а [] - квадратные скобки
   опускаются при создании имени процедуры}

{============ Функции вывода и ввода точек для разных режимов ===============}
 {Режим 3}
 PROCEDURE  PutPixM1(x, y : Word);
 PROCEDURE  GetPixM1(x, y : Word);
 {Режим 1 и 2}
 PROCEDURE  PutPixM2(x, y : Word);
 PROCEDURE  GetPixM2(x, y : Word);
 {Режим 0}
 PROCEDURE  PutPixM3(x, y : Word);
 PROCEDURE  GetPixM3(x, y : Word);
 {Режим 5..9}
 PROCEDURE  PutPixM5(x, y : Word);
 PROCEDURE  GetPixM5(x, y : Word);

{=========================== Глобальные переменные ==========================}
 VAR   GIErrorProc: PROCEDURE; {Процедура выдачи ошибок}
       GIError, GIStatus, GetMF: Boolean;
       GIErrorCode, DizR, DizG, DizB, Color_Index, GetColor_Index, GMode, Last: Byte;
       MaxX, MaxY, Lmx, Lmy, WinX1, WinX2, WinY1, WinY2, MouseX, MouseY, LastPage,
       MouseButton, MouseTotalButtons, MouseHorStep, MouseVerStep, DFonR,
       DColorR, DFonG, DColorG, DFonB, DColorB: Word; {размер экрана по X-ам и Y-ам}
       Reg : Registers;
       PutPix :Ppixtype;
       GetPix :Gpixtype;
       Color, LastColor, TempColor: TColor;     {Стандартный цвет для рисования точек}
       FillStyle: TFillStyle; {Стандартный тип для закрашивания фигур}
       LineStyle: TLineStyle; {Стандартный тип для рисования линий}
       MainMouse: PMouse; {Стандартная мышь}
       TempPFillStyle: TFillStyle;
       TempPLineStyle: TLineStyle;
       MouseFon: TFon;
       DMatrix, LastDMatrix: TDMatrix;
       DizTable: TDizTable ABSOLUTE Diz_File; {Таблица масок для дизеринга}
       ColorTable: ARRAY [0..255,0..2] OF Byte ABSOLUTE Colors_File; {Таблица интесивностей}
       MemScreen: ARRAY [0..199,0..319] OF Byte ABSOLUTE $A000:0; {Место графической памяти}
       BF: ARRAY [0..255] OF Byte; {Буфер для VESA 2.0}
 CONST {Текстовое представление ошибок, которые могут возникнут в процессе работы}
       GIErrorMessage: ARRAY [0..7] OF String[80] = (
       'Нет ошибок.',
       'Модуль не инициализирован.',
       'Ошибка выбора видеорежима.',
       'Данный видеорежим не потдерживается вашим видеоадаптером.',
       'Виртуальная память не инициализированна.',
       'Нехватает памяти.',
       'Объект небыл инициализирован.',
       'Видеоадаптер не потдерживает графический протокол SVGA VESA 2.0');

       TStep:ARRAY [0..15] OF Word = (32768,16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1);
       {Стандартные кнопки мыши}
       LeftButton = 1;
       RightButton = 2;
       LeftRightButton = 3;
       {Стнадартная мышь}
       StdMouse: TMouse = (OffX:0; OffY:0; SizeX:12; SizeY:21; Cursor:
       ((00,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,15,15,00,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,00,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,15,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,15,15,00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,15,00,00,99,00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (00,00,99,99,99,00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,00,15,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,00,15,15,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,00,00,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99),
        (99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99)));

        {Таблица соответствия цветов}
       Diffuze: ARRAY [0..1,0..15,0..15] OF Byte = (
       (( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15),
        ( 1, 1, 3, 0, 5, 0, 8, 0, 0, 7,11, 0,13, 0,15, 0),
        ( 2, 3, 2, 0, 6, 0, 0, 0, 0,11, 0, 0,14, 0, 0, 0),
        ( 3, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 4, 5, 6, 0, 4, 0, 0, 0, 0,13,14, 0, 0, 0, 0, 0),
        ( 5, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 6, 8, 0, 0, 0, 0, 6, 0, 0, 7, 0, 0, 0, 0, 0, 0),
        ( 7, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 8, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0),
        ( 9, 0,11, 0,13, 0, 7, 0, 0, 9,11, 0,13, 0,15, 0),
        (10,11, 0, 0,14, 0, 0, 0, 0,11,10, 0,14, 0, 0, 0),
        (11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,11, 0, 0, 0, 0),
        (12,13,14, 0, 0, 0, 0, 0, 0,13,14, 0,12, 0, 0, 0),
        (13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,13, 0, 0),
        (14, 7, 0, 0, 0, 0, 0, 0, 0,15, 0, 0, 0, 0,14, 0),
        (15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,15)),
       (( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15),
        ( 1, 1, 3, 0, 5, 0, 8, 0, 0, 7, 3, 0, 5, 0,15, 0),
        ( 2, 3, 2, 0, 6, 0, 0, 0, 0, 3, 0, 0, 6, 0, 0, 0),
        ( 3, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 4, 5, 6, 0, 4, 0, 0, 0, 0, 5, 6, 0, 0, 0, 0, 0),
        ( 5, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 6, 8, 0, 0, 0, 0, 6, 0, 0, 7, 0, 0, 0, 0, 0, 0),
        ( 7, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0),
        ( 8, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0),
        ( 9, 0, 3, 0, 5, 0, 7, 0, 0, 9,11, 0,13, 0,15, 0),
        (10, 3, 0, 0, 6, 0, 0, 0, 0,11,10, 0,14, 0, 0, 0),
        (11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,11, 0, 0, 0, 0),
        (12, 5, 6, 0, 0, 0, 0, 0, 0,13,14, 0,12, 0, 0, 0),
        (13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,13, 0, 0),
        (14, 7, 0, 0, 0, 0, 0, 0, 0,15, 0, 0, 0, 0,14, 0),
        (15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,15)));

       {Стандартные цвета}
       Black:TColor = (Red:0; Green:0; Blue:0);
       Blue:TColor = (Red:0; Green:0; Blue:128);
       Green:TColor = (Red:0; Green:128; Blue:0);
       Cyan:TColor = (Red:0; Green:128; Blue:128);
       Red:TColor = (Red:128; Green:0; Blue:0);
       Magenta:TColor = (Red:128; Green:0; Blue:128);
       Yellow :TColor = (Red:128; Green:128; Blue:0);
       LightGray:TColor = (Red:192; Green:192; Blue:192);
       DarkGray:TColor = (Red:64; Green:64; Blue:64);
       LightBlue:TColor = (Red:0; Green:0; Blue:255);
       LightGreen:TColor = (Red:0; Green:255; Blue:0);
       LightCyan:TColor = (Red:0; Green:255; Blue:255);
       LightRed:TColor = (Red:255; Green:0; Blue:0);
       LightMagenta:TColor = (Red:255; Green:0; Blue:255);
       LightYellow:TColor = (Red:255; Green:255; Blue:0);
       White:TColor = (Red:255; Green:255; Blue:255);
       {Стандартные текстуры}
       Full: TTexture = (255,255,255,255,255,255,255,255);{
       Ansi31: TTexture = (4369,8738,17476,34952,4369,8738,17476,34952,4369,8738,17476,34952,4369,8738,17476,34952);
       Ansi32: TTexture = (5140,10280,20560,41120,5140,10280,20560,41120,5140,10280,20560,41120,5140,10280,20560,41120);
       Ansi33: TTexture = (5397,10794,21588,43176,5397,10794,21588,43176,5397,10794,21588,43176,5397,10794,21588,43176);
{       Ansi34, Ansi35, Ansi36, Ansi37, Ansi38,
       Box, Brass, Brick, Clay, Cork, Cross, Dash, Dolmit, Dots, Earth,
       Escher, Flex, Grass, Grate, Hex, Honey, Hound, Insul, Lines, Mudst,       Net
       Net3, Plast, Plast1, Sacncr, Scuare, Stars, Stell, Swamp, Trans,}

{============================================================================}
                               IMPLEMENTATION
{============================================================================}

{=========== Процедуры и функции используемые основными процедурами =========}

 PROCEDURE  GITempErrorProc;
 BEGIN
  {Процедура вызывается каждый раз когда возникает ошибка, первоночально она
   ничего неделает, но при  желании её можно переопределить}
 END;

 PROCEDURE  PixelErrorProc;
 BEGIN
  GIError:=True;
  GIErrorCode:=1;
  GIErrorProc;
 END;

 PROCEDURE  GetMouseFon;
 VAR x,y,x1,y1: Integer;
 BEGIN
  x1:=MouseX+MainMouse^.OffX;
  y1:=Mousey+MainMouse^.Offy;
  FOR y:=y1 TO y1+MainMouse^.SizeY DO
   FOR x:=x1 TO x1+MainMouse^.SizeX DO BEGIN
    GetPix(x,y);
    MouseFon[x-x1,y-y1]:=GetColor_Index;
   END;
 END;

 PROCEDURE  ShowMouse;
 VAR x,y,x1,y1,tx,ty,c: Integer;
 BEGIN
  x1:=MouseX+MainMouse^.OffX;
  y1:=Mousey+MainMouse^.Offy;
  TempColor:=Color;
  FOR y:=y1 TO y1+MainMouse^.SizeY DO
   FOR x:=x1 TO x1+MainMouse^.SizeX DO BEGIN
    ASM
     MOV ax,x
     MOV bx,x1
     SUB ax,bx
     MOV tx,ax
     MOV ax,y
     MOV bx,y1
     SUB ax,bx
     MOV ty,ax
    END;
    IF GetMF THEN BEGIN
     GetPix(x,y);
     MouseFon[tx,ty]:=GetColor_Index;
     END;
    c:=MainMouse^.Cursor[ty,tx];
    IF c < 16 THEN BEGIN
     Color_Index:=c;
     PutPix(x,y);
    END ELSE BEGIN
     Color_Index:=MouseFon[tx,ty];
     PutPix(x,y);
    END;
   END;
  GetMF:=False;
  Color:=TempColor;
 END;

 PROCEDURE  ShowMouseFon;
 VAR x,y,x1,y1: Integer;
 BEGIN
  x1:=LmX+MainMouse^.OffX;
  y1:=LmY+MainMouse^.Offy;
  TempColor:=Color;
  FOR y:=y1 TO y1+MainMouse^.SizeY DO
   FOR x:=x1 TO x1+MainMouse^.SizeX DO BEGIN
    Color_Index:=MouseFon[x-x1,y-y1];
    PutPix(x,y);
   END;
  Color:=TempColor;
 END;

{=========================== Основные процедуры =============================}

 PROCEDURE  InitGI(Mode : Byte);
 VAR r1, r2, r3: Word;
 BEGIN
   {Инициализация мышки}
   ASM
    MOV AX,0
    INT $33
    MOV MouseTotalButtons, BX
   END;
   CASE Mode OF
    0:BEGIN
       MaxX:=640;
       MaxY:=200;
       {Включаем графический режим CGA 640 на 200 на 2 цвета}
       Reg.ah:=0;
       Reg.al:=$6;
       Intr($10, Reg);
       @PutPix:=@PutPixM3;
       @GetPix:=@GetPixM3;
      END;
    1:BEGIN
       MaxX:=640;
       MaxY:=350;
       {Включаем графический режим EGA 640 на 350 и на 16 цветов}
       Init;
       Reg.ah:=0;
       Reg.al:=$10;
       Intr($10, Reg);
       @PutPix:=@PutPixM2;
       @GetPix:=@GetPixM2;
      END;
    2:BEGIN
       MaxX:=640;
       MaxY:=480;
       {Включаем графический режим VGA 640 на 480 на 16 цветов}
       Init;
       Reg.ah:=0;
       Reg.al:=$12;
       Intr($10, Reg);
       @PutPix:=@PutPixM2;
       @GetPix:=@GetPixM2;
      END;
    4:BEGIN
       MaxX:=320;
       MaxY:=200;
       {Включаем графический режим VGA 320 на 200 и 256 цветов}
       Reg.ah:=0;
       Reg.al:=$13;
       Intr($10, Reg);
       @PutPix:=@PutPixM1;
       @GetPix:=@GetPixM1;
      END;
    5..9: BEGIN
       CASE Mode OF
        5: r1:=$101;
        6: r1:=$103;
        7: r1:=$105;
        8: r1:=$107;
        9: r1:=$109;
       END;
       LastPage:=0;
       r2:=Seg(BF);
       r3:=Ofs(BF[0]);
       ASM
        MOV AX, $4F02
        MOV BX, r1
        INT $10
        MOV AX, $4F01
        MOV CX, r1
        MOV ES, r2
        MOV DI, r3
        INT $10
       END;
       IF MemW[r2:r3+4]=0 THEN MemW[r2:r3+4]:=1;
       Last:=MemW[r2:r3+6] div MemW[r2:r3+4];
       MaxX:=MemW[r2:r3+$12];
       MaxY:=MemW[r2:r3+$14];
       IF (MaxX = 0) OR (MaxY = 0) THEN BEGIN
        WriteLn('Ошибка: '+GIErrorMessage[7]);
        Halt(0);
       END;
       @PutPix:=@PutPixM5;
       @GetPix:=@GetPixM5;
      END;
    ELSE BEGIN
     {Ошибка, неправельный видеорежим}
     GIStatus:=False;
     GIError:=True;
     GIErrorCode:=2;
     GIErrorProc;
    END;
   END;
   GIStatus:=True;
   SaveColorTable;
   SetMouseWindow(0,0,MaxX-1,MaxY-1);
   SetMouseTo(MaxX DIV 2 - 1, MaxY DIV 2 - 1);
   MouseButton:=0;
   GetMF:=True;
   WinX1:=0; WinX2:=MaxX - 1;
   WinY1:=0; WinY2:=MaxY - 1;
   ShowMouse;
   GIError:=False;
   GIErrorCode:=0;
 END;

{======================================}

 PROCEDURE  DestroyGI;
 BEGIN
  IF GIStatus THEN BEGIN
   {Включаем текстовый режим}
   Reg.ah:=0;
   Reg.al:=$3;
   Intr($10, Reg);
  END ELSE BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIerrorProc;
  END;
 END;

{======================================}

 PROCEDURE  PutPixM1(x, y : Word);
 VAR b:Byte;
 BEGIN
  b:=Color_Index;
   ASM
    MOV cx, x
    CMP cx, WinX1
    JL  @exit
    CMP cx, WinX2
    JG  @exit
    MOV cx, y
    CMP cx, WinY1
    JL  @exit
    CMP cx, WinY2
    JG  @exit

    mov  ax,$A000
    mov  es,ax          {es = $A000}
    mov  ax,y
    mov  bx,320         {ax=y*320}
    mul  bx
    mov  bx,x           {bx=ax+x}
    add  bx,ax
    mov  al,b
    mov  es:[bx],al
   @exit:
   END;
 END;
{======================================}

 PROCEDURE  GetPixM1(x,y : Word);
 VAR b:Byte;
 BEGIN
   ASM
    mov  b,0
    cmp  x, 0
    jl  @exit
    cmp  y, 0
    jl  @exit
    mov  ax, MaxX
    cmp  ax, x
    jng  @exit
    mov  ax, MaxY
    cmp  ax, y
    jng  @exit

    mov  ax,$A000
    mov  es,ax          {es = $A000}
    mov  ax,y
    mov  bx,320         {ax=y*320}
    mul  bx
    mov  bx,x           {bx=ax+x}
    add  bx,ax
    mov  al,es:[bx]
    mov  b,al
   @exit:
   END;
  GetColor_Index:=b;
 END;

{======================================}

 PROCEDURE  PutPixM2(x, y: Word);
 VAR b,bb:Byte;
     w:Word;
 BEGIN
   b:=Color_Index;
   bb:=128 SHR (x MOD 8);
   ASM
    MOV cx, x
    CMP cx, WinX1
    JL  @exit
    CMP cx, WinX2
    JG  @exit

    MOV cx, y
    CMP cx, WinY1
    JL  @exit
    CMP cx, WinY2
    JG  @exit

    {Вычисляем адрес байта в видеопамяти}
    MOV  ax, $A000
    MOV  es, ax          {es = $A000}
    MOV  ax, y
    MOV  bx, 80
    MUL  bx
    MOV  cx, ax
    MOV  ax, x
    MOV  bx, 8
    DIV  bx
    MOV  bx, cx
    ADD  bx, ax
    {Устанавливаем режим записи 2}
    MOV  dx, $3CE
    MOV  al, 5
    OUT  dx, al
    INC  dx
    MOV  al, 2
    OUT  dx, al
    DEC  dx
    {Разрешаем изменять только биты символа}
    MOV  al, 8
    OUT  dx, al
    INC  dx
    MOV  al, bb          {Разрешены биты символа}
    OUT  dx, al
    {Выводим символ}
    MOV  al, es:[bx]
    MOV  al, b
    MOV  es:[bx], al
    @exit:
   END;
 END;

{======================================}

 PROCEDURE  GetPixM2(x,y : Word);
 BEGIN
  GetColor_Index:=GPix(x,y);
 END;

{======================================}

 PROCEDURE  PutPixM3(x, y : Word);
 VAR b:Word;
     tb:Byte;
 BEGIN
  IF (x < MaxX) AND (y < MaxY) THEN
   IF Color_index=0 THEN BEGIN
    b:=(y DIV 2)*80+Ord(Odd(y))*$2000 + x DIV 8;
    tb:=Mem[$B800:b];
    Mem[$B800:b]:=tb XOR (tb AND TStep[7-x MOD 8]);
   END ELSE BEGIN
    b:=(y DIV 2)*80+Ord(Odd(y))*$2000 + x DIV 8;
    Mem[$B800:b]:=Mem[$B800:b] OR TStep[7-x MOD 8];
   END;
 END;

{======================================}

 PROCEDURE  GetPixM3(x,y : Word);
 BEGIN
  IF (X < MaxX) AND (Y < MaxY) THEN
   GetColor_Index:=Mem[$B800:(y DIV 2)*80+Ord(Odd(y))*$2000 + x DIV 8]
                       AND TStep[7-x MOD 8] ELSE GetColor_Index:=0;
 END;

{======================================}

 PROCEDURE  PutPixM5(x, y : Word);
 VAR o: LongInt;
     VPage: Word;
 BEGIN
  o:=y*MaxX+x;
  VPage:=o DIV 65536;
  VPage:=VPage*Last;
  IF LastPage <> VPage THEN BEGIN
   ASM
    MOV AH, $4F
    MOV AL, $05
    MOV BX, 0
    MOV DX, VPage
    INT $10
   END;
   LastPage:=Vpage;
  END;
  Mem[$A000:o MOD 65536]:=Color_Index;
 END;

{======================================}

 PROCEDURE  GetPixM5(x,y : Word);
 VAR o: LongInt;
     VPage: Word;
 BEGIN
  o:=y*MaxX+x;
  VPage:=o DIV 65536;
  VPage:=VPage*Last;
  IF LastPage <> VPage THEN BEGIN
   ASM
    MOV AH, $4F
    MOV AL, $05
    MOV BX, 0
    MOV DX, VPage
    INT $10
   END;
   LastPage:=Vpage;
  END;
  GetColor_Index:=Mem[$A000:o MOD 65536];
 END;

{======================================}

 PROCEDURE  PutPixel(x, y: Word);
 LABEL exitt,elsee,doo;
 VAR   t,t1,t2,t3,t4,t5,t6,x1,y1: Word;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим не был инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  x1:=x MOD 8;
  y1:=y MOD 8;
  t:=1 SHL x1;
  DMatrix[x1,y1]:=0;
  t1:=(x1 MOD 2) XOR (y1 MOD 2);
  IF DizTable[DizR,y1] AND t <> t THEN DMatrix[x1,y1]:=DColorR
     ELSE DMatrix[x1,y1]:=DFonR;
  IF DizTable[DizG,y1] AND t <> t THEN DMatrix[x1,y1]:=Diffuze[t1,DMatrix[x1,y1],DColorG]
     ELSE DMatrix[x1,y1]:=Diffuze[t1,DFonG,DMatrix[x1,y1]];
  IF DizTable[DizB,y1] AND t <> t THEN DMatrix[x1,y1]:=Diffuze[t1,DColorB,DMatrix[x1,y1]]
     ELSE DMatrix[x1,y1]:=Diffuze[t1,DFonB,DMatrix[x1,y1]];
  Color_Index:=DMatrix[x1,y1];
  t1:=MainMouse^.Offx;
  t2:=MainMouse^.SizeX;
  t3:=MainMouse^.Offy;
  t4:=MainMouse^.SizeY;
  ASM           {Проверка на нахождение в пределах окна и вне пределах миши}
   MOV bx, t2
   ADD bx, t1
   MOV t2, bx
   MOV bx, t4
   ADD bx, t3
   MOV t4, bx

   MOV bx, t1
   ADD bx, MouseX
   CMP x, bx
   JL  elsee
   MOV bx, t2
   ADD bx, MouseX
   CMP x, bx
   JG  elsee

   MOV bx, t3
   ADD bx, MouseY
   CMP y, bx
   JL  elsee
   MOV bx, t4
   ADD bx, MouseY
   CMP y, bx
   JG  elsee
   MOV ax, x
   SUB ax, MouseX
   SUB ax, t1
   MOV t5, ax
   MOV ax, y
   SUB ax, MouseY
   SUB ax, t3
   MOV t6, ax
  END;
   MouseFon[t5, t6]:=Color_Index;
   IF MainMouse^.Cursor[t6, t5] > 15 THEN PutPix(x,y);
  GOTO exitt;
  elsee:
   PutPix(x,y);
  exitt:
 END;

{======================================}

 FUNCTION   GetPixel(x, y: Word): PColor;
 LABEL exitt;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим не был инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIerrorProc;
   Exit;
  END;
  ASM
   MOV cx, x
   CMP cx, WinX1
   JL  exitt
   CMP cx, WinX2
   JG  exitt

   MOV cx, y
   CMP cx, WinY1
   JL  exitt
   CMP cx, WinY2
   JG  exitt
  END;
  IF (x >= MouseX+MainMouse^.Offx) AND (x <= MouseX+MainMouse^.Offx+MainMouse^.SizeX) AND
   (y >= MouseY+MainMouse^.Offy) AND (y <= MouseY+MainMouse^.Offy+MainMouse^.SizeY) THEN BEGIN
    GetPixel^.Red:=ColorTable[MouseFon[x-MouseX-MainMouse^.Offx,y-MouseY-MainMouse^.Offy],0];
    GetPixel^.Green:=ColorTable[MouseFon[x-MouseX-MainMouse^.Offx,y-MouseY-MainMouse^.Offy],1];
    GetPixel^.Blue:=ColorTable[MouseFon[x-MouseX-MainMouse^.Offx,y-MouseY-MainMouse^.Offy],2];
  END ELSE BEGIN
   GetPix(x,y);
   GetPixel^.Red:=ColorTable[GetColor_Index,0];
   GetPixel^.Green:=ColorTable[GetColor_Index,1];
   GetPixel^.Blue:=ColorTable[GetColor_Index,2];
  END;
  exitt:
 END;

{======================================}

 PROCEDURE  SetColor(Col: TColor);
 VAR    x, y, t, t1: Byte;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  {Проверка на совпадение с предыдущим цветом}
  IF (Col.Red = LastColor.Red) AND
     (Col.Green = LastColor.Green) AND
     (Col.Blue = LastColor.Blue) THEN BEGIN
     DMatrix:=LastDMatrix;
     Exit;
     END;
  Color:=Col;
  IF Col.Green+Col.Blue > 256 THEN BEGIN
   DizR:=(64*Col.Red) DIV 255;
   DFonR:=0;
   DColorR:=12;
  END ELSE BEGIN
   DizR:=(128*Col.Red) DIV 255;
   t:=Col.Red DIV 129;
   Dec(DizR,64*t);
   DFonR:=4*t;
   DColorR:=4+8*t;
  END;
  IF Col.Red+Col.Blue > 256 THEN BEGIN
   DizG:=(64*Col.Green) DIV 255;
   DFonG:=0;
   DColorG:=10;
  END ELSE BEGIN
   t:=Col.Green DIV 129;
   DizG:=(128*Col.Green) DIV 255;
   Dec(DizG,64*t);
   DFonG:=2*t;
   DColorG:=2+8*t;
  END;
  IF Col.Red+Col.Green > 256 THEN BEGIN
   DizB:=(64*Col.Blue) DIV 255;
   DFonB:=0;
   DColorB:=9;
  END ELSE BEGIN
   t:=Col.Blue DIV 129;
   DizB:=(128*Col.Blue) DIV 255;
   Dec(DizB,64*t);
   DFonB:=t;
   DColorB:=1+8*t;
  END;
  IF (Col.Red = Col.Green) AND (Col.Red = Col.Blue) THEN BEGIN
   CASE Col.Red OF
   0..64:
    BEGIN
     DizR:=Col.Red;
     DFonR:=0;
     DColorR:=8;
    END;
   65..192:
    BEGIN
     DizR:=(128*(Col.Red-64)) DIV 255;
     DFonR:=8;
     DColorR:=7;
    END;
   193..255:
    BEGIN
     DizR:=Col.Red-192;
     DFonR:=7;
     DColorR:=15;
    END;
   END;
   ASM
    MOV DColorG, 0
    MOV DFonG, 0
    MOV DizG, 0
    MOV DColorB, 0
    MOV DFonB, 0
    MOV DizB, 0
   END;
  END;
  ASM
   CMP Col.Red, 0
   JNE @Gr
   MOV DColorR, 0
   MOV DFonR, 0
   MOV DizR, 0
   @Gr:
   CMP Col.Green, 0
   JNE @Bl
   MOV DColorG, 0
   MOV DFonG, 0
   MOV DizG, 0
   @Bl:
   CMP Col.Blue, 0
   JNE @Next
   MOV DColorB, 0
   MOV DFonB, 0
   MOV DizB, 0
   @Next:
  END;
  LastColor:=Color;
  LastDMatrix:=DMatrix;
 END;

{======================================}

 PROCEDURE  SetLineStyle(LS: TLineStyle);
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  LineStyle:=LS;
 END;

{======================================}

 PROCEDURE  SetFillStyle(FS: TFillStyle);
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  FillStyle:=FS;
 END;
{======================================}

 PROCEDURE  Line(ax, ay, bx, by: Integer);
 VAR l, l1: Integer;
  PROCEDURE Pixels(x1,y1: Integer);
  VAR x,y: Integer;
  BEGIN
   FOR x:=x1-l TO x1+l1 DO
    FOR y:=y1-l TO y1+l1 DO PutPixel(x, y);
  END;
  PROCEDURE LLine(x1, y1, x2, y2: Integer);
  VAR tx, ty: Integer;
  BEGIN
   tx:=(x1+x2) DIV 2;
   ty:=(y1+y2) DIV 2;
   IF ((x2-x1) DIV 2 <> 0) OR ((y2-y1) DIV 2 <> 0) THEN BEGIN
    PixelS(tx,ty);
    LLine(x1,y1,tx,ty);
    LLine(tx,ty,x2,y2);
   END;
  END;
 BEGIN
  TempColor:=Color;
  SetColor(LineStyle.Color);
  l:=(LineStyle.Size-1) DIV 2;
  l1:=(LineStyle.Size-1) - l;
  PixelS(ax,ay);
  PixelS(bx,by);
  LLine(ax,ay,bx,by);
  SetColor(TempColor);
 END;

{======================================}

 PROCEDURE  Rect(ax, ay, bx, by: Integer);
 VAR x,y,l,l1,x1,y1:Word;
 BEGIN
{  l:=(LineStyle.Size-1) DIV 2;
  l1:=(LineStyle.Size-1) - l;}
  TempColor:=Color;
  SetColor(LineStyle.Color);
  FOR x:=ax TO bx DO BEGIN
   {FOR x1:=x-l TO x+l1 DO
    FOR y1:=ay-l TO ay+l1 DO PutPixel(x1, y1);
   FOR x1:=x-l TO x+l1 DO
    FOR y1:=by-l TO by+l1 DO PutPixel(x1, y1);}
   PutPixel(x, ay);
   PutPixel(x, by);
  END;
  FOR y:=ay TO by DO BEGIN
{   FOR x1:=ax-l TO ax+l1 DO
    FOR y1:=y-l TO y+l1 DO PutPixel(x1, y1);
   FOR x1:=bx-l TO bx+l1 DO
    FOR y1:=y-l TO y+l1 DO PutPixel(x1, y1);}
   PutPixel(ax, y);
   PutPixel(bx, y);
  END;
  SetColor(TempColor);
 END;

{======================================}

 PROCEDURE  FillRect(ax, ay,bx, by: Integer);
 VAR x,y:Word;
 BEGIN
  TempColor:=Color;
  SetColor(FillStyle.Color);
  FOR x:=ax TO bx DO
   FOR y:=ay TO by DO {IF (FillStyle.Texture[y MOD 8] AND TStep[x MOD 8] = TStep[x MOD 8]) OR NOT FillStyle.TextureFill
    THEN} PutPixel(x,y);
{  SetColor(FillStyle.BGColor);
  IF FillStyle.TextureFill THEN
  FOR x:=ax TO bx DO
   FOR y:=ay TO by DO IF (FillStyle.Texture[y MOD 8] AND TStep[x MOD 8] <> TStep[x MOD 8])
    THEN PutPixel(x,y);}
  SetColor(TempColor);
 END;

{======================================}

 PROCEDURE  Ellipse(ax, ay, bx, by: Integer);
 VAR rx,ry,centerx,centery,n,x1,y1,i,x,y,l,l1:Word;
 BEGIN
  TempColor:=Color;
  SetColor(LineStyle.Color);
  rx:=(bx-ax) DIV 2;
  ry:=(by-ay) DIV 2;
  centerx:=ax+rx;
  centery:=ay+ry;
  n:=(ry+rx)*4;
{  l:=(LineStyle.Size-1) DIV 2;
  l1:=(LineStyle.Size-1) - l;}
  FOR i:=0 TO n DO BEGIN
   x:=trunc(centerx+rx*sin(2*pi*i/(n+0.01)));
   y:=trunc(centery+ry*cos(2*pi*i/(n+0.01)));
{   FOR x1:=x-l TO x+l1 DO
    FOR y1:=y-l TO y+l1 DO PutPixel(x1,y1);}
   PutPixel(x,y);
  END;
  SetColor(TempColor);
 END;

{======================================}

 PROCEDURE  FillEllipse(ax, ay, bx, by: Integer);
 VAR rx,ry,centerx,centery,n,x,y,i,tx:Integer;
 BEGIN
  TempColor:=Color;
  rx:=(bx-ax) DIV 2;
  ry:=(by-ay) DIV 2;
  centerx:=ax+rx;
  centery:=ay+ry;
  n:=(ry+rx)*4;
  SetColor(FillStyle.Color);
  FOR i:=0 TO n DO BEGIN
   tx:=trunc(rx*sin(2*pi*i/(n+0.01)));
   y:=trunc(centery+ry*cos(2*pi*i/(n+0.01)));
   FOR x:=centerx-tx TO centerx+tx DO
{    IF (FillStyle.Texture[y MOD 8] AND TStep[x MOD 8] = TStep[x MOD 8]) OR NOT FillStyle.TextureFill
     THEN} PutPixel(x,y);
  END;
{  SetColor(FillStyle.BGColor);
  IF FillStyle.TextureFill THEN
  FOR i:=0 TO n DO BEGIN
   tx:=trunc(rx*sin(2*pi*i/n));
   y:=trunc(centery+ry*cos(2*pi*i/n));
   FOR x:=centerx-tx TO centerx+tx DO
    IF FillStyle.Texture[y MOD 8] AND TStep[x MOD 8] <> TStep[x MOD 8]
     THEN PutPixel(x,y);
  END;}
  SetColor(TempColor);
 END;

{======================================}

 PROCEDURE  SaveColorTable;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  Reg.ax:=Seg(ColorTable);
  Reg.es:=Reg.ax;
  Reg.ah:=$10;
  Reg.al:=$12;
  Reg.dx:=Ofs(ColorTable);
  Reg.bx:=0;
  Reg.cx:=256;
  Intr($10,Reg);
 END;

{======================================}

 PROCEDURE  LoadColorTable;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  Reg.ax:=Seg(ColorTable);
  Reg.es:=Reg.ax;
  Reg.dx:=Ofs(ColorTable);
  Reg.ah:=$10;
  Reg.al:=$17;
  Reg.bx:=0;
  Reg.cx:=256;
  Intr($10,Reg);
 END;

{======================================}

 PROCEDURE  SetWindow(x1, y1,x2, y2:Word);
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  WinX1:=x1; WinX2:=x2;
  WinY1:=y1; WinY2:=y2;
 END;

{======================================}

 PROCEDURE  SetMouseWindow(ax, ay, bx, by: Word);
 VAR tx,tx1:Word;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  tx:=ax;
  tx1:=bx;
   ASM  {Задание области перемещения мыши}
    MOV AX, 7
    MOV CX, tx
    MOV DX, tx1
    INT $33
    MOV AX, 8
    MOV CX, ay
    MOV DX, by
    INT $33
   END;
 END;

{======================================}

 PROCEDURE  SetMouseTo(x,y: Word);
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  ASM  {Установка мыши в определенное место экрана}
   MOV AX,4
   MOV CX,x
   MOV DX,y
   INT $33
  END;
  MouseX:=x;
  MouseY:=y;
 END;

{======================================}

 PROCEDURE   MouseRun;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
   GetMF:=True;
   ASM
    MOV ax,3
    INT $33
    CMP bx,0   {Проверка на изменение клавиш}
    JE  @next
    MOV MouseButton,bx
    @next:
    MOV ax, MouseX {Проверка на изменение положения мыши}
    CMP ax,cx
    JNE @begin
    MOV ax, MouseY
    CMP ax,dx
    JE  @exit
    @begin:
    MOV ax,MouseX
    MOV Lmx,ax
    MOV ax,MouseY
    MOV Lmy,ax
    MOV MouseX,cx
    MOV MouseY,dx
    CALL [ShowMouseFon] {Востанавливаем старый фон мыши}
    CALL [ShowMouse]    {Рисуем курсор мыши}
    @exit:
   END;
   GetMF:=False;
 END;

{======================================}

 PROCEDURE  SetMouseStep(Hor, Ver: Word);
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  WITH Reg DO BEGIN
   ax := $0F;
   cx := Hor AND $7FFF;
   dx := Ver AND $7FFF;
   MouseHorStep := cx;
   MouseVerStep := dx;
   Intr($33,Reg)
  END;
 END;

{======================================}

 FUNCTION   MouseIn(x1,y1,x2,y2: Word): Boolean;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  WITH Reg DO BEGIN
   ax := $3;
   Intr($33,Reg);
   MouseIn:=(cx>=x1) AND (cx<=x2) AND (dx>=Y1) AND (dx<=Y2);
  END;
 END;

{======================================}

 FUNCTION   MousePressed: Boolean;
 BEGIN
  IF NOT GIStatus THEN BEGIN
   {Ошибка, графический режим небыл инициализирован}
   GIError:=True;
   GIErrorCode:=1;
   GIErrorProc;
   Exit;
  END;
  WITH Reg DO BEGIN
   ax := $3;
   Intr($33,Reg);
   MousePressed:=bx<>0;
  END;
 END;

{============================================================================}
BEGIN
 @GIErrorProc:=@GITempErrorProc;
 GetMF:=True;
 New(MainMouse);
 SetColor(White);
 SetMouseStep(8,8);
 LineStyle.Color:=White;
 LineStyle.Mask:=$FFFF;
 LineStyle.Size:=1;
 LineStyle.MaskLine:=False;
 FillStyle.Color:=White;
 FillStyle.BGColor:=White;
 FillStyle.Texture:=Full;
 FillStyle.TextureFill:=False;
 MainMouse^:=StdMouse;
 GIStatus:=False;
 @GIErrorProc:=@GITempErrorProc;
 GIError:=True;
 GIErrorCode:=1;
 @PutPix:=@PixelErrorProc;
 @GetPix:=@PixelErrorProc;
END.
{============================================================================}