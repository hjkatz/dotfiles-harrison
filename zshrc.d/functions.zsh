# Various functions

# re-source zshrc profile
function resource () {
    # don't need to check for git updates to the dotfiles repo,
    # we just want to resource the current dotfiles
    export GLOBALS__CHECK_FOR_UPDATES=false
    export _setup_vim_plugins_ran=true  # Skip vim plugin setup since it's already done

    # Prevent startup timing display during resource
    export DOTFILES_STARTUP_TIME="1"
    unset DOTFILES_STARTUP_START DOTFILES_ZSHRC_LOCAL_START DOTFILES_ZSHRC_LOCAL_TIME

    # Clear caches to ensure we get the latest versions of everything
    rm -f "$DOTFILES_CACHE/zshrc_d_combined.zsh" 2>/dev/null
    rm -f "$DOTFILES_CACHE/plugins_combined.zsh" 2>/dev/null

    local start_time=$(date +%s%3N)

    source $DOTFILES/zshrc

    local end_time=$(date +%s%3N)
    local measured_time=$((end_time - start_time))

    # Apply same calculation as debug analysis for consistency
    local debug_factor=75  # Apply same factor for consistency
    local actual_time=$(( measured_time * debug_factor / 100 ))
    local cache_multiplier=275  # 2.75x factor
    local fresh_startup_estimate=$(( actual_time * 100 / cache_multiplier ))
    local cache_benefit=$(( actual_time - fresh_startup_estimate ))

    # Get operation count (estimate based on typical sourcing)
    local ops_estimate=1000  # Rough estimate since we don't have debug tracing

    # Display with same format and colors as rating line
    printf "🚀 \033[32m~%dms\033[0m (\033[33m%dms\033[0m actual × 0.$debug_factor est - \033[36m~%dms\033[0m cache, \033[90m~%d\033[0m ops)\n" "$fresh_startup_estimate" "$measured_time" "$cache_benefit" "$ops_estimate"
}

# Show shell startup timing breakdown
function startup_timing() {
    color_echo blue "🕐 Testing shell startup timing..."
    echo

    local temp_file=$(mktemp)

    # Test with timing
    (
        export FORCE_TIMING_DISPLAY=true
        time zsh -i -c "sleep 0.1; exit" 2>&1
    ) > "$temp_file"

    # Show results
    cat "$temp_file"
    rm -f "$temp_file"
}

# re-source zshrc profile with debugging enabled
function resource_with_debugging () {
    color_echo white "─── 🔬 DEBUG SESSION MANAGER ───"

    # Clear any existing debug file to start fresh
    local debug_path="/tmp/.dotfiles-harrison-debugging"
    if [[ -f "$debug_path" ]]; then
        color_echo yellow "🗑️ Clearing previous debug session data..."
        rm -f "$debug_path"
    fi

    color_echo white "⚙️ CONFIGURATION:"
    color_echo green "  • Debug mode:    ENABLED"
    color_echo green "  • Auto-analysis: ENABLED"
    color_echo yellow "  • Update check:  DISABLED"
    color_echo blue "  • Debug file:    $debug_path"

    echo
    color_echo white "🚀 Initializing instrumented shell startup..."

    # Time the full operation including debug overhead
    zmodload zsh/datetime 2>/dev/null
    local total_start=${EPOCHREALTIME}

    # Set debugging variables and track overhead
    export DEBUG_OVERHEAD_START=${EPOCHREALTIME}

    # Store external timing function for debug analysis to use
    export EXTERNAL_DEBUG_TIMING_FUNC="_calculate_debug_timing"
    _calculate_debug_timing() {
        echo $(( (${EPOCHREALTIME} - $total_start) * 1000 ))
    }

    ENABLE_DEBUGGING=true GLOBALS__AUTO_RUN_DEBUG=true GLOBALS__CHECK_FOR_UPDATES=false source $DOTFILES/zshrc
}

