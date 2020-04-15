{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
UNIT SVML0_13;
INTERFACE
 USES SVML_U2, SVML_U1, SVM_n;
 PROCEDURE Com0_0;
 PROCEDURE Com0_1;
 PROCEDURE Com0_2;
 PROCEDURE Com0_3;
 PROCEDURE Com0_4;
 PROCEDURE Com0_5;
 PROCEDURE Com0_6;
 PROCEDURE Com0_7;
 PROCEDURE Com0_8;
 PROCEDURE Com0_9;
 PROCEDURE Com0_10;
 PROCEDURE Com0_11;
 PROCEDURE Com0_12;
 PROCEDURE Com0_13;
 PROCEDURE Com0_14;
 PROCEDURE Com0_15;
 PROCEDURE Com0_16;
 PROCEDURE Com0_17;
 PROCEDURE Com0_18;
 PROCEDURE Com0_19;
 PROCEDURE Com0_20;
 PROCEDURE Com0_21;
 PROCEDURE Com0_22;
 PROCEDURE Com0_23;
 PROCEDURE Com0_24;
 PROCEDURE Com0_25;
 PROCEDURE Com0_26;
 PROCEDURE Com0_27;
 PROCEDURE Com0_28;
 PROCEDURE Com9_0;
 PROCEDURE Com9_1;
 PROCEDURE Com9_2;
 PROCEDURE Com9_3;
 PROCEDURE Com9_4;
 PROCEDURE Com9_5;
 PROCEDURE Com9_6;
 PROCEDURE Com9_7;
 PROCEDURE Com9_8;
 PROCEDURE Com9_9;
 PROCEDURE Com9_10;
 PROCEDURE Com9_11;
 PROCEDURE Com9_12;
 PROCEDURE Com9_13;
 PROCEDURE Com9_14;
 PROCEDURE Com9_15;
 PROCEDURE Com9_16;
 PROCEDURE Com9_17;
 PROCEDURE Com9_18;
 PROCEDURE Com9_19;
 PROCEDURE Com9_20;
 PROCEDURE Com9_21;
 PROCEDURE Com9_22;
 PROCEDURE Com9_23;
 PROCEDURE Com9_24;
 PROCEDURE Com9_25;
 PROCEDURE Com9_26;
 PROCEDURE Com9_27;
 PROCEDURE Com9_28;
 PROCEDURE Com10_0;
 PROCEDURE Com10_1;
 PROCEDURE Com10_2;
 PROCEDURE Com10_3;
 PROCEDURE Com10_4;
 PROCEDURE Com10_5;
 PROCEDURE Com10_6;
 PROCEDURE Com10_7;
 PROCEDURE Com10_8;
 PROCEDURE Com10_9;
 PROCEDURE Com10_10;
 PROCEDURE Com10_11;
 PROCEDURE Com10_12;
 PROCEDURE Com10_13;
 PROCEDURE Com10_14;
 PROCEDURE Com10_15;
 PROCEDURE Com10_16;
 PROCEDURE Com10_17;
 PROCEDURE Com10_18;
 PROCEDURE Com10_19;
 PROCEDURE Com10_20;
 PROCEDURE Com10_21;
 PROCEDURE Com10_22;
 PROCEDURE Com10_23;
 PROCEDURE Com10_24;
 PROCEDURE Com10_25;
 PROCEDURE Com10_26;
 PROCEDURE Com10_27;
 PROCEDURE Com10_28;
 PROCEDURE Com11_0;
 PROCEDURE Com11_1;
 PROCEDURE Com11_2;
 PROCEDURE Com11_3;
 PROCEDURE Com11_4;
 PROCEDURE Com11_5;
 PROCEDURE Com11_6;
 PROCEDURE Com11_7;
 PROCEDURE Com11_8;
 PROCEDURE Com11_9;
 PROCEDURE Com11_10;
 PROCEDURE Com11_11;
 PROCEDURE Com11_12;
 PROCEDURE Com11_13;
 PROCEDURE Com11_14;
 PROCEDURE Com11_15;
 PROCEDURE Com11_16;
 PROCEDURE Com11_17;
 PROCEDURE Com11_18;
 PROCEDURE Com11_19;
 PROCEDURE Com11_20;
 PROCEDURE Com11_21;
 PROCEDURE Com11_22;
 PROCEDURE Com11_23;
 PROCEDURE Com11_24;
 PROCEDURE Com11_25;
 PROCEDURE Com11_26;
 PROCEDURE Com11_27;
 PROCEDURE Com11_28;
 PROCEDURE Com12_0;
 PROCEDURE Com12_1;
 PROCEDURE Com12_2;
 PROCEDURE Com12_3;
 PROCEDURE Com12_4;
 PROCEDURE Com12_5;
 PROCEDURE Com12_6;
 PROCEDURE Com12_7;
 PROCEDURE Com12_8;
 PROCEDURE Com12_9;
 PROCEDURE Com12_10;
 PROCEDURE Com12_11;
 PROCEDURE Com12_12;
 PROCEDURE Com12_13;
 PROCEDURE Com12_14;
 PROCEDURE Com12_15;
 PROCEDURE Com12_16;
 PROCEDURE Com12_17;
 PROCEDURE Com12_18;
 PROCEDURE Com12_19;
 PROCEDURE Com12_20;
 PROCEDURE Com12_21;
 PROCEDURE Com12_22;
 PROCEDURE Com12_23;
 PROCEDURE Com12_24;
 PROCEDURE Com12_25;
 PROCEDURE Com12_26;
 PROCEDURE Com12_27;
 PROCEDURE Com12_28;
 PROCEDURE Com13_0;
 PROCEDURE Com13_1;
 PROCEDURE Com13_2;
 PROCEDURE Com13_3;
 PROCEDURE Com13_4;
 PROCEDURE Com13_5;
 PROCEDURE Com13_6;
 PROCEDURE Com13_7;
 PROCEDURE Com13_8;
 PROCEDURE Com13_9;
 PROCEDURE Com13_10;
 PROCEDURE Com13_11;
 PROCEDURE Com13_12;
 PROCEDURE Com13_13;
 PROCEDURE Com13_14;
 PROCEDURE Com13_15;
 PROCEDURE Com13_16;
 PROCEDURE Com13_17;
 PROCEDURE Com13_18;
 PROCEDURE Com13_19;
 PROCEDURE Com13_20;
 PROCEDURE Com13_21;
 PROCEDURE Com13_22;
 PROCEDURE Com13_23;
 PROCEDURE Com13_24;
 PROCEDURE Com13_25;
 PROCEDURE Com13_26;
 PROCEDURE Com13_27;
 PROCEDURE Com13_28;

IMPLEMENTATION

 PROCEDURE PutInMem;
 BEGIN
  FlagsByteTest(c2);
  CASE 1 SHL WES OF
   1: PRG.PutB(c1,bc2);
   2: BEGIN CompToInt(c2); PRG.PutI(c1,wc2); END;
   4: BEGIN CompToLongInt(c2); PRG.PutL(c1,lc2); END;
   8: PRG.PutC(c1,c2);
  END;
 END;

 PROCEDURE LoadC2;
 BEGIN
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c2);
   2: c2:=PRG.GetI(c2);
   4: c2:=PRG.GetL(c2);
   8: c2:=PRG.GetC(c2);
  END;
 END;

 PROCEDURE LoadC2C1;
 BEGIN
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1);
   2: c2:=PRG.GetI(c1);
   4: c2:=PRG.GetL(c1);
   8: c2:=PRG.GetC(c1);
  END;
 END;

 PROCEDURE LoadC1;
 BEGIN
  CASE 1 SHL WES OF
   1: c1:=PRG.GetB(c1);
   2: c1:=PRG.GetI(c1);
   4: c1:=PRG.GetL(c1);
   8: c1:=PRG.GetC(c1);
  END;
 END;

 PROCEDURE CmpDetect;
 BEGIN
  IF c1 > 0 THEN g_f:=1 ELSE
  IF c1 = 0 THEN e_f:=1 ELSE
  IF c1 < 0 THEN l_f:=1;
  CorectRegFlag;
 END;

 PROCEDURE Com0_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  SetR(r1,RegSize[r1],RegSize[r1],c2);
 END;

 PROCEDURE Com0_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  CASE 1 SHL WES OF
   1: c1:=PRG.GetB(c2);
   2: c1:=PRG.GetI(c2);
   4: c1:=PRG.GetL(c2);
   8: c1:=PRG.GetC(c2);
  END;
  SetR(r1,RegSize[r1],1 SHL WES,c1);
 END;

 PROCEDURE Com0_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c1);
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  c2:=c2+c1;
  CASE 1 SHL WES OF
   1: c1:=PRG.GetB(c2);
   2: c1:=PRG.GetI(c2);
   4: c1:=PRG.GetL(c2);
   8: c1:=PRG.GetC(c2);
  END;
  SetR(r1,RegSize[r1],1 SHL WES,c1);
 END;

 PROCEDURE Com0_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  SetR(r1,RegSize[r1],1,r2);
 END;

 PROCEDURE Com0_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+3);
  SetR(r1,RegSize[r1],2,w1);
 END;

 PROCEDURE Com0_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+3);
  SetR(r1,RegSize[r1],4,l1);
 END;

 PROCEDURE Com0_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c1:=PRG.GetC(RegArea.LIP+3);
  SetR(r1,RegSize[r1],8,c1);
 END;

 PROCEDURE Com0_7;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  CASE 1 SHL WES OF
   1: c1:=PRG.GetB(c2);
   2: c1:=PRG.GetI(c2);
   4: c1:=PRG.GetL(c2);
   8: c1:=PRG.GetC(c2);
  END;
  SetR(r1,RegSize[r1],1 SHL WES,c1);
 END;

 PROCEDURE Com0_8;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c1:=PRG.GetC(RegArea.LIP+3);
  r2:=PRG.GetB(RegArea.LIP+11);
  GetR(r2,RegSize[r2],c2);
  c2:=c2+c1;
  CASE 1 SHL WES OF
   1: c1:=PRG.GetB(c2);
   2: c1:=PRG.GetI(c2);
   4: c1:=PRG.GetL(c2);
   8: c1:=PRG.GetC(c2);
  END;
  SetR(r1,RegSize[r1],1 SHL WES,c1);
 END;

 PROCEDURE Com0_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c2);
  GetR(r2,RegSize[r2],c1);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: CASE RegSize[r2] OF
       1: PRG.PutL(c2,bc1);
       2: PRG.PutL(c2,wc1);
       4: PRG.PutL(c2,lc1);
       8: PRG.PutL(c2,lc1);
      END;
   8: CASE RegSize[r2] OF
       1: PRG.PutC(c2,bc1);
       2: PRG.PutC(c2,wc1);
       4: PRG.PutC(c2,lc1);
       8: PRG.PutC(c2,c1);
      END;
  END;
 END;

 PROCEDURE Com0_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  b1:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,b1);
   2: PRG.PutI(c2,b1);
   4: PRG.PutL(c2,b1);
   8: PRG.PutC(c2,b1);
  END;
 END;

 PROCEDURE Com0_11;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  wc1:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,wc1);
   8: PRG.PutC(c2,wc1);
  END;
 END;

 PROCEDURE Com0_12;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  lc1:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,lc1);
   8: PRG.PutC(c2,lc1);
  END;
 END;

 PROCEDURE Com0_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c1:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,lc1);
   8: PRG.PutC(c2,c1);
  END;
 END;

 PROCEDURE Com0_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  c2:=0; c1:=0;
  GetR(r1,RegSize[r1],c2);
  GetR(r2,RegSize[r2],c1);
  c2:=c2+c1;
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c1);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: CASE RegSize[r2] OF
       1: PRG.PutL(c2,bc1);
       2: PRG.PutL(c2,wc1);
       4: PRG.PutL(c2,lc1);
       8: PRG.PutL(c2,lc1);
      END;
   8: CASE RegSize[r2] OF
       1: PRG.PutC(c2,bc1);
       2: PRG.PutC(c2,wc1);
       4: PRG.PutC(c2,lc1);
       8: PRG.PutC(c2,c1);
      END;
  END;
 END;

 PROCEDURE Com0_15;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c2);
  GetR(r2,RegSize[r2],c1);
  c2:=c2+c1;
  b1:=PRG.GetB(RegArea.LIP+4);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,b1);
   2: PRG.PutI(c2,b1);
   4: PRG.PutL(c2,b1);
   8: PRG.PutC(c2,b1);
  END;
 END;

 PROCEDURE Com0_16;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c2);
  GetR(r2,RegSize[r2],c1);
  c2:=c1+c2;
  wc1:=PRG.GetI(RegArea.LIP+4);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,wc1);
   8: PRG.PutC(c2,wc1);
  END;
 END;

 PROCEDURE Com0_17;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c2);
  GetR(r2,RegSize[r2],c1);
  c2:=c1+c2;
  lc1:=PRG.GetL(RegArea.LIP+4);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,lc1);
   8: PRG.PutC(c2,lc1);
  END;
 END;

 PROCEDURE Com0_18;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c2);
  GetR(r2,RegSize[r2],c1);
  c2:=c1+c2;
  c1:=PRG.GetC(RegArea.LIP+4);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,lc1);
   8: PRG.PutC(c2,c1);
  END;
 END;

 PROCEDURE Com0_19;
 BEGIN
  c2:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c1);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: CASE RegSize[r1] OF
       1: PRG.PutL(c2,bc1);
       2: PRG.PutL(c2,wc1);
       4: PRG.PutL(c2,lc1);
       8: PRG.PutL(c2,lc1);
      END;
   8: CASE RegSize[r1] OF
       1: PRG.PutC(c2,bc1);
       2: PRG.PutC(c2,wc1);
       4: PRG.PutC(c2,lc1);
       8: PRG.PutC(c2,c1);
      END;
  END;
 END;
 PROCEDURE Com0_20;
 BEGIN
  c2:=PRG.GetC(RegArea.LIP+2);
  b1:=PRG.GetB(RegArea.LIP+10);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,b1);
   2: PRG.PutI(c2,b1);
   4: PRG.PutL(c2,b1);
   8: PRG.PutC(c2,b1);
  END;
 END;

 PROCEDURE Com0_21;
 BEGIN
  c2:=PRG.GetC(RegArea.LIP+2);
  wc1:=PRG.GetI(RegArea.LIP+10);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,wc1);
   8: PRG.PutC(c2,wc1);
  END;
 END;

 PROCEDURE Com0_22;
 BEGIN
  c2:=PRG.GetC(RegArea.LIP+2);
  lc1:=PRG.GetL(RegArea.LIP+10);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,lc1);
   8: PRG.PutC(c2,lc1);
  END;
 END;

 PROCEDURE Com0_23;
 BEGIN
  c2:=PRG.GetC(RegArea.LIP+2);
  c1:=PRG.GetC(RegArea.LIP+10);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,lc1);
   8: PRG.PutC(c2,c1);
  END;
 END;

 PROCEDURE Com0_24;
 BEGIN
  c2:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c1);
  c2:=c2+c1;
  r1:=PRG.GetB(RegArea.LIP+11);
  GetR(r1,RegSize[r1],c1);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: CASE RegSize[r1] OF
       1: PRG.PutL(c2,bc1);
       2: PRG.PutL(c2,wc1);
       4: PRG.PutL(c2,lc1);
       8: PRG.PutL(c2,lc1);
      END;
   8: CASE RegSize[r1] OF
       1: PRG.PutC(c2,bc1);
       2: PRG.PutC(c2,wc1);
       4: PRG.PutC(c2,lc1);
       8: PRG.PutC(c2,c1);
      END;
  END;
 END;

 PROCEDURE Com0_25;
 BEGIN
  c2:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c1);
  c2:=c2+c1;
  b1:=PRG.GetB(RegArea.LIP+11);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,b1);
   2: PRG.PutI(c2,b1);
   4: PRG.PutL(c2,b1);
   8: PRG.PutC(c2,b1);
  END;
 END;

 PROCEDURE Com0_26;
 BEGIN
  c2:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c1);
  c2:=c2+c1;
  wc1:=PRG.GetI(RegArea.LIP+11);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,wc1);
   8: PRG.PutC(c2,wc1);
  END;
 END;

 PROCEDURE Com0_27;
 BEGIN
  c2:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c1);
  c2:=c2+c1;
  lc1:=PRG.GetL(RegArea.LIP+11);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,lc1);
   8: PRG.PutC(c2,lc1);
  END;
 END;

 PROCEDURE Com0_28;
 BEGIN
  c2:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c1);
  c2:=c2+c1;
  c1:=PRG.GetC(RegArea.LIP+11);
  CASE 1 SHL WES OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,lc1);
   8: PRG.PutC(c2,c1);
  END;
 END;

 PROCEDURE Com9_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com9_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  LoadC2;
  c1:=c1+c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com9_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c1);
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  c2:=c1+c2;
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=c1+c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com9_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1+r2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com9_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w2:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1+w2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com9_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l2:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1+l2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com9_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1+c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com9_7;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=c1+c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com9_8;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  r2:=PRG.GetB(RegArea.LIP+11);
  GetR(r2,RegSize[r2],c1);
  c2:=c1+c2;
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=c1+c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com9_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)+c2;
   2: c2:=PRG.GetI(c1)+c2;
   4: c2:=PRG.GetL(c1)+c2;
   8: c2:=PRG.GetC(c1)+c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com9_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=c2+r2;
  PutInMem;
 END;

 PROCEDURE Com9_11;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=c2+w1;
  PutInMem;
 END;

 PROCEDURE Com9_12;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=c2+l1;
  PutInMem;
 END;

 PROCEDURE Com9_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)+c2;
   2: c2:=PRG.GetI(c1)+c2;
   4: c2:=PRG.GetL(c1)+c2;
   8: c2:=PRG.GetC(c1)+c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com9_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)+c2;
   2: c2:=PRG.GetI(c1)+c2;
   4: c2:=PRG.GetL(c1)+c2;
   8: c2:=PRG.GetC(c1)+c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com9_15;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  r2:=PRG.GetB(RegArea.LIP+4);
  LoadC2C1;
  c2:=c2+r2;
  PutInMem;
 END;

 PROCEDURE Com9_16;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(RegArea.LIP+4);
  LoadC2C1;
  c2:=c2+w1;
  PutInMem;
 END;

 PROCEDURE Com9_17;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(RegArea.LIP+4);
  LoadC2C1;
  c2:=c2+l1;
  PutInMem;
 END;

 PROCEDURE Com9_18;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(RegArea.LIP+4);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)+c2;
   2: c2:=PRG.GetI(c1)+c2;
   4: c2:=PRG.GetL(c1)+c2;
   8: c2:=PRG.GetC(c1)+c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com9_19;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)+c2;
   2: c2:=PRG.GetI(c1)+c2;
   4: c2:=PRG.GetL(c1)+c2;
   8: c2:=PRG.GetC(c1)+c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com9_20;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  LoadC2C1;
  c2:=c2+r1;
  PutInMem;
 END;

 PROCEDURE Com9_21;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+10);
  LoadC2C1;
  c2:=c2+w1;
  FlagsByteTest(c2);
  PutInMem;
 END;

 PROCEDURE Com9_22;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+10);
  LoadC2C1;
  c2:=c2+l1;
  PutInMem;
 END;

 PROCEDURE Com9_23;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+10);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)+c2;
   2: c2:=PRG.GetI(c1)+c2;
   4: c2:=PRG.GetL(c1)+c2;
   8: c2:=PRG.GetC(c1)+c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com9_24;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(RegArea.LIP+11);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)+c2;
   2: c2:=PRG.GetI(c1)+c2;
   4: c2:=PRG.GetL(c1)+c2;
   8: c2:=PRG.GetC(c1)+c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com9_25;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(RegArea.LIP+11);
  LoadC2C1;
  c2:=c2+r1;
  PutInMem;
 END;

 PROCEDURE Com9_26;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(RegArea.LIP+11);
  LoadC2C1;
  c2:=c2+w1;
  PutInMem;
 END;

 PROCEDURE Com9_27;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(RegArea.LIP+11);
  LoadC2C1;
  c2:=c2+l1;
  PutInMem;
 END;

 PROCEDURE Com9_28;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(RegArea.LIP+11);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)+c2;
   2: c2:=PRG.GetI(c1)+c2;
   4: c2:=PRG.GetL(c1)+c2;
   8: c2:=PRG.GetC(c1)+c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com10_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1-c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com10_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  LoadC2;
  c1:=c1-c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com10_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c1);
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  c2:=c1+c2;
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=c1-c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com10_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1-r2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com10_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w2:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1-w2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com10_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l2:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1-l2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com10_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1-c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com10_7;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=c1-c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com10_8;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  r2:=PRG.GetB(RegArea.LIP+11);
  GetR(r2,RegSize[r2],c1);
  c2:=c1+c2;
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=c1-c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com10_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)-c2;
   2: c2:=PRG.GetI(c1)-c2;
   4: c2:=PRG.GetL(c1)-c2;
   8: c2:=PRG.GetC(c1)-c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com10_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)-c2;
   2: c2:=PRG.GetI(c1)-c2;
   4: c2:=PRG.GetL(c1)-c2;
   8: c2:=PRG.GetC(c1)-c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com10_11;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=c2-w1;
  PutInMem;
 END;

 PROCEDURE Com10_12;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=c2-l1;
  PutInMem;
 END;

 PROCEDURE Com10_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)-c2;
   2: c2:=PRG.GetI(c1)-c2;
   4: c2:=PRG.GetL(c1)-c2;
   8: c2:=PRG.GetC(c1)-c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com10_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)-c2;
   2: c2:=PRG.GetI(c1)-c2;
   4: c2:=PRG.GetL(c1)-c2;
   8: c2:=PRG.GetC(c1)-c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com10_15;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  r2:=PRG.GetB(RegArea.LIP+4);
  LoadC2C1;
  c2:=c2-r2;
  PutInMem;
 END;

 PROCEDURE Com10_16;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(RegArea.LIP+4);
  LoadC2C1;
  c2:=c2-w1;
  PutInMem;
 END;

 PROCEDURE Com10_17;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(RegArea.LIP+4);
  LoadC2C1;
  c2:=c2-l1;
  PutInMem;
 END;

 PROCEDURE Com10_18;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(RegArea.LIP+4);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)-c2;
   2: c2:=PRG.GetI(c1)-c2;
   4: c2:=PRG.GetL(c1)-c2;
   8: c2:=PRG.GetC(c1)-c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com10_19;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)-c2;
   2: c2:=PRG.GetI(c1)-c2;
   4: c2:=PRG.GetL(c1)-c2;
   8: c2:=PRG.GetC(c1)-c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com10_20;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  LoadC2C1;
  c2:=c2-r1;
  PutInMem;
 END;

 PROCEDURE Com10_21;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+10);
  LoadC2C1;
  c2:=c2-w1;
  PutInMem;
 END;

 PROCEDURE Com10_22;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+10);
  LoadC2C1;
  c2:=c2-l1;
  PutInMem;
 END;

 PROCEDURE Com10_23;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+10);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)-c2;
   2: c2:=PRG.GetI(c1)-c2;
   4: c2:=PRG.GetL(c1)-c2;
   8: c2:=PRG.GetC(c1)-c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com10_24;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(RegArea.LIP+11);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)-c2;
   2: c2:=PRG.GetI(c1)-c2;
   4: c2:=PRG.GetL(c1)-c2;
   8: c2:=PRG.GetC(c1)-c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com10_25;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(RegArea.LIP+11);
  LoadC2C1;
  c2:=c2-r1;
  PutInMem;
 END;

 PROCEDURE Com10_26;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(RegArea.LIP+11);
  LoadC2C1;
  c2:=c2-w1;
  PutInMem;
 END;

 PROCEDURE Com10_27;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(RegArea.LIP+11);
  LoadC2C1;
  c2:=c2-l1;
  PutInMem;
 END;

 PROCEDURE Com10_28;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(RegArea.LIP+11);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)-c2;
   2: c2:=PRG.GetI(c1)-c2;
   4: c2:=PRG.GetL(c1)-c2;
   8: c2:=PRG.GetC(c1)-c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com11_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1*c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com11_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  LoadC2;
  c1:=c1*c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com11_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c1);
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  c2:=c1+c2;
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=c1*c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com11_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1*r2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com11_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w2:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1*w2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com11_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l2:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1*l2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com11_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=c1*c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com11_7;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=c1*c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com11_8;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  r2:=PRG.GetB(RegArea.LIP+11);
  GetR(r2,RegSize[r2],c1);
  c2:=c1+c2;
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=c1*c2;
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com11_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)*c2;
   2: c2:=PRG.GetI(c1)*c2;
   4: c2:=PRG.GetL(c1)*c2;
   8: c2:=PRG.GetC(c1)*c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com11_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=c2*r2;
  PutInMem;
 END;

 PROCEDURE Com11_11;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=c2*w1;
  PutInMem;
 END;

 PROCEDURE Com11_12;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=c2*l1;
  PutInMem;
 END;

 PROCEDURE Com11_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)*c2;
   2: c2:=PRG.GetI(c1)*c2;
   4: c2:=PRG.GetL(c1)*c2;
   8: c2:=PRG.GetC(c1)*c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com11_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)*c2;
   2: c2:=PRG.GetI(c1)*c2;
   4: c2:=PRG.GetL(c1)*c2;
   8: c2:=PRG.GetC(c1)*c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com11_15;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  r2:=PRG.GetB(RegArea.LIP+4);
  LoadC2C1;
  c2:=c2*r2;
  PutInMem;
 END;

 PROCEDURE Com11_16;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(RegArea.LIP+4);
  LoadC2C1;
  c2:=c2*w1;
  PutInMem;
 END;

 PROCEDURE Com11_17;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(RegArea.LIP+4);
  LoadC2C1;
  c2:=c2*l1;
  PutInMem;
 END;

 PROCEDURE Com11_18;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(RegArea.LIP+4);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)*c2;
   2: c2:=PRG.GetI(c1)*c2;
   4: c2:=PRG.GetL(c1)*c2;
   8: c2:=PRG.GetC(c1)*c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com11_19;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)*c2;
   2: c2:=PRG.GetI(c1)*c2;
   4: c2:=PRG.GetL(c1)*c2;
   8: c2:=PRG.GetC(c1)*c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com11_20;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  LoadC2C1;
  c2:=c2*r1;
  PutInMem;
 END;

 PROCEDURE Com11_21;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+10);
  LoadC2C1;
  c2:=c2*w1;
  PutInMem;
 END;

 PROCEDURE Com11_22;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+10);
  LoadC2C1;
  c2:=c2*l1;
  PutInMem;
 END;

 PROCEDURE Com11_23;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+10);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)*c2;
   2: c2:=PRG.GetI(c1)*c2;
   4: c2:=PRG.GetL(c1)*c2;
   8: c2:=PRG.GetC(c1)*c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com11_24;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(RegArea.LIP+11);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)*c2;
   2: c2:=PRG.GetI(c1)*c2;
   4: c2:=PRG.GetL(c1)*c2;
   8: c2:=PRG.GetC(c1)*c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com11_25;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(RegArea.LIP+11);
  LoadC2C1;
  c2:=c2*r1;
  PutInMem;
 END;

 PROCEDURE Com11_26;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(RegArea.LIP+11);
  LoadC2C1;
  c2:=c2*w1;
  PutInMem;
 END;

 PROCEDURE Com11_27;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(RegArea.LIP+11);
  LoadC2C1;
  c2:=c2*l1;
  PutInMem;
 END;

 PROCEDURE Com11_28;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(RegArea.LIP+11);
  CASE 1 SHL WES OF
   1: c2:=PRG.GetB(c1)*c2;
   2: c2:=PRG.GetI(c1)*c2;
   4: c2:=PRG.GetL(c1)*c2;
   8: c2:=PRG.GetC(c1)*c2;
  END;
  PutInMem;
 END;

 PROCEDURE Com12_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=DivComp(c1,c2);
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com12_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  LoadC2;
  c1:=DivComp(c1,c2);
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com12_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c1);
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  c2:=c1+c2;
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=DivComp(c1,c2);
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com12_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=DivComp(c1,r2);
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com12_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w2:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=DivComp(c1,w2);
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com12_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l2:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=DivComp(c1,l2);
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com12_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c1:=DivComp(c1,c2);
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com12_7;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=DivComp(c1,c2);
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com12_8;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  r2:=PRG.GetB(RegArea.LIP+11);
  GetR(r2,RegSize[r2],c1);
  c2:=c1+c2;
  GetR(r1,RegSize[r1],c1);
  LoadC2;
  c1:=DivComp(c1,c2);
  FlagsRegTest(r1,c1);
  CorectComp(c1);
  SetR(r1,RegSize[r1],b1,c1);
 END;

 PROCEDURE Com12_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  CASE 1 SHL WES OF
   1: c2:=DivComp(PRG.GetB(c1),c2);
   2: c2:=DivComp(PRG.GetI(c1),c2);
   4: c2:=DivComp(PRG.GetL(c1),c2);
   8: c2:=DivComp(PRG.GetC(c1),c2);
  END;
  PutInMem;
 END;

 PROCEDURE Com12_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=DivComp(c2,r2);
  PutInMem;
 END;

 PROCEDURE Com12_11;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=DivComp(c2,w1);
  PutInMem;
 END;

 PROCEDURE Com12_12;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  LoadC2C1;
  c2:=DivComp(c2,l1);
  PutInMem;
 END;

 PROCEDURE Com12_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  CASE 1 SHL WES OF
   1: c2:=DivComp(PRG.GetB(c1),c2);
   2: c2:=DivComp(PRG.GetI(c1),c2);
   4: c2:=DivComp(PRG.GetL(c1),c2);
   8: c2:=DivComp(PRG.GetC(c1),c2);
  END;
  PutInMem;
 END;

 PROCEDURE Com12_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  CASE 1 SHL WES OF
   1: c2:=DivComp(PRG.GetB(c1),c2);
   2: c2:=DivComp(PRG.GetI(c1),c2);
   4: c2:=DivComp(PRG.GetL(c1),c2);
   8: c2:=DivComp(PRG.GetC(c1),c2);
  END;
  PutInMem;
 END;

 PROCEDURE Com12_15;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  r2:=PRG.GetB(RegArea.LIP+4);
  LoadC2C1;
  c2:=DivComp(c2,r2);
  PutInMem;
 END;

 PROCEDURE Com12_16;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(RegArea.LIP+4);
  LoadC2C1;
  c2:=DivComp(c2,w1);
  PutInMem;
 END;

 PROCEDURE Com12_17;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(RegArea.LIP+4);
  LoadC2C1;
  c2:=DivComp(c2,l1);
  PutInMem;
 END;

 PROCEDURE Com12_18;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(RegArea.LIP+4);
  CASE 1 SHL WES OF
   1: c2:=DivComp(PRG.GetB(c1),c2);
   2: c2:=DivComp(PRG.GetI(c1),c2);
   4: c2:=DivComp(PRG.GetL(c1),c2);
   8: c2:=DivComp(PRG.GetC(c1),c2);
  END;
  PutInMem;
 END;

 PROCEDURE Com12_19;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: c2:=DivComp(PRG.GetB(c1),c2);
   2: c2:=DivComp(PRG.GetI(c1),c2);
   4: c2:=DivComp(PRG.GetL(c1),c2);
   8: c2:=DivComp(PRG.GetC(c1),c2);
  END;
  PutInMem;
 END;

 PROCEDURE Com12_20;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  LoadC2C1;
  c2:=DivComp(c2,r1);
  PutInMem;
 END;

 PROCEDURE Com12_21;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+10);
  LoadC2C1;
  c2:=DivComp(c2,w1);
  PutInMem;
 END;

 PROCEDURE Com12_22;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+10);
  LoadC2C1;
  c2:=DivComp(c2,l1);
  PutInMem;
 END;

 PROCEDURE Com12_23;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+10);
  CASE 1 SHL WES OF
   1: c2:=DivComp(PRG.GetB(c1),c2);
   2: c2:=DivComp(PRG.GetI(c1),c2);
   4: c2:=DivComp(PRG.GetL(c1),c2);
   8: c2:=DivComp(PRG.GetC(c1),c2);
  END;
  PutInMem;
 END;

 PROCEDURE Com12_24;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(RegArea.LIP+11);
  GetR(r1,RegSize[r1],c2);
  CASE 1 SHL WES OF
   1: c2:=DivComp(PRG.GetB(c1),c2);
   2: c2:=DivComp(PRG.GetI(c1),c2);
   4: c2:=DivComp(PRG.GetL(c1),c2);
   8: c2:=DivComp(PRG.GetC(c1),c2);
  END;
  PutInMem;
 END;

 PROCEDURE Com12_25;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(RegArea.LIP+11);
  LoadC2C1;
  c2:=DivComp(c2,r1);
  PutInMem;
 END;

 PROCEDURE Com12_26;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(RegArea.LIP+11);
  LoadC2C1;
  c2:=DivComp(c2,w1);
  PutInMem;
 END;

 PROCEDURE Com12_27;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(RegArea.LIP+11);
  LoadC2C1;
  c2:=DivComp(c2,l1);
  PutInMem;
 END;

 PROCEDURE Com12_28;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(RegArea.LIP+11);
  CASE 1 SHL WES OF
   1: c2:=DivComp(PRG.GetB(c1),c2);
   2: c2:=DivComp(PRG.GetI(c1),c2);
   4: c2:=DivComp(PRG.GetL(c1),c2);
   8: c2:=DivComp(PRG.GetC(c1),c2);
  END;
  PutInMem;
 END;

 PROCEDURE Com13_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  c2:=0; lc2:=0;
  GetR(r2,RegSize[r2],c2);
  ClearAllFlags;
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  LoadC2;
  ClearAllFlags;
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+3);
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r1,RegSize[r1],c1);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  LoadC2C1;
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  ClearAllFlags;
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  b1:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  ClearAllFlags;
  c1:=c1-b1;
  CmpDetect;
 END;

 PROCEDURE Com13_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  ClearAllFlags;
  c1:=c1-w1;
  CmpDetect;
 END;

 PROCEDURE Com13_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  ClearAllFlags;
  c1:=c1-l1;
  CmpDetect;
 END;

 PROCEDURE Com13_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  ClearAllFlags;
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_7;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  ClearAllFlags;
  LoadC2;
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_8;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+3);
  r2:=PRG.GetB(RegArea.LIP+11);
  GetR(r2,RegSize[r2],c1);
  c2:=c2+c1;
  LoadC2;
  GetR(r1,RegSize[r1],c1);
  ClearAllFlags;
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  LoadC1;
  r1:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c2);
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  LoadC1;
  b1:=PRG.GetB(RegArea.LIP+3);
  c1:=c1-b1;
  CmpDetect;
 END;

 PROCEDURE Com13_11;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  LoadC1;
  w1:=PRG.GetI(RegArea.LIP+3);
  c1:=c1-w1;
  CmpDetect;
 END;

 PROCEDURE Com13_12;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  LoadC1;
  l1:=PRG.GetL(RegArea.LIP+3);
  c1:=c1-l1;
  CmpDetect;
 END;

 PROCEDURE Com13_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  LoadC1;
  c2:=PRG.GetC(RegArea.LIP+3);
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  LoadC1;
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_15;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  LoadC1;
  b1:=PRG.GetB(RegArea.LIP+4);
  c1:=c1-b1;
  CmpDetect;
 END;

 PROCEDURE Com13_16;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  LoadC1;
  w1:=PRG.GetI(RegArea.LIP+4);
  c1:=c1-w1;
  CmpDetect;
 END;

 PROCEDURE Com13_17;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  LoadC1;
  l1:=PRG.GetL(RegArea.LIP+4);
  c1:=c1-l1;
  CmpDetect;
 END;

 PROCEDURE Com13_18;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  LoadC1;
  c2:=PRG.GetC(RegArea.LIP+4);
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_19;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  LoadC1;
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_20;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  b1:=PRG.GetB(RegArea.LIP+10);
  LoadC1;
  c1:=c1-b1;
  CmpDetect;
 END;

 PROCEDURE Com13_21;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  w1:=PRG.GetI(RegArea.LIP+10);
  LoadC1;
  c1:=c1-w1;
  CmpDetect;
 END;

 PROCEDURE Com13_22;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  l1:=PRG.GetL(RegArea.LIP+10);
  LoadC1;
  c1:=c1-l1;
  CmpDetect;
 END;

 PROCEDURE Com13_23;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  c2:=PRG.GetC(RegArea.LIP+10);
  LoadC1;
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_24;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(RegArea.LIP+11);
  GetR(r1,RegSize[r1],c2);
  LoadC1;
  c1:=c1-c2;
  CmpDetect;
 END;

 PROCEDURE Com13_25;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  b1:=PRG.GetB(RegArea.LIP+11);
  LoadC1;
  c1:=c1-b1;
  CmpDetect;
 END;

 PROCEDURE Com13_26;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(RegArea.LIP+11);
  LoadC1;
  c1:=c1-w1;
  CmpDetect;
 END;

 PROCEDURE Com13_27;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(RegArea.LIP+11);
  LoadC1;
  c1:=c1-l1;
  CmpDetect;
 END;

 PROCEDURE Com13_28;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(RegArea.LIP+10);
  GetR(r1,RegSize[r1],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(RegArea.LIP+11);
  LoadC1;
  c1:=c1-c2;
  CmpDetect;
 END;

END.