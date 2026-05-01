#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"

main() {
  require_macos

  log "Requesting sudo privileges (for macOS updates)"
  sudo -v

  # Keep sudo alive during the run
  while true; do
    sudo -v
    sleep 30
  done >/dev/null 2>&1 &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" >/dev/null 2>&1 || true' EXIT

  log "Checking macOS software updates"
  local out
  out="$(softwareupdate -l 2>&1 || true)"

  if echo "$out" | grep -q "No new software available"; then
    ok "macOS is up to date"
    ok "macOS maintenance complete"
    return 0
  fi

  changed "macOS updates available"
  log "Installing macOS updates (may require restart)"
  sudo softwareupdate -ia --verbose
  changed "macOS updates installed (if applicable)"

  ok "macOS maintenance complete"
}

main "$@"
