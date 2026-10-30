# Boot performance plan

The target is **bootloader handoff to usable desktop in < 3 seconds** on a declared reference machine. Do not count firmware or pretend a splash screen means boot completed.

Measure:

```bash
systemd-analyze time
systemd-analyze blame
systemd-analyze critical-chain
systemd-analyze plot > boot.svg
```

Record the exact machine, firmware version, CPU, RAM, SSD model, graphics device, kernel version and whether the measurement is a cold boot.

Optimization order:

1. Disable only services proven unnecessary on the target hardware.
2. Remove package recommendations and background services from the image.
3. Avoid network waits during graphical login.
4. Keep the shell startup free of network calls and expensive scans.
5. Use SSD/NVMe and a supported graphics driver.
6. Profile compositor, display manager and GPU initialization separately.

Do not disable security updates, device discovery, storage services or required hardware services merely to improve a benchmark. A desktop that boots quickly and then cannot connect to Wi-Fi is not a success.