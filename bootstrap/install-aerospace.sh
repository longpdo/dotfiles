#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "nikitabobko/tap/aerospace" --cask --app-path "/Applications/AeroSpace.app"
  ok "AeroSpace bootstrap complete"
}

main "$@"
