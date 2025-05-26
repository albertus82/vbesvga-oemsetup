10 DR$ = "VBESVGA.DRV"
20 SHELL "VIDMODES > VIDMODES.TMP"
30 OPEN "VIDMODES.TMP" FOR INPUT AS #1
130 WHILE A$ <> "Available modes:"
140 LINE INPUT #1, A$
150 WEND
160 DIM MO(255, 3): REM Distinct video modes (ID, width, height, depth)
170 I = 0
180 WHILE NOT EOF(1)
190 LINE INPUT #1, A$
200 IF LEN(A$) = 0 THEN 361: REM continue
210 ID$ = LEFT$(A$, INSTR(A$, ":") - 1)
220 WI$ = MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2)
240 HE$ = MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1)
260 DE$ = MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, INSTR(INSTR(A$, " ") + 1, A$, " ") - INSTR(INSTR(A$, "*") + 1, A$, "*") - 1)
280 IF VAL(DE$) > 24 THEN DE$ = "24": REM Max value allowed for Depth is 24
290 IF VAL(WI$) < 640 OR VAL(HE$) < 480 THEN 361: REM continue
300 FOR J = 0 TO I
310 IF MO(J, 1) = WI$ AND MO(J, 2) = HE$ AND MO(J, 3) = DE$ THEN 361: REM continue
320 NEXT J
330 MO(I, 0) = ID$
330 MO(I, 1) = WI$
340 MO(I, 2) = HE$
350 MO(I, 3) = DE$
360 I = I + 1
361 WEND
362 CLOSE 1
363 KILL "VIDMODES.TMP"
364 OPEN "OEMSETUP.INF" FOR OUTPUT AS #2
366 REM OEMSETUP.INF header
367 PRINT #2, "Version="; CHR$(34); "0.0.1"; CHR$(34)
368 PRINT #2, ""
369 PRINT #2, "[disks]"
370 PRINT #2, "    1 =., "; CHR$(34); "PluMGMK VBE/SVGA Driver"; CHR$(34); ",disk1"
371 PRINT #2, ""
372 PRINT #2, "[display]"
374 REM Entries
375 FOR J = 0 TO I
376 ID$ = MO(J, 0)
379 WI$ = MO(J, 1)
380 HE$ = MO(J, 2)
381 DE$ = MO(J, 3)
383 FOR K = 0 TO 1: REM Create both large and small font entries for every video mode
388 IF K = 0 THEN FS$ = "S" ELSE FS$ = "L"
390 PRINT #2, "VBE"; ID$; FS$; "=1:"; DR$; ","; CHR$(34); "VBE/SVGA "; WI$; "x"; HE$; "x";
400 IF DE% = 8 THEN PRINT #2, "256";
410 IF DE% = 16 THEN PRINT #2, "64k";
420 IF DE% = 24 THEN PRINT #2, "16M";
430 PRINT #2, " ";
440 IF FS$ = "S" THEN PRINT #2, "Small";  ELSE PRINT #2, "Large";
450 PRINT #2, " fonts"; CHR$(34); ","; CHR$(34); "100,";
460 IF FS$ = "S" THEN PRINT #2, "96,96";  ELSE PRINT #2, "120,120";
470 PRINT #2, CHR$(34); ",,2:VGALOGO.LGO, 2:VDDVBE.386, 2:VGADIB.3GR,,2:VGALOGO.RLE,VBE"; ID$; FS$
560 NEXT K
570 NEXT J
571 REM Settings
572 FOR J = 0 TO I
573 ID$ = MO(J, 0)
574 WI$ = MO(J, 1)
575 HE$ = MO(J, 2)
576 DE$ = MO(J, 3)
578 FOR K = 0 TO 1: REM Create both large and small font entries for every video mode
581 IF K = 0 THEN FS$ = "S" ELSE FS$ = "L" 
583 PRINT #2, "[VBE"; ID$; FS$; "]"
585 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "W"; CHR$(34); ","; CHR$(34); "Width="; WI$; CHR$(34)
587 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "H"; CHR$(34); ","; CHR$(34); "Height="; HE$; CHR$(34)
589 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "D"; CHR$(34); ","; CHR$(34); "Depth="; DE$; CHR$(34)
591 PRINT #2, ",,system.ini,"; DR$; ","; CHR$(34); "F"; CHR$(34); ","; CHR$(34); "fontsize=";
593 IF FS$ = "S" THEN PRINT #2, "small";  ELSE PRINT #2, "large";
595 PRINT #2, CHR$(34): PRINT #2, ""
597 NEXT K
598 NEXT J
600 PRINT #2, ""
610 CLOSE 2
690 SYSTEM
