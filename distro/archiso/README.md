# FiOS ArchISO profile overlay

The CI workflow copies Arch Linux's official releng profile and overlays FiOS files before running mkarchiso. The upstream profile supplies the boot infrastructure; this repository supplies the desktop, branding, live session and installer configuration.

The live desktop uses SDDM autologin for a temporary `fios` account. The **Install FiOS** entry launches Archinstall with a FiOS package profile and a post-install command that copies the FiOS shell, session, wallpaper, Phi icon and Plymouth theme into the installed system.

The installer still asks the user to choose storage, partitioning, bootloader, locale and account credentials. It does not silently select or erase a disk.

The ISO target is **2 GB or less**. This remains a target until CI builds and measures the artifact.
