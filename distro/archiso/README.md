# FiOS ArchISO profile overlay

The CI workflow copies Arch Linux's official releng profile and overlays FiOS files before running mkarchiso. The upstream profile supplies boot infrastructure; this repository supplies the desktop, branding and live-session configuration.

The live desktop uses SDDM autologin for a temporary fios account. The installer entry launches Archinstall. The live account is not intended as a production account.

The ISO target is 2 GB or less. This remains a target until CI builds and measures the artifact.
