# FiOS architecture

FiOS is an x86-64 Linux distribution built on Arch Linux. It uses the upstream Linux kernel, systemd, mkinitcpio and pacman.

## FiOS experience

- Qt 6 / QML desktop shell and Labwc Wayland compositor.
- Original floating dock, searchable application launcher, top panel and native quick-settings center.
- Quick actions for Wi-Fi, audio, brightness and Bluetooth, plus appearance and update shortcuts.
- Phi emblem, wallpaper and Plymouth boot splash reading “By Pratham Tech.”
- Foot terminal, Thunar file manager and Firefox browser.
- NetworkManager, PipeWire, Bluetooth and removable-storage integration.
- Archinstall configuration that installs the FiOS package set and runs a post-install step to apply the FiOS shell, session, wallpaper and boot splash.

## Performance objective

The target remains **under 3 seconds from bootloader handoff to interactive FiOS desktop** on a declared reference machine. This is a target, not a measured result. Firmware time is reported separately. Every performance claim must include hardware, firmware, kernel, storage and measurement method.
