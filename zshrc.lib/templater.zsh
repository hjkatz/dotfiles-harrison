# Advanced templater for various dotfiles with async compilation and caching

# Async template compilation function
function _async_compile_template() {
    local template_file="$1"
    local compiled_file="$2"
    local checksum_file="$3"
    local result_file="$4"

    # Create lock file to prevent concurrent compilation
    local lock_file="${compiled_file}.lock"
    local lock_acquired=false

    # Try to acquire lock with timeout
    local timeout=10
    local start_time=$(date +%s)
    while [[ $(($(date +%s) - start_time)) -lt $timeout ]]; do
        if (set -C; echo $$ > "$lock_file") 2>/dev/null; then
            lock_acquired=true
            break
        fi
        sleep 0.1
    done

    if [[ "$lock_acquired" != "true" ]]; then
        echo "lock_failed" > "$result_file"
        return 1
    fi

    # Ensure lock is cleaned up on exit
    trap "rm -f '$lock_file'" EXIT

    # Validate template exists
    if [[ ! -f "$template_file" ]]; then
        echo "template_missing" > "$result_file"
        return 1
    fi

    # Calculate template checksum for caching
    local current_checksum=$(md5sum "$template_file" 2>/dev/null | cut -d' ' -f1)

    # Check if recompilation is needed
    if [[ -f "$compiled_file" && -f "$checksum_file" ]]; then
        local cached_checksum=$(cat "$checksum_file" 2>/dev/null)
        if [[ "$current_checksum" == "$cached_checksum" ]]; then
            echo "cached" > "$result_file"
            return 0
        fi
    fi

    # Use atomic file creation with temporary file
    local temp_compiled="${compiled_file}.tmp.$$"

    # Read template content into memory
    local template_content
    if ! template_content=$(<"$template_file"); then
        echo "read_failed" > "$result_file"
        return 1
    fi

    # Extract template variables using grep (safer than regex in zsh)
    local vars=()
    local found_vars=$(grep -o '{{[A-Za-z_][A-Za-z0-9_]*}}' "$template_file" 2>/dev/null | sed 's/{{//g; s/}}//g' | sort -u)

    # Convert to array
    while IFS= read -r var; do
        [[ -n "$var" ]] && vars+=("$var")
    done <<< "$found_vars"

    # Replace variables in content
    for var in "${vars[@]}"; do
        local var_value="${(P)var:-}"
        if [[ -n "$var_value" ]]; then
            # Use Zsh parameter expansion for replacement (safer than sed)
            template_content="${template_content//\{\{${var}\}\}/${var_value}}"
        fi
    done

    # Write compiled content directly to temporary file, then move atomically
    if ! printf '%s' "$template_content" > "$temp_compiled" 2>/dev/null; then
        echo "write_failed" > "$result_file"
        return 1
    fi

    # Atomically move temporary file to final location using command instead of alias
    if ! command mv "$temp_compiled" "$compiled_file" 2>/dev/null; then
        rm -f "$temp_compiled"
        echo "move_failed" > "$result_file"
        return 1
    fi

    # Save checksum for future caching
    echo "$current_checksum" > "$checksum_file"
    echo "compiled" > "$result_file"
    return 0
}

# Check for async template compilation results
function _check_async_template_results() {
    local file="$1"
    local result_file="$DOTFILES_CACHE/template_${file}"
    local pid_file="$DOTFILES_CACHE/template_${file}_pid"

    # Check if background compilation is still running
    if [[ -f "$pid_file" ]]; then
        local bg_pid=$(cat "$pid_file" 2>/dev/null)
        if kill -0 "$bg_pid" 2>/dev/null; then
            return 0  # Still running
        else
            rm -f "$pid_file"  # Clean up
        fi
    fi

    # Process results if available
    if [[ -f "$result_file" ]]; then
        local result=$(cat "$result_file" 2>/dev/null)
        case "$result" in
            "compiled")
                [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "✅ Template $file compiled successfully"
                ;;
            "cached")
                [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "📋 Template $file using cached version"
                ;;
            "template_missing")
                color_echo red "❌ Template $file.template not found"
                ;;
            "read_failed")
                color_echo red "❌ Failed to read template $file"
                ;;
            "write_failed")
                color_echo red "❌ Failed to write compiled template $file"
                ;;
            "lock_failed")
                [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "⏳ Template $file compilation lock timeout"
                ;;
            "move_failed")
                color_echo red "❌ Failed to finalize template $file compilation"
                ;;
        esac
        rm -f "$result_file"
    fi
}

