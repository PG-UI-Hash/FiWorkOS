# FiOS live shell fallback. SDDM normally starts the graphical session.
if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" && "$(tty 2>/dev/null)" == "/dev/tty1" ]]; then
  exec labwc
fi
