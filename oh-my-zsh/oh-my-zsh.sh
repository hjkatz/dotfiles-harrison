# Initializes Oh My Zsh

# add a function path
# fpath=($DOTFILES/oh-my-zsh/functions $DOTFILES/oh-my-zsh/completions $fpath)

# Load all of the config files in ~/oh-my-zsh that end in .zsh
# TIP: Add files you don't want in git to .gitignore
#for config_file ($DOTFILES/oh-my-zsh/lib/*.zsh); do
#  source $config_file
#done

is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.zsh \
    || test -f $base_dir/plugins/$name/_$name
}
# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
    fpath=($DOTFILES/oh-my-zsh/plugins/$plugin $fpath)
done

# Figure out the SHORT hostname
if [ -n "$commands[scutil]" ]; then
  # OS X
  SHORT_HOST=$(scutil --get ComputerName)
else
  SHORT_HOST=${HOST/.*/}
fi

# Save the location of the current completion dump file.
ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# Load and run compinit
autoload -U compinit
compinit -i -d "${ZSH_COMPDUMP}"

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins); do
    source $DOTFILES/oh-my-zsh/plugins/$plugin/$plugin.plugin.zsh
done
