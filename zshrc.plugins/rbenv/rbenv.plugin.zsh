# rbenv plugin from omz (heavily modified/fixed), provides:
#   - alias rubies: list ruby versions
#   - function current_ruby: list current ruby version
#   - prompt: rbenv_prompt_info

FOUND_RBENV=0
rbenvdirs=("$HOME/.rbenv" "/usr/local/rbenv" "/opt/rbenv" "/usr/local/opt/rbenv")
for rbenvdir ($rbenvdirs) ; do
    if [ -d $rbenvdir/shims -a $FOUND_RBENV -eq 0 ] ; then
        FOUND_RBENV=1

        # init - lazy load for performance
        if [[ $PATH != *.rbenv* ]]; then
            # Add rbenv shims to PATH immediately for command detection
            export PATH="$rbenvdir/shims:$PATH"
            
            # Lazy load full rbenv initialization
            _load_rbenv() {
                unfunction ruby gem irb erb ri rdoc testrb rake &>/dev/null
                eval "$(command rbenv init --no-rehash - zsh)"
                export _rbenv_loaded=true
            }
            
            # Create wrapper functions that trigger lazy loading
            for cmd in ruby gem irb erb ri rdoc testrb rake; do
                if ! command -v $cmd &>/dev/null; then
                    eval "$cmd() { _load_rbenv && $cmd \"\$@\"; }"
                fi
            done
        fi

        alias rubies="rbenv versions"

        function current_ruby () {
            echo "$(rbenv version-name)"
        }

        function rbenv_prompt_info () {
            [[ ${GLOBALS__SHOW_PROMPT_HASH[rbenv]} != true ]] && return

            rbenv_version=`rbenv version`
            if echo "$rbenv_version" | grep -q -E '[.](ruby|rbenv)-version' ; then
                echo "%{$FX[bold]$FG[207]%}rbenv:[%{$fg_bold[red]%}$(current_ruby)%{$FX[bold]$FG[207]%}]%{$reset_color%} "
            else
                # don't show system ruby
                #echo "$(current_ruby)"
            fi
        }
    fi
done
unset rbenvdir

if [ $FOUND_RBENV -eq 0 ] ; then
    alias rubies='ruby -v'
    function rbenv_prompt_info() { echo "" }
fi
