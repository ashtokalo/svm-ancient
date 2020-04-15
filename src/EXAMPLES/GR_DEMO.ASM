STACK   1024
coor1x  DD 0                 ; var  coor1x, coor1y: LongInt;
coor1y  DD 0                 ;      coor2x, coor2y: LongInt;
coor2x  DD 640
coor2y  DD 0
PIConst DQ 0
x       DD 40
y       DD 0
lx      DD 40
ly      DD 240
osi     DD 10, 30, 110, 40, 90, 50, 110, 40, 90, 40, 400, 40, 240, 600, 240, 580, 230, 600, 240, 580, 250
text1   DB 'Демонстрация SVM',0    ; const text1 = 'The demonstration of';
text2   DB 'Нажмите Esc для выхода или Space для продолжения',0 ;text2 = 'SVM graphics interface.';
test1   DB 'Тест #1. Случайные точки.',0
test2   DB 'Тест #2. Случайные закрашеные прямоугольники.',0
test3   DB 'Тест #3. Случайные закрашеные эллипсы.',0
test4   DB 'Тест #4. Случайные прямые.',0
test5   DB 'Тест #5. Случайные прямоугольники.',0
test6   DB 'Тест #6. Случайные эллипсы.',0
test7   DB 'Тест #7. График синуса.',0
test8   DB 'Тест #8. Шрифты.',0
test9   DB 'Тест #9. Моя фотогpафия.',0
normaltext           DB 'Нормальный текст.',0
italictext           DB 'Наклонный текст.',0
boldtext             DB 'Жирный текст.',0
underlinetext        DB 'Подчеркнутый текст.',0
strikelinetext       DB 'Зачеркнутый текст.',0
bolditalictext       DB 'Жырный-наклонный текст.',0
boldunderlinetext    DB 'Жырный-подчеркнутый текст.',0
italicstrikelinetext DB 'Наклонный-зачеркнутый текст.',0
size10  DB 'Размер - 10 пунктов.',0
size20  DB 'Размер - 20 пунктов.',0
size30  DB 'Размер - 30 пунктов.',0
size40  DB 'Размер - 40 пунктов.',0
osix    DB 'X ',0
osiy    DB 'Y ',0
win1    DD 20, 80
win2    DD 619, 429
redc    DB 0
greenc  DB 0
bluec   DB 0, 0
shagfotoname DB 'C:\shag.fto',0
filest  DD 0
INCLUDE graph.inc            ; uses graph, keyboard, math;
INCLUDE keyboard.inc
INCLUDE math.inc
INCLUDE files.inc

