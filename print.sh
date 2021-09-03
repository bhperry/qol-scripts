declare -A TEXT_STYLES=(
    [END]=0
    [BLD]=1
    [DIM]=2
    [ITL]=3
    [UND]=4
    [BNK]=5
    [REV]=7
    [INV]=8
    [BLK]=30
    [RED]=31
    [GRN]=32
    [YLW]=33
    [BLU]=34
    [PRP]=35
    [CYN]=36
    [WHT]=37
    [END]=0
)

for STYLE in ${!TEXT_STYLES[@]}; do
    declare ${STYLE}="\033[${TEXT_STYLES[$STYLE]}m"
done

color() {
    local MESSAGE=$1
    local COLOR=$2
    local OPTS=$3
    echo -e $OPTS "${COLOR}${MESSAGE}${END}"
}

error() {
    color "ERROR" $BLD$RED -n
    echo -e ": ${@}"
    return 1
}

warning() {
    color "WARNING" $BLD$YLW -n
    echo -e ": ${@}"
}
