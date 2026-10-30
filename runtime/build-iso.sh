#!/usr/bin/env bash
set -euo pipefail

: "${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is required}"
: "${LIVEFS_EDIT:?LIVEFS_EDIT must point to the livefs-edit executable}"

BASE_ISO="${BASE_ISO:-$GITHUB_WORKSPACE/ubuntu-26.04.1-desktop-amd64.iso}"
OUTPUT_ISO="${OUTPUT_ISO:-$GITHUB_WORKSPACE/PrathamOS-0.1.0-amd64.iso}"
DEB="$GITHUB_WORKSPACE/dist/prathamos-shell_0.1.0_amd64.deb"
SUMS="$GITHUB_WORKSPACE/SHA256SUMS"

test -s "$DEB" || { echo "Missing compiled PrathamOS package: $DEB" >&2; exit 1; }
test -s "$BASE_ISO" || { echo "Missing Ubuntu Desktop base ISO: $BASE_ISO" >&2; exit 1; }

if [[ -s "$SUMS" ]]; then
  grep 'ubuntu-26.04.1-desktop-amd64.iso$' "$SUMS" | sha256sum --check -
fi

# Ubuntu 26.04 Desktop ships several locale and Secure Boot variants.
# Modify the common minimal root filesystem, never the first locale-specific
# squashfs returned by xorriso.
CASPER_LIST="$(xorriso -indev "$BASE_ISO" -ls /casper 2>/dev/null)"
printf '%s\n' "$CASPER_LIST"
SQUASH_NAME="$(printf '%s\n' "$CASPER_LIST" | grep -oE '[[:alnum:]_.-]+\.squashfs' | sed 's/\.squashfs$//' | grep -m1 -E '^(minimal|ubuntu-desktop-minimal|filesystem)$' || true)"
if [[ -z "$SQUASH_NAME" ]]; then
  echo "Could not find the common Ubuntu root squashfs (minimal.squashfs, ubuntu-desktop-minimal.squashfs or filesystem.squashfs)." >&2
  exit 1
fi
echo "Customizing common root filesystem: casper/$SQUASH_NAME.squashfs"

ACTIONS="$GITHUB_WORKSPACE/runtime/livefs-actions.yml"
cat > "$ACTIONS" <<EOF
- name: edit-squashfs
  squash_name: $SQUASH_NAME
  add_sys_mounts: false
- name: shell
  command: |
    set -eux
    ROOT="new/$SQUASH_NAME"
    mkdir -p "\$ROOT/tmp" "\$ROOT/dev" "\$ROOT/proc" "\$ROOT/sys"
    rm -f "\$ROOT/etc/resolv.conf"
    touch "\$ROOT/etc/resolv.conf"
    mount --bind /dev "\$ROOT/dev"
    mount --bind /sys "\$ROOT/sys"
    mount -t proc proc "\$ROOT/proc"
    mount --bind /etc/resolv.conf "\$ROOT/etc/resolv.conf"
    APT_BACKUP="\$ROOT/tmp/prathamos-apt-backup"
    mkdir -p "\$APT_BACKUP"
    if [ -f "\$ROOT/etc/apt/sources.list" ]; then
      mv "\$ROOT/etc/apt/sources.list" "\$APT_BACKUP/sources.list"
    fi
    if [ -d "\$ROOT/etc/apt/sources.list.d" ]; then
      mv "\$ROOT/etc/apt/sources.list.d" "\$APT_BACKUP/sources.list.d"
    fi
    mkdir -p "\$ROOT/etc/apt/sources.list.d"
    cat > "\$ROOT/etc/apt/sources.list.d/prathamos-build.sources" <<'APT'
    Types: deb
    URIs: http://archive.ubuntu.com/ubuntu
    Suites: resolute resolute-updates resolute-backports
    Components: main restricted universe multiverse
    Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

    Types: deb
    URIs: http://security.ubuntu.com/ubuntu
    Suites: resolute-security
    Components: main restricted universe multiverse
    Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
    APT
    restore_apt_sources() {
      rm -f "\$ROOT/etc/apt/sources.list.d/prathamos-build.sources"
      rmdir "\$ROOT/etc/apt/sources.list.d" 2>/dev/null || true
      if [ -d "\$APT_BACKUP/sources.list.d" ]; then
        mv "\$APT_BACKUP/sources.list.d" "\$ROOT/etc/apt/sources.list.d"
      fi
      if [ -f "\$APT_BACKUP/sources.list" ]; then
        mv "\$APT_BACKUP/sources.list" "\$ROOT/etc/apt/sources.list"
      fi
      rm -rf "\$APT_BACKUP"
    }
    cleanup() {
      restore_apt_sources
      umount -lf "\$ROOT/etc/resolv.conf" || true
      umount -lf "\$ROOT/proc" || true
      umount -lf "\$ROOT/sys" || true
      umount -lf "\$ROOT/dev" || true
      rm -f "\$ROOT/etc/resolv.conf"
    }
    trap cleanup EXIT
    cp "\$GITHUB_WORKSPACE/dist/prathamos-shell_0.1.0_amd64.deb" "\$ROOT/tmp/prathamos-shell.deb"
    chroot "\$ROOT" /bin/bash -euxc 'apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y /tmp/prathamos-shell.deb && apt-get clean && rm -rf /var/lib/apt/lists/*'
    mkdir -p "\$ROOT/etc/gdm3"
    cat > "\$ROOT/etc/gdm3/custom.conf" <<'GDMEOF'
    [daemon]
    DefaultSession=prathamos.desktop
    GDMEOF
EOF

sudo --preserve-env=GITHUB_WORKSPACE "$LIVEFS_EDIT" "$BASE_ISO" "$OUTPUT_ISO" --action-yaml "$ACTIONS"

test -s "$OUTPUT_ISO"
xorriso -indev "$OUTPUT_ISO" -report_el_torito as_mkisofs >/dev/null
sha256sum "$OUTPUT_ISO" | tee "$OUTPUT_ISO.sha256"
echo "Built PrathamOS runtime ISO: $OUTPUT_ISO"
