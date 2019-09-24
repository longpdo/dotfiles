HISTSIZE=50000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell

setopt auto_cd
setopt auto_list
setopt auto_menu
setopt always_to_end
setopt complete_in_word
unsetopt flow_control
unsetopt menu_complete

# Completion
zstyle ':completion:*' menu select 'm:{a-z}={A-Z}'
autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Setup fzf: Auto-completion + Key bindings
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--reverse --border --exact'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_TRIGGER=',,'
export FZF_COMPLETION_OPTS='--reverse --border --exact --height 40%'
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
