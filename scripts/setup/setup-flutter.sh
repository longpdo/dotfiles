# Bash script to setup a Flutter development environment - until there is a complete homebrew approach
# Dependencies: homebrew
#
# Add following paths to .zshrc
# export INTEL_HAXM_HOME=/usr/local/Caskroom/intel-haxm
# export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# asdf for dart, flutter and ruby runtimes
brew install asdf
brew install android-sdk
# haxm for faster flutter rendering
brew install haxm
# adoptopenjdk8 for sdkmanager
brew cask install adoptopenjdk8

asdf plugin install dart https://github.com/patoconnor43/asdf-dart.git
asdf plugin-add flutter
asdf plugin install ruby https://github.com/asdf-vm/asdf-ruby.git

asdf install dart 2.7.0
asdf install flutter 1.12.13+hotfix.7-stable
asdf install ruby 2.3.7

asdf global dart 2.7.0
asdf global flutter 1.12.13+hotfix.7-stable
asdf global ruby 2.3.7

# Install -v 1.7.5 if pod setup does not work
gem install cocoapods

pod setup

sudo xcodebuild -license
flutter doctor --android-licenses

# Check if all dependencies are installed
sdkmanager

flutter doctor -v
