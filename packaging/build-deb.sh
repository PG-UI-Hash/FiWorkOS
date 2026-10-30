#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build"
PKG="$ROOT/dist/prathamos-shell_0.1.0_amd64"
mkdir -p "$BUILD" "$ROOT/dist"
cmake -S "$ROOT/shell" -B "$BUILD" -DCMAKE_BUILD_TYPE=Release
cmake --build "$BUILD" --parallel
rm -rf "$PKG"
mkdir -p "$PKG/DEBIAN" "$PKG/usr/bin" "$PKG/usr/share/prathamos" \
  "$PKG/usr/share/wayland-sessions" "$PKG/etc/xdg/labwc"
cp "$ROOT/packaging/control" "$PKG/DEBIAN/control"
install -m 0755 "$BUILD/pratham-shell" "$PKG/usr/bin/pratham-shell"
install -m 0644 "$ROOT/assets/wallpaper.svg" "$PKG/usr/share/prathamos/wallpaper.svg"
install -m 0644 "$ROOT/packaging/prathamos.desktop" "$PKG/usr/share/wayland-sessions/prathamos.desktop"
install -m 0644 "$ROOT/packaging/labwc-rc.xml" "$PKG/etc/xdg/labwc/rc.xml"
install -m 0755 "$ROOT/packaging/labwc-autostart" "$PKG/etc/xdg/labwc/autostart"
dpkg-deb --root-owner-group --build "$PKG" "$ROOT/dist/prathamos-shell_0.1.0_amd64.deb"
echo "Built $ROOT/dist/prathamos-shell_0.1.0_amd64.deb"