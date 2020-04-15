uses PGL, Crt;
var  i: PImage;
     n: LongInt;
begin
 InitPGL;
 PushStyles;
 SetViewWindow(AssignRect(10, 150, 265, 250));
 for n:=0 to 255 do begin
  SetColor(RGB2Color(n, n, n));
  DrawLine(n, 0, n, 100);
  end;
 PopStyles;
 SetColor(clLightRed);
 DrawRect(9, 149, 256+10, 251);
 n:=GetImageSize(AssignRect(5, 150, 270, 250));
 GetImage(AssignRect(5, 150, 270, 250), i);
 SetColor(clBlack);
 FillRect(0, 0, GetMaxX, GetMaxY);
 PutImage(100, 100, i);
 PutImage(150, 250, i);
 DisposeImage(i);
end.