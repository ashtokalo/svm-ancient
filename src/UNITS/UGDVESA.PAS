{$A-,B-,D-,E+,F+,G+,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X-}
{$M 1568,0,0}
{============================================================================}
{====--------------------------------------------------------------------====}
{====                      Universal Graphics Driver                     ====}
{====                        VESA 2.0  Version 1.0                       ====}
{====                   Copyright (c)  2000 ShAG Studio                  ====}
{====--------------------------------------------------------------------====}
{==== For access to function of this driver you mast call interrupt with ====}
{==== number $EE and in register AL put code of operation need.          ====}
{====--------------------------------------------------------------------====}
{==== This table contant code of operation and note to him:              ====}
{====  Code    Note                                                      ====}
{====   0      This operation need to detect this driver. If driver      ====}
{====          was installed this operation return $FFFF in register AX  ====}
{====          and pointer to information table BX:CX - BX - segment,    ====}
{====          CX - offset. For test this pointer you mast compare it    ====}
{====          with pointer of interrupt with number $EF. If driver was  ====}
{====          installed BX = WORD PTR [$EF*4] & CX = WORD PTR [$EF*4+2] ====}
{====   1      This operation activate graphics mode.                    ====}
{====   2      This operation set the color that be used when you put    ====}
{====          pixel on screen. In registers you mast put next value:    ====}
{====            AH - red    [0..255]                                    ====}
{====            BL - green  [0..255] This value defined color as RGB    ====}
{====            BH - blue   [0..255]                                    ====}
{====   3      This operation put pixel on screen with color that you    ====}
{====          defined with operation 2. In registers you mast put next  ====}
{====          value:                                                    ====}
{====            CX - horizontal coordinate - X                          ====}
{====            DX - vertical coordinate - Y                            ====}
{====   4      This operation return the RGB color to one pixel from     ====}
{====          screen. In registers you mast put next value:             ====}
{====            CX - horizontal coordinate - X                          ====}
{====            DX - vertical coordinate - Y                            ====}
{====          This functin return RGB color in next registers:          ====}
{====            AH - red    [0..255]                                    ====}
{====            BL - green  [0..255] This value defined color as RGB    ====}
{====            BH - blue   [0..255]                                    ====}
{====   5      This operation return maximums for to coordinates:        ====}
{====            CX - horizontal maximum coordinate                      ====}
{====            DX - vertical maximum coordinate                        ====}
{====   6      This operation put pixel on screen with color that you    ====}
{====          defined with this operation. In registers you mast put    ====}
{====          next value:                                               ====}
{====            AH - red    [0..255]                                    ====}
{====            BL - green  [0..255] This value defined color as RGB    ====}
{====            BH - blue   [0..255]                                    ====}
{====            CX - horizontal coordinate - X                          ====}
{====            DX - vertical coordinate - Y                            ====}
{====   7      This operation put pixel with color from mini color table ====}
{====          In registers you mast put next value:                     ====}
{====            AH - color number from mini table [0..15]               ====}
{====            CX - horizontal coordinate - X                          ====}
{====            DX - vertical coordinate - Y                            ====}
{====--------------------------------------------------------------------====}
{==== This table content a color name for each colors from mini table:   ====}
{==== Number   Name        Number   Name                                 ====}
{====   0      Black         8      DarkGray                             ====}
{====   1      Blue          9      LightBlue                            ====}
{====   2      Green         10     LightGreen                           ====}
{====   3      Cyan          11     LightCyan                            ====}
{====   4      Red           12     LightRed                             ====}
{====   5      Magenta       13     LightMagenta                         ====}
{====   6      Yellow        14     LightYellow                          ====}
{====   7      Gray          15     White                                ====}
{====--------------------------------------------------------------------====}
{==== The information table note:                                        ====}
{==== Information table content 4 areas. In end of all areas set byte    ====}
{==== with number 1 and last area finished by byte with number 0.        ====}
{==== Next table contanse note for all areas from information table:     ====}
{==== Area  Note                                                         ====}
{====  1    This area always mast content 3 bytes as string 'UGD'. It    ====}
{====       need to detecting this driver in memory.                     ====}
{====  2    This area contant the name of this driver in string view.    ====}
{====  3    This area contant the version number of this driver in       ====}
{====       string view. This string mast content number an integer      ====}
{====       type only (without floating point)                           ====}
{====  4    This area contant the author information or it copyright.    ====}
{====--------------------------------------------------------------------====}
{==== Information that contants in information table mast writing on     ====}
{==== screen when started program that used UGD driver.                  ====}
{====--------------------------------------------------------------------====}
{==== Sorry for my poor english, but I hope that biggest part of         ====}
{==== rusian, ukranian and other programer understud me. If you don't    ====}
{==== understud something from this text see this example driver or      ====}
{==== contact with me. My coordinates:                                   ====}
{====  E-mail: shag@qnx.com                                              ====}
{====  Home page: http://www.shag.itgo.com                               ====}
{====                                       Shtokalo Alexey Gennadievich ====}
{====--------------------------------------------------------------------====}
{============================================================================}
 uses Dos;

{============================================================================}
{====                             Constants                              ====}
{============================================================================}
 CONST {This array need to generate bit mask for emulate True Color mode}
       Diz_File: ARRAY [0..519] OF Byte = (
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

       {This array content special color table in R, G, B view}
       Colors_File: ARRAY [0..767] OF Byte = (
          0,   0,   0,     0,   0,  31,     0,  31,   0,     0,  31,  31,
         31,   0,   0,    31,   0,  31,    59,  59,   0,    47,  47,  47,
         31,  31,  31,     0,   0,  63,     0,  63,   0,     0,  63,  63,
         63,   0,   0,    63,   0,  63,    63,  63,   0,    63,  63,  63,
          0,  21,   0,     0,  21,  42,     0,  63,   0,     0,  63,  42,
         42,  21,   0,    42,  21,  42,    42,  63,   0,    42,  63,  42,
          0,  21,  21,     0,  21,  63,     0,  63,  21,     0,  63,  63,
         42,  21,  21,    42,  21,  63,    42,  63,  21,    42,  63,  63,
         21,   0,   0,    21,   0,  42,    21,  42,   0,    21,  42,  42,
         63,   0,   0,    63,   0,  42,    63,  42,   0,    63,  42,  42,
         21,   0,  21,    21,   0,  63,    21,  42,  21,    21,  42,  63,
         63,   0,  21,    63,   0,  63,    63,  42,  21,    63,  42,  63,
         21,  21,   0,    21,  21,  42,    21,  63,   0,    21,  63,  42,
         63,  21,   0,    63,  21,  42,    63,  63,   0,    63,  63,  42,
         21,  21,  21,    21,  21,  63,    21,  63,  21,    21,  63,  63,
         63,  21,  21,    63,  21,  63,    63,  63,  21,    63,  63,  63,
         63,  31,  31,    63,  39,  31,    63,  47,  31,    63,  55,  31,
         63,  63,  31,    55,  63,  31,    47,  63,  31,    39,  63,  31,
         31,  63,  31,    31,  63,  39,    31,  63,  47,    31,  63,  55,
         31,  63,  63,    31,  55,  63,    31,  47,  63,    31,  39,  63,
         45,  45,  63,    49,  45,  63,    54,  45,  63,    58,  45,  63,
         63,  45,  63,    63,  45,  58,    63,  45,  54,    63,  45,  49,
         63,  45,  45,    63,  49,  45,    63,  54,  45,    63,  58,  45,
         63,  63,  45,    58,  63,  45,    54,  63,  45,    49,  63,  45,
         45,  63,  45,    45,  63,  49,    45,  63,  54,    45,  63,  58,
         45,  63,  63,    45,  58,  63,    45,  54,  63,    45,  49,  63,
          0,   0,  28,     7,   0,  28,    14,   0,  28,    21,   0,  28,
         28,   0,  28,    28,   0,  21,    28,   0,  14,    28,   0,   7,
         28,   0,   0,    28,   7,   0,    28,  14,   0,    28,  21,   0,
         28,  28,   0,    21,  28,   0,    14,  28,   0,     7,  28,   0,
          0,  28,   0,     0,  28,   7,     0,  28,  14,     0,  28,  21,
          0,  28,  28,     0,  21,  28,     0,  14,  28,     0,   7,  28,
         14,  14,  28,    17,  14,  28,    21,  14,  28,    24,  14,  28,
         28,  14,  28,    28,  14,  24,    28,  14,  21,    28,  14,  17,
         28,  14,  14,    28,  17,  14,    28,  21,  14,    28,  24,  14,
         28,  28,  14,    24,  28,  14,    21,  28,  14,    17,  28,  14,
         14,  28,  14,    14,  28,  17,    14,  28,  21,    14,  28,  24,
         14,  28,  28,    14,  24,  28,    14,  21,  28,    14,  17,  28,
         20,  20,  28,    22,  20,  28,    24,  20,  28,    26,  20,  28,
         28,  20,  28,    28,  20,  26,    28,  20,  24,    28,  20,  22,
         28,  20,  20,    28,  22,  20,    28,  24,  20,    28,  26,  20,
         28,  28,  20,    26,  28,  20,    24,  28,  20,    22,  28,  20,
         20,  28,  20,    20,  28,  22,    20,  28,  24,    20,  28,  26,
         20,  28,  28,    20,  26,  28,    20,  24,  28,    20,  22,  28,
          0,   0,  16,     4,   0,  16,     8,   0,  16,    12,   0,  16,
         16,   0,  16,    16,   0,  12,    16,   0,   8,    16,   0,   4,
         16,   0,   0,    16,   4,   0,    16,   8,   0,    16,  12,   0,
         16,  16,   0,    12,  16,   0,     8,  16,   0,     4,  16,   0,
          0,  16,   0,     0,  16,   4,     0,  16,   8,     0,  16,  12,
          0,  16,  16,     0,  12,  16,     0,   8,  16,     0,   4,  16,
          8,   8,  16,    10,   8,  16,    12,   8,  16,    14,   8,  16,
         16,   8,  16,    16,   8,  14,    16,   8,  12,    16,   8,  10,
         16,   8,   8,    16,  10,   8,    16,  12,   8,    16,  14,   8,
         16,  16,   8,    14,  16,   8,    12,  16,   8,    10,  16,   8,
          8,  16,   8,     8,  16,  10,     8,  16,  12,     8,  16,  14,
          8,  16,  16,     8,  14,  16,     8,  12,  16,     8,  10,  16,
         11,  11,  16,    12,  11,  16,    13,  11,  16,    15,  11,  16,
         16,  11,  16,    16,  11,  15,    16,  11,  13,    16,  11,  12,
         16,  11,  11,    16,  12,  11,    16,  13,  11,    16,  15,  11,
         16,  16,  11,    15,  16,  11,    13,  16,  11,    12,  16,  11,
         11,  16,  11,    11,  16,  12,    11,  16,  13,    11,  16,  15,
         11,  16,  16,    11,  15,  16,    11,  13,  16,    11,  12,  16,
          0,   0,   0,     0,   0,   0,     0,   0,   0,     0,   0,   0,
          0,   0,   0,     0,   0,   0,     0,   0,   0,     0,   0,   0);

       {This array need for diffuze some colors when emulate True Color mode}
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

       {This constant content all information about this driver in next view:
        1 param - the 'UGD'
        2 param - the driver name (UGDVGA or another)
        3 param - the version number (the one number by integer type)
                  in string view
        4 param - the copyright for this driver}
       InitTable: String = 'UGD'#1'UGDVESA20'#1'1'#1'Copyright (c) 2000 ShAG Studio'#0;

{============================================================================}
{====                              User types                            ====}
{============================================================================}

 {This user type need for this driver only}
 TYPE TDMatrix = ARRAY [0..7,0..7] OF Byte;

 {This user type need for this driver only}
 TYPE TDizTable = ARRAY [0..65,0..7] OF Byte;

 {This user type is defined standart type for color}
 type TColor = record
  case byte of
   0: (Red, Green, Blue, Index: Byte);
   1: (color: LongInt);
  end;

 TYPE PColor = ^TColor;

{============================================================================}
{====                              Variables                             ====}
{============================================================================}

 {This variables need for this driver only}
 var DizR, DizG, DizB, grmode, t, Last: Byte;
     DFonR, DColorR, DFonG, DColorG, DFonB, DColorB, rax, rbx, rcx, rdx,
     maxx, maxy, iseg, iofs, x1, y1, t1, tk, DriverVersion, LastPage: Word;
     DriverName, DriverCopyright: String;
     Color, Col: TColor;
     DMatrix: TDMatrix;
     DizTable: TDizTable ABSOLUTE Diz_File;
     ColorTable: ARRAY [0..255,0..2] OF Byte ABSOLUTE Colors_File;
     BF: ARRAY [0..255] OF Byte; {Буфер для VESA 2.0}

{============================================================================}
{====            Procedures and functions for this driver                ====}
{============================================================================}

 procedure  PutNPixel(x, y: Word; col: Byte);
 var o: LongInt;
     VPage: Word;
 begin
  o:=LongInt(y)*LongInt(MaxX)+LongInt(x);
  VPage:=o div 65536;
  VPage:=VPage*Last;
  if LastPage <> VPage then begin
   asm
    MOV AH, $4F
    MOV AL, $05
    MOV BX, 0
    MOV DX, VPage
    INT $10
   end;
   LastPage:=Vpage;
  end;
  Mem[$A000:o mod 65536]:=col;
 end;

 function  GetNPixel(x,y: Word): Byte;
 var o: LongInt;
     VPage: Word;
 begin
  o:=LongInt(y)*LongInt(MaxX)+LongInt(x);
  VPage:=o div 65536;
  VPage:=VPage*Last;
  if LastPage <> VPage then begin
   asm
    MOV AH, $4F
    MOV AL, $05
    MOV BX, 0
    MOV DX, VPage
    INT $10
   end;
   LastPage:=Vpage;
  end;
  GetNPixel:=Mem[$A000:o mod 65536];
 end;

 {This procedure mul all bytes in ColorTable on 4}
 procedure  MulColorTable;
 var n: Byte;
 begin
  for n:=0 to 255 do begin
   colortable[n,0]:=colortable[n,0] shl 2;
   colortable[n,1]:=colortable[n,1] shl 2;
   colortable[n,2]:=colortable[n,2] shl 2;
  end;
 end;

 {This procedure mul div bytes in ColorTable on 4}
 procedure  DivColorTable;
 var n: Byte;
 begin
  for n:=0 to 255 do begin
   colortable[n,0]:=colortable[n,0] shr 2;
   colortable[n,1]:=colortable[n,1] shr 2;
   colortable[n,2]:=colortable[n,2] shr 2;
  end;
 end;

 {This procedure setup special color table for VGA}
 PROCEDURE  SaveColorTable; assembler;
 asm
  call DivColorTable
  mov  ax, seg(ColorTable)
  mov  es, ax
  mov  ah, $10
  mov  al, $12
  lea  dx, ColorTable
  mov  bx, 0
  mov  cx, 256
  int  $10
  call MulColorTable;
 end;

{============================================================================}
{====            Procedures and functions for all UGD drivers            ====}
{============================================================================}

 {This procedure setup color for all operation with graphics}
 PROCEDURE  SetColor;
 BEGIN
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
    XOR ax, ax
    MOV DColorG, ax
    MOV DFonG, ax
    MOV DizG, al
    MOV DColorB, ax
    MOV DFonB, ax
    MOV DizB, al
   END;
  END;
  ASM
   XOR ax, ax
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
 END;

 {This procedure draw one point to x,y coordinates with True Color changes}
 procedure  PutPixel(x,y: Integer);
 BEGIN
  x1:=x MOD 8;
  y1:=y MOD 8;
  tk:=1 SHL x1;
  DMatrix[x1,y1]:=0;
  t1:=(x1 MOD 2) XOR (y1 MOD 2);
  IF DizTable[DizR,y1] AND tk <> tk THEN DMatrix[x1,y1]:=DColorR
                                    ELSE DMatrix[x1,y1]:=DFonR;
  IF DizTable[DizG,y1] AND tk <> tk THEN DMatrix[x1,y1]:=Diffuze[t1,DMatrix[x1,y1],DColorG]
                                    ELSE DMatrix[x1,y1]:=Diffuze[t1,DFonG,DMatrix[x1,y1]];
  IF DizTable[DizB,y1] AND tk <> tk THEN DMatrix[x1,y1]:=Diffuze[t1,DColorB,DMatrix[x1,y1]]
                                    ELSE DMatrix[x1,y1]:=Diffuze[t1,DFonB,DMatrix[x1,y1]];
  PutNPixel(x,y,DMatrix[x1,y1]);
 end;

 {This function geting information about one point in True Color view}
 PROCEDURE GetPixel(x, y: Word);
 BEGIN
  t:=GetNPixel(x,y);
  Color.Red:=ColorTable[t,0];
  Color.Green:=ColorTable[t,1];
  COlor.Blue:=ColorTable[t,2];
 END;

 {This procedure activate graphics mode}
 procedure InitGraph;
 var r1, r2, r3: Word;
 begin
  CASE GrMode OF
   1: r1:=$101;
   2: r1:=$103;
   3: r1:=$105;
   4: r1:=$107;
  END;
  LastPage:=0;
  r2:=Seg(BF);
  r3:=Ofs(BF[0]);
  ASM
   MOV AX, $4F02
   MOV BX, r1
   INT $10
   MOV AX, $4F01
   MOV CX, r1
   MOV ES, r2
   MOV DI, r3
   INT $10
  END;
  IF MemW[r2:r3+4]=0 THEN MemW[r2:r3+4]:=1;
  Last:=MemW[r2:r3+6] div MemW[r2:r3+4];
  MaxX:=MemW[r2:r3+$12];
  MaxY:=MemW[r2:r3+$14];
  IF (MaxX = 0) OR (MaxY = 0) THEN BEGIN
   WriteLn('UGD error: this mode not support or your video card not support VESA 2.0');
   Halt(0);
  END;
  SaveColorTable;
 end;

 {The main interrupt procedure.}
 procedure UGD_TSR; interrupt; assembler;
 asm
   MOV  ax, [bp+16]
   MOV  cx, [bp+12]
   MOV  dx, [bp+10]
   CMP  al, 7
   JNE  @test3
   PUSH cx
   PUSH dx
   MOV  al, ah
   XOR  ah, ah
   PUSH ax
   call PutNPixel
   JMP  @exit
 @test3:
   CMP  al, 3
   JNE  @test2
   PUSH cx
   PUSH dx
   CALL PutPixel
   JMP  @exit
 @test2:
   MOV  bx, [bp+14]
   CMP  al, 2
   JNE  @test6
   MOV  byte ptr col.red, ah
   MOV  byte ptr col.green, bl
   MOV  byte ptr col.blue, bh
   CALL SetColor
   JMP  @exit
 @test6:
   CMP  al, 6
   JNE  @test4
   MOV  byte ptr col.red, ah
   MOV  byte ptr col.green, bl
   MOV  byte ptr col.blue, bh
   push cx
   push dx
   call SetColor
   call PutPixel
   JMP  @exit
 @test4:
   CMP  al, 4
   JNE  @test0
   PUSH cx
   PUSH dx
   CALL GetPixel
   MOV  ah, byte ptr color.red
   MOV  bl, byte ptr color.green
   MOV  bh, byte ptr color.blue
   JMP  @set_and_exit
 @test0:
   CMP  al, 0
   JNE  @test1
   MOV  ax, $FFFF
   MOV  bx, iseg
   MOV  cx, iofs
   JMP  @set_and_exit
 @test1:
   CMP  al, 1
   JNE  @test5
   CALL InitGraph
   JMP  @exit
 @test5:
   CMP  al, 5
   JNE  @set_and_exit
   MOV  cx, maxx
   MOV  dx, maxy
   JMP  @set_and_exit
 @set_and_exit:
   MOV  [bp+16], ax
   MOV  [bp+14], bx
   MOV  [bp+12], cx
   MOV  [bp+10], dx
 @exit:
 end;

{============================================================================}
{====                The initialization part of driver                   ====}
{============================================================================}
 function  RegisterUGD: Boolean;
 var n,s,o: Word;
     str: ^String;
     tstr,ts: String;
     i: Integer;
     l: LongInt absolute str;
 begin
  RegisterUGD:=False;
  l:=Meml[$0000:$EF*4];
  tstr:=str^;
  DriverName:=Copy(tstr,1,Pos(#1,tstr)-1);
  Delete(tstr,1,Pos(#1,tstr));
  if DriverName <> 'UGD' then begin
   DriverName:='';
   Exit;
  end;
  DriverName:=Copy(tstr,1,Pos(#1,tstr)-1);
  Delete(tstr,1,Pos(#1,tstr));
  ts:=Copy(tstr,1,Pos(#1,tstr)-1);
  Delete(tstr,1,Pos(#1,tstr));
  val(ts,DriverVersion,i);
  if i <> 0 then begin
   DriverVersion:=0;
   Exit;
  end;
  DriverCopyright:=Copy(tstr,1,Pos(#0,tstr)-1);
  asm
   mov  ax, 0
   int  $EE
   mov  n, ax
   mov  s, bx
   mov  o, cx
  end;
  if (n <> $FFFF) or (str <> Ptr(s,o)) then exit;
  RegisterUGD:=True;
 end;

 begin
  WriteLn('Universal Graphics Driver for VGA  Copyright (c) 2000 ShAG Studio');
  if RegisterUGD then begin
   WriteLn('UGD driver already installed.');
   WriteLn('Information about installed UGD driver:');
   WriteLn('Driver name:    ',DriverName);
   WriteLn('Driver Version: ',DriverVersion);
   WriteLn('Author:         ',DriverCopyright);
   Halt(0);
  end;
  MulColorTable;
  iseg:=seg(InitTable);
  iofs:=ofs(InitTable);
  if (ParamStr(1) <> '-0') and (ParamStr(1) <> '-1') and (ParamStr(1) <> '-2') and
     (ParamStr(1) <> '-3') and (ParamCount > 0) then begin
   WriteLn('usage: UGDVESA [options]');
   WriteLn('Options:');
   WriteLn(' -0   - resolution 640x480 (default resolution)');
   WriteLn(' -1   - resolution 800x600');
   WriteLn(' -2   - resolution 1024x768');
   WriteLn(' -3   - resolution 1152x864');
   Halt(0);
  end;
  grmode:=1;
  if ParamStr(1) = '-1' then grmode:=2 else
  if ParamStr(1) = '-2' then grmode:=3 else
  if ParamStr(1) = '-3' then grmode:=4 else
  if ParamStr(1) = '-0' then grmode:=1;
  Write('Resolution: ');
  case grmode of
   1: WriteLn('640x480xTrueColor');
   2: WriteLn('800x600xTrueColor');
   3: WriteLn('1024x768xTrueColor');
   else WriteLn('1152x864xTrueColor');
  end;
  SetIntVec($EE,@UGD_TSR);
  SetIntVec($EF,@InitTable);
  maxx:=0; maxy:=0;
  InitGraph;
  asm
   mov al, 3
   mov ah, 0
   int $10
  end;
  WriteLn('Universal Graphics Driver for VGA  Copyright (c) 2000 ShAG Studio');
  Write('Resolution: ');
  case grmode of
   1: WriteLn('640x480xTrueColor');
   2: WriteLn('800x600xTrueColor');
   3: WriteLn('1024x768xTrueColor');
   else WriteLn('1152x864xTrueColor');
  end;
  Keep(0);
 end.
{============================================================================}
{====                      Universal Graphics Driver                     ====}
{====                          VGA   Version 1.0                         ====}
{====                   Copyright (c)  2000 ShAG Studio                  ====}
{============================================================================}