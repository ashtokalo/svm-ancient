 uses   PMI, Crt;
 var    Key       : Byte;
        LPos      : TPoint;
 begin
   repeat
     if KeyPressed then
       Key:=Ord(ReadKey);

     GetMouseStatus;
     if LPos <> MPos then

   until
 end.