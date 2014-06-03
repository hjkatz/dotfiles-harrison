# Path to your oh-my-zsh configuration.
DOTFILES=$HOME/.dotfiles-harrison/
ZSH=$DOTFILES/oh-my-zsh/

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# DEFAULT: robbyrussell
ZSH_THEME="katz"

DEFAULT_USER="harrison"

COMPLETION_WAITING_DOTS="true"

# Source my files
source $DOTFILES/zsh-colors

# Plugins need to be setup before sourcing oh-my-zsh
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git-fast git-extras sudo web-search command-not-found zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Source my aliases last to overwrite any created by oh-my-zsh
source $DOTFILES/zsh-aliases

# Customize to your needs...
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/pgsql-9.1/bin/:/home/harrison/Apps/idea/bin/:/home/harrison/Apps/android-sdk-linux/tools/:/home/harrison/Apps/android-sdk-linux/platform-tools/:/home/harrison/Apps/android-studio/bin/
export EDITOR=/usr/bin/vim

# sets completion to be arrow driven
zstyle ':completion:*' menu select

setopt AUTO_CD
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt RM_STAR_WAIT
setopt EXTENDED_GLOB
setopt DVORAK

function chpwd ()
{
    cl
}

function ack () {
    if [ -e ~/bin/ack ] ; then
        ~/bin/ack "$@"
    elif [ -e /usr/bin/ack ] ; then
        /usr/bin/ack "$@"
    else
        \grep -lR "$@" | \grep -v "/\.svn/"
    fi
}

function vack () {
    files="$(ack -l "$@")"
    if [ -z "$files" ] ; then
        echo "No matches found."
    else
        vim $files
    fi
}
