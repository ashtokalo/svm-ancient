;----------------------------------------------------------------------------
;         Virus checker  Version 1.0  Copyright (c) 1999 ShAG Studio
;                             EXE-mudul file
;----------------------------------------------------------------------------
;    ��  �ணࠬ��  ��  ����  ᠬ����⥫쭮�.  ���  �।�����祭�  ���
; ��⠭����  �  �����  ���  ��㣮��  EXE-䠩��. ���� 34 ���� ��⮢����
; ᯥ樠�쭮�  �ணࠬ���,  ����� ��⠭�������� ��� �����. ��᫥ ����᪠
; EXE-䠩��  ������������  �⨬  ���㫥�, �ࠢ����� ����砥� �� �ணࠬ��.
; ��� �஢���� ��������� 䠩��. �᫨ �� ���������, �����, ����⭥� �ᥣ�,
; 䠩�  ��  ��ࠦ��  ����ᮬ  ��� ������஢�� �����-� ��㣮� �ணࠬ���.
; ���⮬�  �ணࠬ��  �।�०����  ���짮��⥫�  �  ��������� � �।������
; ����⠭����� �ਣ����, ��⥬ �����뢠��� EXE-䠩�� � ��㣮� 䠩�. �� �⮬
; �᫨  �����  ����ᠫ  ᢮� ��� � ����� 䠩��, ��� �ࠣ���� �� ���������.
; �᫨  �� ����� ����ᠫ ᢮� ��� � ��砫� ��� � �।��� 䠩�� � ����������
; ����   �ਣ�����,   �ணࠬ��  �뤠��  ᮮ⢥�����饥  ᮮ�饭��,  ��  ��
; ����⠭��������   �ਣ����.   ��᫥   ���   ���  �������権,  �ணࠬ��
; ����⠭��������  ��ࢮ��砫�� ��������� 䠩��. ��᫥ ⮣�, ��� �ணࠬ��
; �믮����   ��   ����������  ��  ���  �㭪樨,  ���  ��।���  �ࠢ�����
; �ਣ����쭮�� EXE-䠩��.
;    �  ��  ���  �������  ��஭��� �. �., ���⮬� ᮮ���, �� ���� � ����
; ॠ����樨 � ��� � ����.
;----------------------------------------------------------------------------

CSEG    SEGMENT PARA    PUBLIC  'CODE'

; ������� ��楤��
VirCheck        PROC    FAR
        ASSUME CS:CSEG,DS:CSEG,SS:CSEG
 ;������騥 34 ���� ��⮢���� �ணࠬ���-���⠫���஬:
 Head      dw      12 dup(?)     ; ����஢���� ����
 StartS    dw      ?             ; �⭮�⥫�� ᥣ����
 StartO    dw      ?             ; � ᬥ饭�� �窨 ����᪠
 Leng1     dw      ?             ; �⠫����� ����� -24 ����
                                 ; (������ ����)
 Leng2     dw      ?             ; ����� ����
 Key       dw      ?             ; ��� ����

 ; ��६���� � ����⠭��
 PSP       dw      ?             ; ᥣ���� PSP
 CS0       dw      ?             ; ��࠭���� CS
 SP0       dw      ?             ; ��࠭���� SP
 NameFE    db      80 dup(?)     ; ASCIIZ-��� EXE-䠩��
 NameF$    db      80 dup(?)     ; ASCIIZ-��� $V$-䠩��
 NameFV    db      80 dup(?)     ; ASCIIZ-��� VIR-䠩��
 Buffer    equ word ptr NameF$
 LName     dw      ?             ; ����� ����� ��� ���
                                 ; ���७�� � ���
 HandExe   dw    0               ; ����⥫� EXE-䠩��
 Copyright db    10,13,
           db    'Virus checker  Version 1.0  Copyright (c) 1999 ShAG Studio'
           db    10,13,'$'
 Txt0      db    10,13,'$'       ; EOL
 Txt1      db    'Warning! File $'
 Txt2      db    ' was infected by virus!',10,13,'$'
 Txt21     db    'Sorry, I can`t delete virus, because it situated at top of file!',10,13
 Txt20     db    'Press any key...$'
 Txt22     db    'Do you want to delete virus from file (Y/N,Y) ?$'
 Vir       db    'VIR',0
 Ext$      db    '$V$',0
 HandVir   dw    0
 Txt3      db    'Error: Access denied.',10,13,'$'
 Txt4      db    'Virus was deleting. Check any file!',10,13,'$'
 Mem       dw    ?               ; ࠧ��� ����
 MemS      dw    ?               ; ᥣ���� ����
 MemF      dw    0               ; �ਧ��� ��।������ �����

 START:
        ; ����ࠨ���� ��࠭�� ���न���� �窨 �室� � �᭮���� �ணࠬ��
        push    ax              ; ᯠ�� AX
        mov     ax,ds           ; ��������� ᥣ���� PSP
        mov     bx,sp           ; � 㪠��⥫� �⥪�
        push    cs              ; �������� ᥣ���� ������
        pop     ds              ; ࠢ�� ᥣ����� ����
        mov     CS0,ds          ; ��࠭��� CS
        mov     PSP,ax          ; ᯠ�� DS = PSP
        mov     SP0,bx          ; ᯠ�� SP
        add     ax,10h          ; ᥣ���� ��砫� �ணࠬ��
        add     ax,StartS       ; ᥣ���� �窨 ����᪠
        mov     StartS,ax       ; �����⮢��� ��室

        ; ����� ᫥��� �ணࠬ�� ��������� �� ���ᠭ���� ��� �������
        call    GetExeName      ; ������� ��� EXE-䠩��
        call    ReadHead        ; ������ ��� ���������
        call    CheckHead       ; �஢���� ���������
        je      Exit            ; ��������, �᫨ ��ଠ
        call    Dialog          ; ᮮ���� � �������
        je      Exit            ; ���짮��⥫� ����⨫ 㤠�����
        call    NewFile         ; ᮧ���� $V$-䠩�
        call    WriteHead       ; ������� � ���� �⠫���� ���������
        call    CopyFile        ; ����஢��� ����ࠦ����� ����
        call    Rename          ; ��२�������� 䠩��
        ; ����� �ணࠬ�� �⢥��饩 �� ॠ������ ���ᠭ���� �����⬠