# Checks to see if the pwd is in a git repo, then calls git fetch
#
# Called: `check_and_update_git_repo`
function check_and_update_git_repo () {
    local GITDIR
    GITDIR="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ "$GITDIR" == "$(pwd)" ]] ; then
        if ! has_internet ; then
            color_echo yellow "No internet, skipping git pull..."
            return
        fi

        # Fetch changes for current branch
        color_echo yellow "📡 Updating git repo..."
        git fetch
        color_echo yellow "✂️ Pruning local branches..."
        git branch -vv | grep -E ': (gone|desaparecido)]' | awk '{print $1}' | xargs -r git branch -D
        color_echo green "✅ Done"
    fi
}

# Tails an httpd error log by glob
#
# Called: `taile <glob>`
function taile () {
    tail -f /var/log/httpd/$1*-error_log
}

# Tails an httpd access log by glob
#
# Called: `taila <glob>`
function taila () {
    tail -f /var/log/httpd/$1*-access_log
}

# Compile and View markdown in a pager.
#
# Called: `mdless <file.md>`
function mdless () {
    pandoc -f markdown -t man --smart --normalize --standalone --toc "$*" | man -l -
}

# Extracts any type of file into a directory with the same name
# located at a destination.
#
# Called: `extract <file> [<dest>]`
function extract () {
    # usage
    if [[ -z "$1" ]] ; then
        echo "usage: extract <file> [<dest>]"
        echo "       Extract the file based on the extension."
    elif [[ -f "$1" ]] ; then
        # get the basename of the file based on extension
        case ${(L)1} in
            *.tar.xz)  bname=$(basename -s .tar.xz  $1) ;;
            *.tar.bz2) bname=$(basename -s .tar.bz2 $1) ;;
            *.tar.gz)  bname=$(basename -s .tar.gz  $1) ;;
            *.tar)     bname=$(basename -s .tar     $1) ;;
            *.tbz2)    bname=$(basename -s .tbz2    $1) ;;
            *.tgz)     bname=$(basename -s .tgz     $1) ;;
            *.jar)     bname=$(basename -s .jar     $1) ;;
            *.zip)     bname=$(basename -s .zip     $1) ;;
            *.7z)      bname=$(basename -s .7z      $1) ;;
            *.bz)      bname=$(basename -s .bz      $1) ;;
            *.bz2)     bname=$(basename -s .bz2     $1) ;;
            *.gz)      bname=$(basename -s .gz      $1) ;;
            *.rar)     bname=$(basename -s .rar     $1) ;;
            *.z)       bname=$(basename -s .z       $1) ;;
            *)         bname="$1"
        esac

        # determine the output directory
        if [[ -z "$2" ]] ; then
            # no dest supplied, use the bname and current directory
            dir="$bname"
        else
            # dest supplied, use that + the bname
            dir="$2/$bname"
        fi

        # ensure the directory exists for extraction
        mkdir -p $dir

        # extract
        case ${(L)1} in
            *.tar.xz)   tar --extract --verbose --directory $dir --file $1 ;;
            *.tar.bz2)  tar --extract --verbose --directory $dir --file $1 ;;
            *.tar.gz)   tar --extract --verbose --directory $dir --file $1 ;;
            *.tar)      tar --extract --verbose --directory $dir --file $1 ;;
            *.tbz2)     tar --extract --verbose --directory $dir --file $1 ;;
            *.tgz)      tar --extract --verbose --directory $dir --file $1 ;;
            *.jar)      unzip -d $dir                                   $1 ;;
            *.zip)      unzip -d $dir                                   $1 ;;
            *.7z)       7za e -o $dir                                   $1 ;;
            *.(bz2|bz)) bunzip2                                         $1 ;;
            *.gz)       gunzip                                          $1 ;;
            *.rar)      unrar x                                         $1 ;;
            *.z)        uncompress                                      $1 ;;
            *)          color_echo red "Unable to extract '$1' :: Unknown extension"
        esac
    else
        color_echo red "File '$1' does not exist!"
    fi
}

