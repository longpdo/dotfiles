#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"

main() {
  require_macos
  require_cmd brew

  log "Updating Homebrew metadata"
  brew update
  ok "brew update completed"

  log "Upgrading installed formulae and casks"
  brew upgrade
  ok "brew upgrade completed"

  log "Removing unused dependencies"
  brew autoremove || true

  log "Cleaning up old versions and caches"
  brew cleanup
  ok "brew cleanup completed"

  log "Running brew doctor (non-fatal)"
  if brew doctor; then
    ok "brew doctor looks good"
  else
    warn "brew doctor reported issues (often informational)"
  fi

  ok "Homebrew maintenance complete"
}

main "$@"
