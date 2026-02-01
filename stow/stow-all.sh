#!/usr/bin/env bash
set -euo pipefail

STOW_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$STOW_DIR"

PACKAGES=(
  zsh
  git
  starship
  ghostty
)

STOW_FLAGS=(--target "$HOME" --verbose)

# Dry-run support
if [[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]]; then
  STOW_FLAGS+=(--no)
  echo "[DRY-RUN] No changes will be made"
fi

stow "${STOW_FLAGS[@]}" "${PACKAGES[@]}"
