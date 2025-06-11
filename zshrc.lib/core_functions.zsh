# Some helper core functions that are used to load this zshrc
# library of useful helper functions

# delay the execution of a command using a background subshell
function delay () {
    seconds="$1"
    shift

    # command is in "$@"
    (sleep "$seconds" && "$@") &
}

# adds dir to $PATH if it does not already contain it
function add_to_path () {
    dir="$1"
    front="$2"

    if ! [[ ":$PATH:" == *":$dir:"* ]] ; then
        if [[ "$front" == true ]] ; then
            PATH="$dir:$PATH"
        else
            path+=( "$dir" )
        fi
    fi
}

# tests if the current shell has internet connectivity
function has_internet () {
    local test_sites=('8.8.8.8' 'google.com' '1.1.1.1')
    local timeout=2

    # try multiple test sites to increase reliability
    for site in "${test_sites[@]}"; do
        # try ping with both -w and -t flags for cross-platform compatibility
        if ping -q -w $timeout -c 1 "$site" &>/dev/null || \
           ping -q -t $timeout -c 1 "$site" &>/dev/null; then
            return 0
        fi
    done

    # as a fallback, try a simple HTTP request (faster than ping on some networks)
    if command_exists curl; then
        curl -s --max-time $timeout --head http://google.com &>/dev/null && return 0
    elif command_exists wget; then
        wget -q --timeout=$timeout --spider http://google.com &>/dev/null && return 0
    fi

    return 1
}

# tests if a given command is available
function command_exists () {
    command="$1"

    if type "$command" &>/dev/null ; then
        return 0
    else
        return 1
    fi
}

# echos out with color
#
# Called:
#   `color_echo red "My Error"`
#   `color_echo yellow "My Warning"`
#   `color_echo green "My Success"`
function color_echo() {
    if [[ "$1" == "-n" ]] ; then
        n_flag="-n"
        shift
    fi

    is_stderr=false
    case $1 in
     red)
          color="1;31"
          # when the color is "red", redirect to stderr
          is_stderr=true
          ;;
     green)
          color="1;32"
          ;;
     yellow)
          color="1;33"
          ;;
     blue)
         color="1;34"
         ;;
     purple)
         color="1;35"
         ;;
     cyan)
         color="1;36"
         ;;
     white)
         color="0"
         ;;
     *)
          color=$1
          ;;
    esac

    # remove $1
    shift

    if [[ $is_stderr == true ]]; then
        # stderr
        echo -e $n_flag "\033[${color}m$@\033[0m" >&2
    else
        # stdout
        echo -e $n_flag "\033[${color}m$@\033[0m"
    fi
}

# begin reading from the keyboard
function turn_on_keyboard () {
    # save stdin to fd 6
    exec 6<&1

    # set stdin to /dev/tty
    exec </dev/tty

    # because we're about to read something...I guess
    flush_stdin
}

# stop reading from the keyboard
function turn_off_keyboard () {
    # restore stdin from fd 6 and close fd 6
    exec 1<&6 6>&-
}

# asks the user for input in the form of a question
# the result is stored in the variable $ANSWER
function q () {
    question="$1"

    # manually run color echo without a newline
    echo -e -n "\033[1;33m$question \033[0m"

    turn_on_keyboard
    read ANSWER
    turn_off_keyboard

    # add the missing newline
    echo ""

    return 0
}

# [see: https://superuser.com/questions/276531/clear-stdin-before-reading]
function flush_stdin() {
    while read -e -t 0.1 ; do : ; done
}


# asks the user for input in the form of a [y/n] question
# the result is stored in the variable $ANSWER
function ask () {
    question="$1"

    # manually run color echo without a newline
    echo -e -n "\033[1;33m$question [y/n]: \033[0m"

    turn_on_keyboard
    read -k 1 ANSWER
    turn_off_keyboard

    # add the missing newline
    echo ""

    # loop until the user responds with a y or n
    while [[ $ANSWER != y ]] && [[ $ANSWER != n ]] ; do
        # manually run color echo without a newline
        echo -e -n "\033[1;33m[y/n]: \033[0m"

        turn_on_keyboard
        read -k 1 ANSWER
        turn_off_keyboard

        # add the missing newline
        echo ""
    done

    if [[ $ANSWER == y ]] ; then
        return 0
    else
        return 1
    fi

}

# asks the user for input in the form of a [y/n] question
# the result is stored in the variable $ANSWER
function ask_with_timeout () {
    timeout="$1"
    default="$2"
    question="$3"

    # manually run color echo without a newline
    color_echo yellow "$question [y/n]"
    echo -e -n "\033[1;33mAssuming \"$default\" in $timeout secs: \033[0m"

    turn_on_keyboard
    read -t $timeout -k 1 ANSWER
    read_exit_code="$?"
    turn_off_keyboard

    # add the missing newline
    echo ""

    if [[ $read_exit_code != 0 ]] ; then
        # timeout occurred
        ANSWER="$default"
    else
        # loop until the user responds with a y or n
        while [[ $ANSWER != y ]] && [[ $ANSWER != n ]] ; do
            # manually run color echo without a newline
            echo -e -n "\033[1;33m[y/n]: \033[0m"

            turn_on_keyboard
            read -k 1 ANSWER
            turn_off_keyboard

            # add the missing newline
            echo ""
        done
    fi

    if [[ $ANSWER == y ]] ; then
        return 0
    else
        return 1
    fi

}

