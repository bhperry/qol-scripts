DIR=$( dirname "${BASH_SOURCE[0]}" )

for FILE in $(ls $DIR | grep ".sh" | grep -v "_source\.sh"); do
    source $DIR/$FILE
done