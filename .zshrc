# Init Antibody and load plugins
source <(antibody init)
antibody bundle < ~/dotfiles/zsh/plugins.txt

# Load custom zsh files
source ~/dotfiles/zsh/env.zsh
source ~/dotfiles/zsh/options.zsh

source ~/dotfiles/zsh/alias.zsh
source ~/dotfiles/zsh/functions.zsh
source ~/dotfiles/zsh/p10k.zsh
