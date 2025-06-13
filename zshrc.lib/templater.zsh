# templater for various dotfiles

# env variables will replace {{template_var}} in files
# current template engine is custom and based on perl -p -i -e
function compile_file () {
    file="$1"

    if [[ ! -d $GLOBALS__DOTFILES_TEMPLATES_PATH ]] ; then
        color_echo red "Unable to find templates path! Please \`export GLOBALS__DOTFILES_TEMPLATES_PATH=\"\$DOTFILES/path/to/templates/\"\`."
        return 1
    fi

    if [[ ! -d $GLOBALS__DOTFILES_COMPILED_PATH ]] ; then
        mkdir $GLOBALS__DOTFILES_COMPILED_PATH
    fi

    template="$GLOBALS__DOTFILES_TEMPLATES_PATH/$file.template"
    compiled="$GLOBALS__DOTFILES_COMPILED_PATH/$file"

    if [[ ! -f $template ]] ; then
        color_echo red "Unable to find template '$template'!"
        return 1
    fi

    # copy and overwrite template to compiled
    \cp -f "$template" "$compiled"

    # replace templated vars in the "compiled" file

    # first, get the list of vars from the file
    vars=$(cat "$compiled" | \
           \grep -o -E "{{\w+}}" | \
           \grep -o -E "\w+" | \
           tr "\n" " " ) # replace newlines with spaces to use in loop below

    # for each var, replace it in the file
    for var in $(echo ${vars[@]}) ; do # please ignore this echo hack
        perl -p -i -e "s;\Q{{$var}}\E;q{${(P)var}};e" $compiled
    done

    # all done!
}

# compile some templates
compile_file gitconfig
# Note: nvimrc template compilation removed - using init.lua directly now
