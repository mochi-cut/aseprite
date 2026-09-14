#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
build_dir="${ASEPRITE_BUILD_DIR:-$repo_dir/build/bin}"
install_dir="${ASEPRITE_INSTALL_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aseprite}"
bin_dir="${ASEPRITE_BIN_DIR:-$HOME/.local/bin}"

if [[ ! -x "$build_dir/aseprite" ]]; then
  echo "Aseprite is not built at $build_dir/aseprite" >&2
  echo "Run scripts/build-ubuntu.sh first." >&2
  exit 1
fi

install -d "$install_dir" "$bin_dir"
cp -a "$build_dir/." "$install_dir/"
ln -sfn "$install_dir/aseprite" "$bin_dir/aseprite"

printf 'Installed Aseprite files in: %s\n' "$install_dir"
printf 'Command-line launcher: %s\n' "$bin_dir/aseprite"

