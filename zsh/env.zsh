# Setting and editing of env variables

# Vars
export TERM="xterm-256color"

# PATHS
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH=$(cd $HOME/.gem/ruby/*/bin; pwd):$PATH
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/bc/bin:$PATH"
export PATH="/Users/longdo/repos/flutter/bin:$PATH"
export PATH="/usr/local/opt/fzf/bin:$PATH"

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
