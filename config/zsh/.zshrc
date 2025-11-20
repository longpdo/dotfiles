# IMPORTANT: Changes here do not mirror to ~/.zshrc anymore, since the symlink now points to the mackup backup.

# Activate antidote
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
# Static loading: Run antibody only when plugins.txt changed, else load the “static” plugins file
antidote bundle < ~/dev/dotfiles/config/antibody/plugins.txt > ~/dev/dotfiles/config/antibody/plugins.zsh
source ~/dev/dotfiles/config/antibody/plugins.zsh

for file in  ~/dev/dotfiles/config/zsh/*.zsh; do source $file; done
