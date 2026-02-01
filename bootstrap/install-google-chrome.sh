#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "google-chrome" --cask --app-path "/Applications/Google Chrome.app"
  ok "Google Chrome bootstrap complete"
}

main "$@"
