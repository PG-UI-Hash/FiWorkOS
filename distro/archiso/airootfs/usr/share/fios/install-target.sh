#!/bin/bash
set -euo pipefail

SOURCE=/run/archiso/sfs/airootfs
if [[ ! -x "$SOURCE/usr/bin/fios-shell" ]]; then
  echo "FiOS live payload is unavailable at $SOURCE" >&2
  exit 1
fi

install -Dm755 "$SOURCE/usr/bin/fios-shell" /usr/bin/fios-shell
install -Dm644 "$SOURCE/usr/share/fios/wallpaper.png" /usr/share/fios/wallpaper.png
install -Dm644 "$SOURCE/etc/xdg/labwc/autostart" /etc/xdg/labwc/autostart
install -Dm644 "$SOURCE/usr/share/wayland-sessions/fios.desktop" /usr/share/wayland-sessions/fios.desktop
install -Dm644 "$SOURCE/usr/share/icons/hicolor/scalable/apps/fios.svg" /usr/share/icons/hicolor/scalable/apps/fios.svg
mkdir -p /usr/share/plymouth/themes
cp -a "$SOURCE/usr/share/plymouth/themes/fios" /usr/share/plymouth/themes/
install -Dm644 "$SOURCE/etc/plymouth/plymouthd.conf" /etc/plymouth/plymouthd.conf

sed -i 's/ filesystems/ plymouth filesystems/' /etc/mkinitcpio.conf
mkinitcpio -P
for account in $(awk -F: '$3 >= 1000 && $3 < 60000 && $6 ~ /^\/home\// { print $1 }' /etc/passwd); do
  usermod -aG video,storage,optical "$account"
done

systemctl enable NetworkManager.service sddm.service
systemctl set-default graphical.target
