 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                            Pascal Mouse Interface
                                 Version 1.0
                       Copyright (c) 2000 Lex Software
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   Этот  модуль содержит  команды необходимые  для работы с устройством типа
  мышь. Команды  позволяю получать информацию о состоянии мыши, её отдельных
  параметров и менять их.

                                                 Штокало Алексей Геннадиевич
                                                 5.03.2000

  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

 unit PMI;

 interface

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                               Новые типы данных
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 type
     {----------------------------------
      Тип          Точка
      ----------------------------------}
     PPoint = ^TPoint;
     TPoint = record
       X, Y       : Integer;
     end;

     {----------------------------------
      Тип          Прямоугольник
      ----------------------------------}
     PRect = ^TRect;
     TRect = record
       A, B       : TPoint;
     end;

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  Константы
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 const

  {----------------------------------
    Кнопки мыши
   ----------------------------------}
     mbNo         = $00;
     mbLeft       = $01;
     mbRight      = $02;
     mbCenter     = $04;

  {----------------------------------
    Чувствительность мыши
   ----------------------------------}
     msNormal     = $08;
     msQuick      = $04;
     msSlow       = $10;


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                Переменные
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 var
      CursorStatus : Boolean;
      MHor, MVer,
      MaxButtons,
      MButton      : Integer;
      MPos         : TPoint;
      MouseWindow  : TRect;

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  Функции
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
  function  GetMouseX: Integer;
  function  GetMouseY: Integer;
  function  InitPMI: Boolean;
  function  MouseClick(but: Word): Boolean;
  function  MouseIn(R: TRect): Boolean;

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  Процедуры
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
  procedure GetMouseStatus;
  procedure HideCursor;
  procedure MoveMouse(x, y: Integer);
  procedure SetMouseStep(Hor, Ver: Integer);
  procedure SetMouseWindow(R: TRect);
  procedure ShowCursor;

 implementation

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  Функции
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    Возвращает горизонтальную
    координату мыши
   ----------------------------------}
  function  GetMouseX: Integer; assembler;
  asm
    mov  ax, 3
    int  $33
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    mov  MButton, bx
    mov  ax, cx
  end;

  {----------------------------------
    Возвращает вертикальную
    координату мыши
   ----------------------------------}
  function  GetMouseY: Integer; assembler;
  asm
    mov  ax, 3
    int  $33
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    mov  MButton, bx
    mov  ax, dx
  end;

  {----------------------------------
    Возвращает True если драйвер и
    мышь присутствуют в рабочем
    состоянии
   ----------------------------------}
  function  InitPMI: Boolean; assembler;
  asm
    xor  ax, ax
    int  $33
    mov  CursorStatus, 0
    cmp  ax, 0
    je   @no_driver
    mov  MaxButtons, bx
    inc  al
    jmp  @driver
  @no_driver:
    mov  MaxButtons, 0
  @driver:
  end;

  {----------------------------------
    Возвращает True если нажаты
    соответствующие кнопки
   ----------------------------------}
  function  MouseClick(but: Word): Boolean; assembler;
  asm
    mov  ax, 3
    int  $33
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    mov  MButton, bx
    xor  al, al
    cmp  bx, but
    jl   @no
    inc  al
  @no:
  end;

  {----------------------------------
    Возвращает True если мышь
    находится в прямоугольнике R
   ----------------------------------}
  function  MouseIn(R: TRect): Boolean; assembler;
  asm
    mov  ax, 3
    int  $33
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    mov  MButton, bx
    xor  al, al
    cmp  cx, word ptr R[0]
    jl   @no
    cmp  cx, word ptr R[2]
    jg   @no
    cmp  dx, word ptr R[1]
    jl   @no
    cmp  dx, word ptr R[3]
    jg   @no
    inc  al
  @no:
  end;


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  Процедуры
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    Возвращает в глобальные
    переменные координаты и состояние
    кнопок мыши
   ----------------------------------}
  procedure GetMouseStatus; assembler;
  asm
    mov  ax, 3
    int  $33
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    mov  MButton, bx
  end;

  {----------------------------------
    Делает курсор мыши невидимым
   ----------------------------------}
  procedure HideCursor; assembler;
  asm
    mov  CursorStatus, 0
    mov  ax, 2
    int  $33
  end;

  {----------------------------------
    Перемещает курсор мыши в заданную
    точку
   ----------------------------------}
  procedure MoveMouse(x, y: Integer); assembler;
  asm
    mov  ax, 4
    mov  cx, x
    mov  dx, y
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    int  $33
  end;

  {----------------------------------
    Устанавливает чувствительность
    мыши
   ----------------------------------}
  procedure SetMouseStep(Hor, Ver: Integer); assembler;
  asm
    mov  ax, $0F
    mov  cx, Hor
    mov  dx, Ver
    mov  MHor, cx
    mov  MVer, dx
    int  $33
  end;

  {----------------------------------
    Задает доступную для работы
    область экрана
   ----------------------------------}
  procedure SetMouseWindow(R: TRect);
  begin
    if (R.A.X > R.B.X) or (R.A.Y > R.B.Y) then
      Exit;
    MouseWindow:=R;
    asm
      mov  ax, 7
      mov  cx, word ptr R[0]
      mov  dx, word ptr R[2]
      int  $33
      mov  ax, 8
      mov  cx, word ptr R[1]
      mov  dx, word ptr R[3]
      int  $33
    end;
  end;

  {----------------------------------
    Делает курсор мыши видимым
   ----------------------------------}
  procedure  ShowCursor; assembler;
  asm
   mov  CursorStatus, 1
   mov  ax, 1
   int  $33
  end;


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                         Начальная инициализация данных
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
begin
  MPos.X:=0;
  MPos.Y:=0;
  MouseWindow.A.X:=0;  MouseWindow.A.Y:=0;
  MouseWindow.B.X:=0;  MouseWindow.B.Y:=0;
  MButton:=mbNo;
  MHor:=msNormal;
  MVer:=msNormal;
end.