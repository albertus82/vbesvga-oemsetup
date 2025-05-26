10 REM OEMSETUP.INF generator for PluMGMK VBE/SVGA Driver
20 REM Tested on GW-BASIC 3.23 and QBASIC 1.1
30 DR$ = "VBESVGA.DRV"
40 DIM MO(255, 2): REM Distinct video modes (width, height, depth)
50 REM Collect valid video modes for Windows
60 SHELL "VIDMODES > VIDMODES.TMP"
70 OPEN "VIDMODES.TMP" FOR INPUT AS #1
80 WHILE A$ <> "Available modes:"
90 LINE INPUT #1, A$: REM Skip line
100 WEND
110 I = 0
120 WHILE NOT EOF(1)
130 LINE INPUT #1, A$
140 IF LEN(A$) = 0 THEN 270: REM continue
150 WI% = VAL(MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2))
160 HE% = VAL(MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1))
170 DE% = VAL(MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, INSTR(INSTR(A$, " ") + 1, A$, " ") - INSTR(INSTR(A$, "*") + 1, A$, "*") - 1))
180 IF WI% < 640 OR HE% < 480 THEN 270: REM continue
190 IF DE% > 24 THEN DE% = 24: REM Max value allowed for Depth is 24
200 FOR J = 0 TO I
210 IF MO(J, 0) = WI% AND MO(J, 1) = HE% AND MO(J, 2) = DE% THEN 270: REM continue (avoid duplicates)
220 NEXT J
230 MO(I, 0) = WI%
240 MO(I, 1) = HE%
250 MO(I, 2) = DE%
260 I = I + 1
270 WEND
280 CLOSE 1
290 KILL "VIDMODES.TMP"
300 I = I - 1
310 REM Write OEMSETUP.INF file
320 OPEN "OEMSETUP.INF" FOR OUTPUT AS #2
330 REM Header
340 PRINT #2, "Version="; CHR$(34); "0.0.1"; CHR$(34)
350 PRINT #2, ""
360 PRINT #2, "[disks]"
370 PRINT #2, "    1 =., "; CHR$(34); "PluMGMK VBE/SVGA Driver"; CHR$(34); ",disk1"
380 PRINT #2, ""
390 PRINT #2, "[display]"
400 REM Entries
410 FOR J = 0 TO I: REM Cycle over all valid modes
420 FOR K = 0 TO 1: REM Create both large and small font entries for every mode
430 IF K = 0 THEN FS$ = "S" ELSE FS$ = "L"
440 ID$ = "VBE" + RIGHT$(STR$(J), LEN(STR$(J)) - 1) + FS$
450 PRINT #2, ID$; "=1:"; DR$; ","; CHR$(34); "VBE/SVGA "; RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0))) - 1); "x"; RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1))) - 1); "x";
460 IF MO(J, 2) = 8 THEN PRINT #2, "256";
470 IF MO(J, 2) = 16 THEN PRINT #2, "64k";
480 IF MO(J, 2) = 24 THEN PRINT #2, "16M";
490 PRINT #2, " ";
500 IF FS$ = "S" THEN PRINT #2, "Small";  ELSE PRINT #2, "Large";
510 PRINT #2, " fonts"; CHR$(34); ","; CHR$(34); "100,";
520 IF FS$ = "S" THEN PRINT #2, "96,96";  ELSE PRINT #2, "120,120";
530 PRINT #2, CHR$(34); ",,2:VGALOGO.LGO, 2:VDDVBE.386, 2:VGADIB.3GR,,2:VGALOGO.RLE,"; ID$
540 NEXT K
550 NEXT J
560 PRINT #2, ""
570 REM Settings
580 FOR J = 0 TO I: REM Cycle AGAIN over all valid modes
590 FOR K = 0 TO 1: REM Create both large and small font entries for every mode
600 IF K = 0 THEN FS$ = "S" ELSE FS$ = "L"
610 PRINT #2, "[VBE"; RIGHT$(STR$(J), LEN(STR$(J)) - 1); FS$; "]"
620 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "W"; CHR$(34); ","; CHR$(34); "Width="; RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0))) - 1); CHR$(34)
630 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "H"; CHR$(34); ","; CHR$(34); "Height="; RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1))) - 1); CHR$(34)
640 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "D"; CHR$(34); ","; CHR$(34); "Depth="; RIGHT$(STR$(MO(J, 2)), LEN(STR$(MO(J, 2))) - 1); CHR$(34)
650 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "F"; CHR$(34); ","; CHR$(34); "fontsize=";
660 IF FS$ = "S" THEN PRINT #2, "small";  ELSE PRINT #2, "large";
670 PRINT #2, CHR$(34): PRINT #2, ""
680 NEXT K
690 NEXT J
700 CLOSE 2
710 SYSTEM
