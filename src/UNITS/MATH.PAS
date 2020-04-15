{ Unit Math makes some undocumented, but fully functional routines of the
  coprocessor/emulator floating point package available to the user. These
  functions are *not* available for REAL arithmetic in $N- mode. This unit
  works correctly with real mode, DOS protected mode, and Windows programs.

  Copyright (c) 1989-1993 Norbert Juffa }


{$N+,E+}

UNIT Math;


INTERFACE

FUNCTION Tan (X: EXTENDED): EXTENDED;

FUNCTION Log (X: EXTENDED): EXTENDED;

FUNCTION Ld  (X: EXTENDED): EXTENDED;

FUNCTION PowerOfTen (X: EXTENDED): EXTENDED;

FUNCTION PowerOfTwo (X: EXTENDED): EXTENDED;


IMPLEMENTATION

{$IFDEF WINDOWS}

{$L WF87.OBJ}

{ File WF87.OBJ is one of the files delivered by Borland with BP 7.0 RTL code }

PROCEDURE __F87_TANGENT; NEAR; EXTERNAL;
PROCEDURE __F87_EXP10;   NEAR; EXTERNAL;
PROCEDURE __F87_EXP2;    NEAR; EXTERNAL;
PROCEDURE __F87_LOG10;   NEAR; EXTERNAL;
PROCEDURE __F87_LOG2;    NEAR; EXTERNAL;


FUNCTION Tan (X: EXTENDED): EXTENDED; ASSEMBLER;
ASM
   FLD   TBYTE PTR [X]   { get argument }
   CALL  __F87_TANGENT
END;

FUNCTION Log (X: EXTENDED): EXTENDED; ASSEMBLER;
ASM
   FLD   TBYTE PTR [X]    { get argument }
   CALL  __F87_LOG10;
END;

FUNCTION Ld  (X: EXTENDED): EXTENDED; ASSEMBLER;
ASM
   FLD   TBYTE PTR [X]    { get argument }
   CALL  __F87_LOG2;
END;

FUNCTION PowerOfTen (X: EXTENDED): EXTENDED; ASSEMBLER;
ASM
   FLD   TBYTE PTR [X]    { get argument }
   CALL  __F87_EXP10;
END;

FUNCTION PowerOfTwo (X: EXTENDED): EXTENDED; ASSEMBLER;
ASM
   FLD   TBYTE PTR [X]    { get argument }
   CALL  __F87_EXP2;
END;


{$ELSE}


FUNCTION Tan (X: EXTENDED): EXTENDED; ASSEMBLER;
ASM
   FLD   TBYTE PTR [X]    { get argument }
   INT   3Eh              { call shortcut interrupt }
   DW    90F0h            { signal Tan wanted to shortcut handler }
END;

FUNCTION Log (X: EXTENDED): EXTENDED; ASSEMBLER;
ASM
   FLD   TBYTE PTR [X]    { get argument }
   INT   3Eh              { call shortcut interrupt }
   DW    90F8h            { signal Log10 wanted to shortcut handler }
END;

FUNCTION Ld  (X: EXTENDED): EXTENDED; ASSEMBLER;
ASM
   FLD   TBYTE PTR [X]    { get argument }
   INT   3Eh              { call shortcut interrupt }
   DW    90F6h            { signal Log2 wanted to shortcut handler }
END;

FUNCTION PowerOfTen (X: EXTENDED): EXTENDED; ASSEMBLER;
ASM
   FLD   TBYTE PTR [X]    { get argument }
   INT   3Eh              { call shortcut interrupt }
   DW    90FEh            { signal Power of 10 wanted to shortcut handler}
END;

FUNCTION PowerOfTwo (X: EXTENDED): EXTENDED; ASSEMBLER;
ASM
   FLD   TBYTE PTR [X]    { get argument }
   INT   3Eh              { call shortcut interrupt }
   DW    90FCh            { signal Power of 2 wanted to shortcut handler }
END;


{$ENDIF}

END. { Math }
