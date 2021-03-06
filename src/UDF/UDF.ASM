 ;---------------------------------------------------------------------------
 ;                          Universal Driver Format
 ;                      Copyright (c) 2000  ShAG Studio
 ;---------------------------------------------------------------------------
                %title "Universal Driver Format"
                .model tiny
                .286
                .code
                org 0h
 start:

 ;------------------
 ;---------------- ����⠭�� ��� �⮣� �ࠩ���
 ;------------------

 CScreen_segment equ 0A000h
 CScreen_Width   equ 320
 CScreen_Height  equ 200
 CBits_per_pixel equ 8
 CVideo_Mode     equ 13h
 VByte           equ 0
 VWord           equ 1
 VLongInt        equ 2
 VReal           equ 3
 VComp           equ 4
 VArray          equ 6

 ;---------------------------------------------------------------------------
 ;                            ��������� �ࠩ���
 ;---------------------------------------------------------------------------

 ;------------------
 ;---------------- ����⮢�� ���� ���������
 ;------------------
 ; �� ���� �।�����祭� ��� ��ᬮ�� ᮤ�ন���� � ⥪�⮢�� ०���.
 ; ��ଠ� �⮩ ��� �������� ����� ��।����� �����祭�� �ࠩ���.
 ;------------------

 ; �⠭���⭠� ��ப�, � ���ன ��稭����� �� �ࠩ��� �⮣� �ଠ�
                 db "Universal Driver Format"
                 db 13, 10

 ; ���ଠ�� � ᮧ����� �ࠩ���
                 db "Copyright (c) 2000 ShAG Studio"
                 db 13, 10

 ; � �⮩ ��ப� ���筮 ᮮ�頥��� � �����祭�� �⮣� �ࠩ���
                 db "The Video driver for VGA mode with 320x200x256 colors"

 ; �⨬� ���⠬� ������ �����稢����� ⥪�⮢�� ���� �ࠩ���.
                 db 1Ah, 0, 0

 ;------------------
 ;---------------- ���⪠� ���ଠ�� � �ࠩ���
 ;------------------
       		 db 13, 10, "[DRIVER INFORMATION]", 13, 10

 ; ��� �ࠩ���
                 db "Video driver",0        ; Video driver

 ; ����� �ࠩ���
                 db 10h                     ; 1.0

 ; ��� ������, ����� ����室�� ��� �ࠩ���
                 dw 286                     ; Intel80x286

 ; �ॡ������ � ᮯ������
  		 db 0			    ; ������

 ; ��१�ࢨ஢����. ��� ���� ������ ���� ࠢ�� ���.
                 dw 0

       		 db 13, 10
 		 db "[EXPORT LIST]", 13, 10

 ;------------------
 ;---------------- ���� ��楤��
 ;------------------
 ; � �⮩ ��� �ࠩ��� ������ ��楤���, ����� �� ��ᯮ�����. ���ᠭ��
 ; �ந�室�� �� ᫥���饬� ⨯�: ���, ᬥ饭��. ��� ᬥ饭�� - ����, ��
 ; ����� ���� ��३� ��� ����᪠ ��楤���. ���� �������� �⭮�⥫쭮
 ; ᥣ���� ����.
 ;------------------
  		 db "--PROCEDURES"

 ; ��ᯮ���㥬
                 dw 10                      ; 10 ��楤��
                 db 13, 10

                 db "Init graphics mode",0  ; ��� ��楤���
                 dd initgraph               ; ���饭��
                 db 13, 10

                 db "Close graphics mode",0
                 dd closegraph
                 db 13, 10

                 db "Fill screen",0
                 dd fillscreen
                 db 13, 10

                 db "Put pixel",0
                 dd setpixel
                 db 13, 10

                 db "Get pixel",0
                 dd getpixel
                 db 13, 10

                 db "Horisontal line",0
                 dd hline
                 db 13, 10

                 db "Vertical line",0
                 dd vline
                 db 13, 10

                 db "Line",0
                 dd line
                 db 13, 10

                 db "Rectangle",0
                 dd rectangle
                 db 13, 10

                 db "Fill rectangle",0
                 dd fillrectangle
                 db 13, 10

 ;------------------
 ;---------------- ���� ��६�����
 ;------------------
 ; � �⮩ ��� �ࠩ��� ������ ��६����, ����� �� ��ᯮ�����. ���
 ; ��।������ ��६����� �ᯮ������ ⠪�� �������: ���, ⨯, ���祭��
 ; ��� ������ �����稢����� 0, � ⨯ ��।������ �� ᫥���饩 ⠡���:
 ;  0 - 1 ����
 ;  1 - 2 ����
 ;  2 - 4 ����
 ;  3 - 6 ����
 ;  4 - 8 ����
 ;  5 - 10 ����
 ;  6 - ���ᨢ �� N ����, ��� N - �� ���祭�� ᫮�� ᫥���饣� �ࠧ� ��
 ;  ��।���⥫�� ⨯�.
 ;------------------
 		 db "--VARIABLES"

 ; ��ᯮ���㥬
                 dw 4                       ; 4 ��६����
                 db 13, 10

                 db "Screen width",0        ; ��� ��६�����
                 db VWord                   ; ��� ��६�����
 Screen_Width    dw CScreen_Width           ; ���祭�� ��६�����
                 db 13, 10

                 db "Screen height",0
                 db VWord
 Screen_Height   dw CScreen_Height
                 db 13, 10

                 db "Bits per pixel",0
                 db VWord
 Bits_per_pixel  dw CBits_per_pixel
                 db 13, 10

                 db "Draw color",0
                 db VLongInt
 Color           db 0
                 db 3 dup(0)
                 db 13, 10

 		 db "[IMPORT LIST]", 13, 10

 ;------------------
 ;---------------- ���� ��楤��
 ;------------------
 ; � �⮩ ��� �ࠩ��� ������ �������㥬� ��楤���.  ���ᠭ�� �ந�室��
 ; �� ᫥���饬� ⨯�: ���, ᥣ���� ������, ᥣ���� ����, ᬥ饭��. �� �맮��
 ; ⠪�� ��楤���, ᮤ�ঠ��� ���� "ᥣ���� ������" ��⠭���������� � DS.
 ;------------------
  		 db "--PROCEDURES"

 ; �������㥬
                 dw 0                      ; 0 ��楤��
                 db 13, 10

 ;               db "Procedure name",0     ; ��� ��楤���
 ;		 dd 0			   ; ᥣ���� ������
 ;		 dd 0			   ; ᥣ���� ����
 ;               dd 0                      ; ���饭��
 ;               db 13, 10

 ;------------------
 ;---------------- ���� ��६�����
 ;------------------
 ; � �⮩ ��� �ࠩ��� ������ �������㥬� ��६����. ���ᠭ�� �ந�室��
 ; �� ᫥���饬� ⨯�: ���, ᥣ���� ������, ᬥ饭��.
 ;------------------
 		 db "--VARIABLES"

 ; �������㥬
                 dw 0                      ; 0 ��६�����
                 db 13, 10

 ;               db "Variable name",0      ; ��� ��६�����
 ;		 dd 0			   ; ᥣ���� ������
 ;               dd 0                      ; ���饭��
 ;               db 13, 10


 ;---------------------------------------------------------------------------
 ;                        ��楤��� � �㭪樨 �ࠩ���
 ;---------------------------------------------------------------------------
 		db "[DRIVER CODE]", 13, 10

 initgraph proc far
        push    ax
        mov     ax, CVideo_Mode
        int     10h
        pop     ax
        ret
 initgraph endp

 closegraph proc far
        push    ax
        mov     ax, 3
        int     10h
        pop     ax
        ret
 closegraph endp

 fillscreen proc far
        push    ax cx di es
        mov     ax, CScreen_segment
        mov     es, ax
        mov     cx, CScreen_Width*CScreen_Height/2
        mov     al, cs:[Color]
        mov     ah, al
        xor     di, di
        cld
        rep     stosw
        pop     es di cx ax
        ret
 fillscreen endp

 setpixel proc far
 arg    y: word, x: word
        enter   0, 0
        mov     ax, CScreen_segment
        mov     es, ax
        mov     ax, [y]
        mov     bx, [x]
        mov     dx, CScreen_Width
        mul     dx
        add     bx, ax
        mov     al, cs:[Color]
        mov     es:[bx], al
        leave
        ret     4
 setpixel endp

 getpixel proc far
 arg    y: word, x: word
        enter   0, 0
        mov     ax, CScreen_segment
        mov     es, ax
        mov     bx, [x]
        mov     ax, [y]
        mov     dx, CScreen_Width
        mul     dx
        add     bx, ax
        xor     ax, ax
        mov     dx, ax
        mov     al, es:[bx]
        mov     cs:[Color], al
        leave
        ret     4
 getpixel endp

 hline proc far
 arg    Len: word, Y: word, X: word
        enter   0, 0
        push    di
        cld
        mov     ax, CScreen_segment
        mov     es, ax
        mov     di, [X]
        mov     dx, [Y]
        mov     cx, [Len]
        inc     cx
        mov     ax, dx
        mov     bx, CScreen_Width
        mul     bx
        add     di, ax
        mov     al, cs:[Color]
        mov     ah, al
        shr     cx, 1
        rep     stosw
        adc     cx, cx
        rep     stosb
        pop     di
        leave
        ret     6
 hline endp

 vline proc far
 arg    Len: word, Y: word, X: word
        enter   0, 0
        cld
        mov     ax, CScreen_segment
        mov     es, ax
        mov     bx, [X]
        mov     ax, [Y]
        mov     cx, [Len]
        mov     dx, CScreen_Width
        mul     dx
        add     bx, ax
        mov     al, cs:[Color]
        inc     cx
 @@Next:
        mov     es:[bx], al
        add     bx, CScreen_Width
        loop    @@Next
        leave
        ret     6
 vline endp

 rectangle proc far
 arg    bottom: word, right: word, top: word, left: word
        enter   0, 0
        push    di si
        mov     ax, CScreen_segment
        mov     es, ax
	mov     di, [left]
	mov     bx, [right]
	sub     bx, di
	jl      @@DoneRectangle
	inc     bx
	mov     si, [top]
	mov     dx, [bottom]
	sub     dx, si
	jl      @@DoneRectangle
        cld
        push    dx
        mov     dx, CScreen_Width
        mul     dx
        add     di, ax
        pop     dx
        mov     si, CScreen_Width
        sub     si, bx
        mov     al, cs:[Color]
        mov     ah, al
        cld
        mov     cx, bx
        shr     cx, 1
        rep     stosw
        adc     cx, cx
        rep     stosb
        mov     cx, dx
        mov     es:[di], ah
 @@LoopLabel:
        add     di, si
        mov     es:[di], ah
        add     di, bx
        mov     es:[di], ah
        loop    @@LoopLabel
        sub     di, bx
        mov     cx, bx
        inc     cx
        shr     cx, 1
        rep     stosw
        adc     cx, cx
        rep     stosb
 @@DoneRectangle:
        pop     si di
        leave
        ret     8
 rectangle endp

 fillrectangle proc far
 arg    bottom: word, right: word, top: word, left: word
        enter   0, 0
        push    di si
        cld
        mov     ax, CScreen_segment
        mov     es, ax
        mov     di, [left]
        mov     bx, [right]
        sub     bx, di
        jl      @@DoneBar
        inc     bx
        mov     si, [top]
        mov     dx, [bottom]
        sub     dx, si
        jl      @@DoneBar
        inc     dx
        push    ax dx
        mov     ax, si
        mov     si, CScreen_Width
        mul     si
        add     di, ax
        pop     dx ax
        sub     si, bx
        mov     al, cs:[Color]
        mov     ah, al
 @@NewLineDraw:
        mov     cx, bx
        shr     cx, 1
        rep     stosw
        adc     cx, cx
        rep     stosb
        add     di, si
        dec     dx
        jnz     @@NewLineDraw
 @@DoneBar:
        pop     si di
        leave
        ret     8
 fillrectangle endp

 line proc far
 arg    end_y: word, end_x: word, start_y: word, start_x: word
 local  diagonal_y_increment: word, \
        diagonal_x_increment: word, \
        short_distance: word,       \
        straight_x_increment: word, \
        straight_y_increment: word, \
        straight_count: word,       \
        diagonal_count: word = szLocals;
        push    bp
        mov     bp,sp
        sub     sp, szLocals
        push    ax bx cx dx di si
        mov     ax, CScreen_segment
        mov     es, ax
        mov     cx, 1
        mov     dx, 1
        mov     di, end_y
        sub     di, start_y
        jge     @@keep_y
        neg     dx
        neg     di
 @@keep_y:
        mov     diagonal_y_increment, dx
        mov     si, end_x
        sub     si, start_x
        jge     @@keep_x
        neg     cx
        neg     si
 @@keep_x:
        mov     diagonal_x_increment, cx
        cmp     si, di
        jge     @@horz_seg
        mov     cx, 0
        xchg    si, di
        jmp     @@save_values
 @@horz_seg:
        mov     dx, 0
 @@save_values:
        mov     short_distance, di
        mov     straight_x_increment, cx
        mov     straight_y_increment, dx
        mov     ax, short_distance
        shl     ax, 1
        mov     straight_count, ax
        sub     ax, si
        mov     bx, ax
        sub     ax, si
        mov     diagonal_count, ax
        mov     cx, start_x
        mov     dx, start_y
        inc     si
 @@mainloop:
        dec     si
        jz      @@line_finished
        push    bx dx
        mov     ax, dx
        mov     bx, CScreen_Width
        mul     bx
        mov     bx, cx
        add     bx, ax
        mov     al, cs:[Color]
        mov     es:[bx], al
        pop     dx bx
        cmp     bx, 0
        jge     @@diagonal_line
        add     cx, straight_x_increment
        add     dx, straight_y_increment
        add     bx, straight_count
        jmp     short @@mainloop
 @@diagonal_line:
        add     cx, diagonal_x_increment
        add     dx, diagonal_y_increment
        add     bx, diagonal_count
        jmp     short @@mainloop
 @@line_finished:
        pop     si di dx cx bx ax
        add     sp, szLocals
        pop     bp
        ret     8
 line endp

 Finish:
 		db 13, 10, "[END OF DRIVER]"

 end start

