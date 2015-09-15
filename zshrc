# Path to your oh-my-zsh configuration.
DOTFILES=$HOME/.dotfiles-harrison
ZSH=$DOTFILES/oh-my-zsh

# update if needed
UPDATED=false
function update_dotfiles ()
{
    cd $DOTFILES

    git rev-parse 2> /dev/null
    if [[ $? -eq 0 ]] ; then
        OLD_HASH=$(cd $DOTFILES && git rev-parse --verify HEAD)
        git pull > /dev/null 2>&1
        NEW_HASH=$(cd $DOTFILES && git rev-parse --verify HEAD)
        if [ ! "$OLD_HASH" = "$NEW_HASH" ] ; then
            UPDATED=true
        fi
    fi

    cd $HOME
}
update_dotfiles

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# DEFAULT: robbyrussell
ZSH_THEME="katz"

DEFAULT_USER="harrison"

COMPLETION_WAITING_DOTS="true"

function which_distro ()
{
    release_info=`cat /etc/*-release`

    echo "$release_info" | grep -i -q 'ubuntu' && {
        echo "ubuntu"
        exit 0
    }

    echo "$release_info" | grep -i -q 'debian' && {
        echo "debian"
        exit 0
    }

    echo "$release_info" | grep -i -q 'centos' && {
        echo "centos"
        exit 0
    }

    echo "$release_info" | grep -i -q 'redhat' && {
        echo "redhat"
        exit 0
    }

    echo "$release_info" | grep -i -q 'red hat' && {
        echo "redhat"
        exit 0
    }

    echo "$release_info" | grep -i -q 'rhel' && {
        echo "rhel"
        exit 0
    }

    echo "$release_info" | grep -i -q 'fedora' && {
        echo "fedora"
        exit 0
    }

    echo ""
}

DISTRO=$(which_distro)

# Source my files
source $DOTFILES/*.version
source $DOTFILES/zsh-colors

plugins=(git-extras sudo web-search command-not-found zsh-syntax-highlighting gitfast)
source $ZSH/oh-my-zsh.sh

source $DOTFILES/zsh-syntax-highlighting-settings

# Source my aliases last to overwrite any created by oh-my-zsh
source $DOTFILES/zsh-aliases
source $DOTFILES/zsh-functions

# Source any local files for custom environments
if [ -f $HOME/.zshlocal ] ; then
    source $HOME/.zshlocal
fi

# Echo updated message after sourcing files
if [ $UPDATED = true ] ; then
    echo "Updated to $DOTFILES_VERSION"
fi

# Customize to your needs...
export PATH=$PATH:/usr/local/git/bin/:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/pgsql-9.1/bin/:/home/harrison/Apps/idea/bin/:/home/harrison/Apps/android-sdk-linux/tools/:/home/harrison/Apps/android-sdk-linux/platform-tools/:/home/harrison/Apps/android-studio/bin/:/etc/profile.d/scripts/:$DOTFILES
export EDITOR=/usr/bin/vim

setopt AUTO_CD
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt RM_STAR_WAIT
setopt EXTENDED_GLOB
setopt DVORAK

# COMPLETION
zmodload -i zsh/complist
zstyle ':completion:*' use-perl on
zstyle ':completion:*' menu select

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' keep-prefix true tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "%{${color[green]}%}##%d%{${reset_color}%}"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-separator '#'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:prefix:*' add-space true

# Make the nice with git completion and others
zstyle ':completion::*:(git|less|rm|emacs)' ignore-line true

# add .ssh/config hosts to completion
zstyle -s ':completion:*:hosts' hosts _ssh_config
[[ -r ~/.ssh/config ]] && _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p'))
zstyle ':completion:*:hosts' hosts $_ssh_config

# SSH Completion
zstyle ':completion:*:scp:*' tag-order files 'hosts:-domain:domain'
zstyle ':completion:*:scp:*' group-order files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-domain:domain'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr

### highlight parameters with uncommon names
zstyle ':completion:*:parameters' list-colors "=[^a-zA-Z]*=$color[red]"

### highlight aliases
zstyle ':completion:*:aliases' list-colors "=*=$color[green]"

### highlight the original input.
zstyle ':completion:*:original' list-colors "=*=$color[red];$color[bold]"

### highlight words like 'esac' or 'end'
zstyle ':completion:*:reserved-words' list-colors "=*=$color[red]"

### colorize hostname completion
zstyle ':completion:*:*:*:*:hosts' list-colors "=*=$color[cyan];$color[bg-black]"

# Disable completion of usernames
zstyle ':completion:*' users off

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*' verbose yes
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#) #([^ ]#)*=$color[cyan]=$color[yellow]=$color[green]"

## With commands like `rm' it's annoying if one gets offered the same filename
## again even if it is already on the command line. To avoid that:
zstyle ':completion:*:rm:*' ignore-line yes

## Manpages, ho!
zstyle ':completion:*:manuals'       separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections   true

# Cache
zstyle ':completion:*' use-cache off

# fuzzy matching of completions for when you mistype them
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# ignore completion functions for commands you don't have
zstyle ':completion:*:functions' ignored-patterns '_*'

# set completion definitions
compdef ssh-remote-zsh=ssh

# set distro specific completions
case "$DISTRO" in
    ubuntu)
        # fall through
        ;&
    debian)
        compdef '_deb_packages avail' install
        compdef '_deb_packages installed' purge
        ;;
    fedora)
        # fall through
        ;&
    centos)
        # fall through
        ;&
    rhel)
        # fall through
        ;&
    fedora)
        # fall through
        ;&
    redhat)
        compdef '_yum_install' install
        compdef '_yum_erase' purge
        _yum >/dev/null 2>&1
        ;;
    *)
        echo "Distro '$DISTRO' is unrecognized"
        ;;
esac
