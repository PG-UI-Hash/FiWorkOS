# ISO mastering notes

This project uses the official Ubuntu 26.04 Desktop amd64 ISO as its starting point and Cubic for customization.

Why Cubic: it unpacks the live filesystem, provides a chroot terminal for package installation, and remasters the bootable ISO. It preserves the upstream installer and boot structure. The build is not fully unattended because Cubic's ISO generation UI is part of this prototype workflow.

After installing the package in the Cubic chroot:
- Verify `/usr/share/wayland-sessions/prathamos.desktop` exists.
- Verify `/usr/bin/pratham-shell` runs in a Wayland session.
- Keep the Ubuntu installer and recovery options intact.
- Build the ISO and test in QEMU.
- Test Secure Boot separately. A custom kernel or bootloader is not part of this release.

For a later reproducible CI pipeline, migrate to Ubuntu's livecd-rootfs image build infrastructure rather than maintaining a pile of ad-hoc ISO remaster commands.