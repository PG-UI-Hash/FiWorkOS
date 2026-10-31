#!/usr/bin/env bash
set -euo pipefail

: "${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is required}"
: "${LIVEFS_EDIT:?LIVEFS_EDIT must point to the livefs-edit executable}"

BASE_ISO="${BASE_ISO:-$GITHUB_WORKSPACE/ubuntu-26.04.1-desktop-amd64.iso}"
OUTPUT_ISO="${OUTPUT_ISO:-$GITHUB_WORKSPACE/FiOS-0.1.0-amd64.iso}"
SUMS="$GITHUB_WORKSPACE/SHA256SUMS"

test -s "$BASE_ISO" || { echo "Missing Ubuntu Desktop base ISO: $BASE_ISO" >&2; exit 1; }

if [[ -s "$SUMS" ]]; then
  grep 'ubuntu-26.04.1-desktop-amd64.iso$' "$SUMS" | sha256sum --check -
fi

CASPER_LIST="$(xorriso -indev "$BASE_ISO" -ls /casper 2>/dev/null)"
printf '%s\n' "$CASPER_LIST"
SQUASH_NAME="$(printf '%s\n' "$CASPER_LIST" | grep -oE '[[:alnum:]_.-]+\.squashfs' | sed 's/\.squashfs$//' | grep -m1 -E '^(minimal|ubuntu-desktop-minimal|filesystem)$' || true)"
if [[ -z "$SQUASH_NAME" ]]; then
  echo "Could not find the common Ubuntu root squashfs." >&2
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

    APT_BACKUP="\$ROOT/tmp/fios-apt-backup"
    mkdir -p "\$APT_BACKUP"
    if [ -f "\$ROOT/etc/apt/sources.list" ]; then
      mv "\$ROOT/etc/apt/sources.list" "\$APT_BACKUP/sources.list"
    fi
    if [ -d "\$ROOT/etc/apt/sources.list.d" ]; then
      mv "\$ROOT/etc/apt/sources.list.d" "\$APT_BACKUP/sources.list.d"
    fi
    mkdir -p "\$ROOT/etc/apt/sources.list.d"
    cat > "\$ROOT/etc/apt/sources.list.d/fios-build.sources" <<'APT'
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
      rm -f "\$ROOT/etc/apt/sources.list.d/fios-build.sources"
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

    # Use Plasma instead of the paused custom PDE session.
    printf 'gdm3 shared/default-x-display-manager select gdm3\\n' | chroot "\$ROOT" debconf-set-selections
    chroot "\$ROOT" /bin/bash -euxc '
      apt-get update
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        plasma-desktop plasma-workspace plasma-session-wayland \
        plasma-nm plasma-pa dolphin konsole kate
      apt-get clean
      rm -rf /var/lib/apt/lists/*
    '

    mkdir -p "\$ROOT/etc/gdm3"
    cat > "\$ROOT/etc/gdm3/custom.conf" <<'GDMEOF'
    [daemon]
    DefaultSession=plasma.desktop
    GDMEOF

    test -f "\$ROOT/usr/share/wayland-sessions/plasma.desktop" || \
      test -f "\$ROOT/usr/share/xsessions/plasma.desktop"
EOF

sudo --preserve-env=GITHUB_WORKSPACE "$LIVEFS_EDIT" "$BASE_ISO" "$OUTPUT_ISO" --action-yaml "$ACTIONS"

test -s "$OUTPUT_ISO"
xorriso -indev "$OUTPUT_ISO" -report_el_torito as_mkisofs >/dev/null
sha256sum "$OUTPUT_ISO" | tee "$OUTPUT_ISO.sha256"
echo "Built FiOS runtime ISO: $OUTPUT_ISO"