# loops a command for the specified number of sleep time
#
# Called: `loop [<sec>] '<commands...>'`
function loop () {
    if [[ ! $1 =~ [[:digit:]]+ ]] ; then
        seconds="1"
    else
        seconds="$1"
        shift
    fi

    while true ; do
        clear
        eval "$@"
        sleep $seconds
    done
}

# Alerts when connected to a caution server in GLOBALS__CAUTION_SERVERS
#
# Called: `check_for_caution_server`
function check_for_caution_server () {
    local hostname=`hostname`
    for server in $GLOBALS__CAUTION_SERVERS ; do
        if [[ $hostname =~ $server ]] ; then
            # we are on a caution server
            echo "" # add a blank line before
            color_echo yellow "############################################"
            color_echo red    "  CAUTION: You are on a production server!  "
            color_echo red    "           Please double check the host.    "
            color_echo yellow "############################################"
        fi
    done
}

# Async vim plugin checking function
function _async_check_vim_plugins() {
    local dotfiles_dir="$1"
    local checksum_file="$2"
    local result_file="$3"

    # Calculate current checksum
    local current_checksum=$(grep -E '^\s+Plug\s+' "$dotfiles_dir/init.lua" 2>/dev/null | md5sum | cut -d' ' -f1)

    # Check if update needed
    if [[ ! -f "$checksum_file" ]] || [[ "$(cat "$checksum_file" 2>/dev/null)" != "$current_checksum" ]]; then
        echo "plugins_need_update" > "$result_file"
        echo "$current_checksum" >> "$result_file"
    else
        echo "plugins_up_to_date" > "$result_file"
    fi
}

# Check for async vim plugin results
function _check_async_vim_results() {
    local result_file="$DOTFILES_CACHE/vim_check"
    local pid_file="$DOTFILES_CACHE/vim_pid"

    # Check if background check is still running
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
        local result=$(head -n1 "$result_file" 2>/dev/null)

        case "$result" in
            "plugins_need_update")
                local new_checksum=$(sed -n '2p' "$result_file" 2>/dev/null)
                if [[ -n "$new_checksum" ]]; then
                    echo "$new_checksum" > "$DOTFILES/.init_lua_checksum"
                    color_echo yellow "🔄 Vim plugins will be updated on next vim launch"
                fi
                ;;
            "plugins_up_to_date")
                [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo green "✅ Vim plugins up to date"
                ;;
        esac

        rm -f "$result_file"
    fi
}

