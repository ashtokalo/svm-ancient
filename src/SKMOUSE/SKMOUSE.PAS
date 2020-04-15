{$A+,B+,D-,E+,F+,G-,I-,L-,N-,O+,P+,Q-,R-,S-,T+,V+,X+}
{$M $800,0,0}
uses Dos, Crt;
var LastMouseTSR, LastKeyboardTSR, ShowMouseCursor, ShowCursor,
    HideCursor, TempProc: Procedure;
{Video variables}
    VideoMode, VideoPage: Byte;
    SizeX, SizeY:  Word;
{Mouse variables}
    M_X, M_Y, L_X, L_Y: Integer; {}
    MaxX, MaxY, MinX, MinY: Word; {}
    Res_X, Res_Y, MulIndex, StepX, StepY, Counter,
    LeftP, RightP, LeftU, RightU, CountX, CountY, LastCurSim: Word;
    LeftB, RightB, LastLB, LastRB: Byte;
    MouseMove, MouseViewStatus: Boolean;
    LeftChange, RightChange, OriginalDRV: Boolean;
{Keyboard variables}
    Mouse_Status: Byte;
    Left, Right, Up, Down, LU, RU, LD, RD, ZB, PB, Ctrl, NL, Shift: Byte;
    rax, rbx, rcx, rdx,flag, res, rds, rdi, rsi: Word;
    rah, ral: Byte;
{$F+}

procedure KeyboardTSR; interrupt;
var b: Byte;
begin
 b:=Port[$60];
 case b of
   75: Left:=255;
  203: Left:=0;
   77: Right:=255;
  205: Right:=0;
   72: Up:=255;
  200: Up:=0;
   80: Down:=255;
  208: Down:=0;
   71: LU:=255;
  199: LU:=0;
   73: RU:=255;
  201: RU:=0;
   79: LD:=255;
  207: LD:=0;
   81: RD:=255;
  209: RD:=0;
   82: ZB:=255;
  210: ZB:=0;
   83: PB:=255;
  211: PB:=0;
 end;
 inline($9C);
 LastKeyboardTSR;
 b:=Port[$60];
 case b of
   29: Ctrl:=255;
  157: Ctrl:=0;
  254,69: NL:=255;
  197: NL:=0;
 end;
 If ((Mem[0:$417] and 4) = 4) and (NL = 255) then begin
  Mouse_Status:=abs(1-Mouse_Status);
  sound(500);
  delay(50);
  nosound;
  b:=Mem[0:$417];
  if Mouse_Status = 0 then Mem[0:$417]:=b and 16 else Mem[0:$417]:=b or 16;
 end;
 if (Mouse_Status = 1) then begin
  if ((LD = 255) or (LU = 255) or (Left = 255)) then M_X:=M_X-StepX*MulIndex;
  if ((RU = 255) or (LU = 255) or (Up = 255)) then M_Y:=M_Y-StepY*MulIndex;
  if ((RU = 255) or (RD = 255) or (Right = 255)) then M_X:=M_X+StepX*MulIndex;
  if ((LD = 255) or (RD = 255) or (Down = 255)) then M_Y:=M_Y+StepY*MulIndex;
  if M_X >= MaxX then M_X:=MaxX-1;
  if M_X <= MinX then M_X:=MinX+1;
  if M_Y >= MaxY then M_Y:=MaxY-1;
  if M_Y <= MinY then M_Y:=MinY+1;
  CountX:=M_X-CountX;
  CountY:=M_Y-CountY;
  LeftB:=ZB;
  RightB:=PB;
  LeftChange:=False;
  RightChange:=False;
  if LeftB <> LastLB then begin
   if LeftB = 255 then LeftP:=LeftP+1;
   if LeftB = 0 then LeftP:=LeftU+1;
   LastLB:=LeftB;
   LeftChange:=True;
  end;
  if RightB <> LastRB then begin
   if RightB = 255 then RightP:=RightP+1;
   if RightU = 0 then RightU:=RightU+1;
   RightChange:=True;
   LastRB:=RightB;
  end;
  if (LD = 255) or (RU = 255) or (LU = 255) or (RD = 255) or (Left = 255) or
     (Right = 255) or (ZB = 255) or (PB = 255) or (Up = 255) or (Down = 255)
     then begin
   counter:=counter+1;
   if (L_X <> M_X) or (L_Y <> M_Y) then begin
    if MouseViewStatus then ShowMouseCursor;
    L_X:=M_X;
    L_Y:=M_Y;
    MouseMove:=True;
   end else MouseMove:=False;
   if counter > 5 then begin
    MulIndex:=MulIndex+1;
    counter:=0;
    if MulIndex > 32 then MulIndex:=32;
   end;
   repeat
    if KeyPressed then ReadKey;
   until not KeyPressed;
  end else begin
   counter:=0;
   MulIndex:=1;
  end;
 end;