EXIT:
        ; �᢮������� �� �ᯮ��㥬� ���� ������� � �����頥��� � �᭮����
        ; �ணࠬ��
        call    CloseFiles      ; ������� ������ 䠩��
        call    FreeMem         ; ������ ��१�ࢨ஢����� ������
        mov     sp,SP0          ; ����⠭����� SP
        mov     bx,StartS       ; �����⮢��� ᥣ����
        mov     cx,StartO       ; � ᬥ饭�� �窨 ����᪠
        mov     es,PSP          ; ����⠭����� ES
        mov     ds,PSP          ; ����⠭����� DS
        pop     ax              ; ����⠭����� AX
        push    bx
        push    cx
        retf                    ; ��।��� �ࠢ����� �᭮���� �ணࠬ��

;----------------------------------------------------------------------------
;    �����  ᫥����  ��楤���, � ������� ������ ॠ������� ���ᠭ�� ���
; ������ ����� � ����஫�.
;----------------------------------------------------------------------------

;----------------------------------------------------------------------------
;    ������   ��楤��   �����頥�   ���   �ணࠬ��.   ��㣨��   ᫮����,
; �����頥��� ��ࠬ��� ��������� ��ப� � �����ᮬ 0.
;----------------------------------------------------------------------------
GetExeName      PROC    NEAR
  ; ���������� ���㦥��� ���, �뤥��� ��� �ணࠬ��
  ; � ������� ��� � ���� NameFE
        mov     es,PSP          ; ES = PSP
        mov     es,es:[2Ch]     ; ES - ᥣ���� ���㦥���
        ; �᪠�� ��砫� �������⥫��� ��ࠬ��஢
        mov     cx,1000         ; �᪠�� � ���� ������ 1000 ����
        mov     bx,-1           ; ����� � ��ࢮ�� ����
SEARCH:
        inc     bx              ; ⥪�騩 ����
        mov     ax,es:[bx]      ; ⥪�饥 ᫮��
        cmp     ax,0            ; �᪠�� ��� ���
        jz      EndSearch       ; ���室, �᫨ ��諨
        loop    Search          ; ������� ��� ᫥���饣� ����
        jmp     Exit            ; �� ������� ��� - ��室!
        ; ��७��� ��� 䠩��
ENDSEARCH:
        add     bx,2            ; ᬥ饭�� ������⢠ ��ࠬ��஢
        mov     ax,es:[bx]      ; ������� ������⢮ ��ࠬ��஢
        cmp     ax,0            ; ���� ��ࠬ����?
        je      Exit            ; -���, ��室
        add     bx,2            ; ��砫� �����
        lea     di,NameFE       ; ������ �����
        mov     cx,0            ; �����⮢��� ���稪 �����
LAB1:   mov     ah,es:[bx]      ; ��।��� ᨬ���
        mov     [di],ah         ; ��७��� ���
        inc     bx              ; ������� 㪠��⥫�
        inc     di
        inc     cx              ; � ���稪
        cmp     ah,0
        jnz     Lab1            ; �������� �� ᨬ���� 0
        add     cx,-4           ; CX - ����� ����� ��� ���७�� � 0
        mov     LName,cx
        ret
        
;----------------------------------------------------------------------------
; ������ ��楤�� �⠥� ��������� EXE-䠩��
;----------------------------------------------------------------------------
ReadHead        PROC    NEAR
        ; ���뢠�� EXE-䠩�, �⠥� �� ���� ���������
        ; ������ 䠩� � ������ � NAMEF
        lea     dx,NameFE       ; ��砫� �����
        mov     ah,3Dh          ; ��� ����樨
        mov     al,0            ; ������ ��� �⥭��
        int     21h             ; �������� � DOS
        jnc     Lab0            ; �᫨ ��� �訡��
        jmp     Exit            ; ���, �᫨ �訡��
LAB0:   mov     HandExe,ax      ; ��࠭��� ����⥫� 䠩��
        ; ����� ��������� 䠩��
        mov     bx,ax           ; BX - ����⥫� 䠩��
        mov     ah,3Fh          ; ��� ����樨
        lea     dx,Buffer       ; DS:DX - ���� ����
        mov     cx,24           ; ���� 24 ���� (���������)
        int     21h
        jnc     m0
        jmp     Exit            ; �᫨ �訡��
m0:     ret

;----------------------------------------------------------------------------
; ������ ��楤�� �ࠢ������ ���⠭� ��������� � ����騬�� �⠫����.
;----------------------------------------------------------------------------
CheckHead       PROC    NEAR
  ; ������� ���� � �஢���� ��������� 䠩��
        ; ����஢��� ����
        mov     cx,12           ; ���稪 ����७��
        lea     bx,Head         ; BX - ᬥ饭�� �⠫������ ���������
LAB2:   mov     ax,[bx]         ; ����� ��।��� ᫮��
        xor     ax,Key          ; ����஢��� ���
        mov     [bx],ax         ; � �������� �����
        add     bx,2            ; ᬥ���� � ᫥���饬� ᫮��
        loop    Lab2            ; �������
        ; �ࠢ���� ��������� � �⠫����
        mov     cx,12           ; ����� ��������� � ᫮���
        mov     es,cs0          ; ES - ᥣ���� ����
        lea     si,Head         ; �⠫��
        lea     di,Buffer       ; ���������
        cld                     ; ���ࠢ����� - ���।
repe    cmpsb                   ; �ࠢ����
        ret

;----------------------------------------------------------------------------
;������ ��楤�� �����⢫�� ������ � ���짮��⥫��.
;----------------------------------------------------------------------------
Dialog  PROC    NEAR
  ; ����頥� ���짮��⥫� � ����稨 ����� � ����訢��� ��� ����⢨�
        ; ������� ���짮��⥫�
        lea     dx,Copyright    ; Copyright
        call    Print
        lea     dx,Txt1
        call    Print           ; '���� '
        lea     bx,NameFE
        add     bx,LName
        add     bx,3            ; BX - ᬥ饭�� ��� � ���� �����
        mov     Mem,bx          ; ��࠭��� � Mem
        mov     ah,24h          ; �������� '$' � ����� �����
        mov     [bx],ah
        lea     dx,NameFE
        call    Print           ; �뢥�� ��� 䠩��
        mov     bx,Mem          ; ����⠭�����
        mov     ah,0            ; ���� � ���� �����
        mov     [bx],ah
        lea     dx,Txt2
        call    Print           ; ' ��ࠦ�� ����ᮬ!'
        ; �஢���� �ᯮ������� �����
        mov     ax,word ptr [Buffer+16h]
        cmp     ax,word ptr [Head+16h]
        ja      Delete          ; ����� � ���� 䠩��
        ; ����� � ��砫� 䠩��
        ; ������� � �������� ࠡ���
        lea    dx,Txt21
        call   Print
        mov    ah,1
        int    21h              ; ����� ॠ��� ���짮��⥫�
        lea    dx,Txt0
        call   Print            ; EOL
        jmp    Exit             ; �������� ࠡ���
        ; ����� � ���� 䠩��
