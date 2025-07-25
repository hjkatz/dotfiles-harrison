#!/usr/bin/env bash

# Initially symlinks various files as needed for .dotfiles-harrison to function

# Assume that .dotfiles-harrison is the default location where the repo has been cloned
DEFAULT_DOTFILES_HOME=$HOME/.dotfiles-harrison

# Echos out with color for better visual feedback
# Usage: color_echo red "error message"
color_echo() {
    case $1 in
     red)    color="1;31" ;;
     green)  color="1;32" ;;
     yellow) color="1;33" ;;
     blue)   color="1;34" ;;
     purple) color="1;35" ;;
     cyan)   color="1;36" ;;
     *)      color=$1 ;;
    esac
    shift
    echo -e "\033[${color}m$@\033[0m"
}

# Symlinks a file $DEFAULT_DOTFILES_HOME/<from> $HOME/<to>
# <from> is implicitly relative to $DEFAULT_DOTFILES_HOME
# Uses -f to force overwrite existing symlinks, -v for verbose output
symlink () {
  local from="$1"
  color_echo cyan "🔗 Linking $from"
  ln -s -f -v $DEFAULT_DOTFILES_HOME/$from $HOME/$from
}

echo "────────────────────────────────────"
color_echo purple "📦 Dotfiles Installation"
echo "────────────────────────────────────"

echo
color_echo cyan "🔗 Creating symlinks..."
# Create symlinks for core dotfiles
symlink .zshrc
symlink .vimrc
symlink .vim
symlink .gitconfig
symlink .psqlrc

echo
color_echo cyan "📁 Setting up Neovim config..."
# Create Neovim config directory and symlink our init.lua
mkdir -p ~/.config/nvim
ln -s -f -v $DEFAULT_DOTFILES_HOME/init.lua ~/.config/nvim/init.lua

echo
color_echo green "✅ Installation complete!"
color_echo white "   Run 'source ~/.dotfiles-harrison/zshrc' to activate your dotfiles"
