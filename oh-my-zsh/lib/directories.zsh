# Changing/making/removing directory
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias ..='cd ..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd/='cd /'

alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

cd () {
  if [[ -f "$1" ]]; then
    builtin cd $(dirname "$1")
  elif [[ "$1" == "" ]]; then
    builtin cd
  else
    builtin cd "$1"
  fi
}

alias md='mkdir -p'
alias rd=rmdir
alias d='dirs -v | head -10'

_git_cd() {
  if [[ "$1" != "" ]]; then
   builtin cd "$@"
  else
    local OUTPUT
    OUTPUT="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ -e "$OUTPUT" ]]; then
      if [[ "$OUTPUT" != "$(pwd)" ]]; then
        builtin cd "$OUTPUT"
      else
        builtin cd
      fi
    else
      builtin cd 
    fi
  fi
}

alias cd=_git_cd
