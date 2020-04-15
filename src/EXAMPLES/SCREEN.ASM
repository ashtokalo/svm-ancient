stack 1024
include graph.inc           ; uses graph, keyboard;
include keyboard.inc
coor1x DD 0                 ; var  coor1x, coor1y: LongInt;
coor1y DD 0                 ;      coor2x, coor2y: LongInt;
coor2x DD 640
coor2y DD 0
text1 DB 'The demonstration of',0    ; const text1 = 'The demonstration of';
text2 DB 'SVM graphics interface.',0 ; 	     text2 = 'SVM graphics interface.';

start:                      ; begin
  call SelectGD             ;  InitGI;
  mov eep, 0                ;  eep:=0;
 @repeat:                   ;  repeat
  mov ebx, 480              ;   lbx:=Trunc(255/480*(480-eep));
  sub ebx, eep
  mul ebx, 255
  div ebx, 480              ;   bl:=Byte(lbx);
  mov al, 0                 ;   edx:=al + ah*256 + bl*256;
  mov ah, 0
  call RGBToInt
  call SetColor             ;   SetColor(edx);
  mov dword [coor1y], eep   ;   coor1y:=eep;
  mov dword [coor2y], eep   ;   coor2y:=eep;
  mov qword lbx, [coor1x]   ;   Line(coor1x, coor1y, coor2x, coor2y);
  mov qword lcx, [coor2x]
  call DrawLine
  inc eep                   ;   eep:=eep+1;
  call KeyPressed           ;   if KeyPressed then Halt(0);
  jz finish
  cmp eep,  480             ;  until eep >= 480;
  jl @repeat

  mov dword edx, [Black]    ; SetColor(Black);
  call SetColor

  mov edx, 0                ; SetFontStyle(48,BoldItalic,0);
  mov ebx, 48
  mov cl, [BoldItalic]
  call SetFontStyle

  mov lep, text1            ; DrawString(20,20,text1,0);
  mov edx, 0
  mov ebx, 20
  mov ecx, 20
  call DrawString

  mov lep, text2            ; DrawString(100,60,text2,0);
  mov ebx, 100
  mov ecx, 60
  call DrawString

  mov dword edx, [White]    ; SetColor(White);
  call SetColor

  mov lep, text1            ; DrawString(10,10,text1,0);
  mov edx, 0
  mov ebx, 10
  mov ecx, 10
  call DrawString

  mov lep, text2            ; DrawString(90,50,text2,0);
  mov ebx, 90
  mov ecx, 50
  call DrawString

  call ReadKey              ; ReadKey;
finish:                     ; end.