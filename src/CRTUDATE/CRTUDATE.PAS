 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                Update for CRT
                                 Version 1.0
                    Copyright (c) 2000 by Alexey Shtokalo
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

     Данная программа исправляет ошибки допущенные в модуле CRT компилятора
   Turbo Pascal 7.0. Подробности смотрите при запуске программы.

                                                 Штокало Алексей Геннадиевич
                                                 13.05.2000

  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

{$A+,B+,D-,E-,F+,G+,I+,L-,N+,O+,P+,Q-,R-,S+,T+,V+,X+,Y+}
{$M 16384,0,0}

const   BufSize = 16384;
        SD1: array [0..7] of Byte = ($F7, $D0, $F7, $D2, $B9, $37, $00, $F7);
        SD2: array [0..7] of Byte = ($8B, $DC, $36, $8B, $4F, $04, $E3, $13);
        SD3: array [0..7] of Byte = ($E8, $05, $00, $E2, $F6, $CA, $02, $00);
        UD1: array [0..7] of Byte = ($F7, $D0, $F7, $D2, $B9, $B8, $01, $F7);
        UD2: array [0..7] of Byte = ($58, $5A, $59, $52, $50, $C1, $E1, $03);
        UD3: array [0..7] of Byte = ($E8, $05, $00, $E2, $F6, $CB, $41, $53);

var     f: File;
        Buffer: array [0..BufSize-1] of Byte;

function  FindData(var f: File; var SData; DataSize: Word): Boolean;
var       Data: array [0..1] of Byte absolute SData;
          n, Size, DataByte: Word;
          FirstData, ThisBlock: LongInt;
          FindIt: Boolean;
begin
  DataByte:=0;
  FindIt:=False;
  while not eof(f) and not FindIt do
  begin
    ThisBlock:=FilePos(f);
    BlockRead(f, Buffer, BufSize, Size);
    for n:=0 to Size-1 do
      if Data[DataByte] = Buffer[n] then
      begin
        if (DataByte = 0) and (Size-n < DataSize) then
        begin
          Seek(f, ThisBlock+n);
          DataByte:=0;
          FirstData:=0;
          Break;
        end;
        if DataByte = 0 then
          FirstData:=ThisBlock+n;
        if DataByte < DataSize-1 then
          Inc(DataByte)
        else
          begin
            Seek(f, FirstData);
            FindIt:=True;
            Break;
          end;
      end else
        begin
          DataByte:=0;
          FirstData:=0;
        end;
  end;
  FindData:=FindIt;
end;

function  MakeCopy(name: String): Byte;
var       FromF, ToF : File;
          i, NumRead, NumWritten : Word;
begin
  MakeCopy:=1;
  Assign(FromF, name);
  {$I-}
  Reset(FromF, 1);
  {$I+}
  if IOResult <> 0 then
    Exit;
  MakeCopy:=2;
  if Pos('.', name) = 0 then
    name:=name+'.bak'
  else
    name:=Copy(name, 1, Pos('.', name)) + 'bak';
  Assign(ToF, name);
  {$I-}
  ReWrite(ToF, 1);
  {$I+}
  if IOResult <> 0 then
  begin
    Close(FromF);
    Exit;
  end;
  MakeCopy:=3;
  repeat
    {$I-}
    BlockRead(FromF, Buffer, SizeOf(Buffer), NumRead);
    BlockWrite(ToF, Buffer, NumRead, NumWritten);
    {$I+}
    i:=IOResult;
  until (NumRead = 0) or (NumWritten <> NumRead) or (i <> 0);
  Close(FromF);
  Close(ToF);
  if i <> 0 then
    Exit;
  MakeCopy:=0;
end;

procedure ShowHelp;
begin
  WriteLn('usage: crtudate.exe filename');
  WriteLn('       filename - name of file with program code (*.EXE, *.TPU, *.TPL)');
  WriteLn('Описание ошибки и результата работы этой программы:');
  WriteLn(' В  модуле Crt  при начальной  инициализации  программисты  из  Borland');
  WriteLn(' International   пытались  получить   число  которое  бы   можно   было');
  WriteLn(' использовать как  счетчик в  пустом цикле,  так чтобы  такой цикл  был');
  WriteLn(' эквивалентом одной милексекунде.  Но не учли всех  нюансов  инструкции');
  WriteLn(' DIV, которая при выполнении деления,  в случае, когда результат больше');
  WriteLn(' чем регистр,  в котором  он должен быть  сохранен,  генерирует  ошибку');
  WriteLn(' деления  на   ноль  через  прерывание  0.   На  высокопроизводительных');
  WriteLn(' процессорах  число  в  промежуточных  вычислениях  получается  больше,');
  WriteLn(' чем  3604480,  поэтому при  попытки деления  получается очень  большой');
  WriteLn(' результат и как следствие - ошибка деления на ноль.');
  WriteLn(' Учитывая то, что Borland''овцы  умеют писать  эффективный и оптимальный');
  WriteLn(' код, все  что я смог сделать  это немного переписать  процедуру Delay.');
  WriteLn(' В результате устранения  ошибке (учитывая возможности 16-битного кода)');
  WriteLn(' процедура Delay стала немного ограниченой. Если быть точным, то теперь');
  WriteLn(' максимальный  аргумент  у  этой процедуры  не должен  превышать  8190,');
  WriteLn(' вместо старых 65535. Если аргумент превышает указанное число, задержка');
  WriteLn(' становится  неопределенной  (конечно это  можно определить,  но только');
  WriteLn(' проведа небольшие вычисления).');
  Halt;
end;

begin
  WriteLn(#13, #10, 'Update for Crt (Turbo Pascal 7.0)    Copyright (c) 2000 Alexey Shtokalo');
  if (ParamStr(1) = '/?') or (ParamStr(1) = '/h') or (ParamStr(1) = '/H') or
  (ParamStr(1) = '') then
    ShowHelp;

  Write('Make the copy of ', ParamStr(1));
  case MakeCopy(ParamStr(1)) of
    0: WriteLn;
    1: begin
         WriteLn;
         WriteLn('Error: File not found (', ParamStr(1),')');
         Halt(1);
       end;
    2: WriteLn(' can''t creat copy.');
    3: WriteLn(' can''t read/write data.');
  end;

  Assign(f, ParamStr(1));
  Reset(f, 1);

  if FindData(f, UD3, SizeOf(UD3)) then
  begin
    Close(f);
    WriteLn('This file already updated by this program.');
    Halt;
  end;
  Seek(f, 0);

  if FindData(f, SD1, SizeOf(SD1)) then
  begin
    Seek(f, 0);
    if FindData(f, SD2, SizeOf(SD2)) then
    begin
      Seek(f, 0);
      if FindData(f, SD3, SizeOf(SD3)) then
        BlockWrite(f, UD3, SizeOf(UD3))
      else
        begin
          WriteLn('Nothing to update.');
          Close(f);
          Halt(2);
        end;
      Seek(f, 0);
      FindData(f, SD2, SizeOf(SD2));
      BlockWrite(f, UD2, SizeOf(UD2))
    end else
      begin
        WriteLn('Nothing to update.');
        Close(f);
        Halt(2);
      end;
    Seek(f, 0);
    FindData(f, SD1, SizeOf(SD1));
    BlockWrite(f, UD1, SizeOf(UD1))
  end else
    begin
      WriteLn('Nothing to update.');
      Close(f);
      Halt(2);
    end;

  Close(f);
  WriteLn(ParamStr(1), ' successful updated.');
end.