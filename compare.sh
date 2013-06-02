#!/bin/bash

urldecode(){
  echo -e "$(sed 's/+/ /g;s/%\(..\)/\\x/g;')"
}

FIRST="$1"
SECOND="$2"

if [ $# -ne 2 ]
then
	printf "Usage: `basename %s` {first directory} {second directory}\n" $0
	printf "Compares the screenshots in the first directory to those in "
	printf "the second.\n"
 	exit 1
fi

if [ ! -d "$FIRST" ]; then
	printf "'%s' does not exist\n" $FIRST
	exit 1
fi

if [ ! -d "$SECOND" ]; then
	printf "'%s' does not exist\n" $SECOND
	exit 1
fi

DIFFPNG="difference.$FIRST.png"

for filename in $FIRST/*.png ; do
	filename=`sed "s|^$FIRST/||" <<< $filename`
	compare "$FIRST/$filename" "$SECOND/$filename" -metric AE "$DIFFPNG" > /dev/null 2>&1
	
	if [ "$?" -ne "0" ]; then
		url=`sed "s/.png$//" <<< $filename`
		url=`sed "s/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g" <<< $url`
		echo -e "$url does not match"
		cp $DIFFPNG $filename
	fi
done

rm $DIFFPNG