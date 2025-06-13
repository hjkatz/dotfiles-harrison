# Zsh function hooks

# Called when changing pwd. Does the following:
#   - checks the global GLOBALS__SHOULD_RUN_CHPWD, if false exits
#   - calls alias `cl` which clears and lists the files in pwd
#   - checks to update the git repo if in one
function chpwd () {
    [ $GLOBALS__SHOULD_RUN_CHPWD = false ] && return

    cl

    check_and_update_git_repo
}

# override cd to support bare `cd` with no args behaviour:
#   - if in git, cd to git root
#     - if already in git and git root, cd $HOME
#   - else, cd $HOME
#   - else (has args), cd ARGS
function cd () {
    if [[ $# == 0 ]] ; then
        local gitroot
        gitroot=`git rev-parse --show-toplevel 2>&1`
        if [[ $? == 0 ]] ; then
            if [[ `pwd` != "$gitroot" ]] ; then
                builtin cd "$gitroot"
            else
                builtin cd "$HOME"
            fi
        else
            builtin cd "$HOME"
        fi
    else
        builtin cd "$@"
    fi
}

# period is 900 seconds == 15 mins
export PERIOD=900

# Called on postcmd ever PERIOD seconds. Does the following:
#   - checks to update the git repo if in one
function periodic () {
    check_and_update_git_repo
}

# Called just before running a command. Does the following:
#   - determines the current terminal width (columns - 1)
#   - truncates the current path into something that fits
#   - determines the correct lengths for PWDLEN and FILLBAR
#
# Literally magic (see:http://aperiodic.net/phil/prompt/)
# Optimized to avoid expensive operations on every prompt
function precmd () {
    # Skip expensive calculations if terminal size hasn't changed
    local TERMWIDTH=$(( ${COLUMNS} - 1 ))
    if [[ "$TERMWIDTH" == "$_LAST_TERMWIDTH" && -n "$PR_FILLCHAR" ]]; then
        return 0
    fi
    _LAST_TERMWIDTH=$TERMWIDTH

    PR_FILLCHAR=""
    PR_PWDLEN=""

    # Cache prompt size (doesn't change often)
    if [[ -z "$_CACHED_PROMPTSIZE" ]]; then
        _CACHED_PROMPTSIZE=${#${(%):-- %n@%M [00:00:00]}}
    fi
    
    # Only calculate pwd size (this changes with directory)
    local pwdsize=${#${(%):-%~}}

    # determine which size to use
    if [[ $(( _CACHED_PROMPTSIZE + pwdsize )) -gt $TERMWIDTH ]]; then
        ((PR_PWDLEN=$TERMWIDTH - _CACHED_PROMPTSIZE))
    else
        PR_FILLCHAR="\${(l.(($TERMWIDTH - ($_CACHED_PROMPTSIZE + $pwdsize))).. .)}"
    fi
}
