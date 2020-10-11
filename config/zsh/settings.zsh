# The file to save the history in when an interactive shell exits.
HISTFILE=~/.zsh_history
# The maximum number of events stored in the internal history list.
HISTSIZE=50000
# Set maximum number of history events to save in the history file.
SAVEHIST=10000

# Setup Completion
autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
  compinit
else
  compinit -C
fi
# Completion: Matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Setup fzf
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--reverse --border --exact --ansi
  --bind='ctrl-k:preview-up'
  --bind='ctrl-j:preview-down'
  --bind='ctrl-r:toggle-all'
  --height='100%'
  --preview-window='right:60%'
  '
export FZF_COMPLETION_OPTS='--reverse --border --exact --height 40%'
# Add fzf completion
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Setup history-search-multi-word plugin
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

# Setup zsh-tab-title plugin
ZSH_TAB_TITLE_ONLY_FOLDER=true
ZSH_TAB_TITLE_CONCAT_FOLDER_PROCESS=true

# Setup wakatime plugin
ZSH_WAKATIME_PROJECT_DETECTION=true

# Init z.lua
eval "$(lua ~/z.lua --init zsh enhanced once)"

# Init jenv
eval "$(jenv init -)"
