unit sdi;
interface

const ForRead = 0;
      ForWrite = 1;
      ForReWrite = 2;
      IOError = 0;
      FromStart = 0;
      FromCurrentPos = 1;
      FromEnd = 2;

function CreatFile(filename: String): Word;
function OpenFile(forwhat:Byte; filename: String): Word;
function DeleteFile(filename: String): Boolean;
function CloseFile(w: Word): Boolean;
function ReadFile(w: Word; var Source; count: Word): Word;
function WriteFile(w: Word; var Source; count: Word): Word;
function SeekFile(w, when: Byte; var Pos: LongInt): Boolean;

implementation

function CreatFile(filename: String): Word; assembler;
asm
 mov  bp, sp
 push ds
 mov  ax, ss
 mov  ds, ax
 mov  dx, bp
 add  dx, 11
 mov  ah, $3c
 mov  cx, 32
 int  $21
 jnc  @no_err
 mov  ax, 0
 @no_err:
 pop  ds
end;

function OpenFile(forwhat:Byte; filename: String): Word; assembler;
asm
 mov  bp, sp
 push ds
 mov  ax, ss
 mov  ds, ax
 mov  dx, bp
 add  dx, 13
 mov  ah, $3d
 mov  al, forwhat
 int  $21
 jnc  @no_err
 mov  ax, 0
 @no_err:
 pop  ds
end;

function DeleteFile(filename: String): Boolean; assembler;
asm
 mov  bp, sp
 push ds
 mov  ax, ss
 mov  ds, ax
 mov  dx, bp
 add  dx, 15
 mov  ah, $41
 int  $21
 jnc  @no_err
 mov  al, 0
 jmp  @exit
 @no_err:
 mov  al, 1
 @exit:
 pop  ds
end;

function CloseFile(w: Word): Boolean; assembler;
asm
 mov bx, w
 mov ah, $3e
 jnc @no_err
 mov al, 0
 jmp @exit
 @no_err:
 mov al, 1
 @exit:
end;

function ReadFile(w: Word; var Source; count: Word): Word; assembler;
asm
 push ds
 push bp
 mov cx, count
 mov bx, w
 mov bp, sp
 mov dx, [ss:bp+14]
 mov ax, [ss:bp+12]
 mov ds, dx
 mov dx, ax
 mov ah, $3f
 int $21
 jnc @no_err
 pop bp
 pop ds
 xor ax, ax
 jmp @exit
 @no_err:
 pop bp
 pop ds
 @exit:
end;

function WriteFile(w: Word; var Source; count: Word): Word; assembler;
asm
 push ds
 push bp
 mov cx, count
 mov bx, w
 mov bp, sp
 mov dx, [ss:bp+14]
 mov ax, [ss:bp+12]
 mov ds, dx
 mov dx, ax
 mov ah, $40
 int $21
 jnc @no_err
 pop bp
 pop ds
 xor ax, ax
 jmp @exit
 @no_err:
 pop bp
 pop ds
 @exit:
end;

function SeekFile(w, when: Byte; var Pos: LongInt): Boolean; assembler;
asm
 push ds
 push bp
 xor bx, bx
 mov bl, w
 mov al, when
 push ax
 push bx
 mov bp, sp
 mov ax, [ss:bp+16]
 mov es, ax
 mov bx, [ss:bp+14]
 mov dx, [es:bx]
 mov cx, [es:bx+2]
 pop bx
 pop ax
 mov ah, $42
 int $21
 jnc @no_err
 xor ax, ax
 jmp @exit
 @no_err:
 xchg dx, ax
 push ax
 mov ax, [ss:bp+16]
 mov es, ax
 mov bx, [ss:bp+14]
 pop ax
 mov [es:bx], dx
 mov [es:bx+2], ax
 mov al, 1
 @exit:
 pop bp
 pop ds
end;

begin
end.