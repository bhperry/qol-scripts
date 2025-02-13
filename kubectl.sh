if which kubectl &>/dev/null; then
    # Kubectl
    alias k=kubectl
    alias kcc="kubectl config current-context"
    alias kcn="kubectl config  get-contexts $(kcc) | tail -n +2 | sed 's/.* //'"
    alias ktx="kubectl config use-context"
    alias kgp="kubectl get po"
    alias kns="kubectl config set-context --current --namespace "
    alias kevents="kubectl get events -o custom-columns=FirstSeen:.firstTimestamp,LastSeen:.lastTimestamp,Count:.count,From:.source.component,Type:.type,Reason:.reason,Message:.message"

    complete -F __start_kubectl k
    complete -F _complete_alias ktx
    complete -F _complete_alias kgp
    complete -F _complete_alias kns

    klabels() {
        local VARS="-v NAME=1"
        local PASSTHROUGH
        local FILTER

        while [ $1 ]; do
            case $1 in
                --all-namespaces | -A )
                    VARS="-v NAME=2"
                    PASSTHROUGH+=" $1"
                    ;;
                --filter | -f )
                    shift
                    if [ "$FILTER" ]; then
                        FILTER="$FILTER|$1"
                    else
                        FILTER=$1
                    fi
                    ;;
                * )
                    PASSTHROUGH+=" $1"
                    ;;
            esac
            shift
        done

        _klabels() {
            kubectl get ${PASSTHROUGH:-pods} --show-labels | tail -n +2 | awk $VARS '{print $NAME"\n    "$NF"\n"}' | sed 's/,/\n    /g; s/=/: /g'
        }

        if [ "$FILTER" ]; then
            _klabels | grep -E "$FILTER|^[^ ]*$" --color=never
        else
            _klabels
        fi
    }
fi