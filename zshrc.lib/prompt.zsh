# setup the prompt

# Returns a colored user name for the prompt
function _uname () {
    # these names are white
    my_names=( harrison hkatz hjkatz hjkatz03 )
    for name in $my_names ; do
        [[ $USER == $name ]] && echo "%{$fg_bold[white]%}%n%{$reset_color%}" && return 0
    done

    # these names are not shortened and are red
    my_alert_names=( root )
    for name in $my_alert_names ; do
        [[ $USER == $name ]] && echo "%{$fg_bold[red]%}%n%{$reset_color%}" && return 0
    done

    # all other names are not shortened and are yellow
    echo "%{$fg_bold[yellow]%}%n%{$reset_color%}"
}

# Returns a colored hostname name for the prompt
function _hname () {
    local hostname=`hostname`

    # we're on a dotfiles source machine with repo enabled
    if [[ $GLOBALS__DOTFILES_IS_GIT_LOCAL == true ]] ; then
        echo "%{$FG[013]%}@%M%{$reset_color%}" && return 0
    fi

    # check for caution server
    for server in $GLOBALS__CAUTION_SERVERS ; do
        if [[ $hostname =~ $server ]] ; then
            # we are on a caution server
            echo "%{$fg_bold[red]%}@%M%{$reset_color%}" && return 0
        fi
    done

    # else we're on a regular server
    echo "%{$reset_color%}%{$fg[white]%}@%M%{$reset_color%}"
}

# Sets the visibility of the prompt to true.
#
# called: `show_prompt <prompt>`
function show_prompt () {
    prompt_name="$1"

    if [[ -z $1 ]] ; then
        color_echo red "Missing prompt!"
        return 1
    fi

    # test if key exists in array using arithmetic and name expansion
    # [see: http://zshwiki.org/home/scripting/array]
    (( ${+GLOBALS__SHOW_PROMPT_HASH[$prompt_name]} )) || {
        color_echo red "No prompt '$prompt_name' found!"
        return 1
    }

    # turn the prompt "on"
    GLOBALS__SHOW_PROMPT_HASH[$prompt_name]=true
}

# Sets the visibility of the prompt to false.
#
# called: `hide_prompt <prompt>`
function hide_prompt () {
    prompt_name="$1"

    if [[ -z $1 ]] ; then
        color_echo red "Missing prompt!"
        return 1
    fi

    # test if key exists in array using arithmetic and name expansion
    # [see: http://zshwiki.org/home/scripting/array]
    (( ${+GLOBALS__SHOW_PROMPT_HASH[$prompt_name]} )) || {
        color_echo red "No prompt '$prompt_name' found!"
        return 1
    }

    # turn the prompt "off"
    GLOBALS__SHOW_PROMPT_HASH[$prompt_name]=false
}

# ensure that the first value of ret_status is a success
echo "" >/dev/null 2>&1

# previous command return status
local ret_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"

# zsh theme settings for prompt sections
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[blue]%}) %{$fg_bold[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%})"

ZSH_THEME_HG_PROMPT_PREFIX="%{$fg_bold[red]%}hg:[%{$fg_bold[blue]%}"
ZSH_THEME_HG_PROMPT_SUFFIX="%{$fg_bold[red]%}]%{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY=" %{$fg_bold[yellow]%}✗%{$reset_color%}"
ZSH_THEME_HG_PROMPT_CLEAN=" %{$fg_bold[green]%}✓%{$reset_color%}"

ZSH_THEME_VIRTUALENV_PREFIX="%{$fg_bold[green]%}[%{$FX[no-bold]%}"
ZSH_THEME_VIRTUALENV_SUFFIX="%{$fg[green]%}%{$FX[bold]%}]%{$reset_color%} "

ZSH_THEME_KUBECTL_PREFIX="%{$fg_bold[cyan]%}{%{$FX[no-bold]%}%{$fg[white]%}"
ZSH_THEME_KUBECTL_SUFFIX="%{$fg_bold[cyan]%}}%{$reset_color%} "

GIT_PS1_SHOWUPSTREAM="git legacy"
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_STATESEPARATOR=""

# display the content from a prompt command, or nothing
function display_prompt () {
    prompt_command="$1"

    if command_exists "$prompt_command" ; then
        $prompt_command
        return
    else
        echo ""
        return
    fi

    # unreachable
}

# add something to the prompt
function build_prompt () {
    PROMPT+="$@"
}

# jen prompt
PROMPT="" # reset prompt before building
build_prompt $'\n' # start with a newline
build_prompt '${ret_status} ' # show the return code status from the last command
build_prompt '$(_uname)$(_hname)' # user@host
build_prompt '%{$fg_bold[cyan]%} %$PR_PWDLEN<...<%~%<<%{$reset_color%}${(e)PR_FILLCHAR}[%D{%I:%M:%S}]' # don't ask
build_prompt $'\n' # second line!
build_prompt '%{$fg_bold[yellow]%}%# ' # the prompt separator/privilege indicator
build_prompt '%{$reset_color%}'
build_prompt '$(display_prompt "kubectl_prompt_info")'
build_prompt '$(display_prompt "rbenv_prompt_info")'
build_prompt '$(display_prompt "virtualenv_prompt_info")'
build_prompt '$(display_prompt "git_prompt_info")'
build_prompt '$(display_prompt "hg_prompt_info")'
