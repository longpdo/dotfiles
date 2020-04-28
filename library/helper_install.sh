#!/usr/bin/env bash

# originally from https://github.com/atomantic/dotfiles/blob/master/lib_sh

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function ok() {
    echo -e "$COL_GREEN[ok]$COL_RESET "$1
}

function bot() {
    echo -e "\n$COL_GREEN(⩾﹏⩽)$COL_RESET - "$1
}

function running() {
    echo -en "$COL_YELLOW ⇒ $COL_RESET"$1": "
}

function action() {
    echo -e "\n$COL_YELLOW[action]:$COL_RESET ⇒ $1"
}

function warn() {
    echo -e "$COL_YELLOW[warning]$COL_RESET "$1
}

function error() {
    echo -e "$COL_RED[error]$COL_RESET "$1
}

function install_brew() {
    running "brew $1 $2"
    brew list $1 > /dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        action "brew install $1 $2"
        brew install $1 $2
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
        fi
    fi
    ok
}

function install_cask() {
    running "brew cask $1"
    brew cask list $1 > /dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        action "brew cask install $1 $2"
        brew cask install $1
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
        fi
    fi
    ok
}

function install_code() {
    running "checking vs code extension: $1"
    code --list-extensions | grep $1@ > /dev/null
    if [[ $? != 0 ]]; then
        action "code --install-extension $1"
        code --install-extension $1
    fi
    ok
}

function install_gem() {
    running "gem $1"
    if [[ $(gem list --local | grep $1 | head -1 | cut -d' ' -f1) != $1 ]];
        then
            action "gem install $1"
            gem install $1
    fi
    ok
}

function install_gem_local() {
    running "gem $1"
    if [[ $(gem list --local | grep $1 | head -1 | cut -d' ' -f1) != $1 ]];
        then
            action "gem install $1"
            gem install --user-install $1
    fi
    ok
}

function install_mas() {
    running "mas $1"
    if [[ $(mas list | grep $1 | head -1 | cut -d' ' -f1) != $1 ]];
        then
            action "mas install $1"
            mas install $1
    fi
    ok
}

function install_npm() {
    sourceNVM
    nvm use stable
    running "npm $*"
    npm list -g --depth 0 | grep $1@ > /dev/null
    if [[ $? != 0 ]]; then
        action "npm install -g $*"
        npm install -g $@
    fi
    ok
}

function install_tap() {
    running "brew tap $1"
    brew tap list $1 > /dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        action "brew tap $1 $2"
        brew tap $1
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
            # exit -1
        fi
    fi
    ok
}
