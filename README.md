# PrathamOS 0.1.0

An Ubuntu-based x86-64 Linux distribution prototype with an original Qt 6/QML desktop shell and the Pratham Design System (PDS).

## What this repository contains

- `shell/`: Qt 6/QML desktop dock, launcher, quick controls and branding.
- `packaging/`: installable Debian package metadata and install scripts.
- `iso/`: repeatable Cubic-based ISO customization instructions and helper scripts.
- `assets/`: original SVG wallpaper and mark.
- `docs/`: architecture and performance notes.

This is a **first bootable prototype**, not a finished commercial OS. It uses `labwc` as the Wayland compositor/window manager and adds the original Pratham shell above it. This is deliberate: writing a compositor, display manager, installer, settings service and desktop shell simultaneously would be a spectacular way to never ship anything.

## Base release

Ubuntu 26.04 LTS (Resolute Raccoon), amd64. Ubuntu 26.04 LTS was released on 23 April 2026 and is supported until April 2031. See the official [release notes](https://documentation.ubuntu.com/release-notes/26.04/).

## Build the shell on Ubuntu 26.04

```bash
sudo apt update
sudo apt install -y build-essential cmake qt6-base-dev qt6-declarative-dev \
  qt6-wayland qt6-qpa-plugins qml6-module-qtquick \
  qml6-module-qtquick-controls qml6-module-qtquick-layouts \
  qml6-module-qtquick-window qml6-module-qtqml-workerscript \
  labwc swaybg fonts-inter fonts-jetbrains-mono
cmake -S shell -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel
```

Run it inside a Wayland session:

```bash
QT_QPA_PLATFORM=wayland ./build/pratham-shell
```

For a quick test from an existing desktop, use a nested Wayland session or a VM. Do not replace your current login session until you have tested the package.

## Build a Debian package

```bash
./packaging/build-deb.sh
```

The resulting `.deb` is written to `dist/`.

Install locally:

```bash
sudo apt install ./dist/prathamos-shell_0.1.0_amd64.deb
```

## Build the PrathamOS ISO

The supported prototype workflow uses **Cubic** to customize the official Ubuntu 26.04 Desktop amd64 ISO. This keeps Ubuntu's signed boot chain and desktop installer rather than inventing a fragile installer in release zero.

1. Download `ubuntu-26.04-desktop-amd64.iso` from the official [Ubuntu 26.04 image directory](https://releases.ubuntu.com/26.04/).
2. Install Cubic on an Ubuntu 26.04 build machine.
3. Create a new Cubic project and select the downloaded ISO as the original image.
4. In Cubic's terminal, copy this repository into the chroot (Cubic exposes its project directory; alternatively download/copy the repository into `/tmp/PrathamOS-0.1.0`).
5. Run the commands in `iso/cubic-chroot.sh` from the repository root.
6. Complete Cubic's ISO generation step. Name the output `PrathamOS-0.1.0-amd64.iso`.
7. Test the ISO in a VM before writing it to USB or installing it on physical hardware.

Cubic is a GUI workflow, so the final ISO mastering step is intentionally completed in Cubic. Do not use `dd` on a disk containing data you want to keep.

## Test in QEMU

```bash
sudo apt install -y qemu-system-x86
qemu-system-x86_64 -enable-kvm -m 4096 -smp 4 \
  -cdrom PrathamOS-0.1.0-amd64.iso -boot d
```

If KVM is unavailable, remove `-enable-kvm` (it will be slower).

## First login

At the login screen, choose the **PrathamOS** Wayland session. The session starts `labwc`, paints the desktop wallpaper with `swaybg`, and launches `pratham-shell`.

The default shell includes a dock with Terminal, Files, Browser, Settings and App Launcher entries. Applications launch only when their desktop command exists.

## Important limitations in 0.1.0

- The Ubuntu installer is retained. This is a customized Ubuntu desktop ISO, not a new installer implementation.
- The dock and launcher are an early shell. There is no custom file manager, settings backend, notification daemon or app store yet.
- Window management is provided by labwc, not implemented by Pratham.
- Theme switching in this prototype changes shell surfaces only; it does not yet re-theme every GTK/Qt application.
- Boot time depends on firmware, storage, drivers, graphics initialization and installed services. The under-3-second target must be measured on named hardware and is not guaranteed by this prototype.

## License

The original PrathamOS code in this repository is provided under the MIT License. Ubuntu, Qt, labwc and other dependencies retain their own licenses and trademarks. PrathamOS is an independent project and is not an official Ubuntu product.
