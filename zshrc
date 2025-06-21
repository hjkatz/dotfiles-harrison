# Main Zshrc that loads all other parts of the dotfiles

# Startup timing (only for interactive shells, and only if timing is enabled and not debugging)
if [[ $- == *i* ]] && [[ -z "$DOTFILES_STARTUP_TIME" ]] && [[ "${DOTFILES_ENABLE_TIMING:-true}" == "true" ]] && [[ "$ENABLE_DEBUGGING" != "true" ]]; then
    # Load datetime module for fast timing
    zmodload zsh/datetime 2>/dev/null
    DOTFILES_STARTUP_START=${EPOCHREALTIME}
fi

# prints debugging info (preserve if already set by resource_with_debugging)
ENABLE_DEBUGGING=${ENABLE_DEBUGGING:-false}

# Where the dotfiles are located to load
export DOTFILES=$HOME/.dotfiles-harrison

# Fast track: Skip heavy loading for simple commands
if [[ $# -eq 1 && "$1" =~ ^(git|ls|cd|pwd|echo)$ ]] && [[ ! -t 0 ]]; then
    # Simple command in non-interactive context - minimal setup
    PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
    alias g="git"
    return 0
fi

# run the debugging, if enabled
source $DOTFILES/zshrc.lib/debugging.zsh

# source core functions
source $DOTFILES/zshrc.lib/core_functions.zsh

# source user settings
source $DOTFILES/zshrc.lib/user.zsh

# turn on zsh options
source $DOTFILES/zshrc.lib/setopts.zsh

# autoload zsh functions
source $DOTFILES/zshrc.lib/autoloads.zsh

# load globals
source $DOTFILES/zshrc.lib/globals.zsh

# check and apply updates
source $DOTFILES/zshrc.lib/updater.zsh

# set the version after attempting to update
export DOTFILES_VERSION=`head -n 1 $DOTFILES/VERSION`

# setup the environment variables
source $DOTFILES/zshrc.lib/environment.zsh

# Source any local files for custom environments
if [ -f $HOME/.zshrc_local ] ; then
    # Time zshrc_local loading
    if [[ -n "$DOTFILES_STARTUP_START" ]]; then
        DOTFILES_ZSHRC_LOCAL_START=${EPOCHREALTIME}
    fi
    source $HOME/.zshrc_local
    if [[ -n "$DOTFILES_STARTUP_START" ]]; then
        # Convert to milliseconds (EPOCHREALTIME is in seconds with decimals)
        DOTFILES_ZSHRC_LOCAL_TIME=$(( (${EPOCHREALTIME} - DOTFILES_ZSHRC_LOCAL_START) * 1000 ))
    fi
fi

# Conditional templater loading (non-interactive shells rarely need templates)
if [[ $- == *i* ]] || [[ -n "$FORCE_TEMPLATE_LOAD" ]]; then
    source $DOTFILES/zshrc.lib/templater.zsh
else
    # Minimal template stub for non-interactive shells
    function compile_file() { return 0; }
fi

# source the gitconfig hack
source $DOTFILES/zshrc.lib/gitconfig.zsh

# Note: Completion init must occur in the zshrc file

# add custom / vendor completions to fpath (loaded by compinit in zshrc)
fpath+=( "$GLOBALS__DOTFILES_COMPLETIONS_PATH" )

# add M1 Mac homebrew site-functions
if [[ $GLOBALS__DISTRO == "darwin" ]] ; then
    fpath+=( /opt/homebrew/share/zsh/site-functions/ )
    fpath+=( /opt/homebrew/share/zsh-completions/ )
fi

# tell the world where our completion functions exist
export fpath

# Hybrid completion loading: sync core + async enhancements
# Phase 1: Essential sync loading for immediate functionality
autoload -Uz compinit

# Fast compinit - skip security checks for speed, we'll do full check async
compinit -C -d $ZSH_COMPDUMP

# Load essential completion configuration immediately
source $DOTFILES/zshrc.lib/completions.zsh

# Phase 2: Async enhancements for additional completions
function _load_completion_enhancements() {
    local cache_dir="$DOTFILES_CACHE"
    local enhancement_ready="$cache_dir/completion_enhancements_ready"
    local enhancement_pid="$cache_dir/completion_enhancement_pid"

    # Check if enhancements are already being loaded
    if [[ -f "$enhancement_pid" ]]; then
        local pid=$(cat "$enhancement_pid" 2>/dev/null)
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            return 0  # Already loading
        fi
    fi

    # Start async enhancement loading
    {
        # Perform full security check if needed (once per day)
        if [[ -n $ZSH_COMPDUMP(#qN.mh+24) ]]; then
            autoload -Uz compinit
            compinit -i -d $ZSH_COMPDUMP
            compdump
        fi

        # Load bash completions
        autoload bashcompinit
        bashcompinit

        # Load bash completion files if they exist
        if [[ -d "$GLOBALS__DOTFILES_COMPLETIONS_PATH.bash" ]]; then
            if [[ -n "$(find "$GLOBALS__DOTFILES_COMPLETIONS_PATH.bash" -name "*.bash" -type f 2>/dev/null)" ]]; then
                for file in "$GLOBALS__DOTFILES_COMPLETIONS_PATH.bash"/*.bash; do
                    [[ -f "$file" ]] && source "$file" 2>/dev/null
                done
            fi
        fi

        # Mark enhancements as ready
        echo "ready" > "$enhancement_ready"
        rm -f "$enhancement_pid"
    } &!
    echo $! > "$enhancement_pid"
}

# Start loading enhancements in background (only for interactive shells)
if [[ $- == *i* ]]; then
    _load_completion_enhancements
fi

# Optimized zshrc.d file loading with combined cache
ZSHRC_D_COMBINED="$DOTFILES_CACHE/zshrc_d_combined.zsh"

if [[ -f "$ZSHRC_D_COMBINED" ]] && [[ -z "$(find "$DOTFILES/zshrc.d" -name "*.zsh" -newer "$ZSHRC_D_COMBINED")" ]]; then
    # Ultra-fast: source single combined file
    [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "🚀 Loading combined zshrc.d cache..."
    source "$ZSHRC_D_COMBINED"
else
    # Rebuild combined file
    [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "🔄 Rebuilding zshrc.d cache..."
    mkdir -p "$(dirname "$ZSHRC_D_COMBINED")"

    # Create combined file
    {
        echo "# Combined zshrc.d file - auto-generated $(date)"
        echo "# Do not edit manually - will be regenerated"
        echo ""

        for file in $DOTFILES/zshrc.d/*.zsh; do
            if [[ -f "$file" ]]; then
                echo "# --- File: $(basename "$file") ---"
                cat "$file"
                echo ""
            fi
        done
    } > "$ZSHRC_D_COMBINED"

    # Source the combined file
    source "$ZSHRC_D_COMBINED"
fi

# add omz compatible functions to the fpath
for plugin in $DOTFILES/zshrc.plugins/* ; do
    fpath+=( $plugin )
done
export fpath

# source zsh syntax highlighting settings (must be loaded before the plugin)
source $DOTFILES/zshrc.lib/syntax-highlighting-settings.zsh

# Minimal plugin caching (safe approach)
PLUGIN_CACHE_FILE="$DOTFILES_CACHE/plugins"

# Simple cache check: if cache exists, not empty, and no plugin files are newer, use it
if [[ -f "$PLUGIN_CACHE_FILE" ]] && [[ -s "$PLUGIN_CACHE_FILE" ]] && [[ -z "$(find "$DOTFILES/zshrc.plugins" -name "*.plugin.zsh" -newer "$PLUGIN_CACHE_FILE")" ]]; then
    # Use cache - load plugins from stored list
    [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "📦 Using cached plugins..."
    
    # Use array instead of while loop to avoid potential hang
    local plugin_list=("${(@f)$(< "$PLUGIN_CACHE_FILE")}")
    for plugin_file in "${plugin_list[@]}"; do
        if [[ -n "$plugin_file" && -f "$plugin_file" ]]; then
            [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "  Loading: $(basename "$(dirname "$plugin_file")")"
            source "$plugin_file"
        fi
    done
else
    # No cache or outdated - scan and rebuild
    [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "🔄 Scanning plugins..."
    
    # Create cache directory
    mkdir -p "$(dirname "$PLUGIN_CACHE_FILE")"
    
    # Build plugin list and cache it
    local plugin_files=()
    for plugin_dir in $DOTFILES/zshrc.plugins/*(/); do
        plugin=${plugin_dir:t}
        plugin_file="$plugin_dir/$plugin.plugin.zsh"
        if [[ -f "$plugin_file" ]]; then
            plugin_files+=("$plugin_file")
            [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "  Loading: $plugin"
            source "$plugin_file"
        fi
    done
    
    # Write cache file (use printf to avoid potential issues)
    printf '%s\n' "${plugin_files[@]}" > "$PLUGIN_CACHE_FILE"
fi

# Optimized prompt loading
if [[ $- == *i* ]]; then
    # Interactive shell - load prompt with potential optimizations
    source $DOTFILES/zshrc.lib/prompt.zsh
else
    # Non-interactive shell - minimal prompt
    PROMPT='$ '
fi

# Calculate and display startup timing (before exit tasks)
local show_timing="false"
local total_time=0
local core_time=0 
local local_time=0

if [[ -n "$DOTFILES_STARTUP_START" ]]; then
    # Single time measurement to minimize overhead
    local end_time=${EPOCHREALTIME}

    # Set flag to prevent showing timing on resource calls
    export DOTFILES_STARTUP_TIME="1"

    # Display timing breakdown (only for truly interactive shells or when forced)
    if ([[ $- == *i* ]] && [[ -t 0 ]]) || [[ "$FORCE_TIMING_DISPLAY" == "true" ]]; then
        show_timing="true"
        # Calculate timing synchronously so it displays at the actual end of startup
        # Convert to milliseconds (EPOCHREALTIME is in seconds with decimals)
        total_time=$(( (end_time - DOTFILES_STARTUP_START) * 1000 ))
        local_time=${DOTFILES_ZSHRC_LOCAL_TIME:-0}
        core_time=$((total_time - local_time))
    fi

    # Clean up timing variables
    unset DOTFILES_STARTUP_START DOTFILES_ZSHRC_LOCAL_START DOTFILES_ZSHRC_LOCAL_TIME
fi

# Load exit tasks
source $DOTFILES/zshrc.lib/exit-tasks.zsh

# Display startup timing at the very end
if [[ "$show_timing" == "true" ]]; then
    echo
    if [[ $local_time -gt 0 ]]; then
        printf "⚡Startup: \033[32m%dms\033[0m total (\033[36m%dms\033[0m dotfiles + \033[33m%dms\033[0m local)\n" \
            "$total_time" "$core_time" "$local_time"
    else
        printf "⚡Startup: \033[32m%dms\033[0m dotfiles\n" "$core_time"
    fi
fi

# Lazy load terraform completion for faster startup
_load_terraform_completion() {
    # Remove the lazy loading functions
    unset -f terraform tf

    # Setup terraform completion if terraform is available
    if command_exists terraform; then
        terraform_path=$(which terraform)
        complete -o nospace -C "$terraform_path" terraform
    fi

    # Setup tf completion if tf is available (check common locations)
    tf_locations=("$HOME/.local/bin/tf" "/usr/local/bin/tf")
    for tf_path in "${tf_locations[@]}"; do
        if [[ -x "$tf_path" ]]; then
            complete -o nospace -C "$tf_path" tf
            break
        fi
    done
}

# Create lazy loading wrapper functions for terraform
if command_exists terraform; then
    terraform() { _load_terraform_completion && terraform "$@"; }
fi

# Check for tf in common locations and create lazy wrapper if found
tf_locations=("$HOME/.local/bin/tf" "/usr/local/bin/tf")
for tf_path in "${tf_locations[@]}"; do
    if [[ -x "$tf_path" ]]; then
        tf() { _load_terraform_completion && tf "$@"; }
        break
    fi
done

# Lazy load NVM for faster startup (saves ~630ms)
export NVM_DIR="$HOME/.nvm"

# Function to load NVM when actually needed
_load_nvm() {
    # Remove the lazy loading functions
    unset -f nvm node npm npx claude

    # Load NVM
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# Create lazy loading wrapper functions
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # Only set up lazy loading if NVM exists
    claude() { _load_nvm && claude "$@"; } # claude is nodejs
    nvm() { _load_nvm && nvm "$@"; }
    node() { _load_nvm && node "$@"; }
    npm() { _load_nvm && npm "$@"; }
    npx() { _load_nvm && npx "$@"; }
fi
