# debugging

# where should we store our debug information
# Note: This is exported here instead of zshrc.lib/globals.zsh because of the ordering of source files in zshrc
export GLOBALS__DEBUGGING_PATH="/tmp/.dotfiles-harrison-debugging"

if [[ "$ENABLE_DEBUGGING" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$GLOBALS__DEBUGGING_PATH
    setopt xtrace prompt_subst
fi

# turn off the debugging in exit-tasks.zsh

function zsh_debug () {
    if [[ "$ENABLE_DEBUGGING" != true ]] ; then
        color_echo red "Debugging was not enabled for this session!"
        return 1
    fi

    if [[ ! -f "$GLOBALS__DEBUGGING_PATH" ]] ; then
        color_echo red "Debugging information was not saved to the debugging path '$GLOBALS__DEBUGGING_PATH'!"
        return 1
    fi

    # set the default timing threshold to 9 milliseconds
    timing_threshold="$1"
    : ${timing_threshold:="10"}

    # get the starting time
    debugging_start_time=`head -n 1 $GLOBALS__DEBUGGING_PATH | awk '{print $1}'`

    # print out the first line for consistency
    first_line=`head -n 1 $GLOBALS__DEBUGGING_PATH`
    first_section=`echo $first_line | awk '{print $2}' | cut -f1 -d:`
    color_echo green "$first_line"

    # for recording the timing
    previous_section_start_time="$debugging_start_time"
    previous_section="$first_section"
    previous_line="$first_line"

    # read each line
    while read line ; do
        current_section=`echo $line | awk '{print $2}' | cut -f1 -d:`

        # skip any line that doesn't match our debugging pattern
        if ! echo "$line" | grep -q -P '^\d+\s.*:\d+\>' ; then
            continue
        fi

        # skip sections that are the same
        if [[ $current_section == $previous_section ]] ; then
            previous_line="$line"
            continue
        fi

        # find the timing of the previous section to now
        current_section_start_time=`echo $line | awk '{print $1}'`
        timing=$(( $current_section_start_time - $previous_section_start_time ))

        if [[ $timing -gt $timing_threshold ]] ; then
            # print timing
            color_echo yellow "...$timing"

            # trim the lines to print
            trim_previous_line=`echo $previous_line | cut -c1-120`
            trim_line=`echo $line | cut -c1-120`
            color_echo red "$trim_previous_line"
            color_echo green "$trim_line"
        fi

        # update the previous vars
        previous_section_start_time="$current_section_start_time"
        previous_section="$current_section"
        previous_line="$line"
    done < $GLOBALS__DEBUGGING_PATH

    # print the total time
    debugging_end_time=`echo $previous_line | awk '{print $1}'`
    total_time=$(( $debugging_end_time - $debugging_start_time ))
    color_echo yellow "Total Time: $total_time"
}
