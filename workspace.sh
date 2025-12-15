WORKSPACE=~/workspace
workspace() {
    DIR=${1}
    if [ ! "${DIR}" ]; then
        error "<dir> arg is required"
        return 1
    fi
    cd -P ${WORKSPACE}/${DIR}
    if which conda &>/dev/null; then
        conda deactivate
        ENV_NAMES="${DIR} $(echo ${DIR} | sed 's,/, ,g')"
        for ENV_NAME in $ENV_NAMES; do
            if conda info --envs | awk '{print $1}' | grep -q ^${ENV_NAME}$; then
                conda activate ${ENV_NAME}
                break
            fi
        done
    fi
}

_workspace_completion() {
    find ${WORKSPACE}/ -maxdepth 1 -type d,l | sed 's,^.*/,,g' | grep -v '^$' | grep ^${2}
}
complete -C _workspace_completion workspace


NOTES=~/workspace/notes
notes() {
    local EDIT=false
    local NOTE=""
    while [ "$1" ]; do
        case $1 in
            -e | --edit )
                EDIT=true
                ;;
            * )
                NOTE=$1
                ;;
        esac
        shift
    done
    if [ ! "$NOTE" ]; then
        error "Missing note filename"
        return 1
    fi
    NOTE=$NOTES/$NOTE

    if [ -d $NOTE ]; then
        for FILE in $(ls $NOTE); do
            echo $1/$FILE
        done
    elif [ -f $NOTE ]; then
        if [ "$EDIT" == "true" ]; then
            vim $NOTE
        else
            cat $NOTE
            echo
        fi
    else
        error "\"$NOTE\" not found"
        return 1
    fi
}

_notes_completion() {
    find ${NOTES}/ -maxdepth 1 -type f | sed 's,^.*/,,g' | grep -v '^$' | grep ^${2}
    DIRS=$(find ${NOTES}/ -maxdepth 1 -type d,l | sed 's,^.*/,,g' | grep -v '^$' | grep ^${2})
    for DIR in $DIRS; do
        find ${NOTES}/${DIR}/ -maxdepth 1 -type f | sed 's,^.*/,,g' | grep -v '^$' | grep ^${2} | sed 's,^,'$DIR'/,'
    done
}
complete -C _notes_completion notes