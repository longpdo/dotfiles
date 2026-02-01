# Only run the rest in interactive shells
[[ $- == *i* ]] || return

ZSH_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

for f in \
  "$ZSH_DIR/env.zsh" \
  "$ZSH_DIR/zinit.zsh" \
  "$ZSH_DIR/options.zsh" \
  "$ZSH_DIR/tools.zsh" \
  "$ZSH_DIR/aliases.zsh"
do
  [[ -r "$f" ]] && source "$f"
done