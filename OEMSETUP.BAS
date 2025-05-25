10 DR$ = "VBESVGA.DRV"
20 SHELL "VIDMODES > VIDMODES.TMP"
30 OPEN "VIDMODES.TMP" FOR INPUT AS #1
40 OPEN "OEMSETUP.INF" FOR OUTPUT AS #2
50 OPEN "OEMSETUP.TMP" FOR OUTPUT AS #3
60 REM OEMSETUP.INF header
70 PRINT #2, "Version="; CHR$(34); "0.0.1"; CHR$(34)
80 PRINT #2, ""
90 PRINT #2, "[disks]"
100 PRINT #2, "    1 =., "; CHR$(34); "PluMGMK VBE SVGA Driver"; CHR$(34); ",disk1"
110 PRINT #2, ""
120 PRINT #2, "[display]"
130 WHILE A$ <> "Available modes:"
140 LINE INPUT #1, A$
150 WEND
160 DIM M(255, 2): REM Distinct video modes
170 I = 0
180 WHILE NOT EOF(1)
190 LINE INPUT #1, A$
200 IF LEN(A$) = 0 THEN 530: REM continue
210 ID$ = LEFT$(A$, INSTR(A$, ":") - 1)
220 H% = VAL(MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2))
230 V% = VAL(MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1))
240 C% = VAL(MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, 2))
250 IF H% < 640 OR V% < 480 THEN 530: REM continue
260 IF (C% > 24) THEN C% = 24: REM Max value allowed for Depth is 24
270 FOR J = 0 TO I
280 IF M(J, 0) = H% AND M(J, 1) = V% AND M(J, 2) = C% THEN 530: REM continue
290 NEXT J
300 M(I, 0) = H%
310 M(I, 1) = V%
320 M(I, 2) = C%
330 I = I + 1
340 IF C% = 8 THEN C$ = "256"
350 IF C% = 16 THEN C$ = "64k"
360 IF C% = 24 THEN C$ = "16M"
370 FOR K = 0 TO 1: REM Create both large and small font entries for every video mode
380 IF K = 0 THEN FS$ = "S" ELSE FS$ = "L"
390 PRINT #2, "VBE"; ID$; FS$; "=1:"; DR$; ","; CHR$(34); "VBE/SVGA"; STR$(H%); "x"; RIGHT$(STR$(V%), LEN(STR$(V%)) - 1); "x"; C$; " ";
400 IF FS$ = "S" THEN PRINT #2, "Small";  ELSE PRINT #2, "Large";
410 PRINT #2, " fonts"; CHR$(34); ","; CHR$(34); "100,";
420 IF FS$ = "S" THEN PRINT #2, "96,96";  ELSE PRINT #2, "120,120";
430 PRINT #2, CHR$(34); ",,2:VGALOGO.LGO, 2:VDDVBE.386, 2:VGADIB.3GR,,2:VGALOGO.RLE,VBE"; ID$; FS$
440 REM Settings for each entry are temporarily saved to another file
450 PRINT #3, "[VBE"; ID$; FS$; "]"
460 PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "W"; CHR$(34); ","; CHR$(34); "Width="; RIGHT$(STR$(H%), LEN(STR$(H%)) - 1); CHR$(34)
470 PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "H"; CHR$(34); ","; CHR$(34); "Height="; RIGHT$(STR$(V%), LEN(STR$(V%)) - 1); CHR$(34)
480 PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "D"; CHR$(34); ","; CHR$(34); "Depth="; RIGHT$(STR$(C%), LEN(STR$(C%)) - 1); CHR$(34)
490 PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "F"; CHR$(34); ","; CHR$(34); "fontsize=";
500 IF FS$ = "S" THEN PRINT #3, "small";  ELSE PRINT #3, "large";
510 PRINT #3, CHR$(34): PRINT #3, ""
520 NEXT K
530 WEND
540 CLOSE 3, 1
550 PRINT #2, ""
560 REM Compose the final INF file
570 OPEN "OEMSETUP.TMP" FOR INPUT AS #1
580 WHILE NOT EOF(1)
590 LINE INPUT #1, B$
600 PRINT #2, B$
610 WEND
620 CLOSE 2, 1
630 KILL "OEMSETUP.TMP"
640 KILL "VIDMODES.TMP"
650 SYSTEM
