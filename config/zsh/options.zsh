# List of all options: http://zsh.sourceforge.net/Doc/Release/Options.html

# If a command is issued that can’t be executed as a normal command, and the command is the name of a directory, perform the cd command to that directory.
setopt AUTO_CD

# On completion move cursor to the end of the word
setopt ALWAYS_TO_END
# Automatically list choices on an ambiguous completion.
setopt AUTO_LIST
# Cursor stays there and completion is done from both ends.
setopt COMPLETE_IN_WORD
# Insert the first autocomplete match immediately. Then when completion is requested again, remove the first match and insert the second match, etc.
setopt MENU_COMPLETE
# No Beep on an ambiguous completion.
setopt NO_LIST_BEEP

# zsh sessions will append their history list to the history file.
setopt APPEND_HISTORY
# Save each command’s beginning timestamp and the duration to the history file.
setopt EXTENDED_HISTORY
# If the internal history needs to be trimmed to add the current command line, the oldest history event that has a duplicate is deleted before losing a unique event from the list.
setopt HIST_EXPIRE_DUPS_FIRST
# If a new command line being added to the history list duplicates an older one, the older command is removed from the list.
setopt HIST_IGNORE_ALL_DUPS
# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt HIST_IGNORE_DUPS
# Remove command lines from the history list when the first character on the line is a space.
setopt HIST_IGNORE_SPACE
# Remove superfluous blanks from each command line being added to the history list.
setopt HIST_REDUCE_BLANKS
# Whenever the user enters a line with history expansion, don’t execute the line directly; instead, perform history expansion and reload the line into the editing buffer.
setopt HIST_VERIFY
# Append history incrementally.
setopt INC_APPEND_HISTORY
# Share it across zsh sessions.
setopt SHARE_HISTORY

# Do not query the user before executing ‘rm *’ or ‘rm path/*’.
setopt RM_STAR_SILENT

# No background jobs.
setopt NO_BG_NICE
# No HUP signals to running jobs when the shell exits.
setopt NO_HUP
