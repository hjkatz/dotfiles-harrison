# Controls the updating for the dotfiles

# update if needed
function update_dotfiles ()
{
    [ $GLOBALS__CHECK_FOR_UPDATES = false ] && return 0

    local GLOBALS__SHOULD_RUN_CHPWD=false

    cd $DOTFILES

    git rev-parse 2> /dev/null
    if [[ $? -eq 0 ]] ; then
        OLD_HASH=$(cd $DOTFILES && git rev-parse --verify HEAD)
        git pull > /dev/null 2>&1
        NEW_HASH=$(cd $DOTFILES && git rev-parse --verify HEAD)
        if [ ! "$OLD_HASH" = "$NEW_HASH" ] ; then
            export GLOBALS__DOTFILES_UPDATED=true
        fi
    fi
    cd $HOME
}

# check to update
update_dotfiles

# symlink the required files in place
if [ $GLOBALS__DOTFILES_UPDATED = true ] ; then
    for dotfile in $GLOBALS__REQUIRED_SYMLINKS ; do
        [[ ! -h $DOTFILES/.$dotfile ]] && ln -s $DOTFILES/$dotfile $DOTFILES/.$dotfile
    done
fi
