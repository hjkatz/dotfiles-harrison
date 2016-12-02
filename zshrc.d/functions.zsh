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
        if type unp ; then
            unp -U $1
        else
            color_echo yellow "unp missing, falling back..."
            case ${(L)1} in
                *.tar.xz)   tar --extract --verbose --one-top-level --file $1 ;;
                *.tar.bz2)  tar --extract --verbose --one-top-level --file $1 ;;
                *.tar.gz)   tar --extract --verbose --one-top-level --file $1 ;;
                *.tar)      tar --extract --verbose --one-top-level --file $1 ;;
                *.tbz2)     tar --extract --verbose --one-top-level --file $1 ;;
                *.tgz)      tar --extract --verbose --one-top-level --file $1 ;;
                *.jar)      unzip -d $(basename $1)                        $1 ;;
                *.zip)      unzip -d $(basename $1)                        $1 ;;
                *.7z)       7za e -o $(basename $1)                        $1 ;;
                *.(bz2|bz)) bunzip2                                        $1 ;;
                *.gz)       gunzip                                         $1 ;;
                *.rar)      unrar x                                        $1 ;;
                *.z)        uncompress                                     $1 ;;
                *)          color_echo red "Unable to extract '$1' :: Unknown extension"
            esac
        fi
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

# Installs, updates, and manages vim plugins upon load through the file GLOBALS__PLUGIN_LIST_FILE.
#
# Called: `setup_vim_plugins`
function setup_vim_plugins () {
    local plugin_list_file="$DOTFILES/.plugin_list"
    local plugin_list_cmd="cat $DOTFILES/vimrc | grep -P '^\s+Plug\s+' | awk '{print \$2}' | tr -d ','"
    local do_plugin_setup=""

    if [[ ! -f $plugin_list_file ]] ; then
        eval $plugin_list_cmd > $plugin_list_file
        do_plugin_setup="1"
    elif ! eval $plugin_list_cmd | diff -q - $plugin_list_file &>/dev/null ; then
        do_plugin_setup="1"
    fi

    if [[ -n $do_plugin_setup ]] ; then
        color_echo yellow 'Setting up vim plugins...'
        vim -u "$DOTFILES/vimrc" +PlugInstall +PlugUpdate +qall >/dev/null 2>&1

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
