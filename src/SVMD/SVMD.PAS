{$A+,B+,D-,E-,F+,G+,I-,L-,N+,O-,P+,Q-,R-,S-,T+,V+,X+}
{$M 13384,0,14384}

USES Crt, SVM_n, SGI, SEMME_e, SVML_U2, SVML_U1, SVML0_13, SVML2_8, SVML_CSP,
     SFI, SIFI, SSI, DOS;

VAR diagonal: Real;
    mouset: Byte;
    MouseCall: PROCEDURE;
    oscr: TScreen;
    adr, cadr: Comp;
    LRegArea: SVMRegisters;
    o_ff, s_ff, z_ff, c_ff, p_ff, a_ff, {Флаги процессора}
    g_ff, e_ff, l_ff, Key: Byte;       {Флаги перехода, в программу не возвращаются}
    tadr, ladr, madr: Comp;
    sc,br, curadr: Comp;
    PosCounter: LongInt;
    tadrl: LongInt absolute tadr;
    brl: LongInt absolute br;
    BreakP: array [0..255] of Comp;
    BreackPS: array [0..255] of Byte;
    f: File of Comp;
    mdf: Text;
    tstr, tstr2, SelChar, SysChar, Sfn, ts, INIFile:String;

CONST  SVMComType: ARRAY [0..60] OF Byte = (1,2,4,5,4,3,4,4,4,1,1,1,1,1,6,6,6,
       10,6,6,6,6,6,7,7,0,5,10,8,8,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,0,0,0,
       0,0,0,0,0,0,0,0,0); {Код согласования команда - параметры}
       SVMRegistersName: ARRAY [0..40] OF String[3] = (
       'AL ','AH ','BL ','BH ','CL ','CH ','DL ','DH ','AX ','BX ','CX ','DX ','SS ','FS ',
       'SP ','IP ','EP ','FP ','GP ','EAX','EBX','ECX','EDX','ESS','EFS','ESP','EIP',
       'EEP','EFP','EGP','LAX','LBX','LCX','LDX','LSS','LFS','LSP','LIP','LEP',
       'LFP','LGP'); {Имена всех регистров SVM}
       SVMCommandName: ARRAY [0..60] OF String[5] = (
       'MOV ','MOVS','PUSH','PUSH','POP ','XCHG','INC ','DEC ','NEG ','ADD ','SUB ',
       'MUL ','DIV ','CMP ','AND ','OR  ','XOR ','NOT ','RCL ','RCR ','SHL ','SHR ','TEST',
       'CALL','JMP ','RET ','CSP ','CSP ','JRNZ','JRZ ','JO  ','JZ  ','JS  ',
       'JC  ','JP  ','JA  ','JE  ','JG  ','JL  ','JNO ','JNZ ','JNS ','JNC ','JNP ','JNA ','JNE ',
       'JNG ','JNL ','CLO ','CLS ','CLZ ','CLC ','CLP ','CLA ','STO ','STS ','STZ ','STC ',
       'STP ','STA ','NOP '); {Имена всех команд SVM}
       DATA: array [0..3] of String[6] = ('BYTE  ','WORD  ','DWORD ','QWORD ');
      RegColor: TColor = (Text : 0; Fon : 3; SText : 15; SFon : 3);
      ChangedRegColor: TColor = (Text : 15; Fon : 3; SText : 0; SFon : 7);
      BreakColor: TColor = (Text : 15; Fon : 4; SText : 14; SFon : 4);
      WarnigColor: TColor = (Text : 14; Fon : 4; SText : 0; SFon : 7);
      SelectColor: TColor = (Text : 0; Fon : 3; SText : 15; SFon : 3);
      HelpColor: TColor = (Text : 0; Fon : 3; SText : 15; SFon : 3);
      EditWindowColor: TColor = (Text : 14; Fon : 1; SText : 15; SFon : 1);
      TotalStr = 15;
      HelpText: array [0..TotalStr-1] of String[65] = (
      ' ~Hot Keys~',
      '-------------------------------------------------------------',
      ' ~Alt+X~   - use this keys to exit from the debugger;',
      ' ~Alt+E~   - use this keys for turning on highlight for',
      '           commands and registers;',
      ' ~Alt+F5~  - use this keys to view user screen;',
      ' ~F1~      - use this key to show this window;',
      ' ~F2~      - use this key to toogle breakpoint;',
      ' ~F7~      - use this key to execute one assembler command;',
      ' ~F8~      - use this key to execute the next statement in',
      '           the current procedure;',
      ' ~Ctrl+F9~ - use this keys to run program.',
      ' ',
      ' You can read more in ~SVMD.DOC~ file with full help about',
      '~SVM Debugger v1.0~');

{============================================================================}
 {Процедуры отвечающие за реализацию каждой команды}
 {$I SVML.INC}

function  HexB(b: Byte): String;
const HD: array [0..15] of Char = ('0','1','2','3','4','5','6','7','8','9',
                                   'A','B','C','D','E','F');
begin
 ts:=HD[b shr 4]+HD[b and $F];
 if SysChar = '' then Str(b,ts);
 HexB:=ts;
end;

function  HexW(w: Word): String;
begin
 ts:=HexB(Hi(w))+HexB(Lo(w));
 if SysChar = '' then Str(w,ts);
 HexW:=ts;
end;

function  HexI(i: Integer): String;
var i1: Integer;
    w: Word absolute i1;
begin
 i1:=i;
 ts:=HexW(w);
 if SysChar = '' then Str(i,ts);
 HexI:=ts;
end;

function  HexL(l: LongInt): String;
var l1: LongInt;
    w:array [0..1] of Word absolute l1;
begin
 l1:=l;
 ts:=HexW(w[1])+HexW(w[0]);
 if SysChar = '' then Str(l,ts);
 HexL:=ts;
end;

function  HexC(c: Comp): String;
var c1: Comp;
    l: array [0..1] of LongInt absolute c1;
