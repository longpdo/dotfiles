#!/usr/bin/env bash
set -euo pipefail

# Log Helper (green OK)
_ok() { printf "\033[32m[ok]\033[0m %s\n" "$1"; }

SCRIPTS_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Ensure rg exists (optional, but avoids confusing failures)
command -v rg >/dev/null 2>&1 || { echo "rg not found (ripgrep). Install it first."; exit 1; }

# Find *.sh files safely (null-delimited), handle spaces/newlines in filenames.
rg -t sh --files --null "$SCRIPTS_PATH" |
while IFS= read -r -d '' script; do
  # Only change if not executable already
  if [[ ! -x "$script" ]]; then
    chmod +x "$script"
    _ok "chmod +x: $script"
  fi
done
