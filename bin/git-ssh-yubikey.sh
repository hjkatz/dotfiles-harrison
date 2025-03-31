#!/bin/bash

# Returns the first ssh key found from the ssh agent
#
# See: https://calebhearth.com/sign-git-with-ssh

# Must be returned in the format `key::<key>`

key=""

from_agent=`ssh-add -L | head -n1`
if [[ $? == 0 ]] && [[ -n $from_agent ]] ; then
    key="$from_agent"
else
    # no key found in agent
    return 1
fi

echo "key::$key"
