include keyboard.inc, terminal.inc
hello db 'Hello word! Press any key ... ',0
start:
 call creatkbdstream
 call creattrmstream
 mov lep, hello
 call WriteString
 @wait:
 call readkey
 call writechar
 cmp bl, 13
 jne  @wait
finish: