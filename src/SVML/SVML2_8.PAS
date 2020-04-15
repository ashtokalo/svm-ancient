{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
UNIT SVML2_8;
INTERFACE
 USES SVML_U2, SVML_U1, SVM_n;
 PROCEDURE Com3_0;
 PROCEDURE Com3_1;
 PROCEDURE Com3_2;
 PROCEDURE Com3_3;
 PROCEDURE Com2_0;
 PROCEDURE Com2_1;
 PROCEDURE Com2_2;
 PROCEDURE Com2_3;
 PROCEDURE Com2_4;
 PROCEDURE Com2_5;
 PROCEDURE Com2_6;
 PROCEDURE Com2_7;
 PROCEDURE Com2_8;
 PROCEDURE Com2_9;
 PROCEDURE Com2_10;
 PROCEDURE Com2_11;
 PROCEDURE Com2_12;
 PROCEDURE Com2_13;
 PROCEDURE Com2_14;
 PROCEDURE Com2_15;
 PROCEDURE Com2_16;
 PROCEDURE Com4_0;
 PROCEDURE Com4_1;
 PROCEDURE Com4_2;
 PROCEDURE Com4_3;
 PROCEDURE Com4_4;
 PROCEDURE Com4_5;
 PROCEDURE Com4_6;
 PROCEDURE Com4_7;
 PROCEDURE Com4_8;
 PROCEDURE Com4_9;
 PROCEDURE Com4_10;
 PROCEDURE Com4_11;
 PROCEDURE Com4_12;
 PROCEDURE Com4_13;
 PROCEDURE Com4_14;
 PROCEDURE Com4_15;
 PROCEDURE Com4_16;
 PROCEDURE Com6_0;
 PROCEDURE Com6_1;
 PROCEDURE Com6_2;
 PROCEDURE Com6_3;
 PROCEDURE Com6_4;
 PROCEDURE Com6_5;
 PROCEDURE Com6_6;
 PROCEDURE Com6_7;
 PROCEDURE Com6_8;
 PROCEDURE Com6_9;
 PROCEDURE Com6_10;
 PROCEDURE Com6_11;
 PROCEDURE Com6_12;
 PROCEDURE Com6_13;
 PROCEDURE Com6_14;
 PROCEDURE Com6_15;
 PROCEDURE Com6_16;
 PROCEDURE Com7_0;
 PROCEDURE Com7_1;
 PROCEDURE Com7_2;
 PROCEDURE Com7_3;
 PROCEDURE Com7_4;
 PROCEDURE Com7_5;
 PROCEDURE Com7_6;
 PROCEDURE Com7_7;
 PROCEDURE Com7_8;
 PROCEDURE Com7_9;
 PROCEDURE Com7_10;
 PROCEDURE Com7_11;
 PROCEDURE Com7_12;
 PROCEDURE Com7_13;
 PROCEDURE Com7_14;
 PROCEDURE Com7_15;
 PROCEDURE Com7_16;
 PROCEDURE Com8_0;
 PROCEDURE Com8_1;
 PROCEDURE Com8_2;
 PROCEDURE Com8_3;
 PROCEDURE Com8_4;
 PROCEDURE Com8_5;
 PROCEDURE Com8_6;
 PROCEDURE Com8_7;
 PROCEDURE Com8_8;
 PROCEDURE Com8_9;
 PROCEDURE Com8_10;
 PROCEDURE Com8_11;
 PROCEDURE Com8_12;
 PROCEDURE Com8_13;
 PROCEDURE Com8_14;
 PROCEDURE Com8_15;
 PROCEDURE Com8_16;
 PROCEDURE Com5_0;
 PROCEDURE Com5_1;
 PROCEDURE Com5_2;
 PROCEDURE Com5_3;
 PROCEDURE Com5_4;
IMPLEMENTATION

 PROCEDURE Com3_0;
 BEGIN
  PRG.PutB(RegArea.LSS+RegArea.LSP,PRG.GetB(RegArea.LIP+2));
  RegArea.LSP:=RegArea.LSP+1;
 END;

 PROCEDURE Com3_1;
 BEGIN
  PRG.PutI(RegArea.LSS+RegArea.LSP,PRG.GetI(RegArea.LIP+2));
  RegArea.LSP:=RegArea.LSP+2;
 END;

 PROCEDURE Com3_2;
 BEGIN
  PRG.PutL(RegArea.LSS+RegArea.LSP,PRG.GetL(RegArea.LIP+2));
  RegArea.LSP:=RegArea.LSP+4;
 END;

 PROCEDURE Com3_3;
 BEGIN
  PRG.PutC(RegArea.LSS+RegArea.LSP,PRG.GetC(RegArea.LIP+2));
  RegArea.LSP:=RegArea.LSP+8;
 END;

 PROCEDURE Com2_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  CASE RegSize[r1] OF
   1: PRG.PutB(RegArea.LSS+RegArea.LSP,bc1);
   2: PRG.PutI(RegArea.LSS+RegArea.LSP,wc1);
   4: PRG.PutL(RegArea.LSS+RegArea.LSP,lc1);
   8: PRG.PutC(RegArea.LSS+RegArea.LSP,c1);
  END;
  RegArea.LSP:=RegArea.LSP+RegSize[r1];
 END;

 PROCEDURE Com2_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r1:=PRG.GetB(c1);
  PRG.PutB(RegArea.LSS+RegArea.LSP,r1);
  RegArea.LSP:=RegArea.LSP+1;
 END;

 PROCEDURE Com2_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(c1);
  PRG.PutB(RegArea.LSS+RegArea.LSP,r1);
  RegArea.LSP:=RegArea.LSP+1;
 END;

 PROCEDURE Com2_3;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r1:=PRG.GetB(c1);
  PRG.PutB(RegArea.LSS+RegArea.LSP,r1);
  RegArea.LSP:=RegArea.LSP+1;
 END;

 PROCEDURE Com2_4;
 BEGIN
  c1:=PRG.GetI(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  r1:=PRG.GetB(c1);
  PRG.PutB(RegArea.LSS+RegArea.LSP,r1);
  RegArea.LSP:=RegArea.LSP+1;
 END;

 PROCEDURE Com2_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  w1:=PRG.GetI(c1);
  PRG.PutI(RegArea.LSS+RegArea.LSP,w1);
  RegArea.LSP:=RegArea.LSP+2;
 END;

 PROCEDURE Com2_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(c1);
  PRG.PutI(RegArea.LSS+RegArea.LSP,w1);
  RegArea.LSP:=RegArea.LSP+2;
 END;

 PROCEDURE Com2_7;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  w1:=PRG.GetI(c1);
  PRG.PutI(RegArea.LSS+RegArea.LSP,w1);
  RegArea.LSP:=RegArea.LSP+2;
 END;

 PROCEDURE Com2_8;
 BEGIN
  c1:=PRG.GetI(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(c1);
  PRG.PutI(RegArea.LSS+RegArea.LSP,w1);
  RegArea.LSP:=RegArea.LSP+2;
 END;

 PROCEDURE Com2_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  l1:=PRG.GetL(c1);
  PRG.PutL(RegArea.LSS+RegArea.LSP,l1);
  RegArea.LSP:=RegArea.LSP+4;
 END;

 PROCEDURE Com2_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(c1);
  PRG.PutL(RegArea.LSS+RegArea.LSP,l1);
  RegArea.LSP:=RegArea.LSP+4;
 END;

 PROCEDURE Com2_11;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  l1:=PRG.GetL(c1);
  PRG.PutL(RegArea.LSS+RegArea.LSP,l1);
  RegArea.LSP:=RegArea.LSP+4;
 END;

 PROCEDURE Com2_12;
 BEGIN
  c1:=PRG.GetI(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(c1);
  PRG.PutL(RegArea.LSS+RegArea.LSP,l1);
  RegArea.LSP:=RegArea.LSP+4;
 END;

 PROCEDURE Com2_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  c1:=PRG.GetC(c1);
  PRG.PutC(RegArea.LSS+RegArea.LSP,c1);
  RegArea.LSP:=RegArea.LSP+8;
 END;

 PROCEDURE Com2_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c1:=PRG.GetC(c1);
  PRG.PutC(RegArea.LSS+RegArea.LSP,c1);
  RegArea.LSP:=RegArea.LSP+8;
 END;

 PROCEDURE Com2_15;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  c1:=PRG.GetC(c1);
  PRG.PutC(RegArea.LSS+RegArea.LSP,c1);
  RegArea.LSP:=RegArea.LSP+8;
 END;

 PROCEDURE Com2_16;
 BEGIN
  c1:=PRG.GetI(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c1:=PRG.GetC(c1);
  PRG.PutC(RegArea.LSS+RegArea.LSP,c1);
  RegArea.LSP:=RegArea.LSP+8;
 END;

 PROCEDURE Com4_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  RegArea.LSP:=RegArea.LSP-RegSize[r1];
  CASE RegSize[r1] OF
   1: BEGIN
       b1:=PRG.GetB(RegArea.LSS+RegArea.LSP);
       SetR(r1,RegSize[r1],1,b1);
      END;
   2: BEGIN
       w1:=PRG.GetI(RegArea.LSS+RegArea.LSP);
       SetR(r1,RegSize[r1],2,w1);
      END;
   4: BEGIN
       l1:=PRG.GetL(RegArea.LSS+RegArea.LSP);
       SetR(r1,RegSize[r1],4,l1);
      END;
   8: BEGIN
       c1:=PRG.GetC(RegArea.LSS+RegArea.LSP);
       SetR(r1,RegSize[r1],8,c1);
      END;
  END;
 END;

 PROCEDURE Com4_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  RegArea.LSP:=RegArea.LSP-1;
  PRG.PutB(c1,PRG.GetB(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+2);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  RegArea.LSP:=RegArea.LSP-1;
  PRG.PutB(c1,PRG.GetB(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_3;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  RegArea.LSP:=RegArea.LSP-1;
  PRG.PutB(c1,PRG.GetB(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_4;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  RegArea.LSP:=RegArea.LSP-1;
  PRG.PutB(c1,PRG.GetB(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  RegArea.LSP:=RegArea.LSP-2;
  PRG.PutI(c1,PRG.GetI(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+2);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  RegArea.LSP:=RegArea.LSP-2;
  PRG.PutI(c1,PRG.GetI(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_7;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  RegArea.LSP:=RegArea.LSP-2;
  PRG.PutI(c1,PRG.GetI(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_8;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  RegArea.LSP:=RegArea.LSP-2;
  PRG.PutI(c1,PRG.GetI(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  RegArea.LSP:=RegArea.LSP-4;
  PRG.PutL(c1,PRG.GetL(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+2);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  RegArea.LSP:=RegArea.LSP-4;
  PRG.PutL(c1,PRG.GetL(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_11;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  RegArea.LSP:=RegArea.LSP-4;
  PRG.PutL(c1,PRG.GetL(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_12;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  RegArea.LSP:=RegArea.LSP-4;
  PRG.PutL(c1,PRG.GetL(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  RegArea.LSP:=RegArea.LSP-8;
  PRG.PutC(c1,PRG.GetC(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+2);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  RegArea.LSP:=RegArea.LSP-8;
  PRG.PutC(c1,PRG.GetC(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_15;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  RegArea.LSP:=RegArea.LSP-8;
  PRG.PutC(c1,PRG.GetC(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com4_16;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  RegArea.LSP:=RegArea.LSP-8;
  PRG.PutC(c1,PRG.GetC(RegArea.LSS+RegArea.LSP));
 END;

 PROCEDURE Com6_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  CASE RegSize[r1] OF
   1: bc1:=bc1+1;
   2: wc1:=wc1+1;
   4: lc1:=lc1+1;
   8: c1:=c1+1;
  END;
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com6_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  b1:=PRG.GetB(c1);
  b1:=b1+1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com6_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  b1:=PRG.GetB(c1);
  b1:=b1+1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com6_3;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  b1:=PRG.GetB(c1);
  b1:=b1+1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com6_4;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  b1:=PRG.GetB(c1);
  b1:=b1+1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com6_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  w1:=PRG.GetI(c1);
  w1:=w1+1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com6_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(c1);
  w1:=w1+1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com6_7;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  w1:=PRG.GetI(c1);
  w1:=w1+1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com6_8;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(c1);
  w1:=w1+1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com6_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  l1:=PRG.GetL(c1);
  l1:=l1+1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com6_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(c1);
  l1:=l1+1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com6_11;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  l1:=PRG.GetL(c1);
  l1:=l1+1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com6_12;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(c1);
  l1:=l1+1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com6_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  c2:=PRG.GetC(c1);
  c2:=c2+1;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com6_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(c1);
  c2:=c2+1;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com6_15;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  c2:=PRG.GetC(c1);
  c2:=c2+1;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com6_16;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(c1);
  c2:=c2+1;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com7_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  CASE RegSize[r1] OF
   1: bc1:=bc1-1;
   2: wc1:=wc1-1;
   4: lc1:=lc1-1;
   8: c1:=c1-1;
  END;
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com7_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  b1:=PRG.GetB(c1);
  b1:=b1-1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com7_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  b1:=PRG.GetB(c1);
  b1:=b1-1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com7_3;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  b1:=PRG.GetB(c1);
  b1:=b1-1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com7_4;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  b1:=PRG.GetB(c1);
  b1:=b1-1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com7_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  w1:=PRG.GetI(c1);
  w1:=w1-1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com7_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(c1);
  w1:=w1-1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com7_7;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  w1:=PRG.GetI(c1);
  w1:=w1-1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com7_8;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(c1);
  w1:=w1-1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com7_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  l1:=PRG.GetL(c1);
  l1:=l1-1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com7_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(c1);
  l1:=l1-1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com7_11;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  l1:=PRG.GetL(c1);
  l1:=l1-1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com7_12;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(c1);
  l1:=l1-1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com7_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  c2:=PRG.GetC(c1);
  c2:=c2-1;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com7_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(c1);
  c2:=c2-1;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com7_15;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  c2:=PRG.GetC(c1);
  c2:=c2-1;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com7_16;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(c1);
  c2:=c2-1;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com8_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  CASE RegSize[r1] OF
   1: bc1:=-bc1;
   2: wc1:=-wc1;
   4: lc1:=-lc1;
   8: c1:=-c1;
  END;
  FlagsRegTest(r1,c1);
  SetR(r1,RegSize[r1],RegSize[r1],c1);
 END;

 PROCEDURE Com8_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  b1:=PRG.GetB(c1);
  b1:=-b1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com8_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  b1:=PRG.GetB(c1);
  b1:=-b1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com8_3;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  b1:=PRG.GetB(c1);
  b1:=-b1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com8_4;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  b1:=PRG.GetB(c1);
  b1:=-b1;
  FlagsByteTest(b1);
  PRG.PutB(c1,b1);
 END;

 PROCEDURE Com8_5;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  w1:=PRG.GetI(c1);
  w1:=-w1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com8_6;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(c1);
  w1:=-w1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com8_7;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  w1:=PRG.GetI(c1);
  w1:=-w1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com8_8;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  w1:=PRG.GetI(c1);
  w1:=-w1;
  FlagsByteTest(w1);
  PRG.PutI(c1,w1);
 END;

 PROCEDURE Com8_9;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  l1:=PRG.GetL(c1);
  l1:=-l1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com8_10;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(c1);
  l1:=-l1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com8_11;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  l1:=PRG.GetL(c1);
  l1:=-l1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com8_12;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  l1:=PRG.GetL(c1);
  l1:=-l1;
  FlagsByteTest(l1);
  PRG.PutL(c1,l1);
 END;

 PROCEDURE Com8_13;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  c2:=PRG.GetC(c1);
  c2:=-c2;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com8_14;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(c1);
  c2:=-c2;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com8_15;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  c2:=PRG.GetC(c1);
  c2:=-c2;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com8_16;
 BEGIN
  c1:=PRG.GetC(RegArea.LIP+2);
  r2:=PRG.GetB(RegArea.LIP+10);
  GetR(r2,RegSize[r2],c2);
  c1:=c1+c2;
  c2:=PRG.GetC(c1);
  c2:=-c2;
  FlagsByteTest(c2);
  PRG.PutC(c1,c2);
 END;

 PROCEDURE Com5_0;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  SetR(r1,RegSize[r1],RegSize[r2],c2);
  SetR(r2,RegSize[r2],RegSize[r1],c1);
 END;

 PROCEDURE Com5_1;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+3);
  GetR(r2,RegSize[r2],c2);
  b1:=PRG.GetB(c2);
  SetR(r1,RegSize[r1],1,b1);
  SetR(r2,RegSize[r2],RegSize[r1],c1);
 END;

 PROCEDURE Com5_2;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+3);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+4);
  GetR(r2,RegSize[r2],c2);
  c2:=c2+c1;
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  b1:=PRG.GetB(c2);
  SetR(r1,RegSize[r1],1,b1);
  SetR(r2,RegSize[r2],RegSize[r1],c1);
 END;

 PROCEDURE Com5_3;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  c2:=PRG.GetC(RegArea.LIP+3);
  b1:=PRG.GetB(c2);
  SetR(r1,RegSize[r1],1,b1);
  CASE RegSize[r1] OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,lc1);
   8: PRG.PutC(c2,c1);
  END;
 END;

 PROCEDURE Com5_4;
 BEGIN
  r1:=PRG.GetB(RegArea.LIP+2);
  GetR(r1,RegSize[r1],c1);
  r2:=PRG.GetB(RegArea.LIP+11);
  GetR(r2,RegSize[r2],c2);
  c2:=c2+PRG.GetC(RegArea.LIP+3);
  b1:=PRG.GetB(c2);
  SetR(r1,RegSize[r1],1,b1);
  CASE RegSize[r1] OF
   1: PRG.PutB(c2,bc1);
   2: PRG.PutI(c2,wc1);
   4: PRG.PutL(c2,lc1);
   8: PRG.PutC(c2,c1);
  END;
 END;

END.