end;

procedure ShowVideoCursor; assembler;
asm
 mov cx, M_X
 mov dx, M_Y
 mov ax, 4
 pushf
 call LastMouseTSR
end;

procedure HideVideoCur; assembler;
asm
 mov ax, 2
 pushf
 call LastMouseTSR
end;

procedure ShowVideoCur; assembler;
asm
 mov ax, 1
 pushf
 call LastMouseTSR
end;


procedure ShowTextCursor;
var w: Word;
    b: array [0..1] of Byte absolute w;
begin
 MemW[$B800:(L_X div 8)*2+(L_Y div 8)*160]:=LastCurSim;
 w:=MemW[$B800:(M_X div 8)*2+(M_Y div 8)*160];
 LastCurSim:=w;
 b[1]:=(not b[1]) and 127;
 MemW[$B800:(M_X div 8)*2+(M_Y div 8)*160]:=w;
end;

procedure HideTextCur;
begin
 MemW[$B800:(M_X div 8)*2+(M_Y div 8)*160]:=LastCurSim;
end;

procedure ShowTextCur;
var w: Word;
    b: array [0..1] of Byte absolute w;
begin
 w:=MemW[$B800:(M_X div 8)*2+(M_Y div 8)*160];
 LastCurSim:=w;
 b[1]:=(not b[1]) and 127;
 MemW[$B800:(M_X div 8)*2+(M_Y div 8)*160]:=w;
end;

procedure FreeProc;
begin
end;

