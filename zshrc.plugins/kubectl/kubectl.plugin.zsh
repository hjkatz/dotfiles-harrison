#### ALIASES / FUNCTIONS ####

command_exists "kubectl" || return

alias kb="kubectl "
alias kube="kubectl "
alias kctx="kubectx "
alias kns="kubens "

alias -g kall="all,configmaps,deployments.apps,servicemonitors,secrets"

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