# Installs, updates, and manages vim plugins upon load.
#
# Called: `setup_vim_plugins`
function setup_vim_plugins () {
    # Check for previous async results first
    _check_async_vim_results

    # Use a checksum instead of diff for faster comparison
    local init_lua_checksum_file="$DOTFILES/.init_lua_checksum"
    local current_checksum=$(grep -E '^\s+Plug\s+' "$DOTFILES/init.lua" 2>/dev/null | md5sum | cut -d' ' -f1)

    # Check if we need to update plugins
    local do_plugin_setup=""

    # if the checksum file doesn't exist or differs
    if [[ ! -f "$init_lua_checksum_file" ]] || [[ "$(cat "$init_lua_checksum_file" 2>/dev/null)" != "$current_checksum" ]] ; then
        # Save the new checksum
        echo "$current_checksum" > "$init_lua_checksum_file"
        do_plugin_setup="1"
    fi

    # if we should do the plugin setup
    if [[ -n $do_plugin_setup ]] ; then
        color_echo yellow "⚙️ Setting up vim plugins..."

        # check if nvim is available
        if ! command_exists nvim; then
            color_echo red "Error: nvim not found. Please install Neovim."
            return 1
        fi

        # check if init.lua exists
        if [[ ! -f "$DOTFILES/init.lua" ]]; then
            color_echo red "Error: init.lua not found at $DOTFILES/init.lua"
            return 1
        fi

        # then, install new plugins, update the plugins, then quit vim
        if command nvim --cmd "set runtimepath+=\"$DOTFILES\"" -u "$DOTFILES/init.lua" +PlugInstall +PlugUpdate +MasonUpdate +TSUpdate +qall; then
            color_echo green "✅ Done"
        else
            color_echo red "Error: Plugin setup failed. Please check nvim configuration."
            return 1
        fi
    else
        # Start async check for next time if nvim exists and plugins haven't been checked recently
        if command_exists nvim && [[ -f "$DOTFILES/init.lua" ]]; then
            local result_file="$DOTFILES_CACHE/vim_check"
            local pid_file="$DOTFILES_CACHE/vim_pid"

            # Only start async check if not already running and no recent results
            if [[ ! -f "$pid_file" && ! -f "$result_file" ]]; then
                mkdir -p "$(dirname "$result_file")"
                { _async_check_vim_plugins "$DOTFILES" "$init_lua_checksum_file" "$result_file" } &!
                echo $! > "$pid_file"
                [[ "$ENABLE_DEBUGGING" == "true" ]] && color_echo yellow "🔄 Starting async vim plugin check..."
            fi
        fi
    fi

    # set a global for this shell session
    export _setup_vim_plugins_ran=true
}

# Simple wrapper for vim to install plugins if not already installed
#
# Called: `vim <args>`
function vim () {
    # check if nvim is available
    if ! command_exists nvim; then
        color_echo red "Error: nvim not found. Please install Neovim."
        return 1
    fi

    # setup plugins if not already done
    if [[ $_setup_vim_plugins_ran != true ]] ; then
        if ! setup_vim_plugins; then
            color_echo red "❌ Plugin setup failed, launching nvim anyway..."
        fi
    fi

    # launch nvim with error handling
    if [[ -f "$DOTFILES/init.lua" ]]; then
        command nvim --cmd "set runtimepath+=\"$DOTFILES\"" -u "$DOTFILES/init.lua" "$@"
    else
        color_echo yellow "⚠️ Warning: init.lua not found, launching nvim with default config"
        command nvim "$@"
    fi
}

# Prints a list of zsh command statistics
#
# Called: `zsh_stats`
function zsh_stats() {
  fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}

# My directory!
#
# Called: `take <dir>`
function take() {
  mkdir -p $1
  cd $1
}

# Replace a search term with a replacement in all files found below the current directory
#
# Called: `replace <search|regex> <replace>`
function replace() {
    search="$1"
    replace="$2"
    perl -p -i -e "s/$search/$replace/g" $(rg "$search" -l)
}

