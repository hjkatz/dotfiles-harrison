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

# Truly async completion loading - defer everything to first tab press
function _load_completions_async() {
    local cache_dir="$DOTFILES_CACHE"
    local completion_ready="$cache_dir/completions_ready"
    local completion_pid="$cache_dir/completion_init_pid"
    
    # Check if completions are already being loaded
    if [[ -f "$completion_pid" ]]; then
        local pid=$(cat "$completion_pid" 2>/dev/null)
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            return 0  # Already loading
        fi
    fi
    
    # Start async completion loading
    {
        # Perform compinit only once a day
        autoload -Uz compinit
        if [[ -n $ZSH_COMPDUMP(#qN.mh+24) ]]; then
            compinit -i -d $ZSH_COMPDUMP
            compdump
        else
            compinit -C -d $ZSH_COMPDUMP
        fi

        # Load bash completions
        autoload bashcompinit
        bashcompinit

        # Load bash completion files if they exist
        local bash_comp_cache="$cache_dir/bash_completions_loaded"
        if [[ ! -f "$bash_comp_cache" && -d "$GLOBALS__DOTFILES_COMPLETIONS_PATH.bash" ]]; then
            if [[ -n "$(find "$GLOBALS__DOTFILES_COMPLETIONS_PATH.bash" -name "*.bash" -type f 2>/dev/null)" ]]; then
                for file in "$GLOBALS__DOTFILES_COMPLETIONS_PATH.bash"/*.bash; do
                    [[ -f "$file" ]] && source "$file"
                done
                touch "$bash_comp_cache"
            fi
        fi
        
        echo "ready" > "$completion_ready"
        rm -f "$completion_pid"
    } &!
    echo $! > "$completion_pid"
}

# Setup minimal completion stub and trigger async loading
function _completion_stub() {
    # Remove stub and load real completions
    unset -f _completion_stub
    zle -D complete-word
    
    # Wait for async completions or load them now
    local completion_ready="$DOTFILES_CACHE/completions_ready"
    local wait_time=0
    
    # Wait up to 100ms for async completions
    while [[ $wait_time -lt 10 && ! -f "$completion_ready" ]]; do
        sleep 0.01
        ((wait_time++))
    done
    
    # If not ready, load synchronously (fallback)
    if [[ ! -f "$completion_ready" ]]; then
        autoload -Uz compinit
        compinit -C -d $ZSH_COMPDUMP
    fi
    
    # Setup real completion widget
    zle -C complete-word .complete-word _main_complete
    zle complete-word
}

# Override tab completion to load completions on first use
zle -N complete-word _completion_stub

# Start loading completions in background immediately
_load_completions_async

# Defer completion config until completion system is ready
function _load_completion_config() {
    local completion_ready="$DOTFILES_CACHE/completions_ready"
    
    # Wait for completions to be ready or load them now
    local wait_time=0
    while [[ $wait_time -lt 50 && ! -f "$completion_ready" ]]; do
        sleep 0.01
        ((wait_time++))
    done
    
    # Load completion config once system is ready
    if [[ -f "$completion_ready" ]] || command -v compdef >/dev/null 2>&1; then
        source $DOTFILES/zshrc.lib/completions.zsh
    fi
}

# Load completion config in background
{ _load_completion_config } &!

# Optimized zshrc.d file loading with combined cache
ZSHRC_D_COMBINED="$DOTFILES_CACHE/zshrc_d_combined.zsh"

if [[ -f "$ZSHRC_D_COMBINED" && "$ZSHRC_D_COMBINED" -nt "$DOTFILES/zshrc.d" ]]; then
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

# Optimized plugin loading with pre-compiled cache
PLUGIN_CACHE_FILE="$DOTFILES_CACHE/plugins"
PLUGIN_COMBINED_FILE="$DOTFILES_CACHE/plugins_combined.zsh"

# Check if we can use the super-fast combined plugin file  
# Note: Combined file disabled due to dependency issues with functions like command_exists
if false && [[ -f "$PLUGIN_COMBINED_FILE" && "$PLUGIN_COMBINED_FILE" -nt "$DOTFILES/zshrc.plugins" ]]; then
    # Ultra-fast: source single combined file (disabled)
    [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "🚀 Loading combined plugin cache..."
    source "$PLUGIN_COMBINED_FILE"
elif [[ -f "$PLUGIN_CACHE_FILE" && "$PLUGIN_CACHE_FILE" -nt "$DOTFILES/zshrc.plugins" ]]; then
    # Fast: use cached plugin list but create combined file for next time
    [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "📦 Loading plugins from cache..."
    
    # Create combined file in background for next startup
    if [[ ! -f "$PLUGIN_COMBINED_FILE" ]]; then
        {
            echo "# Combined plugin file - auto-generated $(date)" > "$PLUGIN_COMBINED_FILE"
            echo "# Do not edit manually - will be regenerated" >> "$PLUGIN_COMBINED_FILE"
            echo "" >> "$PLUGIN_COMBINED_FILE"
            
            while IFS= read -r plugin_file; do
                if [[ -f "$plugin_file" ]]; then
                    plugin=$(basename "$(dirname "$plugin_file")")
                    plugin_dir=$(dirname "$plugin_file")
                    echo "# --- Plugin: $plugin ---" >> "$PLUGIN_COMBINED_FILE"
                    
                    # Fix relative paths in plugin content
                    sed -e "s|dir=\$(dirname \$0)|dir=\"$plugin_dir\"|g" \
                        -e "s|\${0:A:h}|$plugin_dir|g" \
                        -e "/^0=\${(%):-%N}/d" \
                        "$plugin_file" >> "$PLUGIN_COMBINED_FILE"
                    echo "" >> "$PLUGIN_COMBINED_FILE"
                fi
            done < "$PLUGIN_CACHE_FILE"
        } &!
    fi
    
    # Load plugins normally for this startup
    while IFS= read -r plugin_file; do
        [[ -f "$plugin_file" ]] && source "$plugin_file"
    done < "$PLUGIN_CACHE_FILE"
else
    # Slow: rebuild cache and create combined file
    mkdir -p "$(dirname "$PLUGIN_CACHE_FILE")"
    [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "🔄 Rebuilding plugin cache..."
    
    > "$PLUGIN_CACHE_FILE"  # Clear cache file
    > "$PLUGIN_COMBINED_FILE"  # Clear combined file
    
    # Add header to combined file
    echo "# Combined plugin file - auto-generated $(date)" >> "$PLUGIN_COMBINED_FILE"
    echo "# Do not edit manually - will be regenerated" >> "$PLUGIN_COMBINED_FILE"
    echo "" >> "$PLUGIN_COMBINED_FILE"
    
    for plugin_dir in $DOTFILES/zshrc.plugins/*(/); do
        plugin=${plugin_dir:t}
        plugin_file="$plugin_dir/$plugin.plugin.zsh"
        if [[ -f "$plugin_file" ]]; then
            echo "$plugin_file" >> "$PLUGIN_CACHE_FILE"
            # Add to combined file with path fixes
            echo "# --- Plugin: $plugin ---" >> "$PLUGIN_COMBINED_FILE"
            sed -e "s|dir=\$(dirname \$0)|dir=\"$plugin_dir\"|g" \
                -e "s|\${0:A:h}|$plugin_dir|g" \
                -e "/^0=\${(%):-%N}/d" \
                "$plugin_file" >> "$PLUGIN_COMBINED_FILE"
            echo "" >> "$PLUGIN_COMBINED_FILE"
            source "$plugin_file"
        fi
    done
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
if [[ -n "$DOTFILES_STARTUP_START" ]]; then
    # Single time measurement to minimize overhead
    local end_time=${EPOCHREALTIME}
    
    # Set flag to prevent showing timing on resource calls
    export DOTFILES_STARTUP_TIME="1"
    
    # Display timing breakdown (only for truly interactive shells or when forced)
    if ([[ $- == *i* ]] && [[ -t 0 ]]) || [[ "$FORCE_TIMING_DISPLAY" == "true" ]]; then
        # Calculate timing in background to avoid blocking startup
        {
            # Convert to milliseconds (EPOCHREALTIME is in seconds with decimals)
            local total_time=$(( (end_time - DOTFILES_STARTUP_START) * 1000 ))
            local local_time=${DOTFILES_ZSHRC_LOCAL_TIME:-0}
            local core_time=$((total_time - local_time))
            
            echo
            if [[ $local_time -gt 0 ]]; then
                printf "⚡ Startup: \033[32m%dms\033[0m total (\033[36m%dms\033[0m dotfiles + \033[33m%dms\033[0m local)\n" \
                    "$total_time" "$core_time" "$local_time"
            else
                printf "⚡ Startup: \033[32m%dms\033[0m dotfiles\n" "$core_time"
            fi
            
            # Clean up timing variables in background
            unset DOTFILES_STARTUP_START DOTFILES_ZSHRC_LOCAL_START DOTFILES_ZSHRC_LOCAL_TIME
        } &!
    else
        # Clean up timing variables immediately if not displaying
        unset DOTFILES_STARTUP_START DOTFILES_ZSHRC_LOCAL_START DOTFILES_ZSHRC_LOCAL_TIME
    fi
fi

# Defer exit tasks for interactive shells (saves ~5ms on startup)
if [[ $- == *i* ]]; then
    # Interactive shell - defer exit tasks
    function _load_exit_tasks() {
        unset -f _load_exit_tasks
        source $DOTFILES/zshrc.lib/exit-tasks.zsh
    }
    # Load after a short delay to not block startup
    { sleep 0.1 && _load_exit_tasks } &!
else
    # Non-interactive shell - load normally
    source $DOTFILES/zshrc.lib/exit-tasks.zsh
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
