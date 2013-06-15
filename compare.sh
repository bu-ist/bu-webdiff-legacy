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

DIFFERENCES="$FIRST-vs-$SECOND"

if [ ! -d "$DIFFERENCES" ]; then
	printf "Creating '%s' to store difference images\n" $DIFFERENCES
	mkdir $DIFFERENCES
fi

for filename in $FIRST/*.png ; do
	filename=`sed "s|^$FIRST/||" <<< $filename`
	compare "$FIRST/$filename" "$SECOND/$filename" -metric AE "$DIFFERENCES/$filename" > /dev/null 2>&1
	
	if [ $? -eq 0 ]; then
		# printf "Removing %s\n" "$DIFFERENCES/$filename"
		rm "$DIFFERENCES/$filename"
	else
		url=`sed "s/.png$//" <<< $filename`
		url=`sed "s/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g" <<< $url`
		echo -e "$url does not match"
	fi
done
