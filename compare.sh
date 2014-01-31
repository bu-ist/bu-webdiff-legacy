#!/bin/bash

urldecode(){
    echo -e "$(sed 's/+/ /g;s/%\(..\)/\\x/g;')"
}

first=$(cd -P -- "$1" && printf "%s\n" "$(pwd -P)")
second=$(cd -P -- "$2" && printf "%s\n" "$(pwd -P)")

if [ $# -ne 2 ]
then
    printf "Usage: `basename %s` {first directory} {second directory}\n" $0
    printf "Compares the screenshots in the first directory to those in "
    printf "the second.\n"
    exit 1
fi

if [ ! -d "$first" ]; then
    printf "'%s' does not exist\n" $first
    exit 1
fi

if [ ! -d "$second" ]; then
    printf "'%s' does not exist\n" $second
    exit 1
fi

differences=$(printf "%s/%s-vs-%s" "$(dirname -- "$first")" \
    "$(basename -- "$first")" "$(basename -- "$second")")

if [ ! -d "$differences" ]; then
    printf "Creating '%s' to store difference images\n" $differences
    mkdir $differences
fi

for filename in $first/*.png ; do
    filename=`sed "s|^$first/||" <<< $filename`
    compare "$first/$filename" "$second/$filename" -metric AE "$differences/$filename" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        # printf "Removing %s\n" "$differences/$filename"
        rm "$differences/$filename"
    else
        url=`sed "s/.png$//" <<< $filename`
        url=`sed "s/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g" <<< $url`
        echo -e "$url does not match"
    fi
done
