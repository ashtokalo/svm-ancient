{$A-,B-,D-,E+,F+,G+,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X-}
{$M 2048,0,0}
{============================================================================}
{====--------------------------------------------------------------------====}
{====                      Universal Graphics Driver                     ====}
{====       Name of videocard and number of version to this driver       ====}
{====                   Copyright (c)  2000 ShAG Studio                  ====}
{====--------------------------------------------------------------------====}
{==== For access to function of this driver you mast call interrupt with ====}
{==== number $EE and in register AL put code of operation need.          ====}
{====--------------------------------------------------------------------====}
{==== This table contants code of operation and note to him:             ====}
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
 const
       {This constant content all information about this driver in next view:
        1 param - the 'UGD'
        2 param - the driver name (UGDVGA or another)
        3 param - the version number (the one number by integer type)
                  in string view
        4 param - the copyright for this driver}
       InitTable: String = 'UGD'#1'Driver Name'#1'Driver Version'#1'Author or copyright'#0;

{============================================================================}
{====                              User types                            ====}
{============================================================================}

 {This user type is defined standart type for color}
 type TColor = record
  case byte of
   0: (Red, Green, Blue, Index: Byte);
   1: (color: LongInt);
  end;

 type PColor = ^TColor;

{============================================================================}
{====                              Variables                             ====}
{============================================================================}

 {This variables need for this driver only}
 var DriverVersion: Word;
     DriverName, DriverCopyright: String;
     Color, Col: TColor;

{============================================================================}
{====            Procedures and functions for this driver                ====}
{============================================================================}

 {In this part you mast write special procedure and function that you
  used in other procedures and functions of this driver}

{============================================================================}
{====            Procedures and functions for all UGD drivers            ====}
{============================================================================}

 {This procedure setup color for all operation with graphics}
 procedure  SetColor;
 begin
  {You mast setup default color from variable COL of TColor Type}
 end;

 {This procedure draw one point to x,y coordinates}
 procedure  PutPixel(x,y: Integer);
 begin
  {You mast draw pixel to x, y coordinates with color COL of TColor Type}
 end;

 {This function geting information about one point in True Color view}
 procedure GetPixel(x, y: Word);
 begin
  {You mast get RGB information about pixel as x,y to variable COLOR of TColor Type}
 end;

 {This procedure activate graphics mode}
 procedure InitGraph;
 begin
  {You mast activate graphics mode that be used for input by procedures and
   function of this driver. In variables MaxX and MaxY you mast put
   maximum X and maximum Y for example MaxX:=639; MaxY:=479. This
   coordinates mast show last, but used, coordinates in this mode. In
   mathimatic it write as [0..MaxX] and [0..MaxY]}
 end;

 {The main interrupt procedure}
 procedure UGD_TSR; INTERRUPT; assembler;
 asm
   MOV  AX, [BP+16]
   MOV  CX, [BP+12]
   MOV  DX, [BP+10]
   CMP  AL, 3
   JNE  @TEST2
   PUSH CX
   PUSH DX
   CALL PUTPIXEL
   JMP  @EXIT
 @TEST2:
   MOV  BX, [BP+14]
   CMP  AL, 2
   JNE  @TEST6
   MOV  BYTE PTR COL.RED, AH
   MOV  BYTE PTR COL.GREEN, BL
   MOV  BYTE PTR COL.BLUE, BH
   CALL SETCOLOR
   JMP  @EXIT
 @TEST6:
   CMP  AL, 6
   JNE  @TEST4
   MOV  BYTE PTR COL.RED, AH
   MOV  BYTE PTR COL.GREEN, BL
   MOV  BYTE PTR COL.BLUE, BH
   PUSH CX
   PUSH DX
   CALL SETCOLOR
   CALL PUTPIXEL
   JMP  @EXIT
 @TEST4:
   CMP  AL, 4
   JNE  @TEST0
   PUSH CX
   PUSH DX
   CALL GETPIXEL
   MOV  AH, BYTE PTR COLOR.RED
   MOV  BL, BYTE PTR COLOR.GREEN
   MOV  BH, BYTE PTR COLOR.BLUE
   JMP  @SET_AND_EXIT
 @TEST0:
   CMP  AL, 0
   JNE  @TEST1
   MOV  AX, $FFFF
   MOV  BX, ISEG
   MOV  CX, IOFS
   JMP  @SET_AND_EXIT
 @TEST1:
   CMP  AL, 1
   JNE  @TEST5
   CALL INITGRAPH
   JMP  @EXIT
 @TEST5:
   CMP  AL, 5
   JNE  @SET_AND_EXIT
   MOV  CX, MAXX
   MOV  DX, MAXY
   JMP  @SET_AND_EXIT
 @SET_AND_EXIT:
   MOV  [BP+16], AX
   MOV  [BP+14], BX
   MOV  [BP+12], CX
   MOV  [BP+10], DX
 @EXIT:
 end;

{============================================================================}
{====                The initialization part of driver                   ====}
{============================================================================}

 {This function return true if it find any UGD driver in memory}
 function   RegisterUGD: Boolean;
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
   MOV  AL, 0
   INT  $EE
   MOV  N, AX
   MOV  S, BX
   MOV  O, CX
  end;
  if (n <> $FFFF) or (str <> Ptr(s,o)) then exit;
  RegisterUGD:=True;
 end;

 begin
  WriteLn('UGD  Driver Name  Driver Version  Driver author or copyright');
  if RegisterUGD then begin
   WriteLn('UGD driver already installed.');
   WriteLn('Information about installed UGD driver:');
   WriteLn('Driver name:    ',DriverName);
   WriteLn('Driver Version: ',DriverVersion);
   WriteLn('Author:         ',DriverCopyright);
   Halt(0);
  end;



  {Please delete next 2 string (after comment) in normal driver. It need for
   terminate this program without stay resident}
  WriteLn('This is demo UGD driver. You mast add your code to it source if you want to make UGD driver!');
  Halt(0);



  iseg:=seg(InitTable);
  iofs:=ofs(InitTable);
  SetIntVec($EE,@UGD_TSR);
  SetIntVec($EF,@InitTable);
  MaxX:=0; MaxY:=0;
  Keep(0);
 end.
{============================================================================}
{====                      Universal Graphics Driver                     ====}
{====       Name of videocard and number of version to this driver       ====}
{====                   Copyright (c)  2000 ShAG Studio                  ====}
{============================================================================}