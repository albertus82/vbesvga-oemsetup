100 REM OEMSETUP.INF generator for PluMGMK VBE SVGA driver
110 REM Tested on GW-BASIC 3.2x and QBasic 1.x
120 DIM MO(255, 2): REM Distinct video modes (width, height, depth)
130 REM Collect valid video modes for Windows
140 SHELL "vidmodes > vidmodes.out"
150 OPEN "I", 1, "vidmodes.out"
160 WHILE A$ <> "Available modes:"
170 LINE INPUT #1, A$: REM Skip line
180 WEND
190 I = -1
200 WHILE NOT EOF(1)
210 LINE INPUT #1, A$
220 GOSUB 630
230 WEND
240 CLOSE 1
250 KILL "vidmodes.out"
270 REM Write OEMSETUP.INF file
280 OPEN "O", 2, "oemsetup.inf"
290 REM Header
300 PRINT #2, "[disks]"
310 PRINT #2, "V=. ," + CHR$(34) + "PluMGMK VBE SVGA driver path" + CHR$(34) + ",diskV"
320 PRINT #2, "2=. ," + CHR$(34) + "Microsoft Windows 3.x Disk #2" + CHR$(34) + ",disk2"
330 PRINT #2, ""
340 PRINT #2, "[display]"
350 REM Entries
360 FOR J = 0 TO I: REM Cycle over all valid modes
370 FOR FS = 96 TO 120 STEP 24: REM Create both large and small font entries for every mode
380 K$ = "vbe" + RIGHT$(STR$(J), LEN(STR$(J)) - 1): IF FS = 96 THEN K$ = K$ + "s" ELSE K$ = K$ + "l"
390 PRINT #2, K$ + "=V:vbesvga.drv," + CHR$(34) + "VBE SVGA " + RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0))) - 1) + "x" + RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1))) - 1) + "x";
400 IF MO(J, 2) = 8 THEN PRINT #2, "256";
410 IF MO(J, 2) = 15 THEN PRINT #2, "32k";
420 IF MO(J, 2) = 16 THEN PRINT #2, "64k";
430 IF MO(J, 2) = 24 THEN PRINT #2, "16M";
440 PRINT #2, " ";
450 IF FS = 96 THEN PRINT #2, "Small";  ELSE PRINT #2, "Large";
460 PRINT #2, " fonts" + CHR$(34) + "," + CHR$(34) + "100," + RIGHT$(STR$(FS), LEN(STR$(FS)) - 1) + "," + RIGHT$(STR$(FS), LEN(STR$(FS)) - 1) + CHR$(34) + ",2:vgacolor.2gr,2:vgalogo.lgo,V:vddvbe.386,2:vgadib.3gr,,2:vgalogo.rle," + K$
470 NEXT FS, J
480 REM Settings
490 FOR J = 0 TO I: REM Cycle AGAIN over all valid modes
500 FOR FS = 96 TO 120 STEP 24: REM Create both large and small font entries for every mode
510 K$ = "vbe" + RIGHT$(STR$(J), LEN(STR$(J)) - 1): IF FS = 96 THEN K$ = K$ + "s" ELSE K$ = K$ + "l"
520 PRINT #2, ""
530 PRINT #2, "[" + K$ + "]"
540 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "width=" + CHR$(34) + "," + CHR$(34) + "width=" + RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0))) - 1) + CHR$(34)
550 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "height=" + CHR$(34) + "," + CHR$(34) + "height=" + RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1))) - 1) + CHR$(34)
560 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "depth=" + CHR$(34) + "," + CHR$(34) + "depth=" + RIGHT$(STR$(MO(J, 2)), LEN(STR$(MO(J, 2))) - 1) + CHR$(34)
570 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "fontsize=" + CHR$(34) + "," + CHR$(34) + "fontsize=";
580 IF FS = 96 THEN PRINT #2, "small";  ELSE PRINT #2, "large";
590 PRINT #2, CHR$(34)
600 NEXT FS, J
610 CLOSE 2
620 SYSTEM: REM End of program
630 REM Begin of the routine that collects valid video modes
640 IF LEN(A$) = 0 OR INSTR(A$, "NG for VBESVGA.DRV") <> 0 THEN RETURN: REM Skip empty lines and "no good" modes
650 WI% = VAL(MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2))
660 HE% = VAL(MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1))
670 IF WI% < 640 OR HE% < 480 THEN RETURN: REM Ignore useless resolutions
680 DE% = VAL(MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, INSTR(INSTR(A$, " ") + 1, A$, " ") - INSTR(INSTR(A$, "*") + 1, A$, "*") - 1))
690 IF DE% > 24 THEN DE% = 24: REM Max value allowed for Depth is 24
700 FOR J = 0 TO I
710 IF MO(J, 0) = WI% AND MO(J, 1) = HE% AND MO(J, 2) = DE% THEN RETURN: REM Avoid duplicates
720 NEXT J
730 I = I + 1
740 MO(I, 0) = WI%
750 MO(I, 1) = HE%
760 MO(I, 2) = DE%
770 RETURN: REM End of the routine that collects valid video modes