procedure MouseTSR; interrupt;
begin
 asm
  mov ax, [bp+8]
  mov rsi, ax
  mov ax, [bp+6]
  mov rdi, ax
  mov ax, [bp+4]
  mov rds, ax
  mov ax, [bp+2]
  mov res, ax
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
  0:  begin
       asm
        push ax
        mov ah, $F
        int $10
        mov ral, al
        pop ax
       end;
       VideoMode:=ral;
       Res_X:=8; Res_Y:=8;
       case ral of
        0,1                  : begin SizeX:=40*8; SizeY:=25*8;
                                     Res_X:=4; Res_Y:=4;
                                     @ShowMouseCursor:=@ShowTextCursor;
                                     @ShowCursor:=@ShowTextCur;
                                     @HideCursor:=@HideTextCur;
                               end;
        2,3,7                : begin SizeX:=80*8; SizeY:=25*8;
                                     Res_X:=4; Res_Y:=4;
                                     @ShowMouseCursor:=@ShowTextCursor;
                                     @ShowCursor:=@ShowTextCur;
                                     @HideCursor:=@HideTextCur;
                               end;
        4,5,9,$D,$13         : begin SizeX:=320; SizeY:=200;
                                     @ShowMouseCursor:=@ShowVideoCursor;
                                     @ShowCursor:=@ShowVideoCur;
                                     @HideCursor:=@HideVideoCur;
                               end;
        8                    : begin SizeX:=160; SizeY:=200;
                                     @ShowMouseCursor:=@ShowVideoCursor;
                                     @ShowCursor:=@ShowVideoCur;
                                     @HideCursor:=@HideVideoCur;
                               end;
        6,$A,$E              : begin SizeX:=640; SizeY:=200;
                                     @ShowMouseCursor:=@ShowVideoCursor;
                                     @ShowCursor:=@ShowVideoCur;
                                     @HideCursor:=@HideVideoCur;
                               end;
        $F, $10              : begin SizeX:=640; SizeY:=350;
                                     @ShowMouseCursor:=@ShowVideoCursor;
                                     @ShowCursor:=@ShowVideoCur;
                                     @HideCursor:=@HideVideoCur;
                               end;
        $11,$12              : begin SizeX:=640; SizeY:=480;
                                     @ShowMouseCursor:=@ShowVideoCursor;
                                     @ShowCursor:=@ShowVideoCur;
                                     @HideCursor:=@HideVideoCur;
                               end;
        else begin SizeX:=80*8; SizeY:=25*8;
                   @ShowMouseCursor:=@ShowTextCursor;
                   @ShowCursor:=@ShowTextCur;
                   @HideCursor:=@HideTextCur;
             end;
       end;
       VideoPage:=Mem[0:$462];
       rax:=$FFFF;
       rbx:=2;
       MaxX:=SizeX;
       MaxY:=SizeY;
       MinX:=0;
       MinY:=0;
       M_X:=MaxX div 2;
       M_Y:=MaxY div 2;
       L_X:=M_X;
       L_Y:=M_Y;
       MulIndex:=1;
       StepX:=(15 div Res_X)+1;
       StepY:=(15 div Res_Y)+1;
       ShowCursor;
       HideCursor;
       MouseViewStatus:=False;
      end;
  1:  begin
       L_X:=M_X;
       L_Y:=M_Y;
       ShowCursor;
       MouseViewStatus:=True;
      end;
  2:  begin
       HideCursor;
       MouseViewStatus:=False;
      end;
  3:  begin
       rcx:=M_X;
       rdx:=M_Y;
       rbx:=(LeftB and 1) or (RightB and 2);
       flag:=255;
      end;
  4:  begin
       if rcx >= MaxX then rcx:=MaxX-1;
       if rdx >= MaxY then rdx:=MaxY-1;
       if rcx < MinX then rcx:=MinX;
       if rdx < MinY then rdx:=MinY;
       M_X:=rcx;
       M_Y:=rdx;
       ShowMouseCursor;
       L_X:=M_X;
       L_Y:=M_Y;
       flag:=255;
      end;
  5:  begin
       rax:=(LeftB and 1) or (RightB and 2);
       rcx:=M_X;
       rdx:=M_Y;
       case rbx of
        1: rbx:=LeftP;
        2: rbx:=RightP;
        4: rbx:=0;
       end;
       LeftP:=0;
       Right:=0;
       LeftU:=0;
       RightU:=0;
       flag:=255;
      end;
  6:  begin
       rax:=(LeftB and 1) or (RightB and 2);
       rcx:=M_X;
       rdx:=M_Y;
       case rbx of
        1: rbx:=LeftU;
        2: rbx:=RightU;
        4: rbx:=0;
       end;
       LeftP:=0;
       Right:=0;
       LeftU:=0;
       RightU:=0;
       flag:=255;
      end;
  7:  begin
       MinX:=rcx;
       MaxX:=rdx;
      end;
  8:  begin
       MinY:=rcx;
       MaxY:=rdx;
      end;
 $B:  begin
       rcx:=CountX;
       rdx:=CountY;
       flag:=255;
       CountX:=0;
       CountY:=0;
      end;
 $C:  begin
       flag:=255;
      end;
 $F:  begin
       Res_X:=rcx;
       Res_Y:=rdx;
      end;
 $14: begin
       flag:=255;
      end;
 $15: begin
       rbx:=10;
       flag:=255;
      end;
 $1E: begin
       rbx:=VideoPage;
       flag:=255;
      end;
 $1D: begin
       VideoPage:=rbx;
       flag:=255;
      end;
 $FD: begin
       rsi:=Seg(LastMouseTSR);
       rdi:=Seg(LastKeyboardTSR);
       res:=Ofs(LastMouseTSR);
       rdx:=Ofs(LastKeyboardTSR);
       rcx:=0;
       if OriginalDRV then rcx:=1 else rcx:=0;
       rcx:=rcx or 2;
       rcx:=rcx or 4;
       if Mouse_Status = 1 then rcx:=rcx or 128;
       rbx:=(MemW[CSeg-16:2]-CSeg+24)*16;
       flag:=255;
      end;
 $FE: begin
       if (rbx=1) and (rcx=2) and (rdx=3) then begin
        GetIntVec($9,@TempProc);
        if @TempProc = @KeyboardTSR then SetIntVec($9,@LastKeyboardTSR);
        GetIntVec($33,@TempProc);
        if @TempProc = @MouseTSR then SetIntVec($33,@LastMouseTSR);
        asm
         mov ax, cs
         sub ax, 16
         mov es, ax
         mov ah, $49
         int $21
        end;
       end;
       flag:=255;
      end;
 $FF: begin
       rax:=0;
       rbx:=1;
       rcx:=2;
       rdx:=3;
       flag:=255;
      end;
 end;
 asm
  mov ax, rax
  mov bx, rbx
  mov cx, rcx
  mov dx, rdx
  cmp flag, 0
  jne @no_call
  pushf
  call LastMouseTSR
  @no_call:
  mov [bp+16],ax
  mov [bp+14],bx
  mov [bp+12],cx
  mov [bp+10],dx
  mov ax, rsi
  mov [bp+8], ax
  mov rdi, ax
  mov [bp+6], ax
  mov ax, rds
  mov [bp+4], ax
  mov ax, res
  mov [bp+2], ax
 end;
 flag:=0;
end;

{$F-}

function UpString(s: String): String;
var n: Byte;
begin
 for n:=1 to Length(s) do s[n]:=UpCase(s[n]);
 UpString:=s;
end;

function  HexB(b: Byte): String;
const HD: array [0..15] of Char = ('0','1','2','3','4','5','6','7','8','9',
                                   'A','B','C','D','E','F');
begin
 HexB:=HD[b shr 4]+HD[b and $F];
end;

function  HexW(w: Word): String;
begin
 HexW:=HexB(Hi(w))+HexB(Lo(w));
end;

