 ;---------------------------------------------------------------------------
 ;                                  Time
 ;                               Version 1.0
 ;                      Copyright (C) 1999 ShAG Studio
 ;---------------------------------------------------------------------------
 ;    ��� ����� ᮤ�ন� ���� ��楤���, � ������� ������ �� ᬮ���
 ; ������� � ��⠭�������� ���� � �६� �� ��������.
 ;
 ; ���᮪ ��楤�� ����㯭�� ��� �맮��:
 ;    GetDate       - ������� ⥪���� ����
 ;    GetTime       - ������� ⥪�饥 �६�
 ;    SetDate       - ��⠭����� ⥪���� ����
 ;    SetTime       - ��⠭����� ⥪�饥 �६�
 ;
 ;    �⮡� �ᯮ�짮���� ��� ����� �� ������ ��⠢��� � ᢮� �ணࠬ��
 ; ᫥������ ��ப�: INCLUDE Time.inc   ��� �������� �१ �������, �᫨
 ; ��४⨢� INCLUDE 㦥 ���-� �ᯮ�짮������.
 ;---------------------------------------------------------------------------

 ;---------------------------------------------------------------------------
 ; GetDate - ������� ⥪���� ����
 ;---------------------------------------------------------------------------
 ; �室:
 ;  ���
 ; ��室:
 ;  BX - ���
 ;  CL - �����
 ;  CH - ����
 ;  DL - ���� ������
 ; ��������:
 ;  BX,CL,CH,DL
 ;---------------------------------------------------------------------------
 PROC GetDate
  PUSH LAX
  MOV  LAX, 0
  CSP  0
  POP  LAX
  RET

 ;---------------------------------------------------------------------------
 ; GetTime - ������� ⥪�饥 �६�
 ;---------------------------------------------------------------------------
 ; �室:
 ;  ���
 ; ��室:
 ;  BL - ���
 ;  BH - ������
 ;  CL - ᥪ㭤�
 ;  CH - 100-� ���� ᥪ㭤�
 ; ��������:
 ;  BX,CX
 ;---------------------------------------------------------------------------
 PROC GetTime
  PUSH LAX
  MOV  LAX, 1
  CSP  0
  POP  LAX
  RET

 ;---------------------------------------------------------------------------
 ; SetDate - ��⠭����� ⥪���� ����
 ;---------------------------------------------------------------------------
 ; �室:
 ;  BX - ���
 ;  CL - �����
 ;  CH - ����
 ; ��室:
 ;  ���
 ; ��������:
 ;  BX,CX
 ;---------------------------------------------------------------------------
 PROC SetDate
  PUSH LAX
  MOV  LAX, 2
  CSP  0
  POP  LAX
  RET

 ;---------------------------------------------------------------------------
 ; SetTime - ��⠭����� ⥪�饥 �६�
 ;---------------------------------------------------------------------------
 ; �室:
 ;  BL - ���
 ;  BH - ������
 ;  CL - ᥪ㭤�
 ;  CH - 100-� ���� ᥪ㭤�
 ; ��室:
 ;  ���
 ; ��������:
 ;  BX,CX
 ;---------------------------------------------------------------------------
 PROC SetTime
  PUSH LAX
  MOV  LAX, 3
  CSP  0
  POP  LAX
  RET

 ;---------------------------------------------------------------------------
 ;                                  Time
 ;                               Version 1.0
 ;                      Copyright (C) 1999 ShAG Studio
 ;---------------------------------------------------------------------------