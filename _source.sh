DIR=$( dirname "${BASH_SOURCE[0]}" )

source $DIR/.env
PYTHON_INSTALL_PATH=${PYTHON_INSTALL_PATH:-/usr/local/bin/}

for FILE in $(ls $DIR | grep ".sh" | grep -v "_source\.sh"); do
    source $DIR/$FILE
done
