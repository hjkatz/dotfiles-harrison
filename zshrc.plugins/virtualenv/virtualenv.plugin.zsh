# [see: https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/virtualenv/virtualenv.plugin.zsh]

# configure:
#   - ZSH_THEME_VIRTUALENV_PREFIX : prefix for prompt
#   - ZSH_THEME_VIRTUALENV_SUFFIX : suffix for prompt
#   - ZSH_THEME_VIRTUALENV_NAME : name of prompt
#   - ZSH_THEME_VIRTUALENV_SEP  : separator of prompt from name

function virtualenv_prompt_info () {
    [[ ${GLOBALS__SHOW_PROMPT_HASH[venv]} != true && ${GLOBALS__SHOW_PROMPT_HASH[virtualenv]} != true ]] && return

    [[ -n $VIRTUAL_ENV_PROMPT ]] || return
    echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${ZSH_THEME_VIRTUALENV_NAME}${ZSH_THEME_VIRTUALENV_SEP}${VIRTUAL_ENV_PROMPT:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1

# stores the currently active virtual environment root
export _CURRENT_VENV_ROOT=""
auto_venv () {
    if [[ -n $VIRTUAL_ENV ]]; then
        # we are in a virtualenv, so set the current venv root
        _CURRENT_VENV_ROOT=$(dirname "$VIRTUAL_ENV")
    else
        # no virtualenv, reset the current venv root
        _CURRENT_VENV_ROOT=""
    fi

    if [[ -e .venv/ ]]; then
        reactivate # from virtualenv.plugin.zsh
    elif [[ -n $VIRTUAL_ENV ]] && [[ `pwd` != "$_CURRENT_VENV_ROOT"* ]]; then
        # left the venv dir
        deactivate
    fi
}

# add `setuv` to be called automatically anytime we change directories
autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd auto_venv

# reactivate the virtualenv
function reactivate () {
    [[ -n $VIRTUAL_ENV ]] && deactivate
    [[ -e ".venv/" ]] && source ".venv/bin/activate"
}

# uv helper functions

function uv_activate () {
    reactivate
    show_prompt virtualenv
}

function uv_deactivate () {
    deactivate
    hide_prompt virtualenv
}

function uv_create_venv () {
    local name="$1"

    local prompt_flag=""
    if [[ -n $name ]]; then
        prompt_flag="--prompt=$name"
    fi
    uv venv $prompt_flag
}

function uv_get_in_out_files () {
    name_or_file="$1"
    default_file="requirements.in"
    default_suffix="-requirements.in"

    found_file="$name_or_file"
    if [[ -z $name_or_file ]]; then
        found_file="$default_file"
    else
        if [[ -f $name_or_file ]]; then
            found_file="$name_or_file"
        elif [[ -f "$name_or_file.in" ]]; then
            found_file="$name_or_file.in"
        elif [[ -f "$name_or_file$default_suffix" ]]; then
            found_file="$name_or_file$default_suffix"
        fi
    fi

    file_no_extension="${found_file%.in}"
    in_file="$file_no_extension.in"
    out_file="$file_no_extension.txt"

    echo "$in_file" "$out_file"
}

function uv_compile () {
    uv_files=($(uv_get_in_out_files "$@"))
    in_file="${uv_files[1]}" # 1-indexed :(
    out_file="${uv_files[2]}"

    echo "Compiling $in_file -> $out_file"

    if [[ -n $VIRTUAL_ENV ]]; then
        uv pip compile $in_file -o $out_file --emit-index-url
    else
        echo "No active venv found (run reactivate?)"
        return 1
    fi
}

function uv_install () {
    uv_files=($(uv_get_in_out_files "$@"))
    in_file="${uv_files[1]}" # 1-indexed :(
    out_file="${uv_files[2]}"

    echo "Installing $out_file"
    if [[ -n $VIRTUAL_ENV ]]; then
        uv pip install -r requirements.txt
    else
        echo "No active venv found (run reactivate?)"
        return 1
    fi
}

function uv_new () {
    uv_create_venv "$@"
    uv_activate
    uv_compile
    uv_install
}

function uv_delete () {
    if [[ -n $VIRTUAL_ENV ]]; then
        deactivate
    fi

    if [[ -d ".venv" ]]; then
        rm -rf ".venv"
    else
        echo "No venv found to delete."
        return 1
    fi
}
