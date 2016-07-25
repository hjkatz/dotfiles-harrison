# setup gitconfig

# ok, so git is the one program that does not have a way to specify
# a custom .gitconfig file for any given git command, so here's what
# we're going to do..

# Function for quick replacing ~/.gitconfig with $DOTFILES/gitconfig for certain servers
#
# Called: `setup_git_config`
function setup_git_config () {
    local hostname=`hostname`

    # copy gitconfig on specific hostnames
    for server in $GLOBALS__GITCONFIG_SERVERS ; do
        if [[ $hostname =~ $server ]] ; then
            # replace the gitconfig
            cp -f $DOTFILES/gitconfig ~/.gitconfig >/dev/null 2>&1
        fi
    done

    # copy gitconfig if this host contains a .git copy of the dotfiles
    if [[ -d $DOTFILES/.git ]] ; then
        cp -f $DOTFILES/gitconfig ~/.gitconfig >/dev/null 2>&1
    fi
}

# call the function
setup_git_config
