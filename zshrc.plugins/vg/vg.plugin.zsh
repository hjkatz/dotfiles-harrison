# go vg configuration

# configure:
#   - ZSH_THEME_VG_PREFIX : prefix for prompt
#   - ZSH_THEME_VG_SUFFIX : suffix for prompt

function vg_prompt_info () {
  [[ -n ${VIRTUALGO} ]] || return
  echo "${ZSH_THEME_VG_PREFIX:=[}${VIRTUALGO:t}${ZSH_THEME_VG_SUFFIX:=]}"
}

# disables prompt mangling
export VIRTUALGO_DISABLE_PROMPT=true
