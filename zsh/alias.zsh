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
alias py='python3'
alias kill="fkill"
