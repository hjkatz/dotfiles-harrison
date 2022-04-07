#### ALIASES / FUNCTIONS ####

command_exists "kubectl" || return

# kube-ps1 local sourcing
function kube_ps1_cluster_function () {
    cluster="$1"

    # flag prod clusters
    if [[ $cluster == *prod* ]] ; then
        echo "%{$fg_bold[red]%}$cluster%{$reset_color%}"
    else
        echo "$cluster"
    fi

    # unreachable
}
export KUBE_PS1_PREFIX="{"
export KUBE_PS1_SUFFIX="} "
export KUBE_PS1_SYMBOL_ENABLE=false
export KUBE_PS1_DIVIDER="/"
export KUBE_PS1_CTX_COLOR=cyan
export KUBE_PS1_NS_COLOR=cyan
export KUBE_PS1_CLUSTER_FUNCTION=kube_ps1_cluster_function

dir=$(dirname $0)
source $dir/kube_ps1.sh

alias kb="kubectl "
alias kube="kubectl "
alias kctx="kubectx "
alias kns="kubens "

alias -g kall="all,configmaps,deployments.apps,servicemonitors,secrets,limits,resourcequotas,poddisruptionbudgets,jobs,deployments,cronjobs,statefulsets,serviceaccounts,rolebindings,persistentvolumeclaims"

# add kubectl completion
source <(kubectl completion zsh)
# lazy load the completions
# function kubectl() {
#     if ! type __start_kubectl >/dev/null 2>&1; then
#         source <(command kubectl completion zsh)
#     fi

#     command kubectl "$@"
# }

# set completion
compdef kb=kubectl
compdef kube=kubectl

# kubectx config
export KUBECTX_CURRENT_FGCOLOR=$(tput setaf 6) # blue text
export KUBECTX_CURRENT_BGCOLOR=$(tput setaf 7) # white background

# show the prompt information
function kubectl_prompt_info () {
    [[ $GLOBALS__SHOW_PROMPT_HASH[kubectl] != true ]] && return

    echo "$(kube_ps1)"
}

function kb_get_all () {
    declare -a custom_resources=(`kubectl get crd --no-headers | awk '{print $1}' | cut -d. -f1 | tr '\n' ' '`)
    declare -a resources=(
        configmaps
        cronjobs
        daemonsets
        deployments
        endpoints
        events
        horizontalpodautoscalers
        ingresses
        jobs
        namespaces
        networkpolicies
        nodes
        persistentvolumeclaims
        persistentvolumes
        poddisruptionbudgets
        podpreset
        pods
        podsecuritypolicies
        podtemplates
        replicasets
        resourcequotas
        rolebindings
        roles
        secrets
        serviceaccounts
        services
        statefulsets
    )

    for resource in ${resources[@]} ${custom_resources[@]} ; do
        result=`kubectl get $@ $resource 2>/dev/null`

        echo Resource: $resource
        if ! echo "$result" | grep -q "No resources found." ; then
            echo "$result"
        fi
        echo ""
    done
}

function kb_get_labels () {
    declare -a custom_resources=(`kubectl get crd --no-headers | awk '{print $1}' | cut -d. -f1 | tr '\n' ' '`)
    declare -a resources=(
        configmaps
        cronjobs
        daemonsets
        deployments
        endpoints
        events
        horizontalpodautoscalers
        ingresses
        jobs
        namespaces
        networkpolicies
        nodes
        persistentvolumeclaims
        persistentvolumes
        poddisruptionbudgets
        podpreset
        pods
        podsecuritypolicies
        podtemplates
        replicasets
        resourcequotas
        rolebindings
        roles
        secrets
        serviceaccounts
        services
        statefulsets
    )

    declare -a labels=()
    for resource in ${resources[@]} ${custom_resources[@]} ; do
        labels+=(`kubectl get $resource --show-labels --no-headers 2>/dev/null | awk '{print $NF}' | perl -p -e "s/\Q<none>\E$//" | tr ',' ' ' | tr '\n' ' '`)
    done

    echo "$labels" | tr ' ' '\n' | sort | uniq
}

function kb_get_env () {
    pod="$1"
    kubectl exec -it "$pod" env | grep -E -v "(PORT|HOST|HOME|PATH|TERM|JAVA_OPTS)" | sed 's///g' | perl -p -e "s/(\w+)=(.*)/export \1='\2'/"
}
