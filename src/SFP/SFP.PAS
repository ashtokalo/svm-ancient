{============================================================================}
{====--------------------------------------------------------------------====}
{====                         ShAG files packer                          ====}
{====                            Version 1.0                             ====}
{====                  Copyright (c) 1999 ShAG Studio                    ====}
{====--------------------------------------------------------------------====}
{====   Работа этого архиватора основанна на алгоритме Хофмана, описание ====}
{==== которого всегда можно найти, поэтому его описывать я не буду.      ====}
{====   Таблицы для упаковки и распаковки я взял из файла lzhuf.c Он был ====}
{==== написан  Haruyasu Yoshizaki 20 ноября 1988 и  обновлен 6 июня 1989 ====}
{==== года.                                                              ====}
{====--------------------------------------------------------------------====}
{==== Вы имеете следующие права:                                         ====}
{====  1. Вы можете испольовать и видоизменять программу но только не    ====}
{====     для комерческих целей.                                         ====}
{====  2. Вы можете распространять этот файл только без изменений.       ====}
{====  3. Вы можете распространять свои программы написанные с помошью   ====}
{====     этого файла, при этом, вы не можете брать плату за эти про-    ====}
{====     граммы, также они должны распространяться на таких же правах   ====}
{====     как и этот файл.                                               ====}
{====--------------------------------------------------------------------====}
{============================================================================}
{$A-,B+,D-,E-,F-,G+,I-,L-,N-,O-,P+,Q-,R-,S-,T-,V-,X-}
{$M 16384,0,0}

 uses dos,crt;

 const  N = 2048;
        F = 70;
        THRESHOLD = 2;
        NILL = N;
        TREENODE = N+1;
        EXIT_OK = 0;
        EXIT_FAILED = -1;
        FILEBUFSIZE = 31744;
        BUFFERSIZE = 32767;
        N_Char = (256 - THRESHOLD + F);
        T      = (N_Char * 2 - 1);
        R      = (T - 1);
        MAX_FREQ = $1000;
 {Таблицы для упаковки}
 p_len:array [0..63] of Byte= (
       $03, $04, $04, $04, $05, $05, $05, $05,
       $05, $05, $05, $05, $06, $06, $06, $06,
       $06, $06, $06, $06, $06, $06, $06, $06,
       $07, $07, $07, $07, $07, $07, $07, $07,
       $07, $07, $07, $07, $07, $07, $07, $07,
       $07, $07, $07, $07, $07, $07, $07, $07,
       $08, $08, $08, $08, $08, $08, $08, $08,
       $08, $08, $08, $08, $08, $08, $08, $08);
 p_code:array [0..63] of Byte = (
       $00, $20, $30, $40, $50, $58, $60, $68,
       $70, $78, $80, $88, $90, $94, $98, $9C,
       $A0, $A4, $A8, $AC, $B0, $B4, $B8, $BC,
       $C0, $C2, $C4, $C6, $C8, $CA, $CC, $CE,
       $D0, $D2, $D4, $D6, $D8, $DA, $DC, $DE,
       $E0, $E2, $E4, $E6, $E8, $EA, $EC, $EE,
       $F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7,
       $F8, $F9, $FA, $FB, $FC, $FD, $FE, $FF);
 {Таблицы для распаковки}
 d_code:array [0..255] of Byte = (
       $00, $00, $00, $00, $00, $00, $00, $00,
       $00, $00, $00, $00, $00, $00, $00, $00,
       $00, $00, $00, $00, $00, $00, $00, $00,
       $00, $00, $00, $00, $00, $00, $00, $00,
       $01, $01, $01, $01, $01, $01, $01, $01,
       $01, $01, $01, $01, $01, $01, $01, $01,
       $02, $02, $02, $02, $02, $02, $02, $02,
       $02, $02, $02, $02, $02, $02, $02, $02,
       $03, $03, $03, $03, $03, $03, $03, $03,
       $03, $03, $03, $03, $03, $03, $03, $03,
       $04, $04, $04, $04, $04, $04, $04, $04,
       $05, $05, $05, $05, $05, $05, $05, $05,
       $06, $06, $06, $06, $06, $06, $06, $06,
       $07, $07, $07, $07, $07, $07, $07, $07,
       $08, $08, $08, $08, $08, $08, $08, $08,
       $09, $09, $09, $09, $09, $09, $09, $09,
       $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A,
       $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B,
       $0C, $0C, $0C, $0C, $0D, $0D, $0D, $0D,
       $0E, $0E, $0E, $0E, $0F, $0F, $0F, $0F,
       $10, $10, $10, $10, $11, $11, $11, $11,
       $12, $12, $12, $12, $13, $13, $13, $13,
       $14, $14, $14, $14, $15, $15, $15, $15,
       $16, $16, $16, $16, $17, $17, $17, $17,
       $18, $18, $19, $19, $1A, $1A, $1B, $1B,
       $1C, $1C, $1D, $1D, $1E, $1E, $1F, $1F,
       $20, $20, $21, $21, $22, $22, $23, $23,
       $24, $24, $25, $25, $26, $26, $27, $27,
       $28, $28, $29, $29, $2A, $2A, $2B, $2B,
       $2C, $2C, $2D, $2D, $2E, $2E, $2F, $2F,
       $30, $31, $32, $33, $34, $35, $36, $37,
       $38, $39, $3A, $3B, $3C, $3D, $3E, $3F);
 d_len:array [0..255] of Byte = (
       $03, $03, $03, $03, $03, $03, $03, $03,
       $03, $03, $03, $03, $03, $03, $03, $03,
       $03, $03, $03, $03, $03, $03, $03, $03,
       $03, $03, $03, $03, $03, $03, $03, $03,
       $04, $04, $04, $04, $04, $04, $04, $04,
       $04, $04, $04, $04, $04, $04, $04, $04,
       $04, $04, $04, $04, $04, $04, $04, $04,
       $04, $04, $04, $04, $04, $04, $04, $04,
       $04, $04, $04, $04, $04, $04, $04, $04,
       $04, $04, $04, $04, $04, $04, $04, $04,
       $05, $05, $05, $05, $05, $05, $05, $05,
       $05, $05, $05, $05, $05, $05, $05, $05,
       $05, $05, $05, $05, $05, $05, $05, $05,
       $05, $05, $05, $05, $05, $05, $05, $05,
       $05, $05, $05, $05, $05, $05, $05, $05,
       $05, $05, $05, $05, $05, $05, $05, $05,
       $05, $05, $05, $05, $05, $05, $05, $05,
       $05, $05, $05, $05, $05, $05, $05, $05,
       $06, $06, $06, $06, $06, $06, $06, $06,
       $06, $06, $06, $06, $06, $06, $06, $06,
       $06, $06, $06, $06, $06, $06, $06, $06,
       $06, $06, $06, $06, $06, $06, $06, $06,
       $06, $06, $06, $06, $06, $06, $06, $06,
       $06, $06, $06, $06, $06, $06, $06, $06,
       $07, $07, $07, $07, $07, $07, $07, $07,
       $07, $07, $07, $07, $07, $07, $07, $07,
       $07, $07, $07, $07, $07, $07, $07, $07,
       $07, $07, $07, $07, $07, $07, $07, $07,
       $07, $07, $07, $07, $07, $07, $07, $07,
       $07, $07, $07, $07, $07, $07, $07, $07,
       $08, $08, $08, $08, $08, $08, $08, $08,
       $08, $08, $08, $08, $08, $08, $08, $08);
 type
   Bytebuffer = array[0..buffersize] of Byte;
   ByteFile = File of Byte;

   Fileheadertype = record
     Headsize,Headchk: Byte;
     HeadID: packed array[1..5] of Char;
     Packsize,Origsize,Filetime: LongInt;
     Attr: Word;
     FileName: pathstr;
   end;
 var
   crc: Word;
   oFileName: String;
   oFilesize, pFilesize: LongInt;
   ifbf, ofbf, ibf, obf: Integer;                {Счетчики буфера}
   iFilebuf: array [1..Filebufsize] of Byte;     {Файловый буффер}
   ofsize: LongInt;
   NumRead, NumWrite: Word;
   outFileName, inFileName: pathstr;
   crcbuf: array [1..2]of Byte absolute crc;
   fh: Fileheadertype;
   fha: array [1..sizeof(Fileheadertype)] of Byte absolute fh;
   crc_table: array [0..255] of Word;
   text_buf: array[0..N+F-1] of Byte;
   match_position, match_length: Integer;
   lson: array [0..N+1] of Integer;
   rson: array [0..N+1] of Integer;
   eqson: array [0..N+1] of Integer;
   dad: array [0..N+1] of Integer;
   sub_tree: array [0..255] of Integer;
   useleftnode: Boolean;
   inFile: File;
   outFile: File of Byte;
   textsize, codesize, printcount: LongInt;
   freq: array [0..T+1] of Word;
   prnt: array [0..T+N_Char] of Integer;
   son: array [0..T] of Integer;
   getbuf: Word;
   getlen: Byte;
   putbuf: Word;
   putlen: Byte;
   code, len: Word;
   s,s2,aName,fName,fn,sn: String;
   a,e,i: Boolean;


 Function FReadByte: Integer;
 var b: Byte;
 begin
   if ibf >= NumRead then begin
    BlockRead(inFile, iFilebuf, sizeof(iFilebuf), NumRead);
    ibf:=0;
   end;
   Inc(ibf);
   Dec(ofsize);
   FReadByte:=iFilebuf[ibf];
 end;

 Procedure FWriteByte(b: Byte);
 begin
   Write(outFile,b);
 end;

 Procedure FReadlong(var ll: LongInt);
 var lla: array [1..4] of Byte absolute ll;
 begin
   lla[1]:=FReadByte;
   lla[2]:=FReadByte;
   lla[3]:=FReadByte;
   lla[4]:=FReadByte;
 end;

 Procedure FWritelong(ll: LongInt);
 var lla: array [1..4] of Byte absolute ll;
 begin
   FWriteByte(lla[1]);
   FWriteByte(lla[2]);
   FWriteByte(lla[3]);
   FWriteByte(lla[4]);
 end;

 Procedure InitTree;
 var i:Integer;
 begin
   for i := 0 to 255 do sub_tree[i] := NILL;
   for i := 0 to N-1 do dad[i] := NILL;
 end;

 Function  searchtree(r: Integer): Boolean;
 var x,match_value: Word;
     p: Integer;
 begin
     searchtree:=false;
     match_value:=text_buf[r+1]+text_buf[r+2] shl 8;
     p:=sub_tree[text_buf[r]];
     match_position:=NILL;
     while p<>NILL do begin
         match_position:=p;
         x:=text_buf[p+1]+text_buf[p+2] shl 8;
         if match_value=x then begin
             searchtree:=true;
             exit;
         end;
         if x>match_value then begin
             useleftnode:=false;
             p:=rson[p];
         end else begin
             useleftnode:=true;
             p:=lson[p];
         end;
     end;
 end;

 Procedure insertnode(r: Integer);
 var parent :Word;
     p:Word;
     i,curr_position:Integer;
 begin
     if searchtree(r) then
       begin
         eqson[r]:=match_position;
         dad[r]:=dad[match_position];
         dad[match_position]:=r;
         rson[r]:=rson[match_position];
         if rson[r]<>NILL then dad[rson[r]]:=r;
         lson[r]:=lson[match_position];
         if lson[r]<>NILL then dad[lson[r]]:=r;
         p:=dad[r];
         if p=TREENODE then sub_tree[text_buf[r]]:=r
          else if rson[p]=match_position then rson[p]:=r else lson[p]:=r;
         curr_position:=match_position;
         match_length:=0;
         repeat
           i:=3;
           while i<F do begin
             if text_buf[curr_position+i]=text_buf[r+i] then Inc(i)
              else begin
                if i>match_length then begin
                 match_length:=i;
                 match_position:=curr_position;
                end;
                i:=N;
              end;
             if i=F then begin
               match_length:=i;
               match_position:=curr_position;
               exit;
             end;
           end;
           curr_position:=eqson[curr_position];
         until curr_position=NILL;
         exit;
       end;
     parent:=match_position;
     if parent=NILL then
       begin
         sub_tree[text_buf[r]]:=r;
         parent:=TREENODE;
       end
     else
      if useleftnode then lson[parent]:=r else rson[parent]:=r;
     lson[r]:=NILL;
     rson[r]:=NILL;
     eqson[r]:=NILL;
     dad[r]:=parent;
     match_position:=NILL;
     match_length  :=0;
 end;

 Procedure deletenode(p: Integer);
 var q: Integer;
 begin
    if (dad[p]=NILL) then exit;
    if (dad[p]<>TREENODE) and (eqson[dad[p]]=p) then
      begin
        q:=eqson[p];
        eqson[dad[p]]:=q;
        if q<>NILL then dad[q]:=dad[p];
        exit;
      end;
    if rson[p]=NILL then q:=lson[p]
    else if lson[p]=NILL then q:=rson[p]
    else
      begin
        q:=lson[p];
        if rson[q]<>NILL then
          begin
            repeat
              q:=rson[q];
            until  rson[q]=NILL;
            rson[dad[q]]:=lson[q];
            dad[lson[q]]:=dad[q];
            lson[q]:=lson[p];
            dad[lson[p]]:=q;
          end;
        rson[q]:=rson[p];
        dad[rson[p]]:=q;
      end;
    dad[q]:=dad[p];
    if dad[p]<>TREENODE then
      if rson[dad[p]]=p then rson[dad[p]]:=q else lson[dad[p]]:=q
    else
      sub_tree[text_buf[p]]:=q;
    dad[p]:=NILL
 end;

 Function GetBit: Integer;
 var i: Integer;
 begin
  while (getlen <= 8) do
    begin
      i:=FReadByte;
      if (i  < 0) then i := 0;
      getbuf := getbuf or (i shl (8 - getlen));
      getlen := getlen + 8;
    end;
  i := getbuf;
  getbuf := getbuf shl 1;
  Dec(getlen);
  Getbit:= Integer(i < 0);
 end;

 Function GetByte: Integer;
 var i: Word;
 begin
    while (getlen <= 8) do
      begin
        i:=FReadByte;
        if i < 0 then i := 0;
        getbuf := getbuf or (i shl (8 - getlen));
        getlen := getlen + 8;
      end;
    i := getbuf;
    getbuf := getbuf shl 8;
    getlen := getlen - 8;
    GetByte :=i shr 8;
 end;

 Procedure Putcode(l: Integer; c: Word);
 begin
    putbuf := putbuf or (c shr putlen);
    putlen := putlen + l;
    if (putlen  >= 8) then
      begin
        FWriteByte(putbuf shr 8);
        putlen := putlen - 8;
        if (putlen >= 8) then
          begin
            FWriteByte(putbuf);
            Inc(codesize,2);
            putlen := putlen - 8;
            putbuf := c shl (l - putlen);
          end
        else
          begin
            putbuf := putbuf shl 8;
            Inc(codesize);
          end;
      end;
 end;

 Procedure StartHuff;
 var i,j: Integer;
 begin
    for i := 0 to N_Char-1 do
      begin
        freq[i] := 1;
        son[i]  := i + T;
        prnt[i + T] := i;
      end;
    i := 0;
    j := N_Char;
    while (j <= R) do
      begin
        freq[j] := freq[i] + freq[i + 1];
        son[j]  := i;
        prnt[i] := j;
        prnt[i + 1] := j;
        Inc(i,2);
        Inc(j);
      end;
    freq[T] := $ffff;
    prnt[R] := 0;
 end;

 Procedure reconst;
 var  i,j,k: Integer;
      f,l: Word;
 begin
    j := 0;
    for i := 0 to T-1 do
      begin
        if (son[i] >= T) then
          begin
            freq[j] := (freq[i] + 1) div 2;
            son[j] := son[i];
            Inc(j);
          end;
      end;
    i:=0;
    for j:=N_Char to T-1 do
      begin
        k := i + 1;
        f := freq[i] + freq[k];
        freq[j] := freq[i] + freq[k];
        k:=j-1;
        while (f<freq[k]) do Dec(k);
        Inc(k);
        l := (j - k) * 2;
        move(freq[k],freq[k + 1], l);
        freq[k] := f;
        move(son[k], son[k + 1], l);
        son[k] := i;
        Inc(i,2);
      end;
    for i := 0 to T-1 do
      begin
        k := son[i];
        if (k  >= T) then prnt[k]:=i else
          begin
            prnt[k] := i;
            prnt[k + 1] := i;
          end;
      end;
 end;

 Procedure update(c: Integer);
 var  i,j,k,l: Integer;
 begin
  if (freq[R] = MAX_FREQ) then reconst;
    c := prnt[c + T];
    repeat
        Inc(freq[c]);
        k := freq[c];
        l := c+1;
        if (k > freq[l]) then
          begin
            Inc(l);
            while (k > freq[l]) do Inc(l);
            Dec(l);
            freq[c] := freq[l];
            freq[l] := k;
            i := son[c];
            prnt[i] := l;
            if (i < T) then prnt[i + 1] := l;
            j := son[l];
            son[l] := i;
            prnt[j] := c;
            if (j < T) then prnt[j + 1] := c;
            son[c] := j;
            c := l;
          end;
        c := prnt[c];
    until (c = 0);
 end;

 Procedure EncodeChar(c: Word);
 var i: Word;
     j,k: Integer;
 begin
    i := 0;
    j := 0;
    k := prnt[c + T];
    repeat
        i := i shr 1;
        if (k and 1)<>0 then i := i + $8000;
        Inc(j);
        k:=prnt[k];
    until (k = R);
    Putcode(j, i);
    code := i;
    len := j;
    update(c);
 end;

 Procedure EncodePosition(c: Word);
 var  i: Word;
 begin
    i := c shr 6;
    Putcode(p_len[i], Word(p_code[i]) shl 8);
    Putcode(6, (c and $3f) shl 10);
 end;

 Procedure EncodeEnd;
 begin
    if (putlen)<>0 then
      begin
        FWriteByte(putbuf shr 8);
        Inc(codesize);
      end;
 end;

 Function DecodeChar: Integer;
 var c: Word;
 begin
    c := son[R];
    while (c < T) do
      begin
        c := c + GetBit;
        c := son[c];
      end;
    c := c - T;
    update(c);
    DecodeChar:= c;
 end;

 Function DecodePosition: Integer;
 var i,j,c: Word;
 begin
    i := GetByte;
    c := Word(d_code[i]) shl 6;
    j := d_len[i];
    Dec(j,2);
    while (j<>0) do
      begin
        Dec(j);
        i := (i shl 1) + GetBit;
      end;
    Dec(j);
    DecodePosition := c or i and $3f;
 end;

 Procedure Writeinfo;
 const logos: array [0..3] of Char = ('S','h','A','G');
       logop: array [0..3] of Char = ('{','F','P','}');
 var   logosl: LongInt absolute logos;
       logopl: LongInt absolute logop;
       n: Byte;
 begin
  seek(outFile,0);
  FWritelong(logosl);
  FWritelong(logopl);
  FWriteByte(Length(oFileName));
  for n:=1 to Length(oFileName) do FWriteByte(Ord(oFileName[n]));
  FWritelong(oFilesize);
  FWritelong(pFilesize);
 end;

 Procedure loadinfo;
 const logos: array [0..3] of Char = ('S','h','A','G');
       logop: array [0..3] of Char = ('{','F','P','}');
 var   logosl: LongInt absolute logos;
       logopl: LongInt absolute logop;
       n: Byte;
       s: String;
       b: array [0..255] of Byte absolute s;
 begin
  s:='';
  seek(inFile,0);
  FReadlong(logosl);
  FReadlong(logopl);
  b[0]:=FReadByte;
  for n:=1 to b[0] do b[n]:=FReadByte;
  FReadlong(oFilesize);
  FReadlong(pFilesize);
  oFileName:=s;
  textsize:=oFilesize;
 end;

 Procedure Encode;  {Упаковуем}
 var i,c,len,r,s,last_match_length: Integer;
 begin
    textsize := Filesize(inFile);
    oFilesize:= textsize;
    ofsize:=oFilesize;
    Writeinfo;
    if (textsize = 0) then exit;
    seek(inFile,0);
    textsize := 0;
    StartHuff;
    InitTree;
    s := 0;
    r := N - F;
    for i := s to  r-1 do text_buf[i] := 32;
    len:=0;
    while (len < F) and (ofsize <> 0) do
      begin
        c:=FReadByte;
        text_buf[r+len]:=c;
        Inc(len);
      end;
    textsize := len;
    for i := F downto 1 do InsertNode(r - i);
    InsertNode(r);
    repeat
        if (match_length > len) then  match_length := len;
        if (match_length <= THRESHOLD) then
          begin
            match_length := 1;
            EncoDeChar(text_buf[r]);
          end
        else
          begin
            EncoDeChar(255 - THRESHOLD + match_length);
            EncodePosition((r-match_position-1)and (N-1));
          end;
        last_match_length := match_length;
        i:=0;
        if i<last_match_length then
          begin
            while (i<last_match_length) and (ofsize <> 0) do
              begin
                c:=FReadByte;
                DeleteNode(s);
                text_buf[s] := c;
                if (s < F - 1) then
                    text_buf[s + N] := c;
                s := (s + 1) and (N - 1);
                r := (r + 1) and (N - 1);
                InsertNode(r);
                Inc(i);
              end;
          end;
        textsize:=textsize+i;
        if (textsize > printcount) then
          begin
            GotoXY(2,WhereY);
            Write('Adding ',oFileName);
            GotoXY(70,WhereY);
            Write(Trunc(textsize/(oFilesize/100)),' %');
            printcount := printcount + (oFilesize DIV 100 ) + 1;
          end;
        while (i < last_match_length) do
          begin
            Inc(i);
            DeleteNode(s);
            s := (s + 1) and (N - 1);
            r := (r + 1) and (N - 1);
            Dec(len);
            if (len<>0) then InsertNode(r);
          end;
    until (len <= 0);
    EncodeEnd;
    pFilesize:=codesize;
    close(outFile);
    reset(outFile);
    Writeinfo;
    GotoXY(2,WhereY);
    Write('Adding ',oFileName);
    GotoXY(70,WhereY);
    WriteLn('Ok    ');
    WriteLn('Size: ',oFilesize);
    WriteLn('Packed: ',pFilesize);
    WriteLn('Ratio: ',(pFilesize/(oFilesize/100)):3:2,' %');
 end;

 Procedure Decode; {Распаковуем}
 var i,j,k,r,c: Integer;
     count: LongInt;
 begin
    loadinfo;
    if (textsize = 0) then exit;
    StartHuff;
    for i := 0 to N-F-1 do text_buf[i] := 32;
    r := N - F;
    count:=0;
    while (count<textsize) and (ofsize <> 0) do
      begin
        c := DecodeChar;
        if (c < 256) then
          begin
            FWriteByte(c);
            text_buf[r] := c;
            Inc(r);
            r := r and (N - 1);
            count:=count+1;
          end
        else
          begin
            i := (r - DecodePosition - 1) and (N - 1);
            j := c - 255 + THRESHOLD;
            for k := 0 to j-1 do
              begin
                c := text_buf[(i + k) and (N - 1)];
                FWriteByte(c);
                text_buf[r] := c;
                Inc(r);
                r := r and (N - 1);
                Inc(count);
               end;
          end;
        if (count > printcount) then
          begin
            GotoXY(2,WhereY);
            Write('Extracting ',oFileName);
            GotoXY(70,WhereY);
            Write(Trunc(count/(oFilesize/100)),' %');
            printcount := printcount + (oFilesize DIV 100 )+1{1024};
          end;
      end;
  GotoXY(2,WhereY);
  Write('Extracting ',oFileName);
  GotoXY(70,WhereY);
  WriteLn('Ok    ');
 end;

 Procedure ShowFileInfo(fn: String);
 var fs: LongInt;
 begin
  loadinfo;
  fs:=FileSize(inFile);
  WriteLn(' Archiv name: ',fn);
  WriteLn(' ----------------------------------------------------------------');
  GotoXY(2,WhereY);
  Write('File name');
  GotoXY(15,WhereY);
  Write('Original Size');
  GotoXY(35,WhereY);
  Write('Packed Size');
  GotoXY(55,WhereY);
  WriteLn('Ratio');
  WriteLn(' ----------------------------------------------------------------');
  GotoXY(2,WhereY);
  Write(oFileName);
  GotoXY(17,WhereY);
  Write(textsize);
  GotoXY(38,WhereY);
  Write((fs-16-Length(oFileName)-1));
  GotoXY(55,WhereY);
  WriteLn((fs-16-Length(oFileName)-1)/(textsize/100):3:2,' %');
 end;

