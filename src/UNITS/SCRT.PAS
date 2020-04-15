unit SCrt;

interface

 function  KeyPressed: Boolean;
 function  ReadKey: Char;
 procedure PutKey(c: Char);
 procedure ClrScr;
 procedure Delay(t: LongInt);
 {  В  качестве  параметра  для  функции  Delay передается  количество
  55-и  милисикундных интервалов,  в течении которых надо простаивать.
  Это  сильно отличается  от параметра  Delay из модуля Crt, а именно:
  1 для моей функции Delay соответствует 55-и для Delay из модуля Crt.
  1 секунда приблизительно равна 18-и 55-и милисикундным интервалам.}

implementation

 function KeyPressed: Boolean; assembler;
 asm
   mov ah, 1
   int $16
   jnz @pressed
   xor al, al
   jmp @ex
  @pressed:
   mov al, 1
  @ex:
 end;

 procedure PutKey(c: Char); assembler;
 asm
  mov ah, 5
  mov cl, c
  xor ch, ch
  int $16
 end;

 function ReadKey: Char; assembler;
 asm
  xor ah,ah
  int 16h
 end;

 procedure Delay(t: LongInt);
 begin
  Inc(t,MemL[0:$046c]);
  while MemL[0:$046c] < t do;
 end;

 procedure ClrScr; assembler;
 asm
  mov ah, 0
  mov al, 3
  int $10
 end;

end.