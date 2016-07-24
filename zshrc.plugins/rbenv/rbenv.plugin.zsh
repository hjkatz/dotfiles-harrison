# rbenv plugin from omz, provides:
#   - alias rubies: list ruby versions
#   - alias gemsets: list gemsets
#   - function current_ruby: list current ruby version
#   - function current_gemset: list current gemset active
#   - function gems: list gems installed in current environment
#   - prompt: rbenv_prompt_info

FOUND_RBENV=0
rbenvdirs=("$HOME/.rbenv" "/usr/local/rbenv" "/opt/rbenv" "/usr/local/opt/rbenv")
for rbenvdir in "${rbenvdirs[@]}" ; do
    if [ -d $rbenvdir/bin -a $FOUND_RBENV -eq 0 ] ; then
        FOUND_RBENV=1
        if [[ $RBENV_ROOT = '' ]]; then
            RBENV_ROOT=$rbenvdir
        fi
        export RBENV_ROOT
        export PATH=${rbenvdir}/bin:$PATH
        eval "$(rbenv init --no-rehash - zsh)"

        alias rubies="rbenv versions"
        alias gemsets="rbenv gemset list"

        function current_ruby() {
            echo "$(rbenv version-name)"
        }

        function current_gemset() {
            echo "$(rbenv gemset active 2&>/dev/null | sed -e ":a" -e '$ s/\n/+/gp;N;b a' | head -n1)"
        }

        function gems {
            local rbenv_path=$(rbenv prefix)
            gem list $@ | sed -E \
                -e "s/\([0-9a-z, \.]+( .+)?\)/$fg[blue]&$reset_color/g" \
                -e "s|$(echo $rbenv_path)|$fg[magenta]\$rbenv_path$reset_color|g" \
                -e "s/$current_ruby@global/$fg[yellow]&$reset_color/g" \
                -e "s/$current_ruby$current_gemset$/$fg[green]&$reset_color/g"
        }

        # changed for my own use
        function rbenv_prompt_info() {
            if [[ -n $(current_gemset) ]] ; then
                echo "%{$fg_bold[magenta]%}rbenv:[%{$fg_bold[red]%}$(current_ruby)%{$fg_bold[magenta]%}@%{$fg_bold[green]%}$(current_gemset)%{$fg_bold[magenta]%}]%{$reset_color%}"
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
    function gemsets() { echo 'not supported' }
    function rbenv_prompt_info() { echo "system: $(ruby -v | cut -f-2 -d ' ')" }
fi
