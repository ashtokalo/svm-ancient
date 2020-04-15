{============================================================================}
{====--------------------------------------------------------------------====}
{====                          Aplication Object                         ====}
{====                            Version  1.0                            ====}
{====                    Copyright (c) 2000 ShAG Studio                  ====}
{====--------------------------------------------------------------------====}
{==== This unit content one object and some procedures and functions for ====}
{==== work with mouse, keyboard and time.                                ====}
{==== To use this unit you mast have Turbo Pascal 7.0 or leter.          ====}
{============================================================================}
                                 unit APIObj;
{============================================================================}
                                  interface
{============================================================================}
 {$A+,B+,D+,E+,F+,G+,I+,L+,N-,O+,P+,Q-,R-,S+,T+,V+,X+}

 type PPoint = ^TPoint;                 { This type content two fild:    }
      TPoint = record                   { x, y - it used as coordinates  }
      x, y: Integer;                    { for some procedures            }
 end;

 type PRect = ^TRect;                   { This type content two fild:    }
      TRect = record                    { a, b - it uses to define left  }
      a, b: TPoint;                     { up coner and right down coner  }
 end;

 const LeftButton  = 1;                 { This constants define the code }
       RightButton = 2;                 { to left and rigth mouse button }
       On          = True;              { On as True                     }
       Off         = False;             { Off as False                   }

 { This object have some methotds to rule some components. It may used   }
 { for made any objects to graphics mode. Object have methods for        }
 { access to any objects that make by him and used it as owner.          }
 type PCanvas = ^TCanvas;
      TCanvas = object
       Prev,                           { The next and previous object    }
       Next          : PCanvas;        { that used to access to him      }
       StartPos,                       { The left top coner of object    }
       Size,                           { The widht and height of object  }
       LMP           : TPoint;         { The last mouse position         }
       DrawWindow    : TRect;          { The part of screen that may     }
                                       { used to draw object's elements  }
       ControlString : String[4];      { This string always equaly       }
                                       { 'ShAG' and used to test memory  }
                                       { an some objects                 }
       ObjectNumber,                   { This number need for control    }
                                       { access to objects               }
       InfoTime,                       { This variable show how qickly   }
                                       { Help mast showed (1 - 55 msc)   }
       LastTime      : LongInt;        { This variables content a time   }
                                       { when mouse stoped an object     }
       LastPir,                        { Use as buffer for mouse move    }
       LKP,                            { Use as keyboard buffer          }
       TabKey,                         { If TabKey true then you may use }
                                       { Tab key to select next object   }
       Selection,                      { If object selected this value   }
                                       { is true else it false           }
       MousePres,                      { If mouse pressed now then this  }
                                       { value is true else it false     }
       LastMouse,                      { Last mouse pressed mode         }
       ViewMode,                       { If view mode is true then       }
                                       { object a worked else it sleep   }
       DrawMode,                       { If draw mode is true then       }
                                       { object may draw himeself else   }
                                       { it can't do it                  }
       InfoView,                       { If InfoView is true then help   }
                                       { showing at this time            }
       InfV           : Boolean;       { Last help view status           }

       { Init mast call to initialisate object and here environmetn.     }
       { For call you mast give him a next value:                        }
       {  rec - the position of left top coner for this object           }
       {  sel - this value set to Selection                              }
       {  vm  - this value set to ViewMode                               }
       {  p   - this value mast point to previouse object of this type   }
       {  n   - this value mast point to himself (object)                }
       constructor Init(rec: TRect; sel, vm: Boolean; p, n: PCanvas);

       { Done mast call before closing this object. It restore the       }
       { conection and destroy all value. Before destroyed it call       }
       { virtual mathod DoneThisObject.                                  }
       destructor  Done;

       { Run mast call always. It test mouse, keyboard, time and call    }
       { some method to execute}
       procedure   Run;

       { Select change Selection to m and call Update method             }
       procedure   Select(m: Boolean);

       { Visable change ViewMode to m and call Update method             }
       procedure   Visable(m: Boolean);

       { Update method call ReDraw methods fot object's size.            }
       procedure   Update;

       { MoveTo change StartPos to p and call Update method              }
       procedure   MoveTo(p: TPoint);

       { Shift add to StartPos numbers from p and call Update method     }
       procedure   Shift(p: TPoint);

       { ReDraw test drawin zone to true and if zone no empty it set     }
       { drawing zone to DrawWindow and call virtual Draw method         }
       procedure   ReDraw(rec: TRect);

       { GetObject try to find object with number l and if finding it    }
       { return pointer to this object                                   }
       function    GetObject(l: LongInt): PCanvas;

       { GetSelect try to find object that select at this time}
       function    GetSelect: PCanvas;

       { IsObject test pointer to object (of this type) fild as          }
       { ControlString if it no empty method return True else False      }
       function    IsObject(p: PCanvas): Boolean;

       { This methods you mast change to your methods.                   }
       { Draw was called when object mast draw himself. When it draw     }
       { you mast set drawing window from DrawWindow.                    }
       procedure   Draw;                                   virtual;

       { MousePressed was called one time when mouse was pushed some     }
       { buttons. P content mouse position, but content mouse button.    }
       procedure   MousePressed(p: TPoint; but: Byte);     virtual;

       { KeyboardPressed was called when object selected and pushed      }
       { some keys. if k > 255 then pressed special key and you mast     }
       { make k:=k and 255 to get key code else k content normal code.   }
       procedure   KeyboardPressed(k: Word);               virtual;

       { KeyboardUnPressed was called until keypressed after read key    }
       procedure   KeyboardUnPressed;                      virtual;

       { MouseUnPressed was called when some mouse button unpushed. P    }
       { content mouse position.                                         }
       procedure   MouseUnPressed(p: TPoint);              virtual;

       { MouseMove was called when mouse in object and moved to it       }
       procedure   MouseMove(p: TPoint);                   virtual;

       { MousePressedMove was called when some mouse button was pushed   }
       { and mouse moved to object.                                      }
       procedure   MousePressedMove(p: TPoint; but: Byte); virtual;

       { DonwThisObject was called when you call Done methods. This      }
       { methods mast close all sources that object used.                }
       procedure   DoneThisObject;                         virtual;

       { ShowInfo was called when mouse stay some time on this object.   }
       { P content mouse position. If m true you mast draw help else     }
       { you mast restore screen under help message.                     }
       procedure   ShowInfo(p: TPoint; m: Boolean);        virtual;

       { RunElse was called when no any procedures                       }
       procedure   RunElse;                                virtual;

      end;

 { This function run for initialisate mouse driver to select screen mode }
 function  InitMouse: Boolean;

 { This procedure made mouse visable                                     }
 procedure ShowMouse;

 { This procedure made mouse invisable                                   }
 procedure HideMouse;

 { This procedure rereturn mouse position and mouse button               }
 procedure GetMouseMode(var x, y: Word; b: Byte);

 { This procedure move mouse to new position                             }
 procedure MoveMouse(x, y: Word);

 { This procedure set window that mouse may use for moved                }
 procedure SetMouseWindow(x, y, x1, y1: Word);

 { This function return a true when pushed some key                      }
 function  KeyPressed: Boolean;

 { This function return pushed key                                       }
 function  ReadKey: Char;

 { This procedure send to keyboard some key as pushed                    }
 procedure PutKey(c: Char);

 { This procedure wait (t*55/1000) seconds                               }
 procedure Delay(t: LongInt);

 { This function return true if point p in rectangle r                   }
 function  PointInRect(p: TPoint; r:TRect): Boolean;

 { This function return min value from a and b                           }
 function  GetMin(a, b: Integer): Integer;

 { This function return max value from a and b                           }
 function  GetMax(a, b: Integer): Integer;

 { This function return rectangle position from (a and b)                }
 procedure  RectAndRect(a, b: TRect; var r: TRect);

 { This function return true if rectangle not empty                      }
 function  IsRect(rec: TRect): Boolean;

 var   MouseStatus,                     { True if mouse present          }
       MouseViewMode: Boolean;          { True if mouse visable          }
       MouseButton: Byte;               { Mouse button code              }
       MouseX, MouseY: Word;            { Mouse position                 }

{============================================================================}
                                implementation
{============================================================================}

 function  InitMouse: Boolean; assembler;
 asm
  mov ax, 0
  int $33
  cmp ax, $FFFF
  je  @ok
  mov al, 0
  mov MouseStatus, 0
  mov MouseButton, 0
  mov MouseViewMode, 0
  jmp @exit
  @ok:
  mov al, 1
  mov MouseStatus, 1
  mov MouseViewMode, 0
  mov MouseButton, bl
  @exit:
 end;

 procedure ShowMouse; assembler;
 asm
  mov al, MouseStatus
  cmp al, 1
  jne @exit
  mov al, MouseViewMode
  cmp al, 1
  je  @exit
  mov ax, 1
  int $33
  mov MouseViewMode, 1
  @exit:
 end;

 procedure HideMouse; assembler;
 asm
  mov al, MouseStatus
  cmp al, 1
  jne @exit
  mov al, MouseViewMode
  cmp al, 0
  je  @exit
  mov ax, 2
  int $33
  mov MouseViewMode, 0
  @exit:
 end;

 procedure GetMouseMode(var x, y: Word; b: Byte);
 var x1, y1, b1: Word;
 begin
  asm
   mov x1, 0
   mov y1, 0
   mov b1, 0
   mov al, MouseStatus
   cmp al, 1
   jne @exit
   mov ax, 3
   int $33
   mov x1, cx
   mov y1, dx
   mov b1, bx
   @exit:
  end;
  x:=x1;
  y:=y1;
  b:=b1;
  MouseX:=x;
  MouseY:=y;
  MouseButton:=b1;
 end;

 procedure MoveMouse(x, y: Word); assembler;
 asm
  mov al, MouseStatus
  cmp al, 1
  jne @exit
  mov cx, x
  mov dx, y
  mov ax, 4
  int $33
  @exit:
 end;

 procedure SetMouseWindow(x, y, x1, y1: Word); assembler;
 asm
  mov al, MouseStatus
  cmp al, 1
  jne @exit
  mov cx, x
  mov dx, x1
  mov ax, 7
  int $33
  mov cx, y
  mov dx, y1
  mov ax, 8
  int $33
  @exit:
 end;

 function KeyPressed: Boolean; assembler;
 asm
   mov ah, 1
   int $16
   jnz @pressed
   xor al, al
   jmp @ex
  @pressed:
   mov al, 1
  @ex:
 end;

 procedure PutKey(c: Char); assembler;
 asm
  mov ah, 5
  mov cl, c
  xor ch, ch
  int $16
 end;

 function ReadKey: Char; assembler;
 asm
  xor ah,ah
  int 16h
 end;

 procedure Delay(t: LongInt);
 begin
  Inc(t,MemL[0:$046c]);
  while MemL[0:$046c] < t do;
 end;

 function  PointInRect(p: TPoint; r:TRect): Boolean;
 begin
  if (p.x >= r.a.x) and (p.x <= r.b.x) and
     (p.y >= r.a.y) and (p.y <= r.b.y)
   then PointInRect:=true
   else PointInRect:=false;
 end;

 function  GetMin(a, b: Integer): Integer;
 begin
  if a > b then GetMin:=b else GetMin:=a;
 end;

 function  GetMax(a, b: Integer): Integer;
 begin
  if a < b then GetMax:=b else GetMax:=a;
 end;

 procedure  RectAndRect(a, b: TRect; var r: TRect);
 begin
  r.a.x:=GetMax(a.a.x,b.a.x);
  r.a.y:=GetMax(a.a.y,b.a.y);
  r.b.x:=GetMin(a.b.x,b.b.x);
  r.b.y:=GetMin(a.b.y,b.b.y);
 end;

 function  IsRect(rec: TRect): Boolean;
 begin
  IsRect:=false;
  if ((rec.b.x-rec.a.x) < 0) or ((rec.b.y-rec.a.y) < 0) then Exit;
  IsRect:=true;
 end;

 function    BMousePressed(b: Word): Boolean;
 begin
  if (MouseButton and b) = b then BMousePressed:=true
                             else BMousePressed:=false;
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
  DrawMode:=True;
  MousePres:=False;
  LastMouse:=False;
  LastTime:=0;
  InfoTime:=100;
  InfV:=false;
  InfoView:=false;
  TabKey:=True;
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
 end;

 procedure   TCanvas.Run;
 var k: Word;
     kp,pir: Boolean;
     p: TPoint;
     r: TRect;
     c: PCanvas;
 begin
  if not ViewMode or not DrawMode then exit;
  GetMouseMode(MouseX, MouseY, MouseButton);
  r.A:=StartPos;
  r.B.X:=r.A.X+Size.X;
  r.B.Y:=r.A.Y+Size.Y;
  p.x:=MouseX;
  p.y:=MouseY;
  kp:=KeyPressed;
  if kp then k:=Ord(ReadKey);
  if kp then begin
   if k = 0 then k:=Word(Ord(ReadKey)) or Word(255 shl 8);
  end;
  if TabKey and kp and (k = 9) and Selection then begin
   c:=next;
   kp:=False;
   if not IsObject(c) then c:=GetObject(1);
   if (c^.ObjectNumber <> ObjectNumber) and IsObject(c) then begin
    Select(Off);
    c^.Select(on);
   end;
  end;
  pir:=PointInRect(p,r);
  if (BMousePressed(LeftButton) or BMousePressed(RightButton)) and pir
     and not MousePres then MousePres:=True;
  if not (BMousePressed(LeftButton) or BMousePressed(RightButton))
     and MousePres then MousePres:=False;
  if MousePres and not Selection then begin
      c:=GetSelect;
      if IsObject(c) then c^.Select(off);
      Select(on);
     end;
  if pir and not MousePres
     and ((LMP.x <> p.x) or (LMP.y <> p.y)) then MouseMove(p) else
  if pir and MousePres and not LastMouse
     then MousePressed(p,MouseButton) else
  if pir and (BMousePressed(LeftButton) or BMousePressed(RightButton))
     and (LMP.x <> p.x) and (LMP.y <> p.y)
     then MousePressedMove(p,MouseButton) else
  if (not MousePres and LastMouse) or (not pir and lastpir)
     then MouseUnPressed(p) else
  if Selection and not KP and LKP
     then KeyboardUnPressed;
  if Selection and KP
     then KeyboardPressed(k) else begin
      if KP then begin
       if k > 255 then PutKey(Chr(0));
       PutKey(Chr(k and 255));
      end;
      RunElse;
     end;
  if (LMP.x <> p.x) and (LMP.y <> p.y) and pir then begin
   LastTime:=MemL[0:$046c];
   InfV:=false;
  end;
  if (MemL[0:$046c]-LastTime >= InfoTime) and not InfoView and pir then begin
   InfoView:=true;
   InfV:=true;
   ShowInfo(p,on);
  end;
  if InfV <> InfoView then begin
   InfoView:=false;
   ShowInfo(p,off);
  end;
  LastMouse:=MousePres;
  LastPir:=pir;
  LMP:=p;
  LKP:=KP;
 end;

 procedure   TCanvas.Select(m: Boolean);
 var c: PCanvas;
 begin
  if (not ViewMode or not DrawMode) and m then begin
   c:=next;
   if not IsObject(c) then c:=GetObject(1);
   if (c^.ObjectNumber <> ObjectNumber) and IsObject(c) then begin
    Select(Off);
    c^.Select(on);
   end;
   exit;
  end;
  Selection:=m;
  Update;
 end;

 procedure   TCanvas.Visable(m: Boolean);
 begin
  if not DrawMode then exit;
  ViewMode:=m;
  Update;
 end;

 procedure   TCanvas.Update;
 var r: TRect;
 begin
  if not DrawMode then exit;
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
  if not DrawMode then exit;
  r.A:=StartPos;
  r.B.X:=r.A.X+Size.X;
  r.B.Y:=r.A.Y+Size.Y;
  RectAndRect(r,rec,r);
  if not IsRect(r) then Exit;
  DrawWindow:=r;
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

 function    TCanvas.GetSelect: PCanvas;
 var p: PCanvas;
 begin
  GetSelect:=nil;
  p:=prev;
  while (p <> nil) and not p^.Selection do p:=p^.prev;
  if p^.Selection and (p <> nil) then begin
   GetSelect:=p;
   exit;
  end;
  p:=next;
  while (p <> nil) and not p^.Selection do p:=p^.next;
  if p^.Selection and (p <> nil) then begin
   GetSelect:=p;
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

 procedure   TCanvas.KeyboardPressed(k: Word);
 begin
 end;

 procedure   TCanvas.KeyboardUnPressed;
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

 procedure   TCanvas.ShowInfo(p: TPoint; m: Boolean);
 begin
 end;

 procedure   TCanvas.RunElse;
 begin
 end;

{============================================================================}
begin
 MouseStatus:=False;                   { Set's default value             }
 MouseViewMode:=False;
 MouseButton:=0;
end.
{============================================================================}