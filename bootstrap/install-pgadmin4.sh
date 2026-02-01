#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "pgadmin4" --cask --app-path "/Applications/pgAdmin 4.app"
  ok "pgAdmin 4 bootstrap complete"
}

main "$@"
