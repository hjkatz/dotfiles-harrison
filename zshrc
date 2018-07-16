# Main Zshrc that loads all other parts of the dotfiles

# prints debugging info
ENABLE_DEBUGGING=false

# Where the dotfiles are located to load
export DOTFILES=$HOME/.dotfiles-harrison

# run the debugging, if enabled
source $DOTFILES/zshrc.lib/debugging.zsh

# source core functions
source $DOTFILES/zshrc.lib/core_functions.zsh

# source user settings
source $DOTFILES/zshrc.lib/user.zsh

# turn on zsh options
source $DOTFILES/zshrc.lib/setopts.zsh

# autoload zsh functions
source $DOTFILES/zshrc.lib/autoloads.zsh

# load globals
source $DOTFILES/zshrc.lib/globals.zsh

# check and apply updates
source $DOTFILES/zshrc.lib/updater.zsh

# set the version after attempting to update
export DOTFILES_VERSION=`head -n 1 $DOTFILES/VERSION`

# setup the environment variables
source $DOTFILES/zshrc.lib/environment.zsh

# Source any local files for custom environments
if [ -f $HOME/.zshrc_local ] ; then
    source $HOME/.zshrc_local
fi

# source the templater
source $DOTFILES/zshrc.lib/templater.zsh

# source the gitconfig hack
source $DOTFILES/zshrc.lib/gitconfig.zsh

# add custom / vendor completions to fpath (loaded by compinit in zshrc)
fpath+=( "$GLOBALS__DOTFILES_COMPLETIONS_PATH" )
export fpath

# turn on the completion engine
compinit -i -d "$ZSH_COMPDUMP"

# turn on bash completions too
autoload bashcompinit
bashcompinit

# source bash completions
for file in $GLOBALS__DOTFILES_COMPLETIONS_PATH.bash/* ; do
    source $file
done

# source zshrc.d files
for file in $DOTFILES/zshrc.d/* ; do
    source $file
done

# add omz compatible functions to the fpath
for plugin in $DOTFILES/zshrc.plugins/* ; do
    fpath+=( $plugin )
done
export fpath

# source omz compatible plugins
plugin_list=( `/bin/ls -d -1 $DOTFILES/zshrc.plugins/* | xargs -n1 basename | tr '\n' ' '` )
for plugin in $plugin_list ; do
    source $DOTFILES/zshrc.plugins/$plugin/$plugin.plugin.zsh
done

# source zsh syntax highlighting settings
source $DOTFILES/zshrc.lib/syntax-highlighting-settings.zsh

# source the prompt
source $DOTFILES/zshrc.lib/prompt.zsh

# source all exit tasks
source $DOTFILES/zshrc.lib/exit-tasks.zsh
