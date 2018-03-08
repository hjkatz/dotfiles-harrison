# [see: https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/virtualenv/virtualenv.plugin.zsh]

# configure:
#   - ZSH_THEME_VIRTUALENV_PREFIX : prefix for prompt
#   - ZSH_THEME_VIRTUALENV_SUFFIX : suffix for prompt

function virtualenv_prompt_info () {
    [[ ${GLOBALS__SHOW_PROMPT_HASH[virtualenv]} != true ]] && return

    [[ -n ${VIRTUAL_ENV} ]] || return
    echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1
