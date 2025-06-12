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
  echo "🔗 Linking $from"
  ln -s -f -v $DEFAULT_DOTFILES_HOME/$from $HOME/$from
}

echo "────────────────────────────────────"
color_echo purple "📦 Dotfiles Installation"
echo "────────────────────────────────────"

# Back up existing zshrc before we overwrite it with our symlink
if [[ -f ~/.zshrc ]] ; then
	echo "💾 Backing up existing ~/.zshrc"
    echo "# Saved ~/.zshrc to ~/.zshrc_local during .dotfiles-harrison install" > ~/.zshrc_local
	cat ~/.zshrc >> ~/.zshrc_local
    color_echo green "   Backup saved to ~/.zshrc_local"
fi

echo
color_echo blue "🔗 Creating symlinks..."
# Create symlinks for core dotfiles
symlink .zshrc
symlink .vimrc
symlink .vim
symlink .gitconfig
symlink .psqlrc

echo
echo "📁 Setting up Neovim config..."
# Create Neovim config directory and symlink our init.lua
mkdir -p ~/.config/nvim
ln -s -f -v $DEFAULT_DOTFILES_HOME/init.lua ~/.config/nvim/init.lua

echo
color_echo green "✅ Installation complete!"
echo "   Run 'source ~/.zshrc' to activate your dotfiles"
