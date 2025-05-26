# oemsetup.inf for vbesvga.drv

#### `OEMSETUP.INF` generator for [vbesvga.drv](https://github.com/PluMGMK/vbesvga.drv).

### Usage

1. Place the BAS file in the same directory that contains the driver files
2. Run one of the following commands depending on the BASIC interpreter you have:

#### GW-BASIC
```
GWBASIC OEMSETUP
```

#### QBASIC
```
QBASIC /RUN OEMSETUP
```

2. Start Windows 3.1
3. ***Main*** > ***Windows Setup***
4. ***Options*** > ***Change system settings...***
5. ***Display*** > ***Other display (Requires disk from OEM)...***
6. Provide the path where the driver files are located
7. Select the desired video mode

### Troubleshooting

Usually the generated file cannot be used from Windows Setup in DOS mode (`windows\SETUP.EXE`) because it's too large.

If you're stuck in DOS mode, cannot start Windows due to video driver issues and cannot change the video driver from `windows\SETUP.EXE` due to out-of-memory error, delete the `windows\SYSTEM\OEMn.INF` file corresponding to this driver (check inside with `EDIT` or similar), then launch `windows\SETUP.EXE` again and select ***VGA*** or another generic driver.
