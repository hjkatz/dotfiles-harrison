# ENV exports

# Set Path
export PATH=$PATH:/usr/local/git/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$DOTFILES/bin

# Set default editor
export EDITOR=/usr/bin/vim

# Setup zsh history tracking
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# Set default pager and settings
export PAGER="less"
export LESS="-F -X -I -R"

# ls colors (see:http://geoff.greer.fm/lscolors/)
export LSCOLORS="ExgxbxdxCxegedabagacad"

# Zsh compdump
export SHORT_HOST=${HOST/.*/}
export ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# Setup psqlrc location
export PSQLRC="$DOTFILES/psqlrc"