begin
 c1:=c;
 HexC:=HexL(l[1])+HexL(l[0]);
end;

function PosToAdr(p: LongInt): Comp;
var c: Comp;
begin
 if p >= sc then p:=1;
 c:=0;
 Seek(f,p-1);
 read(f,c);
 PosToAdr:=c;
end;

function AdrToPosCounter(adr: Comp): LongInt;
var p: LongInt;
    c: Comp;
begin
 if adr >= Info.CodeSize then adr:=0;
 p:=1;
 Seek(f,0);
 c:=0;
 while (c < adr) and (p < sc) do begin
  p:=p+1;
  read(f,c);
 end;
 Seek(f,0);
 AdrToPosCounter:=p;
end;

function IsFile(fn: String): Boolean;
var f: File;
begin
 IsFile:=False;
 if ((UpCase(fn[1]) IN ['A'..'Z']) and (fn[2] = ':') and (fn[3] = '\')) or
    (Length(fn) < 15) then else Exit;
 assign(f,fn);
 {$I-}
 reset(f);
 {$I+}
 if IOResult <> 0 then IsFile:=False else begin IsFile:=True; close(f); end;
end;

procedure ShowMainScreen;
var x,y: Integer;
begin
 FillWindow(0,1,80,24,Chr(178),EditColor);
 FillWindow(0,0,80,1,' ',WinColor);
 ClearSL;
 WriteString(2,1,'SVM Debugger  Version 1.0  Copyright (c) 1999 ShAG Studio',WinColor);
 WriteString(79-Length(sfn),1,'~'+UpString(sfn)+'~',WinColor);
 x:=1; y:=2;
 ShowWindow(x,y,x+79,y+9,DoubleB,'Memory',EditWindowColor);
 x:=1; y:=12;
 ShowWindow(x,y,x+54,y+12,DoubleB,'Registers',RegColor);
 x:=56; y:=12;
 ShowWindow(x,y,x+24,y+12,DoubleB,'Stack head',RegColor);
end;

procedure ShowSteck;
var x,y,n: Integer;
begin
 x:=56;
 y:=12;
 WriteString(x+2,y+11,'LSS',RegColor);
 WriteString(x+2,y+1, 'LSP'+Chr(16),RegColor);
 for n:=1 to 11 do begin
  if ((RegArea.LSS+RegArea.LSP-(n)*8) < (PRG.Size-8)) and ((RegArea.LSS+RegArea.LSP-(n)*8) >= 0) then
  WriteString(x+7,y+n,HexC(PRG.GetC(RegArea.LSS+RegArea.LSP-(n)*8)),RegColor) else
  WriteString(x+7,y+n,AddS('Out of memory',16),RegColor);
 end;
end;

procedure ShowRegisters;
var x, y: Integer;
    c: Comp;
    s: String;
    col: TColor;
begin
 x:=1;
 y:=12;
 if RegArea.LAX <> LRegArea.LAX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+1 ,'LAX '+HexC(RegArea.LAX),Col);
 if RegArea.LBX <> LRegArea.LBX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+2 ,'LBX '+HexC(RegArea.LBX),Col);
 if RegArea.LCX <> LRegArea.LCX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+3 ,'LCX '+HexC(RegArea.LCX),Col);
 if RegArea.LDX <> LRegArea.LDX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+4 ,'LDX '+HexC(RegArea.LDX),Col);
 if RegArea.LFS <> LRegArea.LFS then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+5 ,'LFS '+HexC(RegArea.LFS),Col);
 if RegArea.LSS <> LRegArea.LSS then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+6 ,'LSS '+HexC(RegArea.LSS),Col);
 if RegArea.LSP <> LRegArea.LSP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+7 ,'LSP '+HexC(RegArea.LSP),Col);
 if RegArea.LIP <> LRegArea.LIP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+8 ,'LIP '+HexC(RegArea.LIP),Col);
 if RegArea.LEP <> LRegArea.LEP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+9 ,'LEP '+HexC(RegArea.LEP),Col);
 if RegArea.LFP <> LRegArea.LFP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+10,'LFP '+HexC(RegArea.LFP),Col);
 if RegArea.LGP <> LRegArea.LGP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+2,y+11,'LGP '+HexC(RegArea.LGP),Col);

 if RegArea.EAX <> LRegArea.EAX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+1 ,'EAX '+HexL(RegArea.EAX),Col);
 if RegArea.EBX <> LRegArea.EBX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+2 ,'EBX '+HexL(RegArea.EBX),Col);
 if RegArea.ECX <> LRegArea.ECX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+3 ,'ECX '+HexL(RegArea.ECX),Col);
 if RegArea.EDX <> LRegArea.EDX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+4 ,'EDX '+HexL(RegArea.EDX),Col);
 if RegArea.EFS <> LRegArea.EFS then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+5 ,'EFS '+HexL(RegArea.EFS),Col);
 if RegArea.ESS <> LRegArea.ESS then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+6 ,'ESS '+HexL(RegArea.ESS),Col);
 if RegArea.ESP <> LRegArea.ESP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+7 ,'ESP '+HexL(RegArea.ESP),Col);
 if RegArea.EIP <> LRegArea.EIP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+8 ,'EIP '+HexL(RegArea.EIP),Col);
 if RegArea.EEP <> LRegArea.EEP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+9 ,'EEP '+HexL(RegArea.EEP),Col);
 if RegArea.EFP <> LRegArea.EFP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+10,'EFP '+HexL(RegArea.EFP),Col);
 if RegArea.EGP <> LRegArea.EGP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+23,y+11,'EGP '+HexL(RegArea.EGP),Col);

 if RegArea.AX <> LRegArea.AX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+1 ,'AX '+HexI(RegArea.AX),Col);
 if RegArea.BX <> LRegArea.BX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+2 ,'BX '+HexI(RegArea.BX),Col);
 if RegArea.CX <> LRegArea.CX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+3 ,'CX '+HexI(RegArea.CX),Col);
 if RegArea.DX <> LRegArea.DX then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+4 ,'DX '+HexI(RegArea.DX),Col);
 if RegArea.FS <> LRegArea.FS then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+5 ,'FS '+HexI(RegArea.FS),Col);
 if RegArea.SS <> LRegArea.SS then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+6 ,'SS '+HexI(RegArea.SS),Col);
 if RegArea.SP <> LRegArea.SP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+7 ,'SP '+HexI(RegArea.SP),Col);
 if RegArea.IP <> LRegArea.IP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+8 ,'IP '+HexI(RegArea.IP),Col);
 if RegArea.EP <> LRegArea.EP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+9 ,'EP '+HexI(RegArea.EP),Col);
 if RegArea.FP <> LRegArea.FP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+10,'FP '+HexI(RegArea.FP),Col);
 if RegArea.GP <> LRegArea.GP then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+36,y+11,'GP '+HexI(RegArea.GP),Col);

 if RegArea.AL <> LRegArea.AL then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+44,y+1 ,'AL '+HexB(RegArea.AL),Col);
 if RegArea.AH <> LRegArea.AH then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+44,y+2 ,'AH '+HexB(RegArea.AH),Col);
 if RegArea.BL <> LRegArea.BL then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+44,y+3 ,'BL '+HexB(RegArea.BL),Col);
 if RegArea.BH <> LRegArea.BH then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+44,y+4 ,'BH '+HexB(RegArea.BH),Col);
 if RegArea.CL <> LRegArea.CL then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+44,y+5 ,'CL '+HexB(RegArea.CL),Col);
 if RegArea.CH <> LRegArea.CH then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+44,y+6 ,'CH '+HexB(RegArea.CH),Col);
 if RegArea.DL <> LRegArea.DL then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+44,y+7 ,'DL '+HexB(RegArea.DL),Col);
 if RegArea.DH <> LRegArea.DH then Col:=ChangedRegColor else Col:=RegColor;
 WriteString(x+44,y+8 ,'DH '+HexB(RegArea.DH),Col);

 if o_f <> o_ff then Col:=ChangedRegColor else Col:=RegColor;
 Str(o_f,s);
 WriteString(x+50,y+1,'o='+s,Col);
 if s_f <> s_ff then Col:=ChangedRegColor else Col:=RegColor;
 Str(s_f,s);
 WriteString(x+50,y+2,'s='+s,Col);
 if z_f <> z_ff then Col:=ChangedRegColor else Col:=RegColor;
 Str(z_f,s);
 WriteString(x+50,y+3,'z='+s,Col);
 if c_f <> c_ff then Col:=ChangedRegColor else Col:=RegColor;
 Str(c_f,s);
 WriteString(x+50,y+4,'c='+s,Col);
 if p_f <> p_ff then Col:=ChangedRegColor else Col:=RegColor;
 Str(p_f,s);
 WriteString(x+50,y+5,'p='+s,Col);
 if a_f <> a_ff then Col:=ChangedRegColor else Col:=RegColor;
 Str(a_f,s);
 WriteString(x+50,y+6,'a='+s,Col);

 if e_f <> e_ff then Col:=ChangedRegColor else Col:=RegColor;
 Str(e_f,s);
 WriteString(x+50,y+9,'e='+s,Col);
 if g_f <> g_ff then Col:=ChangedRegColor else Col:=RegColor;
 Str(g_f,s);
 WriteString(x+50,y+10,'g='+s,Col);
 if l_f <> l_ff then Col:=ChangedRegColor else Col:=RegColor;
 Str(l_f,s);
 WriteString(x+50,y+11,'l='+s,Col);
 ShowSteck;
 LRegArea:=RegArea;
 o_ff:=o_f;
 s_ff:=s_f;
 z_ff:=z_f;
 c_ff:=c_f;
 p_ff:=p_f;
 a_ff:=a_f;
 e_ff:=e_f;
 g_ff:=g_f;
 l_ff:=l_f;
