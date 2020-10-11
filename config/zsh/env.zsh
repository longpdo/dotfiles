# Setting and editing of env variables

# VARIABLES
export EDITOR='code'
export VISUAL='nano' # set to nano to edit crontabs
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home"
export TERM="xterm-256color"

# PATHS
# Set ruby installed by Homebrew first in your PATH
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="${PATH}:/usr/local/opt/coreutils/libexec/gnubin"
export PATH="${PATH}:/usr/local/opt/findutils/libexec/gnubin"
export PATH="${PATH}:/usr/local/opt/grep/libexec/gnubin"
export PATH="${PATH}:/usr/local/opt/bc/bin"
export PATH="${PATH}:/usr/local/opt/fzf/bin"
export PATH="${PATH}:/Users/longdo/.gem/ruby/2.7.0/bin"
export PATH="${PATH}:/Users/longdo/.local/bin"
export PATH="${PATH}:/Users/longdo/repos/flutter/bin"
export PATH="$HOME/.jenv/bin:$PATH"
