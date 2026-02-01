#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "microsoft-teams" --cask --app-path "/Applications/Microsoft Teams.app"
  ok "Microsoft Teams bootstrap complete"
}

main "$@"
