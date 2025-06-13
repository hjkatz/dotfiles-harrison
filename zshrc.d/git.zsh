# Utility function for the various git prompts

# Check git version for feature compatibility
autoload -Uz is-at-least
if is-at-least 1.7.2 "$(git --version | cut -d' ' -f3)"; then
    POST_1_7_2_GIT=1
else
    POST_1_7_2_GIT=0
fi

# Checks if working tree is dirty
function parse_git_dirty() {
    local STATUS=''
    local FLAGS

    FLAGS=('--porcelain')

    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
        FLAGS+='--ignore-submodules=dirty'
    fi

    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
        FLAGS+='--untracked-files=no'
    fi

    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
    if [[ -n $STATUS ]]; then
        echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
        echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
}
