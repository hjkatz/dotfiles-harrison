# Exit Tasks for Zshrc

# run any exit task local functions if it exists
type $GLOBALS__DOTFILES_EXIT_HOOK_FUNCTION >/dev/null 2>&1 && {
    # call the function
    $GLOBALS__DOTFILES_EXIT_HOOK_FUNCTION

    # remove the function
    unset -f $GLOBALS__DOTFILES_EXIT_HOOK_FUNCTION
}

add_to_path "./bin" true
export PATH

# Echo updated message after sourcing files
if [ $GLOBALS__DOTFILES_UPDATED = true ] ; then
    color_echo green "Updated to $DOTFILES_VERSION"
fi

# Check for extremely long PATH
PATH_LENGTH=`echo $PATH | wc -c`
if [[ $PATH_LENGTH -gt 4000 ]] ; then
    color_echo yellow "Warning: current PATH length exceeds 4000 characters, perhaps it's time to reopen the terminal?"
fi

# setup the vim plugins automatically for git local dotfiles
# otherwise this is done on the first call to vim
if [[ $GLOBALS__DOTFILES_IS_GIT_LOCAL == true ]] ; then
    setup_vim_plugins
fi

# warn about caution servers
check_for_caution_server

# Auto-run debug analysis if requested
if [[ "$GLOBALS__AUTO_RUN_DEBUG" == true ]]; then
    echo
    color_echo green "✅ Instrumented startup complete! Launching performance analysis..."
    echo

    # Run debug analysis
    zsh_debug


    # Clear the auto-run flag
    unset GLOBALS__AUTO_RUN_DEBUG
fi

# turn off debugging if it was on
if [[ "$ENABLE_DEBUGGING" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi

# set distro specific completions
# NOTE: Must happen last due to parsing error in _yum case
case "$GLOBALS__DISTRO" in
    darwin)
        # fall through
        ;&
    ubuntu)
        # fall through
        ;&
    debian)
        compdef '_deb_packages avail' install
        compdef '_deb_packages installed' purge
        ;;
    fedora)
        # fall through
        ;&
    centos)
        # fall through
        ;&
    rhel)
        # fall through
        ;&
    fedora)
        # fall through
        ;&
    redhat)
        compdef '_yum_install' install
        compdef '_yum_erase' purge
        # NOTE: This causes a parsing error but still must be called, so call it last!
        _yum >/dev/null 2>&1
        echo "" >/dev/null 2>&1
        ;;
    *)
        echo "Distro '$GLOBALS__DISTRO' is unrecognized"
        ;;
esac

# Clean up async background jobs and cache files on shell exit
function cleanup_async_jobs () {
    local cache_dir="$HOME/.cache"

    # Clean up dotfiles-related PID files and kill orphaned processes
    local pid_files=(
        "$cache_dir/dotfiles_update_pid"
        "$cache_dir/dotfiles_vim_pid"
        "$cache_dir/dotfiles_connectivity_pid"
    )

    for pid_file in "${pid_files[@]}"; do
        if [[ -f "$pid_file" ]]; then
            local pid=$(cat "$pid_file" 2>/dev/null)
            if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
                # Gracefully terminate background job
                kill -TERM "$pid" 2>/dev/null
                sleep 0.1
                # Force kill if still running
                kill -KILL "$pid" 2>/dev/null
            fi
            rm -f "$pid_file"
        fi
    done

    # Clean up stale cache files older than 1 day
    find "$cache_dir" -name "dotfiles_*" -type f -mtime +1 -delete 2>/dev/null
}

# Set up exit handler for async job cleanup
function zshexit () {
    cleanup_async_jobs
}

# ensure the exit code of startup is 0
echo "" >/dev/null 2>&1
