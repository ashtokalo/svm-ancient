stack 1024
piconst dq 0
x       dd 40
y       dd 0
lx      dd 40
ly      dd 240
osi     dd 10, 30, 110, 40, 90, 50, 110, 40, 90, 40, 400, 40, 240, 600, 240, 580, 230, 600, 240, 580, 250
name    db 'График синуса',0
osix    db 'X ',0
osiy    db 'Y ',0
include graph.inc,math.inc, keyboard.inc
start:
 call CreatKbdStream
 call PI
 xchg lbx,lcx
 mov  lbx, 180
 call IntToFloat
 xchg lbx, lcx
 call FloatDiv
 mov  qword [piconst], lbx
 call SelectGD
 mov  dword ldx, [white]
 call SetColor
 mov  lep, osi
 call DrawPolygon
 mov edx, 0                 ; SetFontStyle(20,Normal,0);
 mov ebx, 20
 mov cl, 0
 call SetFontStyle
 mov lep, name              ; DrawString(190,110,name,0);
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
  inc  word [x]
  mov  word lbx, [x]
  sub  lbx, 40
  call IntToFloat
  mov  qword lcx, [piconst]
  call FloatMul
  call sin
  xchg lbx, lcx
  mov  lbx, 140
  call IntToFloat
  xchg lbx, lcx
  call FloatMul
  call Truncate
  mov  word [y], bx
  mov  lax, 240
  sub  word ax, [y]
  mov  word [y], ax
  mov  qword lbx, [lx]
  mov  qword lcx, [x]
  call DrawLine
  mov  qword lax, [x]
  mov  qword [lx], lax
 cmp word [x], 581
 jl @repeat
 @wait:
 call KeyPressed
 jnz  @wait
finish: