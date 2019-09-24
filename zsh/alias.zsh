# Remove default aliases
unalias -a

# Easier navigation: .., ..., ...., .....
alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'

# Aliases replacing common apps with better alternatives
alias cat='bat'
alias cp='cp -v'
alias kill='fkill'
alias loc='tokei'
alias ls='exa'
alias man='tldr'
alias mv='mv -v'
alias rm='trash -v'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# Shortcuts
alias b='brew'
alias f='open .'
alias g='git'
alias l='exa -lh'
alias la='exa -lah'
alias o='open'
alias p='python3'
alias p2='python'
alias standup='git standup -A "$(date -d "yesterday 13:00" '+%Y-%m-%d') 00:00:00" -B "$(date -u +"%Y-%m-%d") 10:00" -D human -s'
alias zep='git standup -A "$(date -u +"%Y-%m-%d") 00:00:00" -B "$(date -u +"%Y-%m-%d") 23:59" -D format:%H:%M:%S -s'

# Functions
alias c='open_arg_in_vs_code'
alias cdf='cd_to_current_finder_window'
alias gco='git_checkout_branch_with_fzf'
alias gclean='git_clean_branches'
alias gh='git_open_repo_in_browser'
alias glog='git_commit_log_with_fzf'
alias history='zsh_history_with_fzf'
alias j='jump_to_given_dir_or_with_fzf'
alias mkd='create_dir_and_cd_to_it'
alias update='update_all_and_cleanup'
alias wifi='get_wifi_password'
alias yt='download_youtube_video'
