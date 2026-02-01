#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "microsoft-excel" --cask --app-path "/Applications/Microsoft Excel.app"
  ok "Microsoft Excel bootstrap complete"
}

main "$@"
