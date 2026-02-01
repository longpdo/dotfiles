#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "microsoft-powerpoint" --cask --app-path "/Applications/Microsoft PowerPoint.app"
  ok "Microsoft PowerPoint bootstrap complete"
}

main "$@"
