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