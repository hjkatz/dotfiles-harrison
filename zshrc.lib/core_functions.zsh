# Some helper core functions that are used to load this zshrc

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
    local test_site='google.com'

    if ping -q -c 1 "$test_site" &>/dev/null ; then
        return 0
    else
        return 1
    fi

    # unreachable
}

# tests if a given command is available
function command_exists () {
    command="$1"

    if type "$command" &>/dev/null ; then
        return 0
    else
        return 1
    fi

    # unreachable
}
