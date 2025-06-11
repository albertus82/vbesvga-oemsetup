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
220 GOSUB 620
230 WEND
240 CLOSE 1
250 KILL "vidmodes.out"
260 REM Write OEMSETUP.INF file
270 OPEN "O", 2, "oemsetup.inf"
280 REM Header
290 PRINT #2, "[disks]"
300 PRINT #2, "V=. ," + CHR$(34) + "PluMGMK VBE SVGA driver path" + CHR$(34) + ",diskV"
310 PRINT #2, "2=. ," + CHR$(34) + "Microsoft Windows 3.x Disk #2" + CHR$(34) + ",disk2"
320 PRINT #2, ""
330 PRINT #2, "[display]"
340 REM Entries
350 FOR J = 0 TO I: REM Cycle over all valid modes
360 FOR FS = 96 TO 120 STEP 24: REM Create both large and small font entries for every mode
370 K$ = "vbe" + RIGHT$(STR$(J), LEN(STR$(J)) - 1): IF FS = 96 THEN K$ = K$ + "s" ELSE K$ = K$ + "l"
380 PRINT #2, K$ + "=V:vbesvga.drv," + CHR$(34) + "VBE SVGA " + RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0))) - 1) + "x" + RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1))) - 1) + "x";
390 IF MO(J, 2) = 8 THEN PRINT #2, "256";
400 IF MO(J, 2) = 15 THEN PRINT #2, "32k";
410 IF MO(J, 2) = 16 THEN PRINT #2, "64k";
420 IF MO(J, 2) = 24 THEN PRINT #2, "16M";
430 PRINT #2, " ";
440 IF FS = 96 THEN PRINT #2, "Small";  ELSE PRINT #2, "Large";
450 PRINT #2, " fonts" + CHR$(34) + "," + CHR$(34) + "100," + RIGHT$(STR$(FS), LEN(STR$(FS)) - 1) + "," + RIGHT$(STR$(FS), LEN(STR$(FS)) - 1) + CHR$(34) + ",2:vgacolor.2gr,2:vgalogo.lgo,V:vddvbe.386,2:vgadib.3gr,,2:vgalogo.rle," + K$
460 NEXT FS, J
470 REM Settings
480 FOR J = 0 TO I: REM Cycle AGAIN over all valid modes
490 FOR FS = 96 TO 120 STEP 24: REM Create both large and small font entries for every mode
500 K$ = "vbe" + RIGHT$(STR$(J), LEN(STR$(J)) - 1): IF FS = 96 THEN K$ = K$ + "s" ELSE K$ = K$ + "l"
510 PRINT #2, ""
520 PRINT #2, "[" + K$ + "]"
530 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "width=" + CHR$(34) + "," + CHR$(34) + "width=" + RIGHT$(STR$(MO(J, 0)), LEN(STR$(MO(J, 0))) - 1) + CHR$(34)
540 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "height=" + CHR$(34) + "," + CHR$(34) + "height=" + RIGHT$(STR$(MO(J, 1)), LEN(STR$(MO(J, 1))) - 1) + CHR$(34)
550 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "depth=" + CHR$(34) + "," + CHR$(34) + "depth=" + RIGHT$(STR$(MO(J, 2)), LEN(STR$(MO(J, 2))) - 1) + CHR$(34)
560 PRINT #2, ",,system.ini,vbesvga.drv," + CHR$(34) + "fontsize=" + CHR$(34) + "," + CHR$(34) + "fontsize=";
570 IF FS = 96 THEN PRINT #2, "small";  ELSE PRINT #2, "large";
580 PRINT #2, CHR$(34)
590 NEXT FS, J
600 CLOSE 2
610 SYSTEM: REM End of program
620 REM Begin of the routine that collects valid video modes
630 IF LEN(A$) = 0 OR INSTR(A$, "NG for VBESVGA.DRV") <> 0 THEN RETURN: REM Skip empty lines and "no good" modes
640 WI% = VAL(MID$(A$, INSTR(A$, ":") + 2, INSTR(A$, "*") - INSTR(A$, ":") - 2))
650 HE% = VAL(MID$(A$, INSTR(A$, "*") + 1, INSTR(INSTR(A$, "*") + 1, A$, "*") - INSTR(A$, "*") - 1))
660 IF WI% < 640 OR HE% < 480 THEN RETURN: REM Ignore useless resolutions
670 DE% = VAL(MID$(A$, INSTR(INSTR(A$, "*") + 1, A$, "*") + 1, INSTR(INSTR(A$, " ") + 1, A$, " ") - INSTR(INSTR(A$, "*") + 1, A$, "*") - 1))
680 IF DE% > 24 THEN DE% = 24: REM Max value allowed for Depth is 24
690 FOR J = 0 TO I
700 IF MO(J, 0) = WI% AND MO(J, 1) = HE% AND MO(J, 2) = DE% THEN RETURN: REM Avoid duplicates
710 NEXT J
720 I = I + 1
730 MO(I, 0) = WI%
740 MO(I, 1) = HE%
750 MO(I, 2) = DE%
760 RETURN: REM End of the routine that collects valid video modes