{============================================================================}
{====                        Основная программа                          ====}
{============================================================================}
 begin
  ibf:=32767;
  obf:=WhereY;
  Window(2,1,79,25);
  GotoXY(1,obf);
  obf:=0;
  ofsize:=0;
  NumWrite:=Filebufsize;
  NumRead:=0;
  textsize:=0;
  codesize:=0;
  printcount:=0;
  getbuf:=0;
  getlen:=0;
  putbuf:=0;
  putlen:=0;
  s:=paramstr(1);
  GotoXY(1,WhereY);
  ClrEOL;
  if s[3] <> 'P' then begin
      obf:=WhereY;
      Window(1,1,80,25);
      GotoXY(1,obf);
      obf:=0;
      TextColor(7);
      Write('ShAG files packer  Version 1.0  Copyright (c) 1999 ShAG Studio      ');
      TextBackGround(0);
      TextColor(15);
      WriteLn('FREEWEARE');
      TextColor(7);
      TextBackGround(0);
  end;
  if (paramcount < 2) or (s[1] <> '/') or (s[2] = '?') or
     (UpCase(s[2]) = 'H') then
    begin
      Writeln('Usage: sfp [options] filename|archivname <filename|path> '); ClrEOL;
      Writeln(' Options          Description'); ClrEOL;
      Writeln('  /?, /h           show this help'); ClrEOL;
      Writeln('  /a               add file to archiv'); ClrEOL;
      Writeln('  /e               extract files from archiv'); ClrEOL;
      Writeln('  /i               show info about archiv'); ClrEOL;
      WriteLn(''); ClrEOL;
      WriteLn('  If you extract files from archiv - third command parametrs - full path where');
      WriteLn(' are SFP creat  files from  archiv. If  path is  empty - SFP creat files where');
      WriteLn(' are   situated  archiv   file.  If  you  want  add  file  to  archiv:  second');
      WriteLn(' parametr  from command line  - name of  original file, third  - name or path');
      WriteLn(' where are SFP mast creat archiv.'); ClrEOL;
      TextColor(15);
      WriteLn('                                               Home page: www.shag.itgo.com');
        Write('                                               E-mail: shag@qnx.com');
      TextColor(7);
      WriteLn('');
      Halt;
    end;
  fn:=paramstr(2);
  sn:=paramstr(3);
  a:=false; e:=false; i:=false;
  CASE UpCase(s[2]) OF
   'A': a:=true;
   'E': e:=true;
   'I': i:=true;
  END;
  if a then begin     {архивируем}
   s2:=fn;
   repeat
    if Pos('\',s2) <> 0 then Delete(s2,1,Pos('\',s2));
   until Pos('\',s2) = 0;
   oFileName:=s2; {имя оригинала}
   s:=fn;
   s2:=sn;     {имя архива}
   repeat
    if Pos('\',s2) <> 0 then Delete(s2,1,Pos('\',s2));
   until Pos('\',s2) = 0;
   if (Pos('.',s2) = 0) and (s2 <> '') then s2:=sn+'.sfp' else
    if (Copy(sn,Pos('.',s2),Length(s2)-Pos('.',s2)) <> '.sfp') and (s2 <> '') then begin
      Delete(sn,Pos('.',sn),Length(sn)-Pos('.',sn)+1);
    s2:=sn+'.sfp';
   end;
   if s2 = '' then
    if Pos('.',s) <> 0 then s2:=sn+Copy(s,1,Pos('.',s)-1)+'.sfp'
                       else s2:=sn+s+'.sfp';
   end else
  if e then begin     {распаковываем}
   s:=fn;
   if (sn[length(sn)] <> '\') and (sn <> '') then sn:=sn+'\';
   assign(inFile,s);
   reset(inFile,1);
   loadinfo;
   close(inFile);
   ibf:=32767;
   s2:=sn+oFileName;
  end else
  if i then begin
   s:=fn;
  end;
  assign(inFile,s);
  {$I-}
  reset(inFile,1);
  {$I+}
  if IOResult <> 0 then begin
   WriteLn('Error: archiv file not found.');
   Halt(0);
  end;
  ofsize:=oFilesize;
  assign(outFile,s2);
  {$I-}
  if not i then reWrite(outFile{,1});
  {$I+}
  if IOResult <> 0 then begin
   WriteLn('Error: Can'#39't creat file ',s2);
   Halt(0);
  end;
  if a then Encode else
  if e then Decode else
  if i then ShowFileInfo(s);
  close(inFile);
  if not i then close(outFile);
 end.
{============================================================================}
{====--------------------------------------------------------------------====}
{====                         ShAG files packer                          ====}
{====                            Version 1.0                             ====}
{====                  Copyright (c) 1999 ShAG Studio                    ====}
{====--------------------------------------------------------------------====}
{============================================================================}