{============================================================================}
{====                          Mouse interface                           ====}
{====                            Version 1.0                             ====}
{====                  Copyright (c) 2000 ShAG Studio                    ====}
{============================================================================}
                                 unit Mouse;
{============================================================================}
                                  interface
{============================================================================}
 const LeftButton  = 1;
       RightButton = 2;
       TherdButton = 4;

 var   MouseStatus, MouseViewMode: Boolean;
       MouseButton: Byte;
       MouseX, MouseY: Word;


 function  InitMouse: Boolean;
 procedure ShowMouse;
 procedure HideMouse;
 procedure GetMouseMode(var x, y: Word; b: Byte);
 procedure MoveMouse(x, y: Word);
 procedure SetMouseWindow(x, y, x1, y1: Word);
{============================================================================}
                                implementation
{============================================================================}

function  InitMouse: Boolean; assembler;
asm
 mov ax, 0
 int $33
 cmp ax, $FFFF
 je  @ok
 mov al, 0
 mov MouseStatus, 0
 mov MouseButton, 0
 mov MouseViewMode, 0
 jmp @exit
 @ok:
 mov al, 1
 mov MouseStatus, 1
 mov MouseViewMode, 0
 mov MouseButton, bl
 @exit:
end;

procedure ShowMouse; assembler;
asm
 mov al, MouseStatus
 cmp al, 1
 jne @exit
 mov al, MouseViewMode
 cmp al, 1
 je  @exit
 mov ax, 1
 int $33
 mov MouseViewMode, 1
 @exit:
end;

procedure HideMouse; assembler;
asm
 mov al, MouseStatus
 cmp al, 1
 jne @exit
 mov al, MouseViewMode
 cmp al, 0
 je  @exit
 mov ax, 1
 int $33
 mov MouseViewMode, 0
 @exit:
end;

procedure GetMouseMode(var x, y: Word; b: Byte);
var x1, y1, b1: Word;
begin
 asm
  mov x1, 0
  mov y1, 0
  mov b1, 0
{  mov al, MouseStatus
  cmp al, 1
  jne @exit}
  mov ax, 3
  int $33
  mov x1, cx
  mov y1, dx
  mov b1, bx
  @exit:
 end;
 x:=x1;
 y:=y1;
 b:=b1;
 MouseX:=x;
 MouseY:=y;
 MouseButton:=b1;
end;

procedure MoveMouse(x, y: Word); assembler;
asm
 mov al, MouseStatus
 cmp al, 1
 jne @exit
 mov cx, x
 mov dx, y
 mov ax, 4
 int $33
 @exit:
end;

procedure SetMouseWindow(x, y, x1, y1: Word); assembler;
asm
 mov al, MouseStatus
 cmp al, 1
 jne @exit
 mov cx, x
 mov dx, x1
 mov ax, 7
 int $33
 mov cx, y
 mov dx, y1
 mov ax, 8
 int $33
 @exit:
end;

begin
 MouseStatus:=False;
 MouseViewMode:=False;
 MouseButton:=0;
end.