#!/usr/bin/env bash

# Log Helper
info() { echo -e "\033[1m[INFO]\033[0m $1" ; }
ok()   { echo -e "\033[32m[OK]\033[0m $1" ; }

function runScripts() {
    # Ask for the administrator password upfront
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until the script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # Run sections based on command line arguments
    for ARG in "$@"
    do
        if [ "$ARG" == "init" ] || [ "$ARG" == "all" ]; then
            info "Starting init.sh script..."
            ./scripts/setup/init.sh
        fi
        if [ "$ARG" == "brew" ] || [ "$ARG" == "all" ]; then
            info "Starting brew.sh script..."
            ./scripts/setup/brew.sh
        fi
        if [ "$ARG" == "macos" ] || [ "$ARG" == "all" ]; then
            info "Starting macos.sh script..."
            ./scripts/setup/macos.sh
        fi
        if [ "$ARG" == "config" ] || [ "$ARG" == "all" ]; then
            info "Starting config.sh script..."
            ./scripts/setup/config.sh
        fi
    done
    ok "Completed running setup.sh, restart your computer to ensure all updates take effect"
}

read -r -p "This script may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    runScripts "$@"
fi;

unset runScripts;
