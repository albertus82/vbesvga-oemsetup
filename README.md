# oemsetup.inf for vbesvga.drv

`OEMSETUP.INF` generator for [vbesvga.drv](https://github.com/PluMGMK/vbesvga.drv), obviously written in an obsolete programming language so that it can be easily executed from DOS.

### Prerequisites

* Setup Windows 3.1x with the default VGA driver (640x480x16)
* Make sure you have a BASIC interpreter like **GW-BASIC** or **QBasic**
* Have your Windows Installation Disk 2 handy.

### Usage

1. Place [`OEMSETUP.BAS`](OEMSETUP.BAS) file in the same directory that contains the driver files, including `VIDMODES.COM`
2. Run one of the following commands depending on the BASIC interpreter you have:
   #### GW-BASIC
   ```
   GWBASIC OEMSETUP
   ```
   #### QBASIC
   ```
   QBASIC /RUN OEMSETUP
   ```
3. Start Windows 3.1x
4. ***Main*** > ***Windows Setup***
5. ***Options*** > ***Change system settings...***
6. ***Display*** > ***Other display (Requires disk from OEM)...***
7. Provide the path where the driver files are located
8. Select the desired video mode

### Troubleshooting

#### Out-of-memory error in DOS mode setup

Sometimes the generated `OEMSETUP.INF` cannot be used from Windows Setup in DOS mode (`%WINDIR%\SETUP.EXE`) because it's too large.

If you're stuck in DOS mode due to video driver issues and cannot change the driver from `%WINDIR%\SETUP.EXE` due to out-of-memory errors, delete the `%WINDIR%\SYSTEM\OEMn.INF` file corresponding to this driver (check inside with `EDIT` or similar beforehand), then launch `%WINDIR%\SETUP.EXE` again and select **VGA**.

---

# Explanation by Copilot

This GW-BASIC/QBasic program, OEMSETUP.BAS, is an automatic generator for an OEMSETUP.INF file used to install the PluMGMK VBE SVGA driver in Windows 3.x. It analyzes available video modes and writes the necessary installer entries. Here’s a detailed breakdown:

---

## What does this program do?

- **Purpose:**  
  It reads video modes supported by your system, filters them for Windows compatibility, and auto-generates a Windows 3.x OEMSETUP.INF installer script for the custom SVGA driver.

---

## Step-by-step explanation

### 1. **Initialize video mode storage**
```basic
120 DIM MO(255, 2)  ' Array to store up to 256 video modes: width, height, depth
```

### 2. **Collect valid video modes**
```basic
140 SHELL "vidmodes > vidmodes.out"                    ' Runs vidmodes utility, saves output
150 OPEN "I", 1, "vidmodes.out"                        ' Opens output for reading
160 WHILE A$ <> "Available VBE video modes:" ... WEND  ' Skips lines until mode list begins
```
- **It uses an external utility (vidmodes) to list available video modes and writes them to a file.**
- **It skips lines until it finds "Available VBE video modes:".**

```basic
200 WHILE NOT EOF(1) AND A$ <> ""
210 LINE INPUT #1, A$
220 GOSUB 620  ' Parse and store valid video mode
230 WEND
```
- **For each mode line, it calls a parsing subroutine (see below) to extract mode details.**

### 3. **Parsing and filtering video modes**
```basic
620 REM Begin of the routine that collects valid video modes
630 IF LEN(A$) = 0 OR INSTR(A$, "NG for VBESVGA.DRV") <> 0 THEN RETURN  ' Skip blanks and unsupported modes
640 WI% = ... ' Extract width
650 HE% = ... ' Extract height
660 IF WI% < 640 OR HE% < 480 THEN RETURN  ' Only keep at least 640x480
670 DE% = ... ' Extract color depth
680 IF DE% > 24 THEN DE% = 24  ' Max depth is 24-bit
690 FOR J = 0 TO I
700 IF MO(J, 0) = WI% AND MO(J, 1) = HE% AND MO(J, 2) = DE% THEN RETURN  ' No duplicates
710 NEXT J
720 I = I + 1
730 MO(I, 0) = WI% : MO(I, 1) = HE% : MO(I, 2) = DE%
760 RETURN
```
- **Skips blank lines and modes flagged as “no good”.**
- **Parses width, height, and depth.**
- **Ignores low-res and duplicate modes.**
- **Stores valid, unique, Windows-compatible modes.**

### 4. **Generate OEMSETUP.INF**
```basic
270 OPEN "O", 2, "oemsetup.inf"  ' Open output file
```
**Writes setup sections:**
- `[disks]`  
  Defines driver disks.

- `[display]`  
  For each video mode and font size (small/large), writes an entry that identifies the display driver and settings.

```basic
350 FOR J = 0 TO I
360 FOR FS = 96 TO 120 STEP 24  ' For each font size (96=Small, 120=Large)
370 K$ = ...                    ' Unique key for mode+font combo
380 PRINT #2, ...               ' Writes display entry with mode details
...
460 NEXT FS, J
```

- **For each mode and both font sizes, writes a display install line with the right parameters and friendly name.**

- **Settings sections:**  
  For each mode/font, writes a section with the required `system.ini` settings: width, height, depth, fontsize.

---

## Key features & details

- **Avoids Duplicates:** Only unique width/height/depth combinations are included.
- **Mode Filtering:** Only modes with at least 640x480 resolution and up to 24-bit color are kept.
- **Font Size Handling:** Generates entries for both small (96) and large (120) fonts.
- **Automation:** Eliminates need for manual INF editing—makes driver installation easier and more reliable.

---

## Example output (simplified)
The resulting `oemsetup.inf` will include sections like:
```
[disks]
V=. ,"PluMGMK VBE SVGA driver path",diskV
...

[display]
vbe0s=V:vbesvga.drv,"VBE SVGA 640x480x256 Small fonts",...
vbe0l=V:vbesvga.drv,"VBE SVGA 640x480x256 Large fonts",...
...

[vbe0s]
,,system.ini,vbesvga.drv,"width=","width=640"
,,system.ini,vbesvga.drv,"height=","height=480"
...
```
---

## Summary

**This is a utility to auto-generate a Windows 3.x installation script for a custom SVGA driver, by scanning available video modes and producing all needed installer entries in OEMSETUP.INF.**  
It ensures only valid, non-redundant, and Windows-compatible modes are included, with support for both large and small system font setups.
