# VBE SVGA oemsetup.inf

`OEMSETUP.INF` generator for [vbesvga.drv](https://github.com/PluMGMK/vbesvga.drv)

### Troubleshooting

Usually the generated file cannot be used from Windows Setup in DOS mode (`WINDOWS\SETUP.EXE`) because it is too large. You need to start Windows and go to **Main** > **Windows Setup**.

If you're stuck in DOS mode, delete the `WINDOWS\SYSTEM\OEMn.INF` file corresponding to this driver (check inside with `EDIT` or similar), then launch Windows Setup in DOS mode to select **VGA** or another generic driver.
