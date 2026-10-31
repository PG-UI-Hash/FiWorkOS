# FiOS 0.1.0

FiOS is an x86-64 Linux distribution built directly on **Arch Linux**, using **KDE Plasma 6** as its desktop environment.

The custom PDE (Pratham Desktop Environment) is paused for now. FiOS uses upstream KDE Plasma on Wayland, with the **Ø emblem**, FiOS wallpaper and a Plymouth boot splash reading **“By Pratham Tech.”**

## Desktop
- Arch Linux base with the official ArchISO live-image build system.
- KDE Plasma 6 desktop and Wayland session.
- SDDM display manager with a temporary FiOS live-session login.
- Plasma NetworkManager and audio controls.
- Dolphin, Konsole and Kate.
- PipeWire audio, Bluetooth, removable storage and common graphics drivers.
- Ø emblem, FiOS wallpaper and Plymouth boot splash.
- x86-64 target.

## Build the ISO
The reproducible build runs on GitHub Actions in an Arch Linux container.

1. Open **Actions** in this repository.
2. Select **Build FiOS**.
3. Run the workflow manually, or push to main.
4. Download the **FiOS-0.1.0-x86_64-ISO** artifact when the workflow completes.

The workflow installs ArchISO tooling, copies the official Arch Linux releng profile, overlays FiOS configuration and branding, and runs mkarchiso. No Ubuntu ISO, APT repository, Debian package, or Ubuntu livefs editor is used. The build script is mounted into the Arch container and invoked as a real file, so an empty stdin cannot masquerade as a successful build.

## Installation
Boot the live ISO and select **Install FiOS** from the Plasma application launcher. This launches Archinstall with the FiOS package profile. Review the target disk carefully before confirming installation; partitioning is destructive.

The live desktop signs in automatically and does not use a shared preset password. During installation, the interactive Archinstall wizard asks you to create your installed system's user account and set its password. Choose your own username and password there; those credentials are used after the installation reboots. FiOS keeps Archinstall's interactive prompts enabled and does not preconfigure an installed user or password. It does not silently select or erase a disk.

## Release targets
| Target | Goal | Status |
|---|---:|---|
| ISO size | 2 GiB or less | Enforced by CI |
| Boot to interactive desktop | Under 3 seconds | Not yet benchmarked |
| Architecture | x86-64 | Build target |
| Desktop | KDE Plasma 6 | Build configuration |
| Base | Arch Linux | Build configuration |

The 3-second target is measured from bootloader handoff to an interactive desktop on declared reference hardware. Firmware time is recorded separately. It is an engineering target, not a claim that the current prototype already meets it.

## Current status
This is an early distribution prototype. Plasma, the kernel, system services, installer and applications are upstream components. FiOS-specific branding and integration are maintained in this repository. The generated ISO must be boot-tested in a virtual machine on both UEFI and legacy BIOS before it is called stable.

## Licensing
FiOS-specific code and artwork are provided under the MIT License. Arch Linux, KDE Plasma, Qt, Plymouth and bundled applications retain their respective licenses and trademarks. FiOS is an independent project and is not an official Arch Linux product.
