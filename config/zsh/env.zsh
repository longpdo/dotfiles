# Setting and editing of env variables

# VARIABLES
export EDITOR='code'
export VISUAL='nano' # set to nano to edit crontabs
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home"
export TERM="xterm-256color"
export USER_PATH="/Users/saltukkezer"
export DOTFILES_PATH="$USER_PATH/dev/dotfiles"

# PATHS
# Set ruby installed by Homebrew first in your PATH
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="${PATH}:/usr/local/opt/coreutils/libexec/gnubin"
export PATH="${PATH}:/usr/local/opt/findutils/libexec/gnubin"
export PATH="${PATH}:/usr/local/opt/grep/libexec/gnubin"
export PATH="${PATH}:/usr/local/opt/bc/bin"
export PATH="${PATH}:/usr/local/opt/fzf/bin"
export PATH="${PATH}:$USER_PATH/.gem/ruby/3.0.0/bin"
export PATH="${PATH}:$USER_PATH/.local/bin"
export PATH="${PATH}:$USER_PATH/repos/flutter/bin"
export PATH="$HOME/.jenv/bin:$PATH"