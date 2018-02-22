# Globals

# whether the updater should check for updates this run or not (default:true)
: ${GLOBALS__CHECK_FOR_UPDATES:=true}
export GLOBALS__CHECK_FOR_UPDATES

# global identifier to know if the dotfiles have been updated during this source
export GLOBALS__DOTFILES_UPDATED=false

# global control flag for the zsh chpwd function hook
export GLOBALS__SHOULD_RUN_CHPWD=true

# servers to alert when connected
GLOBALS__CAUTION_SERVERS=(
    ".*[.]thdises[.]com"
    ".*[.]neadwerx[.]com"
    ".*prod[.]squarespace[.]net"
    ".*corp[.]squarespace[.]net"
)

# export on separate line to prevent "unknown file attribute" error in older versions of Zsh
export GLOBALS__CAUTION_SERVERS

# servers to overwrite ~/.gitconfig with $DOTFILES/gitconfig
GLOBALS__GITCONFIG_SERVERS=(
    "harrison.internal"
)

# export on separate line to prevent "unknown file attribute" error in older versions of Zsh
export GLOBALS__GITCONFIG_SERVERS

# know whether this set of dotfiles is git controlled or not
if [[ -d "$DOTFILES/.git" ]] ; then
    export GLOBALS__DOTFILES_IS_GIT_LOCAL=true
else
    export GLOBALS__DOTFILES_IS_GIT_LOCAL=false
fi

# templates configuration
export GLOBALS__DOTFILES_TEMPLATES_PATH="$DOTFILES/templates"
export GLOBALS__DOTFILES_COMPILED_PATH="$DOTFILES/compiled"

# custom / vendor completions path
export GLOBALS__DOTFILES_COMPLETIONS_PATH="$DOTFILES/completions"

# exit task hook function name for zshrc_local
export GLOBALS__DOTFILES_EXIT_HOOK_FUNCTION="_local_exit_function"

# where should we store our debug information
# export GLOBALS__DEBUGGING_PATH="/tmp/.dotfiles-harrison-debugging"
# Note: This is *actually* defined in zshrc.lib/debugging.zsh

# figure out which distro is currently loaded
#
# Called: `which_distro`
function which_distro ()
{
    if [[ $OSTYPE == darwin* ]] ; then
        # on mac
        echo "darwin" && return 0
    fi

    # otherwise, continue doing it this way
    release_info=`cat /etc/*-release`

    echo "$release_info" | grep -i -q 'ubuntu' && {
        echo "ubuntu" && return 0
    }

    echo "$release_info" | grep -i -q 'debian' && {
        echo "debian" && return 0
    }

    echo "$release_info" | grep -i -q 'centos' && {
        echo "centos" && return 0
    }

    echo "$release_info" | grep -i -q 'redhat' && {
        echo "redhat" && return 0
    }

    echo "$release_info" | grep -i -q 'red hat' && {
        echo "redhat" && return 0
    }

    echo "$release_info" | grep -i -q 'rhel' && {
        echo "rhel" && return 0
    }

    echo "$release_info" | grep -i -q 'fedora' && {
        echo "fedora" && return 0
    }

    echo ""
}

# which distro the dotfiles thinks is running
export GLOBALS__DISTRO=`which_distro`