DELETE:
        lea    dx,Txt22
        call   Print            ; ������� ���짮��⥫�
        ; ����� �⢥� ���짮��⥫�
        mov     ah,1
        int     21h
        push    ax
        lea     dx,Txt0
        call    Print           ; EOL
        pop     ax
        cmp     al,'N'
        je      ExitP           ; ���, �᫨ �⢥� 'N'
        cmp     al,'n'          ; �ࠢ���� � 'n'
EXITP:  ret

;----------------------------------------------------------------------------
; �뢮��� ��ப� �� ��࠭. � DX ᬥ饭�� ��ப�.
;----------------------------------------------------------------------------
Print   PROC    NEAR
        mov     ah,9
        int     21h
        ret

;----------------------------------------------------------------------------
; ������� ���� 䠩�.
;----------------------------------------------------------------------------
NewFile PROC    NEAR
  ; �����⠢������ ����� $V$ � VIR-䠩��� � ᮧ���� $V$-䠩�
        lea     di,NameF$
        lea     bx,ext$
        call    CopyName        ; ��� $V$-䠩��
        lea     di,NameFV
        lea     bx,Vir
        call    CopyName        ; ��� VIR-䠩��
        ; ������� $V$-䠩�
        mov     ah,3Ch
        mov     al,1
        lea     dx,NameF$
        int     21h
        jnc     m1
        jmp     Error
m1:     mov     HandVir,ax      ; ����⥫� ����ࠦ������ 䠩��
        ret

;----------------------------------------------------------------------------
; ������� ��ப�. DI- �ਥ����, BX-���७��
;----------------------------------------------------------------------------
CopyName        PROC    NEAR
        mov     es,cs0
        lea     si,NameFE
        mov     cx,LName
        cld
rep     movsb                   ; ����஢��� �� ���७��
        mov     si,bx
        mov     cx,4
rep     movsb                   ; ����஢��� ���७��
        ret

;----------------------------------------------------------------------------
; �����뢠�� �⠫���� ��������� � 䠩�.
;----------------------------------------------------------------------------
WriteHead       PROC    NEAR
        mov     ah,40h
        mov     cx,24           ; ����� ��������� 24 ����
        lea     dx,Head
        mov     bx,HandVir
        int     21h
        jnc     m2
        jmp     Error
m2:     ret

;----------------------------------------------------------------------------
; ������� ����ࠦ����� ���� 䠩��.
;----------------------------------------------------------------------------
CopyFile        PROC    NEAR
        ; ���� ����� ����
        mov     ax,SP0          ; ���設� �⥪� (� �⥪� AX!)
        cmp     ax,0FFD0h       ; �⥪ 64 �����?
        ja      LargStack       ; -��
        add     ax,17           ; ���㣫��� � ����⪮�
        mov     cl,4
        shr     ax,cl           ; ��ॢ��� � ��ࠣ���
        jmp     GetSize
LargStack:
        mov     ax,1000h        ; 64 � = 4096 ��ࠣ�䮢
GetSize:
        mov     cx,ss
        add     ax,cx           ; AX - ᥣ���� ����
        mov     es,PSP          ; ᥣ���� PSP
        mov     bx,es:[2]       ; ������� ���設� �����
        sub     bx,ax           ; BX - ����㯭�� ������ � ��ࠣ���
        cmp     bx,1000h        ; ����� 64 �����?
        ja      LargMem         ; -��
        mov     cl,4
        shl     bx,cl           ; BX - ����㯭�� ������ � �����
        jmp     m5
LargMem:
        mov     bx,0FFFFh       ; ����� ���� = 64 �����
m5:     cmp     bx,0            ; ���� ᢮������ ������?
        jne     SetMem          ; -��
        ; ��� ᢮������ ����� - १�ࢨ஢���
        mov     ah,48h
        mov     bx,1000h
        int     21h             ; १�ࢨ஢��� 64 �
        jnc     OKay            ; 㤠筮
        cmp     bx,0            ; ���� ��� ᪮�쪮 �����?
        jne     GetLowMem       ; -��
        ; �뤥���� ���� �⥪�
GetStack:
        mov     ax,ss
        mov     bx,sp
        add     bx,-2
        jmp     SetMem
GetLowMem:
        mov     ah,48h          ; ������� � ��� ���� �����
        int     21h             ; ������ BX ��ࠣ�䮢
        jc      GetStack
Okay:   mov     MemF,bx         ; ࠧ��� ��१�ࢨ஢�����
        mov     cl,4            ; ����� � ��ࠣ���
        shl     bx,cl           ; ��ॢ��� � �����
