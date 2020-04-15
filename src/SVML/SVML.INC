 PROCEDURE Com26_0;
 BEGIN
  b1:=PRG.GetB(RegArea.LIP+2);
  CASE b1 OF
    0: CSP_0;
    1: CSP_1;
    2: CSP_2;
    3: CSP_3;
    4: CSP_4;
    5: CSP_5;
    6: CSP_6;
    7: CSP_7;
    8: CSP_8;
    9: CSP_9;
   10: CSP_10;
  END;
 END;


 PROCEDURE Com26_1;
 BEGIN
  w1:=PRG.GetI(RegArea.LIP+2);
  CASE w1 OF
    0: CSP_0;
    1: CSP_1;
    2: CSP_2;
    3: CSP_3;
    4: CSP_4;
    5: CSP_5;
    6: CSP_6;
    7: CSP_7;
    8: CSP_8;
    9: CSP_9;
   10: CSP_10;
  END;
 END;

 PROCEDURE Com26_2;
 BEGIN
  l1:=PRG.GetL(RegArea.LIP+2);
  CASE l1 OF
    0: CSP_0;
    1: CSP_1;
    2: CSP_2;
    3: CSP_3;
    4: CSP_4;
    5: CSP_5;
    6: CSP_6;
    7: CSP_7;
    8: CSP_8;
    9: CSP_9;
   10: CSP_10;
  END;
 END;

 PROCEDURE Com26_3;
 BEGIN
 END;

 PROCEDURE Com14_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=CompAND(c1,c2);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com14_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  b1:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompAND(c1,b1);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com14_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompAND(c1,w1);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com14_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompAND(c1,l1);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com14_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompAND(c1,c2);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com15_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=CompOR(c1,c2);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com15_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  b1:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompOR(c1,b1);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com15_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompOR(c1,w1);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com15_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompOR(c1,l1);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com15_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompOR(c1,c2);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com16_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=CompXOR(c1,c2);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com16_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  b1:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompXOR(c1,b1);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com16_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompXOR(c1,w1);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com16_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompXOR(c1,l1);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com16_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompXOR(c1,c2);
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com18_0;
 BEGIN
 END;

 PROCEDURE Com18_1;
 BEGIN
 END;

 PROCEDURE Com18_2;
 BEGIN
 END;

 PROCEDURE Com18_3;
 BEGIN
 END;

 PROCEDURE Com18_4;
 BEGIN
 END;

 PROCEDURE Com19_0;
 BEGIN
 END;

 PROCEDURE Com19_1;
 BEGIN
 END;

 PROCEDURE Com19_2;
 BEGIN
 END;

 PROCEDURE Com19_3;
 BEGIN
 END;

 PROCEDURE Com19_4;
 BEGIN
 END;

 PROCEDURE Com20_0;
 BEGIN
 END;

 PROCEDURE Com20_1;
 BEGIN
 END;

 PROCEDURE Com20_2;
 BEGIN
 END;

 PROCEDURE Com20_3;
 BEGIN
 END;

 PROCEDURE Com20_4;
 BEGIN
 END;

 PROCEDURE Com21_0;
 BEGIN
 END;

 PROCEDURE Com21_1;
 BEGIN
 END;

 PROCEDURE Com21_2;
 BEGIN
 END;

 PROCEDURE Com21_3;
 BEGIN
 END;

 PROCEDURE Com21_4;
 BEGIN
 END;

 PROCEDURE Com22_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=CompAND(c1,c2);
  FlagsRegTest(r1,c1);
 END;

 PROCEDURE Com22_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  b1:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompAND(c1,b1);
  FlagsRegTest(r1,c1);
 END;

 PROCEDURE Com22_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompAND(c1,w1);
  FlagsRegTest(r1,c1);
 END;

 PROCEDURE Com22_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompAND(c1,l1);
  FlagsRegTest(r1,c1);
 END;

 PROCEDURE Com22_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=CompAND(c1,c2);
  FlagsRegTest(r1,c1);
 END;


 PROCEDURE Com23_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  {PUSH LIP}
  PRG.PutC(RegArea.LSS+RegArea.LSP,RegArea.LIP+VarSize7[ComD]+1);
  RegArea.LSP:=RegArea.LSP+8;
  {LIP = address - ComandSize - OperandSize}
  RegArea.LIP:=c1-VarSize7[ComD]-1;
 END;

 PROCEDURE Com23_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  {PUSH LIP}
  PRG.PutC(RegArea.LSS+RegArea.LSP,RegArea.LIP+VarSize7[ComD]+1);
  RegArea.LSP:=RegArea.LSP+8;
  {LIP = address - ComandSize - OperandSize}
  RegArea.LIP:=c1-VarSize7[ComD]-1;
 END;

 PROCEDURE Com23_2;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  {PUSH LIP}
  PRG.PutC(RegArea.LSS+RegArea.LSP,RegArea.LIP+VarSize7[ComD]+1);
  RegArea.LSP:=RegArea.LSP+8;
  {LIP = address - ComandSize - OperandSize}
  RegArea.LIP:=c1-VarSize7[ComD]-1;
 END;

 PROCEDURE Com23_3;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  {PUSH LIP}
  PRG.PutC(RegArea.LSS+RegArea.LSP,RegArea.LIP+VarSize7[ComD]+1);
  RegArea.LSP:=RegArea.LSP+8;
  {LIP = address - ComandSize - OperandSize}
  RegArea.LIP:=c1-VarSize7[ComD]-1;
 END;

 PROCEDURE Com23_4;
 BEGIN
 END;

 PROCEDURE Com24_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  {LIP = address - ComandSize - OperandSize}
  RegArea.LIP:=c1-VarSize7[ComD]-1;
 END;

 PROCEDURE Com24_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  {LIP = address - ComandSize - OperandSize}
  RegArea.LIP:=c1-VarSize7[ComD]-1;
 END;

 PROCEDURE Com24_2;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  {LIP = address - ComandSize - OperandSize}
  RegArea.LIP:=c1-VarSize7[ComD]-1;
 END;

 PROCEDURE Com24_3;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  {LIP = address - ComandSize - OperandSize}
  RegArea.LIP:=c1-VarSize7[ComD]-1;
 END;

 PROCEDURE Com24_4;
 BEGIN
 END;


 PROCEDURE Com28_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  RegArea.LIP:=c1-VarSize8[ComD]-1;
 END;

 PROCEDURE Com28_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  RegArea.LIP:=c1-VarSize8[ComD]-1;
 END;

 PROCEDURE Com28_2;
 BEGIN
  c1:=PRG.GetB(RegArea.LIP+3);
  RegArea.LIP:=c1-VarSize8[ComD]-1;
 END;

 PROCEDURE Com28_3;
 BEGIN
  c1:=PRG.GetB(RegArea.LIP+3);
  r2:=PRG.GetB(RegArea.LIP+11);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  RegArea.LIP:=c1-VarSize8[ComD]-1;
 END;

 PROCEDURE Com28_4;
 BEGIN
 END;

 PROCEDURE Com29_0;
 BEGIN
 END;

 PROCEDURE Com29_1;
 BEGIN
 END;

 PROCEDURE Com29_2;
 BEGIN
 END;

 PROCEDURE Com29_3;
 BEGIN
 END;

 PROCEDURE Com29_4;
 BEGIN
 END;

 PROCEDURE Com0; {MOV}
 BEGIN
  WES:=ComD DIV 29;
  ComD:=ComD MOD 29;
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize1[ComD]+1;
 END;

 PROCEDURE Com1; {MOVS}
 BEGIN
 END;

 PROCEDURE Com2; {PUSH}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize4[ComD]+1;
 END;

 PROCEDURE Com3; {PUSH}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize5[ComD]+1;
 END;

 PROCEDURE Com4; {POP}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize4[ComD]+1;
 END;

 PROCEDURE Com5; {XCHG}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize3[ComD]+1;
 END;

 PROCEDURE Com6; {INC}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize4[ComD]+1;
 END;

 PROCEDURE Com7; {DEC}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize4[ComD]+1;
 END;

 PROCEDURE Com8; {NEG}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize4[ComD]+1;
 END;

 PROCEDURE Com9; {ADD}
 BEGIN
  WES:=ComD DIV 29;
  ComD:=ComD MOD 29;
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize1[ComD]+1;
 END;

 PROCEDURE Com10; {SUB}
 BEGIN
  WES:=ComD DIV 29;
  ComD:=ComD MOD 29;
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize1[ComD]+1;
 END;

 PROCEDURE Com11; {MUL}
 BEGIN
  WES:=ComD DIV 29;
  ComD:=ComD MOD 29;
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize1[ComD]+1;
 END;

 PROCEDURE Com12; {DIV}
 BEGIN
  WES:=ComD DIV 29;
  ComD:=ComD MOD 29;
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize1[ComD]+1;
 END;

 PROCEDURE Com13; {CMP}
 BEGIN
  WES:=ComD DIV 29;
  ComD:=ComD MOD 29;
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize1[ComD]+1;
 END;

 PROCEDURE Com14; {AND}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize6[ComD]+1;
 END;

 PROCEDURE Com15; {OR}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize6[ComD]+1;
 END;

 PROCEDURE Com16; {XOR}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize6[ComD]+1;
 END;

 PROCEDURE Com17; {NOT}
 BEGIN
  RegArea.LIP:=RegArea.LIP+2;
  c1:=0;
  r1:=PRG.GetB(RegArea.LIP);
  GetR(r1,RegSize[r1],c1);
  c1:=CompNOT(c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com18; {RCL}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize6[ComD]+1;
 END;

 PROCEDURE Com19; {RCR}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize6[ComD]+1;
 END;

 PROCEDURE Com20; {SHL}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize6[ComD]+1;
 END;

 PROCEDURE Com21; {SHR}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize6[ComD]+1;
 END;

 PROCEDURE Com22; {TEST}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize6[ComD]+1;
 END;

 PROCEDURE Com23; {CALL}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com24; {JMP}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com25; {RET}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  RegArea.LSP:=RegArea.LSP-8;
  RegArea.LIP:=PRG.GetC(RegArea.LSS+RegArea.LSP);
 END;

 PROCEDURE Com26; {CSP}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize5[ComD]+1;
 END;

 PROCEDURE Com27; {CSP}
 BEGIN
  RegArea.LIP:=RegArea.LIP+2;
 END;

 PROCEDURE Com28; {JRNZ}
 BEGIN
  @SVMComand:=ComPrs[ComN,ComD];
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  IF c1 <> 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize8[ComD]+1;
 END;

 PROCEDURE Com29; {JRZ}
 BEGIN
  @SVMComand:=ComPrs[ComN-1,ComD];
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  IF c1 = 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize8[ComD]+1;
 END;

 PROCEDURE Com30; {JO}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF o_f = 1 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com31; {JZ}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF z_f = 1 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com32; {JS}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF s_f = 1 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com33; {JC}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF c_f = 1 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com34; {JP}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF p_f = 1 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com35; {JA}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF a_f = 1 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com36; {JE}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF e_f = 1 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com37; {JG}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF g_f = 1 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com38; {JL}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF l_f = 1 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com39; {JNO}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF o_f = 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com40; {JNZ}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF z_f = 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com41; {JNS}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF s_f = 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com42; {JNC}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF c_f = 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com43; {JNP}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF p_f = 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com44; {JNA}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF a_f = 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com45; {JNE}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF e_f = 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com46; {JNG}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF g_f = 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com47; {JNL}
 BEGIN
  @SVMComand:=ComPrs[24,ComD];
  IF l_f = 0 THEN SVMComand;
  RegArea.LIP:=RegArea.LIP+VarSize7[ComD]+1;
 END;

 PROCEDURE Com48; {CLO}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  o_f:=0;
 END;

 PROCEDURE Com49; {CLS}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  s_f:=0;
 END;

 PROCEDURE Com50; {CLZ}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  z_f:=0;
 END;

 PROCEDURE Com51; {CLC}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  c_f:=0;
 END;

 PROCEDURE Com52; {CLP}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  p_f:=0;
 END;

 PROCEDURE Com53; {CLA}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  a_f:=0;
 END;

 PROCEDURE Com54; {STO}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  o_f:=1;
 END;

 PROCEDURE Com55; {STS}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  s_f:=1;
 END;

 PROCEDURE Com56; {STZ}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  z_f:=1;
 END;

 PROCEDURE Com57; {STC}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  c_f:=1;
 END;

 PROCEDURE Com58; {STP}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  p_f:=1;
 END;

 PROCEDURE Com59; {STA}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
  a_f:=1;
 END;

 PROCEDURE Com60; {NOP}
 BEGIN
  RegArea.LIP:=RegArea.LIP+1;
 END;

 PROCEDURE InitCom;
 BEGIN
  ComArray[0]:=@Com0;    ComArray[1]:=@Com1;    ComArray[2]:=@Com2;
  ComArray[3]:=@Com3;    ComArray[4]:=@Com4;    ComArray[5]:=@Com5;
  ComArray[6]:=@Com6;    ComArray[7]:=@Com7;    ComArray[8]:=@Com8;
  ComArray[9]:=@Com9;    ComArray[10]:=@Com10;  ComArray[11]:=@Com11;
  ComArray[12]:=@Com12;  ComArray[13]:=@Com13;  ComArray[14]:=@Com14;
  ComArray[15]:=@Com15;  ComArray[16]:=@Com16;  ComArray[17]:=@Com17;
  ComArray[18]:=@Com18;  ComArray[19]:=@Com19;  ComArray[20]:=@Com20;
  ComArray[21]:=@Com21;  ComArray[22]:=@Com22;  ComArray[23]:=@Com23;
  ComArray[24]:=@Com24;  ComArray[25]:=@Com25;  ComArray[26]:=@Com26;
  ComArray[27]:=@Com27;  ComArray[28]:=@Com28;  ComArray[29]:=@Com29;
  ComArray[30]:=@Com30;  ComArray[31]:=@Com31;  ComArray[32]:=@Com32;
  ComArray[33]:=@Com33;  ComArray[34]:=@Com34;  ComArray[35]:=@Com35;
  ComArray[36]:=@Com36;  ComArray[37]:=@Com37;  ComArray[38]:=@Com38;                         ComArray[39]:=@Com39;
  ComArray[40]:=@Com40;  ComArray[41]:=@Com41;  ComArray[42]:=@Com42;
  ComArray[43]:=@Com43;  ComArray[44]:=@Com44;  ComArray[45]:=@Com45;
  ComArray[46]:=@Com46;  ComArray[47]:=@Com47;  ComArray[48]:=@Com48;
  ComArray[49]:=@Com49;  ComArray[50]:=@Com50;  ComArray[51]:=@Com51;
  ComArray[52]:=@Com52;  ComArray[53]:=@Com53;  ComArray[54]:=@Com54;
  ComArray[55]:=@Com55;  ComArray[56]:=@Com56;  ComArray[57]:=@Com57;
  ComArray[58]:=@Com58;  ComArray[59]:=@Com59;  ComArray[60]:=@Com60;
  ComPrs[0,0]:=@Com0_0;  ComPrs[0,1]:=@Com0_1;  ComPrs[0,2]:=@Com0_2;
  ComPrs[0,3]:=@Com0_3;  ComPrs[0,4]:=@Com0_4;  ComPrs[0,5]:=@Com0_5;
  ComPrs[0,6]:=@Com0_6;  ComPrs[0,7]:=@Com0_7;  ComPrs[0,8]:=@Com0_8;
  ComPrs[0,9]:=@Com0_9;  ComPrs[0,10]:=@Com0_10;  ComPrs[0,11]:=@Com0_11;
  ComPrs[0,12]:=@Com0_12;  ComPrs[0,13]:=@Com0_13;  ComPrs[0,14]:=@Com0_14;
  ComPrs[0,15]:=@Com0_15;  ComPrs[0,16]:=@Com0_16;  ComPrs[0,17]:=@Com0_17;
  ComPrs[0,18]:=@Com0_18;  ComPrs[0,19]:=@Com0_19;  ComPrs[0,20]:=@Com0_20;
  ComPrs[0,21]:=@Com0_21;  ComPrs[0,22]:=@Com0_22;  ComPrs[0,23]:=@Com0_23;
  ComPrs[0,24]:=@Com0_24;  ComPrs[0,25]:=@Com0_25;  ComPrs[0,26]:=@Com0_26;
  ComPrs[0,27]:=@Com0_27;  ComPrs[0,28]:=@Com0_28;
  ComPrs[2,0]:=@Com2_0;  ComPrs[2,1]:=@Com2_1;  ComPrs[2,2]:=@Com2_2;
  ComPrs[2,3]:=@Com2_3;  ComPrs[2,4]:=@Com2_4;  ComPrs[2,5]:=@Com2_5;
  ComPrs[2,6]:=@Com2_6;  ComPrs[2,7]:=@Com2_7;  ComPrs[2,8]:=@Com2_8;
  ComPrs[2,9]:=@Com2_9;  ComPrs[2,10]:=@Com2_10;  ComPrs[2,11]:=@Com2_11;
  ComPrs[2,12]:=@Com2_12;  ComPrs[2,13]:=@Com2_13;  ComPrs[2,14]:=@Com2_14;
  ComPrs[2,15]:=@Com2_15;  ComPrs[2,16]:=@Com2_16;
  ComPrs[3,0]:=@Com3_0;  ComPrs[3,1]:=@Com3_1;  ComPrs[3,2]:=@Com3_2;
  ComPrs[3,3]:=@Com3_3;
  ComPrs[4,0]:=@Com4_0;  ComPrs[4,1]:=@Com4_1;  ComPrs[4,2]:=@Com4_2;
  ComPrs[4,3]:=@Com4_3;  ComPrs[4,4]:=@Com4_4;  ComPrs[4,5]:=@Com4_5;
  ComPrs[4,6]:=@Com4_6;  ComPrs[4,7]:=@Com4_7;  ComPrs[4,8]:=@Com4_8;
  ComPrs[4,9]:=@Com4_9;  ComPrs[4,10]:=@Com4_10;  ComPrs[4,11]:=@Com4_11;
  ComPrs[4,12]:=@Com4_12;  ComPrs[4,13]:=@Com4_13;  ComPrs[4,14]:=@Com4_14;
  ComPrs[4,15]:=@Com4_15;  ComPrs[4,16]:=@Com4_16;
  ComPrs[5,0]:=@Com5_0;  ComPrs[5,1]:=@Com5_1;  ComPrs[5,2]:=@Com5_2;
  ComPrs[5,3]:=@Com5_3;  ComPrs[5,4]:=@Com5_4;
  ComPrs[6,0]:=@Com6_0;  ComPrs[6,1]:=@Com6_1;  ComPrs[6,2]:=@Com6_2;
  ComPrs[6,3]:=@Com6_3;  ComPrs[6,4]:=@Com6_4;  ComPrs[6,5]:=@Com6_5;
  ComPrs[6,6]:=@Com6_6;  ComPrs[6,7]:=@Com6_7;  ComPrs[6,8]:=@Com6_8;
  ComPrs[6,9]:=@Com6_9;  ComPrs[6,10]:=@Com6_10;  ComPrs[6,11]:=@Com6_11;
  ComPrs[6,12]:=@Com6_12;  ComPrs[6,13]:=@Com6_13;  ComPrs[6,14]:=@Com6_14;
  ComPrs[6,15]:=@Com6_15;  ComPrs[6,16]:=@Com6_16;
  ComPrs[7,0]:=@Com7_0;  ComPrs[7,1]:=@Com7_1;  ComPrs[7,2]:=@Com7_2;
  ComPrs[7,3]:=@Com7_3;  ComPrs[7,4]:=@Com7_4;  ComPrs[7,5]:=@Com7_5;
  ComPrs[7,6]:=@Com7_6;  ComPrs[7,7]:=@Com7_7;  ComPrs[7,8]:=@Com7_8;
  ComPrs[7,9]:=@Com7_9;  ComPrs[7,10]:=@Com7_10;  ComPrs[7,11]:=@Com7_11;
  ComPrs[7,12]:=@Com7_12;  ComPrs[7,13]:=@Com7_13;  ComPrs[7,14]:=@Com7_14;
  ComPrs[7,15]:=@Com7_15;  ComPrs[7,16]:=@Com7_16;
  ComPrs[8,0]:=@Com8_0;  ComPrs[8,1]:=@Com8_1;  ComPrs[8,2]:=@Com8_2;
  ComPrs[8,3]:=@Com8_3;  ComPrs[8,4]:=@Com8_4;  ComPrs[8,5]:=@Com8_5;
  ComPrs[8,6]:=@Com8_6;  ComPrs[8,7]:=@Com8_7;  ComPrs[8,8]:=@Com8_8;
  ComPrs[8,9]:=@Com8_9;  ComPrs[8,10]:=@Com8_10;  ComPrs[8,11]:=@Com8_11;
  ComPrs[8,12]:=@Com8_12;  ComPrs[8,13]:=@Com8_13;  ComPrs[8,14]:=@Com8_14;
  ComPrs[8,15]:=@Com8_15;  ComPrs[8,16]:=@Com8_16;
  ComPrs[9,0]:=@Com9_0;  ComPrs[9,1]:=@Com9_1;  ComPrs[9,2]:=@Com9_2;
  ComPrs[9,3]:=@Com9_3;  ComPrs[9,4]:=@Com9_4;  ComPrs[9,5]:=@Com9_5;
  ComPrs[9,6]:=@Com9_6;  ComPrs[9,7]:=@Com9_7;  ComPrs[9,8]:=@Com9_8;
  ComPrs[9,9]:=@Com9_9;  ComPrs[9,10]:=@Com9_10;  ComPrs[9,11]:=@Com9_11;
  ComPrs[9,12]:=@Com9_12;  ComPrs[9,13]:=@Com9_13;  ComPrs[9,14]:=@Com9_14;
  ComPrs[9,15]:=@Com9_15;  ComPrs[9,16]:=@Com9_16;  ComPrs[9,17]:=@Com9_17;
  ComPrs[9,18]:=@Com9_18;  ComPrs[9,19]:=@Com9_19;  ComPrs[9,20]:=@Com9_20;
  ComPrs[9,21]:=@Com9_21;  ComPrs[9,22]:=@Com9_22;  ComPrs[9,23]:=@Com9_23;
  ComPrs[9,24]:=@Com9_24;  ComPrs[9,25]:=@Com9_25;  ComPrs[9,26]:=@Com9_26;
  ComPrs[9,27]:=@Com9_27;  ComPrs[9,28]:=@Com9_28;
  ComPrs[10,0]:=@Com10_0;  ComPrs[10,1]:=@Com10_1;  ComPrs[10,2]:=@Com10_2;
  ComPrs[10,3]:=@Com10_3;  ComPrs[10,4]:=@Com10_4;  ComPrs[10,5]:=@Com10_5;
  ComPrs[10,6]:=@Com10_6;  ComPrs[10,7]:=@Com10_7;  ComPrs[10,8]:=@Com10_8;
  ComPrs[10,9]:=@Com10_9;  ComPrs[10,10]:=@Com10_10;  ComPrs[10,11]:=@Com10_11;
  ComPrs[10,12]:=@Com10_12;  ComPrs[10,13]:=@Com10_13;  ComPrs[10,14]:=@Com10_14;
  ComPrs[10,15]:=@Com10_15;  ComPrs[10,16]:=@Com10_16;  ComPrs[10,17]:=@Com10_17;
  ComPrs[10,18]:=@Com10_18;  ComPrs[10,19]:=@Com10_19;  ComPrs[10,20]:=@Com10_20;
  ComPrs[10,21]:=@Com10_21;  ComPrs[10,22]:=@Com10_22;  ComPrs[10,23]:=@Com10_23;
  ComPrs[10,24]:=@Com10_24;  ComPrs[10,25]:=@Com10_25;  ComPrs[10,26]:=@Com10_26;
  ComPrs[10,27]:=@Com10_27;  ComPrs[10,28]:=@Com10_28;
  ComPrs[11,0]:=@Com11_0;  ComPrs[11,1]:=@Com11_1;  ComPrs[11,2]:=@Com11_2;
  ComPrs[11,3]:=@Com11_3;  ComPrs[11,4]:=@Com11_4;  ComPrs[11,5]:=@Com11_5;
  ComPrs[11,6]:=@Com11_6;  ComPrs[11,7]:=@Com11_7;  ComPrs[11,8]:=@Com11_8;
  ComPrs[11,9]:=@Com11_9;  ComPrs[11,10]:=@Com11_10;  ComPrs[11,11]:=@Com11_11;
  ComPrs[11,12]:=@Com11_12;  ComPrs[11,13]:=@Com11_13;  ComPrs[11,14]:=@Com11_14;
  ComPrs[11,15]:=@Com11_15;  ComPrs[11,16]:=@Com11_16;  ComPrs[11,17]:=@Com11_17;
  ComPrs[11,18]:=@Com11_18;  ComPrs[11,19]:=@Com11_19;  ComPrs[11,20]:=@Com11_20;
  ComPrs[11,21]:=@Com11_21;  ComPrs[11,22]:=@Com11_22;  ComPrs[11,23]:=@Com11_23;
  ComPrs[11,24]:=@Com11_24;  ComPrs[11,25]:=@Com11_25;  ComPrs[11,26]:=@Com11_26;
  ComPrs[11,27]:=@Com11_27;  ComPrs[11,28]:=@Com11_28;
  ComPrs[12,0]:=@Com12_0;  ComPrs[12,1]:=@Com12_1;  ComPrs[12,2]:=@Com12_2;
  ComPrs[12,3]:=@Com12_3;  ComPrs[12,4]:=@Com12_4;  ComPrs[12,5]:=@Com12_5;
  ComPrs[12,6]:=@Com12_6;  ComPrs[12,7]:=@Com12_7;  ComPrs[12,8]:=@Com12_8;
  ComPrs[12,9]:=@Com12_9;  ComPrs[12,10]:=@Com12_10;  ComPrs[12,11]:=@Com12_11;
  ComPrs[12,12]:=@Com12_12;  ComPrs[12,13]:=@Com12_13;  ComPrs[12,14]:=@Com12_14;
  ComPrs[12,15]:=@Com12_15;  ComPrs[12,16]:=@Com12_16;  ComPrs[12,17]:=@Com12_17;
  ComPrs[12,18]:=@Com12_18;  ComPrs[12,19]:=@Com12_19;  ComPrs[12,20]:=@Com12_20;
  ComPrs[12,21]:=@Com12_21;  ComPrs[12,22]:=@Com12_22;  ComPrs[12,23]:=@Com12_23;
  ComPrs[12,24]:=@Com12_24;  ComPrs[12,25]:=@Com12_25;  ComPrs[12,26]:=@Com12_26;
  ComPrs[12,27]:=@Com12_27;  ComPrs[12,28]:=@Com12_28;
  ComPrs[13,0]:=@Com13_0;  ComPrs[13,1]:=@Com13_1;  ComPrs[13,2]:=@Com13_2;
  ComPrs[13,3]:=@Com13_3;  ComPrs[13,4]:=@Com13_4;  ComPrs[13,5]:=@Com13_5;
  ComPrs[13,6]:=@Com13_6;  ComPrs[13,7]:=@Com13_7;  ComPrs[13,8]:=@Com13_8;
  ComPrs[13,9]:=@Com13_9;  ComPrs[13,10]:=@Com13_10;  ComPrs[13,11]:=@Com13_11;
  ComPrs[13,12]:=@Com13_12;  ComPrs[13,13]:=@Com13_13;  ComPrs[13,14]:=@Com13_14;
  ComPrs[13,15]:=@Com13_15;  ComPrs[13,16]:=@Com13_16;  ComPrs[13,17]:=@Com13_17;
  ComPrs[13,18]:=@Com13_18;  ComPrs[13,19]:=@Com13_19;  ComPrs[13,20]:=@Com13_20;
  ComPrs[13,21]:=@Com13_21;  ComPrs[13,22]:=@Com13_22;  ComPrs[13,23]:=@Com13_23;
  ComPrs[13,24]:=@Com13_24;  ComPrs[13,25]:=@Com13_25;  ComPrs[13,26]:=@Com13_26;
  ComPrs[13,27]:=@Com13_27;  ComPrs[13,28]:=@Com13_28;
  ComPrs[14,0]:=@Com14_0;  ComPrs[14,1]:=@Com14_1;  ComPrs[14,2]:=@Com14_2;
  ComPrs[14,3]:=@Com14_3;  ComPrs[14,4]:=@Com14_4;
  ComPrs[15,0]:=@Com15_0;  ComPrs[15,1]:=@Com15_1;  ComPrs[15,2]:=@Com15_2;
  ComPrs[15,3]:=@Com15_3;  ComPrs[15,4]:=@Com15_4;
  ComPrs[16,0]:=@Com16_0;  ComPrs[16,1]:=@Com16_1;  ComPrs[16,2]:=@Com16_2;
  ComPrs[16,3]:=@Com16_3;  ComPrs[16,4]:=@Com16_4;
  ComPrs[18,0]:=@Com18_0;  ComPrs[18,1]:=@Com18_1;  ComPrs[18,2]:=@Com18_2;
  ComPrs[18,3]:=@Com18_3;  ComPrs[18,4]:=@Com18_4;
  ComPrs[19,0]:=@Com19_0;  ComPrs[19,1]:=@Com19_1;  ComPrs[19,2]:=@Com19_2;
  ComPrs[19,3]:=@Com19_3;  ComPrs[19,4]:=@Com19_4;
  ComPrs[20,0]:=@Com20_0;  ComPrs[20,1]:=@Com20_1;  ComPrs[20,2]:=@Com20_2;
  ComPrs[20,3]:=@Com20_3;  ComPrs[20,4]:=@Com20_4;
  ComPrs[21,0]:=@Com21_0;  ComPrs[21,1]:=@Com21_1;  ComPrs[21,2]:=@Com21_2;
  ComPrs[21,3]:=@Com21_3;  ComPrs[21,4]:=@Com21_4;
  ComPrs[22,0]:=@Com22_0;  ComPrs[22,1]:=@Com22_1;  ComPrs[22,2]:=@Com22_2;
  ComPrs[22,3]:=@Com22_3;  ComPrs[22,4]:=@Com22_4;
  ComPrs[23,0]:=@Com23_0;  ComPrs[23,1]:=@Com23_1;  ComPrs[23,2]:=@Com23_2;
  ComPrs[23,3]:=@Com23_3;  ComPrs[23,4]:=@Com23_4;
  ComPrs[24,0]:=@Com24_0;  ComPrs[24,1]:=@Com24_1;  ComPrs[24,2]:=@Com24_2;
  ComPrs[24,3]:=@Com24_3;  ComPrs[24,4]:=@Com24_4;
  ComPrs[26,0]:=@Com26_0;  ComPrs[26,1]:=@Com26_1;  ComPrs[26,2]:=@Com26_2;
  ComPrs[26,3]:=@Com26_3;
  ComPrs[28,0]:=@Com28_0;  ComPrs[28,1]:=@Com28_1;  ComPrs[28,2]:=@Com28_2;
  ComPrs[28,3]:=@Com28_3;  ComPrs[28,4]:=@Com28_4;
  ComPrs[29,0]:=@Com29_0;  ComPrs[29,1]:=@Com29_1;  ComPrs[29,2]:=@Com29_2;
  ComPrs[29,3]:=@Com29_3;  ComPrs[29,4]:=@Com29_4;
  RegArea.LIP:=Info.EntryPoint;
  RegArea.LSS:=Info.CodeSize+Info.DataSize;
  RegArea.LSP:=0;
 END;
