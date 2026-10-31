# FiOS ArchISO profile

FiOS is built directly from Arch Linux using the official ArchISO releng profile and mkarchiso. Ubuntu and Debian package tooling are not part of the runtime or ISO build.

The live desktop uses KDE Plasma 6 on Wayland with SDDM autologin for the temporary fios account. The custom PDE shell is paused and is not compiled or installed. FiOS branding, the Phi emblem, wallpaper and Plymouth splash remain overlaid onto the ArchISO root filesystem.

The Install FiOS launcher starts Archinstall with the FiOS package profile. The installer asks the user to choose storage, partitioning, bootloader, locale and account credentials. It does not silently select or erase a disk.

The ISO target is 2 GiB or less. CI enforces this target and fails the build if the generated image exceeds it.
