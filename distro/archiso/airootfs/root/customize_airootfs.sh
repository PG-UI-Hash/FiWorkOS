#!/bin/bash
set -euo pipefail

useradd -m -G wheel,audio,video,storage,optical -s /bin/bash fios
passwd -d fios
chmod 0440 /etc/sudoers.d/10-fios-live

systemctl enable NetworkManager.service sddm.service
systemctl disable NetworkManager-wait-online.service systemd-networkd-wait-online.service 2>/dev/null || true
systemctl set-default graphical.target

cat > /usr/lib/os-release <<'OSREL'
NAME="FiOS"
PRETTY_NAME="FiOS 0.1.0 (Arch Linux)"
ID=arch
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;40;100;232"
LOGO=fios
VARIANT="FiOS Live"
VARIANT_ID=live
OSREL

sed -i 's/ filesystems/ plymouth filesystems/' /etc/mkinitcpio.conf.d/archiso.conf
mkdir -p /etc/plymouth
printf '[Daemon]\nTheme=fios\nShowDelay=0\n' > /etc/plymouth/plymouthd.conf
mkinitcpio -P
