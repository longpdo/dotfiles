#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib/common.sh"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAINT_DIR="$ROOT/maintenance"

run() {
  local script="$1"
  [[ -x "$script" ]] || fail "Script not found or not executable: $script (chmod +x $script)"
  log "Running $(basename "$script")"
  "$script"
}

main() {
  require_macos
  log "Starting maintenance run"

  run "$MAINT_DIR/update-macos.sh"
  run "$MAINT_DIR/update-brew.sh"

  ok "All maintenance completed"
}

main "$@"
