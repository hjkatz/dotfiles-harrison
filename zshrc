# Path to your oh-my-zsh configuration.
ZSH=$HOME/.dotfiles-harrison/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# DEFAULT: robbyrussell
ZSH_THEME="katz"

# username for use with certain themes
DEFAULT_USER="harrison"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/pgsql-9.1/bin/:/home/harrison/Apps/idea/bin/:/home/harrison/Apps/android-sdk-linux/tools/:/home/harrison/Apps/android-sdk-linux/platform-tools/:/home/harrison/Apps/android-studio/bin/
export EDITOR=/usr/bin/vim

# sets completion to be arrow driven
zstyle ':completion:*' menu select

setopt AUTO_CD
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt RM_STAR_WAIT
setopt EXTENDED_GLOB
setopt DVORAK

# Play safe!
alias 'rm=rm -i'
alias 'mv=mv -i'
alias 'cp=cp -i'

# alt+s inserts sudo at beginning of line
insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo

# ALIAS
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias l='ls'
alias cl='clear && ls'
alias ises='psql -U postgres ises'
alias ..='cd ..'
alias 'cd..=cd ..'
alias install='sudo apt-fast install'
alias purge='sudo apt-fast purge'
alias update='sudo apt-fast update && apt-fast upgrade'
alias todo='clear && todo'
alias idea='idea.sh'
alias studio='studio.sh'
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias vim='vim -S ~/.dotfiles-harrison/vimrc'

# SUFFIX ALIAS
alias -s txt=vim
alias -s mp4=vlc

function cd ()
{
    builtin cd "$*" && cl
}

function ack () {
    if [ -e ~/bin/ack ] ; then
        ~/bin/ack "$@"
    elif [ -e /usr/bin/ack ] ; then
        /usr/bin/ack "$@"
    else
        \grep -lR "$@" | \grep -v "/\.svn/"
    fi
}

function vack () {
    files="$(ack -l "$@")"
    if [ -z "$files" ] ; then
        echo "No matches found."
    else
        vim $files
    fi
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Define Colors
# normal
black="%{^[[0;30m%}"
red="%{^[[0;31m%}"
green="%{^[[0;32m%}"
yellow="%{^[[0;33m%}"
blue="%{^[[0;34m%}"
magenta="%{^[[0;35m%}"
cyan="%{^[[0;36m%}"
white="%{^[[0;37m%}"

# bold (grey is actually bold black)
grey="%{^[[01;30m%}"
bred="%{^[[01;31m%}"
bgreen="%{^[[01;32m%}"
byellow="%{^[[01;33m%}"
bblue="%{^[[01;34m%}"
bmagenta="%{^[[01;35m%}"
bcyan="%{^[[01;36m%}"
bwhite="%{^[[01;37m%}"

# underscore
ublack="%{^[[04;30m%}"
ugrey="%{^[[01;04;30m%}"
ured="%{^[[04;31m%}"
ugreen="%{^[[04;32m%}"
uyellow="%{^[[04;33m%}"
ublue="%{^[[04;34m%}"
umagenta="%{^[[04;35m%}"
ucyan="%{^[[04;36m%}"
uwhite="%{^[[04;37m%}"

# blinking
kgrey="%{^[[01;05;30m%}"
kred="%{^[[05;31m%}"
kgreen="%{^[[05;32m%}"
kyellow="%{^[[05;33m%}"
kblue="%{^[[05;34m%}"
kmagenta="%{^[[05;35m%}"
kcyan="%{^[[05;36m%}"
kwhite="%{^[[05;37m%}"

normal="%{^[[0m%}"

# example of background colour
# foreground white = 37
# background red = 41
fgwhitebgred="%{^[[0;37;41m%}"
