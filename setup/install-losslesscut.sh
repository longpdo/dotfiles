#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "losslesscut" --cask --app-path "/Applications/LosslessCut.app"
  ok "LosslessCut bootstrap complete"
}

main "$@"
