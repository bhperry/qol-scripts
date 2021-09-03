# Add value to PATH if it doesn't already exist
pathadd() {
    DIR=$(realpath $1)
    if [ ! -d "$DIR" ]; then
        warning "$DIR is not a directory"
    elif [[ ":$PATH:" != *":$DIR:"* ]]; then
        export PATH="${PATH:+"$PATH:"}$DIR"
    fi
}

# Me'aliases
alias srcme="source ~/.bashrc"
alias editme="vim ~/.bash_profile"
alias catme="cat ~/.bash_profile"

# alias expansion (allows watch to use other aliases)
alias watch='watch '

hammer() {
    local TIMEOUT=1s
    local COUNT=50
    local DETACH
    local COMMAND
    while [ "$1" ]; do
        case $1 in
            -c | --count )
                shift
                COUNT=$1
                ;;
            -t | --timeout )
                shift
                TIMEOUT=$1
                ;;
            -d | --detach )
                DETACH=true
                ;;
            * )
                COMMAND=$@
                break
                ;;
        esac
        shift
    done
    if [ ! "$COMMAND" ]; then
        echo "Missing command"
        return 1
    fi
    while true; do
        for i in $(seq $COUNT); do
            timeout -k $TIMEOUT $TIMEOUT $COMMAND &
        done
        if [ ! "$DETACH" ]; then
            for PID in $(jobs -p); do
                wait $PID
            done
        fi
    done
}
