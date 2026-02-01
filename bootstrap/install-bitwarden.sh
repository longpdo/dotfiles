#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "bitwarden" --cask --app-path "/Applications/Bitwarden.app"
  ok "Bitwarden bootstrap complete"
}

main "$@"
