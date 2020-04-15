;       CPU type detector.
;       Copyright (c) 1999 ShAG Studio
;	You may exporting function from this file if write
;
;	{$L CPUID.OBJ}
;	FUNCTION GetCPUType: Byte; EXTERNAL;
;
;	in your pascal program. On result you give number of processor
;	version.
;		Processor version       Number
;                    86                   0
;		     286                  2
;		     386                  3
;		     486                  4
;	 	   Pentium               5-255

 TITLE CPUID
 JUMPS
 .model small
 .stack 100h
 .data
 saved_cpuid     dd      ?
 vendor_id       db      12 dup (?)
 cpu_type        db      ?
 themodel        db      ?
 stepping        db      ?
 id_flag         db      0
 intel_proc      db      0
 intel_id        db      "GenuineIntel"

 public GetCPUType
 .code
 .8086

GetCPUType proc

check_8086:
        pushf                           ;save FLAGS
        pop     bx                      ;store FLAGS in BX
        mov     ax, 0fffh               ;clear bits 12-15
        and     ax, bx                  ;  in FLAGS
        push    ax                      ;store new FLAGS calue on stack
        popf                            ;replace current FLAGS value
        pushf                           ;set new flags
        pop     ax                      ;store new flags in AX
        and     ax, 0f000h              ;if bits 12-15 are set, then CPU
        cmp     ax, 0f000h              ;  is an 8086/8088
        mov     cpu_type, 0             ; save the CPU type
        je      end_get_cpuid

check_80286:
.286
        or      bx, 0f000h              ;try to set bits 12-15
        push    bx
        popf
        pushf
        pop     ax
        and     ax, 0f000h              ; if bits 12-15 are cleared,
                                        ;       CPU=Intel 286
        mov     cpu_type, 2             ; turn on Intel 286 Cpu flag
        jz      end_get_cpuid           ; if CPU is intel 286, check
                                        ; for Intel 287 math coprocessor

check_intel386:
.386
        pushfd
        pop     eax                     ;get original EFLAGS
        mov     ecx,eax                 ; save original EFLAGS
        xor     eax,40000h              ;flip AC bit in EFLAGS
        push    eax                     ; save for EFLAGS
        popfd                           ; copy to EFLAGS
        pushfd                          ; push EFLAGS
        pop     eax                     ; get new EFLAGS value
        xor     eax,ecx                 ; can't toggle AC bit, CPU=Intel386
        mov     cpu_type, 3             ; turn on Intel386 CPU flag
        je      end_get_cpuid           ; if CPU is Intel386, now check
                                        ; for an Intel 287 or Intel387 MCP

check_Intel486:
.486
        mov     cpu_type, 4             ;turn on Intel486 CPU flag
        pushfd                          ;push original EFLAGS
        pop     eax                     ; get original EFLAGS in eax
        mov     ecx,eax                 ;save original EFLAGS in ecx
        or      eax,200000h             ; flip ID bit in EFLAGS
        push    eax                     ;save for EFLAGS
        popfd                           ;copy to EFLAGS
        pushfd                          ;push EFLAGS
        pop     eax                     ;get new EFLAGS value
        xor     eax,ecx
        je      end_get_cpuid           ;if ID bit cannot be changed,
                                        ;CPU=Intel486 without CPUID
                                        ;instruction functionality

check_vendor:
.586
        mov     id_flag, 1              ; set flag for indicating use of
                                        ;CPUID inst
        mov     eax, 0                  ;set up for CPUID instruction
        cpuid
        mov     dword ptr vendor_id, ebx; Test for "GenuineIntel" vendor id.
        mov     dword ptr  vendor_id[+4], edx
        mov     dword ptr vendor_id[+8], ecx
        mov     si, offset vendor_id
        mov     di, offset intel_id
        mov     cx, length intel_id
compare:
        repe    cmpsb
        cmp     cx, 0                   ; must be a GenuineIntel if ecx =0
        jne     cpuid_data

intel_processor:
        mov     intel_proc, 1

cpuid_data:
        mov     eax, 1
        cpuid
        mov     saved_cpuid,eax         ;save for future use
        and     eax, 0F00H              ; mask everything but family
        shr     eax, 8
        mov     cpu_type, al            ; set cpu_type with family

        mov     eax,saved_cpuid         ;restore data
        mov     stepping, al
        and     stepping, 0FH           ; isolate stepping info

        mov     eax, saved_cpuid
        mov     themodel, al
        and     themodel, 0F0H          ; isolate model info
        shr     themodel, 4

end_get_cpuid:
.8086
	mov al, cpu_type		
        ret
GetCPUType endp

	start:
	end start
