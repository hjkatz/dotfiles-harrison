# Color settings for zsh-syntax-highlighing (see:https://github.com/zsh-users/zsh-syntax-highlighting)

# turn on various highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets pattern )

# Declare ZSH_HIGHLIGHT_STYLES as associative array
typeset -A ZSH_HIGHLIGHT_STYLES

# main
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[unknown-token]='bg=red,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'
ZSH_HIGHLIGHT_STYLES[function]='fg=green'
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=blue,underline,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='white'
ZSH_HIGHLIGHT_STYLES[path_prefix]='white'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='none'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='none'
ZSH_HIGHLIGHT_STYLES[assign]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan,bold'

# brackets
ZSH_HIGHLIGHT_STYLES[bracket-error]='bg=white,fg=red,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'

# user defined patterns

# be very cognizant of rm -rf
ZSH_HIGHLIGHT_PATTERNS+=( 'rm -rf *' 'fg=white,bold,bg=red' )