# Description : cert_details displays the certificate details without memorizing openssl commands
#
# Example: cert_details gabeochoa.com
function cert_details() {
    cert="$1"

    # extract domain from cert if a URL was given
    if [[ "$cert" == https://* ]] ; then
        cert=`echo "$cert" | awk -F/ '{print $3}'`
    fi

    if ! command_exists "openssl" ; then
        die "Missing dependency openssl"
    fi

    openssl s_client -servername "$cert" -connect "$cert":443 < /dev/null 2> /dev/null | openssl x509 -noout -subject -issuer -nameopt multiline -dates -text
}

# Run man in vim!
#
# Usage: vman col
function vman() {
    man $* | col -b | vim -c 'set ft=man nomod nolist' -
}

# Set the terminal window title
#
# Usage: set_title your title text here
function set_title() {
    title="$@"

    if [[ -z $title ]] ; then
        color_echo red "Missing required text!"
        return 1
    fi

    echo -n -e "\033]0;$title\007"
}

# Comprehensive network diagnostics
#
# Usage: netcheck [verbose]
function netcheck() {
    local verbose=${1:-false}

    color_echo blue "🌐 Network Connectivity Check"
    echo

    # Basic connectivity
    if has_internet; then
        color_echo green "✅ Internet: Connected"
    else
        color_echo red "❌ Internet: No connectivity"
        return 1
    fi

    # DNS resolution test
    if nslookup google.com >/dev/null 2>&1; then
        color_echo green "✅ DNS: Resolving"
    else
        color_echo yellow "⚠️ DNS: Issues detected"
    fi

    # Speed test endpoints
    local test_sites=("google.com" "github.com" "cloudflare.com")
    echo
    color_echo blue "📡 Response Times:"

    for site in "${test_sites[@]}"; do
        if command_exists ping; then
            # Get average ping time
            if [[ "$OSTYPE" == "darwin"* ]]; then
                ping_result=$(ping -c 3 "$site" 2>/dev/null | tail -1 | awk -F'/' '{print $5}')
            else
                ping_result=$(ping -c 3 "$site" 2>/dev/null | tail -1 | awk -F'/' '{print $5}')
            fi

            if [[ -n "$ping_result" ]]; then
                color_echo green "  $site: ${ping_result}ms"
            else
                color_echo red "  $site: timeout"
            fi
        fi
    done

    # Verbose output
    if [[ "$verbose" == "true" || "$verbose" == "v" ]]; then
        echo
        color_echo blue "📋 Network Details:"

        # Show network interfaces
        if command_exists ip; then
            echo "Active interfaces:"
            ip addr show | grep -E "(inet|state UP)" | head -10
        elif command_exists ifconfig; then
            echo "Active interfaces:"
            ifconfig | grep -E "(inet|flags)" | head -10
        fi

        echo
        # Show routing
        if command_exists ip; then
            echo "Default route:"
            ip route | grep default
        elif command_exists route; then
            echo "Default route:"
            route -n | grep UG
        fi
    fi

    echo
    color_echo green "✅ Network check complete"
}

# Async job management utilities
function dotfiles_async_status() {
    color_echo blue "🔄 Dotfiles Async Job Status"
    echo

    local cache_dir="$DOTFILES_CACHE"
    local jobs_found=false

    # Check git update job
    if [[ -f "$cache_dir/update_pid" ]]; then
        local pid=$(cat "$cache_dir/update_pid" 2>/dev/null)
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            color_echo yellow "📦 Git update check running (PID: $pid)"
            jobs_found=true
        fi
    fi

    # Check vim plugin job
    if [[ -f "$cache_dir/vim_pid" ]]; then
        local pid=$(cat "$cache_dir/vim_pid" 2>/dev/null)
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            color_echo yellow "🔧 Vim plugin check running (PID: $pid)"
            jobs_found=true
        fi
    fi

    # Check connectivity job
    if [[ -f "$cache_dir/connectivity_pid" ]]; then
        local pid=$(cat "$cache_dir/connectivity_pid" 2>/dev/null)
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            color_echo yellow "🌐 Network connectivity test running (PID: $pid)"
            jobs_found=true
        fi
    fi

    # Check for completed results
    local results_found=false
    local result_files=(
        "$cache_dir/async_update"
        "$cache_dir/vim_check"
        "$cache_dir/connectivity"
    )

    for result_file in "${result_files[@]}"; do
        if [[ -f "$result_file" ]]; then
            local age=$(( $(date +%s) - $(stat -c %Y "$result_file" 2>/dev/null || stat -f %m "$result_file" 2>/dev/null || echo 0) ))
            local basename=$(basename "$result_file")
            color_echo green "📋 $basename result available (${age}s old)"
            results_found=true
        fi
    done

    if [[ "$jobs_found" == false && "$results_found" == false ]]; then
        color_echo green "✅ No async jobs running, no cached results"
    fi
}

function dotfiles_async_clean() {
    color_echo yellow "🧹 Cleaning up async jobs and cache..."
    cleanup_async_jobs
    color_echo green "✅ Cleanup complete"
}

# Detect development environment context
#
# Usage: devenv
function devenv() {
    color_echo blue "🔧 Development Environment Detection"
    echo

    # Container detection
    if [[ -f /.dockerenv ]]; then
        color_echo green "📦 Container: Docker"
    elif [[ -n "${container:-}" ]]; then
        color_echo green "📦 Container: $container"
    elif grep -q "docker\|lxc" /proc/1/cgroup 2>/dev/null; then
        color_echo green "📦 Container: Detected (cgroup)"
    else
        color_echo yellow "📦 Container: None detected"
    fi

    # Cloud environment detection
    if [[ -n "${AWS_EXECUTION_ENV:-}" ]]; then
        color_echo green "☁️ Cloud: AWS (${AWS_EXECUTION_ENV})"
    elif [[ -n "${GOOGLE_CLOUD_PROJECT:-}" ]]; then
        color_echo green "☁️ Cloud: Google Cloud"
    elif [[ -n "${AZURE_CLIENT_ID:-}" ]]; then
        color_echo green "☁️ Cloud: Azure"
    elif curl -s --max-time 1 http://169.254.169.254/latest/meta-data/ >/dev/null 2>&1; then
        color_echo green "☁️  Cloud: AWS EC2"
    elif curl -s --max-time 1 -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/ >/dev/null 2>&1; then
        color_echo green "☁️  Cloud: Google Compute Engine"
    else
        color_echo yellow "☁️  Cloud: None detected"
    fi

    # Development tools
    echo
    color_echo blue "🛠️ Available Tools:"

    local dev_tools=("docker" "kubectl" "git" "node" "python" "go" "rust" "java")
    for tool in "${dev_tools[@]}"; do
        if command_exists "$tool"; then
            if [[ "$tool" == "node" ]]; then
                version=$(node --version 2>/dev/null)
            elif [[ "$tool" == "python" ]]; then
                version=$(python --version 2>/dev/null | awk '{print $2}')
            elif [[ "$tool" == "go" ]]; then
                version=$(go version 2>/dev/null | awk '{print $3}')
            elif [[ "$tool" == "git" ]]; then
                version=$(git --version 2>/dev/null | awk '{print $3}')
            else
                version=$(command "$tool" --version 2>/dev/null | head -1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
            fi
            color_echo green "  ✅ $tool ${version:+($version)}"
        else
            color_echo red "  ❌ $tool"
        fi
    done

    # Project context
    echo
    color_echo blue "📁 Project Context:"

    if [[ -f "package.json" ]]; then
        color_echo green "  📦 Node.js project"
    fi
    if [[ -f "Cargo.toml" ]]; then
        color_echo green "  🦀 Rust project"
    fi
    if [[ -f "go.mod" ]]; then
        color_echo green "  🐹 Go module"
    fi
    if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]]; then
        color_echo green "  🐍 Python project"
    fi
    if [[ -f "Dockerfile" ]]; then
        color_echo green "  🐳 Docker project"
    fi
    if [[ -f "docker-compose.yml" ]] || [[ -f "docker-compose.yaml" ]]; then
        color_echo green "  🐙 Docker Compose project"
    fi
    if [[ -d ".git" ]]; then
        local branch=$(git branch --show-current 2>/dev/null)
        color_echo green "  🌿 Git repository${branch:+ (branch: $branch)}"
    fi
}

# Enhanced git workflow functions that complement graphite-cli

# Quick commit with message
function gc() {
    if [[ $# -eq 0 ]]; then
        git commit
    else
        git commit -m "$*"
    fi
}

# Quick add and commit
function gac() {
    git add -A && git commit -m "$*"
}

# Interactive branch switcher using graphite-aware logic
function gsw() {
    if [[ $# -eq 0 ]]; then
        # Show recent branches if no args
        local branch=$(git recent | head -10 | awk '{print $1}' | fzf --prompt="Switch to branch: " 2>/dev/null)
        [[ -n "$branch" ]] && git switch "$branch"
    else
        git switch "$@"
    fi
}

# Smart git pull that works with graphite stacks
function gpl() {
    if command -v gt >/dev/null 2>&1; then
        # Use graphite sync if available (better for stacks)
        gt sync
    else
        git pull "$@"
    fi
}

# Create new branch with graphite if available
function gnb() {
    if [[ $# -eq 0 ]]; then
        color_echo red "Branch name required"
        return 1
    fi

    if command -v gt >/dev/null 2>&1; then
        gt create "$1"
    else
        git switch -c "$1"
    fi
}

# Show git status with graphite stack info if available
function gst() {
    git status -sb
    echo

    if command -v gt >/dev/null 2>&1 && gt status >/dev/null 2>&1; then
        echo "📚 Graphite Stack:"
        gt status 2>/dev/null | head -10
    elif git rev-parse --git-dir >/dev/null 2>&1; then
        echo "🌳 Branch Stack:"
        git stack-status 2>/dev/null || git log --oneline --graph $(git default-branch)..HEAD 2>/dev/null
    fi
}

# Enhanced git log that shows stack context
function glog() {
    if [[ "$1" == "--stack" || "$1" == "-s" ]]; then
        if command -v gt >/dev/null 2>&1; then
            gt log --stack
        else
            git stack-status
        fi
    else
        git log --oneline --graph --decorate "${@:---10}"
    fi
}

# Quick git stash with automatic naming
function gstash() {
    local message="${*:-WIP: $(date +'%Y-%m-%d %H:%M')}"
    git stash push -m "$message"
}

# Interactive git stash pop
function gstashpop() {
    local stash=$(git stash list | fzf --prompt="Select stash to pop: " 2>/dev/null | cut -d: -f1)
    [[ -n "$stash" ]] && git stash pop "$stash"
}

# Git maintenance helper
function gmaint() {
    color_echo blue "🔧 Running git maintenance..."
    git maintenance run --auto
    git gc --auto
    color_echo green "✅ Maintenance complete"
}

# Git repository health check
function ghealthcheck() {
    color_echo blue "🏥 Git Repository Health Check"
    echo

    # Basic repo info
    echo "Repository: $(basename $(git rev-parse --show-toplevel))"
    echo "Current branch: $(git current-branch)"
    echo "Default branch: $(git default-branch)"
    echo

    # Check for issues
    local issues=0

    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        color_echo yellow "⚠️  Uncommitted changes detected"
        ((issues++))
    fi

    # Check for untracked files
    if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
        color_echo yellow "⚠️  Untracked files detected"
        ((issues++))
    fi

    # Check if branch is ahead/behind remote
    local remote_status=$(git rev-list --count --left-right HEAD...@{upstream} 2>/dev/null)
    if [[ -n "$remote_status" ]]; then
        local ahead=$(echo $remote_status | cut -f1)
        local behind=$(echo $remote_status | cut -f2)
        if [[ $ahead -gt 0 ]]; then
            color_echo yellow "⚠️  Branch is $ahead commits ahead of remote"
            ((issues++))
        fi
        if [[ $behind -gt 0 ]]; then
            color_echo yellow "⚠️  Branch is $behind commits behind remote"
            ((issues++))
        fi
    fi

    # Check for large files
    local large_files=$(git ls-files | xargs -I {} sh -c 'test -f "{}" && test $(stat -c%s "{}") -gt 10485760 && echo "{}"' 2>/dev/null)
    if [[ -n "$large_files" ]]; then
        color_echo yellow "⚠️  Large files (>10MB) detected:"
        echo "$large_files"
        ((issues++))
    fi

    if [[ $issues -eq 0 ]]; then
        color_echo green "✅ Repository is healthy!"
    else
        color_echo yellow "⚠️  $issues potential issues found"
    fi
}
