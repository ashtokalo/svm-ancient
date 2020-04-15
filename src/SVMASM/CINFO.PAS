{$L cpuid.obj}
{$M 1024, 0, 655360}
function  GetCPUType: Byte; EXTERNAL;

 procedure DetectMem(var m,e: Word);
 var b: Byte;
     k, j: Word;
 begin
  if Mem[$F000:$FFFE]=$FC then begin
   Port[$70]:=$15;
   m:=Port[$71];
   Port[$70]:=$16;
   m:=m+Port[$71] shl 8;
   Port[$70]:=$17;
   e:=Port[$71];
   Port[$70]:=$18;
   e:=e+Port[$71] shl 8;
  end else begin
   e:=0;
   m:=0;
   for k:=1 to 9 do begin
    j:= k shl 12;
    if Mem[j:0] <> 233 then inc(m)
    else begin
     Mem[j:0]:=0;
     if Mem[j:0] = 0 then begin
      inc(m);
      Mem[j:0]:=233;
     end;
    end;
   end;
   m:=m*64;
  end;
 end;

function DetectSpeed(fracu: Byte): LongInt;
var time,k: LongInt;
    j: Integer;
begin
 k:=0;
 for j:=1 to fracu do begin
  time:=MemL[0:$046c];
  while MemL[0:$046c]=Time do;
  inc(Time,2);
  while MemL[0:$046c]<>Time do inc(k);
 end;
 DetectSpeed:=Trunc(k/fracu);
end;

function TestTrass: Boolean; assembler;
asm
   mov al, 0
   mov byte ptr @, $90
@: ret
   mov al, 1
end;

const logo: array [0..3] of Char = ('S','h','A','G');
      qualyte = 10;
      wonp = 9000;

var t: Real;
    n: LongInt;
    w1, w2: Word;
    l: LongInt absolute logo;
    DOSM, EXTM, FreeM, CPUType: Word;

begin
 WriteLn('');
 if ParamStr(1) <> '/NI' then
  WriteLn('CInfo  Version 1.0  Copyright (c) 1999 ShAG Studio');

 CPUType:=GetCPUType;
 DetectMem(DOSM, EXTM);
 FreeM:=Word(MemAvail div 1024)+25;

 MemL[0:$4f0]:=l;
 MemW[0:$4f0+4]:=DOSM;
 MemW[0:$4f0+6]:=EXTM;
 MemW[0:$4f0+8]:=FreeM;
 MemW[0:$4f0+10]:=CPUType;

 if ParamStr(1) = '/NI' then begin
  Halt(0);
 end;
   Write('Processor type:  ');
 CASE CPUType OF
  0: WriteLn('Intel 80x86');
  2: WriteLn('Intel 80x286');
  3: WriteLn('Intel 80x386');
  4: WriteLn('Intel 80x486');
  5: WriteLn('Intel Pentium');
  else WriteLn('Intel Pentium');
 END;
 t:=(DetectSpeed(qualyte)/wonp);
 WriteLn('Power:           ',t:0:2,' items (1 item - Intel 80x286 16 Mhz)');
 Write('Date of BIOS version (mm/dd/yy): ');
 for n:=0 to 7 do Write(chr(Mem[$F000:$FFF5+n]));
 WriteLn('');
 WriteLn('DOS memory:      ',DOSM,' Kb');
 WriteLn('Extended memory: ',EXTM,' Kb');
 WriteLn('Free memory:     ',FreeM,' Kb');
end.
