#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
install_dir="${ASEPRITE_INSTALL_DIR:-$data_home/aseprite}"
applications_dir="$data_home/applications"
icon_dir="$data_home/icons/hicolor/256x256/apps"
desktop_file="$applications_dir/aseprite.desktop"
icon_file="$icon_dir/aseprite.png"

unregister() {
  rm -f -- "$desktop_file" "$icon_file"
  command -v update-desktop-database >/dev/null 2>&1 && \
    update-desktop-database "$applications_dir" || true
  command -v gtk-update-icon-cache >/dev/null 2>&1 && \
    gtk-update-icon-cache -f -t "$data_home/icons/hicolor" || true
  echo "Removed Aseprite desktop registration."
}

if [[ "${1:-}" == "--unregister" ]]; then
  unregister
  exit 0
fi

if [[ ! -x "$install_dir/aseprite" ]]; then
  echo "Aseprite is not installed at $install_dir/aseprite" >&2
  echo "Run scripts/install-user.sh first." >&2
  exit 1
fi

install -d "$applications_dir" "$icon_dir"
install -m 0644 "$repo_dir/data/icons/ase256.png" "$icon_file"

desktop_tmp="$(mktemp)"
trap 'rm -f -- "$desktop_tmp"' EXIT
desktop_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/ /\\ /g; s/\t/\\t/g; s/\n/\\n/g'
}
exec_value="$(desktop_escape "$install_dir/aseprite")"
icon_value="$(desktop_escape "$icon_file")"
sed \
  -e "s|@EXEC@|$exec_value|g" \
  -e "s|@ICON@|$icon_value|g" \
  "$repo_dir/scripts/aseprite.desktop.in" > "$desktop_tmp"
install -m 0644 "$desktop_tmp" "$desktop_file"

command -v update-desktop-database >/dev/null 2>&1 && \
  update-desktop-database "$applications_dir" || true
command -v gtk-update-icon-cache >/dev/null 2>&1 && \
  gtk-update-icon-cache -f -t "$data_home/icons/hicolor" || true

echo "Registered Aseprite in the Linux desktop application menu."
