#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

ensure_sketchybar_tap() {
  log "Ensuring FelixKratz/formulae tap is available"

  if brew tap | rg -qx 'FelixKratz/formulae'; then
    ok "FelixKratz/formulae tap already added"
  else
    brew tap FelixKratz/formulae
    changed "FelixKratz/formulae tap added"
  fi
}

main() {
  require_macos
  ensure_sketchybar_tap
  brew_ensure "sketchybar"
  ok "SketchyBar bootstrap complete"
}

main "$@"
