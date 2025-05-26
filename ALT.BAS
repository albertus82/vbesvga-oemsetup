10 DR$ = "VBESVGA.DRV"
20 SHELL "VIDMODES > VIDMODES.TMP"
30 OPEN "VIDMODES.TMP" FOR INPUT AS #1
130 WHILE A$ <> "Available modes:"
140 LINE INPUT #1, A$
150 WEND
160 DIM MO(255, 2): REM Distinct video modes (width, height, depth)
170 I = 0
180 WHILE NOT EOF(1)
190 LINE INPUT #1, A$
200 IF LEN(A$) = 0 THEN 361: REM continue
220 WI% = VAL(MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2))
240 HE% = VAL(MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1))
260 DE% = VAL(MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, INSTR(INSTR(A$, " ") + 1, A$, " ") - INSTR(INSTR(A$, "*") + 1, A$, "*") - 1))
270 IF WI% < 640 OR HE% < 480 THEN 361: REM continue
280 IF DE% > 24 THEN DE% = 24: REM Max value allowed for Depth is 24
300 FOR J = 0 TO I
310 IF MO(J, 0) = WI% AND MO(J, 1) = HE% AND MO(J, 2) = DE% THEN 361: REM continue
320 NEXT J
330 MO(I, 0) = WI%
340 MO(I, 1) = HE%
350 MO(I, 2) = DE%
360 I = I + 1
361 WEND
362 CLOSE 1
363 KILL "VIDMODES.TMP"
364 REM Write OEMSETUP.INF file
365 OPEN "OEMSETUP.INF" FOR OUTPUT AS #2
366 REM Header
367 PRINT #2, "Version="; CHR$(34); "0.0.1"; CHR$(34)
368 PRINT #2, ""
369 PRINT #2, "[disks]"
370 PRINT #2, "    1 =., "; CHR$(34); "PluMGMK VBE/SVGA Driver"; CHR$(34); ",disk1"
371 PRINT #2, ""
372 PRINT #2, "[display]"
374 REM Entries
375 FOR J = 0 TO I: REM Cycle over all valid modes
383 FOR K = 0 TO 1: REM Create both large and small font entries for every video mode
388 IF K = 0 THEN FS$ = "S" ELSE FS$ = "L"
389 ID$ = "VBE"; RIGHT$(STR$(I), LEN(STR$(I))); FS$
390 PRINT #2, ID$; "=1:"; DR$; ","; CHR$(34); "VBE/SVGA "; RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0)))); "x"; RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1)))); "x";
400 IF MO(J, 2) = 8 THEN PRINT #2, "256";
410 IF MO(J, 2) = 16 THEN PRINT #2, "64k";
420 IF MO(J, 2) = 24 THEN PRINT #2, "16M";
430 PRINT #2, " ";
440 IF FS$ = "S" THEN PRINT #2, "Small";  ELSE PRINT #2, "Large";
450 PRINT #2, " fonts"; CHR$(34); ","; CHR$(34); "100,";
460 IF FS$ = "S" THEN PRINT #2, "96,96";  ELSE PRINT #2, "120,120";
470 PRINT #2, CHR$(34); ",,2:VGALOGO.LGO, 2:VDDVBE.386, 2:VGADIB.3GR,,2:VGALOGO.RLE,"; ID$
560 NEXT K
570 NEXT J
571 REM Settings
572 FOR J = 0 TO I: REM Cycle again over all valid modes
578 FOR K = 0 TO 1: REM Create both large and small font entries for every video mode
581 IF K = 0 THEN FS$ = "S" ELSE FS$ = "L"
583 PRINT #2, "[VBE"; RIGHT$(STR$(I), LEN(STR$(I))); FS$; "]"
585 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "W"; CHR$(34); ","; CHR$(34); "Width="; RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0)))); CHR$(34)
587 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "H"; CHR$(34); ","; CHR$(34); "Height="; RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1)))); CHR$(34)
589 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "D"; CHR$(34); ","; CHR$(34); "Depth="; RIGHT$(STR$(MO(J, 2)), LEN(STR$(MO(J, 2)))); CHR$(34)
591 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "F"; CHR$(34); ","; CHR$(34); "fontsize=";
593 IF FS$ = "S" THEN PRINT #2, "small";  ELSE PRINT #2, "large";
595 PRINT #2, CHR$(34): PRINT #2, ""
597 NEXT K
598 NEXT J
600 PRINT #2, ""
610 CLOSE 2
690 SYSTEM