# Matches an element against an array of bash regexes
# return status is 0 if it matched, 1 if not, e.g.
#   declare -a my_array=(
#       'v[0-9].[0-9]+HF'
#   )
#
#   matches_regex_element "$element" "${my_array[@]}"
#   if [[ $? == 0 ]] ; then
#       echo "Element matched"
#   fi
matches_regex_element () {
    for element in "${@:2}" ; do
        if [[ "$1" =~ $element ]] ; then
            return 0
        fi
    done

    return 1
}

# Matches an element against an array of bash globs
# return status is 0 if it matched, 1 if not, e.g.
#   declare -a my_array=(
#       '*test/*'
#       '*common/barcode/*'
#       '*common/dompdf/*'
#       '*common/simplesaml/*'
#   )
#
#   matches_glob_element "$element" "${my_array[@]}"
#   if [[ $? == 0 ]] ; then
#       echo "Element matched"
#   fi
matches_glob_element () {
    for element in "${@:2}" ; do
        if [[ $1 == $element ]] ; then
            return 0
        fi
    done

    return 1
}

# prints a list of files, each with the given prefix
# the files should be from the form:
#   files=`ag ...`
#   files=`ls ...`
#   files=`find ...`
print_files () {
    prefix="$1"
    shift
    files="$@"

    for file in $files ; do
        echo -e $prefix $file
    done
}

# prints a list of lines, each with the given prefix
print_lines () {
    prefix="$1"
    shift

    while read -r line ; do
        echo -e $prefix $line
    done <<< "$@"
}

# echo the command and run
echo_run () {
    echo "> $1"
    eval $1
}

# Start a dedicated ssh-agent for name
#
# Usage:
#   $ start_ssh_agent <name>
#
#   # start and set the agent as the primary agent (exported envars)
#   $ start_ssh_agent <name> true
function start_ssh_agent () {
    agent_name="$1"
    primary_agent="${2:-false}"

    [[ -z $agent_name ]] && {
        color_echo red "Missing required agent_name"
        return 1
    }

    ssh_auth_sock="$HOME/.ssh/$agent_name.agent"
    ssh_agent_pid_path="$HOME/.ssh/$agent_name.pid"

    # is ssh-agent already running?
    ssh_agent_pid=`ps aux | grep "ssh-agent -a $ssh_auth_sock" | grep -v grep | awk '{print $2}'`
    if [[ -z $ssh_agent_pid ]] ; then
        color_echo yellow "Starting ssh-agent: $agent_name"

        # ssh-agent not running, start it
        ssh-agent -a "$ssh_auth_sock" 2>&1 >/dev/null

        # grab the now running pid
        ssh_agent_pid=`ps aux | grep "ssh-agent -a $ssh_auth_sock" | grep -v grep | awk '{print $2}'`
    else
        color_echo green "Connected to ssh-agent: $agent_name"
    fi

    # put the pid into the file
    echo "$ssh_agent_pid" > $ssh_agent_pid_path

    if [[ "$primary_agent" == true ]] ; then
        export SSH_AUTH_SOCK="$ssh_auth_sock"
        export SSH_AGENT_PID="$ssh_agent_pid"
    fi
}

# Add an ssh-keygen identity to an agent
#
# Usage:
#   $ add_ssh_id_to_agent <path/to/id> <name>
function add_ssh_id_to_agent () {
    id_path="$1"
    agent_name="$2"

    [[ -z $id_path ]] && {
        color_echo red "Missing required id_path"
        return 1
    }

    [[ -z $agent_name ]] && {
        color_echo red "Missing required agent_name"
        return 1
    }

    ssh_auth_sock="$HOME/.ssh/$agent_name.agent"
    ssh_agent_pid_path="$HOME/.ssh/$agent_name.pid"
    ssh_agent_pid="$(cat $ssh_agent_pid_path)"
    key_name=$(basename $id_path)

    # add ssh adentities to the agent if they are not already added
    if SSH_AUTH_SOCK=$ssh_auth_sock SSH_AGENT_PID=$ssh_agent_pid ssh-add -l | grep "The agent has no identities." ; then
        # Personal
        color_echo yellow "Adding key $key_name to $agent_name ssh-agent"
        SSH_AUTH_SOCK=$ssh_auth_sock SSH_AGENT_PID=$ssh_agent_pid ssh-add "$id_path"
    else
        color_echo green "Found existing key $key_name attached to $agent_name ssh-agent"
    fi
}

# List all identities loaded into a specific agent
#
# Usage:
#   $ list_ssh_ids_for_agent <name>
function list_ssh_ids_for_agent () {
    agent_name="$1"

    [[ -z $agent_name ]] && {
        color_echo red "Missing required agent_name"
        return 1
    }

    ssh_auth_sock="$HOME/.ssh/$agent_name.agent"
    ssh_agent_pid_path="$HOME/.ssh/$agent_name.pid"
    ssh_agent_pid="$(cat $ssh_agent_pid_path)"

    SSH_AUTH_SOCK=$ssh_auth_sock SSH_AGENT_PID=$ssh_agent_pid ssh-add -l
}
