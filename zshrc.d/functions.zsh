# Various functions

# re-source zshrc profile
function resource () {
    # don't need to check for git updates to the dotfiles repo,
    # we just want to resource the current dotfiles
    local GLOBALS__CHECK_FOR_UPDATES=false
    source $DOTFILES/zshrc
}

# echos out with color
#
# Called:
#   `color_echo red "My Error"`
#   `color_echo yellow "My Warning"`
#   `color_echo green "My Success"`
function color_echo () {
    case $1 in
     red)
          color=31
          ;;
     green)
          color=32
          ;;
     yellow)
          color=33
          ;;
     *)
          color=$1
          ;;
    esac

    # remove $1
    shift

    echo -e "\033[1;${color}m$@\033[0m"
}

# Checks to see if the pwd is in a git repo, then calls git fetch
#
# Called: `check_and_update_git_repo`
function check_and_update_git_repo () {
    local GITDIR
    GITDIR="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ "$GITDIR" == "$(pwd)" ]]; then
        # Fetch changes for current branch
        git fetch
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
#
# Called: `extract <file>`
function extract () {
    # usage
    if [[ -z "$1" ]] ; then
        echo "usage: extract <file>"
        echo "       Extract the file based on the extension."
    elif [[ -f "$1" ]] ; then
        case ${(L)1} in
            *.tar.xz)   dir=$(basename -s .tar.xz  $1) && mkdir -p $dir && tar --extract --verbose --directory $dir --file $1 ;;
            *.tar.bz2)  dir=$(basename -s .tar.bz2 $1) && mkdir -p $dir && tar --extract --verbose --directory $dir --file $1 ;;
            *.tar.gz)   dir=$(basename -s .tar.gz  $1) && mkdir -p $dir && tar --extract --verbose --directory $dir --file $1 ;;
            *.tar)      dir=$(basename -s .tar     $1) && mkdir -p $dir && tar --extract --verbose --directory $dir --file $1 ;;
            *.tbz2)     dir=$(basename -s .tbz2    $1) && mkdir -p $dir && tar --extract --verbose --directory $dir --file $1 ;;
            *.tgz)      dir=$(basename -s .tgz     $1) && mkdir -p $dir && tar --extract --verbose --directory $dir --file $1 ;;
            *.jar)      unzip -d $(basename -s .jar $1)                $1 ;;
            *.zip)      unzip -d $(basename -s .zip $1)                $1 ;;
            *.7z)       7za e -o $(basename -s .7z  $1)                $1 ;;
            *.(bz2|bz)) bunzip2                                        $1 ;;
            *.gz)       gunzip                                         $1 ;;
            *.rar)      unrar x                                        $1 ;;
            *.z)        uncompress                                     $1 ;;
            *)          color_echo red "Unable to extract '$1' :: Unknown extension"
        esac
    else
        color_echo red "File '$1' does not exist!"
    fi
}

# loops a command for the specified number of sleep time
# TODO: get this to work
function loop () {
    seconds="$1"
    shift
    command="$@"
    while :
    do
        clear
        $command
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

    # command to list the plugins from the vimrc
    local plugin_list_cmd="cat $DOTFILES/vimrc | grep -P '^\s+Plug\s+' | awk '{print \$2}' | tr -d ','"

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

        # then, install new plugins, update the plugins, then quit vim
        vim -u "$DOTFILES/vimrc" +PlugInstall +PlugUpdate +qall >/dev/null 2>&1

        # refresh the plugin list file
        eval $plugin_list_cmd > $plugin_list_file
        color_echo green 'Done.'
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
