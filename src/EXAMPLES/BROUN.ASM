Stack 1024
INCLUDE Keyboard.inc,Math.inc,Graph.inc
white db 255,255,255,0
px dw 320
py dw 200
Start:
  call SelectGD
;  mov  edx, 16777215
  mov dword edx, [white]
  CALL SetColor
@repeat:
  mov  lbx, 4
  CALL RandomInt
  cmp lbx, 0
  jne @next
  ADD word [px], 1
  jmp @next_l
  @next:
  cmp lbx, 1
  jne @next2
  INC word [py]
  jmp @next_l
  @next2:
  cmp lbx, 2
  jne @next3
  dec word [px]
  jmp @next_l
  @next3:
  SUB word [py], 1
  @next_l:
  mov word ebx, [px] ;Ставим точку по координатам ebx, ecx
  mov word ecx, [py]
  CALL PutPixel
  CALL KeyPressed ;Получаем состояние клавиатуры, если кнопка не нажата, то
  jnz @repeat     ;повторяем все сначала
Finish:
