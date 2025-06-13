# Main Zshrc that loads all other parts of the dotfiles

# prints debugging info (preserve if already set by resource_with_debugging)
ENABLE_DEBUGGING=${ENABLE_DEBUGGING:-false}

# Where the dotfiles are located to load
export DOTFILES=$HOME/.dotfiles-harrison

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
    source $HOME/.zshrc_local
fi

# source the templater
source $DOTFILES/zshrc.lib/templater.zsh

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

# turn on the completion engine
# Speeds up load time
# Perform compinit only once a day.
autoload -Uz compinit
if [[ -n $ZSH_COMPDUMP(#qN.mh+24) ]] ; then
  color_echo yellow "Initializing Completions..."
  compinit -i -d $ZSH_COMPDUMP
  compdump
else
  compinit -C -d $ZSH_COMPDUMP
fi

# turn on bash completions too
autoload bashcompinit
bashcompinit

# source bash completions (only if they exist)
if [[ -d "$GLOBALS__DOTFILES_COMPLETIONS_PATH.bash" && -n "$(echo $GLOBALS__DOTFILES_COMPLETIONS_PATH.bash/*(.N))" ]]; then
    for file in $GLOBALS__DOTFILES_COMPLETIONS_PATH.bash/* ; do
        source $file
    done
fi

# source completion config
source $DOTFILES/zshrc.lib/completions.zsh

# source zshrc.d files
for file in $DOTFILES/zshrc.d/* ; do
    source $file
done

# add omz compatible functions to the fpath
for plugin in $DOTFILES/zshrc.plugins/* ; do
    fpath+=( $plugin )
done
export fpath

# source omz compatible plugins
# Cache plugin paths for faster loading
PLUGIN_CACHE_FILE="$HOME/.cache/dotfiles_plugins"
if [[ -f "$PLUGIN_CACHE_FILE" && "$PLUGIN_CACHE_FILE" -nt "$DOTFILES/zshrc.plugins" ]]; then
    # Use cached plugin list
    [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "📦 Loading plugins from cache..."
    while IFS= read -r plugin_file; do
        [[ -f "$plugin_file" ]] && source "$plugin_file"
    done < "$PLUGIN_CACHE_FILE"
else
    # Create cache directory if it doesn't exist
    mkdir -p "$(dirname "$PLUGIN_CACHE_FILE")"
    # Build and cache plugin list
    [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "🔄 Rebuilding plugin cache..."
    > "$PLUGIN_CACHE_FILE"  # Clear cache file
    for plugin_dir in $DOTFILES/zshrc.plugins/*(/); do
        plugin=${plugin_dir:t}  # Get basename using zsh parameter expansion
        plugin_file="$plugin_dir/$plugin.plugin.zsh"
        if [[ -f "$plugin_file" ]]; then
            echo "$plugin_file" >> "$PLUGIN_CACHE_FILE"
            source "$plugin_file"
        fi
    done
fi

# source zsh syntax highlighting settings
source $DOTFILES/zshrc.lib/syntax-highlighting-settings.zsh

# source the prompt
source $DOTFILES/zshrc.lib/prompt.zsh

# source all exit tasks
source $DOTFILES/zshrc.lib/exit-tasks.zsh

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
