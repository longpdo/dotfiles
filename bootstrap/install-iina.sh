#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "iina" --cask --app-path "/Applications/IINA.app"
  ok "IINA bootstrap complete"
}

main "$@"
