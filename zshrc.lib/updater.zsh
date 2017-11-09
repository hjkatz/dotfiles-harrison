# Controls the updating for the dotfiles

# tests if the current shell has internet connectivity
function has_internet ()
{
    local test_site='http://google.com'

    if ping -q -w 1 -c 1 "$test_site" >/dev/null 2>&1 ; then
        return 1
    else
        return 0
    fi

    # unreachable
}

# update if needed
function update_dotfiles ()
{
    # don't update if check for updates is false
    [ $GLOBALS__CHECK_FOR_UPDATES = false ] && return 0

    # don't update if we've checked recently
    local last_updated_path="$DOTFILES/.last_updated_at"
    last_updated_at=`head -n 1 $last_updated_path 2>/dev/null`
    : ${last_updated_at:="0"} # default to the beginning of time
    [[ $(( `date +%s` - $last_updated_at )) -lt $UPDATE_CHECK_INTERVAL_SECONDS ]] && return 0

    # don't update if there's no internet
    has_internet || return 0

    # turns off auto-fetch for git on cd
    local GLOBALS__SHOULD_RUN_CHPWD=false

    # save the current directory
    local cwd=`pwd`

    # go to the dotfiles
    cd $DOTFILES

    git rev-parse >/dev/null 2>&1
    if [[ $? -eq 0 ]] ; then
        # record the old hash
        OLD_HASH=`git rev-parse --verify HEAD`

        # update
        git pull origin master >/dev/null 2>&1

        # record the new hash
        NEW_HASH=`git rev-parse --verify HEAD`

        # check to see if we actually updated or not
        if [ ! "$OLD_HASH" = "$NEW_HASH" ] ; then
            export GLOBALS__DOTFILES_UPDATED=true
        fi
    fi

    # record the time that we checked
    echo `date +%s` > $last_updated_path

    # return to the previous cwd
    cd $cwd
}

# check to update
update_dotfiles
