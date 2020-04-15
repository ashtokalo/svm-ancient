{$A+,B+,D-,E+,F+,G-,I+,L-,N-,O+,P+,Q-,R-,S+,T+,V+,X+}
{$M 2048,0,0}
 uses Dos;

 CONST Diz_File: ARRAY [0..519] OF Byte = (
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 254,
        255, 255, 255, 239, 255, 255, 255, 254,
        255, 255, 255, 239, 255, 255, 255, 238,
        255, 255, 255, 238, 255, 255, 255, 238,
        255, 255, 255, 238, 255, 251, 255, 238,
        255, 191, 255, 238, 255, 251, 255, 238,
        255, 191, 255, 238, 255, 187, 255, 238,
        255, 187, 255, 238, 255, 187, 255, 238,
        255, 187, 255, 174, 255, 187, 255, 238,
        255, 187, 255, 174, 255, 187, 255, 234,
        255, 187, 255, 170, 255, 187, 255, 234,
        255, 187, 255, 170, 255, 187, 255, 170,
        255, 187, 255, 170, 255, 171, 255, 170,
        255, 186, 255, 170, 255, 171, 255, 170,
        255, 171, 255, 170, 255, 170, 255, 170,
        255, 170, 255, 170, 255, 170, 255, 170,
        127, 170, 255, 170, 255, 170, 255, 170,
        127, 170, 255, 170, 247, 170, 255, 170,
        119, 170, 255, 170, 247, 170, 255, 170,
        119, 170, 255, 170, 119, 170, 255, 170,
        119, 170, 223, 170, 119, 170, 255, 170,
        119, 170, 223, 170, 119, 170, 253, 170,
        119, 170, 221, 170, 119, 170, 253, 170,
        119, 170, 221, 170, 119, 170, 221, 170,
        119, 170,  93, 170, 119, 170, 221, 170,
        119, 170,  93, 170, 119, 170, 213, 170,
        119, 170,  85, 170, 119, 170, 213, 170,
        119, 170,  85, 170, 119, 170,  85, 170,
        119, 170,  85, 170,  87, 170,  85, 170,
        117, 170,  85, 170,  87, 170,  85, 170,
        117, 170,  85, 170,  85, 170,  85, 170,
         85, 170,  85, 170,  85, 170,  85, 170,
         85,  42,  85, 170,  85, 170,  85, 170,
         85,  42,  85, 170,  85, 162,  85, 170,
         85,  34,  85, 170,  85, 162,  85, 170,
         85,  34,  85, 170,  85,  34,  85, 170,
         85,  34,  85, 138,  85,  34,  85, 170,
         85,  34,  85, 138,  85,  34,  85, 168,
         85,  34,  85, 136,  85,  34,  85, 168,
         85,  34,  85, 136,  85,  34,  85, 136,
         85,  34,  85, 136,  85,   2,  85, 136,
         85,  32,  85, 136,  85,   2,  85, 136,
         85,   0,  85, 136,  85,   2,  85, 136,
         85,   0,  85, 136,  85,   0,  85, 136,
         85,   0,  85, 128,  85,   0,  85, 136,
         85,   0,  85, 128,  85,   0,  85,   8,
         85,   0,  85,   0,  85,   0,  85, 128,
         85,   0,  85,   0,  85,   0,  85,   0,
         69,   0,  85,   0,  85,   0,  85,   0,
         69,   0,  85,   0,  84,   0,  85,   0,
         68,   0,  85,   0,  84,   0,  85,   0,
         68,   0,  85,   0,  68,   0,  85,   0,
         68,   0,  81,   0,  68,   0,  85,   0,
         68,   0,  81,   0,  68,   0,  21,   0,
         68,   0,  17,   0,  68,   0,  21,   0,
         68,   0,  17,   0,  68,   0,  17,   0,
         68,   0,  17,   0,   4,   0,  17,   0,
         64,   0,  17,   0,   4,   0,  17,   0,
          0,   0,  17,   0,   4,   0,  17,   0,
          0,   0,  17,   0,   0,   0,  17,   0,
          0,   0,   1,   0,   0,   0,  17,   0,
          0,   0,   1,   0,   0,   0,  16,   0,
          0,   0,   0,   0,   0,   0,   1,   0,
          0,   0,   0,   0,   0,   0,   0,   0);

       Colors_File: ARRAY [0..767] OF Byte = (
          0,   0,   0,   0,   0,  42,   0,  42,   0,   0,  42,  42,  42,   0,
          0,  42,   0,  42,  32,  32,   0,  42,  42,  42,   0,   0,  21,   0,
          0,  63,   0,  42,  21,   0,  42,  63,  42,   0,  21,  42,   0,  63,
         42,  42,  21,  42,  42,  63,   0,  21,   0,   0,  21,  42,   0,  63,
          0,   0,  63,  42,  42,  21,   0,  42,  21,  42,  42,  63,   0,  42,
         63,  42,   0,  21,  21,   0,  21,  63,   0,  63,  21,   0,  63,  63, 
         42,  21,  21,  42,  21,  63,  42,  63,  21,  42,  63,  63,  21,   0, 
          0,  21,   0,  42,  21,  42,   0,  21,  42,  42,  63,   0,   0,  63, 
          0,  42,  63,  42,   0,  63,  42,  42,  21,   0,  21,  21,   0,  63,
         21,  42,  21,  21,  42,  63,  63,   0,  21,  63,   0,  63,  63,  42, 
         21,  63,  42,  63,  21,  21,   0,  21,  21,  42,  21,  63,   0,  21, 
         63,  42,  63,  21,   0,  63,  21,  42,  63,  63,   0,  63,  63,  42, 
         21,  21,  21,  21,  21,  63,  21,  63,  21,  21,  63,  63,  63,  21,
         21,  63,  21,  63,  63,  63,  21,  63,  63,  63,  63,  31,  31,  63, 
         39,  31,  63,  47,  31,  63,  55,  31,  63,  63,  31,  55,  63,  31, 
         47,  63,  31,  39,  63,  31,  31,  63,  31,  31,  63,  39,  31,  63, 
         47,  31,  63,  55,  31,  63,  63,  31,  55,  63,  31,  47,  63,  31,
         39,  63,  45,  45,  63,  49,  45,  63,  54,  45,  63,  58,  45,  63,
         63,  45,  63,  63,  45,  58,  63,  45,  54,  63,  45,  49,  63,  45,
         45,  63,  49,  45,  63,  54,  45,  63,  58,  45,  63,  63,  45,  58,
         63,  45,  54,  63,  45,  49,  63,  45,  45,  63,  45,  45,  63,  49,
         45,  63,  54,  45,  63,  58,  45,  63,  63,  45,  58,  63,  45,  54, 
         63,  45,  49,  63,   0,   0,  28,   7,   0,  28,  14,   0,  28,  21, 
          0,  28,  28,   0,  28,  28,   0,  21,  28,   0,  14,  28,   0,   7, 
         28,   0,   0,  28,   7,   0,  28,  14,   0,  28,  21,   0,  28,  28,
          0,  21,  28,   0,  14,  28,   0,   7,  28,   0,   0,  28,   0,   0, 
         28,   7,   0,  28,  14,   0,  28,  21,   0,  28,  28,   0,  21,  28, 
          0,  14,  28,   0,   7,  28,  14,  14,  28,  17,  14,  28,  21,  14, 
         28,  24,  14,  28,  28,  14,  28,  28,  14,  24,  28,  14,  21,  28,
         14,  17,  28,  14,  14,  28,  17,  14,  28,  21,  14,  28,  24,  14, 
         28,  28,  14,  24,  28,  14,  21,  28,  14,  17,  28,  14,  14,  28, 
         14,  14,  28,  17,  14,  28,  21,  14,  28,  24,  14,  28,  28,  14, 
         24,  28,  14,  21,  28,  14,  17,  28,  20,  20,  28,  22,  20,  28,
         24,  20,  28,  26,  20,  28,  28,  20,  28,  28,  20,  26,  28,  20, 
         24,  28,  20,  22,  28,  20,  20,  28,  22,  20,  28,  24,  20,  28, 
         26,  20,  28,  28,  20,  26,  28,  20,  24,  28,  20,  22,  28,  20, 
         20,  28,  20,  20,  28,  22,  20,  28,  24,  20,  28,  26,  20,  28,
         28,  20,  26,  28,  20,  24,  28,  20,  22,  28,   0,   0,  16,   4, 
          0,  16,   8,   0,  16,  12,   0,  16,  16,   0,  16,  16,   0,  12,
         16,   0,   8,  16,   0,   4,  16,   0,   0,  16,   4,   0,  16,   8,
          0,  16,  12,   0,  16,  16,   0,  12,  16,   0,   8,  16,   0,   4,
         16,   0,   0,  16,   0,   0,  16,   4,   0,  16,   8,   0,  16,  12, 
          0,  16,  16,   0,  12,  16,   0,   8,  16,   0,   4,  16,   8,   8, 
         16,  10,   8,  16,  12,   8,  16,  14,   8,  16,  16,   8,  16,  16, 
          8,  14,  16,   8,  12,  16,   8,  10,  16,   8,   8,  16,  10,   8,
         16,  12,   8,  16,  14,   8,  16,  16,   8,  14,  16,   8,  12,  16, 
          8,  10,  16,   8,   8,  16,   8,   8,  16,  10,   8,  16,  12,   8, 
         16,  14,   8,  16,  16,   8,  14,  16,   8,  12,  16,   8,  10,  16, 
         11,  11,  16,  12,  11,  16,  13,  11,  16,  15,  11,  16,  16,  11,
         16,  16,  11,  15,  16,  11,  13,  16,  11,  12,  16,  11,  11,  16, 
         12,  11,  16,  13,  11,  16,  15,  11,  16,  16,  11,  15,  16,  11, 
         13,  16,  11,  12,  16,  11,  11,  16,  11,  11,  16,  12,  11,  16, 
         13,  11,  16,  15,  11,  16,  16,  11,  15,  16,  11,  13,  16,  11,
         12,  16,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, 
          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0);

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

       InitTable: String = 'UGD'#1'UGDVGA'#1'1'#1'Copyright (c) 2000 ShAG Studio'#0;

 TYPE TDMatrix = ARRAY [0..7,0..7] OF Byte;
 TYPE TDizTable = ARRAY [0..65,0..7] OF Byte;
 type TColor = record
  case byte of
   0: (Red, Green, Blue, Index: Byte);
   1: (color: LongInt);
  end;
 TYPE PColor = ^TColor;

 var DizR, DizG, DizB, grmode: Byte;
     DFonR, DColorR, DFonG, DColorG, DFonB, DColorB, rax, rbx, rcx, rdx, maxx, maxy: Word;
     LastColor, Color: TColor;
     DMatrix, LastDMatrix: TDMatrix;
     DizTable: TDizTable ABSOLUTE Diz_File;
     ColorTable: ARRAY [0..255,0..2] OF Byte ABSOLUTE Colors_File;
     iseg, iofs: Word;

 procedure  MulColorTable;
 var n: Byte;
 begin
  for n:=0 to 255 do begin
   colortable[n,0]:=colortable[n,0] shl 2;
   colortable[n,1]:=colortable[n,1] shl 2;
   colortable[n,2]:=colortable[n,2] shl 2;
  end;
 end;

 procedure  DivColorTable;
 var n: Byte;
 begin
  for n:=0 to 255 do begin
   colortable[n,0]:=colortable[n,0] shr 2;
   colortable[n,1]:=colortable[n,1] shr 2;
   colortable[n,2]:=colortable[n,2] shr 2;
  end;
 end;

 PROCEDURE  SaveColorTable;
 var Reg: Registers;
 BEGIN
  DivColorTable;
  Reg.ax:=Seg(ColorTable);
  Reg.es:=Reg.ax;
  Reg.ah:=$10;
  Reg.al:=$12;
  Reg.dx:=Ofs(ColorTable);
  Reg.bx:=0;
  Reg.cx:=256;
  Intr($10,Reg);
  MulColorTable;
 END;

 PROCEDURE  SetColor_D(Col: TColor);
 VAR t: Byte;
 BEGIN
  IF Col.Color = LastColor.Color THEN DMatrix:=LastDMatrix else begin
   Color:=Col;
   IF Col.Green+Col.Blue > 256 THEN BEGIN
    DizR:=Col.Red shr 2;
    DFonR:=0;
    DColorR:=12;
   END ELSE BEGIN
    DizR:=Col.Red shr 1;
    t:=Col.Red shr 7;
    Dec(DizR,t shl 6);
    DFonR:=t shl 2;
    DColorR:=4+t shl 3;
   END;
   IF Col.Red+Col.Blue > 256 THEN BEGIN
    DizG:=Col.Green shr 2;
    DFonG:=0;
    DColorG:=10;
   END ELSE BEGIN
    t:=Col.Green shr 7;
    DizG:=Col.Green shr 1;
    Dec(DizG,t shl 6);
    DFonG:=t shl 1;
    DColorG:=2+t shl 3;
   END;
   IF Col.Red+Col.Green > 256 THEN BEGIN
    DizB:=Col.Blue shr 2;
    DFonB:=0;
    DColorB:=9;
   END ELSE BEGIN
    t:=Col.Blue shr 7;
    DizB:=Col.Blue shr 1;
    Dec(DizB,t shl 6);
    DFonB:=t;
    DColorB:=1+t shl 3;
   END;
   IF (Col.Red = Col.Green) AND (Col.Red = Col.Blue) THEN BEGIN
    CASE Col.Red OF
     0..63:    BEGIN
                DizR:=Col.Red;
                DFonR:=0;
                DColorR:=8;
               END;
     64..191:  BEGIN
                DizR:=(Col.Red-64) shr 1;
                DFonR:=8;
                DColorR:=7;
               END;
     192..255: BEGIN
                DizR:=Col.Red-191;
                DFonR:=7;
                DColorR:=15;
               END;
    END;
    ASM
     xor ax, ax
     MOV DColorG, ax
     MOV DFonG, ax
     MOV DizG, al
     MOV DColorB, ax
     MOV DFonB, ax
     MOV DizB, al
    END;
   END;
   ASM
    xor ax, ax
    CMP Col.Red, al
    JNE @Gr
    MOV DColorR, ax
    MOV DFonR, ax
    MOV DizR, al
    @Gr:
    CMP Col.Green, al
    JNE @Bl
    MOV DColorG, ax
    MOV DFonG, ax
    MOV DizG, al
    @Bl:
    CMP Col.Blue, al
    JNE @Next
    MOV DColorB, ax
    MOV DFonB, ax
    MOV DizB, al
    @Next:
   END;
   LastColor:=Color;
   LastDMatrix:=DMatrix;
  END;
 END;

 PROCEDURE  PutPixel_0(x, y : Word; col: Byte); assembler;
 ASM
   mov  ax,$A000
   mov  es,ax          {es = $A000}
   mov  ax,y
   mov  bx,320         {ax=y*320}
   mul  bx
   mov  bx,x           {bx=ax+x}
   add  bx,ax
   mov  al,col
   mov  es:[bx],al
 END;

 function  GetPixel_0(x,y : Word): Byte; assembler;
 ASM
   mov  ax,$A000
   mov  es,ax          {es = $A000}
   mov  ax,y
   mov  bx,320         {ax=y*320}
   mul  bx
   mov  bx,x           {bx=ax+x}
   add  bx,ax
   mov  al,es:[bx]
 END;

 PROCEDURE  PutPixel_1(x, y: Word; col: Byte); assembler;
 ASM
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
    PUSH ax
    PUSH cx
    MUL  bx
    MOV  cx, x
    SUB  cx, ax
    MOV  ax, 128
    SHR  ax, cl
    XOR  dh, dh
    MOV  dl, al
    POP  ax
    POP  cx
    PUSH dx
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
    POP  ax              {Разрешены биты символа}
    OUT  dx, al
    {Выводим символ}
    MOV  al, es:[bx]
    MOV  al, col
    MOV  es:[bx], al
 END;

 function  GetPixel_1(x,y: Word): Byte; assembler;
 asm
  mov ah, $0D
  mov bh, 0
  mov cx, x
  mov dx, y
  int $10
 end;

 procedure  PutPixel_D(x,y: Word);
 VAR   x1, y1, t1, t: Word;
 BEGIN
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
  if grmode = 0 then PutPixel_0(x,y,DMatrix[x1,y1])
                else PutPixel_1(x,y,DMatrix[x1,y1]);
 end;

 FUNCTION  GetPixel_D(x, y: Word): PColor;
 var b: Byte;
 BEGIN
  if grmode = 0 then b:=GetPixel_0(x,y)
                else b:=GetPixel_1(x,y);
  GetPixel_D^.Red:=ColorTable[b,0];
  GetPixel_D^.Green:=ColorTable[b,1];
  GetPixel_D^.Blue:=ColorTable[b,2];
 END;

 procedure InitG; assembler;
 asm
  cmp grmode, 0
  jne @n1
  mov al, $13
  mov maxx, 320
  mov maxy, 200
  jmp @set
  @n1:
  cmp grmode, 1
  jne @n2
  mov al, $0E
  mov maxx, 640
  mov maxy, 200
  jmp @set
  @n2:
  cmp grmode, 2
  jne @n3
  mov al, $10
  mov maxx, 640
  mov maxy, 350
  jmp @set
  @n3:
  mov al, $12
  mov maxx, 640
  mov maxy, 480
  @set:
  mov ah, 0
  int $10
  call SaveColorTable
 end;

 procedure UGD_TSR; interrupt;
 begin
  asm
   mov ax, [bp+16]
   mov rax, ax
   mov bx, [bp+14]
   mov rbx, bx
   mov cx, [bp+12]
   mov rcx, cx
   mov dx, [bp+10]
   mov rdx, dx
  end;
  case rax of
   0: begin
       rax:=$FFFF;
       rbx:=iseg;
       rcx:=iofs;
      end;
   1: InitG;
   2: begin
       color.red:=rbx; color.green:=rcx; color.blue:=rdx;
       SetColor_D(color);
      end;
   3: PutPixel_D(rcx,rdx);
   4: begin
       color:=GetPixel_D(rcx,rdx)^;
       rbx:=color.red; rcx:=color.green; rdx:=color.blue;
      end;
   5: begin
       rcx:=maxx;
       rdx:=maxy;
      end;
  end;
  asm
   mov ax, rax
   mov bx, rbx
   mov cx, rcx
   mov dx, rdx
   mov [bp+16],ax
   mov [bp+14],bx
   mov [bp+12],cx
   mov [bp+10],dx
  end;
 end;

 begin
  WriteLn('Universal Graphics Driver for VGA  Copyright (c) 2000 ShAG Studio');
  MulColorTable;
  iseg:=seg(InitTable);
  iofs:=ofs(InitTable);
  if (ParamStr(1) <> '-0') and (ParamStr(1) <> '-1') and
     (ParamStr(1) <> '-2') and (ParamStr(1) <> '-3') and
     (ParamCount > 0) then begin
   WriteLn('usage: UGDVGA [options]');
   WriteLn('Options:');
   WriteLn(' -0   - resolution 320x200');
   WriteLn(' -1   - resolution 640x200');
   WriteLn(' -2   - resolution 640x350');
   WriteLn(' -3   - resolution 640x480 (default resolution)');
   Halt(0);
  end;
  grmode:=3;
  if ParamStr(1) = '-0' then grmode:=0 else
  if ParamStr(1) = '-1' then grmode:=1 else
  if ParamStr(1) = '-2' then grmode:=2;
  Write('Resolution: ');
  case grmode of
   0: WriteLn('320x200xTrueColor');
   1: WriteLn('640x200xTrueColor');
   2: WriteLn('640x350xTrueColor');
   else WriteLn('640x480xTrueColor');
  end;
  SetIntVec($EE,@UGD_TSR);
  maxx:=0; maxy:=0;
  Keep(0);
 end.