# Zsh autoload functions

# load the amazing zmv function
autoload zmv

# ls colors
autoload -U colors && colors

# pre load completion engine
autoload -U compaudit compinit
