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
function precmd () {
    local TERMWIDTH

    # use one character less because zsh auto puts a
    # space at the end of the terminal for some reason
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    PR_FILLCHAR=""
    PR_PWDLEN=""

    # use the extra spaces at the end for padding and manual adjustment
    local promptsize=${#${(%):-- %n@%M [00:00:00]}}
    local pwdsize=${#${(%):-%~}}

    # determine which size to use
    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
	    ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
        PR_FILLCHAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize))).. .)}"
    fi
}
