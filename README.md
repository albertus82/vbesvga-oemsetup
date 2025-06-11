# oemsetup.inf for vbesvga.drv

`OEMSETUP.INF` generator for [vbesvga.drv](https://github.com/PluMGMK/vbesvga.drv), obviously written in an obsolete programming language so that it can be easily executed from DOS.

### Prerequisites

* Setup Windows 3.1x with the default VGA driver (640x480x16)
* Make sure you have a BASIC interpreter like **GW-BASIC** or **QBasic**
* Have your Windows Installation Disk 2 handy (it contains `VGADIB.3GR`).

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

#### Setup asking for Windows disks

If you selected VGA during Windows setup, all the required dependencies are already present in `%WINDIR%\SYSTEM` except `VGADIB.3GR` which is located on disk 2 (both 3.5" and 5.25" versions). If Windows continues to ask for a disk, try specifying the driver path again or the `%WINDIR%\SYSTEM` path.

#### Out-of-memory error in DOS mode setup

Often the generated `OEMSETUP.INF` cannot be used from Windows Setup in DOS mode (`%WINDIR%\SETUP.EXE`) because it's too large.

If you're stuck in DOS mode due to video driver issues and cannot change the driver from `%WINDIR%\SETUP.EXE` due to out-of-memory errors, delete the `%WINDIR%\SYSTEM\OEMn.INF` file corresponding to this driver (check inside with `EDIT` or similar beforehand), then launch `%WINDIR%\SETUP.EXE` again and select **VGA**.

# Explanation by Copilot

This GW-BASIC/QBasic program, OEMSETUP.BAS, is an automatic generator for an OEMSETUP.INF file used to install the PluMGMK VBE SVGA driver in Windows 3.x. It analyzes available video modes and writes the necessary installer entries. Here’s a detailed breakdown:

---

## What Does This Program Do?

- **Purpose:**  
  It reads video modes supported by your system, filters them for Windows compatibility, and auto-generates a Windows 3.x OEMSETUP.INF installer script for the custom SVGA driver.

---

## Step-by-Step Explanation

### 1. **Initialize Video Mode Storage**
```basic
120 DIM MO(255, 2)  ' Array to store up to 256 video modes: width, height, depth
```

### 2. **Collect Valid Video Modes**
```basic
140 SHELL "vidmodes > vidmodes.out"           ' Runs vidmodes utility, saves output
150 OPEN "I", 1, "vidmodes.out"               ' Opens output for reading
160 WHILE A$ <> "Available modes:" ... WEND   ' Skips lines until mode list begins
```
- **It uses an external utility (vidmodes) to list available video modes and writes them to a file.**
- **It skips lines until it finds "Available modes:".**

```basic
200 WHILE NOT EOF(1)
210 LINE INPUT #1, A$
220 GOSUB 630  ' Parse and store valid video mode
230 WEND
```
- **For each mode line, it calls a parsing subroutine (see below) to extract mode details.**

### 3. **Parsing and Filtering Video Modes**
```basic
630 REM Begin of the routine that collects valid video modes
640 IF LEN(A$) = 0 OR INSTR(A$, "NG for VBESVGA.DRV") <> 0 THEN RETURN  ' Skip blanks and unsupported modes
650 WI% = ... ' Extract width
660 HE% = ... ' Extract height
670 IF WI% < 640 OR HE% < 480 THEN RETURN  ' Only keep at least 640x480
680 DE% = ... ' Extract color depth
690 IF DE% > 24 THEN DE% = 24   ' Max depth is 24-bit
700 FOR J = 0 TO I
710 IF MO(J, 0) = WI% AND MO(J, 1) = HE% AND MO(J, 2) = DE% THEN RETURN  ' No duplicates
720 NEXT J
730 MO(I, 0) = WI% : MO(I, 1) = HE% : MO(I, 2) = DE%
760 I = I + 1
770 RETURN
```
- **Skips blank lines and modes flagged as “no good”.**
- **Parses width, height, and depth.**
- **Ignores low-res and duplicate modes.**
- **Stores valid, unique, Windows-compatible modes.**

### 4. **Generate OEMSETUP.INF**
```basic
280 OPEN "O", 2, "oemsetup.inf"   ' Open output file
```
**Writes Setup Sections:**
- `[disks]`  
  Defines driver disks.

- `[display]`  
  For each video mode and font size (small/large), writes an entry that identifies the display driver and settings.

```basic
360 FOR J = 0 TO I
370 FOR FS = 96 TO 120 STEP 24   ' For each font size (96=Small, 120=Large)
380 K$ = ...                     ' Unique key for mode+font combo
390 PRINT #2, ...                ' Writes display entry with mode details
...
470 NEXT FS, J
```

- **For each mode and both font sizes, writes a display install line with the right parameters and friendly name.**

- **Settings Sections:**  
  For each mode/font, writes a section with the required `system.ini` settings: width, height, depth, fontsize.

---

## Key Features & Details

- **Avoids Duplicates:** Only unique width/height/depth combinations are included.
- **Mode Filtering:** Only modes with at least 640x480 resolution and up to 24-bit color are kept.
- **Font Size Handling:** Generates entries for both small (96) and large (120) fonts.
- **Automation:** Eliminates need for manual INF editing—makes driver installation easier and more reliable.

---

## Example Output (Simplified)
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
