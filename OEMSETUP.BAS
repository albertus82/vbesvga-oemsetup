10 REM OEMSETUP.INF generator for PluMGMK VBE SVGA driver
20 REM Tested on GW-BASIC 3.2x and QBasic 1.x
30 DIM MO(255, 2): REM Distinct video modes (width, height, depth)
40 REM Collect valid video modes for Windows
50 SHELL "vidmodes > vidmodes.out"
60 OPEN "I", 1, "vidmodes.out"
70 WHILE A$ <> "Available modes:"
80 LINE INPUT #1, A$: REM Skip line
90 WEND
100 I = 0
110 WHILE NOT EOF(1)
120 GOSUB 810
260 WEND
270 CLOSE 1
280 KILL "vidmodes.out"
290 I = I - 1
300 REM Write OEMSETUP.INF file
310 OPEN "O", 2, "oemsetup.inf"
320 REM Header
330 PRINT #2, "[disks]"
340 PRINT #2, "V=. ," + CHR$(34) + "PluMGMK VBE SVGA driver path" + CHR$(34) + ",diskV"
350 PRINT #2, "2=. ," + CHR$(34) + "Microsoft Windows 3.x Disk #2" + CHR$(34) + ",disk2"
360 PRINT #2, ""
370 PRINT #2, "[display]"
380 REM Entries
390 FOR J = 0 TO I: REM Cycle over all valid modes
400 FOR K = 0 TO 1: REM Create both large and small font entries for every mode
410 IF K = 0 THEN FS$ = "s" ELSE FS$ = "l"
420 PRINT #2, "vbe" + RIGHT$(STR$(J), LEN(STR$(J)) - 1) + FS$ + "=V:vbesvga.drv," + CHR$(34) + "VBE SVGA " + RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0))) - 1) + "x" + RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1))) - 1) + "x";
430 IF MO(J, 2) = 8 THEN PRINT #2, "256";
440 IF MO(J, 2) = 15 THEN PRINT #2, "32k";
450 IF MO(J, 2) = 16 THEN PRINT #2, "64k";
460 IF MO(J, 2) = 24 THEN PRINT #2, "16M";
470 PRINT #2, " ";
480 IF FS$ = "s" THEN PRINT #2, "Small";  ELSE PRINT #2, "Large";
490 PRINT #2, " fonts" + CHR$(34) + "," + CHR$(34) + "100,";
500 IF FS$ = "s" THEN PRINT #2, "96,96";  ELSE PRINT #2, "120,120";
510 PRINT #2, CHR$(34) + ",2:vgacolor.2gr,2:vgalogo.lgo,V:vddvbe.386,2:vgadib.3gr,,2:vgalogo.rle,vbe" + RIGHT$(STR$(J), LEN(STR$(J)) - 1) + FS$
520 NEXT K, J
530 REM Settings
540 FOR J = 0 TO I: REM Cycle AGAIN over all valid modes
550 FOR K = 0 TO 1: REM Create both large and small font entries for every mode
560 IF K = 0 THEN FS$ = "s" ELSE FS$ = "l"
570 PRINT #2, ""
580 PRINT #2, "[vbe" + RIGHT$(STR$(J), LEN(STR$(J)) - 1) + FS$ + "]"
590 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "width=" + CHR$(34) + "," + CHR$(34) + "width=" + RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0))) - 1) + CHR$(34)
600 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "height=" + CHR$(34) + "," + CHR$(34) + "height=" + RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1))) - 1) + CHR$(34)
610 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "depth=" + CHR$(34) + "," + CHR$(34) + "depth=" + RIGHT$(STR$(MO(J, 2)), LEN(STR$(MO(J, 2))) - 1) + CHR$(34)
620 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "fontsize=" + CHR$(34) + "," + CHR$(34) + "fontsize=";
630 IF FS$ = "s" THEN PRINT #2, "small";  ELSE PRINT #2, "large";
640 PRINT #2, CHR$(34)
650 NEXT K, J
660 CLOSE 2
670 SYSTEM: REM End of program
810 REM Begin of the routine to collect valid video modes
820 LINE INPUT #1, A$
830 IF LEN(A$) = 0 OR INSTR(A$, "NG for VBESVGA.DRV") <> 0 THEN RETURN: REM Skip empty lines and "no good" modes
840 WI% = VAL(MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2))
850 HE% = VAL(MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1))
860 IF WI% < 640 OR HE% < 480 THEN RETURN: REM Ignore useless resolutions
870 DE% = VAL(MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, INSTR(INSTR(A$, " ") + 1, A$, " ") - INSTR(INSTR(A$, "*") + 1, A$, "*") - 1))
880 IF DE% > 24 THEN DE% = 24: REM Max value allowed for Depth is 24
890 FOR J = 0 TO I
900 IF MO(J, 0) = WI% AND MO(J, 1) = HE% AND MO(J, 2) = DE% THEN RETURN: REM Avoid duplicates
910 NEXT J
920 MO(I, 0) = WI%
930 MO(I, 1) = HE%
940 MO(I, 2) = DE%
950 I = I + 1
960 RETURN: REM End of the routine to collect valid video modes