end;

function DetectC(var adr: Comp): String;
var s: String;
    b,b1: Byte;
    i: Integer;
    l: LongInt;
    c: Comp;
begin
 if adr >= PRG.Size then begin
   s:='--- Out of memory ---';
   Exit;
 end;
 if adr >= Info.CodeSize then begin
  s:='DB ';
  c:=adr;
  while (c < adr+13) and (c < PRG.Size) do begin
   if PRG.Size > c then
   s:=s+HexB(PRG.GetB(c))+SysChar+',' else
   s:=s+'END of memory ';
   c:=c+1;
  end;
  if c > adr then adr:=c-1;
  Delete(s,Length(s),1);
  DetectC:=s;
  Exit;
 end;
 s:='';
 b:=PRG.GetB(adr);
 if b > 60 then begin
  s:=AddS('DB',4)+HexB(b)+SysChar;
  adr:=adr+1;
 end else begin
  s:=s+SelChar+AddS(SVMCommandName[b],5)+SelChar;
  adr:=adr+1;
  if SVMComType[b] > 0 then begin
   b1:=b;
   b:=PRG.GetB(adr);
   adr:=adr+1;
   case SVMComType[b1] of
    1:  begin
         if not (b in [0,3..6]) then s:=s+Data[(b DIV 29)];
         b:=b MOD 29;
         case b of
          0..8: begin
                 s:=s+SelChar+SVMRegistersName[PRG.GetB(adr)]+SelChar+', ';
                 adr:=adr+1;
                 case b of
                  0: begin
                      b:=PRG.GetB(adr);
                      adr:=adr+1;
                      s:=s+SelChar+SVMRegistersName[b]+SelChar;
                     end;
                  1: begin
                      b:=PRG.GetB(adr);
                      adr:=adr+1;
                      s:=s+'['+SelChar+SVMRegistersName[b]+SelChar+']';
                     end;
                  2: begin
                      b:=PRG.GetB(adr);
                      adr:=adr+1;
                      s:=s+'['+SelChar+SVMRegistersName[b]+SelChar+'+';
                      b:=PRG.GetB(adr);
                      adr:=adr+1;
                      s:=s+SelChar+SVMRegistersName[b]+SelChar+']';
                     end;
                  3: begin
                      b:=PRG.GetB(adr);
                      adr:=adr+1;
                      s:=s+HexB(b)+SysChar;
                     end;
                  4: begin
                      i:=PRG.GetI(adr);
                      adr:=adr+2;
                      s:=s+HexI(i)+SysChar;
                     end;
                  5: begin
                      l:=PRG.GetL(adr);
                      adr:=adr+4;
                      s:=s+HexL(l)+SysChar;
                     end;
                  6: begin
                      c:=PRG.GetC(adr);
                      adr:=adr+8;
                      s:=s+HexC(c)+SysChar;
                     end;
                  7: begin
                      c:=PRG.GetC(adr);
                      adr:=adr+8;
                      s:=s+'['+HexC(c)+SysChar+']';
                     end;
                  8: begin
                      c:=PRG.GetC(adr);
                      adr:=adr+8;
                      s:=s+'['+HexC(c)+SysChar+'+';
                      b:=PRG.GetB(adr);
                      adr:=adr+1;
                      s:=s+SelChar+SVMRegistersName[b]+SelChar+']';
                     end;
                  end;
                 end;
          9..13,19..23: begin
                  if b in [9..13] then
                    s:=s+'['+SelChar+SVMRegistersName[PRG.GetB(adr)]+SelChar+'], ' else
                    s:=s+'['+HexC(PRG.GetC(adr))+SysChar+'], ';
                  if b in [9..13] then
                    adr:=adr+1 else
                    adr:=adr+8;
                  case b of
                   9,19: begin
                      b:=PRG.GetB(adr);
                      adr:=adr+1;
                      s:=s+SelChar+SVMRegistersName[b]+SelChar;
                      end;
                   10,20:begin
                       b:=PRG.GetB(adr);
                       adr:=adr+1;
                       s:=s+HexB(b)+SysChar;
                      end;
                   11,21:begin
                       i:=PRG.GetI(adr);
                       adr:=adr+2;
                       s:=s+HexI(i)+SysChar;
                      end;
                   12,22:begin
                       l:=PRG.GetL(adr);
                       adr:=adr+4;
                       s:=s+HexL(l)+SysChar;
                      end;
                   13,23:begin
                       c:=PRG.GetC(adr);
                       adr:=adr+8;
                       s:=s+HexC(c)+SysChar;
                      end;
                  end;
                 end;
          14..18,24..28: begin
                 if b in [14..18] then begin
                  s:=s+'['+SelChar+SVMRegistersName[PRG.GetB(adr)]+SelChar+'+';
                  adr:=adr+1;
                  s:=s+SelChar+SVMRegistersName[PRG.GetB(adr)]+SelChar+'], ';
                  adr:=adr+1;
                 end else begin
                  s:=s+'['+HexC(PRG.GetC(adr))+SysChar+'+';
                  adr:=adr+8;
                  s:=s+SelChar+SVMRegistersName[PRG.GetB(adr)]+SelChar+'], ';
                  adr:=adr+1;
                 end;
                  case b of
                   14,24: begin
                      b:=PRG.GetB(adr);
                      adr:=adr+1;
                      s:=s+SelChar+SVMRegistersName[b]+SelChar;
                      end;
                   15,25:begin
                       b:=PRG.GetB(adr);
                       adr:=adr+1;
                       s:=s+HexB(b)+SysChar;
                      end;
                   16,26:begin
                       i:=PRG.GetI(adr);
                       adr:=adr+2;
                       s:=s+HexI(i)+SysChar;
                      end;
                   17,27:begin
                       l:=PRG.GetL(adr);
                       adr:=adr+4;
                       s:=s+HexL(l)+SysChar;
                      end;
                   18,28:begin
                       c:=PRG.GetC(adr);
                       adr:=adr+8;
                       s:=s+HexC(c)+SysChar;
                      end;
                  end;
                  end;
         end;
        end;
     3: begin
         if (not b in [0]) then s:=s+Data[(b DIV 4)];
         b:=b MOD 4;
         s:=s+SelChar+SVMRegistersName[PRG.GetB(adr)]+SelChar+', [';
         adr:=adr+1;
         case b of
          0: begin
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+SelChar+SVMRegistersName[b]+SelChar;
             end;
          1: begin
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+HexB(b)+SysChar;
             end;
          2: begin
              i:=PRG.GetI(adr);
              adr:=adr+2;
              s:=s+HexI(i)+SysChar;
             end;
          3: begin
              l:=PRG.GetL(adr);
              adr:=adr+4;
              s:=s+HexL(l)+SysChar;
             end;
          4: begin
              c:=PRG.GetC(adr);
              adr:=adr+8;
              s:=s+HexC(c)+SysChar;
             end;
         end;
         s:=s+']';
        end;
    4: begin
        if b = 0 then begin
         b:=PRG.GetB(adr);
         adr:=adr+1;
         s:=s+SelChar+SVMRegistersName[b]+SelChar;
        end else begin
         b:=b-1;
         s:=s+Data[b DIV 29];
         b:=b MOD 4;
         case b of
          0: begin
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+'['+SelChar+SVMRegistersName[b]+SelChar+']';
             end;
          1: begin
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+'['+SelChar+SVMRegistersName[b]+SelChar+'+';
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+SelChar+SVMRegistersName[b]+SelChar+']';
             end;
          2: begin
              c:=PRG.GetC(adr);
              adr:=adr+8;
              s:=s+'['+HexC(c)+SysChar+']';
             end;
          3: begin
              c:=PRG.GetC(adr);
              adr:=adr+8;
              s:=s+'['+HexC(c)+SysChar+'+';
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+SelChar+SVMRegistersName[b]+SelChar+']';
             end;
         end;
        end;
       end;
     5: begin
         case b of
          0: begin
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+HexB(b)+SysChar;
             end;
          1: begin
              i:=PRG.GetI(adr);
              adr:=adr+2;
              s:=s+HexI(i)+SysChar;
              end;
          2: begin
              l:=PRG.GetL(adr);
              adr:=adr+4;
              s:=s+HexL(l)+SysChar;
             end;
          3: begin
              c:=PRG.GetC(adr);
              adr:=adr+8;
              s:=s+HexC(c)+SysChar;
             end;
         end;
        end;
     6: begin
         s:=s+SelChar+SVMRegistersName[PRG.GetB(adr)]+SelChar+', ';
         adr:=adr+1;
         case b of
          0: begin
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+SelChar+SVMRegistersName[b]+SelChar;
             end;
          1: begin
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+HexB(b)+SysChar;
             end;
          2: begin
              i:=PRG.GetI(adr);
              adr:=adr+2;
              s:=s+HexI(i)+SysChar;
              end;
          3: begin
              l:=PRG.GetL(adr);
              adr:=adr+4;
              s:=s+HexL(l)+SysChar;
             end;
          4: begin
              c:=PRG.GetC(adr);
              adr:=adr+8;
              s:=s+HexC(c)+SysChar;
             end;
         end;
        end;
     7: begin
         case b of
          0: begin
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+SelChar+SVMRegistersName[b]+SelChar;
             end;
          1: begin
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+SelChar+SVMRegistersName[b]+SelChar+'+';
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+SelChar+SVMRegistersName[b]+SelChar;
             end;
          2: begin
              c:=PRG.GetC(adr);
              adr:=adr+8;
              s:=s+HexC(c)+SysChar;
             end;
          3: begin
              c:=PRG.GetC(adr);
              adr:=adr+8;
              s:=s+HexC(c)+SysChar;
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+SelChar+SVMRegistersName[b]+SelChar;
             end;
         end;
        end;
     8: begin
         s:=s+SelChar+SVMRegistersName[PRG.GetB(adr)]+SelChar+', ';
         adr:=adr+1;
         case b of
          0: begin
              b:=PRG.GetB(adr);
              adr:=adr+1;
              s:=s+HexB(b)+SysChar;
             end;
          1: begin
              i:=PRG.GetI(adr);
              adr:=adr+2;
              s:=s+HexI(i)+SysChar;
             end;
          2: begin
              l:=PRG.GetL(adr);
              adr:=adr+4;
              s:=s+HexL(l)+SysChar;
             end;
          3: begin
              c:=PRG.GetC(adr);
              adr:=adr+8;
              s:=s+HexC(c)+SysChar;
             end;
         end;
        end;
    10: s:=s+SelChar+SVMRegistersName[b]+SelChar;
   end;
  end;
 end;
 DetectC:=s;
