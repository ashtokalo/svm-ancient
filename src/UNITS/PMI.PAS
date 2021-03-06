 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                            Pascal Mouse Interface
                                 Version 1.0
                       Copyright (c) 2000 Lex Software
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   ���  ����� ᮤ�ন�  ������� ����室���  ��� ࠡ��� � ���ன�⢮� ⨯�
  ����. �������  �������� ������� ���ଠ�� � ���ﭨ� ���, �� �⤥����
  ��ࠬ��஢ � ������ ��.

                                                 �⮪��� ����ᥩ �����������
                                                 5.03.2000

  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

 unit PMI;

 interface

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                               ���� ⨯� ������
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 type
     {----------------------------------
      ���          ��窠
      ----------------------------------}
     PPoint = ^TPoint;
     TPoint = record
       X, Y       : Integer;
     end;

     {----------------------------------
      ���          ��אַ㣮�쭨�
      ----------------------------------}
     PRect = ^TRect;
     TRect = record
       A, B       : TPoint;
     end;

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  ����⠭��
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 const

  {----------------------------------
    ������ ���
   ----------------------------------}
     mbNo         = $00;
     mbLeft       = $01;
     mbRight      = $02;
     mbCenter     = $04;

  {----------------------------------
    ���⢨⥫쭮��� ���
   ----------------------------------}
     msNormal     = $08;
     msQuick      = $04;
     msSlow       = $10;


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                ��६����
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

 var
      CursorStatus : Boolean;
      MHor, MVer,
      MaxButtons,
      MButton      : Integer;
      MPos         : TPoint;
      MouseWindow  : TRect;

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  �㭪樨
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
  function  GetMouseX: Integer;
  function  GetMouseY: Integer;
  function  InitPMI: Boolean;
  function  MouseClick(but: Word): Boolean;
  function  MouseIn(R: TRect): Boolean;

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  ��楤���
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
  procedure GetMouseStatus;
  procedure HideCursor;
  procedure MoveMouse(x, y: Integer);
  procedure SetMouseStep(Hor, Ver: Integer);
  procedure SetMouseWindow(R: TRect);
  procedure ShowCursor;

 implementation

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  �㭪樨
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    �����頥� ��ਧ��⠫���
    ���न���� ���
   ----------------------------------}
  function  GetMouseX: Integer; assembler;
  asm
    mov  ax, 3
    int  $33
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    mov  MButton, bx
    mov  ax, cx
  end;

  {----------------------------------
    �����頥� ���⨪�����
    ���न���� ���
   ----------------------------------}
  function  GetMouseY: Integer; assembler;
  asm
    mov  ax, 3
    int  $33
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    mov  MButton, bx
    mov  ax, dx
  end;

  {----------------------------------
    �����頥� True �᫨ �ࠩ��� �
    ���� ���������� � ࠡ�祬
    ���ﭨ�
   ----------------------------------}
  function  InitPMI: Boolean; assembler;
  asm
    xor  ax, ax
    int  $33
    mov  CursorStatus, 0
    cmp  ax, 0
    je   @no_driver
    mov  MaxButtons, bx
    inc  al
    jmp  @driver
  @no_driver:
    mov  MaxButtons, 0
  @driver:
  end;

  {----------------------------------
    �����頥� True �᫨ ������
    ᮮ⢥�����騥 ������
   ----------------------------------}
  function  MouseClick(but: Word): Boolean; assembler;
  asm
    mov  ax, 3
    int  $33
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    mov  MButton, bx
    xor  al, al
    cmp  bx, but
    jl   @no
    inc  al
  @no:
  end;

  {----------------------------------
    �����頥� True �᫨ ����
    ��室���� � ��אַ㣮�쭨�� R
   ----------------------------------}
  function  MouseIn(R: TRect): Boolean; assembler;
  asm
    mov  ax, 3
    int  $33
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    mov  MButton, bx
    xor  al, al
    cmp  cx, word ptr R[0]
    jl   @no
    cmp  cx, word ptr R[2]
    jg   @no
    cmp  dx, word ptr R[1]
    jl   @no
    cmp  dx, word ptr R[3]
    jg   @no
    inc  al
  @no:
  end;


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  ��楤���
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    �����頥� � ��������
    ��६���� ���न���� � ���ﭨ�
    ������ ���
   ----------------------------------}
  procedure GetMouseStatus; assembler;
  asm
    mov  ax, 3
    int  $33
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    mov  MButton, bx
  end;

  {----------------------------------
    ������ ����� ��� ��������
   ----------------------------------}
  procedure HideCursor; assembler;
  asm
    mov  CursorStatus, 0
    mov  ax, 2
    int  $33
  end;

  {----------------------------------
    ��६�頥� ����� ��� � ��������
    ���
   ----------------------------------}
  procedure MoveMouse(x, y: Integer); assembler;
  asm
    mov  ax, 4
    mov  cx, x
    mov  dx, y
    mov  word ptr MPos.X, cx
    mov  word ptr MPos.Y, dx
    int  $33
  end;

  {----------------------------------
    ��⠭�������� ���⢨⥫쭮���
    ���
   ----------------------------------}
  procedure SetMouseStep(Hor, Ver: Integer); assembler;
  asm
    mov  ax, $0F
    mov  cx, Hor
    mov  dx, Ver
    mov  MHor, cx
    mov  MVer, dx
    int  $33
  end;

  {----------------------------------
    ������ ����㯭�� ��� ࠡ���
    ������� ��࠭�
   ----------------------------------}
  procedure SetMouseWindow(R: TRect);
  begin
    if (R.A.X > R.B.X) or (R.A.Y > R.B.Y) then
      Exit;
    MouseWindow:=R;
    asm
      mov  ax, 7
      mov  cx, word ptr R[0]
      mov  dx, word ptr R[2]
      int  $33
      mov  ax, 8
      mov  cx, word ptr R[1]
      mov  dx, word ptr R[3]
      int  $33
    end;
  end;

  {----------------------------------
    ������ ����� ��� ������
   ----------------------------------}
  procedure  ShowCursor; assembler;
  asm
   mov  CursorStatus, 1
   mov  ax, 1
   int  $33
  end;


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                         ��砫쭠� ���樠������ ������
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
begin
  MPos.X:=0;
  MPos.Y:=0;
  MouseWindow.A.X:=0;  MouseWindow.A.Y:=0;
  MouseWindow.B.X:=0;  MouseWindow.B.Y:=0;
  MButton:=mbNo;
  MHor:=msNormal;
  MVer:=msNormal;
end.