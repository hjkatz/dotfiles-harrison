# Get the directory of this plugin file
dir="$DOTFILES/zshrc.plugins/gitfast"

source $dir/../git/git.plugin.zsh
source $dir/git-prompt.sh

# Simple synchronous git prompt
function git_prompt_info() {
    [[ ${GLOBALS__SHOW_PROMPT_HASH[git]} != true ]] && return

    # Use the __git_ps1 function from git-prompt.sh
    local git_info=$(__git_ps1 "%s" 2>/dev/null)

    if [[ -n "$git_info" ]]; then
        # Check if repo is dirty
        local dirty=$(parse_git_dirty)

        echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${git_info}${dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
    fi
}
