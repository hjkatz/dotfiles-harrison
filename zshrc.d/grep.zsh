# Better grep

# is a certain grep argument available?
grep_flag_available() {
    echo | grep $1 "" >/dev/null 2>&1
}

# list of grep options to add by default
GREP_OPTIONS=""

# color grep results
if grep_flag_available --color=auto ; then
    GREP_OPTIONS+=" --color=auto"
fi

# ignore VCS folders
VCS_FOLDERS="{.bzr,CVS,.git,.hg,.svn}"

if grep_flag_available --exclude-dir=.cvs ; then
    GREP_OPTIONS+=" --exclude-dir=$VCS_FOLDERS"
elif grep_flag_available --exclude=.cvs ; then
    GREP_OPTIONS+=" --exclude=$VCS_FOLDERS"
fi

# export grep settings
alias grep="grep $GREP_OPTIONS"

# clean up
unset GREP_OPTIONS
unset VCS_FOLDERS
unfunction grep_flag_available
