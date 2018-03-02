# ENV exports

# adds dir to $PATH if it does not already contain it
function add_to_path () {
    dir="$1"

    if ! [[ ":$PATH:" == *":$dir:"* ]] ; then
        path+=( "$dir" )
    fi
}

# build the PATH
add_to_path "/usr/local/git/bin"
add_to_path "$DOTFILES/bin"
add_to_path "$HOME/.local/bin"
export PATH

# Set default editor
export EDITOR=/usr/bin/vim

# Setup zsh history tracking
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
export HISTORY_IGNORE="(pwd|l|ls|ll|cl|clear)"

# Set default pager and settings
export PAGER="less"
export LESS="-F -X -I -R"

# ls colors (see:http://geoff.greer.fm/lscolors/)
export LSCOLORS="ExgxbxdxCxegedabagacad"
export CLICOLOR=1 # for *BSD/darwin

# Zsh compdump
export SHORT_HOST=${HOST/.*/}
export ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# Setup psqlrc location
export PSQLRC="$DOTFILES/psqlrc"

# report how long a command took, only if > 10 seconds
# Note: time is calculated by user + system (does not include cpu)
export REPORTTIME=10
