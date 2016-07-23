# Main Zshrc that loads all other parts of the dotfiles

# Where the dotfiles are located to load
DOTFILES=$HOME/.dotfiles-harrison

# turn on zsh options
source $DOTFILES/zshrc.lib/setopts.zsh

# autoload zsh functions
source $DOTFILES/zshrc.lib/autoloads.zsh

# load globals
source $DOTFILES/zshrc.lib/globals.zsh

# check and apply updates
source $DOTFILES/zshrc.lib/updater.zsh

# set the version after attempting to update
DOTFILES_VERSION=`cat $DOTFILES/VERSION`

# setup the environment variables
source $DOTFILES/zshrc.lib/environment.zsh

# Source my files
for file in $DOTFILES/zshrc.d/* ; do
    source $file
done

# TODO: gut this
plugins=(git-extras sudo web-search command-not-found zsh-syntax-highlighting gitfast)
source $DOTFILES/oh-my-zsh/oh-my-zsh.sh

# Source any local files for custom environments
if [ -f $HOME/.zshrc_local ] ; then
    source $HOME/.zshrc_local
fi

# source the prompt
source $DOTFILES/zshrc.lib/prompt.zsh

# source all exit tasks
source $DOTFILES/zshrc.lib/exit-tasks.zsh
