 ; �������᪠� �ணࠬ�� hello.asm
 ; ��� �뢮��� ��ப� Hello world! �� �ନ��� - ⥪�⮢� ��࠭

 ; ���塞 �⥪ �� 512 ����
 stack 512

 ; ������砥� ����� ��� ࠡ��� � �ନ�����
 include terminal.inc
 
 ; message - ��६����� ᮤ�ঠ�� �뢮����� ���� ��ப� 
 message db 'Hello world!', 10, 13, 0  ; 0 - ����� ��ப�

 ; ��砫� �ணࠬ�� 
 start:

  ; ᮧ���� ��⮪ ��� ࠡ��� � �ନ�����, ��� ����� �࠭���� � ��६����� 
  ; TrmStream ��� ������� ᫮��
  call CreatTrmStream
 
  ; �����塞 ���� ��६�����, ����� ᮤ�ন� �뢮����� ��ப�, � ॣ���� lep
  mov lep, message

  ; ��뢠�� ��楤��� �뢮�� ��ப� �� �ନ���
  call WriteString

 ; ����� �ணࠬ��
 finish: