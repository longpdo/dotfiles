# ------------------------------------------------------------
# Zinit
# ------------------------------------------------------------
# Try common locations (macOS brew, Linux package, local)
if command -v brew >/dev/null 2>&1 && [[ -r "$(brew --prefix zinit 2>/dev/null)/zinit.zsh" ]]; then
  source "$(brew --prefix zinit)/zinit.zsh"
elif [[ -r "/usr/share/zinit/zinit.zsh" ]]; then
  source "/usr/share/zinit/zinit.zsh"
elif [[ -r "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
else
  echo "zinit not found; skipping plugin loading" >&2
fi

# ------------------------------------------------------------
# Completions (zinit-managed; DO NOT run compinit manually later)
# ------------------------------------------------------------
zinit ice wait'0' lucid blockf atinit'zicompinit; zicdreplay'
zinit light zsh-users/zsh-completions

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ------------------------------------------------------------
# Plugins
# ------------------------------------------------------------
zinit ice wait'1' lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait'1' lucid atload'
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
'
zinit light zsh-users/zsh-history-substring-search

zinit ice wait'2' lucid
zinit light zdharma/fast-syntax-highlighting

zinit ice wait'2' lucid
zinit light zdharma/history-search-multi-word
