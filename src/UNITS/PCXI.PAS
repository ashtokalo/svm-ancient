{============================================================================}
{====--------------------------------------------------------------------====}
{====                            PCX Interface                           ====}
{====                             Version 1.0                            ====}
{====                   Copyright (c) 2000 ShAG Studio                   ====}
{====--------------------------------------------------------------------====}
{====                             USER MANUAL                            ====}
{====   This unit help you to use PCX images. Unit may load and give you ====}
{==== line by line all PCX image. But if you want use this unit you mast ====}
{==== know  that unit may use 256-color images only. That meen you don't ====}
{==== may load PCX image with 2, 4 or 16 colors.                         ====}
{====   If you want load image you mast do next item:                    ====}
{==== 1. Open image  to load by OpenPCXToLoad with name of loaded image. ====}
{====    For  return you get width,  height, horisontal DPI and vertical ====}
{====    DPI. An  variable Palette_flag  you may  read what colors used. ====}
{====    If is true then PCX has color table else PCX has'n color table. ====}
{====    If color table present you may read it from array Palette256.   ====}
{==== 2. For  read  line  from  PCX  image  you  mast  use  ReadPCXLine. ====}
{====    In variable  fild you mast put variable that used to store line ====}
{====    from image. This variable mast have size width of image or more ====}
{====    then width else  you have problem with you data segment. If you ====}
{====    want skeep  some lines  from image you mast read it but unused. ====}
{====    In variable Line_Number you  may read number  of line that read ====}
{====    next from image. If LineNumber > height of image and you try to ====}
{====    read it ReadPCXLine close PCX file and return code End_of_image ====}
{==== 3. If you want read next image you mast close that image with help ====}
{====    ClosePCX.  If you don't  do that  you can't  open next image to ====}
{====    view because  OpenPCXToLoad return  code of Image_already_open. ====}
{====    If  you load  all lines  from image  this function  was calling ====}
{====    automaticaly.                                                   ====}
{==== 4. If you want setup colors from image you mast use SetPCXPalette. ====}
{====    You  may convert  this table to gray colors by MakeGrayPalette. ====}
{====    If you use  SetPCXPalette next line that  you read set in 0 and ====}
{====    LineNumber set in 0.                                            ====}
{==== 5. If you  want review  image without closing it you mast set true ====}
{====    in ReViewMode before first read and use ReView to set next line ====}
{====    as 0 and set 0 in LineNumber.                                   ====}
{============================================================================}
                                  unit PCXI;
{============================================================================}
                                  interface
{============================================================================}
 {$A+,B-,D-,E-,F+,G+,I+,L-,N-,O+,P+,Q-,R-,S-,T+,V+,X+}
 const { Error constants that return all function from this unit }
       No_errors                = 0;
       File_not_found           = 1;
       Image_not_open           = 2;
       Image_already_open       = 3;
       Wrong_format             = 4;
       End_of_Image             = 5;
       Image_has_not_palette    = 6;
       Read_error               = 7;
       Format_not_support       = 8;

 { Set the color table from current PCX file }
 function  SetPCXPalette: Byte;
 { Before set you may convert in to gray colors by this function }
 function  MakeGrayPalette: Byte;
 { Return information about current PCX file }
 function  GetPCXInfo(name: String; var xs, ys, xdpi, ydpi: Integer): Byte;
 { Open and prepeare PCX file to read or view }
 function  OpenPCXToLoad(name: String): Byte;
 { Close PCX file opening by OpenPCXToLoad }
 function  ClosePCX: Byte;
 { Read one line from PCX file, unpack and put it to pcxlinevar }
 function  ReadPCXLine(var pcxlinevar): Byte;
 { Reset reading line. Next line to read it 0. Set Line_Number to 0 }
 function  ReView: Byte;

 var   PCX_flag, Palette_flag, ReViewMode: Boolean;
       Line_number: Integer;                     { Number of next read line }
       Palette256: array [0..255, 0..2] of byte; { Color table for PCX }

{============================================================================}
                                 implementation
{============================================================================}
 const Compress_num = $C0;      { mask to compress key }
       Max_block = 4096;        { size of buffer to read PCX file }
       Red = 0;
       Green = 1;
       Blue = 2;

 type  TPcx_Header = record     { Header of PCX file                        }
        Manufacturer: byte;     { Always 10 for PCX file                    }
        Version: byte;          { 2 - old PCX - no palette (not used anymore),
                                  3 - no palette,
                                  4 - Microsoft Windows - no palette (only in
                                      old files, new Windows version uses 3),
                                  5 - with palette                          }
        Encoding: byte;         { 1 is PCX, it is possible that we may add
                                  additional encoding methods in the future }
        Bits_per_pixel: byte;   { Number of bits to represent a pixel
                                  (per plane) - 1, 2, 4, or 8               }
        Xmin: integer;          { Image window dimensions (inclusive)       }
        Ymin: integer;          { Xmin, Ymin are usually zero (not always)  }
        Xmax: integer;
        Ymax: integer;
        Hdpi: integer;          { Resolution of image (dots per inch)       }
        Vdpi: integer;          { Set to scanner resolution - 300 is default }
        ColorMap: array [0..15, RED..BLUE] of byte;
                                { RGB palette data (16 colors or less)
                                  256 color palette is appended to end of file }
        Reserved: byte;         { (used to contain video mode)
                                  now it is ignored - just set to zero      }
        Nplanes: byte;          { Number of planes }
        Bytes_per_line_per_plane: integer;   { Number of bytes to allocate
                                               for a scanline plane.
                                               MUST be an an EVEN number!
                                               Do NOT calculate from Xmax-Xmin! }
        PaletteInfo: integer;   { 1 = black & white or color image,
                                  2 = grayscale image - ignored in PB4, PB4+
                                  palette must also be set to shades of gray! }
        HscreenSize: integer;   { added for PC Paintbrush IV Plus ver 1.0,  }
        VscreenSize: integer;   { PC Paintbrush IV ver 1.02 (and later)     }
                                { I know it is tempting to use these fields
                                  to determine what video mode should be used
                                  to display the image - but it is NOT
                                  recommended since the fields will probably
                                  just contain garbage. It is better to have
                                  the user install for the graphics mode he
                                  wants to use...                       }
        Filler: array [74..127] of byte;     { Just set to zeros        }
       end;

 var   BlockFile: file;         { File that used for access to PCX file }
       BlockData: array [0..MAX_BLOCK] of byte; { Read buffer           }
       Header: TPcx_Header;     { Header of loaded PCX file             }
       NextByte: integer;       { Number of next byte to read from file }
       Index: integer;          { Count of bytes to make next line      }
       Data: byte;              { Byte that read from PCX file          }

 procedure ReadVGAPalette;
 var  i: integer;
 begin
  asm
   mov bx, 0
   mov cx, 255
   mov dx, offset Palette256
   mov ax, seg Palette256
   mov es, ax
   mov ax, $1012
   int $10
  end;
  for i:=0 to 255 do begin
    Palette256[i,RED]:=Palette256[i,RED] shl 2;
    Palette256[i,GREEN]:=Palette256[i,GREEN] shl 2;
    Palette256[i,BLUE]:=Palette256[i,BLUE] shl 2;
  end;
  Palette_flag:=false;
 end;

 function Read256Palette: Byte;
 var i: integer;
     b: byte;
 begin
  Read256Palette:=Image_has_not_palette;
  {$I-}
  seek(BlockFile, FileSize (BlockFile) - 769);
  BlockRead(BlockFile, b, 1);
  {$I+}
  if (b <> 12) then exit;
  Read256Palette:=read_error;
  if IOResult <> 0 then exit;
  {$I-}
  BlockRead(BlockFile, Palette256, 3*256);
  seek(BlockFile, 128);
  {$I+}
  if IOResult <> 0 then exit;
  Read256Palette:=no_errors;
  Palette_flag:=true;
 end;

 function ReadHeader: Byte;
 begin
  ReadHeader:=read_error;
  {$I-}
  BlockRead(BlockFile, Header, 128);
  {$I-}
  if IOResult <> 0 then Exit;
  if (Header.Manufacturer <> 10) or (Header.Encoding <> 1) then begin
   close(BlockFile);
   ReadHeader:=Wrong_format;
   Exit;
  end;
  if (Header.Nplanes = 4) and (Header.Bits_per_pixel = 1) then begin
   ReadHeader:=Format_not_support;
   Exit;
  end else
   if (Header.Nplanes = 1) then begin
    if (Header.Bits_per_pixel = 8) then begin
    if Header.Version = 5 then Read256palette else ReadVGApalette;
   end else begin
    ReadHeader:=Format_not_support;
   end;
  end else begin
    ReadHeader:=Wrong_format;
  end;
  Index:=0;
  ReadHeader:=no_errors;
  NextByte:=MAX_BLOCK;
 end;

 function  ReadByte: Byte;
 var  NumBlocksRead: integer;
 begin
  if NextByte = MAX_BLOCK then begin
   {$I-}
   BlockRead(BlockFile, BlockData, MAX_BLOCK, NumBlocksRead);
   {$I+}
   ReadByte:=read_error;
   if IOResult <> 0 then exit;
   ReadByte:=0;
   NextByte:=0;
  end;
  data:=BlockData[NextByte];
  inc(NextByte);
  ReadByte:=no_errors;
 end;

 function  SetPCXPalette: Byte;
 var  i: integer;
 begin
  SetPCXPalette:=Image_not_open;
  if not PCX_flag then exit;
  SetPCXPalette:=Image_has_not_palette;
  if Header.Version <> 5 then exit;
  SetPCXPalette:=No_errors;
  for i:=0 to 255 do begin
   Palette256[i,RED]:=Palette256[i,RED] shr 2;
   Palette256[i,GREEN]:=Palette256[i,GREEN] shr 2;
   Palette256[i,BLUE]:=Palette256[i,BLUE] shr 2;
  end;
  asm
   mov bx, 0
   mov cx, 255
   mov dx, offset Palette256
   mov ax, seg Palette256
   mov es, ax
   mov ax, $1012
   int $10
  end;
 end;

 function  MakeGrayPalette: Byte;
 var  i: integer;
      b: Byte;
 begin
  MakeGrayPalette:=Image_not_open;
  if not PCX_flag then exit;
  for i:=0 to 255 do begin
    b:=Trunc(0.3*Palette256[i,0]+
             0.59*Palette256[i,1]+
             0.11*Palette256[i,2]);
    Palette256[i,0]:=b;
    Palette256[i,1]:=b;
    Palette256[i,2]:=b;
  end;
  MakeGrayPalette:=no_errors;
 end;

 function  GetPCXInfo(name: String; var xs, ys, xdpi, ydpi: Integer): Byte;
 var b: Byte;
 begin
  assign(BlockFile, name);
  {$I-}
  reset(BlockFile, 1);
  {$I+}
  if IOResult <> 0 then begin
   xs:=0;
   ys:=0;
   xdpi:=0;
   ydpi:=0;
   GetPCXInfo:=file_not_found;
   Exit;
  end;
  b:=ReadHeader;
  GetPCXInfo:=b;
  xs:=Header.XMax-Header.XMin;
  ys:=Header.YMax-Header.YMin;
  xdpi:=Header.HDPI;
  ydpi:=Header.VDPI;
  close(BlockFile);
 end;

 function  OpenPCXToLoad(name: String): Byte;
 var b: Byte;
 begin
  assign(BlockFile, name);
  {$I-}
  reset(BlockFile, 1);
  {$I+}
  if IOResult <> 0 then begin
   OpenPCXToLoad:=file_not_found;
   Exit;
  end;
  b:=ReadHeader;
  OpenPCXToLoad:=b;
  PCX_flag:=true;
  Line_number:=0;
 end;

 function  ClosePCX: Byte;
 begin
  ClosePCX:=Image_not_open;
  if not PCX_flag then exit;
  Close(BlockFile);
  PCX_flag:=false;
  ClosePCX:=no_errors;
  Palette_flag:=false;
  Line_number:=0;
 end;

 function  ReadPCXLine(var pcxlinevar): Byte;
 var count: integer;
     bytes_per_line: integer;
     b: Byte;
     PCXline: array [0..1] of Byte absolute pcxlinevar;
 begin
  ReadPCXLine:=Image_not_open;
  if not PCX_flag then exit;
  ReadPCXLine:=End_of_Image;
  if Line_number > (Header.YMax-Header.YMin) then begin
   if not ReViewMode then ClosePCX;
   exit;
  end;
  bytes_per_line:=Header.Bytes_per_line_per_plane*Header.Nplanes;
  if Index <> 0 then FillChar(PCXline[0], Index, data);
  while (Index < bytes_per_line) do begin
   b:=ReadByte;
   ReadPCXLine:=b;
   if b <> 0 then exit;
   if (data and $C0) = compress_num then begin
    count:=data and $3F;
    b:=ReadByte;
    ReadPCXLine:=b;
    if b <> 0 then exit;
    FillChar(PCXline[Index], count, data);
    inc(Index, count);
  end else begin
   PCXline[Index]:=data;
   inc(Index);
  end;
  end;
  Index:=Index-bytes_per_line;
  Line_number:=Line_number+1;
 end;

 function  ReView: Byte;
 begin
  ReView:=Image_not_open;
  if not PCX_flag then exit;
  ReView:=read_error;
  {$I-}
  seek(BlockFile, 128);
  {$I+}
  if IOResult <> 0 then exit;
  Line_Number:=0;
  ReView:=no_errors;
 end;

 begin
  PCX_flag:=false;
  Palette_flag:=false;
  Line_number:=0;
  ReViewMode:=false;
 end.
