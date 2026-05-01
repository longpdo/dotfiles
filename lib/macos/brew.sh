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