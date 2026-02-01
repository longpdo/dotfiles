# ------------------------------------------------------------
# Zsh options
# ------------------------------------------------------------
setopt AUTO_CD

setopt ALWAYS_TO_END
setopt AUTO_LIST
setopt COMPLETE_IN_WORD
setopt MENU_COMPLETE
setopt NO_LIST_BEEP

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

setopt RM_STAR_SILENT

setopt NO_BG_NICE
setopt NO_HUP

# The file to save the history in when an interactive shell exits.
HISTFILE="$HOME/.zsh_history"
# The maximum number of events stored in the internal history list.
HISTSIZE=50000
# Set maximum number of history events to save in the history file.
SAVEHIST=10000
