have() { command -v "$1" >/dev/null 2>&1; }

require_cmd() {
  have "$1" || fail "Required command '$1' not found"
}

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }

require_macos() { is_macos || fail "This script runs on macOS only."; }
require_linux() { is_linux || fail "This script runs on Linux only."; }
