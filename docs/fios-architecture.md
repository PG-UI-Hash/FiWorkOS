# FiOS architecture

FiOS is an x86-64 Linux distribution built on Arch Linux. It is not Linux From Scratch and does not attempt to replace the upstream kernel, systemd, package manager or driver stack.

## System foundation

- Arch Linux packages and rolling upstream repositories.
- Linux kernel, systemd, mkinitcpio and pacman.
- NetworkManager, iwd and wpa_supplicant for connectivity.
- Mesa and upstream firmware packages for graphics and devices.
- Archinstall as the initial installation path.

## FiOS experience

- Qt 6 / QML desktop shell.
- Labwc Wayland compositor.
- Floating dock, launcher and top panel.
- FiOS identity, Phi emblem, wallpaper and Plymouth boot splash.
- Foot terminal, Thunar file manager and Firefox browser.
- PipeWire audio, Bluetooth and removable-storage integration.

## Release engineering

The ArchISO releng profile provides BIOS and UEFI boot media. The build workflow overlays the FiOS profile, compiles the desktop shell inside Arch Linux, installs it into the live filesystem and creates the ISO with mkarchiso.

## Boot target

The performance objective remains **under 3 seconds from bootloader handoff to interactive FiOS desktop** on a declared reference machine. It is not a current benchmark result. Firmware time is reported separately. Every performance claim must include hardware, firmware, kernel, storage and measurement method.
