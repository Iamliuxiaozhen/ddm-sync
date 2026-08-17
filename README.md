# ddm-sync

Synchronize the display manager login screen with the current desktop display layout.

## Supported targets

- SDDM: copies `~/.local/share/kscreen` to `/var/lib/sddm/.local/share/kscreen`.
- GDM3/GDM: copies `~/.config/monitors.xml` to the installed GDM data directory.

Only configuration files and display manager data directories that exist on the system are synced.

## Requirements

- Qt/QML runtime libraries required by `qmetaobject`.
- `pkexec` for privileged writes to `/var/lib`.
