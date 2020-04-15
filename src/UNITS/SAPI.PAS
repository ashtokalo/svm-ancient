 unit SAPI;

 interface

 uses UGDI, Mouse, SCrt;

 type PPoint = ^TPoint;
      TPoint = record
      x, y: Integer;
 end;

 type PRect = ^TRect;
      TRect = record
      a, b: TPoint;
 end;

 type PCanvas = ^TCanvas;
      TCanvas = object
       prev, next               : PCanvas;
       StartPos, Size, LMP      : TPoint;
       ControlString            : String[4];
       ObjectNumber             : LongInt;
       exitmode, selection, mousepres, lastmouse,
       viewmode, drawmode       : Boolean;
       constructor Init(rec: TRect; sel, vm: Boolean; p, n: PCanvas);
       destructor  Done;
       procedure   Run;
       procedure   Select(m: Boolean);
       procedure   Visable(m: Boolean);
       procedure   DrawIt(m: Boolean);
       procedure   Update;
       procedure   MoveTo(p: TPoint);
       procedure   Shift(p: TPoint);
       procedure   ReDraw(rec: TRect);
       function    GetObject(l: LongInt): PCanvas;
       function    IsObject(p: PCanvas): Boolean;

       procedure   Draw;                                   virtual;
       procedure   MousePressed(p: TPoint; but: Byte);     virtual;
       procedure   KeyPressed(k: Word);                    virtual;
       procedure   MouseUnPressed(p: TPoint);              virtual;
       procedure   MouseMove(p: TPoint);                   virtual;
       procedure   MousePressedMove(p: TPoint; but: Byte); virtual;
       procedure   DoneThisObject;                         virtual;
      end;

 implementation

 function    GetMouseCoor: PPoint;
 var p: TPoint;
 begin
  p.x:=MouseX;
  p.y:=MouseY;
  GetMouseCoor^:=p;
 end;

 function    BMousePressed(b: Word): Boolean;
 begin
  if (MouseButton and b) = b then BMousePressed:=true
                             else BMousePressed:=false;
 end;

 function    PointInRec(p: TPoint; r:TRect): Boolean;
 begin
  if (p.x in [r.a.x..r.b.x]) and (p.y in [r.a.y..r.b.y])
   then PointInRec:=true
   else PointInRec:=false;
 end;

 function    GetMin(a, b: Integer): Integer;
 begin
  if a > b then GetMin:=b else GetMin:=a;
 end;

 function    GetMax(a, b: Integer): Integer;
 begin
  if a < b then GetMax:=b else GetMax:=a;
 end;

 function    RecAndRec(a, b: TRect): PRect;
 var r: TRect;
 begin
  r.a.x:=GetMax(a.a.x,b.a.x);
  r.a.y:=GetMax(a.a.y,b.a.y);
  r.b.x:=GetMin(a.b.x,b.b.x);
  r.b.y:=GetMin(a.b.y,b.b.y);
  RecAndRec^:=r;
 end;

 function    IsRec(rec: TRect): Boolean;
 begin
  IsRec:=false;
  if ((rec.b.x-rec.a.x) < 0) or ((rec.b.y-rec.a.y) < 0) then Exit;
  IsRec:=true;
 end;

 constructor TCanvas.Init(rec: TRect; sel, vm: Boolean; p, n: PCanvas);
 begin
  StartPos:=rec.A;
  Size.X:=rec.B.X-rec.A.X;
  Size.Y:=rec.B.Y-rec.A.Y;
  ControlString:='ShAG';
  if IsObject(p) then prev:=p;
  next:=nil;
  if prev <> nil then ObjectNumber:=prev^.ObjectNumber+1 else ObjectNumber:=1;
  if prev <> nil then prev^.next:=n;
  Selection:=sel;
  ViewMode:=vm;
  ExitMode:=False;
  DrawMode:=True;
  MousePres:=False;
  LastMouse:=False;
 end;
 destructor  TCanvas.Done;
 begin
  if IsObject(next) then begin
   if IsObject(prev) then begin
    prev^.next:=next;
    next^.prev:=prev;
   end else next^.prev:=nil;
  end else prev^.next:=nil;
  ControlString:='';
  ObjectNumber:=1;
  DoneThisObject;
  next:=nil;
  prev:=nil;
  Selection:=false;
  ViewMode:=false;
  ExitMode:=false;
 end;
 procedure   TCanvas.Run;
 var k: Word;
     kp: Boolean;
     p: TPoint;
     r: TRect;
 begin
  if not ViewMode then exit;
  GetMouseMode(MouseX, MouseY, MouseButton);
  r.A:=StartPos;
  r.B.X:=r.A.X+Size.X;
  r.B.Y:=r.A.Y+Size.Y;
  p:=GetMouseCoor^;
  kp:=SCrt.KeyPressed;
  if kp then k:=Ord(ReadKey);
  if kp then begin
   if k = 0 then k:=Word(Ord(ReadKey)) or Word(255 shl 8);
   if k > 255 then PutKey(Chr(0));
   PutKey(Chr(k and 255));
  end;
  if BMousePressed(LeftButton or RightButton) and PointInRec(p,r)
     and not MousePres then MousePres:=True;
  if not BMousePressed(LeftButton or RightButton) and MousePres
     then MousePres:=False;
  if PointInRec(p,r) and not BMousePressed(LeftButton or RightButton)
     and (LMP.x <> p.x) and (LMP.y <> p.y) then MouseMove(p) else
  if PointInRec(p,r) and MousePres and not LastMouse
     then MousePressed(p,MouseButton) else
  if PointInRec(p,r) and MousePres and (LMP.x <> p.x) and (LMP.y <> p.y)
     then MousePressedMove(p,MouseButton) else
  if PointInRec(p,r) and not MousePres and LastMouse
     then MouseUnPressed(p) else
  if Selection and KP
     then KeyPressed(k);
  LastMouse:=MousePres;
  LMP:=p;
 end;
 procedure   TCanvas.Select(m: Boolean);
 begin
  if not ViewMode then exit;
  Selection:=m;
  Update;
 end;
 procedure   TCanvas.Visable(m: Boolean);
 begin
  ViewMode:=m;
  Update;
 end;
 procedure   TCanvas.DrawIt(m: Boolean);
 begin
  DrawMode:=m;
  if not m then Visable(m);
  Update;
 end;
 procedure   TCanvas.Update;
 var r: TRect;
 begin
  r.A:=StartPos;
  r.B.X:=r.A.X+Size.X;
  r.B.Y:=r.A.Y+Size.Y;
  ReDraw(r);
 end;
 procedure   TCanvas.MoveTo(p: TPoint);
 begin
  StartPos:=p;
  Update;
 end;
 procedure   TCanvas.Shift(p: TPoint);
 begin
  StartPos.X:=StartPos.X+p.x;
  StartPos.Y:=StartPos.Y+p.y;
  Update;
 end;
 procedure   TCanvas.ReDraw(rec: TRect);
 var r: TRect;
 begin
  r.A:=StartPos;
  r.B.X:=r.A.X+Size.X;
  r.B.Y:=r.A.Y+Size.Y;
  r:=RecAndRec(r,rec)^;
  if not IsRec(r) then Exit;
  SetWindow(r.a.x,r.a.y,r.b.x,r.b.y);
  Draw;
 end;
 function    TCanvas.GetObject(l: LongInt): PCanvas;
 var p: PCanvas;
 begin
  GetObject:=nil;
  if l = ObjectNumber then exit;
  if l < ObjectNumber then begin
   p:=prev;
   while IsObject(p) do
    if p^.ObjectNumber = l then break
                          else p:=p^.prev;
   if p^.ObjectNumber = l then GetObject:=p;
  end else begin
   p:=next;
   while IsObject(p) do
    if p^.ObjectNumber = l then break
                          else p:=p^.next;
   if p^.ObjectNumber = l then GetObject:=p;
  end;
 end;
 function    TCanvas.IsObject(p: PCanvas): Boolean;
 begin
  IsObject:=false;
  if (p^.ControlString <> 'ShAG') or (p^.ObjectNumber = 0) or
     (p^.ObjectNumber = ObjectNumber) then exit;
  IsObject:=true;
 end;

 procedure   TCanvas.Draw;
 begin
 end;
 procedure   TCanvas.MousePressed(p: TPoint; but: Byte);
 begin
 end;
 procedure   TCanvas.KeyPressed(k: Word);
 begin
 end;
 procedure   TCanvas.MouseUnPressed(p: TPoint);
 begin
 end;
 procedure   TCanvas.MouseMove(p: TPoint);
 begin
 end;
 procedure   TCanvas.MousePressedMove(p: TPoint; but: Byte);
 begin
 end;
 procedure   TCanvas.DoneThisObject;
 begin
 end;

begin
end.