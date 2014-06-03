#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles
############################

########## Variables

dir=~/.dotfiles-harrison                    # dotfiles directory
olddir=~/.dotfiles-harrison-old             # old dotfiles backup directory
files="gitconfig vimrc vim zshrc oh-my-zsh zsh-update zsh-remote-aliases"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/.dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
    echo "done"
done

# link my .zshrc and zshrc inside of .dotfiles-harrison
mv $dir/.zshrc $olddir
echo "Creating symlink to .zshrc in .dotfiles-harrison directory."
ln -s $dir/zshrc $dir/.zshrc
echo "done"
