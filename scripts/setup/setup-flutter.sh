#!/bin/bash

# Bash script to setup a Flutter development environment - until there is a complete homebrew approach
# Dependencies: homebrew
#
# Add following paths to .zshrc
# export INTEL_HAXM_HOME=/usr/local/Caskroom/intel-haxm
# export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# Log Helper
_info()    { echo -e "\033[1m[INFO]\033[0m $1" ; }
_ok()      { echo -e "\033[32m[OK]\033[0m $1" ; }

_info "Installing asdf for dart, flutter and ruby runtimes"
brew install asdf && _ok ""

_info "Installing android-sdk"
brew install android-sdk && _ok ""

_info "Installing haxm for faster flutter rendering"
brew install haxm && _ok ""

_info "Installing adoptopenjdk8 for sdkmanager"
brew cask install adoptopenjdk8 && _ok ""

_info "Installing asdf plugins for dart, flutter and ruby"
asdf plugin install dart https://github.com/patoconnor43/asdf-dart.git && _ok ""
asdf plugin-add flutter && _ok ""
asdf plugin install ruby https://github.com/asdf-vm/asdf-ruby.git && _ok ""

_info "Installing versions of dart, flutter and ruby"
asdf install dart 2.7.0 && _ok ""
asdf install flutter 1.12.13+hotfix.7-stable && _ok ""
asdf install ruby 2.3.7 && _ok ""

_info "Setting global version for dart, flutter and ruby"
asdf global dart 2.7.0 && _ok ""
asdf global flutter 1.12.13+hotfix.7-stable && _ok ""
asdf global ruby 2.3.7 && _ok ""

_info "Installing cocoapods"
# Install -v 1.7.5 if pod setup does not work
gem install cocoapods && _ok ""

_info "Running pod setup"
pod setup && _ok ""

_info "Accepting licenses"
sudo xcodebuild -license && _ok ""
flutter doctor --android-licenses && _ok ""

_info "Checking if all dependencies are installed"
sdkmanager && _ok ""

flutter doctor -v && _ok ""
