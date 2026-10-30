#!/usr/bin/env bash
set -euo pipefail

: "${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is required}"
: "${LIVEFS_EDIT:?LIVEFS_EDIT must point to the livefs-edit executable}"

BASE_ISO="${BASE_ISO:-$GITHUB_WORKSPACE/ubuntu-26.04.1-desktop-amd64.iso}"
OUTPUT_ISO="${OUTPUT_ISO:-$GITHUB_WORKSPACE/PrathamOS-0.1.0-amd64.iso}"
DEB="$GITHUB_WORKSPACE/dist/prathamos-shell_0.1.0_amd64.deb"
SUMS="$GITHUB_WORKSPACE/SHA256SUMS"

if [[ ! -s "$DEB" ]]; then
  echo "Missing compiled PrathamOS package: $DEB" >&2
  exit 1
fi

if [[ ! -s "$BASE_ISO" ]]; then
  echo "Missing Ubuntu Desktop base ISO: $BASE_ISO" >&2
  exit 1
fi

if [[ -s "$SUMS" ]]; then
  grep 'ubuntu-26.04.1-desktop-amd64.iso$' "$SUMS" | sha256sum --check -
fi

# Discover the live root filesystem shipped by the official Ubuntu Desktop ISO.
CASPER_LIST="$(xorriso -indev "$BASE_ISO" -ls /casper 2>/dev/null)"
printf '%s\n' "$CASPER_LIST"
SQUASH_NAME="$(printf '%s\n' "$CASPER_LIST" | grep -oE '[[:alnum:]_.-]+\.squashfs' | sed 's/\.squashfs$//' | grep -m1 -E '^ubuntu-desktop-minimal$|^filesystem$' || true)"
if [[ -z "$SQUASH_NAME" ]]; then
  SQUASH_NAME="$(printf '%s\n' "$CASPER_LIST" | grep -oE '[[:alnum:]_.-]+\.squashfs' | head -n1 | sed 's/\.squashfs$//')"
fi
if [[ -z "$SQUASH_NAME" ]]; then
  echo "Could not find a casper squashfs in the Ubuntu ISO." >&2
  exit 1
fi
echo "Customizing casper/$SQUASH_NAME.squashfs"

ACTIONS="$GITHUB_WORKSPACE/runtime/livefs-actions.yml"
cat > "$ACTIONS" <<EOF
- name: edit-squashfs
  squash_name: $SQUASH_NAME
- name: shell
  command: |
    set -eux
    cp "\$GITHUB_WORKSPACE/dist/prathamos-shell_0.1.0_amd64.deb" "new/$SQUASH_NAME/tmp/prathamos-shell.deb"
    chroot "new/$SQUASH_NAME" /bin/bash -euxc 'apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y /tmp/prathamos-shell.deb && apt-get clean && rm -rf /var/lib/apt/lists/*'
    mkdir -p "new/$SQUASH_NAME/etc/gdm3"
    cat > "new/$SQUASH_NAME/etc/gdm3/custom.conf" <<'GDMEOF'
    [daemon]
    DefaultSession=prathamos.desktop
    GDMEOF
EOF

sudo --preserve-env=GITHUB_WORKSPACE "$LIVEFS_EDIT" "$BASE_ISO" "$OUTPUT_ISO" --action-yaml "$ACTIONS"

test -s "$OUTPUT_ISO"
xorriso -indev "$OUTPUT_ISO" -report_el_torito as_mkisofs >/dev/null
sha256sum "$OUTPUT_ISO" | tee "$OUTPUT_ISO.sha256"
echo "Built PrathamOS runtime ISO: $OUTPUT_ISO"
