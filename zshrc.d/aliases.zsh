# Aliases

# REGULAR ALIASES

# safety first!
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# various listing aliases
alias ls='ls --color=tty'
alias ll='ls -alF'
alias l='ls -CF'
alias cl='clear && ls '
alias tree='tree -lFC'
alias treee='tree -alFC -pug'

# directory aliases
alias ..='cd ..'
alias cd..='cd ..'
alias -- -='cd -'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir
alias d='dirs -v | head -10'

# quick history
alias history='fc -il 1'

# quick dotfile access
alias dotfiles='cd $DOTFILES'

# aliases for quick editing dotfiles
alias vimrc='vim ~/.dotfiles-harrison/vimrc'
alias vim='vim -u ~/.dotfiles-harrison/vimrc'
alias zshrc='vim ~/.dotfiles-harrison/zshrc'
alias gconfig='vim ~/.dotfiles-harrison/gitconfig'

# alias for git and custom gitconfig location
alias git='HOME=$DOTFILES/ git'

# nocorrect aliases
alias ebuild='nocorrect ebuild'
alias gist='nocorrect gist'
alias heroku='nocorrect heroku'
alias hpodder='nocorrect hpodder'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mysql='nocorrect mysql'
alias sudo='nocorrect sudo'

# show a keyboard on screen for presentations
alias show_keyboard='key-mon --theme=clear-ubuntu --nomouse --scale=1.5 --old-keys=3 --decorated >/dev/null 2>&1 &'

# zmv and friends
alias zmv='noglob zmv -W'
alias zcp='noglob zmv -W -C'
alias zln='noglob zmv -W -L'
alias zsy='noglob zmv -W -Ls'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(tail $HISTFILE -n1 | sed '\''s/^:\s*[0-9]\+:[0-9]*;//'\'' | sed '\''s/;\s*alert.*//'\'')"'

# alias to rename function
alias remove='purge'

# SUFFIX ALIASES
alias -s txt=vim
alias -s mp4=vlc

# GLOBAL ALIASES

# sort and uniq
alias -g USORT=' | sort | uniq '

# count lines in outpub
alias -g COUNT=' | wc -l'

# resolves to the current matching stash in `git stash list` for the current branch, i.e. "stash@{1}"
alias -g GCURRENT='$(git stash list | grep $(git rev-parse --symbolic-full-name --abbrev-ref "@{u}" | sed "s#\w*/##") | sed "s/\(stash@{.*}\):.*/\1/")'
