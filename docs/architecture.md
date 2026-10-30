# Architecture

```text
UEFI
  └─ GRUB (Ubuntu signed boot chain)
      └─ Linux kernel + initramfs
          └─ systemd
              └─ GDM login manager
                  └─ labwc (Wayland compositor / window manager)
                      ├─ swaybg (desktop background)
                      └─ pratham-shell (Qt 6/QML dock and launcher)
```

## Why labwc?

labwc is a lightweight Wayland compositor based on wlroots. It supplies the hard OS desktop plumbing: surfaces, focus, input routing and window management. The Pratham QML process supplies PDS visuals and launch affordances. Its small C++ `AppLauncher` bridge starts local desktop commands through `QProcess` and opens URLs through the desktop URL handler. This separation keeps the prototype small and debuggable.

## Next architectural milestones

1. Replace shell placeholder launch actions with `QProcess`-backed desktop-entry launching.
2. Add a real status service using D-Bus / NetworkManager / UPower.
3. Add a proper layer-shell integration so panel and dock reserve screen space and sit in compositor layers.
4. Add a first-party settings app and theme portal.
5. Build a branded Plymouth boot splash only after measuring boot stages.