# FiOS 0.1.0

**FiOS** is an x86-64 Linux distribution built on Arch Linux, with an original Qt 6/QML desktop by Pratham Tech.

The Phi emblem is the visual mark. The boot splash carries the line **“By Pratham Tech.”**

## What FiOS includes

- Arch Linux kernel, systemd, pacman and upstream hardware support.
- Labwc Wayland compositor.
- Original FiOS dock, searchable launcher, top panel and native quick-settings center.
- Quick controls for Wi-Fi, audio, brightness and Bluetooth, plus system appearance and update shortcuts.
- Custom Phi emblem, wallpaper and Plymouth boot splash.
- Firefox, Thunar and Foot.
- NetworkManager, PipeWire, Bluetooth and removable storage.
- Archinstall-based installation entry in the live environment.

## Build the ISO

The reproducible build runs in a current Arch Linux container on GitHub Actions.

1. Push to the `arch-prathamos-lite` branch or manually run **Build FiOS** from Actions.
2. Wait for the ISO build and validation job to complete.
3. Download the `FiOS-0.1.0-x86_64-ISO` artifact.

For a local Arch Linux build:

```bash
sudo pacman -Syu --needed archiso base-devel cmake ninja qt6-base qt6-declarative qt6-wayland qt6-svg
cmake -S shell -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel
```

The CI workflow copies the official ArchISO releng profile, overlays `distro/archiso`, compiles the FiOS shell and runs `mkarchiso`.

## Installation

Boot the live ISO and select **Install FiOS** from the application launcher. This launches Archinstall. Review the target disk carefully before confirming installation; partitioning is destructive.

The installer profile adds the FiOS desktop packages and applies the FiOS shell, session, wallpaper and boot splash to the installed system. The live account is temporary and is not intended for normal installed use. Create your own user account during installation.

## Release targets

| Target | Goal | Status |
|---|---:|---|
| ISO size | 2 GB or less | CI must verify |
| Boot to interactive desktop | Under 3 seconds | Not yet benchmarked |
| Architecture | x86-64 | Build target |
| Firmware | UEFI and legacy BIOS | Inherited from ArchISO releng profile |

The **3-second target** is measured from bootloader handoff to an interactive desktop on declared reference hardware. Firmware time is recorded separately. It is an engineering target, not a claim that the current prototype already meets it.

## Current development status

This is an early distribution prototype. The shell is original, while the compositor, installer, kernel, system services and applications are upstream components. The first ISO must be boot-tested in a virtual machine on both UEFI and BIOS before it is called stable.

## Licensing

FiOS-specific code and artwork are provided under the MIT License. Arch Linux, Qt, Labwc, Plymouth and all bundled applications retain their respective licenses and trademarks. FiOS is an independent project and is not an official Arch Linux product.
