 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                           Pascal Dinamic Variables
                                 Version 1.0
                       Copyright (c) 2000 ShAG Studio
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   ���  ����� ᮤ�ন� �������  ����� ������� ��� ࠡ��� � �������᪮�
  �������. �᭮���� ����� ����� - ᮧ�����, �ᯮ�짮�����, ����஫�஢����
  � 㤠����� �������᪨� ��६�����.
   �������᪠�  ��६����� - �� ���� ����� ��।������� ������ன TVar,
  ����� � ���ன �ந�室��  ��� � ��몭�������� 㪠��⥫� �� ���� �����
  � ���.
   �������᪨� ��६���� ⠪ ���஥��, �� ��������� ᮧ������ ���������
  ���ᨢ�.
   ��࠭�祭�� ������ ���ᨨ:  ࠧ��� ������୮�� ���ᨢ�,  ����� ����
  ᠬ����⥫쭮� �������᪮� ��६����� ��� �室�騩 � ��������� ���ᨢ,
  ��  ������  �ॢ���� 65520  ����  - ᫥��⢨��  �ᯮ�짮�����  ��楤�� �
  �㭪権 Pascal'� ��� ࠡ��� � ��祩.
   ���  �����祭�� ࠧ��饭��  ��६����� �  ��� �� ����� �६���� 㤠����
  ��६�����  �� ��� �  䠩�, � ��⥬  ���⠭����� �� � ��⭮ (�᫨ 墠��
  �����).
  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

  {$A+,B+,D+,E-,F+,G+,I+,L+,N+,O+,P+,Q-,R-,S+,T+,V+,X+}

  unit PDV;

  interface

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                               ���� ⨯� ������
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    �⠭����� ⨯� ������. �� ����
    �ᯮ�짮���� ��� ��८�।������
    ⨯� ������ � ���.

    ���ਬ��:
     var   v: TVar;
           s: String;
           b: Byte;
     ...
       s:=TString(v^.Data^.Data^)[0];
       b:=TByte(v^.Data^.Data^)[0];
         (*   b = Length(s)  *)

   ----------------------------------}
  type    TByte      = array [0..65519] of Byte;
  type    TChar      = array [0..65519] of Char;
  type    TWord      = array [0..32759] of Word;
  type    TInteger   = array [0..32759] of Integer;
  type    TLongInt   = array [0..16379] of LongInt;
  type    TReal      = array [0..10919] of Real;
  type    TString    = array [0..254] of String;

  {----------------------------------
    ��� ⨯ �ᯮ������ ���
    ��।������ ����� ��६�����.
   ----------------------------------}
  type    PName = ^TName;
          TName = String[80];

  {----------------------------------
    ��吝� ᯨ᮪ ���������
    ���ᨢ��
   ----------------------------------}
  type    PData = ^TData;
          TData = record
            Next: PData;                { �����⥫� �� ᫥���騩 ���ᨢ     }
            Size: Word;                 { ������ ���ᨢ�                    }
            Data: Pointer;              { �����⥫� �� ����� ���ᨢ�       }
          end;

  {----------------------------------
    ��吝� ᯨ᮪ �������᪨�
    ��६�����
   ----------------------------------}
  type    PVar = ^TVar;
          TVar = record
            Next: PVar;                 { �����⥫� �� ᫥������ ��६����� }
            Name: TName;                { ��� ��६�����                    }
            Size: Word;                 { ������ ������ ������� (⨯)      }
            Data: PData;                { �����⥫� �� ����� ��६�����    }
          end;


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  ����⠭��
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  const   erNo       = 0;               { ��� �訡��                        }
          erNoMem    = -1;              { ��墠⠥� �����                  }
          erNoData   = -2;              { ��� ������                        }
          erNoVar    = -3;              { ��� ��६�����                    }
          erNoSize   = -4;              { ���ࠢ���� ࠧ���               }
          erNoName   = -5;              { ��� �����                         }
          erBadName  = -6;              { ���ࠢ��쭮� ��� (�㡫������)    }
          erNotFind  = -7;              { �� ������� ����� ��� ��६�����  }
          erNoFile   = -8;              { �� ������ 䠩�                    }

          PDVHead    = 'Pascal Dinamic Variables';


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                ��६����
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  var     dvError,                      { ��� �訡��                        }
          MaxVar   : LongInt;           { ������⢮ ��६�����             }
          Variables: PVar;              { ��६����                        }


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  �㭪樨
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  function   GetData(d: PData; i: Byte): PData;
  function   GetVar(i: LongInt): PVar;
  function   FindVar(Name: TName): LongInt;
  function   LoadVar(n: String; name: TName): LongInt;
  function   NewData(Size: Word; Next: PData): PData;
  function   NewVar(Name: TName; Size: Word; Data: PData): LongInt;


 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  ��楤���
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  procedure  DisposeVar(i: LongInt);
  procedure  DoneDV;
  procedure  FreeData(d: PData);
  procedure  SaveVar(i: LongInt; s: String);





  implementation

 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  �㭪樨
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    �㭪�� �ࠢ����� ���� ��ப
    ⨯� PChar
   ----------------------------------}
  function StrComp(Str1, Str2: PChar): Integer; assembler;
  asm
	  PUSH	DS
	  CLD
	  LES	DI,Str2
	  MOV	SI,DI
	  MOV	CX,0FFFFH
	  XOR	AX,AX
	  CWD
	  REPNE	SCASB
	  NOT	CX
	  MOV	DI,SI
	  LDS	SI,Str1
	  REPE	CMPSB
	  MOV	AL,DS:[SI-1]
	  MOV	DL,ES:[DI-1]
	  SUB	AX,DX
	  POP	DS
  end;


  {----------------------------------
    �����頥� 㪠��⥫� �� ����
    ������ � �吝�� ᯨ᪥, �
    ���浪��� ����஬ i
   ----------------------------------}
  function   GetData(d: PData; i: Byte): PData;
  begin
    GetData:=nil;
    dvError:=erNoData;
    if d = nil then Exit;
    while (i > 0) and (d <> nil) do begin
      Dec(i);
      d:=d^.next;
    end;
    if i <> 0 then d:=nil;
    dvError:=erNo;
    GetData:=d;
  end;


  {----------------------------------
    �����頥� 㪠��⥫� ��
    ��६����� � �吝�� ᯨ᪥, �
    ���浪��� ����஬ i
   ----------------------------------}
  function   GetVar(i: LongInt): PVar;
  var        v: PVar;
  begin
    GetVar:=nil;
    v:=Variables;
    while (i > 0) and (v <> nil) do begin
      Dec(i);
      v:=v^.next;
    end;
    if i <> 0 then v:=nil;
    dvError:=erNo;
    GetVar:=v;
  end;


  {----------------------------------
    �����頥� ���浪��� �����
    ��६����� � �吝�� ᯨ᪥,
    � ������ Name
   ----------------------------------}
  function   FindVar(Name: TName): LongInt;
  var        v: PVar;
             i: LongInt;
  begin
    FindVar:=erNotFind;
    v:=Variables;
    i:=0;
    while (v^.Name <> Name) and (v <> nil) do begin
      Inc(i);
      v:=v^.next;
    end;
    if v^.Name <> Name then i:=erNotFind;
    dvError:=erNo;
    FindVar:=i;
  end;


  {----------------------------------
    ������� � ����㦠�� �� 䠩�� �
    ������ n ��६����� � ������ name
   ----------------------------------}
  function   LoadVar(n: String; name: TName): LongInt;
  var        f: File;
             pc: array [0..31] of Char;
             p: Pointer;
             i: LongInt;
             d, md: PData;
             sz, w: Word;
  begin
    LoadVar:=erNoFile;
    Assign(f, n);
    {$I-}
    Reset(f, 1);
    {$I+}
    if IOResult <> 0 then Exit;
    BlockRead(f, pc, 30);
    sz:=Ord(pc[28]) + (Word(Ord(pc[29])) shl 8);
    pc[26]:=#0;
    if StrComp(pc, '['+PDVHead+']') <> 0 then begin
      Close(f);
      Exit;
    end;
    d:=nil;
    md:=nil;
    while (StrComp(pc, '[End o') <> 0) and not EOF(f) and (dvError = erNo) do begin
      BlockRead(f, pc, 2);
      BlockRead(f, pc, 6);
      pc[6]:=#0;
      if StrComp(pc, '[Data]') = 0 then begin
        BlockRead(f, pc, 2);
        BlockRead(f, pc, 2);
        w:=Ord(pc[0]) + (Word(Ord(pc[1])) shl 8);
        if md = nil then begin
          md:=NewData(w, nil);
          if dvError <> erNo then FreeData(md);
          if md <> nil then BlockRead(f, md^.Data^, w);
          d:=md;
        end else begin
          d^.Next:=NewData(w, nil);
          d:=d^.Next;
          if dvError <> erNo then FreeData(md);
          if d <> nil then BlockRead(f, d^.Data^, w);
        end;
      end;
    end;
    Close(f);
    if md = nil then Exit;
    i:=NewVar(Name, sz, md);
    if i < erNo then Exit;
    dvError:=erNo;
    LoadVar:=i;
  end;


  {----------------------------------
    �뤥��� ������ ��� ������ �����
    ������ � ᮧ���� ��� ����⥫�
   ----------------------------------}
  function   NewData(Size: Word; Next: PData): PData;
  var        d: PData;
  begin
    NewData:=nil;
    if dvError = erNoMem then Exit;
    if MaxAvail < Size+SizeOf(TData)+32 then begin
      FreeData(Next);
      dvError:=erNoMem;
      Exit;
    end;
    New(d);
    if Size <> 0 then GetMem(d^.Data, Size)
                 else d^.Data:=nil;
    d^.Size:=Size;
    d^.Next:=Next;
    NewData:=d;
  end;


  {----------------------------------
    ������� ����� ��६����� �
    ��।���� ��� ��� ������
   ----------------------------------}
  function   NewVar(Name: TName; Size: Word; Data: PData): LongInt;
  var        v, v1: PVar;
             i: LongInt;
  begin
    NewVar:=erNoVar;
    dvError:=erNoData;
    if Data = nil then Exit;
    dvError:=erBadName;
    if FindVar(Name) <> erNotFind then begin
      FreeData(Data);
      Exit;
    end;
    dvError:=erNoSize;
    if Size = 0 then begin
      FreeData(Data);
      Exit;
    end;
    dvError:=erNoName;
    if Name = '' then begin
      FreeData(Data);
      Exit;
    end;
    dvError:=erNoMem;
    if MemAvail < SizeOf(TVar)+16 then begin
      FreeData(Data);
      Exit;
    end;
    New(v);
    v^.Name:=Name;
    v^.Size:=Size;
    v^.Data:=Data;
    v^.Next:=nil;
    v1:=Variables;
    i:=0;
    if v1 <> nil then begin
      while (i > 0) and (v1^.next <> nil) do begin
        Inc(i);
        v1:=v1^.next;
      end;
      Inc(i);
      v1^.next:=v;
    end else Variables:=v;
    dvError:=erNo;
    Inc(MaxVar);
    NewVar:=i;
  end;





 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                                  ��楤���
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}

  {----------------------------------
    �᢮������� ������ �� ��६�����
    � �� ������
   ----------------------------------}
  procedure  DisposeVar(i: LongInt);
  var        v: PVar;
  begin
    v:=GetVar(i);
    if v <> nil then begin
      FreeData(v^.Data);
      if i = 0 then Variables:=v^.next;
      Dispose(v);
      if i > 0 then begin
        v:=GetVar(i-1);
        if v <> nil then v^.next:=GetVar(i+1);
      end;
      Dec(MaxVar);
    end;
  end;


  {----------------------------------
    �᢮������� ������ �� ���
    ��६�����, ����� �� ��⠫���
   ----------------------------------}
  procedure  DoneDV;
  var        i: LongInt;
  begin
    for i:=MaxVar-1 downto 0 do DisposeVar(i);
  end;


  {----------------------------------
    �ᮡ������ ������, ������
    �������� �����
   ----------------------------------}
  procedure  FreeData(d: PData);
  begin
    if d = nil then Exit;
    if d^.next <> nil then FreeData(d^.next);
    if d^.Size > 0 then FreeMem(d^.Data, d^.Size);
    Dispose(d);
  end;


  {----------------------------------
    ���࠭�� ��६����� � 䠩� s
   ----------------------------------}
  procedure  SaveVar(i: LongInt; s: String);
  var        pc: PChar;
             p: Pointer;
             v: PVar;
             f: File;
             d: PData;
  begin
    dvError:=erNoVar;
    v:=GetVar(i);
    if v = nil then Exit;
    Assign(f, s);
    {$I-}
    Rewrite(f, 1);
    {$I+}
    if IOResult <> 0 then begin
      dvError:=erNoSize;
      Exit;
    end;
    pc:='['+PDVHead+']'#13#10#0#0#0;
    pc[28]:=Chr(Lo(v^.Size));
    pc[29]:=Chr(Hi(v^.Size));
    p:=pc;
    BlockWrite(f, p^, 30);
    d:=v^.Data;
    while d <> nil do begin
      pc:=#13#10'[Data]'#13#10#0#0#0;
      pc[10]:=Chr(Lo(d^.Size));
      pc[11]:=Chr(Hi(d^.Size));
      p:=pc;
      BlockWrite(f, p^, 12);
      BlockWrite(f, d^.Data^, d^.Size);
      d:=d^.next;
    end;
    pc:=#13#10'[End of File]'#0;
    p:=pc;
    BlockWrite(f, p^, 15);
    Close(f);
  end;





 {-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                             ��砫쭠� ���樠������
  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
  begin
    Variables:=nil;                     { ��� ��६�����                    }
    MaxVar:=0;                          { �� ������⢮ ࠢ�� 0             }
  end.