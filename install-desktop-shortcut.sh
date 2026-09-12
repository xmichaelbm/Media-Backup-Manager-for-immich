#!/usr/bin/env bash

set -euo pipefail

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
binary_path="$project_dir/target/release/media_backup_manager"
icon_path="$project_dir/app.png"

if command -v xdg-user-dir >/dev/null 2>&1; then
    desktop_dir="$(xdg-user-dir DESKTOP)"
else
    desktop_dir="$HOME/Desktop"
fi

if [[ -z "$desktop_dir" ]]; then
    desktop_dir="$HOME/Desktop"
fi

echo "Building release binary..."
cargo build --release --locked --manifest-path "$project_dir/Cargo.toml"

mkdir -p "$desktop_dir"

launcher_path="$desktop_dir/Media Backup Manager.desktop"
cat > "$launcher_path" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Media Backup Manager
Comment=Backup media from Immich
Exec="$binary_path"
Path=$project_dir
Icon=$icon_path
Terminal=false
Categories=Utility;
EOF

chmod +x "$launcher_path"

if command -v gio >/dev/null 2>&1; then
    gio set "$launcher_path" metadata::trusted true 2>/dev/null || true
fi

echo "Desktop shortcut created: $launcher_path"
echo "Binary: $binary_path"