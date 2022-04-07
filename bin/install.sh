#!/usr/bin/env bash

# Initially symlinks various files as needed for .dotfiles-harrison to function

# assume that .dotfiles-harrison is the default location where the repo has been cloned
DEFAULT_DOTFILES_HOME=$HOME/.dotfiles-harrison

# symlinks a file $DEFAULT_DOTFILES_HOME/<from> $HOME/<to>
# <from> is implicitly relative to $DEFAULT_DOTFILES_HOME
symlink () {
  local from="$1"

  ln -s -f -v $DEFAULT_DOTFILES_HOME/$from $HOME/$from 
}

symlink .zshrc
symlink .vimrc
symlink .vim
symlink .gitconfig
symlink .psqlrc
