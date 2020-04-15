uses PFT;
var  p: array [0..1024] of Char;
     pc: PChar absolute p;
begin
 repeat
   ReadLn(p);
   WriteLn('>',pc);
   if (pc[0] = 'q') and (pc[1] = #0) then
     WriteLn('  = ',Calculate(pc):10:10);
 until p='q';
end.