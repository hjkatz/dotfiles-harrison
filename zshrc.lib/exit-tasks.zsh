# Exit Tasks for Zshrc

# Echo updated message after sourcing files
if [ $GLOBALS__DOTFILES_UPDATED = true ] ; then
    color_echo green "Updated to $DOTFILES_VERSION"
fi

# setup the vim plugins if needed
setup_vim_plugins

# warn about caution servers
check_for_caution_server

# set distro specific completions
# NOTE: Must happen last due to parsing error in _yum case
case "$GLOBALS__DISTRO" in
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
        ;;
    *)
        echo "Distro '$GLOBALS__DISTRO' is unrecognized"
        ;;
esac
