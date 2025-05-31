# oemsetup.inf for vbesvga.drv

`OEMSETUP.INF` generator for [vbesvga.drv](https://github.com/PluMGMK/vbesvga.drv), obviously written in an obsolete programming language so that it is easily executable from DOS.

### Prerequisite

Setup Windows 3.1x with the default VGA driver (640x480x16).

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

Often the generated file cannot be used from Windows Setup in DOS mode (`windows\SETUP.EXE`) because it's too large.

If you're stuck in DOS mode due to video driver issues and cannot change the driver from `windows\SETUP.EXE` due to out-of-memory errors, delete the `windows\SYSTEM\OEMn.INF` file corresponding to this driver (check inside with `EDIT` or similar beforehand), then launch `windows\SETUP.EXE` again and select ***VGA*** or another generic driver.
