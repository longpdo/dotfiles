#!/usr/bin/env bash
set -euo pipefail

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=core/log.sh
source "$LIB_DIR/core/log.sh"
# shellcheck source=core/require.sh
source "$LIB_DIR/core/require.sh"
# shellcheck source=macos/quarantine.sh
source "$LIB_DIR/macos/quarantine.sh"
# shellcheck source=macos/brew.sh
source "$LIB_DIR/macos/brew.sh"
