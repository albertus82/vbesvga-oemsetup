OPEN "VIDMODES.TXT" FOR INPUT AS #1
OPEN "OEMSETUP.1" FOR OUTPUT AS #2
PRINT #2, "Version="; CHR$(34); "0.0.1"; CHR$(34)
PRINT #2, ""
PRINT #2, CHR$(91); "disks"; CHR$(93)
PRINT #2, "    1 =., "; CHR$(34); "PluMGMK VBE SVGA Driver"; CHR$(34); ",disk1"
PRINT #2, ""
PRINT #2, CHR$(91); "display"; CHR$(93)
OPEN "OEMSETUP.2" FOR OUTPUT AS #3
DO
LINE INPUT #1, A$
LOOP UNTIL A$ = "Available modes:"
SZ = 255
DIM MO(SZ, 2) AS INTEGER
LET I = 0
DO WHILE NOT EOF(1)
LINE INPUT #1, A$
ID$ = LEFT$(A$, INSTR(A$, ":") - 1)
HO# = VAL(MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2))
VE# = VAL(MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1))
CO# = VAL(MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, 2))
IF (CO# > 24) THEN CO# = 24
SELECT CASE CO#
CASE 8
CO$ = "256"
CASE 16
CO$ = "64k"
CASE 24
CO$ = "16M"
END SELECT
IF HO# < 640 OR VE# < 480 THEN 999
FOR J = 0 TO SZ
IF MO(J, 0) = HO# AND MO(J, 1) = VE# AND MO(J, 2) = CO# THEN 999
NEXT J
MO(I, 0) = HO#
MO(I, 1) = VE#
MO(I, 2) = CO#
I = I + 1
PRINT #2, "VBE"; ID$; "S=1:VBESVGA.DRV,"; CHR$(34); "SVGA ("; LTRIM$(STR$(HO#)); "x"; LTRIM$(STR$(VE#)); "x"; CO$; " Small fonts)"; CHR$(34); ","; CHR$(34); "100,96,96"; CHR$(34); ",,2:VGALOGO.LGO, 2:VDDVBE.386, 2:VGADIB.3GR,,2:VGALOGO.RLE,VBE"; ID$; "S"
PRINT #2, "VBE"; ID$; "L=1:VBESVGA.DRV,"; CHR$(34); "SVGA ("; LTRIM$(STR$(HO#)); "x"; LTRIM$(STR$(VE#)); "x"; CO$; " Large fonts)"; CHR$(34); ","; CHR$(34); "100,120,120"; CHR$(34); ",,2:VGALOGO.LGO, 2:VDDVBE.386, 2:VGADIB.3GR,,2:VGALOGO.RLE,VBE"; ID$; "L"
FOR J = 1 TO 2
IF J = 1 THEN PRINT #3, CHR$(91); "VBE"; ID$; "S"; CHR$(93) ELSE PRINT #3, CHR$(91); "VBE"; ID$; "L"; CHR$(93)
PRINT #3, ",,system.ini,VBESVGA.DRV,"; CHR$(34); "W"; CHR$(34); ","; CHR$(34); "Width="; LTRIM$(STR$(HO#)); CHR$(34)
PRINT #3, ",,system.ini,VBESVGA.DRV,"; CHR$(34); "H"; CHR$(34); ","; CHR$(34); "Height="; LTRIM$(STR$(VE#)); CHR$(34)
IF CO# <> 24 THEN PRINT #3, ",,system.ini,VBESVGA.DRV,"; CHR$(34); "D"; CHR$(34); ","; CHR$(34); "Depth="; LTRIM$(STR$(CO#)); CHR$(34)
IF J = 2 THEN PRINT #3, ",,system.ini,VBESVGA.DRV,"; CHR$(34); "F"; CHR$(34); ","; CHR$(34); "fontsize=large"; CHR$(34)
PRINT #3, ""
NEXT J
999 LOOP
PRINT #2, ""
CLOSE #3
CLOSE #2
CLOSE #1
SYSTEM

