#!/usr/bin/env bash
# Run INSIDE Cubic's chroot terminal, from the repository root.
set -euo pipefail

apt update
DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
  build-essential cmake qt6-base-dev qt6-declarative-dev qt6-wayland \
  qt6-qpa-plugins qml6-module-qtquick qml6-module-qtquick-controls \
  qml6-module-qtquick-layouts qml6-module-qtquick-window \
  qml6-module-qtqml-workerscript labwc swaybg \
  fonts-inter fonts-jetbrains-mono \
  xdg-utils dbus-user-session

# Build and install the desktop package into the live filesystem.
chmod +x packaging/build-deb.sh
./packaging/build-deb.sh
apt install -y ./dist/prathamos-shell_0.1.0_amd64.deb

# Keep Ubuntu's display manager and installer; add PrathamOS as a selectable session.
# Enable a lean default session on the live user only when the display manager supports it.
mkdir -p /etc/skel/.config
cat > /etc/skel/.config/prathamos-first-login <<'EOF'
PrathamOS first-run profile.
EOF

# Keep /etc/os-release managed by Ubuntu; publish Pratham branding separately.
cat > /etc/prathamos-release <<'EOF'
PrathamOS 0.1.0
Ubuntu 26.04 LTS base
PDS desktop prototype
EOF

echo "PrathamOS shell installed. Finish ISO mastering in Cubic."