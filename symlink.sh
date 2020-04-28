#!/usr/bin/env bash

# Include library helper for colorized echo
source ./library/helper_install.sh

# Variables
dir=~/dotfiles
olddir=~/dotfiles_old
files=".gitconfig .zshrc"

bot "Symlinking dotfiles..."
running "Creating $olddir for backup of any existing dotfiles in home directory"
mkdir -p $olddir
ok

running "Changing to the $dir directory"
cd $dir
ok

action "Saving old dotfiles and creating symlinks..."
for file in $files; do
    running "$file"
    mv ~/$file ~/dotfiles_old/
    ln -s $dir/$file ~/$file
    ok
done
