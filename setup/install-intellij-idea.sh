#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "intellij-idea" --cask --app-path "/Applications/IntelliJ IDEA.app"
  ok "IntelliJ IDEA Ultimate bootstrap complete"
}

main "$@"