start:                        ; begin
  call CreatKbdStream
  call SelectGD              ;  InitGI;

  mov eep, 0                 ;  eep:=0;
 @repeat:                    ;  repeat
  mov ebx, 480               ;   lbx:=Trunc(255/480*(480-eep));
  sub ebx, eep
  mul ebx, 255
  div ebx, 480               ;   bl:=Byte(lbx);
  mov al, 0                  ;   edx:=al + ah*256 + bl*256;
  mov ah, 0
  call RGBToInt
  call SetColor              ;   SetColor(edx);
  mov dword [coor1y], eep    ;   coor1y:=eep;
  mov dword [coor2y], eep    ;   coor2y:=eep;
  mov qword lbx, [coor1x]    ;   Line(coor1x, coor1y, coor2x, coor2y);
  mov qword lcx, [coor2x]
  call DrawLine
  inc eep                    ;   eep:=eep+1;
  call KeyPressed            ;   if KeyPressed then Halt(0);
  jnz @no_pressed 
  call ReadKey
  cmp bl, 27
  jne @no_pressed
  jmp finish
  @no_pressed:
  cmp eep,  480              ;  until eep >= 480;
  jl @repeat

  mov dword edx, [Black]     ; SetColor(Black);
  call SetColor

  mov edx, 0                 ; SetFontStyle(48,BoldItalic,0);
  mov ebx, 48
  mov byte cl, [BoldItalic]
  call SetFontStyle

  mov lep, text1             ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 110
  mov ecx, 15
  call DrawString

  mov dword edx, [White]     ; SetColor(White);
  call SetColor

  mov lep, text1             ; DrawString(100,5,text1,0);
  mov edx, 0
  mov ebx, 100
  mov ecx, 5
  call DrawString

  mov edx, 0                 ; SetFontStyle(20,Normal,0);
  mov ebx, 20
  mov cl, 0
  call SetFontStyle

  mov lep, text2             ; DrawString(90,450,text2,0);
  mov ebx, 70
  mov ecx, 450
  call DrawString

  mov dword edx, [Black]     ; SetColor(Black);
  call SetColor

  mov qword lbx, [win1]      ; FillRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call FillRect

  mov dword edx, [White]     ; SetColor(White);
  call SetColor

  mov qword lbx, [win1]      ; DrawRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call DrawRect

  mov lep, test1             ; DrawString(140,240,test1,0);
  mov edx, 0
  mov ebx, 140
  mov ecx, 240
  call DrawString

  first_test:               ; first_test:

   mov lbx, 256              ;  Red:=Random(256);
   call RandomInt
   mov byte [redc], bl

   mov lbx, 256              ;  Green:=Random(256);
   call RandomInt
   mov byte [greenc], bl

   mov lbx, 256              ;  Blue:=Random(256);
   call RandomInt
   mov byte [bluec], bl

   mov lbx, 598              ;  coor1x:=Random(600)+21;
   call RandomInt
   add ebx, 21
   mov dword [coor1x], ebx

   mov lbx, 348              ;  coor1y:=Random(350)+81;
   call RandomInt
   add ebx, 81
   mov dword [coor1y], ebx

   mov byte [PixelMode], 1   ;  PutPixel(coor1x, coor1y, Red+Green*256+Blue*65536);
   mov dword ebx, [coor1x]
   mov dword ecx, [coor1y]
   mov dword ldx, [redc]
   call PutPixel

   call KeyPressed           ;  if not KeyPressed then goto first_test
   jnz  first_test           ;
   call ReadKey              ;  else bl:=ReadKey;
   cmp  bl, 27               ;  if bl = 27 {Esc-Key} then Halt(0)
   je   finish
   cmp  bl, 32               ;  if bl = 32 {Space_Key} then goto @next
   je   @next                ;
   jmp  first_test           ; else goto first_test;

 @next:

  mov dword edx, [Black]     ; SetColor(Black);
  call SetColor

  mov qword lbx, [win1]      ; FillRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call FillRect

  mov dword edx, [White]     ; SetColor(White);
  call SetColor

  mov qword lbx, [win1]      ; DrawRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call DrawRect

  mov lep, test2             ; DrawString(110,240,test2,0);
  mov edx, 0
  mov ebx, 110
  mov ecx, 240
  call DrawString

 second_test:

   mov lbx, 256              ;  Red:=Random(256);
   call RandomInt
   mov byte [redc], bl

   mov lbx, 256              ;  Green:=Random(256);
   call RandomInt
   mov byte [greenc], bl

   mov lbx, 256              ;  Blue:=Random(256);
   call RandomInt
   mov byte [bluec], bl

   mov lbx, 598              ;  coor1x:=Random(600)+21;
   call RandomInt
   add ebx, 21
   mov dword [coor1x], ebx

   mov lbx, 348              ;  coor1y:=Random(350)+81;
   call RandomInt
   add ebx, 81
   mov dword [coor1y], ebx

   mov lbx, 619              ;  lbx:=619-coor1x;
   sub dword lbx, [coor1x]
   call RandomInt            ;  lbx:=Random(lbx);
   add dword lbx, [coor1x]
   mov dword [coor2x], ebx   ;  coor2x:=ebx+coor1x;

   mov lbx, 429              ;  lbx:=429-coor1x;
   sub dword lbx, [coor1y]
   call RandomInt            ;  lbx:=Random(lbx);
   add dword lbx, [coor1y]
   mov dword [coor2y], ebx   ;  coor2x:=ebx;

   mov dword edx, [redc]     ;  SetColor(red+green*256+blue*65536);
   call SetColor

   mov qword lbx, [coor1x]   ;  FillRect(coor1.x,coor1.y,coor2.x,coor2.y);
   mov qword lcx, [coor2x]
   call FillRect

   call KeyPressed           ;  if not KeyPressed then goto second_test
   jnz  second_test          ;
   call ReadKey              ;  else bl:=ReadKey;
   cmp  bl, 27               ;  if bl = 27 {Esc-Key} then Halt(0)
   je   finish
   cmp  bl, 32               ;  if bl = 32 {Space_Key} then goto @next
   je   @next                ;
   jmp  second_test          ; else goto second_test;

 @next:

  mov dword edx, [Black]     ; SetColor(Black);
  call SetColor

  mov qword lbx, [win1]      ; FillRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call FillRect

  mov dword edx, [White]     ; SetColor(White);
  call SetColor

  mov qword lbx, [win1]      ; DrawRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call DrawRect

  mov lep, test3             ; DrawString(110,240,test2,0);
  mov edx, 0
  mov ebx, 110
  mov ecx, 240
  call DrawString

 therd_test:

   mov lbx, 256              ;  Red:=Random(256);
   call RandomInt
   mov byte [redc], bl

   mov lbx, 256              ;  Green:=Random(256);
   call RandomInt
   mov byte [greenc], bl

   mov lbx, 256              ;  Blue:=Random(256);
   call RandomInt
   mov byte [bluec], bl

   mov lbx, 598              ;  coor1x:=Random(600)+21;
   call RandomInt
   add ebx, 21
   mov dword [coor1x], ebx

   mov lbx, 348              ;  coor1y:=Random(350)+81;
   call RandomInt
   add ebx, 81
   mov dword [coor1y], ebx

   mov lbx, 619              ;  lbx:=619-coor1x;
   sub dword lbx, [coor1x]
   call RandomInt            ;  lbx:=Random(lbx);
   add dword lbx, [coor1x]
   mov dword [coor2x], ebx   ;  coor2x:=ebx+coor1x;

   mov lbx, 429              ;  lbx:=429-coor1x;
   sub dword lbx, [coor1y]
   call RandomInt            ;  lbx:=Random(lbx);
   add dword lbx, [coor1y]
   mov dword [coor2y], ebx   ;  coor2x:=ebx;

   mov dword edx, [redc]     ;  SetColor(red+green*256+blue*65536);
   call SetColor

   mov qword lbx, [coor1x]   ;  FillRect(coor1.x,coor1.y,coor2.x,coor2.y);
   mov qword lcx, [coor2x]
   call FillOval

   call KeyPressed           ;  if not KeyPressed then goto therd_test
   jnz  therd_test           ;
   call ReadKey              ;  else bl:=ReadKey;
   cmp  bl, 27               ;  if bl = 27 {Esc-Key} then Halt(0)
   je   finish
   cmp  bl, 32               ;  if bl = 32 {Space_Key} then goto @next
   je   @next                ;
   jmp  therd_test           ; else goto therd_test;

 @next:

  mov dword edx, [Black]     ; SetColor(Black);
  call SetColor

  mov qword lbx, [win1]      ; FillRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call FillRect

  mov dword edx, [White]     ; SetColor(White);
  call SetColor

  mov qword lbx, [win1]      ; DrawRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call DrawRect

  mov lep, test4             ; DrawString(110,240,test2,0);
  mov edx, 0
  mov ebx, 110
  mov ecx, 240
  call DrawString

 fore_test:

   mov lbx, 256              ;  Red:=Random(256);
   call RandomInt
   mov byte [redc], bl

   mov lbx, 256              ;  Green:=Random(256);
   call RandomInt
   mov byte [greenc], bl

   mov lbx, 256              ;  Blue:=Random(256);
   call RandomInt
   mov byte [bluec], bl

   mov lbx, 598              ;  coor1x:=Random(600)+21;
   call RandomInt
   add ebx, 21
   mov dword [coor1x], ebx

   mov lbx, 348              ;  coor1y:=Random(350)+81;
   call RandomInt
   add ebx, 81
   mov dword [coor1y], ebx

   mov lbx, 598              ;  coor2x:=Random(600)+21;
   call RandomInt
   add ebx, 21
   mov dword [coor2x], ebx

   mov lbx, 348              ;  coor2y:=Random(350)+81;
   call RandomInt
   add ebx, 81
   mov dword [coor2y], ebx

   mov dword edx, [redc]     ;  SetColor(red+green*256+blue*65536);
   call SetColor

   mov qword lbx, [coor1x]   ;  FillRect(coor1.x,coor1.y,coor2.x,coor2.y);
   mov qword lcx, [coor2x]
   call DrawLine

   call KeyPressed           ;  if not KeyPressed then goto fore_test
   jnz  fore_test            ;
   call ReadKey              ;  else bl:=ReadKey;
   cmp  bl, 27               ;  if bl = 27 {Esc-Key} then Halt(0)
   je   finish
   cmp  bl, 32               ;  if bl = 32 {Space_Key} then goto @next
   je   @next                ;
   jmp  fore_test            ; else goto fore_test;

 @next:

  mov dword edx, [Black]     ; SetColor(Black);
  call SetColor

  mov qword lbx, [win1]      ; FillRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call FillRect

  mov dword edx, [White]     ; SetColor(White);
  call SetColor

  mov qword lbx, [win1]      ; DrawRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call DrawRect

  mov lep, test5             ; DrawString(110,240,test2,0);
  mov edx, 0
  mov ebx, 110
  mov ecx, 240
  call DrawString

 fifht_test:

   mov lbx, 256              ;  Red:=Random(256);
   call RandomInt
   mov byte [redc], bl

   mov lbx, 256              ;  Green:=Random(256);
   call RandomInt
   mov byte [greenc], bl

   mov lbx, 256              ;  Blue:=Random(256);
   call RandomInt
   mov byte [bluec], bl

   mov lbx, 598              ;  coor1x:=Random(600)+21;
   call RandomInt
   add ebx, 21
   mov dword [coor1x], ebx

   mov lbx, 348              ;  coor1y:=Random(350)+81;
   call RandomInt
   add ebx, 81
   mov dword [coor1y], ebx

   mov lbx, 619              ;  lbx:=619-coor1x;
   sub dword lbx, [coor1x]
   call RandomInt            ;  lbx:=Random(lbx);
   add dword lbx, [coor1x]
   mov dword [coor2x], ebx   ;  coor2x:=ebx+coor1x;

   mov lbx, 429              ;  lbx:=429-coor1x;
   sub dword lbx, [coor1y]
   call RandomInt            ;  lbx:=Random(lbx);
   add dword lbx, [coor1y]
   mov dword [coor2y], ebx   ;  coor2x:=ebx;

   mov dword edx, [redc]     ;  SetColor(red+green*256+blue*65536);
   call SetColor

   mov qword lbx, [coor1x]   ;  FillRect(coor1.x,coor1.y,coor2.x,coor2.y);
   mov qword lcx, [coor2x]
   call DrawRect

   call KeyPressed           ;  if not KeyPressed then goto fifht_test
   jnz  fifht_test           ;
   call ReadKey              ;  else bl:=ReadKey;
   cmp  bl, 27               ;  if bl = 27 {Esc-Key} then Halt(0)
   je   finish
   cmp  bl, 32               ;  if bl = 32 {Space_Key} then goto @next
   je   @next                ;
   jmp  fifht_test           ; else goto fifht_test;

 @next:

  mov dword edx, [Black]     ; SetColor(Black);
  call SetColor

  mov qword lbx, [win1]      ; FillRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call FillRect

  mov dword edx, [White]     ; SetColor(White);
  call SetColor

  mov qword lbx, [win1]      ; DrawRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call DrawRect

  mov lep, test6             ; DrawString(110,240,test2,0);
  mov edx, 0
  mov ebx, 110
  mov ecx, 240
  call DrawString

 six_test:

   mov lbx, 256              ;  Red:=Random(256);
   call RandomInt
   mov byte [redc], bl

   mov lbx, 256              ;  Green:=Random(256);
   call RandomInt
   mov byte [greenc], bl

   mov lbx, 256              ;  Blue:=Random(256);
   call RandomInt
   mov byte [bluec], bl

   mov lbx, 598              ;  coor1x:=Random(600)+21;
   call RandomInt
   add ebx, 21
   mov dword [coor1x], ebx

   mov lbx, 348              ;  coor1y:=Random(350)+81;
   call RandomInt
   add ebx, 81
   mov dword [coor1y], ebx

   mov lbx, 619              ;  lbx:=619-coor1x;
   sub dword lbx, [coor1x]
   call RandomInt            ;  lbx:=Random(lbx);
   add dword lbx, [coor1x]
   mov dword [coor2x], ebx   ;  coor2x:=ebx+coor1x;

   mov lbx, 429              ;  lbx:=429-coor1x;
   sub dword lbx, [coor1y]
   call RandomInt            ;  lbx:=Random(lbx);
   add dword lbx, [coor1y]
   mov dword [coor2y], ebx   ;  coor2x:=ebx;

   mov dword edx, [redc]     ;  SetColor(red+green*256+blue*65536);
   call SetColor

   mov qword lbx, [coor1x]   ;  FillRect(coor1.x,coor1.y,coor2.x,coor2.y);
   mov qword lcx, [coor2x]
   call DrawOval

   call KeyPressed           ;  if not KeyPressed then goto six_test
   jnz  six_test             ;
   call ReadKey              ;  else bl:=ReadKey;
   cmp  bl, 27               ;  if bl = 27 {Esc-Key} then Halt(0)
   je   finish
   cmp  bl, 32               ;  if bl = 32 {Space_Key} then goto @next
   je   @next                ;
   jmp  six_test             ; else goto six_test;

 @next:

  mov dword edx, [Black]     ; SetColor(Black);
  call SetColor

  mov qword lbx, [win1]      ; FillRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call FillRect

  mov dword edx, [White]     ; SetColor(White);
  call SetColor

  mov qword lbx, [win1]      ; DrawRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call DrawRect

 saven_test:

  call PI                    ; lbx:=PI;
  xchg lbx,lcx
  mov  lbx, 180              ; lbx:=lbx/180.0;
  call IntToFloat
  xchg lbx, lcx
  call FloatDiv

  mov  qword [PIConst], lbx  ; PIConst:=lbx;

  mov  lep, osi              ; DrawPolygon(osi);
  call DrawPolygon

  mov edx, 0                 ; SetFontStyle(20,Normal,0);
  mov ebx, 20
  mov cl, 0
  call SetFontStyle

  mov lep, test7             ; DrawString(190,110,name,0);
  mov ebx, 190
  mov ecx, 110
  call DrawString

  mov lep, osiy              ; DrawString(55,95,osiy,0);
  mov ebx, 55
  mov ecx, 95
  call DrawString

  mov lep, osix              ; DrawString(580,255,osix,0);
  mov ebx, 580
  mov ecx, 255
  call DrawString

  @repeat:
   inc  word [x]             ;  x:=x+1;
   mov  word lbx, [x]
   sub  lbx, 40              ;  lbx:=x-40

   call IntToFloat           ;  lbx:=Real(lbx*PIConst);
   mov  qword lcx, [PIConst]
   call FloatMul

   call sin                  ;  lbx:=Sin(lbx);
   xchg lbx, lcx

   mov  lbx, 140             ;  lbx:=lbx*140.0;
   call IntToFloat
   xchg lbx, lcx
   call FloatMul

   call Truncate             ;  lbx:=Trunc(lbx);

   mov  word [y], bx         ;  y:=bx;
   mov  lax, 240             ;  y:=240-y;
   sub  word ax, [y]
   mov  word [y], ax

   mov  qword lbx, [lx]      ;  DrawLine(lx,ly,x,y);
   mov  qword lcx, [x]
   call DrawLine

   mov  qword lax, [x]       ;  lx:=x;
   mov  qword [lx], lax      ;  ly:=y;

  call KeyPressed            ; if not KeyPressed then goto x_test
  jnz  @x_test               ;
  call ReadKey               ; else bl:=ReadKey;
  cmp  bl, 27                ; if bl = 27 {Esc-Key} then Halt(0)
  je   finish
  cmp  bl, 32                ; if bl = 32 {Space_Key} then goto @next
  je   @next                 ;
  @x_test:
  cmp  word [x], 581         ; if x < 581 then goto @repeat
  jl   @repeat

  @wait:                     ; repeat
  call KeyPressed
  jnz  @wait                 ; until KeyPressed;

  @next:
  mov dword edx, [Black]     ; SetColor(Black);
  call SetColor

  mov qword lbx, [win1]      ; FillRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call FillRect

  mov dword edx, [White]     ; SetColor(White);
  call SetColor

  mov qword lbx, [win1]      ; DrawRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call DrawRect

  mov lep, test8             ; DrawString(190,110,name,0);
  mov edx, 0
  mov ebx, 190
  mov ecx, 100
  call DrawString

 eight_test:

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 10
  mov byte cl, 0
  call SetFontStyle

  mov lep, size10            ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 30
  mov ecx, 130
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 20
  mov byte cl, 0
  call SetFontStyle

  mov lep, size20            ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 30
  mov ecx, 145
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 30
  mov byte cl, 0
  call SetFontStyle

  mov lep, size30            ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 30
  mov ecx, 165
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 40
  mov byte cl, 0
  call SetFontStyle

  mov lep, size40            ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 30
  mov ecx, 195
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 20
  mov byte cl, 0
  call SetFontStyle

  mov lep, NormalText        ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 30
  mov ecx, 235
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 20
  mov byte cl, [Bold]
  call SetFontStyle

  mov lep, BoldText        ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 300
  mov ecx, 235
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 20
  mov byte cl, [Italic]
  call SetFontStyle

  mov lep, ItalicText        ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 30
  mov ecx, 255
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 20
  mov byte cl, [StrikeLine]
  call SetFontStyle

  mov lep, StrikeLineText    ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 300
  mov ecx, 255
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 20
  mov byte cl, [UnderLine]
  call SetFontStyle

  mov lep, UnderLineText        ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 30
  mov ecx, 275
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 20
  mov byte cl, [BoldItalic]
  call SetFontStyle

  mov lep, BoldItalicText    ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 300
  mov ecx, 275
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 20
  mov byte cl, [BoldUnderLine]
  call SetFontStyle

  mov lep, BoldUnderLineText ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 30
  mov ecx, 295
  call DrawString

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 20
  mov byte cl, [ItalicStrikeLine]
  call SetFontStyle

  mov lep, ItalicStrikeLineText        ; DrawString(110,15,text1,0);
  mov edx, 0
  mov ebx, 30
  mov ecx, 320
  call DrawString

  call ReadKey
  

  mov dword edx, [Black]     ; SetColor(Black);
  call SetColor

  mov qword lbx, [win1]      ; FillRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call FillRect

  mov dword edx, [White]     ; SetColor(White);
  call SetColor

  mov qword lbx, [win1]      ; DrawRect(win1.x,win1.y,win2.x,win2.y);
  mov qword lcx, [win2]
  call DrawRect

  mov edx, 0                 ; SetFontStyle(48,Normal,0);
  mov ebx, 20
  mov byte cl, [Bold]
  call SetFontStyle

  mov lep, test9             ; DrawString(110,240,test2,0);
  mov edx, 0
  mov ebx, 190
  mov ecx, 90
  call DrawString

  mov bx,0
  mov lep, shagfotoname
  call CreatFileStream
  mov dword [filest], edx

  mov dword [coor1x], 215
  mov byte [PixelMode], 1   
 show_foto:
 @repeaty:
  mov dword [coor1y], 120
 @repeatx:
  mov dword edx, [filest]
  call ReadByte
  mov byte [redc], bl
  call ReadByte
  mov byte [greenc], bl  
  call ReadByte
  mov byte [bluec], bl
  call ReadByte
  mov dword ebx, [coor1x]
  mov dword ecx, [coor1y]
  mov dword ldx, [redc]
  call PutPixel
  inc dword [coor1y]
  cmp dword [coor1y], 425
  jl @repeatx
  inc dword [coor1x]
  cmp dword [coor1x], 425
  jl @repeaty

  call readkey
finish:                      ; end.