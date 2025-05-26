10 DR$ = "VBESVGA.DRV"
20 SHELL "VIDMODES > VIDMODES.TMP"
30 OPEN "VIDMODES.TMP" FOR INPUT AS #1
40 OPEN "OEMSETUP.INF" FOR OUTPUT AS #2
50 OPEN "OEMSETUP.TMP" FOR OUTPUT AS #3
60 REM OEMSETUP.INF header
70 PRINT #2, "Version="; CHR$(34); "0.0.1"; CHR$(34)
80 PRINT #2, ""
90 PRINT #2, "[disks]"
100 PRINT #2, "    1 =., "; CHR$(34); "PluMGMK VBE/SVGA Driver"; CHR$(34); ",disk1"
110 PRINT #2, ""
120 PRINT #2, "[display]"
130 WHILE A$ <> "Available modes:"
140 LINE INPUT #1, A$
150 WEND
160 DIM MO(255, 2): REM Distinct video modes
170 I = 0
180 WHILE NOT EOF(1)
190 LINE INPUT #1, A$
200 IF LEN(A$) = 0 THEN 570: REM continue
210 ID$ = LEFT$(A$, INSTR(A$, ":") - 1)
220 WI$ = MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2)
230 WI% = VAL(WI$)
240 HE$ = MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1)
250 HE% = VAL(HE$)
260 DE$ = MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, INSTR(INSTR(A$, " ") + 1, A$, " ") - INSTR(INSTR(A$, "*") + 1, A$, "*") - 1)
270 DE% = VAL(DE$)
280 IF DE% > 24 THEN DE% = 24: DE$ = "24": REM Max value allowed for Depth is 24
290 IF WI% < 640 OR HE% < 480 THEN 570: REM continue
300 FOR J = 0 TO I
310 IF MO(J, 0) = WI% AND MO(J, 1) = HE% AND MO(J, 2) = DE% THEN 570: REM continue
320 NEXT J
330 MO(I, 0) = WI%
340 MO(I, 1) = HE%
350 MO(I, 2) = DE%
360 I = I + 1
370 FOR K = 0 TO 1: REM Create both large and small font entries for every video mode
380 IF K = 0 THEN FS$ = "S" ELSE FS$ = "L"
390 PRINT #2, "VBE"; ID$; FS$; "=1:"; DR$; ","; CHR$(34); "VBE/SVGA "; WI$; "x"; HE$; "x";
400 IF DE% = 8 THEN PRINT #2, "256";
410 IF DE% = 16 THEN PRINT #2, "64k";
420 IF DE% = 24 THEN PRINT #2, "16M";
430 PRINT #2, " ";
440 IF FS$ = "S" THEN PRINT #2, "Small";  ELSE PRINT #2, "Large";
450 PRINT #2, " fonts"; CHR$(34); ","; CHR$(34); "100,";
460 IF FS$ = "S" THEN PRINT #2, "96,96";  ELSE PRINT #2, "120,120";
470 PRINT #2, CHR$(34); ",,2:VGALOGO.LGO, 2:VDDVBE.386, 2:VGADIB.3GR,,2:VGALOGO.RLE,VBE"; ID$; FS$
480 REM Settings for each entry are temporarily saved to another file
490 PRINT #3, "[VBE"; ID$; FS$; "]"
500 PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "W"; CHR$(34); ","; CHR$(34); "Width="; WI$; CHR$(34)
510 PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "H"; CHR$(34); ","; CHR$(34); "Height="; HE$; CHR$(34)
520 PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "D"; CHR$(34); ","; CHR$(34); "Depth="; DE$; CHR$(34)
530 PRINT #3, ",,system.ini,"; DR$; ","; CHR$(34); "F"; CHR$(34); ","; CHR$(34); "fontsize=";
540 IF FS$ = "S" THEN PRINT #3, "small";  ELSE PRINT #3, "large";
550 PRINT #3, CHR$(34): PRINT #3, ""
560 NEXT K
570 WEND
580 CLOSE 3, 1
590 KILL "VIDMODES.TMP"
600 PRINT #2, ""
610 REM Compose the final INF file
620 OPEN "OEMSETUP.TMP" FOR INPUT AS #1
630 WHILE NOT EOF(1)
640 LINE INPUT #1, B$
650 PRINT #2, B$
660 WEND
670 CLOSE 2, 1
680 KILL "OEMSETUP.TMP"
690 SYSTEM
