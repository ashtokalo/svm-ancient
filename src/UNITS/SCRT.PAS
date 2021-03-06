unit SCrt;

interface

 function  KeyPressed: Boolean;
 function  ReadKey: Char;
 procedure PutKey(c: Char);
 procedure ClrScr;
 procedure Delay(t: LongInt);
 {  �  ����⢥  ��ࠬ���  ���  �㭪樨  Delay ��।�����  ������⢮
  55-�  ����ᨪ㭤��� ���ࢠ���,  � �祭�� ������ ���� ���⠨����.
  ��  ᨫ쭮 �⫨砥���  �� ��ࠬ���  Delay �� ����� Crt, � ������:
  1 ��� ���� �㭪樨 Delay ᮮ⢥����� 55-� ��� Delay �� ����� Crt.
  1 ᥪ㭤� �ਡ����⥫쭮 ࠢ�� 18-� 55-� ����ᨪ㭤�� ���ࢠ���.}

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