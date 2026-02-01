x###############################################################################
# Homebrew                                                                    #
###############################################################################

_info "Installing binaries, terminal stuff, CLI..."
_BINARIES=(
  ffmpeg
  findutils
  git-redate
  media-info
  ocrmypdf
  pdfgrep
  rename
  scrcpy
  tesseract-lang # language packs for ocr
  wget
)

# pigar
# flake8

_info "Installing dev environment..."
_DEV_LIBRARIES=(
  jenv
)

_info "Installing dev tool casks..."
_DEV_CASKS=(
  chromedriver
)

_info "Installing misc casks..."
# Dropbox was already installed via update.sh
_MISC_CASKS=(
  appcleaner
  jdownloader
  kap
  karabiner-elements
  kodi
  mkvtoolnix
  musicbrainz-picard
  the-unarchiver
)
for cask in "${_MISC_CASKS[@]}"; do
  _info "installing $cask"
  brew cask install "$cask" || error "failed brew cask install $cask"
done

_info "Installing quick look plugins..."
# Reference: https://github.com/sindresorhus/quick-look-plugins/blob/master/readme.md
_PLUGINS=(
  qlcolorcode
  qlstephen
  qlmarkdown
  quicklook-json
  qlvideo
)

###############################################################################
# npm                                                                         #
###############################################################################
_info "Installing npm packages..."
npm install -g @angular/cli || _error "failed npm install @angular/cli"
npm install -g fkill-cli || _error "failed npm install fkill-cli"
npm install -g typescript || _error "failed npm install typescript"