end;

 function IsBP(Adr: Comp): Boolean;
 var c: Comp;
     l: LongInt;
 begin
  c:=Adr;
  l:=0;
  while (l < br) and (c <> BreakP[l]) do l:=l+1;
  if (c = BreakP[l]) and (l < br) then IsBP:=True else IsBP:=False;
 end;

procedure ShowCMDList(var adr: Comp);
var x, y, n: Integer;
    c, adrl: Comp;
    s,s1: String;
begin
 x:=1;
 y:=2;
 ladr:=adr;
 for n:=0 to 7 do begin
  if adr+1 < PRG.Size then begin
   adrl:=adr;
   s1:=' '+Hexc(adr)+'   '+DetectC(adr);
   if not IsBP(adrl) then WriteString(x+1,y+1+n,AddS(s1,78+TotalS(s1)),EditWindowColor)
   else WriteString(x+1,y+1+n,AddS(s1,78+TotalS(s1)),BreakColor);
  end else begin
   s1:=' '+Hexc(adrl)+'   '+'Out of memory';
   WriteString(x+1,y+1+n,AddS(s1,78+TotalS(s1)),EditWindowColor)
  end;
 end;
 madr:=adr;
end;

procedure SelectAdr(adr: Comp);
var s,s1: String;
    c,c1,tm: Comp;
    f: Byte;
    x, y, n: Integer;
