#!/usr/bin/env bash

# Initially symlinks various files as needed for .dotfiles-harrison to function

# Assume that .dotfiles-harrison is the default location where the repo has been cloned
DEFAULT_DOTFILES_HOME=$HOME/.dotfiles-harrison

# Echos out with color for better visual feedback
# Usage: color_echo red "error message"
color_echo() {
    case $1 in
     red)    color="1;31" ;;
     green)  color="1;32" ;;
     yellow) color="1;33" ;;
     blue)   color="1;34" ;;
     purple) color="1;35" ;;
     cyan)   color="1;36" ;;
     *)      color=$1 ;;
    esac
    shift
    echo -e "\033[${color}m$@\033[0m"
}

# Symlinks a file $DEFAULT_DOTFILES_HOME/<from> $HOME/<to>
# <from> is implicitly relative to $DEFAULT_DOTFILES_HOME
# Uses -f to force overwrite existing symlinks, -v for verbose output
symlink () {
  local from="$1"
  color_echo cyan "🔗 Linking $from"
  ln -s -f -v $DEFAULT_DOTFILES_HOME/$from $HOME/$from
}

echo "────────────────────────────────────"
color_echo purple "📦 Dotfiles Installation"
echo "────────────────────────────────────"

echo
color_echo cyan "🔗 Creating symlinks..."
# Create symlinks for core dotfiles
symlink .zshrc
symlink .vimrc
symlink .vim
symlink .gitconfig
symlink .psqlrc

echo
color_echo cyan "📁 Setting up Neovim config..."
# Create Neovim config directory and symlink our init.lua
mkdir -p ~/.config/nvim
ln -s -f -v $DEFAULT_DOTFILES_HOME/init.lua ~/.config/nvim/init.lua

echo
color_echo cyan "🤖 Setting up Claude config..."
# Create Claude config directory and symlink our CLAUDE.md
mkdir -p ~/.claude
ln -s -f -v $DEFAULT_DOTFILES_HOME/compiled/CLAUDE.md ~/.claude/CLAUDE.md

echo
color_echo cyan "🪝 Merging Claude hooks into ~/.claude/settings.json..."
# Idempotently merge dotfiles hook fragments into the global Claude settings.
# We don't symlink settings.json because Claude writes to it at runtime
# (e.g. permission grants). Instead, we deep-merge our fragment so hook entries
# from dotfiles travel with the repo while per-machine settings stay intact.
hooks_fragment="$DEFAULT_DOTFILES_HOME/claude/settings.hooks.json"
claude_settings="$HOME/.claude/settings.json"
if [[ ! -f "$hooks_fragment" ]]; then
    color_echo yellow "  ⚠️  No hooks fragment at $hooks_fragment, skipping..."
elif ! command -v jq >/dev/null 2>&1; then
    color_echo red "  ❌ jq not installed — cannot merge hooks. Install jq and re-run 'make install'."
else
    [[ -f "$claude_settings" ]] || echo '{}' > "$claude_settings"
    tmp_settings="$(mktemp)"
    # Deep-merge: for each event in the fragment, append any hook blocks that
    # aren't already present (deduped by exact JSON equality).
    if jq --slurpfile frag "$hooks_fragment" '
          . as $base
          | ($frag[0].hooks // {}) as $new
          | reduce ($new | keys[]) as $event (
              $base;
              .hooks[$event] = (((.hooks[$event] // []) + $new[$event]) | unique)
            )
        ' "$claude_settings" > "$tmp_settings"; then
        mv "$tmp_settings" "$claude_settings"
        color_echo green "  ✅ Hooks merged into $claude_settings"
    else
        rm -f "$tmp_settings"
        color_echo red "  ❌ Failed to merge hooks (settings.json left untouched)"
    fi
fi

echo
color_echo cyan "🔧 Verifying Claude hook runtime dependencies..."
missing_deps=()
for dep in jq yq osascript; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        missing_deps+=("$dep")
    fi
done
if [[ ${#missing_deps[@]} -gt 0 ]]; then
    color_echo yellow "  ⚠️  Missing: ${missing_deps[*]} — stop-save-permissions hook will fail until installed"
    color_echo white  "     (osascript ships with macOS; install jq + yq via 'brew install jq yq')"
else
    color_echo green "  ✅ jq, yq, osascript all present"
fi

echo
color_echo cyan "🤖 Setting up Claude commands..."
# Create Claude commands directory and symlink all command files
mkdir -p ~/.claude/commands
if [[ -d $DEFAULT_DOTFILES_HOME/claude/commands ]]; then
    for cmd_file in $DEFAULT_DOTFILES_HOME/claude/commands/*.md; do
        if [[ -f "$cmd_file" ]]; then
            cmd_name=$(basename "$cmd_file")
            color_echo cyan "  🔗 Linking command: $cmd_name"
            ln -s -f -v "$cmd_file" ~/.claude/commands/"$cmd_name"
        fi
    done
else
    color_echo yellow "  ⚠️  No claude/commands directory found, skipping..."
fi

echo
color_echo green "✅ Installation complete!"
color_echo white "   Run 'source ~/.dotfiles-harrison/zshrc' to activate your dotfiles"
