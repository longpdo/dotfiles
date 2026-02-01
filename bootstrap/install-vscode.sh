#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "visual-studio-code" --cask --app-path "/Applications/Visual Studio Code.app"
  ok "VS Code bootstrap complete"
}

main "$@"
