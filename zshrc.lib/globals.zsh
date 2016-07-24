# Globals

# whether the updater should check for updates this run or not (default:true)
: ${GLOBALS__CHECK_FOR_UPDATES:=true}
export GLOBALS__CHECK_FOR_UPDATES

# global identifier to know if the dotfiles have been updated during this source
export GLOBALS__DOTFILES_UPDATED=false

# global control flag for the zsh chpwd function hook
export GLOBALS__SHOULD_RUN_CHPWD=true

# servers to alert when connected
GLOBALS__CAUTON_SERVERS=(
    ".*[.]thdises[.]com"
    ".*[.]neadwerx[.]com"
)

# export on separate line to prevent "unknown file attribute" error in older versions of Zsh
export GLOBALS__CAUTON_SERVERS

# figure out which distro is currently loaded
#
# Called: `which_distro`
function which_distro ()
{
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

export GLOBALS__DISTRO=`which_distro`
