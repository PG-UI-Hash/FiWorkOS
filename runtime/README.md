# Ubuntu-based PrathamOS runtime image

The GitHub Actions workflow builds the PrathamOS Qt shell, packages it as a Debian package, then customizes an official Ubuntu 26.04.1 Desktop amd64 ISO.

The runtime image is intended to:
- retain Ubuntu's kernel, init system, hardware support, package system, display manager and installer;
- install the PrathamOS desktop shell and its Wayland compositor;
- register a PrathamOS session with GDM and make it the default session;
- boot as a live Ubuntu-based desktop and remain installable using the Ubuntu installer.

## Build flow

1. Compile `shell/` and produce `prathamos-shell_0.1.0_amd64.deb`.
2. Download and verify the official Ubuntu 26.04.1 Desktop amd64 ISO.
3. Use Ubuntu's `livefs-editor` to modify the desktop live filesystem squashfs.
4. Install the PrathamOS package and set the default GDM session to `prathamos.desktop`.
5. Repack the ISO and publish it as a GitHub Actions artifact.

The ISO is a customized Ubuntu runtime, not a kernel or Linux distribution built from scratch. Ubuntu remains the upstream base and retains its installer.

## Artifact

After a successful `Build PrathamOS` workflow, download the artifact named `PrathamOS-0.1.0-amd64-ISO` from the workflow run's Artifacts section.

## Testing status

A successful workflow and a successful VM boot are separate checks. The ISO job verifies the generated ISO structure and boot catalog. The first release must still be boot-tested in QEMU/VirtualBox on both UEFI and legacy BIOS before being called stable.

## Notes

The runtime customization uses Canonical's documented Ubuntu live-image editing ecosystem. The livefs-editor project itself warns that its original focus is Ubuntu Server ISOs; desktop ISO compatibility must therefore be confirmed by the CI build and subsequent VM tests.