begin
  WriteLn('ShAG Keyboard Mouse Driver  Version 1.0  Copyright (c) 1999 ShAG Studio');
  if (ParamStr(1) = '/?') or (UpString(ParamStr(1)) = '/H') then begin
   WriteLn('Usage: skmouse.exe [options]');
   WriteLn('Options:');
   WriteLn('  /? /H    - show this help screen');
   WriteLn('  /RELEASE - remove SKMouse from memory and restore old interrupts');
   WriteLn('  /INFO    - show info about installed SKMouse driver');
   Halt(0);
  end;
  asm
   mov ax, $FF
   int $33
   mov rax, ax
   mov rbx, bx
   mov rcx, cx
   mov rdx, dx
  end;
  if (UpString(ParamStr(1)) = '/RELEASE') and (rax=0)
     and (rbx=1) and (rcx=2) and (rdx=3) then begin
   asm
    mov ax, $FE
    mov bx, 1
    mov cx, 2
    mov dx, 3
    int $33
   end;
   WriteLn('SKMouse driver - was removed from memory without erros.');
   Halt(0);
  end;
  asm
   mov ax, 0
   int $33
   mov rax, ax
   cmp ax, $FFFF
   jne @no
   mov ax, 2
   int $33
   @no:
  end;
  Write('Detect mouse driver - ');
  if rax = $FFFF then WriteLn('present') else WriteLn('absent');
  if rax = $FFFF then OriginalDRV:=True else OriginalDRV:=False;
  asm
   mov ax, $FF
   int $33
   mov rax, ax
   mov rbx, bx
   mov rcx, cx
   mov rdx, dx
   mov rcx, cx
   mov rbx, bx
  end;
  Write('Detect SKMouse driver - ');
  if (rax=0) and (rbx=1) and (rcx=2) and (rdx=3) then begin
   WriteLn('already installed.');
   IF UpString(ParamStr(1)) = '/INFO' then begin
    asm
     mov ax, $FD
     int $33
     mov ax, si
     mov rsi, ax
     mov ax, di
     mov rdi, ax
     mov ax, es
     mov res, ax
     mov rdx, dx
     mov rcx, cx
     mov rbx, bx
    end;
    WriteLn('This information recived from main mouse driver:');
    WriteLn(' Last pointer for mouse interrupt:    ',HexW(res),':',HexW(rsi));
    WriteLn(' Last pointer for keyboard interrupt: ',HexW(rdx),':',HexW(res));
    Write(' Total mouse drivers: ');
    if rcx and 1 = 1 then WriteLn('unknown mouse driver and SKMouse') else
    WriteLn('SKMouse only');
    if rcx and 1 = 0 then WriteLn(' Graphics mode not support.') else
    WriteLn(' SKMouse use unknown mouse driver to show cursor in graphics mode.');
    Write(' Left button:         ');
    if rcx and 2 = 2 then WriteLn('present') else WriteLn('absent');
    Write(' Right button:        ');
    if rcx and 4 = 4 then WriteLn('present') else WriteLn('absent');
    Write(' Middle button:       ');
    if rcx and 8 = 8 then WriteLn('present') else WriteLn('absent');
    Write(' Mouse driver mode:   ');
    if rcx and 128 = 128 then WriteLn('active') else WriteLn('pasive');
    WriteLn(' Size in memory:      ',rbx,' bytes');
   end;
   Halt(0);
  end else writeLn('no driver in memory');
  GetIntVec($9,@LastKeyboardTSR);
  GetIntVec($33,@LastMouseTSR);
  SetIntVec($9,@KeyboardTSR);
  SetIntVec($33,@MouseTSR);
  Mouse_Status:=0;
  MaxX:=80*8;
  MaxY:=25*8;
  MinX:=0;
  MinY:=0;
  M_X:=MaxX div 2;
  M_Y:=MaxY div 2;
  LeftB:=0;
  RightB:=0;
  Res_X:=8;
  Res_Y:=8;
  SizeX:=80*8;
  SizeY:=25*8;
  VideoMode:=0;
  MulIndex:=1;
  StepX:=(15 div Res_X)+1;
  StepY:=(15 div Res_Y)+1;
  Counter:=0;
  LeftP:=0;
  RightP:=0;
  LeftU:=0;
  RightU:=0;
  CountX:=0;
  CountY:=0;
  @ShowMouseCursor:=@FreeProc;
  @ShowCursor:=@FreeProc;
  @HideCursor:=@FreeProc;
  WriteLn('Parameters of installed keyboard mouse driver:');
  WriteLn(' Total button: ',2);
  WriteLn(' Left  button - Insert key');
  WriteLn(' Right button - Delete key');
  WriteLn(' For move mouse use arrow key');
  WriteLn(' For activate(diactivate) mouse - Ctrl+NumLock');
  VideoPage:=Mem[0:$462];
  Keep(0);
end.