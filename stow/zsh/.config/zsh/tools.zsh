# ------------------------------------------------------------
# zoxide
# ------------------------------------------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# ------------------------------------------------------------
# fzf
# ------------------------------------------------------------
if command -v rg >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files'
fi

export FZF_DEFAULT_OPTS="--reverse --border --exact --ansi \
  --bind=ctrl-k:preview-up \
  --bind=ctrl-j:preview-down \
  --bind=ctrl-r:toggle-all \
  --height=100% \
  --preview-window=right:60%"

export FZF_COMPLETION_OPTS="--reverse --border --exact --height 40%"

# fzf completion + keybindings
if [[ -n "$IS_MAC" ]] && command -v brew >/dev/null 2>&1; then
  fzf_base="$(brew --prefix fzf 2>/dev/null)"
  [[ -r "$fzf_base/shell/completion.zsh" ]] && source "$fzf_base/shell/completion.zsh"
  [[ -r "$fzf_base/shell/key-bindings.zsh" ]] && source "$fzf_base/shell/key-bindings.zsh"
elif [[ -r "/usr/share/fzf/key-bindings.zsh" ]]; then
  source "/usr/share/fzf/key-bindings.zsh"
  [[ -r "/usr/share/fzf/completion.zsh" ]] && source "/usr/share/fzf/completion.zsh"
fi

# ------------------------------------------------------------
# kubectl completion
# ------------------------------------------------------------
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh) 2>/dev/null
fi

# ------------------------------------------------------------
# history-search-multi-word styles
# ------------------------------------------------------------
# Number of entries to show (default is $LINES/3)
zstyle ":history-search-multi-word" page-size "14"
# Color in which to highlight matched, searched text (default bg=17 on 256-color terminals)
zstyle ":history-search-multi-word" highlight-color "fg=yellow,bold"
# Whether to perform syntax highlighting (default true)
zstyle ":plugin:history-search-multi-word" synhl "yes"
# Effect on active history entry. Try: standout, bold, bg=blue (default underline)
zstyle ":plugin:history-search-multi-word" active "underline"
# Whether to check paths for existence and mark with magenta (default true)
zstyle ":plugin:history-search-multi-word" check-paths "yes"
# Whether pressing Ctrl-C or ESC should clear entered query
zstyle ":plugin:history-search-multi-word" clear-on-cancel "no"

# ------------------------------------------------------------
# starship
# ------------------------------------------------------------
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
