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
    [[ -d $DOTFILES/.git ]] && echo "%{$FG[013]%}@%M%{$reset_color%}" && return 0

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

# ensure that the first value of ret_status is a success
echo "" >/dev/null 2>&1

# previous command return status
local ret_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"

# jen prompt
PROMPT=$'${ret_status} $(_uname)$(_hname)%{$fg_bold[cyan]%} %$PR_PWDLEN<...<%~%<<%{$reset_color%}${(e)PR_FILLCHAR}[%D{%I:%M:%S}]\n%{$fg_bold[yellow]%}%# %{$reset_color%}$(rbenv_prompt_info)$(git_prompt_info)'

# zsh theme settings to work with git-prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[blue]%}) %{$fg_bold[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%})"

GIT_PS1_SHOWUPSTREAM="git legacy"
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
