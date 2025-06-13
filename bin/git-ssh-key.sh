#!/bin/bash

# Smart SSH key selection for git signing based on repository context
#
# See: https://calebhearth.com/sign-git-with-ssh

# Must be returned in the format `key::<key>`

# Echos out with color (minimal version for this script)
# Output goes to stderr so it doesn't interfere with the key output
color_echo() {
    case $1 in
     red)    color="1;31" ;;
     green)  color="1;32" ;;
     blue)   color="1;34" ;;
     yellow) color="1;33" ;;
     *)      color=$1 ;;
    esac
    shift
    echo -e "\033[${color}m$@\033[0m" >&2
}

# Function to get repository context
get_repo_context() {
    local repo_url=""
    local repo_org=""
    local repo_host=""

    # Try to get repository URL from git config
    if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
        repo_url=$(git config --get remote.origin.url 2>/dev/null)
        if [[ -n "$repo_url" ]]; then
            # Extract host and organization from URL
            if [[ "$repo_url" =~ github\.com[:/]([^/]+) ]]; then
                repo_host="github.com"
                repo_org="${BASH_REMATCH[1]}"
            elif [[ "$repo_url" =~ ([^@/:]+)[:/]([^/]+) ]]; then
                repo_host="${BASH_REMATCH[1]}"
                repo_org="${BASH_REMATCH[2]}"
            fi
        fi
    fi

    echo "$repo_host|$repo_org|$repo_url"
}

# Function to select best SSH key based on context
select_ssh_key() {
    local repo_info="$1"
    local repo_host=$(echo "$repo_info" | cut -d'|' -f1)
    local repo_org=$(echo "$repo_info" | cut -d'|' -f2)
    local repo_url=$(echo "$repo_info" | cut -d'|' -f3)

    # Get all available keys from agent
    local all_keys=$(ssh-add -L 2>/dev/null)
    if [[ $? != 0 || -z "$all_keys" ]]; then
        color_echo red "❌ No SSH keys found in agent" >&2
        return 1
    fi

    local selected_key=""
    local selection_reason=""

    # Strategy 1: Look for organization-specific keys (e.g., ramp, ngrok, etc.)
    if [[ -n "$repo_org" ]]; then
        case "$repo_org" in
            "ramp"|"ramp-github.com")
                selected_key=$(echo "$all_keys" | grep -i "ramp\|work" | head -n1)
                [[ -n "$selected_key" ]] && selection_reason="organization-specific key for $repo_org"
                ;;
            "ngrok"|"ngrok-private"|"ngrok-oss")
                selected_key=$(echo "$all_keys" | grep -i "ngrok\|work" | head -n1)
                [[ -n "$selected_key" ]] && selection_reason="organization-specific key for $repo_org"
                ;;
            "hjkatz")
                selected_key=$(echo "$all_keys" | grep -i "personal\|hjkatz" | head -n1)
                [[ -n "$selected_key" ]] && selection_reason="personal key for $repo_org"
                ;;
        esac
    fi

    # Strategy 2: Look for host-specific keys
    if [[ -z "$selected_key" && -n "$repo_host" ]]; then
        case "$repo_host" in
            "github.com")
                selected_key=$(echo "$all_keys" | grep -i "github\|personal" | head -n1)
                [[ -n "$selected_key" ]] && selection_reason="GitHub-specific key"
                ;;
        esac
    fi

    # Strategy 3: Look for Yubikey if available (hardware security)
    if [[ -z "$selected_key" ]]; then
        selected_key=$(echo "$all_keys" | grep -i "yubikey\|cardno" | head -n1)
        [[ -n "$selected_key" ]] && selection_reason="Yubikey hardware key"
    fi

    # Strategy 4: Use the first available key as fallback
    if [[ -z "$selected_key" ]]; then
        selected_key=$(echo "$all_keys" | head -n1)
        [[ -n "$selected_key" ]] && selection_reason="default first key"
    fi

    if [[ -n "$selected_key" ]]; then
        color_echo green "✅ Selected SSH key: $selection_reason" >&2
        if [[ -n "$repo_url" ]]; then
            color_echo blue "🏢 Repository: $repo_url" >&2
        fi
        echo "$selected_key"
        return 0
    else
        color_echo red "❌ No suitable SSH key found" >&2
        return 1
    fi
}

# Main execution
color_echo blue "🔑 Smart SSH key selection for git signing..." >&2

# Get repository context
repo_context=$(get_repo_context)
color_echo blue "🔍 Analyzing repository context..." >&2

# Select the best key
selected_key=$(select_ssh_key "$repo_context")
if [[ $? == 0 && -n "$selected_key" ]]; then
    # Output the key in the required format for git signing
    echo "key::$selected_key"
else
    color_echo red "❌ Failed to select SSH key" >&2
    exit 1
fi
