5 REM OEMSETUP.INF generator for PluMGMK VBE/SVGA Driver
7 REM Tested on GW-BASIC 3.23 and QBASIC 1.1
10 DR$ = "VBESVGA.DRV"
20 DIM MO(255, 2): REM Distinct video modes (width, height, depth)
25 REM Collect valid video modes for Windows
30 SHELL "VIDMODES > VIDMODES.TMP"
40 OPEN "VIDMODES.TMP" FOR INPUT AS #1
50 WHILE A$ <> "Available modes:"
60 LINE INPUT #1, A$
70 WEND
80 I = 0
90 WHILE NOT EOF(1)
100 LINE INPUT #1, A$
110 IF LEN(A$) = 0 THEN 240: REM continue
120 WI% = VAL(MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2))
130 HE% = VAL(MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1))
140 DE% = VAL(MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, INSTR(INSTR(A$, " ") + 1, A$, " ") - INSTR(INSTR(A$, "*") + 1, A$, "*") - 1))
150 IF WI% < 640 OR HE% < 480 THEN 240: REM continue
160 IF DE% > 24 THEN DE% = 24: REM Max value allowed for Depth is 24
170 FOR J = 0 TO I
180 IF MO(J, 0) = WI% AND MO(J, 1) = HE% AND MO(J, 2) = DE% THEN 240: REM continue (avoid duplicates)
190 NEXT J
200 MO(I, 0) = WI%
210 MO(I, 1) = HE%
220 MO(I, 2) = DE%
230 I = I + 1
240 WEND
250 CLOSE 1
260 KILL "VIDMODES.TMP"
270 I = I - 1
280 REM Write OEMSETUP.INF file
290 OPEN "OEMSETUP.INF" FOR OUTPUT AS #2
300 REM Header
310 PRINT #2, "Version="; CHR$(34); "0.0.1"; CHR$(34)
320 PRINT #2, ""
330 PRINT #2, "[disks]"
340 PRINT #2, "    1 =., "; CHR$(34); "PluMGMK VBE/SVGA Driver"; CHR$(34); ",disk1"
350 PRINT #2, ""
360 PRINT #2, "[display]"
370 REM Entries
380 FOR J = 0 TO I: REM Cycle over all valid modes
390 FOR K = 0 TO 1: REM Create both large and small font entries for every mode
400 IF K = 0 THEN FS$ = "S" ELSE FS$ = "L"
410 ID$ = "VBE" + RIGHT$(STR$(J), LEN(STR$(J)) - 1) + FS$
420 PRINT #2, ID$; "=1:"; DR$; ","; CHR$(34); "VBE/SVGA "; RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0))) - 1); "x"; RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1))) - 1); "x";
430 IF MO(J, 2) = 8 THEN PRINT #2, "256";
440 IF MO(J, 2) = 16 THEN PRINT #2, "64k";
450 IF MO(J, 2) = 24 THEN PRINT #2, "16M";
460 PRINT #2, " ";
470 IF FS$ = "S" THEN PRINT #2, "Small";  ELSE PRINT #2, "Large";
480 PRINT #2, " fonts"; CHR$(34); ","; CHR$(34); "100,";
490 IF FS$ = "S" THEN PRINT #2, "96,96";  ELSE PRINT #2, "120,120";
500 PRINT #2, CHR$(34); ",,2:VGALOGO.LGO, 2:VDDVBE.386, 2:VGADIB.3GR,,2:VGALOGO.RLE,"; ID$
510 NEXT K
520 NEXT J
530 PRINT #2, ""
540 REM Settings
550 FOR J = 0 TO I: REM Cycle AGAIN over all valid modes
560 FOR K = 0 TO 1: REM Create both large and small font entries for every mode
570 IF K = 0 THEN FS$ = "S" ELSE FS$ = "L"
580 PRINT #2, "[VBE"; RIGHT$(STR$(J), LEN(STR$(J)) - 1); FS$; "]"
590 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "W"; CHR$(34); ","; CHR$(34); "Width="; RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0))) - 1); CHR$(34)
600 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "H"; CHR$(34); ","; CHR$(34); "Height="; RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1))) - 1); CHR$(34)
610 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "D"; CHR$(34); ","; CHR$(34); "Depth="; RIGHT$(STR$(MO(J, 2)), LEN(STR$(MO(J, 2))) - 1); CHR$(34)
620 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "F"; CHR$(34); ","; CHR$(34); "fontsize=";
630 IF FS$ = "S" THEN PRINT #2, "small";  ELSE PRINT #2, "large";
640 PRINT #2, CHR$(34): PRINT #2, ""
650 NEXT K
660 NEXT J
670 CLOSE 2
680 SYSTEM
