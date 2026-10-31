# FiOS architecture

FiOS is an x86-64 Linux distribution built on Arch Linux. It uses the upstream Linux kernel, systemd, mkinitcpio and pacman.

## FiOS experience
- KDE Plasma 6 desktop on Wayland.
- SDDM display manager and Plasma session.
- Dolphin, Konsole, Kate and Firefox.
- Plasma NetworkManager and audio controls.
- Ø emblem, wallpaper and Plymouth boot splash reading “By Pratham Tech.”
- NetworkManager, PipeWire, Bluetooth and removable-storage integration.
- Archinstall configuration that installs the FiOS package set and applies FiOS branding and boot splash.

The custom PDE is paused. It is not part of the current image.

## Performance objective
The target remains **under 3 seconds from bootloader handoff to interactive FiOS desktop** on a declared reference machine. This is a target, not a measured result. Firmware time is reported separately. Every performance claim must include hardware, firmware, kernel, storage and measurement method.