# Enhanced compile_file function with async support and caching
function compile_file() {
    local file="$1"
    local force_sync="${2:-false}"

    if [[ ! -d $GLOBALS__DOTFILES_TEMPLATES_PATH ]]; then
        color_echo red "Unable to find templates path! Please \`export GLOBALS__DOTFILES_TEMPLATES_PATH=\"\$DOTFILES/path/to/templates/\"\`."
        return 1
    fi

    if [[ ! -d $GLOBALS__DOTFILES_COMPILED_PATH ]]; then
        mkdir -p "$GLOBALS__DOTFILES_COMPILED_PATH"
    fi

    local template="$GLOBALS__DOTFILES_TEMPLATES_PATH/$file.template"
    local compiled="$GLOBALS__DOTFILES_COMPILED_PATH/$file"
    local checksum_file="$DOTFILES_CACHE/template_${file}_checksum"
    local result_file="$DOTFILES_CACHE/template_${file}"
    local pid_file="$DOTFILES_CACHE/template_${file}_pid"

    # Check for previous async results first
    _check_async_template_results "$file"

    if [[ ! -f "$template" ]]; then
        color_echo red "Unable to find template '$template'!"
        return 1
    fi

    # For critical files or forced sync, compile synchronously
    if [[ "$force_sync" == "true" || "$file" == "gitconfig" ]]; then
        [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "🔄 Compiling template $file synchronously..."

        mkdir -p "$(dirname "$checksum_file")"
        _async_compile_template "$template" "$compiled" "$checksum_file" "$result_file"
        _check_async_template_results "$file"
        return $?
    fi

    # Check if compiled file exists and is recent
    if [[ -f "$compiled" && -f "$checksum_file" ]]; then
        local template_checksum=$(md5sum "$template" 2>/dev/null | cut -d' ' -f1)
        local cached_checksum=$(cat "$checksum_file" 2>/dev/null)

        if [[ "$template_checksum" == "$cached_checksum" ]]; then
            [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "📋 Template $file is up to date"
            return 0
        fi
    fi

    # Start async compilation if not already running and no lock exists
    local lock_file="${compiled}.lock"
    if [[ ! -f "$pid_file" && ! -f "$lock_file" ]]; then
        mkdir -p "$(dirname "$result_file")"
        { _async_compile_template "$template" "$compiled" "$checksum_file" "$result_file" } &!
        echo $! > "$pid_file"
        [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "🔄 Starting async template compilation for $file..."
    elif [[ -f "$lock_file" ]]; then
        [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "⏳ Template $file compilation already in progress..."
    fi

    return 0
}

# Template management utilities
function dotfiles_template_status() {
    color_echo blue "📄 Template Compilation Status"
    echo

    local cache_dir="$DOTFILES_CACHE"
    local templates_found=false

    # Check for running compilations
    if [[ -n $(find "$cache_dir" -name "template_*_pid" -type f 2>/dev/null) ]]; then
        for pid_file in "$cache_dir"/template_*_pid; do
            if [[ -f "$pid_file" ]]; then
                local pid=$(cat "$pid_file" 2>/dev/null)
                local template_name=$(basename "$pid_file" _pid | sed 's/template_//')
                if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
                    color_echo yellow "🔄 Template $template_name compiling (PID: $pid)"
                    templates_found=true
                fi
            fi
        done
    fi

    # Check for cached results
    if [[ -n $(find "$cache_dir" -name "template_*_checksum" -type f 2>/dev/null) ]]; then
        for checksum_file in "$cache_dir"/template_*_checksum; do
            if [[ -f "$checksum_file" ]]; then
                local template_name=$(basename "$checksum_file" _checksum | sed 's/template_//')
                local age=$(( $(date +%s) - $(stat -c %Y "$checksum_file" 2>/dev/null || stat -f %m "$checksum_file" 2>/dev/null || echo 0) ))
                color_echo green "📋 Template $template_name cached (${age}s old)"
                templates_found=true
            fi
        done
    fi

    if [[ "$templates_found" == false ]]; then
        color_echo green "✅ No template compilation activity"
    fi
}

function dotfiles_template_clean() {
    color_echo yellow "🧹 Cleaning all caches..."
    find "$DOTFILES_CACHE" -name "template_*" -type f -delete 2>/dev/null || true
    rm -f "$DOTFILES_CACHE/plugins_combined.zsh" 2>/dev/null || true
    rm -f "$DOTFILES_CACHE/zshrc_d_combined.zsh" 2>/dev/null || true
    rm -f "$DOTFILES_CACHE/completion_*" 2>/dev/null || true
    rm -f "$DOTFILES_CACHE/bash_completions_loaded" 2>/dev/null || true
    if [[ -d "$GLOBALS__DOTFILES_COMPILED_PATH" ]]; then
        find "$GLOBALS__DOTFILES_COMPILED_PATH" -name "*.lock" -type f -delete 2>/dev/null || true
        find "$GLOBALS__DOTFILES_COMPILED_PATH" -name "*.tmp.*" -type f -delete 2>/dev/null || true
    fi
    color_echo green "✅ All caches cleaned"
}

function dotfiles_template_recompile() {
    local file="${1:-gitconfig}"
    color_echo yellow "🔄 Force recompiling template $file..."
    compile_file "$file" true
}

# compile critical templates synchronously on startup
compile_file gitconfig true

# compile other templates asynchronously for next time
# (add other templates here as needed)
