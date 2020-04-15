{$A+,B+,D+,E-,F+,G+,I+,L+,N+,O+,P+,Q-,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
type tpoint = array [0..16] of Byte;
var str1, str2, str3: String;
    f: File;
    p: ^tpoint;
    fs, n, n1: LongInt;
begin
 WriteLn('EXE to UDF Convertor  Version 1.0  Copyright (c) 2000 ShAG Studio');
 str1:=ParamStr(1);
 str2:=ParamStr(2);
 if str1 = '' then begin
  WriteLn('usage: EXE2UDF driver.exe [driver.udf]');
  WriteLn('       driver.exe - name of EXE file that contant compilled UDF driver.');
  WriteLn('       driver.udf - name of creating UDF driver. If it exist then name');
  WriteLn('                    making as name of EXE file with extension UDF.');
  Halt(0);
 end;
 if str2 = '' then str2:=str1;
 if Pos('.',str1) = 0 then str1:=str1+'.exe';
 if Pos('.',str2) <> 0 then str2:=copy(str2,1,Pos('.',str2))+'udf'
                       else str2:=str2+'.udf';
 assign(f,str1);
 {$I-}
 reset(f,1);
 {$I+}
 if IOResult <> 0 then begin
  WriteLn('Error: can'#39't find '+str1+' file.');
  Halt(0);
 end;
 fs:=FileSize(f);
 if fs > 65520 then begin
  WriteLn('Error: file to big.');
  close(f);
  Halt(0);
 end;
 if fs < 500 then begin
  WriteLn('Error: file to small.');
  close(f);
  Halt(0);
 end;
 if MemAvail < fs then begin
  WriteLn('Error: not enother memory.');
  close(f);
  Halt(0);
 end;
 GetMem(p,fs);
 BlockRead(f,p^,fs);
 Close(f);
 WriteLn('Scaning '+str1+' ...');
 str3:='';
 if (p^[0] = Ord('M')) and (p^[1] = Ord('Z')) then
  for n:=0 to fs-Length('Universal Driver Format') do begin
   str3:='';
   if (fs-n) < 1024  then break;
   for n1:=n to n+Length('Universal Driver Format')-1 do str3:=str3+Chr(p^[n1]);
   if str3 = 'Universal Driver Format' then break;
  end;
 if str3 <> 'Universal Driver Format' then begin
  FreeMem(p, fs);
  WriteLn('Error: '+str1+' - is not a UDF driver.');
  Halt(0);
 end;
 assign(f,str2);
 {$I-}
 rewrite(f,1);
 {$I+}
 if IOResult <> 0 then begin
  FreeMem(p, fs);
  WriteLn('Error: can'#39't creat '+str2);
  Halt(0);
 end;
 BlockWrite(f,p^[n],fs-n);
 FreeMem(p, fs);
 Close(f);
 fs:=fs-n;
 WriteLn(str1+' convert to '+str2);
end.