# Zsh function hooks

# Called when changing pwd. Does the following:
#   - checks the global GLOBALS__SHOULD_RUN_CHPWD, if false exits
#   - calls alias `cl` which clears and lists the files in pwd
#   - checks to update the git repo if in one
function chpwd ()
{
    [ $GLOBALS__SHOULD_RUN_CHPWD = false ] && return

    cl

    check_and_update_git_repo
}

# period is 900 seconds == 15 mins
export PERIOD=900

# Called on postcmd ever PERIOD seconds. Does the following:
#   - checks to update the git repo if in one
function periodic ()
{
    check_and_update_git_repo
}
