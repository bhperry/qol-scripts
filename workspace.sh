WORKSPACE=~/workspace
workspace() {
    DIR=${1}
    if [ ! "${DIR}" ]; then
        error "<dir> arg is required"
        return 1
    fi
    cd -P ${WORKSPACE}/${DIR}
    conda deactivate
    if conda info --envs | awk '{print $1}' | grep -q ^${DIR}$; then
        conda activate ${DIR}
    fi
}

_workspace_completion() {
    find ${WORKSPACE}/ -maxdepth 1 -type d,l | sed 's,^.*/,,g' | grep -v '^$' | grep ^${2}
}
complete -C _workspace_completion workspace


NOTES=~/workspace/notes
notes() {
   NOTE=$NOTES/$1
   if [ -d $NOTE ]; then
       for FILE in $(ls $NOTE); do
           echo $1/$FILE
       done
   elif [ -f $NOTE ]; then
       cat $NOTE
       echo
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