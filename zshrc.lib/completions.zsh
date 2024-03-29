# Setup Zsh Completions

# TODO: learn and document this...

zmodload -i zsh/complist

# from omz

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Disable completion of usernames
zstyle ':completion:*' users

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# completion waiting dots
expand-or-complete-with-dots() {
    # toggle line-wrapping off and back on again
    [[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti rmam
    print -Pn "%{%F{red}......%f%}"
    [[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti smam

    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# end omz

zstyle ':completion:*' use-perl on
zstyle ':completion:*' menu select

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' keep-prefix true tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "%{$color[green]%}##%d%{$reset_color%}"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-separator '#'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:prefix:*' add-space true

# Make the nice with git completion and others
zstyle ':completion::*:(git|less|rm|emacs)' ignore-line true

# add .ssh/config hosts to completion
[[ -r ~/.ssh/config ]] && _ssh_config+=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p'))
[[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()

hosts=(
  "$_ssh_config[@]"
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  "$HOST"
  localhost
)

zstyle ':completion:*:hosts' hosts $hosts

# SSH Completion
zstyle ':completion:*:scp:*' tag-order files 'hosts:-domain:domain'
zstyle ':completion:*:scp:*' group-order files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:scp:*' users off
zstyle ':completion:*:ssh:*' tag-order 'hosts:-domain:domain'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' users off

### highlight parameters with uncommon names
zstyle ':completion:*:parameters' list-colors "=[^a-zA-Z]*=$color[red]"

### highlight aliases
zstyle ':completion:*:aliases' list-colors "=*=$color[green]"

### highlight the original input.
zstyle ':completion:*:original' list-colors "=*=$color[red];$color[bold]"

### highlight words like 'esac' or 'end'
zstyle ':completion:*:reserved-words' list-colors "=*=$color[red]"

### colorize hostname completion
# zstyle ':completion:*:*:*:*:hosts' list-colors "=*=$color[cyan];$color[bg-black]"

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*' verbose yes
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#) #([^ ]#)*=$color[cyan]=$color[yellow]=$color[green]"

## With commands like `rm' it's annoying if one gets offered the same filename
## again even if it is already on the command line. To avoid that:
zstyle ':completion:*:rm:*' ignore-line yes

## Manpages, ho!
zstyle ':completion:*:manuals'       separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections   true

# Cache
zstyle ':completion:*' use-cache off

# fuzzy matching of completions for when you mistype them
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# ignore completion functions for commands you don't have
zstyle ':completion:*:functions' ignored-patterns '_*'

# set completion definitions
compdef ssh-remote-zsh=ssh

# aws cli completion
function _get_aws_zsh_completer_sh_path () {
    # try and find the executable in the PATH
    if which aws_zsh_completer.sh &>/dev/null ; then
        echo $(which aws_zsh_completer.sh)
    # sometimes it's here?
    elif [[ -f "/usr/share/zsh/site-functions/aws_zsh_completer.sh" ]] ; then
        echo "/usr/share/zsh/site-functions/aws_zsh_completer.sh"
    # sometimes it's here on M1 Macs
    elif [[ -f "/opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh" ]] ; then
        echo "/opt/homebrew/share/zsh/site-functions/aws_zsh_completer.sh"
    else
        # try to locate it in the system (note: very slow)
        _aws_completion_path=`locate aws_zsh_completer.sh 2>/dev/null | head -1`

        if [[ -n $_aws_completion_path ]] ; then
            echo $_aws_completion_path
        fi
    fi
}

# try to source the aws zsh completion, if it exists
_aws_completion_path=`_get_aws_zsh_completer_sh_path`
if [[ -n $_aws_completion_path ]] ; then
    source $_aws_completion_path
    unset _aws_completion_path
# try the new aws_completer binary
# see: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
elif which aws_completer &>/dev/null ; then
    complete -C $(which aws_completer) aws
fi
