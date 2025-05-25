DR$ = "VBESVGA.DRV"
OPEN "VIDMODES.TXT" FOR INPUT AS #1
OPEN "OEMSETUP.1" FOR OUTPUT AS #2
REM OEMSETUP.INF HEADER
PRINT #2, "Version="; CHR$(34); "0.0.1"; CHR$(34)
PRINT #2, ""
PRINT #2, "[disks]"
PRINT #2, "    1 =., "; CHR$(34); "PluMGMK VBE SVGA Driver"; CHR$(34); ",disk1"
PRINT #2, ""
PRINT #2, "[display]"
OPEN "OEMSETUP.2" FOR OUTPUT AS #3
DO
LINE INPUT #1, A$
LOOP UNTIL A$ = "Available modes:"
L = 255
DIM M(L, 2) AS INTEGER
I = 0
DO WHILE NOT EOF(1)
LINE INPUT #1, A$
ID$ = LEFT$(A$, INSTR(A$, ":") - 1)
H# = VAL(MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2))
V# = VAL(MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1))
C# = VAL(MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, 2))
IF H# < 640 OR V# < 480 THEN 1009: REM CONTINUE
IF (C# > 24) THEN C# = 24: REM MAX VALUE ALLOWED FOR DEPTH IS 24
FOR J = 0 TO L
IF M(J, 0) = H# AND M(J, 1) = V# AND M(J, 2) = C# THEN 1009: REM CONTINUE
NEXT J
M(I, 0) = H#
M(I, 1) = V#
M(I, 2) = C#
I = I + 1
SELECT CASE C#
CASE 8
C$ = "256"
CASE 16
C$ = "64k"
CASE 24
C$ = "16M"
END SELECT
FOR K = 0 TO 1: REM CREATE BOTH LARGE AND SMALL FONT ENTRIES FOR EVERY VIDEO MODE
IF K = 0 THEN FS$ = "S" ELSE FS$ = "L"
PRINT #2, "VBE"; ID$; FS$; "=1:"; DR$; ","; CHR$(34); "VBE/SVGA "; LTRIM$(STR$(H#)); "x"; LTRIM$(STR$(V#)); "x"; C$; " ";
IF FS$ = "S" THEN PRINT #2, "Small";  ELSE PRINT #2, "Large";
PRINT #2, " fonts"; CHR$(34); ","; CHR$(34); "100,";
IF FS$ = "S" THEN PRINT #2, "96,96";  ELSE PRINT #2, "120,120";
PRINT #2, CHR$(34); ",,2:VGALOGO.LGO, 2:VDDVBE.386, 2:VGADIB.3GR,,2:VGALOGO.RLE,VBE"; ID$; FS$
REM SETTINGS FOR EACH ENTRY
PRINT #3, "[VBE"; ID$; FS$; "]"
PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "W"; CHR$(34); ","; CHR$(34); "Width="; LTRIM$(STR$(H#)); CHR$(34)
PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "H"; CHR$(34); ","; CHR$(34); "Height="; LTRIM$(STR$(V#)); CHR$(34)
PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "D"; CHR$(34); ","; CHR$(34); "Depth="; LTRIM$(STR$(C#)); CHR$(34)
PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "F"; CHR$(34); ","; CHR$(34); "fontsize=";
IF FS$ = "S" THEN PRINT #3, "small";  ELSE PRINT #3, "large";
PRINT #3, CHR$(34)
PRINT #3, ""
NEXT K
1009 LOOP
PRINT #2, ""
CLOSE #3
CLOSE #2
CLOSE #1
SYSTEM