begin
 if adr >= PRG.Size then adr:=PRG.Size-1;
 tm:=adr;
 x:=1;
 y:=2;
 c:=ladr;
 curadr:=adr;
 f:=0;
 for n:=0 to 7 do begin
  c1:=c;
  s:=' '+AddS(Hexc(c)+'   '+DetectC(c),77);
  s:=AddS(s,78+TotalS(s));
  if c1 = madr then begin
   if not IsBP(madr) then WriteString(x+1,y+1+n,s,EditWindowColor) else WriteString(x+1,y+1+n,s,BreakColor);
  end;
  if c1 = adr then begin
   WriteString(x+1,y+1+n,s,SelectColor);
   f:=1;
  end;
 end;
 if f = 0 then begin
  c:=tm;
  ShowCMDList(c);
  c:=tm;
  s1:=' '+Hexc(c)+'   '+DetectC(c);
  WriteString(x+1,y+1,AddS(s1,78+TotalS(s1)),SelectColor);
 end;
 madr:=tm;
end;

 PROCEDURE FreeCall;
 BEGIN
 END;

 procedure showWarning(text: String);
 begin
  ShowMDialog(60,CenterText,'Warning!',text,'~O~k',WarnigColor);
 end;

 procedure showMessage(text: String);
 begin
  ShowMDialog(60,CenterText,'Message',text,'~O~k',WinColor);
 end;

 procedure ShowHelp;
 var x,y,l,n: Integer;
     key: Byte;
     col: TColor;
 begin
  col:=HelpColor;
  SaveScreen(SSITempScreen);
  l:=TotalStr;
  x:=((80-61) div 2);
  y:=(25-l) div 2;
  ShowWindow(x,y,x+61+3,y+l+3,DoubleB, 'Help', col);
  l:=0;
  for n:=0 to TotalStr-1 do
   WriteString(x+2,y+2+n,HelpText[n],HelpColor);
  repeat
   key:=Ord(ReadKey);
  until key in [13,32,27];
  RestoreScreen(SSITempScreen);
 end;

 procedure RunCom;
 begin
  @SVMComand:=ComArray[ComN];
  SVMComand;
  ComN:=PRG.GetB(RegArea.LIP);
  ComD:=PRG.GetB(RegArea.LIP+1);
 end;

 PROCEDURE RunFile;
 var c,ta1,ta2: Comp;
     key2: Byte;
     n, l: LongInt;
 label one_step;
 BEGIN
  ComN:=PRG.GetB(RegArea.LIP);
  VMError:=False;
  ComD:=PRG.GetB(RegArea.LIP+1);
  ShowRegisters;
  SelectAdr(RegArea.LIP);
  REPEAT
   MouseCall;
   c1:=0; c2:=0;
   repeat
    if (KeyPressed) and (Ord(ReadKey) = 0) then begin
     key:=Ord(ReadKey);

     if Key = 108 then begin
      SaveScreen(SSITempScreen);
      RestoreScreen(oscr);
      CursorOn;
      repeat
      until KeyPressed;
      key:=Ord(ReadKey);
      if Key = 0 then Key:=Ord(ReadKey);
      SaveScreen(oscr);
      RestoreScreen(SSITempScreen);
      CursorOff;
     end else

     if Key = 80 then begin
      if PosCounter < sc then PosCounter:=PosCounter+1;
      Seek(f,PosCounter-1);
      Read(f,tadr);
      SelectAdr(tadr);
     end else

     if Key = 72 then begin
      if PosCounter > 1 then PosCounter:=PosCounter-1;
      Seek(f,PosCounter-1);
      Read(f,tadr);
      SelectAdr(tadr);
     end else

     if Key = 81 then begin
      if PosCounter+8 < sc then PosCounter:=PosCounter+8;
      Seek(f,PosCounter-1);
      Read(f,tadr);
      SelectAdr(tadr);
     end else

     if Key = 73 then begin
      if PosCounter-8 > 1 then PosCounter:=PosCounter-8;
      Seek(f,PosCounter-1);
      Read(f,tadr);
      SelectAdr(tadr);
     end else

     if Key = 66 then begin
      ComN:=PRG.GetB(RegArea.LIP);
      if not (ComN in [23]) then goto one_step;
      VMError:=False;
      SaveScreen(SSITempScreen);
      RestoreScreen(oscr);
      CursorOn;
      TextColor(7);
      TextBackGround(0);
      ta1:=RegArea.LIP;
      DetectC(ta1);
      repeat
       RunCom;
      until (RegArea.LIP >= PRG.Size) or (RegArea.LIP = ta1)
            or IsBP(RegArea.LIP) or (Port[$60] = 88);
      SaveScreen(oscr);
      RestoreScreen(SSITempScreen);
      CursorOff;
      ShowRegisters;
      SelectAdr(RegArea.LIP);
      VMError:=False;
      if RegArea.LIP = Info.FinishPoint then Exit;
      PosCounter:=AdrToPosCounter(RegArea.LIP);
     end else

     if Key = 65 then begin
     one_step:
      VMError:=False;
      if ComN in [26,27] then Key2:=1 else Key2:=0;
      if Key2 = 1 then begin
       SaveScreen(SSITempScreen);
       RestoreScreen(oscr);
       CursorOn;
       TextColor(7);
       TextBackGround(0);
      end;
      RunCom;
      if Key2 = 1 then begin
       SaveScreen(oscr);
       RestoreScreen(SSITempScreen);
       CursorOff;
      end;
      ShowRegisters;
      SelectAdr(RegArea.LIP);
      VMError:=False;
      if RegArea.LIP = Info.FinishPoint then Exit;
      PosCounter:=AdrToPosCounter(RegArea.LIP);
     end else

     if Key = 60 then begin
      tadr:=PosToAdr(PosCounter);
      if (not IsBP(tadr)) and (br < 255) then begin
       brl:=brl+1;
       l:=0;
       while (BreackPS[l] <> 0) and (l < 256) do l:=l+1;
       BreackPS[l]:=1;
       BreakP[l]:=tadr;
      end else begin
       l:=0;
       c:=BreakP[l];
       while (c <> tadr) and (l < br) do begin
        l:=l+1;
        c:=BreakP[l];
       end;
       BreackPS[l]:=0;
       BreakP[l]:=PRG.Size+1;
       br:=br-1;
      end;
      SelectAdr(PosToAdr(PosCounter));
     end else

     if Key = 102 then begin
      VMError:=False;
      SaveScreen(SSITempScreen);
      RestoreScreen(oscr);
      CursorOn;
      TextColor(7);
      TextBackGround(0);
      repeat
       RunCom;
      until (RegArea.LIP >= PRG.Size) or IsBP(RegArea.LIP) or (Port[$60] = 88)
            or (RegArea.LIP = Info.FinishPoint);
      SaveScreen(oscr);
      RestoreScreen(SSITempScreen);
      CursorOff;
      ShowRegisters;
      SelectAdr(RegArea.LIP);
      VMError:=False;
      if RegArea.LIP = Info.FinishPoint then Exit;
      PosCounter:=AdrToPosCounter(RegArea.LIP);
     end else

     if Key = 59 then ShowHelp else

     if Key = 18 then begin
      if SelChar = '' then SelChar:='~' else SelChar:='';
      ShowCMDList(ladr);
      SelectAdr(PosToAdr(PosCounter));
     end;

     if Key = 45 then
      if not ShowQDialog(40,CenterText,0,'Exit','Are you sure?','~Y~es','~N~o',WinColor) then key:=255;

    end else Key:=255;
   until (Key = 45);
  UNTIL (RegArea.LIP = Info.FinishPoint) OR (ComN > 60) or (Key = 45);
 END;

PROCEDURE LoadIniFile;
VAR tstr: String;
    c,t: Integer;
BEGIN
 WriteSL('Read configuration file...');
 tstr:=GetItem(INIFile,'OPTIONS','GRAPHICS_MODE');
 Val(tstr,GrMode,c);
 IF c <> 0 THEN GrMode:=1;
 MaxX:=640; MaxY:=480;
 CASE GrMode OF
  0: BEGIN GrMode:=4; MaxX:=320; MaxY:=200; END;
  1: BEGIN GrMode:=2; MaxX:=640; MaxY:=480; END;
  2: BEGIN GrMode:=5; MaxX:=640; MaxY:=480; END;
  3: BEGIN GrMode:=6; MaxX:=800; MaxY:=600; END;
  4: BEGIN GrMode:=7; MaxX:=1024; MaxY:=768; END;
  5: BEGIN GrMode:=8; MaxX:=1152; MaxY:=864; END;
  6: BEGIN GrMode:=9; MaxX:=1280; MaxY:=1024; END;
 END;

 tstr:=GetItem(INIFile,'OPTIONS','DIAGONAL');
 Val(tstr,t,c);
 diagonal:=t;
 IF c <> 0 THEN diagonal:=14;

 tstr:=GetItem(INIFile,'OPTIONS','TOTAL_FONTS');
 Val(tstr,t,c);
 TotalFonts:=t;
 IF c <> 0 THEN TotalFonts:=0;

 tstr:=GetItem(INIFile,'OPTIONS','SWAP_DISK');
 tstr:=UpString(tstr);
 if (tstr[1] in ['A'..'Z']) and (tstr <> 'DEFAULT') and (tstr <> INIFileNotFound)
 and (tstr <> FolderNotFound) and (tstr <> ItemNotFound)
  then VMDISK:=tstr else VMDISK:='C';

 @MouseCall:=@MouseRun;
