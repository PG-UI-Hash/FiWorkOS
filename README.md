# FiOS 0.1.0

**FiOS** is an Ubuntu 26.04-based x86-64 Linux distribution using **KDE Plasma 6** as its desktop environment.

The custom PDE (Pratham Desktop Environment) is paused for now. FiOS uses upstream KDE Plasma instead, while retaining the FiOS name and the Phi visual identity. The boot splash carries **“By Pratham Tech.”**

## Desktop

- Ubuntu 26.04.1 Desktop base.
- KDE Plasma 6 desktop and Wayland session.
- GDM login manager from the Ubuntu base, configured to start Plasma by default.
- KDE Plasma NetworkManager and audio controls.
- Dolphin, Konsole and Kate.
- Phi emblem and FiOS branding.
- x86-64 target.

## Build the ISO

The reproducible build runs on GitHub Actions.

1. Open **Actions** in this repository.
2. Select **Build FiOS**.
3. Run the workflow manually, or push to `arch-prathamos-lite` / `main`.
4. Download the `FiOS-0.1.0-amd64-ISO` artifact when the workflow completes.

The workflow downloads and verifies the official Ubuntu 26.04.1 Desktop ISO, installs KDE Plasma into the common live filesystem with Ubuntu's livefs editor, and validates the resulting bootable ISO.

## Release targets

| Target | Goal | Status |
|---|---:|---|
| ISO size | 2 GiB or less | CI reports whether the target is met |
| Boot to interactive desktop | Under 3 seconds | Not yet benchmarked |
| Architecture | x86-64 | Build target |
| Desktop | KDE Plasma 6 | Build configuration |
| Base | Ubuntu 26.04.1 | Build configuration |

The 3-second target is measured from bootloader handoff to an interactive desktop on declared reference hardware. Firmware time is recorded separately. It is an engineering target, not a claim that the current prototype already meets it.

## Current status

This is an early distribution prototype. Plasma is upstream KDE software; FiOS-specific branding and integration are maintained in this repository. The generated ISO must be boot-tested in a virtual machine on both UEFI and legacy BIOS before it is called stable.

## Licensing

FiOS-specific code and artwork are provided under the MIT License. Ubuntu, KDE Plasma and bundled applications retain their respective licenses and trademarks. FiOS is an independent project and is not an official Ubuntu or KDE product.
