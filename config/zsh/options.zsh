# List of all options: http://zsh.sourceforge.net/Doc/Release/Options.html

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000

# Changing Directories
# ---------------------
# If a command is issued that can’t be executed as a normal command, and the command is the name of a directory, perform the cd command to that directory. This option is only applicable if the option SHIN_STDIN is set, i.e. if commands are being read from standard input. The option is designed for interactive use; it is recommended that cd be used explicitly in scripts to avoid ambiguity.
setopt AUTO_CD

# Completion
# -----------
# On completion move cursor to the end of the word
setopt ALWAYS_TO_END
# Automatically list choices on an ambiguous completion.
setopt AUTO_LIST
# If unset, the cursor is set to the end of the word if completion is started. Otherwise it stays there and completion is done from both ends.
setopt COMPLETE_IN_WORD
# On an ambiguous completion, instead of listing possibilities or beeping, insert the first match immediately. Then when completion is requested again, remove the first match and insert the second match, etc. When there are no more matches, go back to the first one again. reverse-menu-complete may be used to loop through the list in the other direction. This option overrides AUTO_MENU.
setopt MENU_COMPLETE
# Beep on an ambiguous completion. More accurately, this forces the completion widgets to return status 1 on an ambiguous completion, which causes the shell to beep if the option BEEP is also set; this may be modified if completion is called from a user-defined widget.
setopt NO_LIST_BEEP

# History
# --------
# zsh sessions will append their history list to the history file
setopt APPEND_HISTORY

# Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file. The format of this prefixed data is:
setopt EXTENDED_HISTORY

# If the internal history needs to be trimmed to add the current command line, setting this option will cause the oldest history event that has a duplicate to be lost before losing a unique event from the list. You should be sure to set the value of HISTSIZE to a larger number than SAVEHIST in order to give you some room for the duplicated events, otherwise this option will behave just like HIST_IGNORE_ALL_DUPS once the history fills up with unique events.
setopt HIST_EXPIRE_DUPS_FIRST

# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS
# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt HIST_IGNORE_DUPS

# Remove command lines from the history list when the first character on the line is a space, or when one of the expanded aliases contains a leading space. Only normal aliases (not global or suffix aliases) have this behaviour. Note that the command lingers in the internal history until the next command is entered before it vanishes, allowing you to briefly reuse or edit the line. If you want to make it vanish right away without entering another command, type a space and press return.
setopt HIST_IGNORE_SPACE
# Remove superfluous blanks from each command line being added to the history list.
setopt HIST_REDUCE_BLANKS
# Whenever the user enters a line with history expansion, don’t execute the line directly; instead, perform history expansion and reload the line into the editing buffer.
setopt HIST_VERIFY

# Append history incrementally and share it across sessions
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Input/Output
# -------------
# Do not query the user before executing ‘rm *’ or ‘rm path/*’.
setopt RM_STAR_SILENT

# Job Control
# ------------
# No Run all background jobs at a lower priority. This option is set by default.
setopt NO_BG_NICE
# No Send the HUP signal to running jobs when the shell exits.
setopt NO_HUP

# Completion
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

zstyle ":history-search-multi-word" page-size "14"                      # Number of entries to show (default is $LINES/3)
zstyle ":history-search-multi-word" highlight-color "fg=yellow,bold"   # Color in which to highlight matched, searched text (default bg=17 on 256-color terminals)
zstyle ":plugin:history-search-multi-word" synhl "yes"                 # Whether to perform syntax highlighting (default true)
zstyle ":plugin:history-search-multi-word" active "underline"          # Effect on active history entry. Try: standout, bold, bg=blue (default underline)
zstyle ":plugin:history-search-multi-word" check-paths "yes"           # Whether to check paths for existence and mark with magenta (default true)
zstyle ":plugin:history-search-multi-word" clear-on-cancel "no"        # Whether pressing Ctrl-C or ESC should clear entered query

# Setup fzf: Auto-completion + Key bindings
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='
  --reverse
  --border
  --exact
  --ansi
  --bind='ctrl-k:preview-up'
  --bind='ctrl-j:preview-down'
  --bind='ctrl-r:toggle-all'
  --height='100%'
  --preview-window='right:60%'
  '
export FZF_COMPLETION_OPTS='--reverse --border --exact --height 40%'
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

ZSH_TAB_TITLE_ONLY_FOLDER=true
ZSH_TAB_TITLE_CONCAT_FOLDER_PROCESS=true

# plugin to attribute the project based on either git repository
ZSH_WAKATIME_PROJECT_DETECTION=true
