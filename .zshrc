export TERM="xterm-256color"

# PATHS
export ZSH="/Users/longdo/.oh-my-zsh"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home"
eval $(thefuck --alias)
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH=$(cd $HOME/.gem/ruby/*/bin; pwd):$PATH
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(git osx)

# Load extensions
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Remove default aliases
unalias -a

# Easier navigation: .., ..., ...., .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Aliases replacing common apps with better alternatives
alias cat="bat"
alias cp='cp -v'
alias loc="tokei"
alias ls="exa"
alias man="tldr"
alias mv='mv -v'
alias rm="trash -v"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Shortcuts
alias e="code --wait"
alias l="exa -lgh"
alias la="exa -lagh"
alias lt="exa -T"
alias md="mkdir -p"
alias o="open"
alias oo="open ."
alias kill="fkill"

# Functions

#like normal autojump when used with arguments but displays an fzf prompt when used without
j() {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sed '/_____/Q; s/^[0-9,.:]*\s*//' | sort -r | fzf --height 40% --reverse --inline-info)" 
}

# fh - repeat history #TODO new name for function
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fbr - checkout git branch (including remote branches)
gco() {
  local branches target
  branches=$(
    git branch --all | grep -v HEAD |
    sed "s/.* //" |
    sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches") |
    fzf --no-hscroll --no-multi --delimiter="\t" -n 2 \
        --ansi --preview="git log -200 --pretty=format:%s $(echo {+2..} |  sed 's/$/../' )" ) || return
  git checkout $(echo "$target" | awk '{print $2}' | sed "s#remotes/[^/]*/##")
}

# fshow - git commit browser
glog() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | diff-so-fancy | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

#browse chrome bookmarks #TODO rename ruby script and place the script in github folder 
b() {
  ~/Downloads/b.rb
}

wifi() {
  airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
  ssid=$($airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
  pw=$(security find-generic-password -D 'AirPort network password' -ga $ssid 2>&1 >/dev/null)
  echo $(echo "$pw" | sed -e "s/^.*\"\(.*\)\".*$/\1/")
}

yt() {
  youtube-dl $1 -o "~/Downloads/%(title)s.%(ext)s"
}

# POWERLEVEL9K settings
POWERLEVEL9K_MODE="nerdfont-complete"

# ICONS
OS_ICON='\uf179'
POWERLEVEL9K_EXECUTION_TIME_ICON='\uf253'
POWERLEVEL9K_LOCK_ICON='\uf023'
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0BD'
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0BD'
POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON='\uf171'
POWERLEVEL9K_VCS_GIT_GITHUB_ICON='\uF113'
POWERLEVEL9K_VCS_GIT_GITLAB_ICON='\uf296'
POWERLEVEL9K_VCS_GIT_ICON='\uf1d3'
POWERLEVEL9K_VCS_STAGED_ICON='\u00b1'
POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'

# COLOR LEFT PROMPT
#POWERLEVEL9K_OS_ICON_BACKGROUND='green'
#POWERLEVEL9K_OS_ICON_FOREGROUND='black'
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND='red'
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND='black'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='black'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='green'
POWERLEVEL9K_DIR_HOME_BACKGROUND='black'
POWERLEVEL9K_DIR_HOME_FOREGROUND='green'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='black'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='green'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='green'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='red'

# COLOR RIGHT PROMPT
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='red'
POWERLEVEL9K_STATUS_ERROR_FOREGROUND='black'
#POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='green'
#POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='black'
#POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
POWERLEVEL9K_TIME_BACKGROUND='green'
POWERLEVEL9K_TIME_FOREGROUND='black'
#POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S \uf073 %d.%m}'

# DOUBLE LINED PROMPT
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%f'
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%F{black}%K{green}%} \uf179 %{%f%k%F{green}%} %{%f%}"
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir_writable dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
export PATH="/usr/local/opt/bc/bin:$PATH"
