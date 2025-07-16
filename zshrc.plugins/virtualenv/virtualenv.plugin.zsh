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

# reactivate the virtualenv
function reactivate () {
    [[ -n $VIRTUAL_ENV ]] && deactivate
    [[ -e ".venv/" ]] && source ".venv/bin/activate"
}
