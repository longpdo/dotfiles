#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib/common.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run() {
  local script="$1"

  if [[ ! -x "$script" ]]; then
    fail "Script not found or not executable: $script (chmod +x $script)"
  fi

  log "Running $(basename "$script")"
  "$script"
}

main() {
  log "Starting macOS bootstrap"

  # Front-load sudo and keep it alive for the duration of this script.
  log "Requesting sudo privileges"
  sudo -v

  # Keep sudo alive: refresh timestamp every 30s until script exits.
  while true; do
    sudo -v
    sleep 30
  done >/dev/null 2>&1 &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" >/dev/null 2>&1 || true' EXIT

  run "$SCRIPT_DIR/chmod-x-scripts.sh"

  # INSTALL BLOCK
  run "$SCRIPT_DIR/install-homebrew.sh"

  # --- Dev Packages ---
  run "$SCRIPT_DIR/install-git.sh"                          # VCS
  run "$SCRIPT_DIR/install-jq.sh"                           # JSON processor
  run "$SCRIPT_DIR/install-kubernetes-cli.sh"               # kubectl
  run "$SCRIPT_DIR/install-maven.sh"                        # Java build tool
  run "$SCRIPT_DIR/install-node.sh"                         # JavaScript runtime
  run "$SCRIPT_DIR/install-openjdk21.sh"                    # OpenJDK 21
  run "$SCRIPT_DIR/install-pipx.sh"                         # isolated python apps
  run "$SCRIPT_DIR/install-podman.sh"                       # docker
  run "$SCRIPT_DIR/install-podman-compose.sh"               # docker compose

  # --- Terminal Environment packages ---
  run "$SCRIPT_DIR/install-font-jetbrains-mono-nerd.sh"     # Jetbrains Nerd Font
  run "$SCRIPT_DIR/install-starship.sh"                     # better terminal prompt
  run "$SCRIPT_DIR/install-stow.sh"                         # symlink dotfiles
  run "$SCRIPT_DIR/install-zinit.sh"                        # zsh plugins

  # --- CLI tools ---
  run "$SCRIPT_DIR/install-bat.sh"                          # better cat
  run "$SCRIPT_DIR/install-eza.sh"                          # better ls
  run "$SCRIPT_DIR/install-fastfetch.sh"                    # better neofetch
  run "$SCRIPT_DIR/install-fd.sh"                           # better fd
  run "$SCRIPT_DIR/install-ripgrep.sh"                      # better grep
  run "$SCRIPT_DIR/install-tealdeer.sh"                     # better tldr
  run "$SCRIPT_DIR/install-scc.sh"                          # better loc
  run "$SCRIPT_DIR/install-zoxide.sh"                       # better cd
  
  # --- TUI tools ---
  run "$SCRIPT_DIR/install-fzf.sh"                          # fuzzy finder
  run "$SCRIPT_DIR/install-navi.sh"                         # interactive cheatsheet tool
  run "$SCRIPT_DIR/install-neovim.sh"                       # better vim

  # --- Desktop Environment apps ---
  #run "$SCRIPT_DIR/install-aerospace.sh"                    # tiling window manager, super launcher
  run "$SCRIPT_DIR/install-raycast.sh"                      # better spotlight, spectacle
  #run "$SCRIPT_DIR/install-sketchybar.sh"                   # better status bar

  # --- GUI apps ---
  run "$SCRIPT_DIR/install-bitwarden.sh"                    # password manager
  run "$SCRIPT_DIR/install-bruno.sh"                        # API client
  run "$SCRIPT_DIR/install-firefox-developer-edition.sh"    # browser
  run "$SCRIPT_DIR/install-ghostty.sh"                      # terminal
  run "$SCRIPT_DIR/install-google-chrome.sh"                # browser
  run "$SCRIPT_DIR/install-iina.sh"                         # media player
  run "$SCRIPT_DIR/install-intellij-idea.sh"                # IDE
  run "$SCRIPT_DIR/install-localsend.sh"                    # file sharing
  run "$SCRIPT_DIR/install-losslesscut.sh"                  # video cutter
  run "$SCRIPT_DIR/install-mattermost.sh"                   # chat client
  run "$SCRIPT_DIR/install-microsoft-excel.sh"
  run "$SCRIPT_DIR/install-microsoft-outlook.sh"
  run "$SCRIPT_DIR/install-microsoft-powerpoint.sh"
  run "$SCRIPT_DIR/install-microsoft-teams.sh"
  run "$SCRIPT_DIR/install-microsoft-word.sh"
  run "$SCRIPT_DIR/install-obs.sh"                          # screen recorder
  run "$SCRIPT_DIR/install-obsidian.sh"                     # notes
  run "$SCRIPT_DIR/install-pgadmin4.sh"                     # Postgres client
  run "$SCRIPT_DIR/install-slack.sh"                        # chat client
  run "$SCRIPT_DIR/install-tailscale.sh"                    # vpn
  run "$SCRIPT_DIR/install-vscode.sh"                       # text editor

  log "END of macOS bootstrap"
}

main "$@"
