{$A+,B+,D+,E-,F+,G+,I-,L+,N+,O+,P+,Q+,R-,S+,T+,V+,X+}
{$M 16384,0,655360}
{============================================================================}
{====       Добавочный модуль к ShAG Graphics Interface Версия 1.0       ====}
{============================================================================}
                                   UNIT AddGr;
{============================================================================}
                                    INTERFACE
{============================================================================}
 USES Graph;
 PROCEDURE Init;
 TYPE PPixtype = PROCEDURE (x,y:Word; c:Byte);
 TYPE GPixtype = FUNCTION  (x,y: Integer):Word;
 VAR PPix: PPixtype;
     GPix: GPixtype;
{============================================================================}
                                  IMPLEMENTATION
{============================================================================}

procedure EgaVgaDriverProc; external;
{$L EGAVGA.OBJ }

 PROCEDURE Init;
 VAR gd,gm,a:Integer;
 BEGIN
  if RegisterBGIdriver(@EGAVGADriverProc) < 0 then
  begin
   Writeln('Error: Can`t initilised graphics interface.');
   Halt(1);
  end;
  gd:=VGA;
  gm:=VGAHi;
  Initgraph(gd,gm,'');
  @PPix:=@PutPixel;
  @GPix:=@GetPixel;
  a:=GraphResult;
 END;
{============================================================================}
 BEGIN
 END.
{============================================================================}