SetMem:
        mov     Mem,bx          ; ��������� � MEM ����� ����
        mov     MemS,ax         ; � � MemS ᥣ����
        ; ����஢��� ����ࠦ����� ���� 䠩�
Copy:   mov     ax,Leng2        ; AX - ����� ���� ���⪠
        mov     cx,Mem          ; CX - ���ᨬ���� ����
        cmp     ax,0            ; ��⠫��� ����� ����� ����?
        jnz     Read            ; -��
        cmp     cx,Leng1        ; �ࠢ���� � ������ ����
        jb      Read            ; -���� ����� ���⪠
        mov     cx,Leng1        ; ����஢��� ���⮪ 楫����
        ; ����� 䠩�
Read:
        mov     ah,3Fh
        mov     dx,0            ; ᬥ饭�� ���� = 0
        mov     bx,HandExe      ; ���� �� ��ࠦ������ 䠩��
        push    ds              ; ��࠭��� DS
        mov     ds,MemS         ; ���� - �ࠧ� �� ���殬 �ணࠬ��
        int     21h
        pop     ds
        jnc     Write
        jmp     Error           ; �᫨ �訡�� �⥭��
        ; ������� 䠩�
Write:
        mov     cx,ax           ; �᫮ 䠪��᪨ ���⠭��� ����
        mov     ah,40h
        mov     dx,0
        mov     bx,HandVir      ; ����� � $V$-䠩�
        push    ds
        mov     ds,MemS
        int     21h
        pop     ds
        jnc     m3
        jmp     Error           ; �᫨ �訡�� �����
        ; �������� ����� ���⪠
m3:     mov     dx,Leng1        ; DX - ������ ���� �����
        mov     cx,Leng2        ; CX - ����� ���� �����
        sub     dx,ax           ; AX - ����� ����ᠭ����
        sbb     cx,0            ; CX:DX - ����� ���⪠
        mov     Leng2,cx
        mov     Leng1,dx
        cmp     cx,0
        jnz     Copy            ; ��������
        cmp     dx,0
        jnz     Copy            ; ���� ���⮪ �� �⠭�� �㫥��
        ret

;----------------------------------------------------------------------------
; ��२�����뢠�� 䠩�.
;----------------------------------------------------------------------------
Rename  PROC    NEAR
        call    CloseFiles      ; ������� 䠩��
        mov     ah,41h
        lea     dx,NameFV
        int     21h             ; 㤠���� VIR-䠩�
        mov     ah,56h
        lea     dx,NameFE
        push    ds
        pop     es
        lea     di,NameFV
        int     21h             ; ��२�������� EXE � VIR
        jc      Error
        mov     ah,56h
        lea     dx,NameF$
        lea     di,NameFE
        int     21h             ; ��२�������� $V$ � EXE
        jc      Error
        ; ������� � ���� ࠡ���
        lea     dx,Txt4
        call    Print           ; '����� 㤠���...'
        lea     dx,Txt20
        call    Print           ; '������...'
        mov     ah,1
        int     21h             ; ��������� ॠ�樨 ���짮��⥫�
        lea     dx,Txt0
        call    Print
        ret

;----------------------------------------------------------------------------
; ����뢠�� ������ ࠭�� 䠩�.
;----------------------------------------------------------------------------
CloseFiles      PROC NEAR
        mov     bx,HandExe
        cmp     bx,0
        je      Next
        mov     ah,3Eh
        int     21h
        jc      Error
        mov     HandExe,0
Next:   mov     bx,HandVir
        cmp     bx,0
        je      All
        mov     ah,3Eh
        int     21h
        jc      Error
        mov     HandVir,0
All     :ret

;----------------------------------------------------------------------------
; �᢮������� ��१�ࢨ஢����� ������
;----------------------------------------------------------------------------
FreeMem PROC    NEAR
        mov     bx,MemF
        cmp     bx,0
        je      Return
        mov     ah,49h
        mov     es,MemS
        int     21h
Return: ret

;----------------------------------------------------------------------------
; ��஡�⪠ �訡�� ����㯠 � ����
;----------------------------------------------------------------------------
ERROR:
        lea     dx,Txt3
        call    Print           ; '�訡�� ����㯠 � ����'
        jmp     Exit
CSEG    ENDS
        END     START

;----------------------------------------------------------------------------
;         Virus checker  Version 1.0  Copyright (c) 1999 ShAG Studio
;                             EXE-mudul file
;----------------------------------------------------------------------------