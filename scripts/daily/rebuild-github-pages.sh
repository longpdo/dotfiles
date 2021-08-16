#!/bin/bash

# Trigger new builds for repositories deployed on Github Pages

# Log Helper
_ok() { echo -e "\033[32m[OK]\033[0m $1" ; }

# Load GITHUB_TOKEN from .env
export "$(grep -E -v '^#' "$DOTFILES_PATH.env" | xargs)"

# Declare repositories, where new build should be triggered
declare -a _repositories=("longpdo.github.io" "neumorphism")

# For every declared repository
for repo in "${_repositories[@]}"; do
  # Trigger new build and log on success
  curl --silent --output /dev/null --show-error -u longpdo:"$GITHUB_TOKEN" -X POST https://api.github.com/repos/longpdo/"$repo"/pages/builds && _ok "triggered new build of $repo"
done
