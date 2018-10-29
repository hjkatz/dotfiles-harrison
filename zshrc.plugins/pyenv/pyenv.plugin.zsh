# This plugin loads pyenv into the current shell and provides prompt info via
# the 'pyenv_prompt_info' function. Also loads pyenv-virtualenv if available.

# configure:
#   - ZSH_THEME_PYENV_PREFIX : prefix for prompt
#   - ZSH_THEME_PYENV_SUFFIX : suffix for prompt
#   - ZSH_THEME_PYENV_NAME   : name for prompt
#   - ZSH_THEME_PYENV_SEP    : separator for prompt

FOUND_PYENV=$+commands[pyenv]

if [[ $FOUND_PYENV -ne 1 ]]; then
    pyenvdirs=("$HOME/.pyenv" "/usr/local/pyenv" "/opt/pyenv")
    for dir in $pyenvdirs; do
        if [[ -d $dir/bin ]]; then
            export PATH="$PATH:$dir/bin"
            FOUND_PYENV=1
            break
        fi
    done
fi

if [[ $FOUND_PYENV -ne 1 ]]; then
    if (( $+commands[brew] )) && dir=$(brew --prefix pyenv 2>/dev/null); then
        if [[ -d $dir/bin ]]; then
            export PATH="$PATH:$dir/bin"
            FOUND_PYENV=1
        fi
    fi
fi

if [[ $FOUND_PYENV -eq 1 ]]; then
    eval "$(pyenv init - zsh)"
    if (( $+commands[pyenv-virtualenv-init] )); then
        eval "$(pyenv virtualenv-init - zsh)"
    fi
    function current_python () {
        echo "$(pyenv version-name)"
    }
else
    function current_python () {
        echo "system: $(python -V 2>&1 | cut -f 2 -d ' ')"
    }
fi

function pyenv_prompt_info() {
    [[ ${GLOBALS__SHOW_PROMPT_HASH[pyenv]} != true ]] && return

    echo "${ZSH_THEME_PYENV_PREFIX:=[}${ZSH_THEME_PYENV_NAME:=pyenv}${ZSH_THEME_PYENV_SEP:=:}$(current_python)${ZSH_THEME_PYENV_SUFFIX:=]}"
}

unset FOUND_PYENV dir
