# IMPORTANT: Changes here do not mirror to ~/.zshrc anymore, since the symlink now points to the mackup backup.

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
source ~/dev/dotfiles/config/zsh/p10k.zsh

# Static loading: Run antibody only when plugins.txt changed, else load the “static” plugins file
antibody bundle < ~/dev/dotfiles/config/antibody/plugins.txt > ~/dev/dotfiles/config/antibody/plugins.zsh
source ~/dev/dotfiles/config/antibody/plugins.zsh

# Load custom zsh files
source ~/dev/dotfiles/config/zsh/env.zsh
source ~/dev/dotfiles/config/zsh/options.zsh

source ~/dev/dotfiles/config/zsh/alias.zsh
source ~/dev/dotfiles/config/zsh/functions.zsh

eval "$(lua ~/z.lua --init zsh enhanced once)"
