#!/usr/bin/env bash
set -euo pipefail

log()     { printf "\n\033[1;34m==>\033[0m %s\n" "$*"; }
warn()    { printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }
ok()      { printf "\033[1;32m[ok]\033[0m %s\n" "$*"; }
changed() { printf "\033[1;33m[changed]\033[0m %s\n" "$*"; }
fail()    { printf "\033[1;31m[failed]\033[0m %s\n" "$*"; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

require_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || fail "This script runs on macOS only."
}

require_cmd() {
  have "$1" || fail "Required command '$1' not found"
}

brew_ensure() {
  local name="$1"; shift || true

  local kind="formula"   # formula | cask
  local app_path=""      # optional (only for casks)

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --cask)     kind="cask"; shift ;;
      --formula)  kind="formula"; shift ;;
      --app-path) app_path="${2:-}"; shift 2 ;;
      *)
        fail "brew_ensure: unknown argument: $1"
        ;;
    esac
  done

  if [[ "$kind" == "cask" ]]; then
    log "Ensuring $name is installed (Homebrew cask)"

    if brew list --cask "$name" >/dev/null 2>&1; then
      ok "$name already installed"
    else
      brew install --cask "$name"
      changed "$name installed"
    fi

    if [[ -n "$app_path" ]]; then
      remove_quarantine_if_present "$app_path"
    fi
  else
    log "Ensuring $name is installed (Homebrew formula)"

    if brew list --formula "$name" >/dev/null 2>&1; then
      ok "$name already installed"
    else
      brew install "$name"
      changed "$name installed"
    fi
  fi
}

remove_quarantine_if_present() {
  local app_path="$1"
  local app_name
  app_name="$(basename "$app_path")"

  if [[ ! -d "$app_path" ]]; then
    warn "App not found at: $app_path (skipping quarantine removal)"
    return 0
  fi

  if ! xattr -p com.apple.quarantine "$app_path" >/dev/null 2>&1; then
    ok "No quarantine flag present for $app_name"
    return 0
  fi

  log "Removing quarantine flag from $app_name"

  # Try without sudo first (often works)
  if xattr -dr com.apple.quarantine "$app_path" >/dev/null 2>&1; then
    changed "Quarantine flag removed for $app_name"
    return 0
  fi

  # If permissions require sudo, do it non-interactively to avoid repeated prompts.
  if sudo -n xattr -dr com.apple.quarantine "$app_path" >/dev/null 2>&1; then
    changed "Quarantine flag removed for $app_name (via sudo)"
    return 0
  fi

  # If sudo isn't currently authorized, fall back to interactive once (should be covered by install-all keepalive)
  sudo xattr -dr com.apple.quarantine "$app_path"
  changed "Quarantine flag removed for $app_name (via sudo)"
}
