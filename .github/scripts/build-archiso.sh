#!/usr/bin/env bash
set -Eeuo pipefail
trap 'status=$?; echo "::error::FiOS ArchISO build failed at line ${LINENO} (exit ${status})." >&2; exit "$status"' ERR

pacman -Syu --noconfirm --needed archiso grub imagemagick librsvg xorriso

rm -rf build/profile build/work
mkdir -p build/profile
cp -a /usr/share/archiso/configs/baseline/. build/profile/
cp -a distro/archiso/airootfs/. build/profile/airootfs/
# FiOS is a desktop OS, not a rescue toolkit or cloud image.
sed -i -e '/^cloud-init$/d' -e '/^hyperv$/d' -e '/^open-vm-tools$/d' -e '/^qemu-guest-agent$/d' -e '/^virtualbox-guest-utils-nox$/d' build/profile/packages.x86_64
cat distro/archiso/packages.x86_64 >> build/profile/packages.x86_64
sort -u -o build/profile/packages.x86_64 build/profile/packages.x86_64

sed -i 's|^iso_name=.*|iso_name="fios"|' build/profile/profiledef.sh
sed -i "s|^iso_label=.*|iso_label=\"FIOS_$(date +%Y%m)\"|" build/profile/profiledef.sh
sed -i 's|^iso_publisher=.*|iso_publisher="Pratham Tech."|' build/profile/profiledef.sh
sed -i 's|^iso_application=.*|iso_application="FiOS Live - Arch Linux + KDE Plasma"|' build/profile/profiledef.sh

for cfg in build/profile/grub/grub.cfg build/profile/efiboot/loader/entries/01-archiso-linux.conf build/profile/syslinux/archiso_sys-linux.cfg; do
  if [[ -f "$cfg" ]]; then
    sed -i 's/Arch Linux/FiOS/g;s/%KERNEL_PARAMS%/%KERNEL_PARAMS% quiet splash/g' "$cfg"
  fi
done

install -Dm644 assets/fios-emblem.svg build/profile/airootfs/usr/share/icons/hicolor/scalable/apps/fios.svg
install -Dm644 assets/fios-emblem.svg build/profile/airootfs/usr/share/fios/emblem.svg
mkdir -p build/profile/airootfs/usr/share/fios
magick assets/fios-wallpaper.svg -resize 1920x1080 build/profile/airootfs/usr/share/fios/wallpaper.png
mkdir -p build/profile/airootfs/usr/share/plymouth/themes/fios
magick assets/fios-emblem.svg -resize 220x220 build/profile/airootfs/usr/share/plymouth/themes/fios/emblem.png
cat > build/profile/airootfs/usr/share/plymouth/themes/fios/fios.plymouth <<'PLYMOUTH'
[Plymouth Theme]
Name=FiOS
Description=FiOS boot splash by Pratham Tech.
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/fios
ScriptFile=/usr/share/plymouth/themes/fios/fios.script
PLYMOUTH
cat > build/profile/airootfs/usr/share/plymouth/themes/fios/fios.script <<'PLYMOUTH_SCRIPT'
logo = Image("emblem.png");
logo.SetX(Window.GetWidth() / 2 - logo.GetWidth() / 2);
logo.SetY(Window.GetHeight() / 2 - logo.GetHeight() / 2 - 24);
message = Image.Text("By Pratham Tech.", 0.8, 0.8, 0.8);
message.SetX(Window.GetWidth() / 2 - message.GetWidth() / 2);
message.SetY(Window.GetHeight() / 2 + 100);
PLYMOUTH_SCRIPT

chmod +x build/profile/airootfs/root/customize_airootfs.sh
chmod +x build/profile/airootfs/usr/local/bin/fios-install
chmod +x build/profile/airootfs/usr/share/fios/install-target.sh
mkarchiso -v -w build/work -o /work/out build/profile

ISO=$(find /work/out -maxdepth 1 -type f -name '*.iso' -print -quit)
if [[ -z "$ISO" ]]; then
  echo "::error::mkarchiso completed without producing an ISO." >&2
  exit 1
fi
mv "$ISO" /work/out/FiOS-0.1.0-x86_64.iso
sha256sum /work/out/FiOS-0.1.0-x86_64.iso > /work/out/FiOS-0.1.0-x86_64.iso.sha256
SIZE=$(stat -c%s /work/out/FiOS-0.1.0-x86_64.iso)
echo "FiOS ISO bytes: $SIZE"
xorriso -indev /work/out/FiOS-0.1.0-x86_64.iso -report_el_torito as_mkisofs
if (( SIZE > 2147483648 )); then
  echo "::error::FiOS ISO exceeds the 2 GiB target." >&2
  exit 1
fi
