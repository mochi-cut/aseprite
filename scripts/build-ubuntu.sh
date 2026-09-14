#!/usr/bin/env bash
set -Eeuo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ ! -f /etc/os-release ]]; then
  echo "Cannot identify this operating system." >&2
  exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release
if [[ "${ID:-}" != "ubuntu" && "${ID_LIKE:-}" != *debian* ]]; then
  echo "This script supports Ubuntu/Debian systems (detected: ${ID:-unknown})." >&2
  exit 1
fi

if [[ "${1:-}" != "--skip-deps" ]]; then
  sudo apt-get update
  sudo apt-get install -y \
    g++ clang cmake ninja-build curl unzip \
    libx11-dev libxcursor-dev libxi-dev libxrandr-dev \
    libgl1-mesa-dev libfontconfig1-dev
fi

cd "$repo_dir"
git submodule update --init --recursive
./build.sh --auto --norun

printf '\nBuild complete: %s\n' "$repo_dir/build/bin/aseprite"

