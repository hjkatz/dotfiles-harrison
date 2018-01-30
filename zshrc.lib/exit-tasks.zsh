# Exit Tasks for Zshrc

# Echo updated message after sourcing files
if [ $GLOBALS__DOTFILES_UPDATED = true ] ; then
    color_echo green "Updated to $DOTFILES_VERSION"
fi

# Check for extremely long PATH
PATH_LENGTH=`echo $PATH | wc -c`
if [[ $PATH_LENGTH -gt 2000 ]] ; then
    color_echo yellow "Warning: current PATH length exceeds 2000 characters, perhaps it's time to reopen the terminal?"
fi

# setup the vim plugins if needed
setup_vim_plugins

# warn about caution servers
check_for_caution_server

# warn about old dotfiles
if [[ -d "${DOTFILES}-old" ]] ; then
    color_echo red "Found ${DOTFILES}-old, this should be removed!"
fi

# warn about old dotfiles versioning
if find $DOTFILES -maxdepth 1 -type f -name "*.version" 2>/dev/null | grep -q . ; then
    color_echo red "Found old version files; remove $DOTFILES for a clean start!"
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

# ensure the exit code of startup is 0
echo "" >/dev/null 2>&1
