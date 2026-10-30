# FiOS ArchISO profile overlay

The CI workflow copies Arch Linux's official `releng` profile and overlays these FiOS files before running `mkarchiso`. The upstream profile supplies the signed boot infrastructure and dual BIOS/UEFI boot configuration; this repository supplies the desktop, branding and live-session configuration.

The live desktop uses SDDM autologin for the temporary `fios` account. The installer entry launches Archinstall. A normal installed system should create a personal account during installation; the live account is not intended as a production account.

The ISO target is **2 GB or less**. It is a target, not a verified size until CI builds and measures the artifact.
