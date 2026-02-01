#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

ensure_xcode_clt() {
  log "Ensuring Xcode Command Line Tools are installed"
  if xcode-select -p >/dev/null 2>&1; then
    ok "Xcode Command Line Tools already installed"
    return
  fi

  warn "Xcode Command Line Tools not found. Triggering install dialog..."
  xcode-select --install >/dev/null 2>&1 || true

  cat <<'EOF'
Please complete the Xcode Command Line Tools installation dialog,
then re-run this script.
EOF
  exit 1
}

brew_prefix() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    echo "/opt/homebrew"
  elif [[ -x /usr/local/bin/brew ]]; then
    echo "/usr/local"
  else
    echo ""
  fi
}

ensure_brew() {
  log "Ensuring Homebrew is installed"
  if have brew; then
    ok "Homebrew already installed: $(brew --version | head -n1)"
    return
  fi

  log "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  changed "Homebrew installed"
}

ensure_brew_in_path() {
  log "Ensuring Homebrew is on PATH for your shell"

  local prefix
  prefix="$(brew_prefix)"

  [[ -n "$prefix" ]] || { warn "Could not determine Homebrew prefix; skipping PATH setup"; return; }

  local brew_bin="${prefix}/bin/brew"
  [[ -x "$brew_bin" ]] || { warn "brew not found at expected location: $brew_bin"; return; }

  local shellenv_line="eval \"\$(${brew_bin} shellenv)\""
  local any_changed=0

  add_line_if_missing() {
    local file="$1"
    local line="$2"

    [[ -f "$file" ]] || touch "$file"

    if grep -Fqs "$line" "$file"; then
      ok "Already configured in $(basename "$file")"
      return 1
    else
      printf "\n# Homebrew\n%s\n" "$line" >> "$file"
      changed "Added Homebrew shellenv to $(basename "$file")"
      return 0
    fi
  }

  if add_line_if_missing "$HOME/.zshrc" "$shellenv_line"; then any_changed=1; fi
  if add_line_if_missing "$HOME/.bashrc" "$shellenv_line"; then any_changed=1; fi
  if add_line_if_missing "$HOME/.bash_profile" "$shellenv_line"; then any_changed=1; fi

  # Apply to current session (idempotent)
  eval "$("$brew_bin" shellenv)"

  if [[ "$any_changed" -eq 1 ]]; then
    changed "Homebrew PATH configured (dotfiles updated + shellenv loaded for this session)"
  else
    ok "Homebrew PATH already configured (shellenv loaded for this session)"
  fi
}

main() {
  require_macos
  ensure_xcode_clt
  ensure_brew
  ensure_brew_in_path
  ok "Homebrew bootstrap complete"
}

main "$@"
