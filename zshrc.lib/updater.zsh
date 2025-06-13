# Controls the updating for the dotfiles

# Async git update function that runs in background
function _async_update_dotfiles() {
    local dotfiles_dir="$1"
    local last_updated_path="$2"
    local temp_result_file="$3"

    # Change to dotfiles directory
    cd "$dotfiles_dir" || return 1

    # Check if this is a git repo
    git rev-parse >/dev/null 2>&1 || return 1

    # Record old hash
    local old_hash=$(git rev-parse --verify HEAD 2>/dev/null)

    # Get default branch
    local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|^refs/remotes/origin/||')
    : ${default_branch:="master"}

    # Perform git operations
    if git fetch origin "$default_branch" >/dev/null 2>&1; then
        local new_hash=$(git rev-parse --verify "origin/$default_branch" 2>/dev/null)

        # Check if there are updates available
        if [[ "$old_hash" != "$new_hash" ]]; then
            echo "updates_available" > "$temp_result_file"
            echo "$new_hash" >> "$temp_result_file"
        else
            echo "no_updates" > "$temp_result_file"
        fi
    else
        echo "fetch_failed" > "$temp_result_file"
    fi

    # Record check time
    echo "$(date +%s)" > "$last_updated_path"
}

# Check for async update results and apply if needed
function _check_async_update_results() {
    local temp_result_file="$HOME/.cache/dotfiles_async_update"
    local pid_file="$HOME/.cache/dotfiles_update_pid"

    # Check if background update is still running
    if [[ -f "$pid_file" ]]; then
        local bg_pid=$(cat "$pid_file" 2>/dev/null)
        if kill -0 "$bg_pid" 2>/dev/null; then
            # Still running, don't block startup
            return 0
        else
            # Background job finished, clean up pid file
            rm -f "$pid_file"
        fi
    fi

    # Check results if available
    if [[ -f "$temp_result_file" ]]; then
        local result=$(head -n1 "$temp_result_file" 2>/dev/null)

        case "$result" in
            "updates_available")
                if [[ "$ENABLE_DEBUGGING" == "true" ]]; then
                    color_echo green "🔄 Updates available, applying in background..."
                fi
                # Apply update in background (non-blocking)
                {
                    cd "$DOTFILES" && git pull >/dev/null 2>&1
                    export GLOBALS__DOTFILES_UPDATED=true
                } &!
                ;;
            "no_updates")
                [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "✅ Dotfiles up to date"
                ;;
            "fetch_failed")
                [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "⚠️ Update check failed (network issue)"
                ;;
        esac

        # Clean up result file
        rm -f "$temp_result_file"
    fi
}

# Main update function - now async
function update_dotfiles() {
    # don't update if check for updates is false
    [ $GLOBALS__CHECK_FOR_UPDATES = false ] && return 0

    # Check for previous async results first
    _check_async_update_results

    # don't update if we've checked recently
    local last_updated_path="$DOTFILES/.last_updated_at"
    last_updated_at=$(head -n 1 "$last_updated_path" 2>/dev/null)
    : ${last_updated_at:="0"} # default to the beginning of time
    [[ $(( $(date +%s) - $last_updated_at )) -lt $UPDATE_CHECK_INTERVAL_SECONDS ]] && return 0

    # don't update if there's no internet
    has_internet || return 0

    # Start async update in background
    local temp_result_file="$HOME/.cache/dotfiles_async_update"
    local pid_file="$HOME/.cache/dotfiles_update_pid"

    # Ensure cache directory exists
    mkdir -p "$(dirname "$temp_result_file")"

    # Clean up any stale files
    rm -f "$temp_result_file"

    # Start background update
    { _async_update_dotfiles "$DOTFILES" "$last_updated_path" "$temp_result_file" } &!
    local bg_pid=$!

    # Store the background PID
    echo "$bg_pid" > "$pid_file"

    [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "🔄 Starting async dotfiles update check..."
}

# check to update
update_dotfiles
