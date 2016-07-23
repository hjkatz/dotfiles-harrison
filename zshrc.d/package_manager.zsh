# Consolidated functions for package managers by distro

# Create the following functions:
#   - install
#   - purge
#   - update
#   - search

# Each of these will call the correct package manager based on the GLOBALS__DISTRO
# that you are currently running.
#
# Called: `<function> <args>`

function install () {
    case "$GLOBALS__DISTRO" in
        ubuntu)
            # fall through
            ;&
        debian)
            sudo apt install "$@"
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
            sudo yum install "$@"
            ;;
        *)
            echo "Distro '$GLOBALS__DISTRO' is unrecognized"
            ;;
    esac
}

function purge () {
    case "$GLOBALS__DISTRO" in
        ubuntu)
            # fall through
            ;&
        debian)
            sudo apt purge "$@"
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
            sudo yum remove "$@"
            ;;
        *)
            echo "Distro '$GLOBALS__DISTRO' is unrecognized"
            ;;
    esac
}

function update () {
    case "$GLOBALS__DISTRO" in
        ubuntu)
            # fall through
            ;&
        debian)
            sudo apt upgrade
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
            sudo yum update
            ;;
        *)
            echo "Distro '$GLOBALS__DISTRO' is unrecognized"
            ;;
    esac
}

function search () {
    case "$GLOBALS__DISTRO" in
        ubuntu)
            # fall through
            ;&
        debian)
            sudo apt search "$@"
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
            sudo yum search "$@"
            ;;
        *)
            echo "Distro '$GLOBALS__DISTRO' is unrecognized"
            ;;
    esac
}
