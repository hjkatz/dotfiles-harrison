#### ALIASES / FUNCTIONS ####

command_exists "kubectl" || return

alias kb="kubectl "
alias kube="kubectl "

# set completion
compdef kb=kubectl
compdef kube=kubectl

function kctx () {
    # no args, print contexts
    if [[ "$#" == 0 ]] ; then
        kubectl config get-contexts
    else
        kubectl config use-context "$@"
    fi
}

#### PROMPT ####
# configure:
#   - ZSH_THEME_KUBECTL_PREFIX            : prefix for prompt
#   - ZSH_THEME_KUBECTL_SUFFIX            : suffix for prompt
#   - ZSH_THEME_KUBECTL_SEPARATOR         : separator between context and namespace
#   - ZSH_THEME_KUBECTL_SHOW_NAMESPACE    : show the namespace or note
#   - ZSH_THEME_KUBECTL_DEFAULT_NAMESPACE : what the default namespace should be (if empty, then no separator will be shown)
#   - ZSH_THEME_KUBECTL_KUBECONFIG        : path to your kube config

# defaults
ZSH_THEME_KUBECTL_PREFIX="{"
ZSH_THEME_KUBECTL_SUFFIX="}"
ZSH_THEME_KUBECTL_SEPARATOR="/"
ZSH_THEME_KUBECTL_SHOW_NAMESPACE=true
ZSH_THEME_KUBECTL_DEFAULT_NAMESPACE=""
ZSH_THEME_KUBECTL_KUBECONFIG="$HOME/.kube/config"

# show the prompt information
function kubectl_prompt_info () {
    [[ $GLOBALS__SHOW_PROMPT_HASH[kubectl] != true ]] && return

    _get_kubectl_prompt
    echo "${ZSH_THEME_KUBECTL_PREFIX}${ZSH_KUBECTL_PROMPT}${ZSH_THEME_KUBECTL_SUFFIX}"
}

# gather info and build the kubectl prompt var
function _get_kubectl_prompt() {
    # try out the provided kubeconfig or default to the environment
    kubeconfig="$ZSH_THEME_KUBECTL_KUBECONFIG"
    if [[ -n "$KUBECONFIG" ]]; then
        kubeconfig="$KUBECONFIG"
    fi

    if ! [[ -r $kubeconfig ]] ; then
        ZSH_KUBECTL_PROMPT="kubeconfig missing!!"
        return 1
    fi

    if ! context="$(kubectl config current-context 2>/dev/null)" ; then
        ZSH_KUBECTL_PROMPT="current-context is not set!!"
        return 1
    fi

    if [[ $ZSH_THEME_KUBECTL_SHOW_NAMESPACE != true ]] ; then
        # empty namespace if we shouldn't show one
        namespace=""
    else
        namespace="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.namespace}")"

        if [[ -z $namespace ]] ; then
            namespace="$ZSH_THEME_KUBECTL_DEFAULT_NAMESPACE"
        fi
    fi

    # if we have a namespace, show it and the separator
    if [[ -n $namespace ]] ; then
        ZSH_KUBECTL_PROMPT="${context}${ZSH_THEME_KUBECTL_SEPARATOR}${namespace}"
    else # don't
        ZSH_KUBECTL_PROMPT="${context}"
    fi

    return 0
}
