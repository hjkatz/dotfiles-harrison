#!/bin/bash

# Returns the first ssh key found from the ssh agent
#
# See: https://calebhearth.com/sign-git-with-ssh

# Must be returned in the format `key::<key>`

# Echos out with color (minimal version for this script)
# Output goes to stderr so it doesn't interfere with the key output
color_echo() {
    case $1 in
     red)    color="1;31" ;;
     green)  color="1;32" ;;
     blue)   color="1;34" ;;
     *)      color=$1 ;;
    esac
    shift
    echo -e "\033[${color}m$@\033[0m" >&2
}

key=""

color_echo blue "🔑 Looking up SSH key from agent..." >&2

# Get the first SSH key from the agent
from_agent=`ssh-add -L | head -n1`
if [[ $? == 0 ]] && [[ -n $from_agent ]] ; then
    key="$from_agent"
    color_echo green "✅ Found SSH key in agent" >&2
else
    # No key found in agent
    color_echo red "❌ No SSH key found in agent" >&2
    return 1
fi

# Output the key in the required format for git signing
echo "key::$key"
