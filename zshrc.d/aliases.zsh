# Aliases

# REGULAR ALIASES

# safety first!
alias rm='rm -i '
alias mv='mv -i '
alias cp='cp -i '

# rip g script :(
alias g="git "

# various listing aliases
if ls --color=auto &> /dev/null ; then
    # --color is valid
    local _color='--color=auto'
else
    # CLICOLOR is used instead (see: https://superuser.com/questions/183876/how-do-i-get-ls-color-auto-to-work-on-mac-os-x)
    local _color=''
fi

alias ls="ls $_color "
alias ll="ls -alF $_color "
alias l="ls -CF $_color "
unset _color

alias cl='clear && ls '
alias tree='tree -lFC '
alias treee='tree -alFC -pug '

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

alias md='mkdir -p '
alias rd='rmdir '
alias d='dirs -v | head -10'

# quick history
alias history='fc -il 1'

# quick dotfile access
alias dotfiles='cd $DOTFILES'

# aliases for quick editing dotfiles
alias vimrc="vim $DOTFILES/vimrc"
alias zshrc="vim $DOTFILES/zshrc"
alias gitconfig="vim $GLOBALS__DOTFILES_TEMPLATES_PATH/gitconfig.template"
alias psqlrc="vim $DOTFILES/psqlrc"

# nocorrect aliases
alias ebuild='nocorrect ebuild '
alias gist='nocorrect gist '
alias heroku='nocorrect heroku '
alias hpodder='nocorrect hpodder '
alias man='nocorrect man '
alias mkdir='nocorrect mkdir '
alias mysql='nocorrect mysql '
alias sudo='nocorrect sudo '
alias pry='nocorrect pry '
alias yard='nocorrect yard '
alias rspec='nocorrect rspec '

# show a keyboard on screen for presentations
alias show_keyboard='key-mon --theme=clear-ubuntu --nomouse --scale=1.5 --old-keys=3 --decorated >/dev/null 2>&1 &'

# zmv and friends
alias zmv='noglob zmv -W '
alias zcp='noglob zmv -W -C '
alias zln='noglob zmv -W -L '
alias zsy='noglob zmv -W -Ls'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(tail $HISTFILE -n1 | sed '\''s/^:\s*[0-9]\+:[0-9]*;//'\'' | sed '\''s/;\s*alert.*//'\'')"'

# alias to rename function
alias remove='purge'

# ubuntu + audio :(
alias fix_audio='killall pulseaudio; \rm -rf ~/.config/pulse/* ; \rm -rf ~/.pulse*; sleep 10; pulseaudio -k'

# SUFFIX ALIASES
alias -s txt=vim
alias -s mp4=vlc

# GLOBAL ALIASES

# sort and uniq
alias -g USORT=' sort | uniq '

# count lines in outpub
alias -g COUNT=' wc -l '

# fix typos for git's HEAD
alias -g EHAD='HEAD'

# resolves to the current matching stash in `git stash list` for the current branch, i.e. "stash@{1}"
alias -g GCURRENT='$(git stash list | grep $(git rev-parse --symbolic-full-name --abbrev-ref "@{u}" | sed "s#\w*/##") | sed "s/\(stash@{.*}\):.*/\1/")'
