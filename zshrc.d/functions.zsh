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
