uses binpasu,svm_n,sgi,sfi{,arial};
var x,y:Word;
    f:File OF Byte;
    c:array [0..767] OF Byte ABSOLUTE ColorTable;
    r,g,b,rr,gg,bb,gray: Integer;
    text: TFont;
    col: TColor;
const dv: real = 255/40;
begin
 initbpu;
 x:=MAxAvail;
 r:=sizeOf(text);
 initsvm(1,2,1,'c','test.swp');
 x:=MAxAvail;
 initgi(2);
 InitFI(14);
{ RegisterFontRAM(Arial_File,SizeOf(Arial_File),text);}
 RegisterFontFile('c:\svm\fonts\Arial.chr',text);
 SetFontSize(48,text);
 FOR y:=0 TO MaxY DO BEGIN
  Col.Red:=0;
  Col.Green:=0;
  Col.Blue:=Trunc(255/MaxY*(MaxY-y));
  SetColor(Col);
  for x:=0 to MaxX do putpixel(x,y);
 END;
 Text.Color:=Black;
 Text.Italic:=Italic;
 Text.Bold:=Bold;
 DrawString(20,20,'The demonstration of',text);
 DrawString(120,60,'dithering technology.',text);
 Text.Color:=White;
 Text.Italic:=Italic;
 Text.Bold:=Bold;
 DrawString(10,10,'The demonstration of',text);
 DrawString(110,50,'dithering technology.',text);
 SetFontSize(22,text);
 Col.Red:=0;
 Col.Green:=192;
 col.Blue:=192;
 Text.Color:=Col;
 Text.Italic:=NoItalic;
 DrawString(20,375,'Screen created by ShAG Graphics Interface (SGI)',text);
 DrawString(20,405,'All messages writing by Arial Cyrilic CHR Vector Font',text);
 DrawString(20,435,'Copyright (C) 1999 ShAG Studio',text);
 LineStyle.Size:=2;
 FillStyle.Color:=Black;
 MaxX:=MaxX-180;
 FillRect(10+(MaxX-240) DIV 2-2,10+(MaxY - 240) DIV 2 - 2,10+(MaxX-240) DIV 2 + 244,10+(MaxY - 240) DIV 2 + 244);
 Rect((MaxX-240) DIV 2-1,(MaxY - 240) DIV 2 - 1,(MaxX-240) DIV 2 + 242, (MaxY - 240) DIV 2 + 242);
 FillRect(10+(MaxX-240) DIV 2-2+344,10+(MaxY - 240) DIV 2 - 2,10+(MaxX-240) DIV 2 + 394,10+(MaxY - 240) DIV 2 + 244);
 Rect((MaxX-240) DIV 2-1 +344,(MaxY - 240) DIV 2 - 1,(MaxX-240) DIV 2 + 394, (MaxY - 240) DIV 2 + 242);
 FOR x:=0 TO 240 DO BEGIN
  IF x < 41 THEN BEGIN r:=255; b:=0; g:=trunc(dv*x); END;
  IF (x > 40) AND (x < 81) THEN BEGIN r:=trunc(dv*(80-x)); g:=255; b:=0; END;
  IF (x > 80) AND (x < 121) THEN BEGIN b:=trunc(dv*(x-80)); g:=255; r:=0; END;
  IF (x > 120) AND (x < 161) THEN BEGIN g:=trunc(dv*(160-x)); b:=255; r:=0; END;
  IF (x > 160) AND (x < 201) THEN BEGIN r:=trunc(dv*(x-160)); b:=255; g:=0; END;
  IF (x > 200) AND (x < 241) THEN BEGIN r:=255; g:=0; b:=trunc(dv*(240-x)); END;
  for y:=0 to 240 do BEGIN
   IF x < 49 THEN BEGIN
    gray:=Trunc(255/240*y);
    Col.Red:=gray;
    Col.Blue:=gray;
    Col.Green:=gray;
    setcolor(col);
    PutPixel((MaxX-240) DIV 2 + x+1 + 344, (MaxY - 240) DIV 2+y+1);
   END;
   Col.Red:=Trunc(r*(240-y)/240);
   Col.Blue:=Trunc(b*(240-y)/240);
   Col.Green:=Trunc(g*(240-y)/240);
   setcolor(col);
   putpixel((MaxX-240) DIV 2 + x+1, (MaxY - 240) DIV 2+y+1);
  END;
 END;

 readln;
end.