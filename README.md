# oemsetup.inf for vbesvga.drv

`oemsetup.inf` generator for [vbesvga.drv](https://github.com/PluMGMK/vbesvga.drv), obviously written in an obsolete programming language so that it can be easily executed from DOS.

### Prerequisites

* Setup Windows 3.1x with the default VGA driver (640x480x16)
* Make sure you have a BASIC interpreter like **GW-BASIC** or **QBasic**.

### Usage

1. Place [`oemsetup.bas`](oemsetup.bas) file in the same directory that contains the driver files, including `vidmodes.com`
2. Run one of the following commands depending on the BASIC interpreter you have:

#### GW-BASIC
```
gwbasic oemsetup
```

#### QBASIC
```
qbasic /run oemsetup
```

3. Start Windows 3.1x
4. ***Main*** > ***Windows Setup***
5. ***Options*** > ***Change system settings...***
6. ***Display*** > ***Other display (Requires disk from OEM)...***
7. Provide the path where the driver files are located
8. Select the desired video mode

### Troubleshooting

#### Setup asking for Windows disks

Try specifying the driver path again or the `%WINDIR%\system` path.

#### Setup in DOS mode

Often the generated file cannot be used from Windows Setup in DOS mode (`%WINDIR%\setup.exe`) because it's too large.

If you're stuck in DOS mode due to video driver issues and cannot change the driver from `%WINDIR%\setup.exe` due to out-of-memory errors, delete the `%WINDIR%\system\oem<N>.inf` file corresponding to this driver (check inside with `edit` or similar beforehand), then launch `%WINDIR%\setup.exe` again and select ***VGA*** or another generic driver.
