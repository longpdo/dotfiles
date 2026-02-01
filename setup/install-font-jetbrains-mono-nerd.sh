#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

main() {
  require_macos
  brew_ensure "font-jetbrains-mono-nerd-font" --cask
  ok "JetBrains Mono Nerd Font bootstrap complete"
}

main "$@"