END;

FUNCTION UpString(str: String): String;
VAR n: Byte;
BEGIN
 FOR n:=1 TO Length(str) DO Str[n]:=UpCase(Str[n]);
 UpString:=Str;
END;

procedure FreeVar;
begin
 o_ff:=0; s_ff:=0; z_ff:=0; a_ff:=0; c_ff:=0; p_ff:=0; g_ff:=0; e_ff:=0; l_ff:=0;
 o_f:=0; s_f:=0; z_f:=0; a_f:=0; c_f:=0; p_f:=0; g_f:=0; e_f:=0; l_f:=0;
 ladr:=0;
 adr:=0;
 FillChar(RegArea,SizeOf(RegArea),0);
 FillChar(LRegArea,SizeOf(RegArea),0);
 diagonal:=0;
 mouset:=0;
 adr:=0; cadr:=0;
 tadr:=0; ladr:=0; madr:=0;
 sc:=0; br:=0; curadr:=0;
 PosCounter:=0;
 tstr:='';
 tstr2:='';
 SelChar:='';
 SysChar:='';
 Sfn:='';
 ts:='';
end;

{========================= Основная программа ===============================}
BEGIN
 CheckBreak:=False;
 WriteLn('SVM Debugger  Version 1.0  Copyright (c) 1999 ShAG Studio');
 SaveScreen(oscr);
 repeat
  FreeVar;
  SelChar:='';
  SysChar:='h';
  IniFile:='SVMD.INI';
  VMFile:='svmd.swp';
  Loc:=1;
  if MemAvail < 10000 then begin
   WriteLn('Error: not enother memory.');
   Halt(0);
  end;
  @MouseCall:=@FreeCall;
  SourceName:=ParamStr(1);
  if not IsFile(SourceName) or (SourceName = '') then begin
   WriteLn('Syntax: svmd.exe filename [options]');
   WriteLn('  filename - full path with full name to file for debugging');
   WriteLn(' Options:');
   WriteLn('   /MDF     - disassembling and saving in file as assembler program.');
   WriteLn('              Creat file have been DAS extenation.');
   Halt(0);
  end;
  sfn:=SourceName;
  repeat
   if Pos('\',sfn) <> 0 then Delete(sfn,1,Pos('\',sfn));
  until Pos('\',sfn) = 0;
  if UpString(ParamStr(2)) = '/MDF' then begin
    tstr:=SourceName;
    if Pos('.',tstr) <> 0 then tstr:=Copy(tstr,1,Pos('.',tstr));
    tstr:=tstr+'das';
    assign(mdf,tstr);
    {$I-}
     ReWrite(mdf);
    {$I+}
    if IOResult <> 0 then begin
     WriteLn('Error: can`t creat new file with name ',tstr);
     Halt(0);
    end;
    WriteLn(mdf,';----------------------------------------------------------------------------');
    WriteLn(mdf,';                             SVM Debugger');
    WriteLn(mdf,';                             Version  1.0');
    WriteLn(mdf,';                    Copyright (c) 1999 ShAG Studio');
    WriteLn(mdf,';----------------------------------------------------------------------------');
    WriteLn(mdf,'; Original file name: '+SourceName);
    WriteLn(mdf,';----------------------------------------------------------------------------');
    WriteLn(mdf,'');
  end;
  CursorOff;
  ShowMainScreen;
  WriteSL('Reading configuration file...');
  LoadINIFile;
  WriteSL(AddS('Loading '+SourceName+' and initilising virtual memory...',77));
  LoadFile;
  WriteSL('Initilising...');
  InitCom;
{ InitFI(diagonal);}
  AddrSeg:=Seg(RegArea);
  AddrOfs:=Ofs(RegArea);
  SelectFonts:=0;
  adr:=RegArea.LIP;
  RegArea.LSP:=RegArea.LSS;
  adr:=RegArea.LIP;
  for brl:=0 to 255 do BreakP[brl]:=PRG.Size+1;
  if UpString(ParamStr(2)) = '/MDF' then begin
   Str(Trunc(Info.StackSize),tstr);
   WriteLn(mdf,'; Stack size = ',tstr,'   (',HexC(Info.StackSize),'h)');
   WriteLn(mdf,' STACK ',HexC(Info.StackSize)+SysChar);
   WriteLn(mdf,'');
   WriteLn(mdf,';------------------------------------------------------');
   WriteLn(mdf,'; Code block - started');
   WriteLn(mdf,';------------------------------------------------------');
   WriteLn(mdf,'');
   tadr:=PRG.Size-Info.StackSize;
   PRG.Size:=tadrl;
  end;
  assign(f, 'svmd.adr');
  {$I-}
  ReWrite(f);
  {$I+}
  if IOResult <> 0 then begin
   br:=0;
  end else begin
   br:=0;
   sc:=0;
   {$I-}
   tadr:=0;
   o_ff:=1;
   repeat
    sc:=sc+1;
    cadr:=br;
    Write(f,br);
    tstr:=DetectC(br);
    if UpString(ParamStr(2)) = '/MDF' then begin
     if madr = RegArea.LIP then begin
     WriteLn(mdf,'; Entree point at this place');
      WriteLn(mdf,' START:');
      madr:=0;
     end;
     if ladr = Info.FinishPoint then begin
      WriteLn(mdf,'; Finish point at this place');
      WriteLn(mdf,' FINISH:');
      ladr:=0;
     end;
     if br = RegArea.LIP then madr:=RegArea.LIP;
     if br = Info.FinishPoint then ladr:=Info.FinishPoint;
     if (Pos('DB ',tstr) <> 0) and (o_ff <> 0) then begin
      WriteLn(mdf,'');
      WriteLn(mdf,';------------------------------------------------------');
      WriteLn(mdf,'; Data block - started');
      WriteLn(mdf,';------------------------------------------------------');
      WriteLn(mdf,'');
      WriteSL('Disassembling '+SourceName+' Pless wait...');
      o_ff:=0;
     end;
     if Pos('CSP ',tstr) <> 0 then WriteLn(mdf,' ; Call system procedure');
     if Pos('RET ',tstr) <> 0 then WriteLn(mdf,' ; End of procedure or exit from procedure');
     WriteLn(mdf,' '+AddS(tstr,55)+'; '+HexC(cadr)+SysChar);
     if Pos('RET ',tstr) <> 0 then WriteLn(mdf,'');
    end;
    if br = RegArea.LIP then tadr:=sc;
    if br = Info.FinishPoint then BreakP[0]:=adr;
    adr:=br;
    Str(Trunc(br/(PRG.Size/100)),tstr2);
    WriteSL('Disassembling '+SourceName+'('+tstr2+'%) > '+tstr);
   until br >= PRG.Size-1;
   br:=1;
  end;
  o_ff:=0;
  WriteSL('Disassembling '+SourceName+'(100%) - Ok.');
  if UpString(ParamStr(2)) = '/MDF' then begin
   WriteLn(mdf,'');
   WriteLn(mdf,';------------------------------------------------------');
   WriteLn(mdf,'; File was debugging without errors.');
   WriteLn(mdf,';------------------------------------------------------');
   WriteLn(mdf,'; Some information to file:');
   Str(Trunc(Info.CodeSize),tstr);
   WriteLn(mdf,'; Code size:    ',AddS(tstr,15),' (',HexC(Info.CodeSize),'h)');
   Str(Trunc(Info.DataSize),tstr);
   WriteLn(mdf,'; Data size:    ',AddS(tstr,15),' (',HexC(Info.DataSize),'h)');
   Str(Trunc(Info.StackSize),tstr);
   WriteLn(mdf,'; Stack size:   ',AddS(tstr,15),' (',HexC(Info.StackSize),'h)');
   Str(Trunc(RegArea.LIP),tstr);
   WriteLn(mdf,'; Entry point:  ',AddS(tstr,15),' (',HexC(RegArea.LIP),'h)');
   Str(Trunc(Info.FinishPoint),tstr);
   WriteLn(mdf,'; Finish point: ',AddS(tstr,15),' (',HexC(Info.FinishPoint),'h)');
   WriteLn(mdf,';----------------------------------------------------------------------------');
   WriteLn(mdf,';                             SVM Debugger');
   WriteLn(mdf,';                             Version  1.0');
   WriteLn(mdf,';                    Copyright (c) 1999 ShAG Studio');
   WriteLn(mdf,';----------------------------------------------------------------------------');
   {$I-}
   Close(mdf);
   {$I-}
   DoneVM;
   {$I-}
   Close(f);
   Erase(f);
   ShowMessage('Program was disassembling without errors.');
   RestoreScreen(oscr);
   TextColor(7);
   TextBackGround(0);
   Halt(0);
  end;
  SelChar:='~';
  if BreakP[0] <> 0 then BreackPS[0]:=1 else BreackPS[0]:=0;
  adr:=RegArea.LIP;
  RegArea.LSP:=RegArea.LIP;
  ShowCMDList(RegArea.LSP);
  RegArea.LSP:=0;
  SelectAdr(RegArea.LIP);
  PosCounter:=AdrToPosCounter(RegArea.LIP);
  Randomize;
  WriteSL('~Alt+X~ Exit  ~F2~ Set BP  ~F7~ Step  ~F8~ Step over  ~Ctrl+F9~ Run              ~F1~ Help ');
  RunFile;
  if Key <> 45 then
   ShowMessage('Program finished without errors.');
{  DestroyGI;}
  DoneVM;
  {$I-}
  Close(f);
  Erase(f);
  {$I+}
 until ((Key = 45) or (RegArea.LIP = Info.FinishPoint)) and
  not ShowQDialog(60,CenterText,0,'Information',
                  'Do you want to restart program?','~Y~es','~N~o',WinColor);
  RestoreScreen(oscr);
  TextColor(7);
  TextBackGround(0);
END.
{============================================================================}
