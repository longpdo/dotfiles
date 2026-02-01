# ------------------------------------------------------------
# OS detection
# ------------------------------------------------------------
case "$OSTYPE" in
  darwin*) IS_MAC=1 ;;
  linux*)  IS_LINUX=1 ;;
  *)       IS_MAC=0; IS_LINUX=0 ;;
esac

# ------------------------------------------------------------
# Homebrew (macOS only)
# ------------------------------------------------------------
if [[ -n "$IS_MAC" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
  fi
fi

# ------------------------------------------------------------
# Variables
# ------------------------------------------------------------
if command -v code >/dev/null 2>&1; then
  export EDITOR='code'
elif command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

export VISUAL='nano'   # set to nano to edit crontabs

# ------------------------------------------------------------
# PATH (use zsh path array; auto-dedup)
# ------------------------------------------------------------
typeset -U path PATH

# user bins
path=(
  $HOME/.local/bin
  $path
)

# brew-installed tool bins (macOS only; guarded)
if [[ -n "$IS_MAC" ]] && command -v brew >/dev/null 2>&1; then
  fzf_base="$(brew --prefix fzf 2>/dev/null)"
  [[ -d "$fzf_base/bin" ]] && path=("$fzf_base/bin" $path)
fi

export PATH
