# Various functions

# re-source zshrc profile
function resource () {
    # don't need to check for git updates to the dotfiles repo,
    # we just want to resource the current dotfiles
    local GLOBALS__CHECK_FOR_UPDATES=false
    source $DOTFILES/zshrc
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
        color_echo yellow "Updating git repo..."
        git fetch
        color_echo yellow "Pruning local branches..."
        git branch -vv | grep -E ': (gone|desaparecido)]' | awk '{print $1}' | xargs -r git branch -D
        color_echo green "Done."
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

# Installs, updates, and manages vim plugins upon load.
#
# Called: `setup_vim_plugins`
function setup_vim_plugins () {
    # filepath to the saved plugin list
    local plugin_list_file="$DOTFILES/.plugin_list"

    # command to list the plugins from the init.lua
    local plugin_list_cmd="cat $DOTFILES/init.lua | grep -E '^\s+Plug\s+' | awk '{print \$2}' | tr -d ','"

    # initialize to 'false'
    local do_plugin_setup=""

    # if the plugin list file does not exist
    if [[ ! -f $plugin_list_file ]] ; then
        # then list all the plugins from the vimrc, and put them in the plugin list file
        eval $plugin_list_cmd > $plugin_list_file
        do_plugin_setup="1"
    # else if the plugin list file is different than the plugin list command
    elif ! eval $plugin_list_cmd | diff -q - $plugin_list_file &>/dev/null ; then
        do_plugin_setup="1"
    fi

    # if we should do the plugin setup
    if [[ -n $do_plugin_setup ]] ; then
        color_echo yellow 'Setting up vim plugins...'

        # check if nvim is available
        if ! command_exists nvim; then
            color_echo red 'Error: nvim not found. Please install Neovim.'
            return 1
        fi

        # check if init.lua exists
        if [[ ! -f "$DOTFILES/init.lua" ]]; then
            color_echo red "Error: init.lua not found at $DOTFILES/init.lua"
            return 1
        fi

        # then, install new plugins, update the plugins, then quit vim
        if command nvim --cmd "set runtimepath+=$DOTFILES" -u $DOTFILES/init.lua +PlugInstall +PlugUpdate +MasonUpdate +TSUpdate +qall; then
            # refresh the plugin list file
            eval $plugin_list_cmd > $plugin_list_file
            color_echo green 'Done.'
        else
            color_echo red 'Error: Plugin setup failed. Please check nvim configuration.'
            return 1
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
        color_echo red 'Error: nvim not found. Please install Neovim.'
        return 1
    fi

    # setup plugins if not already done
    if [[ $_setup_vim_plugins_ran != true ]] ; then
        if ! setup_vim_plugins; then
            color_echo red 'Plugin setup failed, launching nvim anyway...'
        fi
    fi

    # launch nvim with error handling
    if [[ -f "$DOTFILES/init.lua" ]]; then
        command nvim --cmd "set runtimepath+=$DOTFILES" -u $DOTFILES/init.lua "$@"
    else
        color_echo yellow "Warning: init.lua not found, launching nvim with default config"
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
