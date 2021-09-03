


# Git
alias gc='git commit -am '"${@}"''

git-dir() {
    git rev-parse --show-toplevel
}

gp() {
    set -o pipefail
    local LINT_CMD
    local SKIP_LINT
    while [ "$1" ]; do
        case $1 in
            -s | --skip-lint )
                SKIP_LINT=true
                ;;
            -l | --lint )
                shift
                LINT_CMD="make $1"
                ;;
        esac
        shift
    done

    color "\nCurrent Branch: " ${BLD}${BLU} -n
    echo $(gcb)

    if [ ! "$SKIP_LINT" ]; then
        if ! DIR=$(git-dir); then
            return $?
        fi
        if [ ! "$LINT_CMD" ] && make -C $DIR lint --dry-run &>/dev/null; then
            LINT_CMD="make lint"
        fi
        if [ "$LINT_CMD" ]; then
            echo
            color "      LINT" ${BLD}${GRN}
            color "+---------------" ${BLD}
            if ! $LINT_CMD 2>&1 | sed 's/^/|  /'; then
                color "+---------------" ${BLD}
                color "     ERROR!\n" ${BLD}${RED}
                return 1
            fi
            color "+---------------" ${BLD}
            color "   SUCCESS!\n" ${BLD}${GRN}
        fi
    fi
    set +o pipefail
    if git push 2>&1 | tee /dev/tty | grep -q "git push --set-upstream"; then
        git push --set-upstream origin $(gcb)
    fi
}

_gp_completion() {
    local OPTIONS="-s --skip-lint -l --lint"
    local OPT
    if [[ ${2} == -* ]]; then
        for OPT in $OPTIONS; do
            if [[ ${OPT} == ${2}* ]]; then
                echo ${OPT}
            fi
        done
    else
        PREV=$(echo "${@}" | awk '{print $NF}')
        case $PREV in
            -l | --lint )
                DIR=$(git-dir)
                grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' $DIR/Makefile | grep -v "\.PHONY" | sed 's/[^a-zA-Z0-9_.-]*$//' | grep -v '^$' | grep "^$2"
                return 0
                ;;
        esac
        if [ ! "${2}" ]; then
            echo
            for OPT in $OPTIONS; do
                echo $OPT
            done
        fi
    fi
}
complete -C _gp_completion gp

gcb() {
    git branch | grep '\*' | awk '{print $2}'
}

alias gb="git branch "

gnuke() {
    local DEL="-d"
    while [ "$1" ]; do
        case $1 in
            -d | -D )
                DEL=${1}
                ;;
            * )
                error "Unknown arg \"$1\""
                return 1
                ;;
        esac
        shift
    done
    gb | grep -v '\*' | xargs git branch ${DEL}
    git fetch --prune --all
}
