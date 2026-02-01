#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

main() {
  require_macos

  log "Ensuring Jekyll toolchain is installed"
  brew_ensure "jekyll"
  brew_ensure "bundler"

  ok "Jekyll toolchain bootstrap complete"
}

main "$@"
