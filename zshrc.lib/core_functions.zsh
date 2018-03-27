# Some helper core functions that are used to load this zshrc

# adds dir to $PATH if it does not already contain it
function add_to_path () {
    dir="$1"

    if ! [[ ":$PATH:" == *":$dir:"* ]] ; then
        path+=( "$dir" )
    fi
}

# tests if the current shell has internet connectivity
function has_internet () {
    local test_site='google.com'

    if ping -q -c 1 "$test_site" >/dev/null 2>&1 ; then
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
